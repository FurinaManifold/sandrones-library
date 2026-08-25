---
id: analysis.multivariable.frechet
family: analysis.multivariable
variant: textbook
kind: definition
state: verified
title: Fréchet 全微分与方向导数
summary: 以线性主部的余项比值趋零定义 Fréchet 导数，并桥接 HasFDerivAt
premises: [topology.normed-space.def, topology.normed-space.inequalities]
mathlib: [ContinuousLinearMap, HasFDerivAt, HasLineDerivAt, hasFDerivAt_iff_tendsto,
  hasLineDerivAt_iff_tendsto_slope_zero, fderiv]
provenance:
  source_type: book
  ref: 多元微积分：Fréchet 导数与全微分
---

# 动机

多元函数在一点的一阶变化不能只由一个数描述，而需要一个同时处理所有方向的线性映射。仅把
`TotalDerivative` 写成连续线性映射类型还没有说明该映射为何是导数；关键条件是扣除线性主部后，
余项相对于增量范数小到一阶以下。

# 直觉

在 `x` 附近，希望用 `f x + A(y-x)` 近似 `f y`。若误差
`f y-f x-A(y-x)` 除以 `‖y-x‖` 后趋于零，那么 `A` 就捕捉了所有方向共同的一阶变化。
把 `A` 作用于方向 `v`，得到该方向的一阶变化率。

# 陈述（自然语言）

- `TotalDerivative` 的数据是从定义域到值域的连续实线性映射。
- `HasFrechetDerivativeAtTextbook f A x` 表示线性近似余项与增量范数之比趋于零。
- 该教材定义与 Mathlib 的 `HasFDerivAt f A x` 完全等价。
- `HasDirectionalDerivativeAtTextbook f d x v` 表示固定方向 `v` 上的去心差商趋于 `d`，
  并与 Mathlib 的 `HasLineDerivAt ℝ f d x v` 完全等价。
- Fréchet 可微时方向导数等于 `A v`；反向一般不成立。全微分满足唯一性、连续性和链式法则。

# 陈述（Lean 对照）

```lean
abbrev TotalDerivative := E →L[ℝ] F

def HasFrechetDerivativeAtTextbook (f : E → F) (A : E →L[ℝ] F) (x : E) : Prop :=
  Filter.Tendsto (fun y => ‖y - x‖⁻¹ * ‖f y - f x - A (y - x)‖)
    (nhds x) (nhds 0)

theorem hasFrechetDerivativeAtTextbook_iff_hasFDerivAt :
    HasFrechetDerivativeAtTextbook f A x ↔ HasFDerivAt f A x

def HasDirectionalDerivativeAtTextbook (f : E → F) (d : F) (x v : E) : Prop :=
  Filter.Tendsto (fun t : ℝ ↦ t⁻¹ • (f (x + t • v) - f x))
    (nhdsWithin 0 {0}ᶜ) (nhds d)

theorem hasDirectionalDerivativeAtTextbook_iff_hasLineDerivAt :
    HasDirectionalDerivativeAtTextbook f d x v ↔ HasLineDerivAt ℝ f d x v
```

# 思维脉络（thinking trace）

1. `A : E →L[ℝ] F` 同时记录线性性与连续性，是全微分的数据载体。
   `TotalDerivative` 只是该 Mathlib 类型的透明课程别名；“它确实是 `f` 的导数”由
   `HasFrechetDerivativeAtTextbook` 表达，而不由载体本身表达。
2. `f y-f x-A(y-x)` 是从实际增量中扣除线性主部后的余项。
3. 乘以 `‖y-x‖⁻¹` 等价于除以增量范数；目标极限为零就是 `o(‖y-x‖)`。
4. `hasFDerivAt_iff_tendsto` 正好给出同一余项比值极限，因此桥是直接的双向等价。
5. Mathlib 中零的逆为零，中心点处比值取零，不影响邻域极限。
6. 方向导数固定 `v` 后只考察直线 `t ↦ x+t • v`；其去心差商形式由
   `hasLineDerivAt_iff_tendsto_slope_zero` 精确桥接 Mathlib。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 连续线性主部 | `A : E →L[ℝ] F` |
| 全微分数据类型 | `TotalDerivative` |
| 余项 | `f y - f x - A (y - x)` |
| 余项小于一阶 | `‖y-x‖⁻¹ * ‖...‖ → 0` |
| 教材 Fréchet 导数条件 | `HasFrechetDerivativeAtTextbook f A x` |
| Mathlib Fréchet 导数条件 | `HasFDerivAt f A x` |
| Mathlib 选出的导数 | `fderiv ℝ f x` |
| 沿固定方向的去心差商极限 | `HasDirectionalDerivativeAtTextbook f d x v` |
| Mathlib 沿直线导数 | `HasLineDerivAt ℝ f d x v` |

# 依赖（人话版）

- 赋范加法交换群和实赋范空间：提供增量、范数、标量乘法和连续线性映射。
- `hasFDerivAt_iff_tendsto`：Mathlib Fréchet 导数与余项比值趋零之间的精确桥。
- `ContinuousLinearMap`：保证线性主部不仅代数线性，而且与拓扑结构相容。
  本库不重建其代数和拓扑结构，`TotalDerivative` 仅为教材记号，并已真实用于教材导数谓词。
- `HasLineDerivAt`：把固定方向问题化为参数 `t` 上的一元导数。

# 应用与陷阱

- 应用：链式法则、方向导数、梯度和 Jacobian 可以继续通过 `HasFDerivAt` 桥复用 Mathlib。
- 陷阱：只存在各方向导数一般不足以推出 Fréchet 可微；定义要求一个统一线性映射控制所有方向。
- 边界：本条只证明 Fréchet 可微推出各固定方向可导，不声明方向可导推出 Fréchet 可微。
- 陷阱：`fderiv` 在不可微点按约定取零，实际使用必须携带可微或 `HasFDerivAt` 假设。
- 边界：本条是一阶实 Fréchet 导数；高阶导数与一般标量域仍使用 Mathlib 的相应接口。
