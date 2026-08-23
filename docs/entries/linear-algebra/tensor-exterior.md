---
id: linear-algebra.tensor-exterior
kind: theorem
state: verified
title: "对偶空间、张量积与外代数"
premises: ["linear-algebra.vector-space.def"]
mathlib: ["Subspace.dual_finrank_eq", "Module.Dual.eval", "Module.bijective_dual_eval",
  "Module.finrank_tensorProduct", "TensorProduct.lift", "contractLeft",
  "ExteriorAlgebra.ι_sq_zero", "ExteriorAlgebra.ι_add_mul_swap",
  "AlternatingMap.map_eq_zero_of_eq"]
provenance:
  source_type: book
  ref: "线性代数与经典微分几何：对偶空间、张量积和外代数"
---

# 动机

经典微分几何需要切向量与余切向量、张量场和微分形式。对偶空间把“测量向量的
线性函数”本身组织成向量空间；张量积把双线性问题化为线性问题；外代数则编码
有向面积、体积和交替性。

# 直觉

纯张量 `v ⊗ w` 对两个变量分别线性，但一般张量是纯张量的有限和。张量积的核心
不是某个坐标公式，而是泛性质：每个双线性映射都唯一地从张量积上的线性映射得到。

外代数把向量放入一个带乘法的代数，并规定 `v ∧ v = 0`。展开
`(u+v) ∧ (u+v)=0` 即得到 `u ∧ v = -(v ∧ u)`。

# 陈述（自然语言）

- `V*` 是从 `V` 到标量域的线性泛函空间，且 `dim V* = dim V`；有限维时自然评价
  `V → V**` 是双射。
- 自然配对为 `⟨φ,v⟩ = φ(v)`；双对偶评价把 `v` 送到 `φ ↦ φ(v)`。
- 纯张量对两个变量分别线性，任意双线性映射可提升为张量积上的线性映射，且
  `dim(V ⊗ W)=dim(V)dim(W)`。
- `V* ⊗ V` 可通过缩并映到标量域，`φ ⊗ v ↦ φ(v)`。
- 向量楔积满足双线性、`v ∧ v = 0` 和 `u ∧ v = -(v ∧ u)`。
- 整个外代数上的楔积满足结合律；特别地 `(u ∧ v) ∧ w = u ∧ (v ∧ w)`。
- 交替形式在两个不同位置输入相同向量时取零。

# 陈述（Lean 对照）

教材记号分别由 `DualSpace`、`TensorSpace`、`ExteriorSpace` 和 `AlternatingForm`
承载。主要接口是 `dim_dual_eq_dim`、`tensorLift_pureTensor`、
`dualTensorContraction_pureTensor`、`vectorWedge_self`、`vectorWedge_swap` 与
`exteriorWedge_assoc`、`vectorWedge_assoc`、`alternatingForm_eq_zero_of_repeat`。

# 思维脉络（thinking trace）

先把对偶空间接到本库只针对域上线性空间的 `LinearSpace`；再通过纯张量的四条
双线性关系解释张量积，并以 `tensorLift` 给出泛性质。缩并连接对偶与张量。
最后把向量嵌入外代数，用外代数乘法定义可迭代的楔积。外代数乘法的结合律给出
多重楔积的括号无关性，再从一次向量平方为零推出反交换律。

# 自然语言 ↔ Lean 映射

- `V*` ↔ `DualSpace K V`
- `v ⊗ w` ↔ `pureTensor K v w`
- 双线性映射的线性化 ↔ `tensorLift K B`
- `φ(v)` 缩并 ↔ `dualTensorContraction K`
- `u ∧ v` ↔ `vectorWedge K u v`
- `k`-形式 ↔ `AlternatingForm K V k`

# 依赖（人话版）

依赖域上线性空间、线性映射和有限维维数。实现层调用 mathlib 的对偶、张量积、
缩并、交替映射和外代数接口。

# 应用与陷阱

- 一般张量不一定是单个纯张量，不能只对 `v ⊗ w` 做模式匹配。
- `V` 与 `V**` 的自然映射无需选择基；有限维时才进一步得到同构。
- `u ∧ v` 位于整个外代数中；后续会补其属于二次外幂以及外幂维数。
- 当前完成向量楔积，形式之间的分次楔积仍是下一批工作。
