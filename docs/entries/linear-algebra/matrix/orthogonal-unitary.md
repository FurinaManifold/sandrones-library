---
id: linear-algebra.matrix.orthogonal-unitary
kind: theorem
state: verified
title: "正交矩阵与酉矩阵"
premises: ["linear-algebra.inner-product", "linear-algebra.det.mul"]
mathlib: ["Matrix.mem_unitaryGroup_iff", "Matrix.mem_orthogonalGroup_iff", "Matrix.det_of_mem_unitary", "Unitary.star_mem"]
provenance:
  source_type: book
  ref: "horn-johnson-matrix-analysis-2013"
---

# 动机

正交矩阵与酉矩阵是保持实、复内积的换坐标矩阵，也是 QR、Schur、SVD 等分解的基本因子。

# 直觉

矩阵的列向量构成标准正交组，当且仅当转置（复数情形为共轭转置）乘自身等于单位阵。

# 陈述（自然语言）

教材定义与正交群、酉群成员条件等价；酉矩阵对乘法和共轭转置封闭。酉矩阵行列式
模长为一，实正交矩阵行列式只能为 `1` 或 `-1`。

# 陈述（Lean 对照）

定义为 `IsUnitaryMatrix`、`IsOrthogonalMatrix`；主要结论为 `unitary_mul`、
`unitary_conjTranspose`、`unitary_det_norm` 与 `orthogonal_det`。

# 思维脉络（thinking trace）

先把单侧单位乘积连接到 mathlib 的酉群与正交群，再利用群封闭性和星运算封闭性；
行列式结论由行列式保持乘法及共轭转置推出。

# 自然语言 ↔ Lean 映射

- 共轭转置 ↔ `Aᴴ`；转置 ↔ `Aᵀ`。
- 酉群 ↔ `Matrix.unitaryGroup`；正交群 ↔ `Matrix.orthogonalGroup`。

# 依赖（人话版）

依赖矩阵乘法、转置、共轭转置、行列式和复数范数。

# 应用与陷阱

复酉矩阵必须使用共轭转置，不能只用普通转置。行列式模为一不反推矩阵酉。
