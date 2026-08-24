---
id: abstract-algebra.ring.ideal
family: abstract-algebra.ring
variant: rotman
kind: theorem
state: verified
title: 左理想、右理想与双边理想
summary: 以集合封闭性定义三类理想，并构造生成理想、理想和与理想积
premises: [abstract-algebra.ring.def]
mathlib: [Ideal, Ideal.span, Ideal.sup, Ideal.mul]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Ch 1（理想）
---

# 动机

子环描述在环运算下封闭的部分，而理想还要求吸收环境环的乘法。这个额外条件使理想成为
环同态的核，并为下一条目中的商环构造提供恰当输入。

# 直觉

左理想吸收左乘，右理想吸收右乘，双边理想同时满足两者。由集合 `S` 生成的双边理想，是
所有包含 `S` 的双边理想的交。理想和由逐项相加得到；理想积不是简单的两两乘积集合，
而是所有两两乘积所生成的双边理想。

# 陈述（自然语言）

本库逐项定义左、右与双边理想。任意集合生成的双边理想确为双边理想，包含原集合，并且
包含于每个含原集合的双边理想。两个双边理想的和仍为双边理想；交换环中，本库的理想
集合、理想和与理想积分别和 Mathlib 的 `Ideal`、上确界及乘积一致。

# 陈述（Lean 对照）

- `LeftIdealSet`、`RightIdealSet`、`TwoSidedIdealSet`：三类理想集合谓词。
- `generatedTwoSidedIdeal`、`generatedTwoSidedIdeal_is_ideal`、
  `generatedTwoSidedIdeal_least`：生成理想及其最小性。
- `idealSetSum`、`idealSetSum_is_ideal`：理想和及封闭性。
- `idealSetProduct`：由两两乘积生成的双边理想。
- `twoSidedIdealSet_iff_exists_ideal`：与 Mathlib `Ideal` 的承载桥。
- `idealSetSum_eq_mathlib_sup`、`idealSetProduct_eq_mathlib_mul`：运算桥。
- `ring_hom_ker_is_ideal`、`ring_hom_mem_range`：Mathlib 环同态核和值域兼容接口。

# 思维脉络（thinking trace）

先把左右吸收与加法子群条件写成普通集合谓词，再以任意交定义生成理想。这样最小性直接来自
交集的定义。和的封闭性逐项验证；积先取两两乘积集合，再调用生成理想，避免在非交换环中
错误地把未封闭的乘积集合称为理想。最后才证明与 Mathlib 打包结构一致。

# 自然语言 ↔ Lean 映射

| 数学语言 | Lean 接口 |
|---|---|
| 左理想 | `LeftIdealSet I` |
| 右理想 | `RightIdealSet I` |
| 双边理想 | `TwoSidedIdealSet I` |
| 集合生成的理想 `(S)` | `generatedTwoSidedIdeal S` |
| 理想和 `I+J` | `idealSetSum I J` |
| 理想积 `IJ` | `idealSetProduct I J` |
| Mathlib 理想承载 | `Ideal R`，仅用于兼容桥 |

# 依赖（人话版）

定义层只依赖集合、零元、加法、乘法与取负。`RingAxioms` 提供教材环公理；Mathlib
`Ideal` 仅在桥接和复用已有同态接口时出现。商同余与商环不属于本条目，见
`abstract-algebra.ring.quotient`。

# 应用与陷阱

- 非交换环中左理想与右理想不能混用；构造商环需要双边理想。
- 理想积必须补生成闭包，不能直接写成 `{x*y | x∈I, y∈J}`。
- `RingHom.ker f` 已经返回 `Ideal R`，无需再调用 `.toIdeal`。
- `Ideal` 是兼容承载，不应替代本库的教材定义层。
