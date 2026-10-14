---
id: examples.analysis.green-regions
kind: example
state: verified
title: 直角三角形与单位圆盘上的 Green 公式计算例
summary: 两个标准平面区域上的 Green 公式实例、三角形面积型边界积分 1/2，以及边界定向反转使积分变号的精确反例
premises: [analysis.multivariable.green-gauss-stokes, analysis.multivariable.jordan-region]
mathlib: [Real.abs_le_sqrt, Real.sq_sqrt, sq_le_sq₀, sq_abs, abs_le, intervalIntegral.integral_sub, intervalIntegral.integral_of_le, integral_Icc_eq_integral_Ioc, integral_id, integral_neg, setIntegral_congr_fun, measurableSet_Icc, Continuous.intervalIntegrable]
provenance:
  source_type: book
  ref: "spivak-calculus-manifolds-1965"
---

# 动机

理论条目 `analysis.multivariable.green-gauss-stokes` 给出「双正常域」上的 Green 公式：
同一区域既可写成竖直正常域 `lower x ≤ y ≤ upper x`，也可写成水平正常域
`left y ≤ x ≤ right y` 时，边界积分等于区域内旋度积分。抽象公式要落到教材上，
需要两个标准图形：第一象限的标准直角三角形与闭单位圆盘。本 Entry 给出这两个区域
的坐标表示、边界积分的显式写法，以及一次真计算（三角形面积型边界积分 `1/2`）。

此外，Green 公式左端是**有向**边界积分。定向是最容易被误删的假设，所以本 Entry
配两条定向反例：把边界反向遍历后积分整体变号，同一个右端不可能同时匹配两种定向。

# 直觉

- 直角三角形 `x ≥ 0`、`y ≥ 0`、`x+y ≤ 1`：上边界是直线 `y = 1 - x`，下边界是 `y = 0`；
  同时左边界是 `x = 0`，右边界是 `x = 1 - y`。两种写法给出同一个区域，这正是
  「双正常域」假设的验证点。
- 单位圆盘 `x²+y² ≤ 1`：上边界是 `y = √(1-x²)`，下边界是 `y = -√(1-x²)`；
  换成水平方向则左右边界是 `x = ±√(1-y²)`。同样两种写法重合。
- 边界积分的符号来自遍历方向：逆时针时底边向右、斜边向左上、左边向下；
  反向遍历把每一项都取负，所以整个边界积分取负——而右端的区域内积分与方向无关。

# 陈述（自然语言）

1. `standardRightTriangle = xNormalDomain 0 1 (0) (1-x) = yNormalDomain 0 1 (0) (1-y)`；
2. `unitDisk = xNormalDomain (-1) 1 (-√(1-x²)) (√(1-x²)) = yNormalDomain (-1) 1 (-√(1-y²)) (√(1-y²))`；
3. 在两条区域上分别成立 Green 公式（在各自的导数可积与可微假设下）；
4. **真计算**：取 `(P,Q) = (0, x)`，直角三角形的逆时针边界积分等于 `1/2`，
   正是三角形面积（由 Green 公式，右端化为 `∬ 1`）；
5. **定向反例（三角形）**：反向遍历的边界积分等于 `-1/2`，与 `1/2` 不等——
   这反驳「边界积分与遍历方向无关」；
6. **定向反例（圆盘）**：反向遍历的边界积分等于原积分的相反数，因此只要原积分非零
   （例如取 `(P,Q) = (0,x)`，由 Green 公式该值是圆盘面积 `π`），两种定向给出不同的值。

# 陈述（Lean 对照）

