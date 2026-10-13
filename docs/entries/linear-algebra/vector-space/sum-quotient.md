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
  source_type: book
  ref: "axler-linear-algebra-2015"
---

# linear-algebra.vector-space.sum-quotient

- **家族**: `linear-algebra.vector-space`
- **状态**: verified
- **一句话**: 子空间的和、交、直和与商空间满足标准维数公式。

## 动机

子空间的和、交、直和与商空间是有限维线性代数的基本运算；它们把大空间的维数
拆解成小块维数，是秩—零化度等计数论证的工具。

## 直觉

两个子空间相加时，共同的向量被重复计数了一次，所以维数之和要减去交的维数。
若相交只有零向量，重复项消失，和就是直和，维数直接相加。商空间把整个子空间
压成一个点，剩下恰好是被压掉维度之外的部分。

## 陈述（教材记号）

对有限维向量空间 `V` 的子空间 `W,U`：

1. `W+U` 与 `W∩U` 仍是子空间；
2. `dim W + dim U = dim(W+U) + dim(W∩U)`；
3. 若 `W∩U={0}`，则 `dim(W+U)=dim W+dim U`；
4. `dim(V/W)+dim W=dim V`。

直和条件在本库中记作 `IsDirectSum W U`，等价于“`W` 与 `U` 的公共向量只有零向量”。

## 依赖（人话版）

依赖子空间的定义与有限维空间的维数。库内前提为 `linear-algebra.vector-space.subspace`
与 `linear-algebra.vector-space.dimension`；Mathlib 的 `Submodule` 只作为证明后端。

## 实现说明

公开接口把子空间表示为满足 `IsSubspace` 的集合，并通过 `subspaceDim`、`quotientDim`
暴露教材数值；`subspaceSum` 与 `subspaceIntersection` 分别给出和与交。四条维度结论
对应 `subspaceSum_isSubspace`、`subspaceIntersection_isSubspace`、
`subspaceDim_add_subspaceDim`、`subspaceDim_directSum` 与 `quotientDim_add_subspaceDim`。
证明内部把 `IsSubspace` 集合转成 `Submodule`，再调用 Mathlib 的维数公式，但类型
`Submodule` 不出现在公开签名中。
