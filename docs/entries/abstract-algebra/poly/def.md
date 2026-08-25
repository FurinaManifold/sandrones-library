---
id: abstract-algebra.poly.def
family: abstract-algebra.poly
variant: textbook
kind: theorem
state: verified
title: 多项式的有限支撑系数定义
summary: 自建多项式类型、环运算、系数、次数、求值、根、因式定理与整环性
premises: [abstract-algebra.ring.def, abstract-algebra.ring.domain, abstract-algebra.ring.divisibility]
mathlib: [Polynomial]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Chapter 2
---

# 动机

多项式首先是只有有限个非零项的形式表达式，而不是一个未经解释的 Mathlib 类型。本条目把这一
教材定义直接写入 Lean，使后续首一性、除法、不可约性和重数都能依赖本库自己的概念链。

# 直觉

一个多项式由系数序列 `a₀,a₁,…` 决定，并要求非零系数的位置有限。加法逐项进行，乘法使用
Cauchy 卷积。次数是最高非零项的位置，零多项式的次数记为 `⊥`；在 `a` 处求值是有限和
`∑ aₙaⁿ`，根就是求值为零的元素。

# 陈述（自然语言）

本条目定义有限支撑系数多项式及其系数，建立与 Mathlib 多项式的具名双向桥，并通过桥传输环
运算。随后证明零、一、加法、负法、乘法、常数和不定元的系数公式，定义次数、求值和根，证明
求值是环同态、`X-a` 整除当且仅当 `a` 是根，并证明整环上的本库多项式环仍为整环。

# 陈述（Lean 对照）

- `PolynomialSequence R`：本库有限支撑系数多项式。
- `coefficient`、`ext`：系数与外延性。
- `toMathlibPolynomial`、`fromMathlibPolynomial`：具名双向实现桥。
- `constant`、`X`、`degree`、`evaluate`、`IsRoot`：教材基本运算与性质。
- `coefficient_mul`：乘法系数的有限卷积公式。
- `evaluate_ringHomomorphism`：求值保持环运算。
- `divides_X_sub_constant_iff_root`：因式定理。
- `polynomial_integralDomainAxioms`：多项式环整环性。

# 思维脉络（thinking trace）

定义层使用函数及有限支撑证明，确保多项式概念不等同于 Mathlib 名称。为了复用成熟的卷积和
次数实现，构造到 Mathlib `Polynomial` 的双向桥并证明互逆；环运算通过这对桥私下传输，再用
系数公式把其教材含义公开。因式定理先在具名桥另一侧调用标准结果，再把整除见证搬回本库类型。
整环性同样把乘积为零送过单射桥，使用底层整环消去后返回。

# 自然语言 ↔ Lean 映射

| 数学语言 | Lean 接口 |
|---|---|
| 有限支撑多项式 | `PolynomialSequence R` |
| `Xⁿ` 的系数 | `coefficient p n` |
| 常数多项式 | `constant a` |
| 不定元 | `X` |
| 次数 | `degree p` |
| 在 `a` 处求值 | `evaluate a p` |
| `a` 是根 | `IsRoot p a` |
| 因式定理 | `divides_X_sub_constant_iff_root` |

# 依赖（人话版）

公开课程结论使用本库 `PolynomialSequence`、`RingHomomorphism`、`DividesElement` 和
`IntegralDomainAxioms`。Mathlib `Polynomial` 与 `Finsupp` 只出现在具名桥、私有传输定义和证明
实现中；它们不是本库多项式的公开教材定义。

# 应用与陷阱

- 零多项式的次数是 `⊥`，不能把它写成自然数零。
- `PolynomialSequence` 的有限支撑字段是定义的一部分，但外延性只需比较系数函数。
- 运算虽然通过成熟实现传输，公开系数公式仍明确给出逐项加法和有限卷积的数学内容。
- 因式定理使用本库 `DividesElement`，其乘子方向与本库 A2 整除定义一致。
- 旧 `Poly.lean` 中直接量化 Mathlib `Polynomial` 的接口保留在独立兼容 Entry，不再代表本定义层。
