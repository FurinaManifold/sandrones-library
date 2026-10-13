---
id: linear-algebra.eigen.jordan-normal-form
family: linear-algebra.eigen
variant: textbook
kind: theorem
state: verified
title: Jordan 标准基存在性
summary: 代数闭域上有限维算子的 Jordan 标准基存在性
premises: ["linear-algebra.eigen.jordan-block"]
mathlib: ["Module.End.maxGenEigenspace", "DirectSum.IsInternal.collectedBasis"]
provenance:
  source_type: book
  ref: "horn-johnson-matrix-analysis-2013"
---

# linear-algebra.eigen.jordan-normal-form

- **家族**: `linear-algebra.eigen`
- **变体**: textbook
- **状态**: verified
- **一句话**: 代数闭域上有限维算子的 Jordan 标准基存在性

## 陈述（教材记号）

本条目对应 `SandronesLibrary/LinearAlgebra/JordanNormalForm.lean`。

- `JordanFormData K`：Jordan 标准矩阵的有限块数据，字段为块类型 `Block`、`blockFintype`、
  特征值 `eigenvalue : Block → K` 与块参数 `length : Block → ℕ`（实际块大小为 `length i + 1`）。
- `jordanNormalMatrix d`：由 `d` 给出的 Jordan 标准矩阵，即各块 `jordanBlock (eigenvalue i) (length i)`
  按 `blockDiagonal'` 拼装成的
  `Matrix (Σ i : d.Block, Fin (d.length i + 1)) (Σ i : d.Block, Fin (d.length i + 1)) K`。
- `HasJordanNormalBasis T d`：存在一组基 `b`，使 `operatorMatrix b hb T = jordanNormalMatrix d`，
  即 `T` 在某组基下由数据 `d` 的标准矩阵表示。
- `exists_jordan_normal_basis`：代数闭域上，有限维线性算子 `T` 存在 Jordan 标准基：
  `∃ d : JordanFormData K, HasJordanNormalBasis T d`。

## 直觉

代数闭域保证每个特征值都能取到。把所有非零最大广义特征子空间取内部直和，它们正好拼成全空间；
在每个广义特征子空间上，`T - μI` 变成幂零算子，于是可以调用幂零算子的链族分解，得到该子空间内的
Jordan 链基。把所有局部链收集起来，就得到全空间的 Jordan 标准基。

## 依赖（人话版）

- 前提 Entry：`linear-algebra.eigen.jordan-block`（链族基与块对角矩阵的对应）。
- Mathlib：`Module.End.maxGenEigenspace`（最大广义特征子空间及其独立性/上确界结果）、
  `DirectSum.IsInternal.collectedBasis`（把各子空间的局部基收集成全空间基），二者都在源码的
  证明构造中实际出现。

## 实现说明

公开签名只使用本库教材记号：`LinearSpace`、`IsBasis`、`operatorMatrix`，以及本层新定义的
`JordanFormData` / `HasJordanNormalBasis`。Mathlib 的 `Module.End`、`DirectSum.IsInternal` 与
`collectedBasis` 只作为私有证明后端，出现在 `exists_jordan_normal_basis` 的证明体内，不进入结论。
局部幂零分解直接调用上一层已证的 `nilpotent_exists_jordanBasisFamily`。

## 应用与陷阱

- 存在性只给出"某个" `JordanFormData`；块没有规范顺序，字面上的矩阵相等一般不成立，唯一性要另立条目。
- 需要 `[IsAlgClosed K]`：没有代数闭性，特征值可能缺失，广义特征子空间不再张成全空间。
- `HasJordanNormalBasis` 的存在量词把基与矩阵等式打包在一起，使用时可一次解构出 `b`、`hb` 与矩阵等式。
