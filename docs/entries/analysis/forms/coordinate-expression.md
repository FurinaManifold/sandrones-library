---
id: analysis.forms.coordinate-expression
family: analysis.forms
variant: textbook
kind: theorem
state: verified
title: "欧氏空间上微分形式的坐标表达式"
summary: "在 ℝⁿ 的标准基下给出 1、2、3 次微分形式的坐标形式 dx_i、dx_i∧dx_j 与体积形式的显式分量展开。"
premises: [analysis.multivariable.differential-forms]
mathlib: [ContinuousAlternatingMap.ofSubsingletonLIE, AlternatingMap.domCoprod, MultilinearMap.domCoprod, MultilinearMap.alternatization, MultilinearMap.domCoprod_alternization_eq, MultilinearMap.alternatization_apply, TensorProduct.lid, Module.Basis.ext_alternating, Module.Basis.det, Module.Basis.det_apply, Module.Basis.toMatrix_apply, AlternatingMap.eq_smul_basis_det, AlternatingMap.map_swap, Pi.basisFun, Pi.basisFun_repr, Matrix.det_apply, Finset.sum_eq_single, Equiv.Perm.sign]
provenance:
  source_type: book
  ref: "spivak-calculus-manifolds-1965"
---

# 动机

教材里的微分形式几乎总是以坐标形式出现：在 `ℝⁿ` 上写 `ω = ∑ f_i dx_i`、
`ω = ∑_{i<j} f_{ij} dx_i ∧ dx_j`、`ω = f dx ∧ dy ∧ dz`。本库的
`analysis.multivariable.differential-forms` 用的是抽象载体
`DifferentialForm E k := E → E [⋀^Fin k]→L[ℝ] ℝ`，其中楔积由 shuffle 公式
`formWedge` 给出。抽象定义便于做外微分与 Stokes 定理，但不便于读数。

本条目把二者接起来：给出坐标 1-形式 `dx_i`、坐标 2-形式 `dx_i ∧ dx_j`，
并证明任意 1/2/3 次形式在标准基下按这些坐标形式展开。这样后续积分、
Green–Gauss–Stokes 等结果就可以直接用教材写法陈述。

# 直觉

设 `E = Fin n → ℝ`，标准基是 `e_i = Pi.single i 1`。`k` 次交替映射由它在
“基向量 `k` 元组”上的取值唯一决定。于是：

- `1` 次形式就是线性泛函，由它在 `e_i` 上的取值 `ω x ![e_i]` 决定；
- `2` 次形式由子式 `ω x ![e_i, e_j]` 决定，而 `dx_i ∧ dx_j` 的取值恰是把
  第 `i`、`j` 行取出的 `2×2` 子式；
- `3` 次形式在 `ℝ³` 上由单一体积值 `ω x ![e_0, e_1, e_2]` 决定。

“展开”不过是“交替多线性映射由基向量元组上的值决定”这一事实的坐标翻译。
唯一的技术障碍是：`dx_i ∧ dx_j` 的取值必须回到 `formWedge` 的 shuffle 定义去算，
而 shuffle 是对 `Equiv.Perm.ModSumCongr` 的和。对 `k = l = 1`，这个商只有两个类，
所以可以逐项算清。

# 陈述（自然语言）

在 `ℝⁿ = Fin n → ℝ` 上，令 `e_i = Pi.single i 1`。

1. 定义坐标 1-形式 `dx_i`：常值形式，取值 `v ↦ v i`。
2. **1 次形式展开**：对任意 1 次形式 `ω` 和点 `x`，
   `ω x = ∑_i (ω x ![e_i]) · dx_i x`。
3. 定义坐标 2-形式 `dx_i ∧ dx_j := dx_i ∧ dx_j`（用库内楔积）。对任意
   `v : Fin 2 → ℝⁿ`，
   `(dx_i ∧ dx_j) x v = v 0 i · v 1 j − v 1 i · v 0 j`。
4. **`ℝ²` 上 2 次形式展开**：`ω x = (ω x ![e_0, e_1]) · (dx_0 ∧ dx_1) x`。
5. **`ℝ³` 上 2 次形式展开**：
   `ω x = ∑_{0 ≤ i < j ≤ 2} (ω x ![e_i, e_j]) · (dx_i ∧ dx_j) x`。
6. 定义 `ℝ³` 上的体积形式 `vol := dx_0 ∧ dx_1 ∧ dx_2`（本实现取标准基下的
   行列式形式，二者相等）。**3 次形式展开**：
   `ω x = (ω x ![e_0, e_1, e_2]) · vol x`。

