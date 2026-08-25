---
id: abstract-algebra.poly.def
family: abstract-algebra.poly
variant: textbook
kind: theorem
state: verified
title: 多项式的有限支撑系数语义与 Lean 承载
summary: 解释 Polynomial 的有限支撑系数语义、系数、支撑、次数、求值和旧兼容表示
premises: [abstract-algebra.ring.def, abstract-algebra.ring.domain, abstract-algebra.ring.divisibility]
mathlib: [Polynomial]
provenance:
  source_type: book
  ref: "dummit-foote-abstract-algebra-2004"
---

# 动机

多项式首先是只有有限个非零项的形式表达式。Mathlib `Polynomial R` 正好承载这一教材语义，
并提供稳定的系数、支撑、次数和求值接口，因此后续课程直接以它作为正式 Lean 类型；已有
`PolynomialSequence R` 保留为经双向互逆桥验证的兼容表示。

# 直觉

一个多项式由系数序列 `a₀,a₁,…` 决定，并要求非零系数的位置有限。加法逐项进行，乘法使用
Cauchy 卷积。次数是最高非零项的位置，零多项式的次数记为 `⊥`；在 `a` 处求值是有限和
`∑ aₙaⁿ`，根就是求值为零的元素。

# 陈述（自然语言）

正式承载 `Polynomial R` 以 `coeff` 读取系数，以有限集 `support` 记录非零项，以
`degree : WithBot ℕ` 表示次数，并以 `eval` 求值。兼容模块另给出 `PolynomialSequence R`，证明
它与正式承载双向互逆，并保留旧代码所用的系数公式、因式定理和整环性。

# 陈述（Lean 对照）

- `Polynomial R` / `R[X]`：后续课程的正式多项式承载。
- `Polynomial.coeff`、`support`：系数函数与有限非零支撑。
- `Polynomial.degree`：零多项式取 `⊥` 的次数。
- `Polynomial.eval`：同系数环中的有限幂和求值。
- `PolynomialSequence R`：旧有限支撑系数兼容表示。
- `coefficient`、`ext`：系数与外延性。
- `toMathlibPolynomial`、`fromMathlibPolynomial`：具名双向实现桥。
- `constant`、`X`、`degree`、`evaluate`、`IsRoot`：教材基本运算与性质。
- `degree_eq_nat_iff`：次数等于 `n` 当且仅当第 `n` 项非零且更高项全为零。
- `evaluate_eq_coefficientSupport_sum`：求值等于非零系数支撑上的有限幂和。
- `degree_eq_mathlib_degree`、`evaluate_eq_mathlib_eval`：方向明确的具名后端桥。
- `coefficient_mul`：乘法系数的有限卷积公式。
- `evaluate_ringHomomorphism`：求值保持环运算。
- `divides_X_sub_constant_iff_root`：因式定理。
- `polynomial_integralDomainAxioms`：多项式环整环性。

# 思维脉络（thinking trace）

教材定义与 `Polynomial` 的语义核对逐项进行：`coeff` 是系数序列，`support` 的有限性保证只有
有限个非零项，乘法系数是 Cauchy 卷积，`degree` 用 `WithBot` 诚实处理零多项式，`eval` 是有限
幂和。兼容类型把同一语义显式再现，并由双向逆桥证明并非另一种数学对象。

# 自然语言 ↔ Lean 映射

| 数学语言 | Lean 接口 |
|---|---|
| 有限支撑多项式 | `Polynomial R` / `R[X]` |
| `Xⁿ` 的系数 | `p.coeff n` |
| 非零系数位置 | `p.support` |
| 常数多项式 | `Polynomial.C a` |
| 不定元 | `Polynomial.X` |
| 次数 | `p.degree` |
| 在 `a` 处求值 | `p.eval a` |
| `a` 是根 | `p.IsRoot a` |
| 因式定理 | `divides_X_sub_constant_iff_root` |

# 依赖（人话版）

后续公开课程结论直接使用 Mathlib `Polynomial`，因为其语义与教材定义一致且已在本条目解释。
`PolynomialSequence` 是旧接口兼容层；`Finsupp` 属于 Mathlib 内部实现，不是课程公开前提。

# 应用与陷阱

- 零多项式的次数是 `⊥`，不能把它写成自然数零。
- `Polynomial.ext` 表明比较所有系数即可证明两个正式多项式相等。
- `PolynomialSequence` 的有限支撑字段是兼容表示的一部分，但外延性同样只需比较系数函数。
- 运算虽然通过成熟实现传输，公开系数公式仍明确给出逐项加法和有限卷积的数学内容。
- 因式定理使用本库 `DividesElement`，其乘子方向与本库 A2 整除定义一致。
- `toMathlibPolynomial` 与 `fromMathlibPolynomial` 是兼容迁移路径；新章节不应再扩张平行类型依赖。
