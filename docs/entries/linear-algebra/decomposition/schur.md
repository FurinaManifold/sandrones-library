---
id: linear-algebra.decomposition.schur
kind: theorem
state: verified
title: Schur 分解
summary: 复方阵酉相似于上三角矩阵并给出实 Schur 块形式
premises: [linear-algebra.decomposition.qr]
mathlib: [InnerProductSpace.gramSchmidtOrthonormalBasis, Module.Basis.toMatrix_mul_toMatrix]
provenance: {source_type: textbook, ref: "Schur triangularization theorem"}
---

# 动机

Schur 分解把一般矩阵的谱问题化为保持内积的三角标准形。

# 直觉

先取得相似三角形，再对换基矩阵作 QR，从而把一般相似变换改造成酉相似变换。

# 陈述（自然语言）

任意复方阵酉相似于上三角矩阵；实方阵具有由一阶和二阶对角块组成的实 Schur 形式。

# 陈述（Lean 对照）

`ComplexSchurFactorization A` 保存酉因子、上三角因子及 `A=UTUᴴ` 证书。

# 思维脉络（thinking trace）

复情形组合 Jordan 三角形与 QR；实情形递归抽取至多二维不变子空间。

# 自然语言 ↔ Lean 映射

“酉相似”对应 `eq_mul_conjTranspose`，“上三角”对应 `upper_triangular`。

# 依赖（人话版）

依赖 QR、Jordan 相似标准形、特征值和正交补接口。

# 应用与陷阱

实矩阵不能总在实数域内三角化，因此必须保留二阶共轭特征值块。

