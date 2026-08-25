---
id: complex-analysis.cauchy.path-independence-primitive
family: complex-analysis.cauchy
variant: primitive
kind: theorem
state: verified
title: 原函数条件下的路径无关
summary: 在显式原函数、路径可微与可积条件下证明路径积分只依赖端点；同伦相等仅作为直接推论
premises: [complex-analysis.integral.path]
mathlib: [curveIntegral_eq_intervalIntegral_deriv, intervalIntegral.integral_eq_sub_of_hasDerivAt, HasDerivAt.comp_hasFDerivAt, ContinuousMap.Homotopy]
provenance:
  source_type: book
  ref: "Ahlfors, Complex Analysis, path independence from primitives; no unsupported simply-connected converse is asserted"
---

# 动机

路径积分的一般全纯同伦不变性是 Cauchy 理论连接拓扑与分析的核心接口。但“全纯函数在任意单连通开集上都有原函数”目前尚不是 Mathlib 已完成的定理。本 foundation 条目只从显式原函数假设出发，证明路径无关；一般同伦条目继续保持未完成。

# 直觉

若 `g' = f`，沿任意解析上合格的路径 `γ : a → b` 积分，链式法则把 integrand 识别为 `g ∘ γ` 的导数，所以积分等于 `g b - g a`。两条路径若端点相同，积分自然相同；具体选了哪一个同伦并不影响证明。

# 陈述（自然语言）

设路径的像包含于 `U`，其延拓在参数区间上实可微，且导数乘 integrand 的参数函数可积。若 `f` 在 `U` 上有原函数 `g`，则沿该路径的积分等于原函数的端点差。因此，两条满足这些解析条件、具有相同端点且同伦的路径，其积分相等。事实上原函数假设使“同伦”成为冗余条件，结论对任意同端点路径成立。

# 陈述（Lean 对照）

```lean
theorem pathIntegral_eq_sub_of_primitive
    (gamma : Path a b)
    (hmem : MapsTo gamma.extend (uIcc 0 1) U)
    (hdiff : ∀ t ∈ uIcc (0 : ℝ) 1, DifferentiableAt ℝ gamma.extend t)
    (hint : IntervalIntegrable
      (fun t : ℝ ↦ deriv gamma.extend t * f (gamma.extend t)) volume 0 1)
    (hg : ∀ z ∈ U, HasDerivAt g (f z) z) :
    pathIntegral f gamma = g b - g a
```

同伦包装定理名为 `pathIntegral_homotopyInvariant_of_primitive`。

# 思维脉络（thinking trace）

展开 `pathIntegral` 后，Mathlib 的 `curveIntegral_eq_intervalIntegral_deriv` 把曲线积分写成参数积分。对 `g ∘ gamma.extend` 使用复导数与实 Fréchet 导数的链式法则，再调用 `intervalIntegral.integral_eq_sub_of_hasDerivAt`。同伦版本分别对两条路径使用端点公式，右侧完全相同。

# 自然语言 ↔ Lean 映射

“路径留在 `U`”对应 `MapsTo gamma.extend (uIcc 0 1) U`；“参数上可微”对应逐点 `DifferentiableAt ℝ gamma.extend t`；“路径积分存在”在证明需要的精确层面写成 integrand 的 `IntervalIntegrable`；“原函数”对应 `HasDerivAt g (f z) z`。`Path` 本身只编码连续性，不能自动当作分段 `C¹` 路径。

# 依赖（人话版）

本条目依赖 `PathIntegral.lean` 对 Mathlib `curveIntegral` 的封装、区间积分微积分基本定理、复导数限制标量后的链式法则，以及 Mathlib 的 `ContinuousMap.Homotopy` 类型。圆盘上原函数的存在可由 `DifferentiableOn.isExactOn_ball` 另行提供。

# 应用与陷阱

原函数接口可直接用于证明闭路积分为零、折线路径的端点依赖及圆盘内的路径无关。不要从这里推出任意单连通开集上的结果：Mathlib 当前仅在圆盘和全平面上提供相关原函数存在定理。另一个常见错误是只给拓扑同伦而省略路径正则性；路径积分定义涉及导数与可积性，连续同伦本身不补足这些解析条件。
