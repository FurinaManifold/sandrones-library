---
id: linear-algebra.eigen.jordan-uniqueness
family: linear-algebra.eigen
variant: textbook
kind: theorem
state: verified
title: Jordan 标准形的唯一性
summary: 广义核维数序列恢复每种 Jordan 块的重数，标准形在块重编号下唯一
premises: ["linear-algebra.eigen.jordan-similarity"]
mathlib: []
provenance:
  source_type: book
  ref: "horn-johnson-matrix-analysis-2013"
---

# linear-algebra.eigen.jordan-uniqueness

- **家族**: `linear-algebra.eigen`
- **变体**: textbook
- **状态**: verified
- **一句话**: 广义核维数序列恢复每种 Jordan 块的重数，标准形在块重编号下唯一

## 陈述（教材记号）

本条目对应 `SandronesLibrary/LinearAlgebra/JordanUniqueness.lean`。Jordan 标准形的块没有规范顺序，
所以"唯一"被表述为"两份块数据仅差一个保持标签的重编号"。

**组合学层：标签与重数。**

- `JordanFormData.blockLabel d i = (d.eigenvalue i, d.length i)`：块的完整标签（实际大小为 `length i + 1`）。
- `JordanFormData.Equivalent d₁ d₂`：存在块之间的双射 `e`，使每个块在 `e` 下保持标签，
  即两份数据仅相差块的重编号。
- `jordanFormData_equivalent_of_fiber_card_eq`：若每个标签的重数在两份数据中相同，则二者等价。
- `JordanFormData.blockTailCount d μ k`：特征值为 `μ` 且大小严格大于 `k` 的块数。
- `JordanFormData.blockMultiplicity d μ m`：特征值为 `μ` 且块参数为 `m` 的块数。
- `blockTailCount_eq_multiplicity_add_succ`：`blockTailCount μ m = blockMultiplicity μ m + blockTailCount μ (m+1)`。
- `blockMultiplicity_eq_of_tailCount_eq`：全部尾计数相同即可推出每种块重数相同。
- `natCard_blockLabel_fiber`：`blockMultiplicity μ m` 就是标签 `(μ, m)` 纤维的基数。
- `jordanFormData_equivalent_of_tailCount_eq`：全部尾计数相同则两份数据等价。

**分析层：用广义核维数恢复尾计数。**

- `JordanFormData.kernelProfile d μ k = ∑ i, if eigenvalue i = μ then min k (length i + 1) else 0`：
  块数据给出的广义核维数候选公式。
- `kernelProfile_succ_sub_eq_blockTailCount`：相邻差 `kernelProfile μ (k+1) - kernelProfile μ k = blockTailCount μ k`。
- `generalizedKernelDimension T μ k = finrank (ker ((T - μI)^k))`：算子侧的内禀不变量。
- `matrixGeneralizedKernelDimension A μ k = card ι - rank ((A - scalar μ)^k)`：方阵侧的"维数减秩"写法。
- `generalizedKernelDimension_eq_matrix`：换到任意一组基不改变广义核维数。
- `jordanNormalMatrix_shift_pow_eq_blockDiagonal`：标准矩阵减去标量矩阵再取幂，仍逐块计算。
- `jordanBlock_shift_pow_rank_of_ne`：移位标量不同于块特征值时，移位块任意幂都满秩。
- `jordanBlock_nilpotent_shift_pow_apply`：纯幂零移位块的 `k` 次幂只保留第 `k` 条上对角线。
- `rank_eq_card_sub_min_of_shift_entries`：只有第 `k` 条上对角线为一的矩阵秩为 `n - min k n`。
- `jordanBlock_nilpotent_shift_pow_rank`：纯幂零块的 `k` 次幂秩为 `(m+1) - min k (m+1)`。
- `jordanBlock_shift_pow_rank`：单块移位幂的完整秩公式（分 `lam = μ` 与否）。
- `blockDiagonal_toLin_apply`、`rank_blockDiagonal'`：块对角矩阵作用逐块进行，且其秩为各块秩之和。
- `jordanNormalMatrix_generalizedKernelDimension`：标准矩阵的广义核维数等于 `kernelProfile`。
- `generalizedKernelDimension_eq_kernelProfile`：换到 Jordan 标准基后，算子侧广义核维数等于块公式。
- `blockTailCount_eq_generalizedKernelDimension_sub`：一份 Jordan 基中大小超过 `k` 的 `μ`-块数
  等于相邻广义核维数之差。
- `blockTailCount_eq_of_hasJordanNormalBasis`：同一算子的任意两份 Jordan 标准基给出相同的全部尾计数。
- `jordan_normal_basis_unique`：同一算子的两份 Jordan 块数据等价（仅差块的重编号）。

## 直觉

广义核维数 `dim ker((T-μI)^k)` 只由算子决定，与所选 Jordan 基无关。对一块大小为 `s` 的 `μ`-块，
它贡献 `min k s`；把相邻两项相减，恰好在 `k < s` 时得到 `1`，也就是"所有大小超过 `k` 的 `μ`-块数"。
于是尾计数序列被内禀不变量完全决定，而尾计数又逐差恢复每种块大小的重数。块本身没有规范顺序，
所以最终唯一性只能是"保持标签的重编号"。

## 依赖（人话版）

- 前提 Entry：`linear-algebra.eigen.jordan-similarity`（Jordan 标准形的存在与相似表示）。
- Mathlib：公开接口不使用 Mathlib 专用名字；证明内部使用矩阵秩、行列式、`Matrix.blockDiagonal'`
  的秩与 `Matrix.toLin'` 等标准结果。

## 实现说明

公开签名使用本库的 `LinearSpace`、`IsBasis`、`operatorMatrix` 与 `JordanFormData`；矩阵侧的
`generalizedKernelDimension` / `matrixGeneralizedKernelDimension` 也以本库记号给出。子空间、有限维
`finrank`、矩阵秩与块对角的细节都在证明体内部完成，不进入公开定理签名。

## 应用与陷阱

- "唯一"不等于两份 `JordanFormData` 字面相等：`JordanFormData.Equivalent` 是保持标签的块重编号，
  不要求块类型或顺序相同。
- `blockTailCount` 的相邻差分公式方向固定：由尾计数恢复的是每种大小的重数，顺序不能颠倒。
- 复方阵的唯一性通过 `jordan-similarity` 的复实例继承；本条目本身对任意域陈述，需先有 Jordan 标准基。
