---
id: abstract-algebra.group.normal
family: abstract-algebra.group
variant: rotman
kind: theorem
state: verified
title: 正规子群与商群
summary: 正规性的共轭与左右陪集刻画；核、逆像、满射像与交；商群运算及商映射泛性质
premises: [abstract-algebra.group.def]
mathlib: [Subgroup.Normal.conj_mem, normal_iff_eq_cosets, Subgroup.Normal.comap, Subgroup.Normal.map, QuotientGroup.ker_mk', QuotientGroup.lift, QuotientGroup.lift_mk', QuotientGroup.mk'_surjective]
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

H 正规 ⟺ 对任意 g，gHg⁻¹ ⊆ H（共轭不变）。等价地 `gH=Hg`。正规性使左陪集
乘法 `(aH)(bH)=abH` 良定义，从而 G/H 构成商群。同态核自动正规，这解释了正规子群
为什么正是能作为群同态“被压成单位元”的子群。

商群还满足泛性质：若 f 在 H 上取单位元，即 `H ≤ ker f`，则 f 唯一地分解为
`G → G/H → N`。这比逐项验证商群运算更能刻画 G/H 的数学意义。

## 陈述（教材记号）

`normal_conj_mem`：H 正规 ⟹ n ∈ H ⟹ g·n·g⁻¹ ∈ H。
`normal_iff_left_coset_eq_right_coset`：H 正规 ⟺ 对所有 g 有 gH=Hg。
`normal_mem_comm`：a·b ∈ H ⟹ b·a ∈ H。`normal_bot`/`normal_top`：⊥ 与 ⊤ 正规。
`kernel_is_normal`、`normal_comap`、`normal_map_of_surjective`、`normal_inf`：正规性的标准构造。
`quotient_mk_mul`/`quotient_mk_one`/`quotient_mk_inv`：商群投影是群同态（保乘/单位元/逆）。
`quotient_projection_kernel`：商投影的核是 H。
`quotientLift`、`quotientLift_mk`、`quotientLift_comp_projection`、`quotientLift_unique`：商映射泛性质。

## 依赖（人话版）

前提：abstract-algebra.group.def。mathlib 的 `H.Normal` 是 Subgroup 上的属性，
`Subgroup.Normal.conj_mem` 给出共轭封闭，`normal_iff_eq_cosets` 给左右陪集刻画。
`QuotientGroup.lift` 在核包含条件下构造下降同态，商投影的满射性给出唯一性。

## 应用与陷阱

- `H.Normal` 需要作为 typeclass 参数 `[nN : H.Normal]` 传给商群引理。
- 商群类型是 `G ⧸ H`，投影 `QuotientGroup.mk`（同余类）。
- 要定义从商群出发的同态，必须先证明 H 包含于原同态的核；仅证明 f 在某些代表元上相等不够。
- 正规子群的像只有在同态满射时自动正规；逆像不需要满射条件。
