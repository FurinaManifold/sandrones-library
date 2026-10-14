---
id: examples.analysis.gauss-stokes
kind: example
state: verified
title: 单位立方体的 Gauss 与水平单位正方形的 Stokes 计算例
summary: 位置向量场在单位立方体上的外向通量为 3、1-形式 x dy 在水平单位正方形上的边界环流为 1，以及法向定向与切向量次序反转改变符号的精确反例
premises: [analysis.multivariable.green-gauss-stokes]
mathlib: [setIntegral_const, integrableOn_const, measure_Icc_lt_top, Real.volume_Icc_pi_toReal, isCompact_Icc, ContinuousLinearMap.fst, Finset.sum_neg_distrib]
provenance:
  source_type: book
  ref: "spivak-calculus-manifolds-1965"
---

# 动机

理论条目 `analysis.multivariable.green-gauss-stokes` 给出盒上的 Gauss 散度公式与参数
矩形上的 Stokes 公式。两个公式在教材里最先被检验的实例是：单位立方体上的位置向量场
（散度恒为 `3`，通量应等于体积 `1` 乘 `3`）与水平单位正方形上的 1-形式 `x dy`
（外微分密度恒为 `1`，环流应等于面积 `1`）。本 Entry 把这两条算到底。

两条公式都带**定向约定**：Gauss 用外向法向，Stokes 用切向量次序 `(∂ᵤσ, ∂ᵥσ)` 决定的
曲面方向。本 Entry 各配一条定向反例，说明这些约定不能省略。

# 直觉

- 单位立方体上取 `F(x) = x`：位置向量场的 Fréchet 导数是恒等映射，散度是
  `1+1+1 = 3`。六个面的外向通量加起来等于 `3 × 体积 = 3 × 1 = 3`。
- 水平单位正方形参数化 `σ(u,v) = (u,v,0)`：1-形式 `x dy` 的拉回是 `u dv`
  （`du` 的系数为 `0`），外微分密度 `∂(u)/∂u - ∂(0)/∂v = 1`。边界环流等于
  `1 × 面积 = 1`。
- 定向：把六个面的法向取反（内向），通量整体变号；把两个切向量交换，
  拉回从 `u dv` 变成 `v du`，外微分密度变成 `-1`，环流随之变成 `-1`。

# 陈述（自然语言）

1. **Gauss**：单位立方体 `[0,1]³` 上位置向量场 `F(x)=x` 的六面外向通量等于 `3`；
2. **Stokes**：水平单位正方形（`σ(u,v)=(u,v,0)`，参数域 `[0,1]²`）上 `x dy` 的
   边界环流等于 `1`；
3. **定向反例（Gauss）**：把六个面的法向全部取反得到内向通量，它等于 `-3`，
   与 `3` 不等——这反驳「通量与法向定向无关」；
4. **定向反例（Stokes）**：交换切向量次序得到 `σ(u,v) = (v,u,0)`，同一 1-形式
   `x dy` 的拉回变成 `v du`，边界环流等于 `-1`——这反驳「环流与曲面定向无关」。

# 陈述（Lean 对照）

```lean
def unitCubeLower : Fin 3 → ℝ := fun _ ↦ 0
def unitCubeUpper : Fin 3 → ℝ := fun _ ↦ 1
theorem gauss_unitCube_identity :
    boxBoundaryFlux3 (fun x : Fin 3 → ℝ ↦ x) unitCubeLower unitCubeUpper = 3

def horizontalUnitSquare : ParametrizedSurface 3 := affinePlane 0 ![1, 0, 0] ![0, 1, 0]
def xDyForm (x : Fin 3 → ℝ) : (Fin 3 → ℝ) →L[ℝ] ℝ := x 0 • (ContinuousLinearMap.proj 1)
theorem stokes_horizontalUnitSquare_xDy :
    rectangleBoundaryIntegral
      (surfacePullbackCoeff₁ xDyForm horizontalUnitSquare)
      (surfacePullbackCoeff₂ xDyForm horizontalUnitSquare) 0 0 1 1 = 1

-- 定向
def boxBoundaryFlux3Inward (F : (Fin 3 → ℝ) → (Fin 3 → ℝ)) (a b : Fin 3 → ℝ) : ℝ := …
theorem boxBoundaryFlux3Inward_eq_neg (F) (a b) :
    boxBoundaryFlux3Inward F a b = -boxBoundaryFlux3 F a b
theorem gauss_inward_ne_outward :
    boxBoundaryFlux3Inward (fun x : Fin 3 → ℝ ↦ x) unitCubeLower unitCubeUpper ≠
      boxBoundaryFlux3 (fun x : Fin 3 → ℝ ↦ x) unitCubeLower unitCubeUpper
def horizontalUnitSquareRev : ParametrizedSurface 3 := affinePlane 0 ![0, 1, 0] ![1, 0, 0]
theorem stokes_horizontalUnitSquareRev_xDy :
    rectangleBoundaryIntegral
      (surfacePullbackCoeff₁ xDyForm horizontalUnitSquareRev)
      (surfacePullbackCoeff₂ xDyForm horizontalUnitSquareRev) 0 0 1 1 = -1
```

