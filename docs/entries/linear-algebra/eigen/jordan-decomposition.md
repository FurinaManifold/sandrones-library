---
id: linear-algebra.eigen.jordan-decomposition
family: linear-algebra.eigen
variant: textbook
kind: theorem
state: verified
title: 幂零 Jordan 链分解
summary: 不变子空间上以像空间归纳构造幂零算子的完整 Jordan 链基
premises: ["linear-algebra.eigen.jordan"]
mathlib: []
provenance:
  source_type: book
  ref: "horn-johnson-matrix-analysis-2013"
---

# linear-algebra.eigen.jordan-decomposition

- **家族**: `linear-algebra.eigen`
- **变体**: textbook
- **状态**: verified
- **一句话**: 不变子空间上以像空间归纳构造幂零算子的完整 Jordan 链基

## 陈述（教材记号）

本条目对应 `SandronesLibrary/LinearAlgebra/JordanDecomposition.lean`。公开结论只有一条：

- `nilpotent_exists_jordanBasisFamily`：设 `V` 有限维、`N : V →ₗ[K] V` 幂零，则存在链数 `r`、
  长度 `length` 与向量族 `b`，使 `IsJordanBasisFamily N r (fun _ => 0) length b` 成立——
  即一族特征值全为零的 Jordan 链，其全部链向量合起来构成 `V` 的一组基。

支撑这条结论的不变子空间机制在源码中是 `private`（文件内可见、不属于公开 API）：

- `IsInvariantSubspace N S`、`invariantRestriction N S hS`：`N`-不变子空间与 `N` 在其上的限制。
- `invariantRestriction_coe_pow`：限制的 `n` 次幂与 `N` 的 `n` 次幂在环境空间中一致。
- `image_invariant`、`image_restriction_nilpotent`：像空间 `N(S)` 仍不变，且其上的限制仍幂零。
- `image_finrank_lt_of_nilpotent`：非平凡 `S` 上幂零限制的像维数严格小于 `S` 的维数——这是递归下降的度量。
- `IsJordanBasisFamilyForSubspace`、`jordanBasisFamilyForSubspace_mem`：把链族基限定到指定子空间 `S`。
- `jordanBasisFamily_chainFirsts_kernel_linearIndependent`：各链链首落在核中且线性无关。
- `invariantSubspace_decomposition_step_framework`：归纳步——分解像空间后逐链提升一个向量，
  再用核空间的一组基补齐链首与长度为一的新链。
- `nilpotent_invariantSubspace_decomposition_framework`：对不变子空间维数做良基递归，`termination_by` 为 `Module.finrank K S`。

## 直觉

幂零算子把空间逐层压低：`V ⊋ N(V) ⊋ N²(V) ⊋ …`。于是从最小的像空间开始分解，每上升一层，
就把已有链整体提升一个向量；提升不了的那部分恰好落在核里，各自成为长度为一的新链。所谓"像空间归纳"
就是这道逐层补齐的过程，最终每个向量都归入某条链的某个位置。

## 依赖（人话版）

- 前提 Entry：`linear-algebra.eigen.jordan`（Jordan 链、链族基与幂零前置结论）。
- Mathlib：公开接口不使用 Mathlib 专用名字；证明内部用到基的 `sumExtend`、像—核维数分解与
  有限维子空间的维数理论。

## 实现说明

唯一的公开签名 `nilpotent_exists_jordanBasisFamily` 只使用本库教材记号：`LinearSpace` 与
`IsJordanBasisFamily`。不变子空间、限制算子与子空间维数都属于 `private` 证明后端，不出现在公开 API 中。
引入它们的归纳框架是为可审核性保留的，教材读者只需知道"像空间归纳 + 核空间补齐"这一思路。

## 应用与陷阱

- 结论只保证存在一族零特征值 Jordan 链基，本身不涉及矩阵形式；把链族写成块对角矩阵是后续条目的事。
- 归纳是对不变子空间而非整个空间的维数做递归，`image_finrank_lt_of_nilpotent` 提供严格下降，
  否则递归不合法。
- `IsJordanBasisFamily N r (fun _ => 0) length b` 的特征值参数是常函数 `0`，因为此处 `N` 本身幂零。
