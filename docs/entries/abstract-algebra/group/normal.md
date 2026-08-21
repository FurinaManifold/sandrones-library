---
id: abstract-algebra.group.normal
family: abstract-algebra.group
variant: rotman
kind: theorem
state: verified
title: 正规子群与商群
summary: 正规⟹共轭封闭与交换性；平凡/全子群正规；商群投影保乘法/单位元/逆
premises: [abstract-algebra.group.def]
mathlib: [Subgroup.Normal.conj_mem, Subgroup.normal_bot, Subgroup.normal_top, QuotientGroup.mk_mul, QuotientGroup.mk_one, QuotientGroup.mk_inv]
provenance:
  source_type: book
  ref: Rotman, An Introduction to the Theory of Groups, Ch 2（正规子群/商群）
---

# abstract-algebra.group.normal

- **家族**: `abstract-algebra.group`
- **变体**: rotman
- **状态**: verified
- **一句话**: 正规子群是"共轭稳定"的子群，商群因此有良定义的群运算。

## 直觉

H 正规 ⟺ 对任意 g，gHg⁻¹ ⊆ H（共轭不变）。等价地 n ∈ H、任意 g 时 g·n·g⁻¹ ∈ H。
正规性使左陪集乘法 (aH)(bH) = abH 良定义，从而 G/H 构成商群。

## 陈述（教材记号）

`normal_conj_mem`：H 正规 ⟹ n ∈ H ⟹ g·n·g⁻¹ ∈ H。
`normal_mem_comm`：a·b ∈ H ⟹ b·a ∈ H。`normal_bot`/`normal_top`：⊥ 与 ⊤ 正规。
`quotient_mk_mul`/`quotient_mk_one`/`quotient_mk_inv`：商群投影是群同态（保乘/单位元/逆）。

## 依赖（人话版）

前提：abstract-algebra.group.def。mathlib 的 `H.Normal` 是 Subgroup 上的属性，
`Subgroup.Normal.conj_mem` 给出共轭封闭，`QuotientGroup.mk_*` 系列是商群投影的运算保持。

## 应用与陷阱

- `H.Normal` 需要作为 typeclass 参数 `[nN : H.Normal]` 传给商群引理。
- 商群类型是 `G ⧸ H`，投影 `QuotientGroup.mk`（同余类）。
