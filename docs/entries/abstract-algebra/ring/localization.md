---
id: abstract-algebra.ring.localization
family: abstract-algebra.ring
variant: textbook
kind: theorem
state: verified
title: 交换环的局部化与分式域
summary: 从乘法集和分式对构造局部化，证明泛性质并得到整环的分式域
premises: [abstract-algebra.ring.def, abstract-algebra.ring.domain, abstract-algebra.ring.divisibility]
mathlib: []
provenance:
  source_type: book
  ref: atiyah-macdonald-commutative-algebra-1969
---

# 动机

整数加入所有非零整数的逆得到有理数；一般交换环也可以只加入指定元素的逆。局部化把“允许哪些
元素作分母”编码为乘法集，是分式域、局部环和后续交换代数的共同基础。

# 直觉

一个局部化元素写成 `a/s`，其中 `s` 属于乘法集。若原环可能含零因子，`a/s=c/t` 不能简单定义为
`a*t=c*s`：还必须允许乘上某个许可分母 `u` 后差变为零。这个额外消去因子使关系具有传递性，
也恰好刻画规范映射可能产生的核。

# 陈述（自然语言）

本条目自建乘法集、分式对、一般交换环中正确的分式等价关系及其商类型，并在商上定义环运算。
规范映射把 `a` 送到 `a/1`，乘法集中的每个元素在局部化中可逆，每个局部化元素都有分式表示。
任何把许可分母送到单位元的环同态都唯一延拓到局部化。对整环取全部非零元为乘法集，所得环
满足本库域公理，因而是分式域。

# 陈述（Lean 对照）

- `MultiplicativeSet R`：乘法集的教材结构。
- `FractionPair S`、`fractionPairEquivalent S`：分式对及正确判等关系。
- `LocalizationRing S`、`localizationFraction`：自建局部化商类型及分式构造。
- `localizationRing_ringAxioms`：下降运算满足环公理。
- `localizationMap_denominator_is_unit`：许可分母的像可逆。
- `localizationRing_every_element_is_fraction`：每个元素都有分式表示。
- `localizationRing_universal_property`：局部化的存在唯一泛性质。
- `nonzeroMultiplicativeSet`、`fractionField_fieldAxioms`：整环分式域。

# 思维脉络（thinking trace）

先证明带消去因子的分式判等是等价关系，再分别验证加法、乘法和取负对代表元选择无关。环公理
全部下降到分式对并化为交换环恒等式。泛性质中，从目标环内分母像的本库 `UnitElement` 选择逆元，
定义 `f(a)·f(s)⁻¹`；判等关系保证其良定义，分式表示保证唯一性。分式域部分利用整环无零因子，
证明非零分式的分子非零，再交换分子分母构造逆元。

# 自然语言 ↔ Lean 映射

| 数学语言 | Lean 接口 |
|---|---|
| 乘法闭集 | `MultiplicativeSet R` |
| 分式 `a/s` | `localizationFraction S a s hs` |
| 局部化环 | `LocalizationRing S` |
| 规范映射 | `localizationMap S` |
| 延拓映射 | `localizationLift S f hf hunit` |
| 局部化泛性质 | `localizationRing_universal_property` |
| 整环的分式域 | `fractionField_fieldAxioms` |

# 依赖（人话版）

构造只依赖本库环同态、单位元素、整环公理和域公理。局部化类型、分式判等、环运算和泛性质均在
本库内直接构造；Mathlib 的 `Submonoid`、`Localization`、`IsLocalization` 与 `Algebra` 没有参与
公开签名或证明后端。

# 应用与陷阱

- 在含零因子的环中，不能删掉判等关系中的额外乘子 `u`。
- 一般局部化的规范映射未必单射；只有分母都是正则元时才能保证。
- 若乘法集含零，局部化会退化为零环，本构造仍保持良定义。
- 分式域结论需要本库整环公理；任意交换环对非零元局部化不一定得到域。
- 泛性质只断言对把全部许可分母送到单位元的环同态存在唯一延拓。
