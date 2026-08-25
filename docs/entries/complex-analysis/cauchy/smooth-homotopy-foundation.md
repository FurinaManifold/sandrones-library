---
id: complex-analysis.cauchy.smooth-homotopy-foundation
family: complex-analysis.cauchy
variant: c2-relative-endpoint
kind: theorem
state: verified
title: C² 道路同伦下的全纯路径积分不变性
summary: 若两条同端点道路由像留在全纯域内的 C² 相对端点同伦连接，则全纯函数沿它们的路径积分相等
premises: [complex-analysis.holomorphic.definition, complex-analysis.integral.path, complex-analysis.cauchy.triangle]
mathlib: [ContinuousMap.Homotopy.curveIntegral_add_curveIntegral_eq_of_hasFDerivWithinAt, Path.Homotopy, ContDiffOn, ContinuousLinearMap.smulRightL]
provenance:
  source_type: book
  ref: "Ahlfors, Complex Analysis, homotopy form of Cauchy's theorem; C2-regular foundation"
---

# 动机

三角形 Goursat 定理是局部结论；要进入单连通域原函数和闭曲线理论，需要知道连续变形道路时积分不变。曲线积分的严格证明必须控制同伦本身的可微性。本条首先完成 Mathlib 当前直接支持的 `C²` 相对端点版本，并把从普通连续同伦到光滑同伦的剩余桥明确隔离。

# 直觉

把同伦看成单位正方形到复平面的参数曲面。`f(z) dz` 的外微分为零：复可微性使其一形式导数在两个方向上对称。正方形边界积分因此为零。上下两边是原来的两条道路，左右两边因为端点在同伦过程中固定而是常值道路，其积分为零，所以两条目标积分相等。

# 陈述（自然语言）

设 `U` 是开集，`f` 在 `U` 上按本库定义全纯。若同端点道路 `gamma` 与 `delta` 之间存在一个相对端点同伦，其整个像位于 `U`，并且该同伦按标准方式延拓到实单位正方形后是二阶连续可微的，则 `f` 沿两条道路的积分相等。特别地，若闭道路以这种方式同伦于常值道路，则其积分为零。

# 陈述（Lean 对照）

```lean
def C2HomotopicWithin (U : Set ℂ) (gamma delta : Path a b) : Prop :=
  ∃ F : gamma.Homotopy delta,
    (∀ s t : I, F (s, t) ∈ U) ∧ ContDiffOn ℝ 2 (...) (Icc 0 1)

theorem pathIntegral_eq_of_C2HomotopicWithin
    (hU : IsOpen U) (hf : HolomorphicOnTextbook f U)
    (hhom : C2HomotopicWithin U gamma delta) :
    pathIntegral f gamma = pathIntegral f delta
```

闭道路推论为 `pathIntegral_eq_zero_of_C2NullHomotopicWithin`。

# 思维脉络（thinking trace）

先把 `f(z) dz` 写成由 `smulRightL` 生成的连续线性映射值函数。其真实 Fréchet 导数由 `f` 的复导数与该线性构造复合得到；对方向 `u,v` 求值后是 `v * (u * f'(z))`，交换复数乘法便得到对称性。随后只在同伦像的紧集 `T = range F` 上工作：`T` 闭且包含于 `U`，因此导数和连续性前提都可从全纯性限制下来。Poincare 曲线积分公式给出正方形四边关系，相对端点条件把两条侧边识别为常值道路，最后消去零积分。

# 自然语言 ↔ Lean 映射

“同端点道路同伦”对应 `gamma.Homotopy delta`，它是固定 `{0,1}` 的 `HomotopyRel`；“像留在 `U`”对应 `∀ s t : I, F (s,t) ∈ U`；“二阶光滑”对应标准 `IccExtend` 上的 `ContDiffOn ℝ 2`；“闭一形式”不是额外假设，而由 `scalarOneFormFDeriv_symmetric` 从复乘法交换律证明。

# 依赖（人话版）

本条依赖本库教材全纯定义与路径积分定义，使用 Mathlib 的道路同伦、连续可微和 Poincare 曲线积分公式。证明显式建立标量一形式的导数与对称性，没有预设原函数，也没有调用尚不存在的“一般单连通域全纯函数有原函数”接口。

# 应用与陷阱

本条能直接处理给出具体光滑同伦的道路和光滑可缩闭曲线。它尚不是仅凭 `Path.Homotopic` 的纯拓扑版本：普通道路同伦只保证连续，Mathlib 当前没有提供在开子集内保持端点和平滑性的同伦逼近定理。因此不得用本 foundation id 标记 ROADMAP 的一般同伦或单连通域原函数已经完成；下一步必须补齐该平滑化桥或给出独立的多边形逼近证明。
