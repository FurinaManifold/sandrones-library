---
id: real-analysis.riemann.lebesgue-criterion
kind: theorem
state: verified
title: "黎曼可积的 Lebesgue 判据"
premises: ["real-analysis.riemann.def", "real-analysis.riemann.cont-integrable", "real-analysis.lebesgue-measure"]
mathlib: ["MeasureTheory.measure_mono", "MeasureTheory.measure_biUnion_finset", "MeasureTheory.measure_iUnion_null", "MeasureTheory.measure_toMeasurable", "Set.exists_isOpen_lt_of_lt", "Metric.ediam", "Metric.uniformContinuousOn_iff", "OscillationWithin.eq_zero_iff_continuousWithinAt", "Real.volume_Ioc", "ENNReal.le_of_forall_pos_le_add"]
provenance:
  source_type: book
  ref: "Lebesgue criterion for Riemann integrability"
---

# 动机

黎曼积分要求函数在大多数小区间上振荡很小。Lebesgue 判据把这个条件压缩成一个结构性结论：对闭区间上的有界函数，真正阻碍黎曼可积性的，恰好是不连续点集具有正测度。

# 直觉

连续点可以用一致连续性控制局部振荡；若不连续点只有零测度，则它们可以被总长度任意小的开区间覆盖，剩余部分上的振荡贡献可以被控制。反方向则由振荡在不连续点处严格为正，推出不连续点集若有正测度就无法让 Darboux 上下和任意接近。

# 陈述（自然语言）

设 `a ≤ b`，且 `f` 在 `[a,b]` 上有界。函数 `f : ℝ → ℝ` 在 `[a,b]` 上黎曼可积，当且仅当它在 `[a,b]` 上几乎处处连续（相对于区间上的 Lebesgue 测度）。

# 陈述（Lean 对照）

```lean
def BoundedOn (f : ℝ → ℝ) (s : Set ℝ) : Prop :=
  ∃ C : ℝ, ∀ x ∈ s, |f x| ≤ C

def AlmostEverywhereContinuousOn (f : ℝ → ℝ) (a b : ℝ) : Prop :=
  ∀ᵐ x ∂volume.restrict (Set.Icc a b),
    ContinuousWithinAt f (Set.Icc a b) x

theorem riemannIntegrable_iff_boundedOn_ae_continuousOn {f : ℝ → ℝ} {a b : ℝ}
    (hab : a ≤ b) :
    RiemannIntegrableWithBound f a b ↔
      BoundedOn f (Set.Icc a b) ∧ AlmostEverywhereContinuousOn f a b
```

# 思维脉络（thinking trace）

当前已固定主定理接口，且正式证明已经完成，证明拆为两条方向：

1. `RiemannIntegrable → AlmostEverywhereContinuousOn`：从任意精度的 Darboux 上下和差出发，定义振荡层级并证明每个正振荡层集的测度为零，再用可数并得到不连续点集为零测度。
2. `AlmostEverywhereContinuousOn → RiemannIntegrable`：先利用有界区间上的可测零集覆盖，把不连续点集限制在总长度任意小的开集；连续部分用有限覆盖/一致连续性控制振荡，合并得到上下和差小于任意 `ε`。

两条方向均已由独立的振荡、测度覆盖和 Darboux 上下和估计引理实现；当前 theorem 不含 `sorry`。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 闭区间 | `Set.Icc a b` |
| 区间上的 Lebesgue 测度 | `volume.restrict (Set.Icc a b)` |
| 几乎处处 | `∀ᵐ x ∂μ, ...` |
| 区间内连续 | `ContinuousWithinAt f (Set.Icc a b) x` |
| 带有界性证据的黎曼可积 | `RiemannIntegrableWithBound f a b` |

# 依赖（人话版）

- `real-analysis.riemann.def`：提供 Darboux 分划、上下和与黎曼可积定义。
- `real-analysis.riemann.cont-integrable`：提供连续函数方向的基础样板和分划振荡估计。
- `real-analysis.lebesgue-measure`：提供区间的 Lebesgue 测度事实。

# 应用与陷阱

- 这里的“几乎处处连续”必须相对于 `volume.restrict (Set.Icc a b)` 理解，而不是整个实轴上的 `volume`。
- 有界性不能省略：单点修改可以制造无界函数，但不会改变几乎处处连续性。
- 经典 Lebesgue 判据通常还假设函数在闭区间上有界；当前库的 Darboux 定义需要在辅助引理中显式处理这一点，不能把它从标准教材陈述中悄悄省略。
