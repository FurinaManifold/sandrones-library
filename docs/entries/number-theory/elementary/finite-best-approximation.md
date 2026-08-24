---
id: number-theory.elementary.finite-best-approximation
family: number-theory.elementary
variant: finite-candidates
kind: theorem
state: verified
title: 有限候选集中的最佳逼近存在
summary: 每个非空有限有理数候选集都有绝对误差最小者
premises: []
mathlib: [Finset.exists_min_image]
provenance:
  source_type: derivation
  ref: "有限线性序集取最小值"
---

# 动机

全体有理数是无限集，直接“取误差最小者”通常需要先证明候选有界。有限候选版本把这一困难
拆开：只要前一步已经构造出非空有限候选集，最优者的存在就由有限序理论保证。

# 直觉

给有限张写着有理数的卡片，逐张计算与 `ξ` 的距离，总能挑出距离最小的一张。允许多个候选
并列；定理只选择其中一个。

# 陈述（自然语言）

每个非空有限有理数集合 `s` 中都存在 `q`，使 `q∈s` 且对每个 `r∈s` 都有
`|ξ-q| ≤ |ξ-r|`。

# 陈述（Lean 对照）

```lean
def IsBestApproximationIn (ξ : ℝ) (s : Finset ℚ) (q : ℚ) : Prop :=
  q ∈ s ∧ ∀ r ∈ s, rationalApproximationError ξ q ≤ rationalApproximationError ξ r

theorem exists_bestApproximationIn (ξ : ℝ) {s : Finset ℚ} (hs : s.Nonempty) :
    ∃ q, IsBestApproximationIn ξ s q
```

# 思维脉络（thinking trace）

对非空有限集 `s : Finset ℚ`，存在 `q ∈ s`，使每个 `r ∈ s` 都满足
`|ξ-q| ≤ |ξ-r|`。把误差函数映到实数线性序，有限集必能选出像的最小值；Lean 中由
`Finset.exists_min_image` 完成这一有限选择。

证明中的 `obtain ⟨q, hqs, hq⟩ := ...` 同时取出最优候选、成员证明和最小性；最后
`exact ⟨q, hqs, hq⟩` 按本库谓词的合取结构原样组装。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 有限候选集 | `s : Finset ℚ` |
| 候选集非空 | `hs : s.Nonempty` |
| `q` 属于候选集 | `hqs : q ∈ s` |
| 误差最小 | `hq : ∀ r ∈ s, ... ≤ ...` |
| 从存在结论取出数据 | `obtain ⟨q, hqs, hq⟩ := ...` |

# 依赖（人话版）

- `rationalApproximationError`：给每个候选赋一个实数误差。
- `Finset.exists_min_image`：有限非空集合上的实值函数取得最小值。
- `LinearOrder ℝ`：允许比较任意两个误差。

# 应用与陷阱

本条是构造分母受限最佳逼近的有限化接口：实际应用先给出一个有限候选集，再在其中取最优者。
它本身不声称候选集已包含“所有分母不超过某界的有理数”；后者还需要对分子作有界化论证。

- 应用：计算实验或分母、分子均已截断时选择最优有理数。
- 陷阱：缺少 `hs` 时空集没有可返回的候选者。
- 陷阱：有限集内最佳不自动推出全局的 `IsBestRationalApproximation`。
