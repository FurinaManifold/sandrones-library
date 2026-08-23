---
id: linear-algebra.spectral-quadratic
kind: theorem
state: verified
title: "实谱定理、二次型与惯性定律"
premises: ["linear-algebra.inner-product", "linear-algebra.matrix.symmetric"]
mathlib: ["LinearMap.IsSymmetric.eigenvectorBasis", "LinearMap.IsSymmetric.apply_eigenvectorBasis", "QuadraticForm.equivalent_one_zero_neg_one_weighted_sum_squared", "QuadraticForm.sigPos_of_equiv_weightedSumSquares"]
provenance:
  source_type: book
  ref: "本科线性代数：实对称谱定理、二次型与Sylvester惯性定律"
---

# 动机

实对称矩阵为什么总能用正交换基化为对角阵，二次型为什么总能消去交叉项，以及
正负平方项个数为什么不随换基改变，本质上是同一套有限维实谱理论。

# 直觉

自伴算子在互异特征值方向上彼此正交；有限维谱定理把全空间拼成这些正交特征方向。
沿标准正交特征基展开后，算子只逐坐标乘以实特征值，二次型因此成为加权平方和。

# 陈述（自然语言）

- 有限维实内积空间中的每个自伴算子都有一组标准正交特征基。
- 在该基下，对应二次型为 `Σ μᵢcᵢ²`，没有交叉项。
- 任意有限维实二次型都等价于系数只取 `-1,0,1` 的平方和。
- 任意对角表示中正系数与负系数的个数分别等于二次型的正、负惯性指数。

# 陈述（Lean 对照）

`spectral_theorem` 给出标准正交特征基；`operatorQuadraticForm_diagonal` 给出坐标公式；
`inertia_normal_form` 和 `inertia_indices_unique` 分别给出 Sylvester 定律的存在与唯一性。

# 思维脉络（thinking trace）

谱定理使用 mathlib 按特征值正交直和构造的 `eigenvectorBasis`。二次型公式把线性算子
作用分配到有限和上，再由标准正交性消掉所有非对角内积。惯性定律则使用正定子空间的
最大维数来刻画正负指数，因此不依赖具体对角化。

# 自然语言 ↔ Lean 映射

- 标准正交特征基 ↔ `IsBasis ℝ b ∧ Orthonormal ℝ b` 加逐向量特征方程。
- 算子二次型 ↔ `operatorQuadraticForm T x = inner ℝ (T x) x`。
- 对角平方和 ↔ `IsDiagonalForm Q w`；正、负惯性指数 ↔ `positiveIndex`、`negativeIndex`。

# 依赖（人话版）

依赖内积空间的伴随与自伴接口、有限维正交谱分解，以及实二次型的等价与符号理论。

# 应用与陷阱

谱定理部分只针对有限维实内积空间；复空间对应 Hermitian 谱定理。普通可对角化不保证
存在标准正交特征基。惯性定律讨论一般可逆线性换基，不只讨论正交换基。
