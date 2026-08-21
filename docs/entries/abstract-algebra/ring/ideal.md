---
id: abstract-algebra.ring.ideal
family: abstract-algebra.ring
variant: rotman
kind: theorem
state: verified
title: 理想与商环
summary: 理想判定定理；理想左/右吸收乘法；含单位元理想=全环；商环判等 x-y∈I；环同态核是理想/值域刻画
premises: [abstract-algebra.ring.def]
mathlib: [Ideal, Ideal.mul_mem_left, Ideal.mul_mem_right, Ideal.eq_top_of_isUnit_mem, Ideal.Quotient.eq, RingHom.ker, RingHom.range]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Ch 1（理想/商环）
---

# abstract-algebra.ring.ideal

- **家族**: `abstract-algebra.ring`
- **变体**: rotman
- **状态**: verified
- **一句话**: 理想是"吸收乘法"的加法子群；商环 R/I 的判等由差落 I 决定。

## 直觉

理想 I 是含 0、对加法封闭、且被 R 中任意元素"吸收"（x ∈ I ⟹ a·x、x·a ∈ I）的加法子群。
商环 R/I 中两个同余类相等 ⟺ 差落在 I 中。环同态核是理想。

## 陈述（教材记号）

`ideal_of_closed`：I 含 0 + 加法封闭 + 右吸收 ⟹ 理想。
`ideal_mul_mem_left`/`ideal_mul_mem_right`：吸收乘法。
`ideal_eq_top_of_unit_mem`：含单位元的理想 = 全环。
`quotient_eq_iff_sub_mem`：mk x = mk y ⟺ x - y ∈ I。
`ring_hom_ker_is_ideal`：环同态核是理想。`ring_hom_mem_range`：值域刻画。
`ring_hom_injective_iff_ker_bot`：单射 ⟺ 核平凡。

## 依赖（人话版）

前提：abstract-algebra.ring.def。mathlib 的 `Ideal` 是 `Submodule R R`（吸收乘法即 smul）；
`Ideal.Quotient.mk` 是商环投影，`Ideal.Quotient.eq` 给判等准则；`RingHom.ker : Ideal R`（已是理想）。

## 应用与陷阱

- `RingHom.ker f` 返回 `Ideal R`（不是 Subgroup！），不要再 `.toIdeal`。
- 商环投影 `Ideal.Quotient.mk I` 需要 `[I.IsTwoSided]`。
