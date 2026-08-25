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

在一般交换环上，除式首一时存在商和余式，且余式次数严格小于除式；满足这一次数条件的
商余对唯一。余式为零恰好表示除式整除被除式。

当系数环是域时，任意非零除式都可通过首项系数归一化而进行带余除法。本库把零多项式
的度量定义为 `0`，把次数为 `n` 的非零多项式的度量定义为 `n + 1`，由此得到自然数值的
Euclidean 度量，并复用 A2 的递归算法取得最大公因式及 Bézout 等式。

## 本库接口

- `Monic`：用“某项系数为一且更高项全为零”定义首一多项式。
- `monicQuotient`、`monicRemainder`：交换环上的首一商与余式。
- `monic_division_identity`、`monic_remainder_degree_lt`：首一带余除法。
- `monic_quotient_remainder_unique`：商余唯一性。
- `polynomialQuotient`、`polynomialRemainder`：域上的一般商与余式。
- `polynomialEuclideanDomainAxioms`：本库 `EuclideanDomainAxioms` 的多项式实例数据。
- `polynomialGCD_isGreatestCommonDivisor`、`polynomialGCD_bezout`：gcd 泛性质与 Bézout 等式。

## 实现边界

公开教材陈述使用本库 `PolynomialSequence`、`DividesElement`、`GreatestCommonDivisor` 和
`EuclideanDomainAxioms`。Mathlib 多项式除法只在具名转换桥后的证明后端出现，不充当本库
的教材定义。
