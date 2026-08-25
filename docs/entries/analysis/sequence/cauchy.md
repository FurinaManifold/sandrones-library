---
id: analysis.sequence.cauchy
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: Cauchy 列定义与实数完备性准则
summary: 以双指标 ε-N 条件定义 Cauchy 列，桥接 CauchySeq，并证明实数列 Cauchy 当且仅当收敛
premises: [analysis.sequence.definition]
mathlib: [CauchySeq, Metric.cauchySeq_iff, cauchySeq_tendsto_of_complete]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第二章 §1-§3 数列极限
---

# 动机

判断收敛时通常并不知道极限是多少。Cauchy 条件只比较序列尾部任意两项，不需要预先猜测极限，
因而把“是否存在极限”转化为序列内部可检验的性质。为了不把这层量词结构藏在 `CauchySeq`
背后，本条先给出教材定义，再复用 Mathlib 的完备空间接口证明实数上的收敛准则。

# 直觉

收敛表示尾部所有项都围绕同一个已知中心靠拢；Cauchy 表示尾部任意两项彼此靠拢，不要求先给
中心。收敛蕴含 Cauchy 只需 ε/2 与三角不等式。反方向并非对所有数系成立：有理数中的 Cauchy
列可能逼近无理数；实数的完备性保证缺失的中心一定仍在实数中。

# 陈述（自然语言）

- `SequenceIsCauchy u` 定义为：对任意正 ε，存在 N，使任意 `m,n≥N` 都满足
  `|u m-u n|<ε`。
- 该定义与 Mathlib 的 `CauchySeq u` 完全等价。
- 任意收敛实数列都是 Cauchy 列。
- 任意 Cauchy 实数列都收敛到某个实数；这一步使用实数完备性。

# 陈述（Lean 对照）

```lean
def SequenceIsCauchy (u : ℕ → ℝ) : Prop :=
  ∀ ε > 0, ∃ N : ℕ, ∀ m ≥ N, ∀ n ≥ N, |u m - u n| < ε

theorem sequenceIsCauchy_iff_cauchySeq {u : ℕ → ℝ} :
    SequenceIsCauchy u ↔ CauchySeq u

theorem convergent_is_cauchy {u : ℕ → ℝ} {l : ℝ}
    (h : Tendsto u atTop (𝓝 l)) : CauchySeq u

theorem cauchy_seq_convergent {u : ℕ → ℝ} (h : CauchySeq u) :
    ∃ l : ℝ, Tendsto u atTop (𝓝 l)
```

# 思维脉络（thinking trace）

1. `Metric.cauchySeq_iff` 将 `CauchySeq u` 展开成尾部任意两项距离小于 ε。
2. `Real.dist_eq` 把实数距离改写为 `|u m-u n|`，由此得到本库定义与 Mathlib 接口的双向桥。
3. 对收敛列取 ε/2。充分大的 `m,n` 分别满足 `|u m-l|<ε/2`、`|u n-l|<ε/2`，三角不等式
   给出 `|u m-u n|<ε`。
4. 对 Cauchy 列，`cauchySeq_tendsto_of_complete` 从 `CompleteSpace ℝ` 实例直接产生极限。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 实数列是 Cauchy 列 | `SequenceIsCauchy u` |
| 尾部任意两项 | `∀ m ≥ N, ∀ n ≥ N` |
| 两项距离小于 ε | `|u m - u n| < ε` |
| Mathlib 的一般 Cauchy 序列接口 | `CauchySeq u` |
| 收敛到 `l` | `Tendsto u atTop (𝓝 l)` |
| 完备空间中 Cauchy 列有极限 | `cauchySeq_tendsto_of_complete` |

# 依赖（人话版）

- `analysis.sequence.definition`：提供数列收敛的 ε-N 含义及其 `Tendsto` 桥。
- `Metric.cauchySeq_iff`：Mathlib 的 Cauchy 序列接口与度量 ε-N 条件之间的桥。
- `Real.dist_eq`：把实数距离还原成教材使用的绝对值。
- `abs_add_le`、`abs_sub_comm`：证明收敛蕴含 Cauchy 所需的三角不等式。
- `cauchySeq_tendsto_of_complete`：把实数完备性用于 Cauchy 蕴含收敛的方向。

# 应用与陷阱

- 应用：级数收敛可通过研究部分和序列是否为 Cauchy 列来判断。
- 陷阱：`N` 同时控制两个下标；不能让 `N` 在选定 `m` 或 `n` 后再次变化。
- 陷阱：Cauchy 蕴含收敛依赖空间完备性，在 `ℚ` 中不成立。
- 接口边界：本库谓词负责展示教材定义；现有定理继续使用 `CauchySeq`，这不是未清理的债务。
