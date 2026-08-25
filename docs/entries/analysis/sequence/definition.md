---
id: analysis.sequence.definition
family: analysis.sequence
variant: ecnu
kind: definition
state: verified
title: 数列收敛的 ε-N 定义
summary: SequenceConvergesTo u l 以 ε-N 量词定义，并与 Tendsto u atTop (𝓝 l) 等价
premises: []
mathlib: [Metric.tendsto_atTop, Real.dist_eq]
provenance:
  source_type: book
  ref: "ecnu-mathematical-analysis-5"
---

# 动机

极限不能用不存在的“第无穷项”定义，而必须把“最终趋势”翻译成有限下标之后可检查的承诺。
若直接把 Mathlib 的滤子谓词 `Tendsto` 当作本库定义，教材最核心的 ε-N 量词结构会被隐藏。
因此本条先建立本库谓词，再把滤子语言放到等价桥中。

# 直觉

`u` 收敛到 `l` 的意思是：无论考核尺度 `ε` 多小，只要 `ε>0`，总能找到一个起点 `N`，
使所有 `n≥N` 的项都落在 `l` 的 ε-邻域内。`N` 可以依赖于 `ε`，但不能依赖于随后选取的 `n`。

# 陈述（自然语言）

- `SequenceConvergesTo u l` 定义为：对每个正数 ε，存在自然数 N，使所有 n≥N 都满足
  `|u n-l|<ε`。
- 该教材定义与 Mathlib 的 `Tendsto u atTop (𝓝 l)` 完全等价。
- 原接口 `tendsto_iff_epsilon_N` 继续保留，直接表达滤子收敛与 ε-N 公式的等价。

# 陈述（Lean 对照）

```lean
def SequenceConvergesTo (u : ℕ → ℝ) (l : ℝ) : Prop :=
  ∀ ε > 0, ∃ N : ℕ, ∀ n ≥ N, |u n - l| < ε

theorem sequenceConvergesTo_iff_epsilon_N {u : ℕ → ℝ} {l : ℝ} :
    SequenceConvergesTo u l ↔ ∀ ε > 0, ∃ N : ℕ, ∀ n ≥ N, |u n - l| < ε

theorem sequenceConvergesTo_iff_tendsto {u : ℕ → ℝ} {l : ℝ} :
    SequenceConvergesTo u l ↔ Tendsto u atTop (𝓝 l)
```

# 思维脉络（thinking trace）

1. `SequenceConvergesTo` 直接保存教材的量词次序，因此展开定理是 `Iff.rfl`。
2. `Metric.tendsto_atTop` 把从自然数滤子 `atTop` 趋于 `l` 化为“最终距离小于每个正 ε”。
3. `Real.dist_eq` 把实轴距离 `dist (u n) l` 改写为绝对值 `|u n-l|`。
4. 将 `tendsto_iff_epsilon_N` 反向并展开本库定义，得到
   `sequenceConvergesTo_iff_tendsto`，两个方向都没有额外前提。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 实数列 `u` 收敛到 `l` | `SequenceConvergesTo u l` |
| 任意正 ε | `∀ ε > 0` |
| 存在信赖起点 N | `∃ N : ℕ` |
| 从 N 项起全部满足 | `∀ n ≥ N` |
| 距离极限小于 ε | `|u n - l| < ε` |
| Mathlib 滤子表达 | `Tendsto u atTop (𝓝 l)` |

# 依赖（人话版）

- 本库定义本身只需要自然数下标、实数绝对值与次序。
- `Metric.tendsto_atTop` 提供自然数序列在度量空间中的 ε-N 收敛刻画。
- `Real.dist_eq` 说明实数距离就是差的绝对值。
- `#print axioms sequenceConvergesTo_iff_tendsto` 的经典依赖来自 Mathlib 的实数、拓扑和滤子实现，
  不表示教材定义额外假设了选择公理。

# 应用与陷阱

- 应用：学习极限唯一、有界、夹逼、子列和极限运算时，可经等价桥在教材量词与 `Tendsto` 间切换。
- 陷阱：`N` 依赖 `ε`；把量词误写成先固定一个 `N` 再处理全部 `ε` 会得到远强于收敛的性质。
- 陷阱：必须要求 `ε>0`；`ε=0` 时严格不等式通常不可能成立。
- 接口边界：现有主定理继续接受和返回 `Tendsto`；本条的目的只是讲清定义，不要求替换这些接口。
