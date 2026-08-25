---
id: linear-algebra.decomposition.qr
kind: theorem
state: verified
title: QR 分解
summary: 任意实方阵分解为正交矩阵与上三角矩阵的乘积
premises: [linear-algebra.inner-product, linear-algebra.matrix.orthogonal-unitary]
mathlib: [InnerProductSpace.gramSchmidtOrthonormalBasis, Module.Basis.toMatrix_mul_toMatrix]
provenance: {source_type: textbook, ref: "horn-johnson-matrix-analysis-2013"}
---

# 动机

QR 分解是正交化、最小二乘及后续 Schur 分解的基础。

# 直觉

对矩阵列作 Gram–Schmidt 得到正交基，原列在该基下的坐标组成上三角矩阵。

# 陈述（自然语言）

任意实方阵存在 `A=QR`，其中 `Q` 正交、`R` 上三角；非奇异时还可选正对角规范形式。

# 陈述（Lean 对照）

`QRFactorization A` 保存两个因子及三项证书，`exists_qr A` 给出其非空性。

# 思维脉络（thinking trace）

先把列视为欧氏空间向量，扩充为正交基，再用两次换基矩阵相乘恢复原矩阵。

# 自然语言 ↔ Lean 映射

正交因子对应 `qrQ`，上三角坐标对应 `qrR`，恢复恒等式对应 `qr_mul`。

# 依赖（人话版）

依赖内积空间 Gram–Schmidt 与本库正交矩阵接口。

# 应用与陷阱

奇异矩阵仍有非规范 QR；正对角与唯一性需要非奇异前提。
