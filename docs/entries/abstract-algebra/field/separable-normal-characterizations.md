---
id: abstract-algebra.field.separable-normal-characterizations
family: abstract-algebra.field
variant: textbook
kind: theorem
state: verified
title: 可分性与正规性的根论刻画
summary: 扩域根重数判据、分裂时的可分性充要条件及正规扩张的不可约多项式判据
premises: [abstract-algebra.field.separable-normal, abstract-algebra.poly.factorization]
mathlib: [Polynomial.rootMultiplicity, Polynomial.nodup_roots_iff_of_splits,
  Polynomial.Splits.of_dvd]
provenance:
  source_type: book
  ref: dummit-foote-abstract-algebra-2004
---

# 动机

A3.8 第一批固定了可分多项式和正规扩张的显式教材定义。本条目不改动
这些定义，而是给出计算根与使用正规扩张时最常见的三个等价刻画：
可分多项式没有重根；已经分裂的非零多项式可由根重数判定可分性；
正规扩张可由不可约多项式“有一个根便完全分裂”来识别。

# 主要结果

- `separablePolynomial_rootMultiplicity_le_one`：沿任意显式域嵌入映射后，
  可分多项式在每一点的根重数都至多为一。
- `separablePolynomial_iff_rootMultiplicity_le_one_of_splits`：非零多项式
  已经在扩域中分裂时，可分性等价于所有根重数至多为一。
- `normalExtension_iff_irreducible_with_root_splits`：正规扩张等价于代数
  扩张且每个在目标域中有根的不可约多项式都在其中完全分裂。

# 证明路线

正向根重数结论先使用第一批的系数映射可分性桥，再调用 Mathlib 的
`rootMultiplicity_le_one_of_separable`。逆向判据把逐点根重数上界通过
`count_roots` 改写为根多重集无重复；分裂假设使
`nodup_roots_iff_of_splits` 可以恢复可分性。

正规扩张方向对不可约多项式的一个根取教材最小多项式。最小多项式的
整除泛性质和双方不可约性给出反向整除，因此其已知分裂性通过
`Polynomial.Splits.of_dvd` 传给原多项式。逆向则直接把任意教材最小
多项式作为有根的不可约多项式应用假设。

# 教材来源

本条目复用 Dummit and Foote, *Abstract Algebra*, Third Edition 的来源键，
对应 Chapter 13 关于可分扩张、重根判据、正规扩张和分裂域的相关章节。

# 边界

- 零多项式被第二个定理的 `p ≠ 0` 明确排除。
- 根重数在映射后的 `Polynomial L` 上计算，不把隐式代数结构放入公开 API。
- 本条目只刻画第一批定义，不新增可分扩张或正规扩张的定义。
- A3.9a 的集成等待本批完成；A3.9b 仍为 `research_open`。
