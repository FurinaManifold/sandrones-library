---
id: abstract-algebra.field.separable-normal
family: abstract-algebra.field
variant: textbook
kind: theorem
state: verified
title: 可分多项式、可分扩张与正规扩张
summary: 导数 Bézout 判据、可分元与扩张、正规扩张、分裂域正规性及有限正规刻画
premises: [abstract-algebra.field.extension, abstract-algebra.field.degree,
  abstract-algebra.field.splitting]
mathlib: [Polynomial.Separable, IsSeparable, Algebra.IsSeparable, Normal, PerfectField]
provenance:
  source_type: book
  ref: dummit-foote-abstract-algebra-2004
---

# 动机

分裂域说明一个多项式何时在扩域中完全分解，但它没有区分不同根是否重复，也没有描述一个
给定扩张是否包含元素的全部共轭根。可分性排除最小多项式的重根现象；正规性要求扩张中的
每个元素，其基域最小多项式都在扩张内完全分裂。这两个概念共同构成后续 Galois 理论的入口。

本条目建立在 A3.5 的显式域嵌入、代数元和最小多项式，A3.6 的有限扩张，以及 A3.7 的
分裂域之上。所有扩张性质都相对于明确给出的 `FieldEmbedding K L`，不会由隐式实例静默选择
基域映射。

# 教材定义

多项式 `p : Polynomial K` 可分，定义为它与形式导数满足 Bézout 恒等式：

```text
∃ a b, a*p + b*p.derivative = 1.
```

这等价于 `p` 与 `p.derivative` 互素。零多项式不满足该条件；域上的非零常数多项式满足。

元素 `x : L` 相对于 `e : FieldEmbedding K L` 可分，若存在一个满足 A3.5 首一、湮灭和整除
泛性质的最小多项式，并且该多项式可分。`SeparableExtension e` 要求每个目标域元素均可分。

`NormalExtension e` 要求两件事：扩张首先是代数扩张；其次，对每个 `x : L` 及其任意教材
最小多项式 `p`，`PolynomialSplitsIn e p` 成立。

# 主要结果

- 可分多项式非零，且沿显式域嵌入映射系数前后可分性等价。
- 不可约多项式可分当且仅当其形式导数非零。
- 可分多项式的根不可能同时是其导数的根。
- 可分元必为代数元；给定最小多项式后，元素可分当且仅当该多项式可分。
- 可分扩张必为代数扩张。
- 正规扩张是代数扩张，且每个元素的最小多项式在目标域中分裂。
- 每个非零多项式的分裂域都是正规扩张。
- 一个显式扩张有限且正规，当且仅当它是某个非零多项式的分裂域。
- 有限基域上的每个显式有限扩张都是可分扩张。

# Lean 承载与复用桥

| 教材对象 | 公开承载 | 私有验证后端 |
|---|---|---|
| 可分多项式 | `SeparablePolynomial` | `Polynomial.Separable` |
| 可分元 | `SeparableElement` | Mathlib 元素可分谓词与 `minpoly` |
| 可分扩张 | `SeparableExtension` | Mathlib 可分扩张类 |
| 正规扩张 | `NormalExtension` | Mathlib 正规扩张类 |
| 有限性 | `FiniteFieldExtension` | 有限维和有限基 |
| 分裂域刻画 | `SplittingFieldFor` | Mathlib 分裂域类 |
| 有限基域可分性 | `[Finite K]` | 完美域实例 |

公开声明只使用域、显式 `FieldEmbedding`、正式 `Polynomial` 以及 A3.5--A3.7 教材谓词。
Mathlib 的 `Algebra`、整性、有限维、可分扩张类、正规扩张类、分裂域类和完美域主要服务
证明后端。`separableExtension_iff_mathlibIsSeparable` 与
`normalExtension_iff_mathlibNormal` 是跨模块正式复用桥：它们集中封装局部
`algebraMap`、显式求值和最小多项式的对齐，上层不得重复这条转换链。

# 证明结构

`SeparablePolynomial` 的定义就是 Mathlib 可分多项式 Bézout 展开的另一方向，因此导数判据、
映射不变性和根处导数非零可复用成熟接口。可分元桥先把 A3.5 最小多项式唯一识别为局部
`minpoly`；反向则从可分元的整性恢复本库代数元和教材最小多项式。

正规扩张桥逐元素使用 Mathlib `normal_iff`：本库代数性对应整性，而任意教材最小多项式由
唯一性识别为 `minpoly`。有限正规扩张方向从有限基构造有限维，再取得分裂多项式；若成熟接口
返回零多项式，则根生成条件迫使扩张与基域同构，改用非零常数多项式保持 A3.7 的非零边界。

有限基域可分性经过严格依赖链：有限域是完美域，显式有限扩张由 A3.6 得到代数性，完美基域
上的代数扩张可分，最后桥回 `SeparableExtension`。

# 教材来源

本条目对应 Dummit and Foote, *Abstract Algebra*, Third Edition, Chapter 13 中关于分裂域、
可分与不可分扩张的相关内容，尤其是 Section 4 “Splitting Fields and Algebraic Closures”
及 Section 5 “Separable and Inseparable Extensions”。正规扩张在分裂域刻画的语境中使用。

# 边界与后续

- 本模块采用 Mathlib 当前的代数可分扩张语义，不把超越扩张的可分生成性纳入定义。
- 有限维扩张本身不保证可分；有限基域可分性依赖有限域的完美性。
- 在不完美域上，不可约多项式可以具有零导数，从而给出有限纯不可分扩张。
- `SplittingFieldFor` 排除零多项式，因此有限正规存在性需要显式补足非零见证。
- 根重数刻画及“在扩域中有根的不可约多项式必分裂”的等价刻画属于第二批接口。
