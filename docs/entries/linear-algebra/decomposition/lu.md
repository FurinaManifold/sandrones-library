---
id: linear-algebra.decomposition.lu
family: linear-algebra.decomposition
variant: textbook
kind: theorem
state: verified
title: LU 与 LDU 分解
summary: LU/LDU/PLU 主元分解的存在性与唯一性、无换行主元条件与块分解
premises: [linear-algebra.elimination.row-reduction]
mathlib: ["Matrix.fromBlocks", "Matrix.fromBlocks_eq_of_invertible₁₁", "Matrix.IsLowerTriangular", "Matrix.IsUpperTriangular", "Matrix.det"]
provenance:
  source_type: book
  ref: "horn-johnson-matrix-analysis-2013"
---

# linear-algebra.decomposition.lu

## 动机

高斯消元在矩阵层面就是三角分解：把矩阵写成单位下三角、对角（或单位上三角）与
上三角因子的乘积。LU/LDU 分解把消元过程固化下来，PLU 分解再用换行处理主元为零的
情形。它们也是求逆、解线性方程组与计算行列式的基础。

## 直觉

无换行的 LU 分解每一步要用左上角主元消去下方元素；只要顺序主子式都不为零，这些
主元就都可逆，消元可以一路走到底。若某步主元为零，就先交换行把非零元换上来，
于是得到 `PA = LU`。唯一性来自“单位下三角 × 对角非零上三角”这种规范形式本身没有
多余自由度。

## 陈述（教材记号）

本模块把分解写成数据证书，三角性与对角条件分别由构造定理给出：

- `LUFactorization A`：因子 `lower, upper` 与 `A = lower * upper`；
- `LDUFactorization A`：因子 `lower, diagonal, upper` 与 `A = lower * diagonal * upper`；
- `PLUFactorization A`：置换 `permutation`、因子 `lower, upper`、下/上三角性、
  `lower` 单位对角，以及 `permutation.permMatrix * A = lower * upper`；
- `NormalizedLUFactorization A`：单位下三角 `lower`、对角非零上三角 `upper` 且
  `A = lower * upper`。

主要定理：

1. **PLU 存在**：可逆方阵存在 PLU 分解（`existsPLU`，前提 `IsUnit A.det`）；
2. **LU 唯一**：单位下三角 `L` 与对角非零上三角 `U` 的分解在因子层面唯一（`lu_unique`）；
3. **LDU 唯一**：`L` 单位下三角、`U` 单位上三角、`d` 对角非零时，`LDU` 唯一（`ldu_unique`）；
4. **规范 LU 唯一**：同一矩阵的两个 `NormalizedLUFactorization` 因子相同（`normalizedLU_unique`）；
5. **无换行主元条件**：递归条件 `NoPivotCondition` 每一步 Schur 补的主元非零
   （`exists_normalizedLU_of_noPivot`）；
6. **教材判据**：所有非空顺序主子式非零（`LeadingPrincipalNonzero`）当且仅当存在
   规范 LU 分解（`noPivot_iff_leadingPrincipalNonzero`、
   `leadingPrincipalNonzero_iff_exists_normalizedLU`）；
7. **非奇异推论**：规范 LU 或非零主元条件都推出 `A.det ≠ 0`
   （`NormalizedLUFactorization.det_ne_zero`、`det_ne_zero_of_noPivot`）；
8. **块分解**：当左上块可逆时，`Matrix.fromBlocks A B C D` 有 Schur 补形式的块 LDU
   分解 `blockLDU`，其中对角块为 `D - C * A⁻¹ * B`；其因子分别是块下三角、块对角、
   块上三角（`blockLDU_isBlockLowerTriangular` 等），合并后两个因子即得块 LU
   （`blockLU`）。

## 依赖（人话版）

依赖初等行变换、行等价与高斯消元的存在性，因此库内前提为
`linear-algebra.elimination.row-reduction`。数学上还要用行列式、Schur 补和分块矩阵
乘法，它们由 Mathlib 提供。

## 实现说明

结构与定理位于 `SandronesLibrary.LinearAlgebra.MatrixDecomposition`。PLU 的构造是
对阶数递归：先用可逆行列式选出首主元、换行，作 Schur 补 `D - C * A⁻¹ * B`，再对
缩小一阶的补递归（`firstColumn_nonzero`、`pivotStep_schur_isUnit`、`assembleLower`/
`assembleUpper`、`recursive_block_product`）。`LDUFactorization` 与 `LUFactorization`
只打包因子与乘积等式，三角性不内嵌于结构，以便同一结构也用于分块矩阵；对具体构造
由 `blockLDU_isBlock*` 一类的定理补上。顺序主子式判据的证明通过
`leadingPrincipal_succ_det` 把 `(k+1)` 阶顺序主子式化为“首主元 × Schur 补的顺序
主子式”，再用归纳得到。

诚实边界：一般（不可逆）方阵的 LU 存在性需要换行，本模块只给出可逆情形的 PLU
存在定理与由顺序主子式刻画的无换行 LU；并未声称任意矩阵都有无换行 LU。
