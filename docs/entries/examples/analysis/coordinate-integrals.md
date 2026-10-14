---
id: examples.analysis.coordinate-integrals
kind: example
state: verified
title: 球体体积与质量的球坐标计算例
summary: 极角积分 ∫₀^π sin φ dφ = 2、径向积分 ∫₀^R ρ² dρ = R³/3，合成半径 R 球体的体积 4πR³/3 与常密度 δ 下的质量 4πδR³/3
premises: [analysis.multivariable.coordinate-integrals]
mathlib: [integral_Ioc_eq_integral_Ioo, intervalIntegral.integral_of_le, integral_sin, integral_pow, integral_const_mul, setIntegral_const]
provenance:
  source_type: book
  ref: "ecnu-mathematical-analysis-5"
---

# 动机

理论条目 `analysis.multivariable.coordinate-integrals` 给出极坐标与柱坐标的换元公式，
但「换元公式长什么样」和「球体体积到底等于几」是两件事。教材里真正被反复引用的，
是后者：半径 `R` 的球体体积 `4πR³/3`、常密度 `δ` 的球体质量 `4πδR³/3`。本 Entry
把球坐标参数盒上的 Jacobian 积分逐步算成这两个数值，供后续质量、重心、转动惯量
（见 `examples.analysis.spherical-moments`）与坐标积分路线复用。

# 直觉

球坐标把球体切成「一层层球壳、一圈圈经线、一条条纬线」：

- 纬线方向（极角 `φ ∈ (0,π)`）的权重是 `sin φ`，整条纬线扫出的总量是 `2`；
- 经线方向（`θ ∈ (-π,π)`）的长度是 `2π`；
- 径向 `ρ² dρ` 累加到半径 `R` 得 `R³/3`。

三者相乘：`(R³/3) · (2π) · 2 = 4πR³/3`。Jacobian `ρ² sin φ` 就是这三段的乘积，
不是额外贴上的系数。

# 陈述（自然语言）

1. `∫₀^π sin φ dφ = 2`（极角方向的总权重）；
2. `∫₀^R ρ² dρ = R³/3`（径向累加，要求 `R ≥ 0`）；
3. 球坐标参数盒 `(ρ,θ,φ) ∈ (0,R)×(-π,π)×(0,π)` 上 Jacobian `ρ² sin φ` 的三重积分
   等于 `4πR³/3`——这就是球体体积；
4. 被积函数换成 `δ · ρ² sin φ` 后等于 `4πδR³/3`——这就是常密度 `δ` 的球体质量。

# 陈述（Lean 对照）

```lean
theorem integral_Ioo_sin_zero_pi :
    (∫ φ in Ioo (0 : ℝ) π, sin φ) = 2

theorem integral_Ioo_sq_zero_radius {R : ℝ} (hR : 0 ≤ R) :
    (∫ ρ in Ioo (0 : ℝ) R, ρ ^ 2) = R ^ 3 / 3

theorem spherical_ball_jacobian_integral {R : ℝ} (hR : 0 ≤ R) :
    (∫ ρ in Ioo (0 : ℝ) R, ∫ _θ in Ioo (-π) π,
      ∫ φ in Ioo (0 : ℝ) π, ρ ^ 2 * sin φ) = 4 * π * R ^ 3 / 3

theorem uniform_ball_mass_jacobian_integral (δ : ℝ) {R : ℝ} (hR : 0 ≤ R) :
    (∫ ρ in Ioo (0 : ℝ) R, ∫ _θ in Ioo (-π) π,
      ∫ φ in Ioo (0 : ℝ) π, δ * (ρ ^ 2 * sin φ)) = 4 * π * δ * R ^ 3 / 3
```

# 思维脉络

先算一维因子，再做嵌套积分——顺序与教材的逐步积分一致：

1. 极角积分用 `integral_sin` 直接得 `2`（开区间与有向区间端点只差零测集，
   `integral_Ioc_eq_integral_Ioo` 与 `intervalIntegral.integral_of_le` 负责换形）；
2. 径向积分用 `integral_pow` 得 `R³/3`，`hR : 0 ≤ R` 是把有向区间接到 `Ioc` 上的
   唯一非平凡假设；
3. 三重积分对 `φ` 用 `integral_const_mul` 提出 `ρ²`，对 `θ` 用 `setIntegral_const`
   把常数 `2` 乘上区间长度 `2π`，最后对 `ρ` 再用一次 `integral_const_mul` 与径向公式；
4. 质量那条只是把 `δ` 一路提出积分号（`integral_const_mul` 两次），最后 `ring` 整理。

整个文件不含任何换元定理：换元理论留在 `Analysis`，本 Entry 只消费它的坐标公式。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 极角 `φ` 的取值范围 | `Ioo (0:ℝ) π` |
| 经角 `θ` 的取值范围 | `Ioo (-π) π` |
| 径向 `ρ` 的取值范围 | `Ioo (0:ℝ) R` |
| 球坐标 Jacobian | `ρ ^ 2 * sin φ` |
| 球体体积 | `4 * π * R ^ 3 / 3` |
| 常密度质量 | `4 * π * δ * R ^ 3 / 3` |

# 依赖（人话版）

- `analysis.multivariable.coordinate-integrals`：本 Entry 消费它的坐标变换公式；
  球坐标的 Jacobian 与参数盒由该条目承载，本文件不重新定义坐标变换。
- Mathlib 在这里是**私有证明后端**：一维积分公式（`integral_sin`、`integral_pow`）
  与积分线性性（`integral_const_mul`、`setIntegral_const`）只用于把数值算出来，
  不作为教材概念暴露。

# 应用与陷阱

- **应用**：本 Entry 的 `4πR³/3` 与 `4πδR³/3` 是 `SphericalMoments.lean` 里重心与
  转动惯量的直接前置；把 `R` 换成具体数值即可得到教材习题答案。
- **陷阱一**：Jacobian `ρ² sin φ` 里的 `sin φ` 属于**纬线方向**，漏掉它会把体积算成
  `2π²R³/3` 一类的错误值——本 Entry 的三重积分保留了完整的 Jacobian。
- **陷阱二**：`hR : 0 ≤ R` 不是装饰。径向积分走的是有向区间 `0..R`，`R < 0` 时
  `∫₀^R ρ² dρ = R³/3` 仍然成立但已经不是「半径 `R` 的球体」；球体体积公式只在
  `R ≥ 0` 下被解释为体积。
- **陷阱三**：参数盒取的是开区间 `(0,R)×(-π,π)×(0,π)`，与闭球体相差零测集，
  所以积分值不受影响；若把端点当成「少算了一层」而改用闭区间，值不变但证明里
  会多出边界项的讨论。
