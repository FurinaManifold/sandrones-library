---
id: abstract-algebra.ring.prime-ideal
family: abstract-algebra.ring
variant: rotman
kind: theorem
state: verified
title: 素理想、极大理想与商环判据
summary: 以理想集合定义素性与极大性，并证明商整环、商域的双向判据
premises: [abstract-algebra.ring.ideal, abstract-algebra.ring.quotient, abstract-algebra.ring.domain]
mathlib: [Ideal.IsPrime, Ideal.IsMaximal]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Ch 1（素理想与极大理想）
---

# 动机

素理想和极大理想把环内的理想序结构转化为商环的乘法性质。为了让结论真正属于本库教材
体系，理想性质和商环性质都必须使用本库定义，而不能直接陈述为 Mathlib `Ideal.Quotient`
上的类型类事实。

# 直觉

素理想是一个真理想：乘积落入它时，至少一个因子已经落入它。这恰好说明商环没有零因子。
极大理想是真理想中按包含关系最大的对象；商掉它以后不再有非平凡理想，等价地，每个非零
商类都有逆元，所以商环是域。交换环中每个极大理想因此都是素理想。

# 陈述（自然语言）

本库把素理想定义为满足乘积判据的真双边理想，把极大理想定义为不存在严格中间双边理想的
真理想。证明极大理想必为素理想；证明 `I` 素当且仅当本库商环 `R/I` 满足整环公理；证明
`I` 极大当且仅当该商环满足域公理。另提供与 Mathlib 打包理想性质的双向承载桥。

# 陈述（Lean 对照）

- `PrimeIdealSet I`：双边理想、非全环及乘积判据。
- `MaximalIdealSet I`：真双边理想及包含序中的极大性。
- `primeIdealSet_iff_exists_ideal_isPrime`、`maximalIdealSet_iff_exists_ideal_isMaximal`：
  Mathlib 兼容桥。
- `maximalIdealSet_is_prime`：交换环中极大理想必为素理想。
- `quotientRingSet_commutativeRingAxioms`：交换环的商满足交换环公理。
- `primeIdealSet_iff_quotient_integralDomainAxioms`：素理想与商整环的双向判据。
- `maximalIdealSet_iff_quotient_fieldAxioms`：极大理想与商域的双向判据。

# 思维脉络（thinking trace）

先定义两个集合谓词，并证明它们与 Mathlib 承载的载体完全一致。商整环判据通过投影乘积为零
等价于代表元乘积落入 `I` 得到。商域判据的核心是商类可逆：代表元 `a` 的商类可逆，当且
仅当存在 `b` 使 `a*b-1∈I`。极大性把由 `I` 与 `a` 生成的更大理想迫到全环，从而产生这个
逆元关系；反向则用商域中的逆元排除严格中间理想。

# 自然语言 ↔ Lean 映射

| 数学语言 | Lean 接口 |
|---|---|
| `I` 是素理想 | `PrimeIdealSet I` |
| `I` 是极大理想 | `MaximalIdealSet I` |
| 极大理想必为素理想 | `maximalIdealSet_is_prime` |
| `R/I` 是整环 | `IntegralDomainAxioms (quotientRingSet I hI)` |
| `R/I` 是域 | `FieldAxioms (quotientRingSet I hI)` |
| 商类为零 | `quotientRingProjection_eq_zero_iff` |
| 商类可逆 | `quotientRingSet_projection_unit_iff` |

# 依赖（人话版）

本条目依赖理想集合定义、显式商环构造以及整环和域的本库公理层。证明实现可以通过具名桥
调用 Mathlib 的 `Ideal.IsPrime` 与 `Ideal.IsMaximal`，但两个商环主判据的公开签名只使用
本库对象。全部内容集中于一个 Lean 文件，满足一个 Registry Entry 对应一个源码文件。

# 应用与陷阱

- 素理想与极大理想都必须是真理想；漏掉 `I ≠ univ` 会让零环式退化对象混入。
- 商类型的构造仍需显式 `hI : TwoSidedIdealSet I`，即使左侧完整谓词已经包含此事实。
- 商环的运算只有本库 `RingAxioms` 证明，不能未经桥接直接调用 Mathlib 的整环或域实例。
- `Ideal.IsPrime`、`Ideal.IsMaximal` 和 `Ideal.Quotient` 不是教材主接口。
