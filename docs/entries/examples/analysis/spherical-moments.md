---
id: examples.analysis.spherical-moments
kind: example
state: verified
title: 均匀球体的重心与转动惯量计算例
summary: 三个一阶矩（重心坐标）全为零，绕 z 轴的转动惯量为 8πδR⁵/15，并改写为教材形式 I = (2/5)MR²
premises: [analysis.multivariable.coordinate-integrals, analysis.coordinate-integrals.mass-center]
mathlib: [integral_Ioc_eq_integral_Ioo, intervalIntegral.integral_of_le, integral_cos, integral_sin, integral_sin_sq, integral_sin_mul_cos₁, integral_sin_pow_three, integral_pow, integral_const_mul, setIntegral_const, setIntegral_congr_fun, measurableSet_Ioo]
provenance:
  source_type: book
  ref: "ecnu-mathematical-analysis-5"
---

# 动机

理论条目 `analysis.coordinate-integrals.mass-center` 给出质量、重心与转动惯量的一般定义，
但「均匀球体的重心在哪」「转动惯量是几分之几 `MR²`」需要真算一遍才有说服力：
这两个数正是刚体力学与后续例题反复引用的常数。本 Entry 在
`examples.analysis.coordinate-integrals` 的球坐标积分之上，把重心与转动惯量逐步算出来，
所有步骤保留 Jacobian `ρ² sin φ`，可与教材的逐步积分一一对照。

# 直觉

均匀球体关于球心高度对称：

- 三个一阶矩的被积函数分别是 `x`、`y`、`z` 乘 Jacobian。`x`、`y` 含 `cos θ` 或
  `sin θ`，在 `θ ∈ (-π,π)` 上正负相消；`z` 含 `cos φ`，在 `φ ∈ (0,π)` 上正负相消。
  所以三个一阶矩都是 `0`，重心就是球心。
- 转动惯量绕 `z` 轴：到轴的距离平方是 `(ρ sin φ)²`，乘 Jacobian 得 `ρ⁴ sin³φ`。
  角向积分 `∫₀^π sin³φ dφ = 4/3`、`∫_{-π}^{π} dθ = 2π`，径向 `∫₀^R ρ⁴ dρ = R⁵/5`，
  三份相乘得 `8πδR⁵/15`。

# 陈述（自然语言）

设球体密度恒为 `δ`，半径 `R`：

1. 三个一阶矩（`x`、`y`、`z` 方向）都等于 `0`，即重心在球心；
2. 绕 `z` 轴的转动惯量 `I_z = 8πδR⁵/15`；
3. 记球体质量 `M = 4πδR³/3`，则 `I_z = (2/5)MR²`——教材常见形式的精确改写；
4. 角向预备积分：`∫_{-π}^{π} cos θ dθ = 0`、`∫_{-π}^{π} sin θ dθ = 0`、
   `∫₀^π sin²φ dφ = π/2`、`∫₀^π sin φ cos φ dφ = 0`、`∫₀^π sin³φ dφ = 4/3`、
   `∫₀^R ρ⁴ dρ = R⁵/5`（要求 `R ≥ 0`）。

# 陈述（Lean 对照）

```lean
lemma integral_Ioo_cos_neg_pi_pi : (∫ θ in Ioo (-π) π, cos θ) = 0
lemma integral_Ioo_sin_neg_pi_pi : (∫ θ in Ioo (-π) π, sin θ) = 0
lemma integral_Ioo_sin_sq_zero_pi : (∫ φ in Ioo (0 : ℝ) π, sin φ ^ 2) = π / 2
lemma integral_Ioo_sin_mul_cos_zero_pi : (∫ φ in Ioo (0 : ℝ) π, sin φ * cos φ) = 0
lemma integral_Ioo_sin_cube_zero_pi : (∫ φ in Ioo (0 : ℝ) π, sin φ ^ 3) = 4 / 3
lemma integral_Ioo_pow_four_zero_radius {R : ℝ} (hR : 0 ≤ R) :
    (∫ ρ in Ioo (0 : ℝ) R, ρ ^ 4) = R ^ 5 / 5

theorem uniform_ball_first_moment_x (δ : ℝ) {R : ℝ} : … = 0
theorem uniform_ball_first_moment_y (δ : ℝ) {R : ℝ} : … = 0
theorem uniform_ball_first_moment_z (δ : ℝ) {R : ℝ} : … = 0
theorem uniform_ball_moment_of_inertia_z (δ : ℝ) {R : ℝ} (hR : 0 ≤ R) :
    … = 8 * π * δ * R ^ 5 / 15
theorem uniform_ball_inertia_eq_two_fifths_mass (δ R : ℝ) :
    8 * π * δ * R ^ 5 / 15 = (2 / 5 : ℝ) * (4 * π * δ * R ^ 3 / 3) * R ^ 2
```