```lean
def standardRightTriangle : Set (ℝ × ℝ) := {z | 0 ≤ z.1 ∧ 0 ≤ z.2 ∧ z.1 + z.2 ≤ 1}
lemma standardRightTriangle_eq_xNormal : standardRightTriangle = xNormalDomain 0 1 (fun _ ↦ 0) (fun x ↦ 1 - x)
lemma standardRightTriangle_eq_yNormal : standardRightTriangle = yNormalDomain 0 1 (fun _ ↦ 0) (fun y ↦ 1 - y)
theorem green_standardRightTriangle (P Q : ℝ × ℝ → ℝ) … :
    standardRightTriangleBoundaryIntegral P Q =
      ∫ z in standardRightTriangle, (deriv (fun x ↦ Q (x, z.2)) z.1 - deriv (fun y ↦ P (z.1, y)) z.2)
theorem standardRightTriangleBoundaryIntegral_zero_fst :
    standardRightTriangleBoundaryIntegral (fun _ ↦ 0) (fun z ↦ z.1) = 1 / 2

def unitDisk : Set (ℝ × ℝ) := {z | z.1 ^ 2 + z.2 ^ 2 ≤ 1}
lemma unitDisk_eq_xNormal : unitDisk = xNormalDomain (-1) 1 (fun x ↦ -√(1 - x ^ 2)) (fun x ↦ √(1 - x ^ 2))
lemma unitDisk_eq_yNormal : unitDisk = yNormalDomain (-1) 1 (fun y ↦ -√(1 - y ^ 2)) (fun y ↦ √(1 - y ^ 2))
theorem green_unitDisk (P Q : ℝ × ℝ → ℝ) … : unitDiskBoundaryIntegral P Q = …

-- 定向
def standardRightTriangleBoundaryIntegralRev (P Q : ℝ × ℝ → ℝ) : ℝ := …
theorem standardRightTriangleBoundaryIntegralRev_eq_neg (P Q) :
    standardRightTriangleBoundaryIntegralRev P Q = -standardRightTriangleBoundaryIntegral P Q
theorem standardRightTriangle_rev_ne_ccw :
    standardRightTriangleBoundaryIntegralRev (fun _ ↦ 0) (fun z ↦ z.1) ≠
      standardRightTriangleBoundaryIntegral (fun _ ↦ 0) (fun z ↦ z.1)
def unitDiskBoundaryIntegralRev (P Q : ℝ × ℝ → ℝ) : ℝ := …
theorem unitDiskBoundaryIntegralRev_eq_neg (P Q) :
    unitDiskBoundaryIntegralRev P Q = -unitDiskBoundaryIntegral P Q
theorem unitDisk_rev_ne_ccw_of_ne_zero (h : unitDiskBoundaryIntegral P Q ≠ 0) :
    unitDiskBoundaryIntegralRev P Q ≠ unitDiskBoundaryIntegral P Q
```

# 思维脉络

1. 区域表示：把图形写成集合，再逐元素证明它同时是竖直正常域与水平正常域。
   圆盘那两条要用 `Real.abs_le_sqrt`／`Real.sq_sqrt` 把 `x²+y² ≤ 1` 翻译成
   `|y| ≤ √(1-x²)`，是本节唯一需要不等式的步骤。
2. Green 公式：把两条正常域表示接起来（`xNormalDomain = yNormalDomain`），
   交给理论层的 `green_binormal_domain`，再把边界积分与区域写法对齐（`simpa`）。
3. 真计算 `1/2`：`(P,Q)=(0,x)` 时边界积分只剩 `∫₀¹ (1-y) dy`，用区间积分的线性性
   与 `∫₀¹ y dy = 1/2` 算出。
4. 定向反例：反向遍历把每个积分项的被减数与减数交换。证明分两步——先对每个积分用
   `integral_neg` 把负号搬进被积函数（`∫(g-f) = -∫(f-g)`），再对总和 `ring`。
   直接对总和用 `ring` 会失败：`ring` 把两个积分当独立原子，不知道它们互为相反数。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 竖直正常域 | `xNormalDomain a b lower upper` |
| 水平正常域 | `yNormalDomain c d left right` |
| 逆时针边界积分（三角形） | `standardRightTriangleBoundaryIntegral P Q` |
| 顺时针边界积分（三角形） | `standardRightTriangleBoundaryIntegralRev P Q` |
| 单位圆盘边界积分 | `unitDiskBoundaryIntegral P Q` |
| 三角形面积 | `1 / 2`（由 `(P,Q)=(0,x)` 的边界积分给出） |

# 依赖（人话版）

- `analysis.multivariable.green-gauss-stokes`：Green 公式本体（`green_binormal_domain`）
  与正常域表示（`xNormalDomain`、`yNormalDomain`、`normalDomainBoundaryIntegral`）
  由该条目承载；本 Entry 只做图形构造、坐标表示与数值计算。
- `analysis.multivariable.jordan-region`：Jordan 可测区域的一般框架由该条目承载，
  本 Entry 的两个区域是它的具体实例。
- Mathlib 是**私有证明后端**：`Real.sqrt` 的不等式、区间积分线性性与
  `integral_neg` 只用于把结论算出来。

# 应用与陷阱

- **应用**：这两个区域是后续 `examples.analysis.integral-theorems`（E3.6）的平面部分，
  也是「用边界积分算面积」这一教材手法的直接范例。
- **陷阱一（定向）**：边界积分依赖遍历方向。反例 5–6 说明反向遍历恰好取负，
  所以 Green 公式的逆时针约定不能删；写成公式时务必固定方向。
- **陷阱二（双正常域假设）**：`green_binormal_domain` 需要同一区域同时是竖直与水平
  正常域。圆盘满足，但「上半圆盘」或「环形」不满足，不能直接套用。
- **陷阱三（可微／可积假设）**：`green_standardRightTriangle` 与 `green_unitDisk`
  都带导数可积与逐点可微假设。这些不是形式主义装饰：边界积分与区域内积分的相等
  正是在这些假设下由 Newton–Leibniz 逐段拼出来的。
- **陷阱四（面积的解释）**：`1/2` 是**边界积分**的值，它等于面积是因为 Green 公式
  把 `(P,Q)=(0,x)` 的旋度 `∂Q/∂x - ∂P/∂y` 化为常数 `1`。不要把它读成
  「三角形面积可以直接由边界积分定义」。
