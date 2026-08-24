---
id: number-theory.elementary.pythagorean-triples
kind: theorem
state: verified
title: "勾股三元组的 Euclid 参数化"
summary: 自建勾股与本原谓词，验证参数构造，并给出一般整数分类和带奇偶、符号规范的本原分类
premises: ["number-theory.elementary.linear-diophantine"]
mathlib: ["PythagoreanTriple.coprime_classification'", "PythagoreanTriple.classification"]
provenance:
  source_type: book
  ref: "Hardy–Wright, An Introduction to the Theory of Numbers, Ch 13"
---

# 动机

方程 `x²+y²=z²` 是初等不定方程的标准范例。只验证某些公式给出解还不够；完整理论
必须说明每一个整数解都来自 Euclid 参数，并为本原正三元组选出方向明确的规范形式。

# 直觉

恒等式
`(m²-n²)²+(2mn)²=(m²+n²)²`
给出构造。反向分类中，公共因子由 `k` 吸收；两条直角边可以交换，斜边可以变号。
本原情形排除公共因子，并迫使参数互素且一奇一偶。再要求 `x` 奇、`z>0`，就固定为
`x=m²-n², y=2mn, z=m²+n²`，而 `m≥0` 固定一种方便的符号规范。

# 陈述（自然语言）

- Euclid 参数 `(m²-n²,2mn,m²+n²)` 总是勾股三元组。
- 本原三元组在 `x` 奇且 `z>0` 时具有带互素、奇偶性和符号规范的参数表示。
- 任意整数勾股三元组都由公共倍数、两直角边交换和斜边符号变化得到。

# 陈述（Lean 对照）

`IsPythagoreanTriple`、`IsPrimitivePythagoreanTriple`、
`pythagorean_parameters_form_triple`、`primitivePythagorean_classification`、
`pythagorean_classification`。

# 思维脉络（thinking trace）

先建立本库公开谓词，使教材逻辑从方程本身开始。正向构造直接用环恒等式验证，不依赖
分类定理。反向阶段才把本库谓词桥接到 Mathlib 的 `PythagoreanTriple`；一般分类保留
`k`、交换和符号三种自由度，本原分类则一次返回公式、互素性、相反奇偶性和 `m≥0`。

# 自然语言 ↔ Lean 映射

- “勾股三元组” ↔ `IsPythagoreanTriple x y z`。
- “本原” ↔ `Int.gcd x y = 1`。
- “一奇一偶” ↔ 两个模 `2` 条件的析取。
- “两直角边可交换” ↔ 一般分类公式中的两个析取分支。

# 依赖（人话版）

依赖整数 gcd、奇偶性和平方恒等式。一般与本原分类的深层反向论证复用 Mathlib 的
`PythagoreanTriple.classification` 与 `PythagoreanTriple.coprime_classification'`；
公开签名不暴露 Mathlib 的分类辅助谓词。

# 应用与陷阱

- 一般整数分类中的参数不唯一；`k` 的符号和参数符号会产生同一个三元组。
- 只说 `x,y` 互素还不足以固定参数方向，必须再指定哪条直角边为奇数以及斜边为正。
- 本原分类给出存在性和规范条件，不声称当前接口已经证明参数对逐字唯一。
