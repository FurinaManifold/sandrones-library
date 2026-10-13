---
id: linear-algebra.vector-space.dimension
family: linear-algebra.vector-space
variant: ecnu
kind: theorem
state: verified
title: 维数
summary: 有限维时 dim V=0 当且仅当 V 是平凡空间；dim 与秩（基数）一致
premises: []
mathlib: ["Module.finrank_eq_rank", "Module.finrank_zero_iff"]
provenance:
  source_type: book
  ref: "axler-linear-algebra-2015"
---

# linear-algebra.vector-space.dimension

- **家族**: `linear-algebra.vector-space`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 有限维时 dim V=0 当且仅当 V 是平凡空间；dim 与秩（基数）一致。

## 直觉

维数衡量向量空间“有多少个自由方向”。零维空间只有零向量；非平凡空间至少有一维。
在有限维情形，按基的基数定义的维数与更一般的基数秩一致。

## 陈述（教材记号）

设 `V` 是域 `𝕜` 上的有限维向量空间：

1. `dim 𝕜 V = 0 ↔ Subsingleton V`（零维 ⟺ 平凡空间）；
2. `(dim 𝕜 V : Cardinal) = Module.rank 𝕜 V`（维数与基数秩一致）。

对应 Lean 声明 `dim_eq_zero_iff_subsingleton` 与 `dim_eq_rank`，均为公开定理。

## 依赖（人话版）

前提：无；mathlib: `Module.finrank_zero_iff`, `Module.finrank_eq_rank`。

## 应用与陷阱

两条定理都必须带有限维假设 `[IsFiniteDimensional 𝕜 V]`：mathlib 把无限维空间的
`finrank` 按约定取为 0，因此无限维非平凡空间也满足 `dim = 0`，此时
“零维 ⟺ 平凡”不成立。`dim` 是非计算别名，使用处需标 `noncomputable`。
