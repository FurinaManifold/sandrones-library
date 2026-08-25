---
id: complex-analysis.cauchy.primitive-from-path-independence-foundation
family: complex-analysis.cauchy
variant: endpoint-independent-integrals
kind: theorem
state: verified
title: 由路径积分无关性构造原函数
summary: 若开全纯域内从基点可达且任意同端点可积道路的积分相等，则从基点到变量终点的积分定义一个原函数
premises: [complex-analysis.holomorphic.definition, complex-analysis.integral.path, complex-analysis.cauchy.smooth-homotopy-foundation]
mathlib: [HasFDerivWithinAt.curveIntegral_segment_source, Path.trans_range, curveIntegrable_segment, Metric.isOpen_iff]
provenance:
  source_type: book
  ref: "Ahlfors, Complex Analysis, construction of a primitive by path integration"
---

# 动机

“单连通域上的全纯函数有原函数”包含两个不同问题：拓扑部分要证明积分与道路选择无关，分析部分要证明从基点积分得到的函数导数等于原函数。若把两部分塞进一个定理，形式化缺口很难定位。本条独立完成第二部分，使后续只需集中解决一般连续同伦如何推出路径积分无关。

# 直觉

固定基点 `c`，对每个 `z` 选择一条域内道路，并定义 `g(z)` 为 `f` 沿该道路的积分。若积分只依赖端点，那么在 `z` 附近计算 `g(w)` 时，可以把所选道路换成“到 `z` 的旧道路，再接上短线段 `z→w`”。前一段贡献常数，短线段积分对终点 `w` 的导数恰好是 `f(z)`，所以 `g'(z)=f(z)`。

# 陈述（自然语言）

设 `U` 是开集，`f` 在 `U` 上全纯，`c` 是固定基点。假设 `U` 中每个点都能由一条从 `c` 出发、像留在 `U` 且 `f(z)dz` 可积的道路到达；再假设任意两条具有相同端点的这类道路积分相等。则存在复函数 `g`，使得对每个 `z∈U` 都有 `g'(z)=f(z)`。

# 陈述（Lean 对照）

```lean
def AdmissiblePath (f : ℂ → ℂ) (U : Set ℂ) (gamma : Path a b) : Prop :=
  Set.range gamma ⊆ U ∧ PathIntegrable f gamma

def PathIntegralIndependentOn (f : ℂ → ℂ) (U : Set ℂ) : Prop := ...

theorem exists_primitive_of_pathIntegralIndependentOn
    (hU : IsOpen U) (hf : HolomorphicOnTextbook f U)
    (hpaths : ∀ z ∈ U, ∃ gamma : Path c z, AdmissiblePath f U gamma)
    (hind : PathIntegralIndependentOn f U) :
    ∃ g : ℂ → ℂ, ∀ z ∈ U, HasDerivAt g (f z) z
```

# 思维脉络（thinking trace）

用经典选择取得每个点的规范道路 `P z`，并在 `U` 内定义 `g z = pathIntegral f (P z)`。固定 `z` 后，由开放性选取闭包仍留在 `U` 的小球。对球内 `w`，线段 `z→w` 留在球内且因全纯函数连续而可积；`P z` 与该线段的拼接也是 admissible。端点无关性把 `P w` 的积分替换为拼接积分，拼接公式再给出 `g(w)=g(z)+∫_[z,w]f`。最后使用曲线积分关于线段终点的 Fréchet 导数定理，并在小球邻域上以函数最终相等转移导数。

# 自然语言 ↔ Lean 映射

“域内可积道路”对应 `AdmissiblePath` 的像包含与 `PathIntegrable` 合取；“积分只依赖端点”对应 `PathIntegralIndependentOn`；“选取从基点到每一点的道路”由依赖型函数 `P : ∀ z : U, {gamma : Path c z // ...}` 承载；“接上短线段”对应 `Path.trans`；“邻域内等于常数加短线段积分”对应滤子等式 `=ᶠ[nhds z]`。

# 依赖（人话版）

本条依赖本库的全纯、路径积分、拼接和可积性接口。Mathlib 后端只用于开放集的小球刻画、凸球内线段、拼接道路的值域，以及曲线积分对线段终点的局部导数。路径积分无关性是明确的输入，没有借用原函数存在结论证明自身。

# 应用与陷阱

该定理是一般单连通原函数定理的分析构造层，不是最终拓扑定理。`PathIntegralIndependentOn` 必须由 Goursat、同伦或多边形逼近另行证明；仅有道路连通性不够。`AdmissiblePath` 只要求曲线可积，不宣称所有连续 `Path` 自动可积。也不能把经典选择误读为可计算的规范道路算法：它只用于存在性证明。
