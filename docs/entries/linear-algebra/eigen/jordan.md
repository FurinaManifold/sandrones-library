---
id: linear-algebra.eigen.jordan
family: linear-algebra.eigen
variant: textbook
kind: theorem
state: verified
title: 广义特征空间与 Jordan 链
summary: 广义特征空间及其层级、Jordan 链与 Jordan 块的教材基础
premises: ["linear-algebra.eigen.diagonalization"]
mathlib: []
provenance:
  source_type: book
  ref: "horn-johnson-matrix-analysis-2013"
---

# linear-algebra.eigen.jordan

- **家族**: `linear-algebra.eigen`
- **变体**: textbook
- **状态**: verified
- **一句话**: 广义特征空间及其层级、Jordan 链与 Jordan 块的教材基础

## 陈述（教材记号）

本条目对应 `SandronesLibrary/LinearAlgebra/Jordan.lean`，只覆盖"Jordan 标准形之前可独立验证"的
教材基础：广义特征空间、Jordan 链与 Jordan 块。完整分解与标准形存在性在后续条目中完成。

**广义特征空间。**

- `generalizedEigenspace T μ k = {x | ((T - μI)^k) x = 0}`：属于 `μ` 的 `k` 阶广义特征子空间。
- `generalizedEigenspace_isSubspace`：它是子空间。
- `generalizedEigenspace_one`：`k = 1` 时回到通常的特征子空间 `eigenspace K T μ`。
- `generalizedEigenspace_mono`：`k ≤ l` 时 `generalizedEigenspace T μ k ⊆ generalizedEigenspace T μ l`。
- `generalizedEigenspace_stabilizes`：有限维时，从 `k = dim V` 起广义特征子空间不再变化。
- `span_generalizedEigenvectors_eq_univ`：代数闭域上，所有取到 `dim V` 阶的最大广义特征子空间共同张成全空间。

**Jordan 链与 Jordan 块。**

- `IsJordanChain T μ b`：长度 `m+1` 的链，链首非零特征向量，后继满足 `T (b_{j+1}) = μ • b_{j+1} + b_j`；
  不要求张成全空间。
- `IsJordanChainBasis T μ b`：链同时是全空间的一组基（`IsBasis`），递推关系同上；
  链首非零由基的线性无关性自动给出。
- `IsJordanBasisFamily T r μ length b`：`r` 条链合起来构成全空间的一组基，且每条都是 Jordan 链。
- `jordanBlock μ m`：大小 `m+1`、对角为 `μ`、上一次对角线为 `1` 的 Jordan 块。
- `jordanBlock_isUpperTriangular`：Jordan 块是上三角矩阵。
- `charpoly_jordanBlock`：该块特征多项式为 `(X - μ)^(m+1)`。

**链向量的湮灭与线性无关。**

- `jordanChain_power_annihilates` / `jordanChain_power_annihilates_general`：链（或链基）中第 `j` 个向量被 `(T-μI)^(j+1)` 湮灭。
- `jordanChain_init`：删去链的最后一个向量仍是 Jordan 链。
- `jordanChain_linearIndependent`：任意非零 Jordan 链中的向量线性无关。
- `jordanChain_power_top_eq_first`：链顶经 `m` 次 `T-μI` 恰降到链首。
- `jordanChain_power_top_eq_rev`：一般地，从链顶施加 `i` 次得逆序编号的第 `i` 个向量。
- `jordanChain_shifted_power_ne_zero`：链首非零，故 `(T-μI)^m ≠ 0`。
- `jordanChainBasis_shifted_power_eq_zero`：若链已是全空间基，则 `(T-μI)^(m+1) = 0`。
- `jordanChain_of_chainBasis`、`jordanChainBasis_linearIndependent`、`jordanChainBasis_spans`、
  `jordanChainBasis_iff`：链基与"基 + Jordan 链"的接口对应。
- `jordanChain_shifted_powers_linearIndependent`：`1, (T-μI), …, (T-μI)^m` 作为线性算子线性无关。

**矩阵表示与单块多项式。**

- `operatorMatrix_eq_jordanBlock`：Jordan 链基下算子矩阵恰为对应的 `jordanBlock μ m`。
- `characteristicPolynomial_eq_pow_of_jordanChainBasis`：单条链张成全空间时，特征多项式为 `(X-μ)^(m+1)`。
- `minimalPolynomial_shifted_eq_pow`：此时平移算子 `T-μI` 的最小多项式恰为 `X^(m+1)`。
- `minimalPolynomial_add_scalar_identity`：线性算子最小多项式的标量平移公式。
- `minimalPolynomial_eq_pow_of_jordanChainBasis`：单块算子的最小多项式与特征多项式相同，均为 `(X-μ)^(m+1)`。

**幂零前置。**

- `nilpotent_power_dim_eq_zero`：有限维幂零算子的 `dim V` 次幂必为零。
- `nilpotent_exists_nonzero_kernel_vector`：非平凡空间中幂零算子的核含非零向量。
- `nilpotent_exact_index_exists`：存在精确的首次归零次数 `m+1`（`N^(m+1)=0` 且 `N^m≠0`）。
- `jordanChain_exists_of_exact_nilpotency_index`：由该指数可构造长度 `m+1`、特征值为零的 Jordan 链。
- `nilpotent_exists_maximal_jordanChain`：幂零算子存在长度恰等于其幂零指数的最长 Jordan 链。
- `nilpotency_index_le_dim`：精确幂零指数不超过空间维数。

## 直觉

把特征子空间放大为"被 `(T-μI)^k` 杀掉"的广义特征子空间，就能容纳那些只差一个幂零部分的向量。
Jordan 链正是这种幂零行为的坐标写法：链首是特征向量，每往后一步 `T-μI` 只把它退回前一个向量。
一条链的向量必然线性无关，单块矩阵就是对角为 `μ`、紧邻上方为 `1` 的 Jordan 块。

## 依赖（人话版）

- 前提 Entry：`linear-algebra.eigen.diagonalization`（本文件直接 import 它，复用其特征子空间与特征多项式语言）。
- Mathlib：公开接口不依赖任何 Mathlib 专用名字；证明内部使用 `Module.End.genEigenspace` /
  `Module.End.maxGenEigenspace` 等模论结果。

## 实现说明

公开签名只使用本库教材记号：`LinearSpace`、`IsBasis`、`eigenspace`、`IsJordanChain`、
`IsJordanBasisFamily` 与多项式 `Polynomial K`。Mathlib 的模、子模与 `Module.End` 结构只作为私有
证明后端出现在证明体内（例如广义特征子空间的稳定与全空间分解），不进入公开定理签名。

## 应用与陷阱

- 本条目刻意停在"单条链 / 幂零前置"层面：把链组装成全空间基、把矩阵写成分块对角、以及标准形的存在
  与唯一性，分别属于后续条目，这里不重复声明。
- `IsJordanChain` 不假设张成或线性无关，而 `IsJordanChainBasis` 假设是基；`jordanChainBasis_iff`
  给出两者的精确关系，组装时避免循环使用过强前提。
- `charpoly_jordanBlock` 的指数是块大小 `m+1`，不是参数 `m`。
