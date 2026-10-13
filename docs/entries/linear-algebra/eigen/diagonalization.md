---
id: linear-algebra.eigen.diagonalization
family: linear-algebra.eigen
variant: textbook
kind: theorem
state: verified
title: 特征基、重数与最小多项式
summary: 对角化的特征基判据、几何/代数重数不等式、Cayley-Hamilton 定理与最小多项式
premises: ["linear-algebra.coordinates.change-basis", "linear-algebra.eigen.charpoly"]
mathlib: ["LinearMap.finrank_eigenspace_le", "LinearMap.aeval_self_charpoly", "LinearMap.minpoly_dvd_charpoly"]
provenance:
  source_type: book
  ref: "axler-linear-algebra-2015"
---

# linear-algebra.eigen.diagonalization

- **家族**: `linear-algebra.eigen`
- **变体**: textbook
- **状态**: verified
- **一句话**: 对角化的特征基判据、几何/代数重数不等式、Cayley-Hamilton 定理与最小多项式

## 陈述（教材记号）

本条目对应 `SandronesLibrary/LinearAlgebra/Diagonalization.lean`，把有限维算子的对角化判据与多项式理论收在同一接口下。

**特征基与对角矩阵。**

- `IsEigenbasis T b`：`b` 是全空间的一组基，且存在特征值族 `μ : ι → K`，使每个基向量满足 `T (b i) = μ i • b i`。
- `operatorMatrix_eq_diagonal_of_eigenbasis`：若 `b` 是特征基，则存在 `μ` 使 `operatorMatrix b hb.1 T = Matrix.diagonal μ`。
- `eigenbasis_of_operatorMatrix_eq_diagonal`：反过来，若 `T` 在基 `b` 下的矩阵是对角矩阵，则 `b` 是特征基。
- `exists_eigenbasis_iff_exists_diagonal_matrix`：存在特征基，当且仅当存在一组基使算子矩阵为对角阵。

**特征子空间与两种重数。**

- `eigenspace_isSubspace`：特征子空间 `eigenspace K T μ` 是子空间。
- `geometricMultiplicity T μ`：几何重数，定义为 `eigenspace K T μ` 的维数。
- `characteristicPolynomial T`：特征多项式，即 `LinearMap.charpoly T`。
- `algebraicMultiplicity T μ`：代数重数，即 `μ` 作为 `characteristicPolynomial T` 根的重数。
- `geometricMultiplicity_le_algebraicMultiplicity`：几何重数不超过代数重数。

**Cayley–Hamilton 与最小多项式。**

- `cayleyHamilton T`：`Polynomial.aeval T (characteristicPolynomial T) = 0`，即特征多项式代入算子自身得到零算子。
- `minimalPolynomial T`：最小多项式，即 `minpoly K T`。
- `minimalPolynomial_aeval`：最小多项式代入算子后为零。
- `minimalPolynomial_dvd_characteristicPolynomial`：最小多项式整除特征多项式。
- `minimalPolynomial_dvd_of_aeval_eq_zero`：最小性——任意湮灭算子的多项式都被最小多项式整除。

## 动机

对角化问的是能否换一组基把算子写成最简形式。特征基把"简单"定义为对角矩阵，于是问题只剩
"线性无关特征向量是否够多"；几何重数与代数重数分别给出可从核空间直接读出的下界和可从特征多项式
读出的上界，二者的差距正好刻画不可对角化的程度。Cayley–Hamilton 与最小多项式则说明特征多项式
湮灭算子、最小多项式是所有湮灭多项式里次数最低者，为后续 Jordan 理论提供多项式侧的工具。

## 依赖（人话版）

- 前提 Entry：`linear-algebra.coordinates.change-basis`（提供 `operatorMatrix` 换基记号）、
  `linear-algebra.eigen.charpoly`（特征多项式）。
- Mathlib 仅在证明内部或命名包装中出现：`LinearMap.finrank_eigenspace_le` 用于重数不等式，
  `LinearMap.aeval_self_charpoly` 用于 Cayley–Hamilton，`LinearMap.minpoly_dvd_charpoly` 用于最小多项式整除特征多项式。

## 实现说明

公开签名只使用本库教材层的向量空间、基、维数、矩阵与多项式语言：`IsEigenbasis` 建立在
`IsBasis` 之上，几何重数走本库的子空间维数，`characteristicPolynomial` / `minimalPolynomial`
是 Mathlib `LinearMap.charpoly` / `minpoly` 的教材命名包装。Mathlib 的模与子模结构只在证明内部
使用（例如把 `eigenspace K T μ` 与 `Module.End.eigenspace T μ` 对齐，再调用
`LinearMap.finrank_eigenspace_le`），不进入公开定理签名。

## 应用与陷阱

- 几何重数 ≤ 代数重数是"可对角化当且仅当各特征子空间维数之和等于 `dim V`"的关键一步。
- 教材里 `χ_T(X) = det(XI - T)`；本条目只是给它一个教材名字，并未改换定义。
- `minimalPolynomial_dvd_characteristicPolynomial` 与 Cayley–Hamilton 相呼应：特征多项式湮灭算子，
  而最小多项式整除任意湮灭多项式。
