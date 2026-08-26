---
id: abstract-algebra.field.galois-normality
family: abstract-algebra.field
variant: textbook
kind: theorem
state: verified
title: Galois 对应中的正规子群与正规中间扩张
summary: 有限 Galois 扩张中子群正规当且仅当其固定域对基域正规或 Galois
premises: [abstract-algebra.field.galois-consequences,
  abstract-algebra.field.galois-correspondence,
  abstract-algebra.field.separable-normal]
mathlib: [Subgroup.Normal, IntermediateField.fixedField,
  IsGalois.of_fixedField_normal_subgroup,
  IsGalois.fixingSubgroup_normal_of_isGalois]
provenance:
  source_type: book
  ref: dummit-foote-abstract-algebra-2004
---

# 数学内容

设 `L/K` 是有限 Galois 扩张，`G = Gal(L/K)`，`H ≤ G`。有限 Galois
基本对应把 `H` 送到共同固定域 `Lᴴ`。本条目证明

```text
H ◁ G  ↔  Lᴴ/K 是 Galois 扩张
       ↔  Lᴴ/K 是正规扩张。
```

第二个等价利用了固定域子扩张自动可分。因此在有限 Galois 环境中，教材
有时只写“正规中间扩张”，有时写“Galois 中间扩张”，两者在这里表达同一
批子群。

# 正式接口

`subgroup_normal_iff_fixedField_galoisExtension` 给出正规子群与固定域
Galois 条件的等价；`subgroup_normal_iff_fixedField_normalExtension` 给出
只保留正规性的教材版本。两项定理都直接接受正式 `Subgroup`，不扩张
历史 `SubgroupSet` 接口。

# 证明路线

私有后端沿已验证乘法等价把显式自同构子群映到 Mathlib 自同构群，并证明
两边固定域 carrier 相同。carrier 恒等诱导一个基域代数同构，从而转移
`IsGalois`。Mathlib 的成熟固定域正规性定理完成核心双向推理；A3.8 的公开
桥再把 `IsGalois`、可分和正规类翻译回本库显式扩张谓词。

# 边界

本条目不构造 restriction 同态、核、像或商群同构；这些属于 A3.9c 下一批。
具体二次扩张和有限域计算继续归 Examples E6.12。
