---
id: analysis.func-limit.definition
family: analysis.func-limit
variant: ecnu
kind: definition
state: verified
title: 函数有限点极限的 ε-δ 定义
summary: FunctionConvergesToAt 展开为去心邻域 ε-δ 条件，并与 Tendsto f (𝓝[≠] a) (𝓝 L) 等价
premises: []
mathlib: [Metric.tendsto_nhds, Metric.mem_nhdsWithin_iff]
provenance:
  source_type: book
  ref: "ecnu-mathematical-analysis-5"
---

# 动机

函数在一点附近的行为不应取决于函数在该点本身的取值。教材用 ε-δ 量词准确表达“自变量足够
接近但不等于 `a` 时，函数值任意接近 `L`”。本条为这组量词建立本库名称，同时保留 Mathlib
去心邻域滤子作为正式定理接口。

# 直觉

给定函数值允许的误差 ε，我们要找到一个自变量半径 δ。任何落在 `a` 的 δ 邻域内但不等于
`a` 的点，都必须被函数送进 `L` 的 ε 邻域。δ 可以随 ε 改变，但选定后要同时控制邻域内所有点。

# 陈述（自然语言）

- `FunctionConvergesToAt f a L` 定义为上述双侧去心 ε-δ 条件。
- 它与 Mathlib 的 `Tendsto f (𝓝[≠] a) (𝓝 L)` 完全等价。
- 定义不约束 `f a`，因此修改函数在单点 `a` 的值不会改变该极限。

# 陈述（Lean 对照）

```lean
def FunctionConvergesToAt (f : ℝ → ℝ) (a L : ℝ) : Prop :=
  ∀ ε > 0, ∃ δ > 0, ∀ x, |x - a| < δ → x ≠ a → |f x - L| < ε

theorem functionConvergesToAt_iff_epsilon_delta {f : ℝ → ℝ} {a L : ℝ} :
    FunctionConvergesToAt f a L ↔
      ∀ ε > 0, ∃ δ > 0, ∀ x, |x - a| < δ → x ≠ a → |f x - L| < ε

theorem functionConvergesToAt_iff_tendsto {f : ℝ → ℝ} {a L : ℝ} :
    FunctionConvergesToAt f a L ↔ Tendsto f (𝓝[≠] a) (𝓝 L)
```

# 思维脉络（thinking trace）

1. `FunctionConvergesToAt` 直接保存教材量词，所以定义展开是 `Iff.rfl`。
2. `Metric.tendsto_nhds` 把趋于 `L` 化为每个 ε-球最终成立。
3. `Metric.mem_nhdsWithin_iff` 把去心邻域上的“最终成立”展开为存在正 δ 的局部条件。
4. `Real.dist_eq` 把实数距离改写为绝对值，得到与教材公式逐项一致的桥。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| `f(x)` 在 `x→a` 时趋于 `L` | `FunctionConvergesToAt f a L` |
| 任意函数值误差 ε | `∀ ε > 0` |
| 存在自变量半径 δ | `∃ δ > 0` |
| `x` 足够接近 `a` | `|x - a| < δ` |
| 排除中心点 | `x ≠ a` |
| Mathlib 去心邻域极限 | `Tendsto f (𝓝[≠] a) (𝓝 L)` |

# 依赖（人话版）

- `Metric.tendsto_nhds`：将目标邻域收敛展开为任意正半径条件。
- `Metric.mem_nhdsWithin_iff`：将集合内邻域成员关系展开为某个小球条件。
- `𝓝[≠] a`：只排除中心 `a` 的去心邻域滤子。
- `Real.dist_eq`：实数距离等于差的绝对值。

# 应用与陷阱

- 应用：极限唯一、四则运算、Heine 归结原理都可以通过等价桥复用 Mathlib 定理。
- 陷阱：去心极限不要求 `f a=L`，甚至不要求 `f a` 参与任何条件。
- 陷阱：这是双侧有限极限；单侧极限、`x→∞` 和函数值趋于无穷需要各自不同定义。
- 接口边界：现有函数极限定理继续使用 `Tendsto`，本定义只负责把教材含义讲清楚。
