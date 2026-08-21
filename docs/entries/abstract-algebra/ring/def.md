---
id: abstract-algebra.ring.def
family: abstract-algebra.ring
variant: rotman
kind: theorem
state: verified
title: 子环判定与基本性质
summary: 子环判定定理（含0/1+加减乘封闭⟹子环）；子环含1与0；外延性；平凡子环；全子环；环同态保运算
premises: []
mathlib: [Subring, Subring.ext, Subring.one_mem, Subring.zero_mem, Subring.mem_bot, Subring.mem_top, RingHom]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Ch 1（子环）
---

# abstract-algebra.ring.def

- **家族**: `abstract-algebra.ring`
- **变体**: rotman
- **状态**: verified
- **一句话**: 子集是子环 ⟺ 含 0/1、对加减乘封闭。

## 直觉

环 R 的子集 S 要是子环，需含加法零元与乘法单位元、对加减乘封闭（减 = 加负，故负封闭由加法+乘含 1 推出）。
mathlib 的 `Subring` 承载"子环"概念。

## 陈述（教材记号）

`subring_of_closed`：S 含 0/1 + 加减乘封闭 ⟹ 存在子环 T 恰以 S 为元素集。
`subring_one_mem`/`subring_zero_mem`：1、0 ∈ S。
`subring_ext`：元素集相同的子环相等。`subring_bot`：平凡子环（n·1 形式）。
`subring_top`：全子环。`ring_hom_map_one/add/mul`：环同态保运算。

## 依赖（人话版）

前提：无。mathlib 用 `Subring.mk`（Subsemiring + 负封闭）构造子环；`Subring.ext` 外延性；
`Subring.mem_bot` 平凡子环（元素是 ℤ 嵌入）；`RingHom` 是环同态。

## 应用与陷阱

- `Subring.mem_bot` 的 n 是 ℤ（不是 ℕ），写 `∃ n : ℤ, (n : R) = x`。
- 子环判定强调"含 1"——这区别于理想（理想含 0 即可）。
