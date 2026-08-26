---
id: abstract-algebra.field.galois-restriction
family: abstract-algebra.field
variant: textbook
kind: theorem
state: verified
title: Galois 对应中的限制同态、核与商群
summary: 正规子群固定域上的限制同态满射，其核为原子群并诱导标准商群同构
premises: [abstract-algebra.field.galois-normality,
  abstract-algebra.field.galois-correspondence,
  abstract-algebra.field.galois-consequences,
  abstract-algebra.field.separable-normal]
mathlib: [Subgroup.Normal, AlgEquiv.restrictNormalHom_surjective,
  QuotientGroup.quotientKerEquivOfSurjective,
  QuotientGroup.quotientMulEquivOfEq]
provenance:
  source_type: book
  ref: dummit-foote-abstract-algebra-2004
---

# 数学内容

设 `L/K` 是有限 Galois 扩张，`G = Gal(L/K)`，`H ◁ G`，并令 `Lᴴ` 为
`H` 的共同固定域。正规性使每个 `σ ∈ G` 都保持 `Lᴴ`，所以逐点限制给出
群同态

```text
res : Gal(L/K) →* Gal(Lᴴ/K).
```

该同态满足 `ker res = H` 且 `range res = ⊤`。群的第一同构定理因此给出

```text
Gal(L/K) ⧸ H ≃* Gal(Lᴴ/K).
```

# 正式接口

`fixedFieldRestrictionHom` 是真实 restriction hom，而不是从最终同构反推的
包装。`fixedFieldRestrictionHom_apply` 给出其底层逐点公式。核、满射和像分别
由 `fixedFieldRestrictionHom_ker`、`fixedFieldRestrictionHom_surjective`、
`fixedFieldRestrictionHom_range` 表达。`fixedFieldQuotientEquiv` 承载商群
同构，`fixedFieldQuotientEquiv_mk_apply` 说明它在自然投影类上严格等于限制。

所有公开子群参数均为 Mathlib `Subgroup`；本条目没有新增 `SubgroupSet`
定义或兼容包装。

# Q01–Q05 证明状态转换

Q01 把“固定域保持性”化为正规子群对 `σ⁻¹τσ` 与 `στσ⁻¹` 的封闭，再用
自同构左右逆消去共轭。Q02 用既有 restriction 的恒等和复合逐点公式构造
`MonoidHom`。Q03 把 kernel membership 依次改写为“限制等于恒等”和“逐点
固定固定域”，最后用有限扩张恢复得到 `H`。

Q04 局部安装扩张塔后，把本库正规性桥到 Mathlib `Normal`，复用成熟的
`restrictNormalHom_surjective`；两个正式自同构 MulEquiv 的点态对齐证明
该满射正是本库真实 restriction hom。Q05 先对核应用第一同构定理，再用
`ker = H` 运输商群；自然投影公式为该构造的定义性计算。

# 边界

本条目不讨论正规中间域对应的子群格、商群作用或具体多项式算例。Mathlib
高级结构只存在于私有证明后端，公开扩张 API 继续使用显式域嵌入。
