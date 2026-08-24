---
id: abstract-algebra.ring.ideal
family: abstract-algebra.ring
variant: rotman
kind: theorem
state: verified
title: 理想与商环
summary: 本库定义左、右、双边理想及理想和、积、生成理想；并桥接商环判等、核与值域
premises: [abstract-algebra.ring.def]
mathlib: [Ideal, Submodule.mem_sup, Ideal.mul_le, Ideal.Quotient.eq, RingHom.ker, RingHom.range]
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

本库不把 `Ideal` 当作理想的定义。`LeftIdealSet` 与 `RightIdealSet` 分别陈述左右吸收，
`TwoSidedIdealSet` 要求两者同时成立。理想和由逐项相加定义；理想积是所有两两乘积生成的
最小双边理想，因此在非交换环中也不丢失双侧吸收。Mathlib `Ideal` 仅在桥接定理之后承担实现。

## 陈述（教材记号）

`LeftIdealSet`、`RightIdealSet`、`TwoSidedIdealSet`：本库教材定义。
`generatedTwoSidedIdeal`、`idealSetSum`、`idealSetProduct`：生成、和与积。
`generatedTwoSidedIdeal_is_ideal` 与 `generatedTwoSidedIdeal_least`：生成理想确为最小双边理想。
`twoSidedIdealSet_iff_exists_ideal`：交换环中与 Mathlib `Ideal` 的承载桥。
`idealSetSum_eq_mathlib_sup`、`idealSetProduct_eq_mathlib_mul`：运算桥。
`ideal_of_closed`：旧 Mathlib 打包接口，供实现层兼容。
`ideal_mul_mem_left`/`ideal_mul_mem_right`：吸收乘法。
`ideal_eq_top_of_unit_mem`：含单位元的理想 = 全环。
`quotient_eq_iff_sub_mem`：mk x = mk y ⟺ x - y ∈ I。
`ring_hom_ker_is_ideal`：环同态核是理想。`ring_hom_mem_range`：值域刻画。
`ring_hom_injective_iff_ker_bot`：单射 ⟺ 核平凡。

## 依赖（人话版）

前提：abstract-algebra.ring.def。定义层只使用集合与环运算。证明与现有生态互操作时，
`Ideal` 承载双边理想数据，`Ideal.Quotient.mk` 承载商映射，`RingHom.ker` 承载同态核。

## 应用与陷阱

- `RingHom.ker f` 返回 `Ideal R`（不是 Subgroup！），不要再 `.toIdeal`。
- 商环投影 `Ideal.Quotient.mk I` 需要 `[I.IsTwoSided]`。