# 陈述（Lean 对照）

```lean
-- 坐标 1-形式与取值
def coordinateForm {n : ℕ} (i : Fin n) : DifferentialForm (Fin n → ℝ) 1
theorem coordinateForm_apply {n : ℕ} (i : Fin n) (x : Fin n → ℝ) (v : Fin 1 → Fin n → ℝ) :
    coordinateForm i x v = v 0 i

-- 核心技术引理：两个 1 次交替映射的楔积在二元组上的取值
theorem alternatingWedge_one_apply {E} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (a b : E [⋀^Fin 1]→ₗ[ℝ] ℝ) (v : Fin 2 → E) :
    alternatingWedge a b v =
      a (fun _ : Fin 1 => v 0) * b (fun _ : Fin 1 => v 1) -
        a (fun _ : Fin 1 => v 1) * b (fun _ : Fin 1 => v 0)

def coordinateTwoForm {n : ℕ} (i j : Fin n) : DifferentialForm (Fin n → ℝ) 2 :=
  formWedge (coordinateForm i) (coordinateForm j)

theorem coordinateTwoForm_apply {n : ℕ} (i j : Fin n) (x : Fin n → ℝ)
    (v : Fin 2 → Fin n → ℝ) :
    coordinateTwoForm i j x v = v 0 i * v 1 j - v 1 i * v 0 j

theorem oneForm_coordinate_expansion {n : ℕ} (ω : DifferentialForm (Fin n → ℝ) 1)
    (x : Fin n → ℝ) :
    ω x = ∑ i, (ω x ![Pi.single i 1]) • coordinateForm i x

theorem twoForm_coordinate_expansion_plane (ω : DifferentialForm (Fin 2 → ℝ) 2)
    (x : Fin 2 → ℝ) :
    ω x = (ω x ![Pi.single 0 1, Pi.single 1 1]) • coordinateTwoForm 0 1 x

theorem twoForm_coordinate_expansion_space (ω : DifferentialForm (Fin 3 → ℝ) 2)
    (x : Fin 3 → ℝ) :
    ω x = ∑ p ∈ (Finset.univ.filter (fun p : Fin 3 × Fin 3 => p.1 < p.2)),
      (ω x ![Pi.single p.1 1, Pi.single p.2 1]) • coordinateTwoForm p.1 p.2 x

def coordinateThreeForm : DifferentialForm (Fin 3 → ℝ) 3
theorem threeForm_coordinate_expansion_space (ω : DifferentialForm (Fin 3 → ℝ) 3)
    (x : Fin 3 → ℝ) :
    ω x = (ω x ![Pi.single 0 1, Pi.single 1 1, Pi.single 2 1]) • coordinateThreeForm x
```

# 定义与记号

- `DifferentialForm E k := E → E [⋀^Fin k]→L[ℝ] ℝ`：`k` 次微分形式是在每一点
  取一个连续交替 `k` 重线性泛函的场；坐标形式都是**常值场**。
- `coordinateForm i` 由 `ContinuousAlternatingMap.ofSubsingletonLIE` 从连续线性
  泛函 `ContinuousLinearMap.proj i` 得到。因为 `Fin 1` 是子单点类型，`1` 重交替
  映射与连续线性泛函通过 `≃ₗᵢ` 一一对应。
- `coordinateTwoForm i j = formWedge (coordinateForm i) (coordinateForm j)`：直接
  复用库内 shuffle 楔积，而不是另造结构。
- `coordinateThreeForm`：取标准基下的行列式形式
  `(Pi.basisFun ℝ (Fin 3)).det`，再用 `AlternatingMap.mkContinuous` 配上一个
  显式范数界（常数 `6 = 3!`）升级为连续交替映射。它与
  `dx_0 ∧ dx_1 ∧ dx_2` 在标准基下同值，故是同一个体积形式。
- 记号 `![a, b, …]` 是 `Matrix.vecCons` 写的有限元组；`Pi.single i 1` 是标准基
  向量 `e_i`（对 `Pi.basisFun ℝ (Fin n)` 有 `Pi.basisFun ℝ (Fin n) i = Pi.single i 1`）。

# 证明思路

