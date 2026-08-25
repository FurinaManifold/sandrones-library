---
id: linear-algebra.matrix.symplectic
kind: theorem
state: verified
title: "辛矩阵与辛群"
premises: ["linear-algebra.matrix.orthogonal-unitary"]
mathlib: ["Matrix.J", "Matrix.symplecticGroup", "SymplecticGroup.det_eq_one"]
provenance:
  source_type: book
  ref: "mcd-salamon-symplectic-topology-2017"
---

# 动机

辛矩阵是保持标准辛形式的线性变换矩阵，是 Hamilton 力学、辛几何以及正则变换的
线性代数基础。

# 直觉

标准辛矩阵为 `J=[[0,-I],[I,0]]`。矩阵 `A` 是辛矩阵，正是说变量替换后双线性形式
`xᵀJy` 不变，即 `AᵀJA=J`。

# 陈述（自然语言）

标准辛矩阵斜对称并满足 `J²=-I`。单位矩阵是辛矩阵；辛矩阵对乘法和求逆封闭，且
逆矩阵满足 `A⁻¹=-JAᵀJ`。每个实辛矩阵的行列式都等于 `1`。

# 陈述（Lean 对照）

对应 `standardJ`、`IsSymplecticMatrix`、`standardJ_transpose`、`standardJ_sq`、
`mul_isSymplectic`、`inverse_formula`、`inv_isSymplectic` 与 `det_eq_one`。

# 思维脉络（thinking trace）

先用 `SymplecticGroup.mem_iff'` 对齐教材条件和 mathlib 辛群。群运算结论随后由辛群
接口得到；逆矩阵使用标准矩阵 `J²=-I`，行列式为一调用 mathlib 对一般交换环证明的
辛群行列式定理。

# 自然语言 ↔ Lean 映射

- 标准辛矩阵 ↔ `standardJ`。
- 保持辛形式 ↔ `IsSymplecticMatrix A`。
- 辛逆矩阵 ↔ `(-standardJ) * Aᵀ * standardJ`。

# 依赖（人话版）

依赖矩阵乘法、转置、行列式和 mathlib 的辛群接口。

# 应用与陷阱

mathlib 辛群的原始定义写成 `AJAᵀ=J`，但其 `mem_iff'` 正好给出教材常用的
`AᵀJA=J`。两式对辛矩阵等价，不应在接口桥接时混淆转置的位置。