# 思维脉络

1. Gauss：把位置向量场的导数取成常值恒等映射 `ContinuousLinearMap.id`，散度
   `divergence3` 逐坐标求和得 `3`；调用 `gauss_box3` 后右端是常数 `3` 在盒上的积分，
   再用 `Real.volume_Icc_pi_toReal` 与单位盒的体积 `1` 算出 `3`。
2. Stokes：先算拉回系数——`surfacePullbackCoeff₁ = 0`、`surfacePullbackCoeff₂ = u`
   （用 `surfaceTangent₁_affinePlane`／`surfaceTangent₂_affinePlane` 把切向量换成
   生成向量）；再对 `P = 0`、`Q = u` 调用 `stokes_parametrized_rectangle`，
   右端化为常数 `1` 在单位参数正方形上的积分，等于 `1`。
3. 定向反例（Gauss）：把六个面的法向逐面取反写成新的和式，用
   `← Finset.sum_neg_distrib` 把符号提到求和号外，再逐项 `ring`；代位置向量场与
   已证的 `3` 得 `-3 ≠ 3`。
4. 定向反例（Stokes）：交换生成向量次序后重算拉回（`x dy` 沿 `(0,1,0)` 给 `v`，
   沿 `(1,0,0)` 给 `0`），于是被积函数变成 `(v, 0)`；矩形边界积分只剩
   `-∫₀¹ 1 dv = -1`，由 `norm_num` 收尾。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 单位立方体 | `Icc unitCubeLower unitCubeUpper`，`Fin 3 → ℝ` |
| 位置向量场 | `fun x : Fin 3 → ℝ ↦ x` |
| 散度 | `divergence3 F'` |
| 六面外向通量 | `boxBoundaryFlux3 F a b` |
| 六面向内通量 | `boxBoundaryFlux3Inward F a b` |
| 水平单位正方形 | `affinePlane 0 ![1,0,0] ![0,1,0]` |
| 反向定向的同一正方形 | `affinePlane 0 ![0,1,0] ![1,0,0]` |
| 1-形式 `x dy` | `xDyForm` |
| 边界环流 | `rectangleBoundaryIntegral (pullback₁) (pullback₂) 0 0 1 1` |

# 依赖（人话版）

- `analysis.multivariable.green-gauss-stokes`：`gauss_box3`、`stokes_parametrized_rectangle`、
  `boxBoundaryFlux3`、`divergence3`、`rectangleBoundaryIntegral`、`surfacePullbackCoeff₁/₂`
  都由该条目承载；本 Entry 只做具体场、具体曲面与数值计算。
- 参数化几何（`affinePlane`、`surfaceTangent₁/₂_affinePlane`）来自 `Analysis` 的
  参数化接口，经同一理论条目暴露；本文件不重新定义曲面。
- Mathlib 是**私有证明后端**：常数积分、盒的体积公式与求和符号运算只用于把数值算出来。

# 应用与陷阱

- **应用**：这两条是三大公式的最低成本检验例——把公式两边的数值都算成一个具体整数，
  任何系数错误（例如散度漏一项、拉回系数次序颠倒）都会立刻暴露。
- **陷阱一（定向）**：Gauss 的「外向」与 Stokes 的「切向量次序」都是公式的一部分。
  反例 3–4 给出精确的符号翻转，说明不能靠「差一个符号无所谓」蒙混。
- **陷阱二（Stokes 的拉回）**：`x dy` 的拉回是 `u dv`，不是 `v du`；写反会让
  外微分密度变成 `-1`。反向参数化的反例正是把这一点做成定理。
- **陷阱三（Gauss 的体积因子）**：`boxBoundaryFlux3` 的值是**通量**，等于
  散度积分；单位立方体上体积为 `1` 才使数值恰好等于散度常数 `3`。换成 `[0,2]³`
  通量就是 `24`，不要把 `3` 误当成与区域无关的常数。
- **陷阱四（参数域方向）**：`rectangleBoundaryIntegral` 的参数域是 `0 0 1 1`，
  与参数化的切向量次序共同决定曲面方向；只改参数域上下限而不改切向量次序，
  得到的是另一个（可能反向的）定向。
