---
id: abstract-algebra.poly.division
family: abstract-algebra.poly
variant: textbook
kind: theorem
state: verified
title: 多项式带余除法、最大公因式与 Bézout 等式
summary: 交换环上首一除法；域上任意非零多项式除法；次数度量给出的 Euclidean 结构；gcd 与 Bézout
premises: [abstract-algebra.poly.def, abstract-algebra.ring.euclidean]
mathlib: [Polynomial.divByMonic, Polynomial.modByMonic, Polynomial.instEuclideanDomain]
provenance:
  source_type: textbook
  ref: 本科抽象代数的多项式带余除法与 Euclidean 算法
---

# abstract-algebra.poly.division

- **家族**: `abstract-algebra.poly`
- **状态**: verified
- **一句话**: 多项式的次数在余式中严格下降，因此域上的多项式环可执行 Euclidean 算法。

## 教材内容

正式承载采用 `Polynomial R`。在一般交换环上，除式首一时存在商和余式，且余式次数严格小于
除式；满足这一次数条件的商余对唯一。余式为零恰好表示除式整除被除式。

当系数环是域时，任意非零除式都可通过首项系数归一化而进行带余除法。课程接口把零多项式
的度量定义为 `0`，把次数为 `n` 的非零多项式的度量定义为 `n + 1`，由此得到自然数值的
Euclidean 度量，并复用 A2 的递归算法取得最大公因式及 Bézout 等式。

## 正式 Lean 接口

- `Polynomial.Monic`：最高次系数为一；这是教材首一性的正式承载。
- `Polynomial.divByMonic`、`Polynomial.modByMonic`：交换环上的首一商与余式。
- `mathlib_monic_division_identity`、`mathlib_monic_remainder_degree_lt`：首一带余除法。
- `mathlib_monic_quotient_remainder_unique`：商余唯一性。
- `/`、`%`：域上的一般多项式商与余式。
- `mathlibPolynomialEuclideanDomainAxioms`：在正式承载上组装本库 A2 Euclidean 公理。
- `mathlibPolynomialGCD_isGreatestCommonDivisor`、`mathlibPolynomialGCD_bezout`：A2 算法的
  gcd 泛性质与 Bézout 等式。

## 旧接口兼容层

`PolynomialSequence`、`Monic`、`monicQuotient`、`monicRemainder`、
`polynomialEuclideanDomainAxioms` 及其 gcd/Bézout 定理继续保留。它们通过
`toMathlibPolynomial`、`fromMathlibPolynomial` 迁移到正式承载，不再作为 A3.3/A3.4 的扩建基础。

## 实现边界

公开教材陈述直接使用语义一致的 Mathlib `Polynomial`、`Monic`、`divByMonic`、`modByMonic`、
`/` 和 `%`。文档在此明确解释这些接口的教材含义和类型类边界；本库
`EuclideanDomainAxioms`、`GreatestCommonDivisor` 与递归算法则作为 A2 已解释的真实上层依赖。