**楔积取值（核心技术点）。** `formWedge` 的底层是 `alternatingWedge`，它对
`Equiv.Perm.ModSumCongr (Fin 1) (Fin 1)` 求和，直接数这个商不方便。改用
`MultilinearMap.domCoprod_alternization_eq`：因为 `(1!)·(1!) = 1`，有
`a.domCoprod b = MultilinearMap.alternatization (MultilinearMap.domCoprod a b)`。
于是 `MultilinearMap.alternatization_apply` 把取值写成对 `Equiv.Perm (Fin 1 ⊕ Fin 1)`
（恰两个元素：恒等与 `Equiv.swap`）的求和。用
`Fintype.sum_bijective` 把一个从 `Fin 2` 到该置换类型的双射代入，和式化为两项；
`MultilinearMap.domDomCongr_apply` / `MultilinearMap.domCoprod_apply` 把每项化为
两个因子值的乘积，`TensorProduct.lid_tmul` 把张量积收成标量乘法，得到
`a(v_0)·b(v_1) − a(v_1)·b(v_0)`。这就是 `alternatingWedge_one_apply`。
把 `a, b` 取成 `coordinateForm i, j` 在 `x` 的纤维并代入 `coordinateForm_apply`，
即得 `coordinateTwoForm_apply` 的子式公式。

**展开引理。** 三条展开都遵循同一模式：先用
`ContinuousAlternatingMap.toAlternatingMap_injective` 把连续交替映射的相等
降到普通交替映射，再用 `Module.Basis.ext_alternating (Pi.basisFun ℝ (Fin n))`
把它降到“所有单射基向量元组上的取值”。

- 1 次：单射元组只是一个基向量 `e_p`；右边的和用 `Finset.sum_eq_single p`
  收缩，`coordinateForm_apply` 给出 Kronecker 取值。
- `ℝ²` 上 2 次：单射元组是 `(e_0,e_1)` 与 `(e_1,e_0)` 两种；对后者用
  `AlternatingMap.map_swap` 把 `ω x ![e_1,e_0]` 化为 `−ω x ![e_0,e_1]`，
  `coordinateTwoForm_apply` 同时对右边给出 `−1`。
- `ℝ³` 上 2 次：`Fin 2 → Fin 3` 的单射有六个有序对（一个私有引理逐一列举）。
  逐一 `fin_cases` 化简后，`Finset.univ.filter (·.1 < ·.2)` 被显式化为三个有序对，
  `coordinateTwoForm_apply` 让求和只剩一项；逆序情形再由 `map_swap` 处理。
- `ℝ³` 上 3 次：直接调用 `AlternatingMap.eq_smul_basis_det`：任一取值在 `ℝ` 的
  交替映射等于“它在标准基上的值”乘 `Basis.det`。于是
  `ω x = (ω x ![e_0,e_1,e_2]) • (Pi.basisFun ℝ (Fin 3)).det`，再对照
  `coordinateThreeForm`（正是该 `Basis.det` 的连续化）即可。

`Basis.det` 的连续性是用行列式的置换展开（`Module.Basis.det_apply`、
`Matrix.det_apply`）逐项用 `‖v i (σ i)‖ ≤ ‖v i‖` 估计，得到常数 `6 = 3!`。
这是有限维情形的常规插值，不属于新增数学内容。

# 依赖与边界

- **依赖**：`analysis.multivariable.differential-forms`（提供 `DifferentialForm`、
  `formWedge`、`continuousAlternatingWedge`、`continuousAlternatingWedge_apply`）。
  本条目没有引入新公理；所调用的 Mathlib 结果均为已发布的线性代数与范数估计。
- **正式承载**：`ContinuousAlternatingMap` / `AlternatingMap` 就是载体；教材的
  `k`-形式在这里逐点被解释为一个连续交替 `k` 重线性泛函。坐标形式是常值场，
  因此连续性与线性都自动成立。
- **覆盖范围（诚实边界）**：
  - 一般 `n` 上只证明了 **1 次**形式的展开；
  - **2 次**展开只对 `ℝ²`（唯一坐标 2-形式）和 `ℝ³`（三个 `i < j` 对）给出，
    没有给出一般 `n` 的 `i < j` 展开；
  - **3 次**展开只在 `ℝ³` 上，且要求形式次数恰为空间维数；
  - 没有涉及 `k ≥ 4`、一般维数的 `k`-形式展开，也没有给出 `dx_i` 的外微分
    `d(dx_i) = 0` 或积分的显式公式（这些属于其它条目）。
- **定义选择的说明**：`coordinateThreeForm` 实现为 `Basis.det` 的连续化，而不是
  三重 `formWedge` 的语法写法；两者在标准基上取相同值，数学上是同一个体积形式。
  这样避免了为 `2+1` shuffle 再写一遍枚举，同时保持“标准坐标体积形式”的语义。
