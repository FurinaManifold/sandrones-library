---
id: analysis.coordinate-integrals.mass-center
family: analysis.coordinate-integrals
variant: textbook
kind: theorem
state: verified
title: "质量、重心与转动惯量"
summary: "带密度区域的质量、一阶矩/重心、二阶矩与转动惯量的集积分接口及平行轴展开。"
premises: [analysis.multivariable.coordinate-integrals, analysis.multivariable.change-variables]
mathlib: [setIntegral_nonneg_of_ae_restrict, ae_restrict_iff'₀, setIntegral_union, setIntegral_union₀, setIntegral_sdiff, integral_add, integral_sub, integral_const_mul, integral_finsetSum, setIntegral_const, setIntegral_one_eq_measureReal, setIntegral_congr_fun, integral_congr_ae, Finset.sum_mul, Finset.mul_sum, Finset.sum_add_distrib, Finset.sum_sub_distrib, Finset.sum_congr, Finset.sum_nonneg, sq_nonneg, mul_div_mul_left, mul_ne_zero]
provenance:
  source_type: book
  ref: "ecnu-mathematical-analysis-5"
---

# 动机

华东师大《数学分析》在讲完二重、三重积分之后，用“微元法”把积分应用到物理量上：
一块平面薄片或空间物体，密度 `ρ` 一般随位置变化，它的质量、重心坐标和绕某点的
转动惯量都要写成区域上的积分。这些量不是新的积分理论，而是同一套重积分在具体
被积函数下的读法。把它们做成正式接口的价值在于：后续的物理应用题、例题和
几何量计算都能直接调用定义与线性性质，而不必每次重复“把求和写成积分”的推导。

本条目承接 `analysis.multivariable.coordinate-integrals`（坐标换元、极/柱/球坐标）
与 `analysis.multivariable.change-variables`（换元公式），给出这些物理量的定义与
基础恒等式。

# 直觉

- **质量**就是把“密度乘体积微元”累加起来：`m = ∫_D ρ`。
- **一阶矩（静矩）**是“力臂乘质量微元”的累加，衡量区域在某个坐标方向上的偏斜。
  把静矩除以总质量，就得到**重心**的对应坐标：`x̄ᵢ = (∫_D xᵢ ρ) / (∫_D ρ)`。
- **二阶矩**是“力臂平方乘质量微元”，即到坐标平面 `xᵢ = 0` 的转动惯量分量；
  **关于一点 `c` 的转动惯量**则是到点 `c` 的欧氏距离平方的加权积分。
- 密度整体乘一个非零常数 `c`，等于“把物体的质量整体放大”，重心不动；密度整体
  乘 `c`，转动惯量也整体乘 `c`。这些都是积分线性性的直接读数。

# 陈述（自然语言）

设 `D` 是 `n` 维空间中的区域，`ρ : D → ℝ` 是密度，`c` 是空间中一点，`i` 是某个坐标。

1. **质量**：`mass ρ D = ∫_D ρ`。
2. **一阶矩（静矩）**：关于坐标平面 `xᵢ = 0` 的一阶矩
   `firstMoment ρ D i = ∫_D xᵢ ρ`。
3. **重心**：`centroid ρ D i = firstMoment ρ D i / mass ρ D`；当 `mass ρ D ≠ 0`
   时它是区域重心的第 `i` 个坐标。
4. **二阶矩**：关于坐标平面 `xᵢ = 0` 的二阶矩
   `secondMoment ρ D i = ∫_D xᵢ² ρ`。
5. **转动惯量**：关于点 `c` 的转动惯量
   `momentOfInertia ρ D c = ∫_D (∑ᵢ (xᵢ - cᵢ)²) ρ`，即被积函数是到 `c` 的欧氏
   距离平方（`c = 0` 时即关于原点）。

基础恒等式：`ρ ≥ 0` 时质量与转动惯量非负；质量在不相交可测并上可加、去掉可测
子集时作差；质量/一阶矩/二阶矩/转动惯量对密度是线性的；缩放密度不改变重心；
单坐标和全空间的平行轴展开把转动惯量写成二阶矩与质量。

# 陈述（Lean 对照）

```lean
-- 载体与密度
variable {n : ℕ} (ρ : JordanEuc n → ℝ) (D : Set (JordanEuc n)) (i : Fin n)
variable (c : JordanEuc n)

def euclideanNormSq (v : JordanEuc n) : ℝ := ∑ i, (v i) ^ 2
def mass (ρ) (D) : ℝ := ∫ x in D, ρ x
def firstMoment (ρ) (D) (i) : ℝ := ∫ x in D, x i * ρ x
def centroid (ρ) (D) (i) : ℝ := firstMoment ρ D i / mass ρ D
def secondMoment (ρ) (D) (i) : ℝ := ∫ x in D, (x i) ^ 2 * ρ x
def momentOfInertia (ρ) (D) (c) : ℝ := ∫ x in D, euclideanNormSq (x - c) * ρ x
```

`mass_nonneg` 假设 `NullMeasurableSet D volume` 与 `∀ x ∈ D, 0 ≤ ρ x`；
`mass_add` 假设 `Disjoint D E`、`MeasurableSet E` 及两侧的 `IntegrableOn`；
`mass_add_of_disjoint` 把第二侧减弱为 `NullMeasurableSet`；
`mass_sub` 假设 `MeasurableSet E`、`E ⊆ D` 与 `IntegrableOn ρ D volume`；
`mass_smul` 无额外假设；`centroid_smul` 假设 `c ≠ 0` 与 `mass ρ D ≠ 0`。

`momentOfInertia_expansion` / `momentOfInertia_parallel_axis` 假设 `IntegrableOn ρ D`、
每个坐标的 `IntegrableOn (fun x ↦ (x i)² * ρ x)` 与 `IntegrableOn (fun x ↦ x i * ρ x)`，
结论为

```lean
momentOfInertia ρ D c =
  ∑ i, (secondMoment ρ D i - 2 * (c i) * firstMoment ρ D i + (c i) ^ 2 * mass ρ D)
```

及其重排形式

```lean
momentOfInertia ρ D c =
  (∑ i, secondMoment ρ D i) - 2 * (∑ i, c i * firstMoment ρ D i)
    + euclideanNormSq c * mass ρ D
```

# 定义与记号

- **载体**：`JordanEuc n := Fin n → ℝ`，是本库多元分析统一的坐标函数空间；
  `n = 2, 3` 分别对应平面与空间。
- **积分**：所有定义都是 `MeasureTheory` 的 Lebesgue/Bochner 集积分
  `∫ x in D, f x`，底层测度为 `volume`（`n` 维 Lebesgue 测度），区域 `D` 不预设
  Jordan 可测。质量与转动惯量非负的定理只需 `NullMeasurableSet D volume`；其余
  线性与可加性定理显式要求 `IntegrableOn`。
- **欧氏范数平方**：`euclideanNormSq v = ∑ i, vᵢ²`。载体 `Fin n → ℝ` 在 Mathlib
  中默认带乘积（上确界）范数 `‖·‖`，不是欧氏范数，因此没有直接使用 `‖v‖²`；
  `euclideanNormSq` 与 `EuclideanSpace ℝ (Fin n)` 上的平方范数一致，在 `n = 2, 3`
  时恰为 `x²+y²` 与 `x²+y²+z²`。
- **重心**：`centroid` 定义为全函数；`mass ρ D = 0` 时 Lean 的除法返回 `0`，这只是
  约定的占位值，物理含义需要 `mass ρ D ≠ 0`。
- **一阶矩的方向约定**：`firstMoment`、`secondMoment` 的指标 `i` 指“关于坐标平面
  `xᵢ = 0`”，是逐坐标的量；`momentOfInertia` 则是关于一点 `c` 的合量。

# 证明思路

全部证明都是集积分上的线性代数，没有新的分析内容：

1. **非负性**：`setIntegral_nonneg_of_ae_restrict` 把非负性化为对
   `volume.restrict D` 的几乎处处非负；再用 `ae_restrict_iff'₀` 与
   `Filter.Eventually.of_forall` 把“`D` 上逐点非负”转成该几乎处处命题；被积函数
   的非负性用 `sq_nonneg` / `euclideanNormSq_nonneg` 与乘法非负组合。
2. **可加与作差**：直接使用 `setIntegral_union`、`setIntegral_union₀` 与
   `setIntegral_sdiff`，把 `IntegrableOn` 侧条件原样传递。
3. **线性**：把函数在点上按交换律重写（`ring`），再用 `integral_const_mul` 把常数
   提到积分外；`centroid_smul` 在得到 `(c·f)/(c·m)` 后用 `mul_div_mul_left` 约去
   `c ≠ 0`。
4. **与体积接口的桥**：`mass_const` 由 `setIntegral_const` 得到
   `mass (fun _ ↦ c) D = c * volume.real D`，`mass_one_eq_measureReal` 是其 `c = 1`
   特例，把质量与 `volume.real` 直接对齐。
5. **平行轴展开**：先用 `euclideanNormSq_sub` 与 `Finset.sum_mul` 把被积函数写成
   `∑ i, (xᵢ - cᵢ)² ρ`，用 `integral_finsetSum` 把积分与有限和交换（对每个坐标项
   给出 `IntegrableOn`），再逐坐标用 `integral_sq_sub_center`（把 `(xᵢ - cᵢ)²` 展成
   `xᵢ² - 2cᵢxᵢ + cᵢ²` 后分别用 `integral_add`、`integral_sub`、`integral_const_mul`）
   化为 `secondMoment`、`firstMoment`、`mass` 的组合，最后用 `Finset` 的线性恒等式
   整理成重排形式。

# 依赖与边界

**依赖**：`premises` 中的 `analysis.multivariable.coordinate-integrals` 提供坐标
换元（极/柱/球坐标）的语言，`analysis.multivariable.change-variables` 提供像区域上
积分拉回的公式；本条目本身只依赖 `JordanEuc` 载体、`volume` 测度与 Mathlib 的
Bochner 集积分 API（经 `SandronesLibrary.Analysis.JordanRegion` 转入）。

**诚实边界**：

- 不建立一般 Radon 测度、分布或弱收敛理论；密度就是实值函数，区域就是 `Set`。
- 可积性/可测性是显式假设，而非全局实例：`mass_add`、`mass_sub`、平行轴展开都要求
  相应的 `IntegrableOn`；不过可测的定理只用到 `NullMeasurableSet`，因此对 Jordan
  可测区域可以直接实例化（`isJordanMeasurable_mass_nonneg`、
  `isJordanMeasurable_momentOfInertia_nonneg`）。
- 转动惯量按坐标显式使用欧氏范数平方，而非载体的默认上确界范数；这是为忠实于
  教材的欧氏距离所作的必要适配，已在模块文档与 `euclideanNormSq` 中说明。
- 平行轴定理只证明到“展开恒等式”这一层，不假设 `c` 是重心、也不断言交叉项为零；
  由展开式到经典形式 `I_c = I_0 + ‖c‖² m` 需要先定义重心向量并证明交叉项消去，
  属后续工作。
- 具体的数值例题（例如求半圆薄片的重心、球体的转动惯量）需要额外的几何计算，
  归 `Examples` 条目，不在本证明条目内。
