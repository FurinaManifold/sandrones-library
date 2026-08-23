---
id: linear-algebra.vector-space.sum-quotient
family: linear-algebra.vector-space
variant: textbook
kind: theorem
state: verified
title: 子空间和、直和与商空间维数
summary: 子空间和与交的维数公式、直和维数公式及商空间维数公式
premises: [linear-algebra.vector-space.subspace, linear-algebra.vector-space.dimension]
mathlib: ["Submodule.finrank_sup_add_finrank_inf_eq", "Submodule.finrank_quotient_add_finrank"]
provenance:
  source_type: textbook
  ref: "本科线性代数：子空间的和、直和与商空间"
---

# linear-algebra.vector-space.sum-quotient

- **家族**: `linear-algebra.vector-space`
- **状态**: verified
- **一句话**: 子空间的和、交、直和与商空间满足标准维数公式。

## 陈述（教材记号）

对有限维向量空间 `V` 的子空间 `W,U`：

1. `W+U` 与 `W∩U` 仍是子空间；
2. `dim W + dim U = dim(W+U) + dim(W∩U)`；
3. 若 `W∩U={0}`，则 `dim(W⊕U)=dim W+dim U`；
4. `dim(V/W)+dim W=dim V`。

## 实现说明

代码公开接口把子空间表示为满足 `IsSubspace` 的集合，并通过 `subspaceDim`、
`quotientDim` 暴露教材数值。mathlib 的子模和商模只在证明内部使用。
