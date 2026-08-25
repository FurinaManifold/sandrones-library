---
id: number-theory.elementary.best-rational-approximation
family: number-theory.elementary
variant: denominator-bounded
kind: definition
state: verified
title: 最佳有理逼近
summary: 分母不超过给定有理数分母的所有候选都不能取得更小绝对误差
premises: []
mathlib: []
provenance:
  source_type: book
  ref: "hardy-wright-number-theory-2008"
---

# 动机

“某个有理数很接近 `ξ`”必须同时考虑误差与分母成本：允许任意大分母时，总能寻找更精细的
候选。最佳逼近把资源预算固定为“不超过当前分母”，再比较所有候选的绝对误差。

# 直觉

把分母看成近似的复杂度。`q` 若是最佳逼近，那么任何复杂度不高于 `q` 的 `r` 都不能更靠近
`ξ`。允许 `≤` 而不是 `<`，意味着并列最优不会被错误排除。

# 陈述（自然语言）

有理数 `q` 是实数 `ξ` 的最佳有理逼近，当且仅当对每个分母不超过 `q.den` 的有理数 `r`，
都有 `|ξ-q| ≤ |ξ-r|`。若 `ξ=q` 本身是有理数，则 `q` 必为最佳逼近。

# 陈述（Lean 对照）

```lean
def IsBestRationalApproximation (ξ : ℝ) (q : ℚ) : Prop :=
  ∀ r : ℚ, r.den ≤ q.den →
    rationalApproximationError ξ q ≤ rationalApproximationError ξ r
```

这把教材中的“分母预算”直接写进定义：在不使用更大分母的前提下，没有有理数比 `q` 更接近
`ξ`。使用 `≤` 允许误差相同的并列最优者。

# 思维脉络（thinking trace）

1. 先定义误差 `rationalApproximationError ξ q = |ξ-(q:ℝ)|`。
2. 将“分母预算内无更优者”翻译为一个全称量词和一个蕴含。
3. 对精确有理数情形，`intro r _` 固定任意竞争者，并丢弃不需要的分母条件。
4. `simp [rationalApproximationError]` 把 `q-q` 化为零，再用绝对值非负性完成 `0 ≤ |·|`。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| `q` 的规范正分母 | `q.den` |
| 近似误差 | `rationalApproximationError ξ q` |
| 分母预算 | `r.den ≤ q.den` |
| 最佳逼近 | `IsBestRationalApproximation ξ q` |
| 任取竞争者 | `intro r hr` |
| 精确误差为零 | `simp [rationalApproximationError]` |

# 依赖（人话版）

- `Rat.den`：有理数的规范自然数分母，恒严格正；`q=0` 时分母为 `1`，不存在零分母退化。
- 实数绝对值非负性：精确有理数基本例的数学核心。
- 本定义不依赖 Mathlib 的连分数结构，保证“最佳”概念独立于一种生成算法。

# 应用与陷阱

Mathlib 当前没有“每个简单连分数收敛子都是上述最佳逼近”的现成定理。本库因此先正式建立
教材定义，但不把 Legendre 判据冒充这一缺失方向。后续补齐收敛子的行列式恒等式与误差比较后，
才应增加该桥接定理。

- 应用：陈述连分数收敛子的最优性、比较不同分母预算下的近似。
- 陷阱：`q.den` 已约分且为正，不能把它当作任意书写 `a/b` 中尚未约分的 `b`。
- 陷阱：本条用绝对误差；有些教材的“第二类最佳逼近”比较 `|bξ-a|`，二者定义不同。
