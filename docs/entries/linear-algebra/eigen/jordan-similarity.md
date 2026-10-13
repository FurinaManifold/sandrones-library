---
id: linear-algebra.eigen.jordan-similarity
family: linear-algebra.eigen
variant: textbook
kind: theorem
state: verified
title: 矩阵的 Jordan 相似标准型
summary: 代数闭域上每个方阵相似于 Jordan 标准矩阵；复方阵为其特例
premises: ["linear-algebra.eigen.jordan-normal-form"]
mathlib: ["LinearMap.toMatrix'_toLin'", "Matrix.reindex"]
provenance:
  source_type: book
  ref: "horn-johnson-matrix-analysis-2013"
---

# linear-algebra.eigen.jordan-similarity

- **家族**: `linear-algebra.eigen`
- **变体**: textbook
- **状态**: verified
- **一句话**: 代数闭域上每个方阵相似于 Jordan 标准矩阵；复方阵为其特例

## 陈述（教材记号）

本条目对应 `SandronesLibrary/LinearAlgebra/JordanSimilarity.lean`。

- `MatricesAreSimilar A B`：两个同阶矩阵相似，即存在互逆的换基矩阵 `P, Q`，满足
  `P * Q = 1`、`Q * P = 1` 且 `B = P * A * Q`。
- `matrix_is_similar_to_jordan`：设 `K` 代数闭，`A : Matrix (Fin n) (Fin n) K`，则存在 Jordan 数据
  `d` 与下标等价 `e`，使 `A` 相似于重编号后的标准矩阵：
  `MatricesAreSimilar A (Matrix.reindex e e (jordanNormalMatrix d))`。
- `complex_matrix_is_similar_to_jordan`：每个复方阵（`A : Matrix (Fin n) (Fin n) ℂ`）都有同样的
  Jordan 相似标准型，等于把上一条代数闭域结论实例化到 `ℂ`。

源码中另有一条 `private` 的换基引理 `operatorMatrix_reindex_basis`：按等价 `e` 重排基，只是把
`operatorMatrix` 用 `Matrix.reindex e e` 重编号，不作为公开 API。

## 直觉

线性算子在两组基下的矩阵互为相似，换基矩阵就是两组基之间的过渡矩阵。把矩阵看作 `A = Matrix.toLin'` 的
算子，套用代数闭域上的 Jordan 标准基存在性，再把标准基的索引重排成 `Fin n`，就得到"`A` 相似于某个
Jordan 标准矩阵"。复数是代数闭域，所以复方阵是特例。

## 依赖（人话版）

- 前提 Entry：`linear-algebra.eigen.jordan-normal-form`（代数闭域上算子的 Jordan 标准基存在性）。
- 复方阵特例依赖代数学基本定理给出的复数域代数闭性：源码 import 了
  `SandronesLibrary.Analysis.FundamentalTheoremAlgebra`，并用
  `SandronesLibrary.Analysis.Complex.complex_is_algebraically_closed` 安装 `IsAlgClosed ℂ`。
  该结果目前只有孤儿文档 `analysis.complex.fundamental-theorem-algebra`，因而不列入本条的 `premises`。
- Mathlib：`LinearMap.toMatrix'_toLin'`（标准基下矩阵与算子互逆）与 `Matrix.reindex`
  （重排索引的矩阵），二者都在源码的证明构造中实际出现。

## 实现说明

公开签名使用本库的 `LinearSpace`、`operatorMatrix`、`JordanFormData` 与自定义的
`MatricesAreSimilar`；标准基与 `Module.Basis` 的转换、`toMatrix'`/`toLin'` 互逆以及 `Matrix.reindex`
都只在证明体内部出现。换基矩阵由本库的 `transitionMatrix` 提供。

## 应用与陷阱

- 结论中的重编号等价 `e` 不可省：Jordan 块的索引类型与原矩阵下标 `Fin n` 不同，必须先重排。
- `MatricesAreSimilar` 同时给出 `P, Q` 及两个互逆等式与 `B = P * A * Q`，比只写"存在可逆 `P`"更强、也更便于组装。
- 复数实例依赖代数学基本定理；若换成一般域，需要显式假设 `[IsAlgClosed K]`。
