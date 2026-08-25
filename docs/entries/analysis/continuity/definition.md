---
id: analysis.continuity.definition
family: analysis.continuity
variant: ecnu
kind: definition
state: verified
title: 点连续、集合上连续与一致连续
summary: 以 ε-δ 量词区分点连续、集合上逐点连续和集合上一致连续，并桥接 Mathlib 接口
premises: [analysis.func-limit.definition]
mathlib: [Metric.continuousAt_iff, Metric.continuousOn_iff, Metric.uniformContinuousOn_iff]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第三章 §2 连续函数
---

# 动机

“连续”至少包含三个容易混淆的层次：固定一点连续、集合上每点分别连续，以及由一个共同 δ 控制
整个集合的一致连续。若只列出 `ContinuousAt`、`ContinuousOn` 和 `UniformContinuousOn`，读者看不到
关键量词究竟如何移动。本条把三种教材定义并列写出，再桥接 Mathlib 的正式接口。

# 直觉

点连续是在一个固定基点附近控制函数波动。集合上连续把这个要求逐点重复，因此 δ 可以随基点变化。
一致连续则要求先选出一个 δ，再让它控制集合内所有点对；这正是它比逐点连续更强的地方。

# 陈述（自然语言）

- `ContinuousAtTextbook f a`：对每个 ε，存在只针对基点 `a` 的 δ。
- `ContinuousOnTextbook f s`：对每个 `a∈s` 都满足相对于 `s` 的点连续。
- `UniformContinuousOnTextbook f s`：对每个 ε，存在与点无关的 δ，同时控制 `s` 中任意 `x,y`。
- 三个定义分别与 Mathlib 的 `ContinuousAt`、`ContinuousOn`、`UniformContinuousOn` 完全等价。

# 陈述（Lean 对照）

```lean
def ContinuousAtTextbook (f : ℝ → ℝ) (a : ℝ) : Prop :=
  ∀ ε > 0, ∃ δ > 0, ∀ x, |x - a| < δ → |f x - f a| < ε

def ContinuousOnTextbook (f : ℝ → ℝ) (s : Set ℝ) : Prop :=
  ∀ a ∈ s, ∀ ε > 0, ∃ δ > 0, ∀ x ∈ s, |x - a| < δ → |f x - f a| < ε

def UniformContinuousOnTextbook (f : ℝ → ℝ) (s : Set ℝ) : Prop :=
  ∀ ε > 0, ∃ δ > 0, ∀ x ∈ s, ∀ y ∈ s, |x - y| < δ → |f x - f y| < ε
```

对应桥为 `continuousAtTextbook_iff_continuousAt`、`continuousOnTextbook_iff_continuousOn` 和
`uniformContinuousOnTextbook_iff_uniformContinuousOn`。

# 思维脉络（thinking trace）

1. 三个本库定义直接固定教材的量词次序，尤其保留逐点连续中 δ 对基点的依赖。
2. `Metric.continuousAt_iff` 展开固定点连续。
3. `Metric.continuousOn_iff` 展开相对于集合的逐点连续，邻近点必须属于集合。
4. `Metric.uniformContinuousOn_iff` 展开一个 δ 控制集合内全部点对的条件。
5. `Real.dist_eq` 把三条 Mathlib 距离公式统一改写为实数绝对值。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 在点 `a` 连续 | `ContinuousAtTextbook f a` |
| 在集合 `s` 上逐点连续 | `ContinuousOnTextbook f s` |
| 在集合 `s` 上一致连续 | `UniformContinuousOnTextbook f s` |
| δ 可以依赖基点 | `∀ a ∈ s, ... ∃ δ ...` |
| δ 与点无关 | `∀ ε > 0, ∃ δ > 0, ∀ x ∈ s, ∀ y ∈ s, ...` |
| Mathlib 正式接口 | `ContinuousAt`、`ContinuousOn`、`UniformContinuousOn` |

# 依赖（人话版）

- `analysis.func-limit.definition`：连续可理解为函数极限等于函数在基点的值，但连续条件包含中心点。
- `Metric.continuousAt_iff`、`Metric.continuousOn_iff`：点态和集合内连续的度量展开。
- `Metric.uniformContinuousOn_iff`：集合上一致连续的统一 δ 展开。
- `Real.dist_eq`：实数距离与绝对值差的对应。

# 应用与陷阱

- 应用：介值定理、最值定理和紧集上的 Heine–Cantor 定理继续通过桥复用 Mathlib 接口。
- 陷阱：集合上逐点连续允许 δ 随 `a` 变化，不能据此直接得到一致连续。
- 陷阱：`ContinuousOn` 在边界点只沿集合内部趋近，比全邻域 `ContinuousAt` 弱。
- 边界：本条只处理实函数；现有正式定理继续使用通用 Mathlib 接口，不要求改写签名。
