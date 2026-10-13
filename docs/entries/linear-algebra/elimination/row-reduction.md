---
id: linear-algebra.elimination.row-reduction
family: linear-algebra.elimination
variant: textbook
kind: theorem
state: verified
title: 初等行变换与高斯消元
summary: 初等行变换、行等价、行阶梯形存在性与秩等于主元个数
premises: []
mathlib: ["Matrix.swap", "Matrix.transvection", "Matrix.IsRowEchelon", "Matrix.rank_mul_eq_right_of_det_ne_zero"]
provenance:
  source_type: book
  ref: "horn-johnson-matrix-analysis-2013"
---

# linear-algebra.elimination.row-reduction

## 动机

高斯消元是线性代数的计算核心：用初等行变换把矩阵化成行阶梯形，从而读出主元、
秩和方程组的解。本模块把三类初等行变换、行等价关系和消元算法都形式化，并证明
消元不改变秩、最终主元个数恰为秩。

## 直觉

初等行变换（交换两行、把一行的倍数加到另一行、用非零数缩放一行）都相当于左乘
一个可逆矩阵，所以不改变行空间，也不改变秩。反复用主元把该列下方的元素消成零，
并逐列向右推进，就能把一个有限矩阵变成行阶梯形；阶梯形中非零行数（主元个数）
就是秩。

## 陈述（教材记号）

三类初等行变换：

- `swapRows A i j = Matrix.swap K i j * A`：交换第 `i,j` 行；
- `addRowMultiple A i j c = Matrix.transvection i j c * A`：把第 `j` 行的 `c` 倍加到
  第 `i` 行（`i≠j` 时是初等变换）；
- `scaleRow A i c = (1.updateRow i (c • 1 i)) * A`：第 `i` 行乘以 `c`。

主要结论：

1. 各变换的逐项行为由 `swapRows_apply_*`、`addRowMultiple_apply_*`、
   `scaleRow_apply_*` 给出；两次交换、加相反倍数分别抵消
   （`swapRows_swapRows`、`addRowMultiple_neg`）；
2. 三类变换都不改变秩：`rank_swapRows`、`rank_addRowMultiple`、`rank_scaleRow`；
3. `RowEquivalent` 是由有限次初等行变换生成的最小等价关系，`rowEquivalentSetoid`
   证明它是等价关系，`RowEquivalent.rank_eq` 说明行等价矩阵的秩相同；
4. `exists_rowEchelon`：任意有限矩阵行等价于一个行阶梯形矩阵（并给出主元位置函数
   与 `IsPivotedBy` 证书）；
5. `exists_rowEchelon_with_rank`：消元同时给出秩公式——原矩阵的秩等于阶梯形矩阵
   的主元个数；
6. `rank_eq_pivot_count`：给定 `Echelon.Decomposition` 证书时，秩等于主元个数。

## 依赖（人话版）

本模块从矩阵与行列式出发自足建立消元理论，不依赖库内其他 Entry，故前提为空。
数学上用到矩阵交换、平延（transvection）、行阶梯形与秩，这些由 Mathlib 提供。

## 实现说明

定义位于 `SandronesLibrary.LinearAlgebra.MatrixElimination`。`IsRowEchelon` 直接复用
Mathlib 的 `Matrix.IsRowEchelon`；`RowEquivalent` 是一个归纳谓词，生成元恰为三类
初等变换，因而行等价不引入额外关系。存在性证明 `fin_exists_rowEchelon` 对行数加
列数做强归纳：若首列全零则删列递归，否则先用 `prepare_pivot` 取非零主元、消去
该列其余元素，再对去掉首行首列的子矩阵递归（`clearRows`、`clearColumn`、
`adjoinPivot`、`prependZeroColumn` 等辅助构造与 `rowEquivalent_*` 引理保证每一步都
保持行等价）。秩公式由阶梯形的主元计数引理与 `RowEquivalent.rank_eq` 拼合而来。
另备 `exists_diagonal_reduction`：方阵可用有限次加行倍数与加列倍数化为对角矩阵，
是后续 LU/PLU 构造的代数前置。

诚实边界：消元算法的递归终止由“行数 + 列数”的强归纳保证；文档只陈述存在性，
不给出算法复杂度的任何断言。
