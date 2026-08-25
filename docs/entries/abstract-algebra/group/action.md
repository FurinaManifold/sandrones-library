---
id: abstract-algebra.group.action
kind: theorem
state: verified
title: "群作用、轨道、稳定子与类方程"
summary: 群作用公理、轨道分割、稳定子、轨道—稳定子定理、传递作用与有限群类方程
premises: ["abstract-algebra.group.product"]
mathlib: ["MulAction.orbit", "MulAction.stabilizer", "MulAction.orbitEquivQuotientStabilizer", "MulAction.orbitProdStabilizerEquivGroup", "MulAction.stabilizerEquivStabilizerOfOrbitRel", "Group.nat_card_center_add_sum_card_noncenter_eq_card"]
provenance:
  source_type: book
  ref: "dummit-foote-abstract-algebra-2004"
---

# 动机

群作用把抽象群解释为一个集合的对称变换，并把群论与几何、组合及置换联系起来。
轨道描述点能被移动到哪里，稳定子描述哪些对称保持该点不动。

# 直觉

一个轨道是一类“可由群作用互相到达”的点。把群元素按它们把 `x` 送到哪里分类，
同一类之间恰差一个稳定子元素，因此轨道由稳定子的陪集参数化。

# 陈述（自然语言）

作用满足 `1·x=x` 与 `(gh)·x=g·(h·x)`。轨道构成集合分割，稳定子是子群；
`Orb(x) ≃ G/Gₓ`，故 `|Orb(x)|·|Gₓ|=|G|`。同一轨道内的稳定子同构。
传递作用只有一个轨道。共轭作用的轨道分割给出有限群类方程。

# 陈述（Lean 对照）

`action_one/action_mul`、`orbit_mem_iff`、`stabilizer_mem_iff`、`orbit_eq_iff_mem`、
`orbitEquivCosets`、`stabilizerEquivOfSameOrbit`、`orbit_stabilizer_card`、
`pretransitive_iff_orbit_eq_univ`、`finite_group_class_equation`。

# 思维脉络（thinking trace）

由作用公理先证明“处于同一轨道”是等价关系。映射 `g ↦ g·x` 的纤维正是稳定子的
左陪集，因此得到轨道与陪集空间的等价；再取基数得到轨道—稳定子公式。最后将作用
专门化为共轭作用，把单点共轭类辨认为中心元素，便得到类方程。

# 自然语言 ↔ Lean 映射

- 群作用 ↔ `[MulAction G X]`；`g·x` ↔ `g • x`。
- 轨道 ↔ `MulAction.orbit G x`。
- 稳定子 `Gₓ` ↔ `MulAction.stabilizer G x`。
- 轨道空间 ↔ `MulAction.orbitRel.Quotient G X`。
- 共轭类 ↔ `ConjClasses G`。

# 依赖（人话版）

依赖群、子群、陪集、群同构和自同构；类方程还使用中心与共轭作用。

# 应用与陷阱

- 稳定子一般不正规，所以 `G/Gₓ` 在轨道—稳定子定理中只是陪集类型，不是商群。
- “传递”表示任意两点之间存在群元素相连，不表示作用忠实。
- `Nat.card` 对无限类型取零；轨道—稳定子乘法公式的主要数值用途是有限群情形。
- 类方程求和只遍历非中心共轭类，中心元素的单点轨道统一贡献 `|Z(G)|`。
