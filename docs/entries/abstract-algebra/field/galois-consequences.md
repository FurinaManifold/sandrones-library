---
id: abstract-algebra.field.galois-consequences
family: abstract-algebra.field
variant: textbook
kind: theorem
state: verified
title: 有限 Galois 对应的次数与指数公式
summary: 子群固定域的上下两层扩张次数分别等于子群阶与子群指数
premises: [abstract-algebra.field.galois-correspondence,
  abstract-algebra.field.degree, abstract-algebra.group.def]
mathlib: [Subgroup, Subgroup.index, Module.Finite.of_injective,
  Module.finBasisOfFinrankEq]
provenance:
  source_type: book
  ref: dummit-foote-abstract-algebra-2004
---

# 动机

有限 Galois 基本对应不仅给出中间域与子群的反向配对，还把域扩张的次数
转化为有限群的阶和指数。若 `G = Gal(L/K)`，`H ≤ G`，共同固定域记为
`Lᴴ`，则教材中的两项基本数值公式是

```text
[L : Lᴴ] = |H|,          [Lᴴ : K] = [G : H].
```

它们使域论问题可以转成有限群计数，也为后续正规子群、限制同态和商群
同构提供数值基础。

# 正式载体与固定域

`fixedFieldIntermediateField e H` 把正式子群 `H : Subgroup
(FieldAutomorphismOver e)` 的共同固定点打包成 A3.9b 的显式中间域。其底层
集合严格是 `FixedFieldSet e (H : Set _)`。本条目不再以 `SubgroupSet` 作为
新公开载体；旧集合判据只在证明体中连接 A3.9b 已集成定理。

# 相对次数等于子群阶

`finiteGalois_fixedField_relativeDegree_eq_card` 陈述
`[L : Lᴴ] = |H|`。A3.9b 已经证明，任意显式中间域上的相对次数等于逐点
固定该中间域的自同构数目。对子群固定域应用子群恢复，逐点 fixing 集合
恰好恢复为 `H`，于是得到所需等式。

# 固定域次数等于子群指数

`finiteGalois_fixedField_degree_eq_index` 陈述
`[Lᴴ : K] = [G : H]`。证明首先由 `L/K` 的有限基和固定域载体到 `L` 的
线性包含，得到 `Lᴴ/K` 的有限性。设其次数为 `m`，扩张塔给出

```text
m |H| = [L : K].
```

A3.9b 的数值接口把总次数识别为 `|G|`；另一方面 Lagrange 公式给出
`|H| [G : H] = |G|`。相对扩张次数严格为正，因此可在自然数中消去 `|H|`，
得到 `m = [G : H]`。

# 实现边界

Mathlib 的 `Basis`、`FiniteDimensional` 与线性映射只用于私有有限性桥。
公开结论继续使用本库的 `FieldEmbedding`、`HasExtensionDegree`、
`FieldAutomorphismOver` 和正式 `Subgroup`。证明不调用直接返回完整 Galois
对应或次数—指数最终结论的便捷定理。

# 后续边界

本条目只完成 A3.9c 的次数—指数批次。正规中间扩张与正规子群的对应、
restriction 的核像以及商群同构属于后续独立批次。二次扩张、有限域和低次
多项式分裂域的具体计算属于 Examples E6.12，不在抽象代数理论模块重复。