# 思维脉络

先备好六个一维角向／径向积分（各自都只是 `integral_cos`／`integral_sin`／
`integral_sin_sq`／`integral_sin_mul_cos₁`／`integral_sin_pow_three`／`integral_pow`
加端点换形），再逐条组装三重积分：

1. 每个一阶矩都对 `φ` 用 `setIntegral_congr_fun` 把被积函数整理成
   `(常数) · sin²φ` 或 `(常数) · sin φ cos φ`，再用 `integral_const_mul` 提出常数；
2. 对 `θ` 同样整理成 `(常数) · cos θ` 或 `(常数) · sin θ`，由预备积分归零；
3. 转动惯量按 `φ → θ → ρ` 顺序提出常数，最后用 `∫₀^R ρ⁴ dρ = R⁵/5` 与 `ring` 收尾；
4. 第 3 条是纯代数改写，`ring` 一步完成——它的作用是让 Lean 陈述与教材形式
   `I = (2/5)MR²` 对上，而不是新的分析内容。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 到 `z` 轴距离的平方 | `(ρ * sin φ) ^ 2`，即 `ρ ^ 2 * sin φ ^ 2` |
| 转动惯量被积函数 | `δ * (ρ ^ 4 * sin φ ^ 3)` |
| 转动惯量 | `8 * π * δ * R ^ 5 / 15` |
| 球体质量 `M` | `4 * π * δ * R ^ 3 / 3` |
| `I = (2/5)MR²` | `8 * π * δ * R ^ 5 / 15 = (2/5) * (4 * π * δ * R ^ 3 / 3) * R ^ 2` |

# 依赖（人话版）

- `analysis.coordinate-integrals.mass-center`：质量、重心与转动惯量的一般定义由该条目
  承载；本 Entry 只把它落到均匀球体上算出数值。
- `analysis.multivariable.coordinate-integrals`：球坐标 Jacobian 与参数盒来自该条目。
- `examples.analysis.coordinate-integrals`（同族 Examples 条目）：一维极角／径向积分的
  计算模板在 `CoordinateIntegrals.lean`，本文件直接复用其命名与做法。
- Mathlib 是**私有证明后端**：六个一维积分公式与积分线性性只用于算出数值，
  不作为教材概念暴露。

# 应用与陷阱

- **应用**：`I = (2/5)MR²` 是实心球转动惯量的标准结论，也是后续刚体力学例题的输入；
  三个一阶矩为零说明重心与球心重合，可用来解释「对称性直接杀掉一阶矩」这一常用手法。
- **陷阱一**：一阶矩为零**不能**反推「被积函数为零」——`x` 在球上并不恒为 `0`，
  是角向积分把正负两部分消掉了。本 Entry 的证明把「消掉」落实为 `∫ cos θ = 0`，
  而不是对函数本身作断言。
- **陷阱二**：转动惯量的角向积分是 `∫₀^π sin³φ dφ = 4/3`，不是 `∫₀^π sin φ dφ = 2`；
  用错会得到 `4πδR⁵/5`（那是把质量当薄壳算的结果）。
- **陷阱三**：`uniform_ball_moment_of_inertia_z` 带假设 `hR : 0 ≤ R`，而三个一阶矩没有；
  前者走径向积分需要 `0 ≤ R`，后者在 `φ`、`θ` 两层就已经归零，不需要 `R` 的符号。
- **陷阱四**：第 3 条只是恒等式改写，不要把它读成「转动惯量只依赖质量」——
  `M` 与 `R` 都出现在右端，`δ` 通过 `M` 进入。
