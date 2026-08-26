---
id: abstract-algebra.field.galois-correspondence
family: abstract-algebra.field
variant: textbook
kind: theorem
state: verified
title: 有限 Galois 基本对应
summary: 以显式中间域集合和基域自同构子群集合表述有限 Galois 基本定理
premises: [abstract-algebra.field.galois-definitions,
  abstract-algebra.field.degree, abstract-algebra.group.def]
mathlib: [FieldTheory.IntermediateField.Adjoin.Basic,
  FieldTheory.IntermediateField.Adjoin.Algebra,
  FieldTheory.Fixed,
  FieldTheory.Galois.Basic]
provenance:
  source_type: book
  ref: dummit-foote-abstract-algebra-2004
---

# 动机

有限 Galois 基本定理把扩张中的中间域与 Galois 群的子群反向对应起来。
本条目采用本库的显式教材 API：中间域用 `IntermediateFieldSet`，子群用
`SubgroupSet`，自同构用 `FieldAutomorphismOver`，共同固定点与逐点 fixing
条件都直接写成集合。公开定理因此不要求读者先接受 Mathlib 的打包结构。

# 集合级 Galois connection

`FixingAutomorphismSet e E` 收集逐点固定 `E` 的全部基域自同构。它对恒等、
复合和逆封闭，因而满足本库 `SubgroupSet`。固定域与 fixing 集合之间有基本
等价：

```text
E ⊆ FixedFieldSet e H ↔ H ⊆ FixingAutomorphismSet e E.
```

由此立即得到两项自然包含。有限性只在把这些包含提升为等式时进入
证明。

# 真实 restriction 层

`ExplicitIntermediateField e` 保存一个集合及其 `IntermediateFieldSet` 证明；
`IntermediateFieldCarrier F` 是这个集合的子类型，并由封闭性获得真实域结构。
模块显式构造基域到该载体的嵌入、载体到 `L` 的包含嵌入，以及保持 `F` 的
自同构在载体上的限制。

`PreservesIntermediateField σ F` 同时记录正向和逆向映射保持 `F`。这足以把
限制组装成 `FieldAutomorphismOver (intermediateFieldBaseEmbedding F)`，并证明
限制与恒等、复合、逆逐点相容。逐点固定 `F` 又等价于该限制自同构为
恒等；这些结果保证后续换基不是仅在定义上伪装的接口。

# 群阶、次数与中间域恢复

对有限 Galois 扩张和显式中间域 `F`，模块建立 fixing 自同构子类型与
`L/F` 自同构的换基等价，再与 Mathlib 私有 `AlgEquiv` 后端对齐。由有限
Galois 扩张的自同构数目公式，得到一个自然数同时是 fixing 群的基数和
`HasExtensionDegree (intermediateFieldInclusion F)` 的次数。

`finiteGalois_automorphism_card_eq_degree` 是留给后续推论层的薄数值接口：
它把全体基域自同构的数目识别为给定的总扩张次数。该接口直接复用本模块
已有的显式自同构换基、有限维和 `IsGalois` 私有桥，避免下游重复造轮子。

`fixingClosureIntermediateField F` 是先取 fixing 自同构、再取共同固定域所得
闭包。`F` 与闭包有相同 fixing 集合，因而相对次数相同；结合自然包含和
“同一有限维数下的包含必为相等”，得到中间域恢复。

# 子群恢复与基本对应

对子群集合 `H`，自然包含给出
`H ⊆ FixingAutomorphismSet e (FixedFieldSet e H)`。证明后端通过固定点作用、
显式子类型等价和有限基数传递，证明两侧群阶相等；有限集合的包含加
同基数遂给出子群恢复。这个方向本身只需要扩张有限，不额外需要
Galois 假设。

`finiteGalois_fundamental_correspondence` 汇总两个恢复方向：有限 Galois
扩张中的每个中间域由其 fixing 群恢复，而每个显式自同构子群由其固定域
恢复。

# Mathlib 私有边界

Mathlib 的局部 `Algebra`、打包中间域和子群、`AlgEquiv`、`FiniteDimensional`、
`IsGalois`、`FixedPoints.toAlgHomEquiv` 及相关有限基数工具只出现在私有桥或
证明体。公开声明不暴露这些承载。证明刻意重建 restriction、换基与数值
消去链，不调用直接返回最终中间域恢复、子群恢复或完整对应的便捷
定理。

# 教材来源与边界

本条目复用 Dummit and Foote, *Abstract Algebra*, Third Edition 的来源键，
对应 Chapter 14 中有限 Galois 扩张的基本定理及其固定域—子群对应。
次数—指数公式、正规中间扩张与正规子群、限制同态的核像及商群同构
留给后续独立条目；这里新增的全群阶—总次数接口只是证明复用边界，不在
本条目中展开这些推论。
