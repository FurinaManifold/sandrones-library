---
id: abstract-algebra.field.splitting
family: abstract-algebra.field
variant: textbook
kind: theorem
state: verified
title: 多项式的分裂域、存在性与唯一到同构
summary: 显式扩域中的根与分裂；根生成的分裂域；有限性、存在性及基域上同构唯一性
premises: [abstract-algebra.field.extension, abstract-algebra.field.degree]
mathlib: [Polynomial.Splits, Polynomial.rootSet, Polynomial.IsSplittingField,
  Polynomial.SplittingField]
provenance:
  source_type: book
  ref: dummit-foote-abstract-algebra-2004
---

# 动机

给定基域 `K` 上的多项式 `p`，教材中的分裂域不仅要求 `p` 在某个扩域 `L` 中完全分解，
还要求 `L` 不含与分解无关的多余元素：`L` 应当由 `p` 的全部根和基域共同生成。
A3.5 已提供显式域嵌入与集合式生成中间域，A3.6 已提供有限扩张和代数扩张接口；本条目
在这些公开定义上正式表达分裂域，而不让隐式代数实例决定教材语义。

# 教材定义

相对于 `e : FieldEmbedding K L`，`PolynomialRootSetIn e p` 包含满足

```text
p ≠ 0  且  evaluateOver e p a = 0
```

的元素 `a : L`。显式加入 `p ≠ 0` 使零多项式的教材根集为空。

`PolynomialSplitsIn e p` 表示把 `p` 的系数沿 `e` 映入 `L` 后，所得正式多项式满足
`Polynomial.Splits`。Mathlib 约定零多项式也分裂；因此 `SplittingFieldFor e p` 另行要求
`p ≠ 0`，并要求 `p` 分裂且

```text
generatedIntermediateFieldSet e (PolynomialRootSetIn e p) = Set.univ.
```

`ExtendsFieldEmbedding e j g` 表示 `g (e x) = j x`，即 `g` 固定基域。
`FieldIsomorphismOver eL eM` 则显式记录正逆域嵌入、左右互逆以及固定基域性质。

# 主要结果

- 根集成员关系等价于多项式非零且显式求值为零；零多项式根集为空。
- 分裂等价于存在一个根的多重集，使映射后的多项式等于首项系数乘全部
  `X - C a` 一次因子的乘积。
- 零多项式、任意常数多项式和任意一次多项式均分裂。
- 对两个非零多项式，乘积分裂当且仅当两个因子分别分裂。
- `SplittingFieldFor` 分别投影非零、分裂和由根生成三个教材条件。
- 分裂域是有限扩张，因而是代数扩张。
- 一个分裂域可在基域上嵌入任意使原多项式分裂的扩域。
- 每个非零多项式都存在分裂域；任意两个分裂域在基域上同构。

# Lean 承载与私有桥

| 教材对象 | 公开承载 | 私有验证后端 |
|---|---|---|
| 扩域中的根集 | `PolynomialRootSetIn` | `Polynomial.rootSet`、`aeval` |
| 扩域中的分裂 | `PolynomialSplitsIn` | `Polynomial.Splits` |
| 分裂域 | `SplittingFieldFor` | `Polynomial.IsSplittingField` |
| 固定基域的嵌入 | `ExtendsFieldEmbedding` | Mathlib 基域代数同态 |
| 基域上同构 | `FieldIsomorphismOver` | Mathlib 基域代数同构 |
| 存在性见证 | `SplittingFieldWitness` | `Polynomial.SplittingField` |
| 有限性 | `FiniteFieldExtension` | 分裂域有限维性、`Module.finBasis` |

公开声明只出现域、显式 `FieldEmbedding`、集合谓词、正式 `Polynomial` 和 A3.6 教材接口。
`Algebra`、`IntermediateField`、`AlgEquiv`、Mathlib 分裂域类以及模基仅在私有证明后端出现。
私有桥首先证明局部 `algebraMap` 等于指定嵌入，再对齐显式求值、根集和生成中间域，避免
由不同隐式实例静默改变基域映射。

# 证明结构

根集桥由 `Polynomial.mem_rootSet` 与 A3.5 的 `evaluateOver` 求值桥得到。集合交定义的
`generatedIntermediateFieldSet` 通过双方最小性与 `IntermediateField.adjoin` 对齐；随后
Mathlib 的中间域版分裂域刻画同时验证“分裂”和“由根生成”。

有限性先调用成熟的分裂域有限维定理，再取 `Module.finBasis`，直接构造 A3.6 的显式
`FinFieldBasis`。嵌入定理使用分裂域的 `lift`，存在性使用标准 `Polynomial.SplittingField`。
唯一性把两个分裂域分别同构到标准分裂域，再转回显式正逆嵌入结构。

# 边界与陷阱

- `PolynomialSplitsIn e 0` 成立，但 `SplittingFieldFor e 0` 不成立。
- 根集定义中的非零条件不可删除，否则零多项式会把整个目标域误作根集。
- 乘积分裂的双向定理需要两个因子非零；否则零多项式边界破坏逆向结论。
- 分裂域相对于具体嵌入 `e` 定义，而不是只由域类型 `K`、`L` 决定。
- 唯一性是“在基域上同构”，不是载体类型严格相等，也不是任意域同构。
