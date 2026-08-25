---
id: abstract-algebra.poly.irreducible
family: abstract-algebra.poly
variant: textbook
kind: theorem
state: verified
title: 不可约多项式、Gauss 引理、有理根与 Eisenstein 判别
summary: 不可约与本原多项式；content；整数到有理数的 Gauss 引理；有理根整除；Eisenstein 判别
premises: [abstract-algebra.poly.def, abstract-algebra.poly.division, abstract-algebra.ring.ideal]
mathlib: [Irreducible, Polynomial.IsPrimitive, Polynomial.content, Polynomial.IsEisensteinAt]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Chapter 2；本科抽象代数多项式不可约判别
---

# 动机

因式分解理论首先要识别不能再分解的多项式。域上次数一多项式显然不可约，但高次多项式通常
需要把系数的公共因子与真正的多项式因子分开，再借助 Gauss 引理、有理根定理和 Eisenstein
判别处理。

# 直觉

不可约表示任何二因子分解中至少一个因子是单位。本原多项式表示没有非单位常数可以整除全部
系数；其 content 是所有系数的规范化最大公因子。Gauss 引理说明整数本原多项式在 `ℤ[X]` 中
不可约，当且仅当把系数嵌入 `ℚ` 后在 `ℚ[X]` 中不可约。

若既约分数 `a/b` 是整系数多项式的根，则 `a` 整除常数项、`b` 整除首项系数。Eisenstein
判别则使用一个素理想：首项不在其中，所有低次系数在其中，而常数项不在该理想的平方中。

# 陈述（自然语言）

本条目给出不可约因子判据、`X-a` 与 `X` 的不可约性、域上一次多项式不可约；解释本原多项式
和 content，证明本原性对乘法封闭以及 content 的乘法公式；证明整数—有理数 Gauss 引理、
有理根定理的分子和分母整除结论、首一整系数多项式的有理根必为整数；最后给出一般素理想版
及整数素数版 Eisenstein 判别。

# Lean 对照与正式承载

| 教材概念 | 正式 Lean 承载 | 关键展开／课程接口 |
|---|---|---|
| 不可约多项式 | `Irreducible p` | `irreducible_factor_isUnit` |
| 本原多项式 | `p.IsPrimitive` | `primitive_iff_constant_dvd_isUnit` |
| content | `p.content` | `primitive_iff_content_eq_one`、`content_mul` |
| 本原部分 | `p.primPart` | `eq_C_content_mul_primPart` |
| 系数嵌入 | `p.map (Int.castRingHom ℚ)` | `integer_gauss_irreducible_iff_rational_irreducible` |
| 异系数求值 | `Polynomial.aeval r p` | 两条有理根整除定理 |
| Eisenstein 条件 | `p.IsEisensteinAt P` | `irreducible_of_isEisensteinAt` |

这些成熟接口与教材语义一致，直接作为正式公开承载；本条目不再建立平行谓词或多项式类型。
`NormalizedGCDMonoid` 为 content 选择规范代表，`StrongNormalizedGCDMonoid` 提供 content 乘法公式；
它们是相应定理的精确代数假设，而非新的课程对象包装。

# 证明思路

低次数结论复用正式多项式接口。content 部分以“常数因子皆为单位”展开本原性，并由规范化 gcd
接口取得本原部分分解和乘法公式。Gauss 引理使用 Mathlib 已验证的整数专门版，避免重新建立
一般分式域的约分理论。

有理根部分调用规范分子、分母定理；首一时分母整除一，因而根来自整数。一般 Eisenstein 定理由
`IsEisensteinAt` 的三个字段组装；整数素数版把素整数 `q` 对应到主理想 `(q)`，只证明
`x∈(q) ↔ q∣x`、`x∈(q)² ↔ q²∣x` 及主理想为素三个桥，再调用一般判别。

# 依赖与真实使用者

多项式正式承载和次数来自 `abstract-algebra.poly.def`，首一性来自多项式除法章节，素理想语义
来自环论理想章节。`integer_prime_eisenstein_irreducible` 真实使用一般
`irreducible_of_isEisensteinAt`，而后者真实使用正式 `Polynomial.IsEisensteinAt` 接口。

# 应用与陷阱

- 一般整环中“次数一”不足以推出不可约：系数可能有非单位公共因子；本条目只在域上给出无条件
  次数一结论。
- Eisenstein 在 `ℤ[X]` 中推出不可约时需要多项式本原。若只想证明在 `ℚ[X]` 中不可约，可以先
  除去 content，但不能静默省略这一边界。
- `Polynomial.aeval` 用于把整系数多项式在有理数中求值，不同于同系数环的 `eval`。
- 有理根定理使用分式域的规范 `num/den`；任取未约分表示时，“分母整除首项”并不成立。
- A3.4 的唯一分解、根重数与导数判据仍未在本条目展开。
