---
id: linear-algebra.eigen.jordan-block
family: linear-algebra.eigen
variant: textbook
kind: theorem
state: verified
title: Jordan 链基的块对角矩阵
summary: Jordan 链族基下算子矩阵等于相应 Jordan 块的块对角矩阵
premises: ["linear-algebra.eigen.jordan-decomposition"]
mathlib: ["Matrix.blockDiagonal'"]
provenance:
  source_type: book
  ref: "horn-johnson-matrix-analysis-2013"
---

# linear-algebra.eigen.jordan-block

- **家族**: `linear-algebra.eigen`
- **变体**: textbook
- **状态**: verified
- **一句话**: Jordan 链族基下算子矩阵等于相应 Jordan 块的块对角矩阵

## 陈述（教材记号）

本条目对应 `SandronesLibrary/LinearAlgebra/JordanMatrix.lean`，把抽象的 Jordan 链族基转化为教材中的
块对角 Jordan 矩阵。

- `operatorMatrix_eq_blockDiagonal_jordan`：若 `b` 按 `(链号, 链内位置)` 展平后是 `V` 的基，
  且每条 `b i` 都是属于 `μ i` 的 Jordan 链，则
  `operatorMatrix b hb.1 T = Matrix.blockDiagonal' (fun i => jordanBlock (μ i) (length i))`。
- `nilpotent_operator_has_jordan_matrix`：设 `N` 有限维幂零，则存在链数、长度与向量族，
  使这些零特征值 Jordan 链构成基，且 `N` 在该基下的矩阵是零特征值 Jordan 块的块对角矩阵。

## 直觉

如果沿对角把各条 Jordan 链的坐标块摆好，链内的"退回前一个向量"只会落在同一个对角块内，
不同链之间不发生耦合，于是整张矩阵自然块对角。每个对角块正是 `jordanBlock`。

## 依赖（人话版）

- 前提 Entry：`linear-algebra.eigen.jordan-decomposition`（幂零算子的链族基存在性，第二个结论直接调用它）。
- Mathlib：`Matrix.blockDiagonal'`（块对角矩阵的构造；源码在结论与证明中使用同名 Mathlib 对象）。

## 实现说明

公开签名使用本库的 `LinearSpace`、`IsBasis`、`IsJordanBasisFamily` / `IsJordanChain` 与
`operatorMatrix` 记号，块对角由 Mathlib 的 `Matrix.blockDiagonal'` 承载。`IsBasis` 与
`Module.Basis` 之间的转换只在证明体内部发生，不出现在结论中。

## 应用与陷阱

- 展平后必须是一组真正的基；仅有"逐条是 Jordan 链"不足以得到块对角矩阵。
- `jordanBlock (μ i) (length i)` 的大小是 `length i + 1`，与 `Fin (length i + 1)` 的索引一致。
- 第二个结论只处理幂零算子（特征值恒为 `0`），一般算子的标准形需要先按广义特征空间分解。
