---
id: examples.real-analysis.measure-derivative
kind: example
state: verified
title: 测度导数具体计算例
summary: 常密度测度、标准正态测度关于 Lebesgue 测度的 Radon–Nikodym 导数，以及 Dirac 测度相对 Lebesgue 测度的互奇异与 Lebesgue 分解
premises: [real-analysis.measure-derivative.absolute-continuity, real-analysis.measure-derivative.mutually-singular, real-analysis.measure-derivative.lebesgue-decomposition, real-analysis.measure-derivative.radon-nikodym]
mathlib: [withDensity_absolutelyContinuous, Measure.rnDeriv_withDensity, withDensity_apply, setLIntegral_const, Real.volume_Icc, gaussianReal_absolutelyContinuous, rnDeriv_gaussianReal, Measure.mutuallySingular_dirac, Real.volume_singleton, Measure.dirac_apply_of_mem, Measure.singularPart_eq_self, Measure.MutuallySingular.rnDeriv_ae_eq_zero, Measure.haveLebesgueDecomposition_add]
provenance:
  source_type: book
  ref: "folland-real-analysis-1999"
---

# 动机

RA-F2（`real-analysis.measure-derivative.*`）把 Folland 第 3 章 §3.2 的绝对连续、互奇异、
Lebesgue 分解与 Radon–Nikodym 定理整理成抽象测度论命题。抽象命题只回答“存在密度”“分解
成立”，读者仍需要能拿在手里的数值对象来核对：密度到底怎么算、分解的两项分别长什么样。
本 Entry 就是这组具体对象。

# 直觉

- **绝对连续是“密度可写”的前提**。`ν.withDensity f` 自动 `≪ ν`；反过来 Radon–Nikodym 定理
  在 σ-有限条件下把 `μ ≪ ν` 提升为 `μ = ν.withDensity (μ.rnDeriv ν)`。
- **常密度测度的导数是常数**：`d(2·volume)/d(volume) = 2`，在单位区间上的质量问题恰为 `2`。
- **正态测度是勒贝格测度的密度测度**：`gaussianReal 0 1 = volume.withDensity (gaussianPDF 0 1)`，
  故其 Radon–Nikodym 导数就是正态密度。
- **互奇异是绝对连续的极端反面**：`δ₀` 把全部质量压在一个 `volume`-零集上，因此
  `δ₀` 与 `volume` 互奇异；它的 Lebesgue 分解的奇异部分取全部质量、密度部分恒为零。

# 陈述（自然语言）

1. 记 `twoVolume` 为“以常数 `2` 为密度的勒贝格测度”。则 `twoVolume ≪ volume`，
   `d(twoVolume)/d(volume) = 2`（a.e.），且 `twoVolume [0,1] = 2`。
2. `gaussianReal 0 1 ≪ volume`，且 `d(gaussianReal 0 1)/d(volume) = gaussianPDF 0 1`（a.e.）。
3. `δ₀ ⟂ₘ volume`；且 `δ₀` **不**绝对连续于 `volume`——`volume {0} = 0` 而 `δ₀ {0} = 1`。
4. `δ₀` 关于 `volume` 的 Lebesgue 分解为 `δ₀ = δ₀ + volume.withDensity 0`，即
   `(δ₀).singularPart volume = δ₀` 且 `d(δ₀)/d(volume) = 0`（a.e.）。

# 陈述（Lean 对照）

```lean
def twoVolume : Measure ℝ := volume.withDensity fun _ ↦ (2 : ℝ≥0∞)

theorem twoVolume_absolutelyContinuous : twoVolume ≪ volume
theorem twoVolume_rnDeriv : twoVolume.rnDeriv volume =ᵐ[volume] fun _ ↦ (2 : ℝ≥0∞)
theorem twoVolume_Icc_zero_one : twoVolume (Set.Icc (0 : ℝ) 1) = 2

theorem standardGaussian_absolutelyContinuous : gaussianReal 0 1 ≪ (volume : Measure ℝ)
theorem gaussianReal_rnDeriv :
    (gaussianReal 0 1).rnDeriv volume =ᵐ[volume] gaussianPDF 0 1

theorem dirac_zero_mutuallySingular_volume : (Measure.dirac (0 : ℝ)) ⟂ₘ (volume : Measure ℝ)
theorem dirac_zero_not_absolutelyContinuous :
    ¬ ((Measure.dirac (0 : ℝ)) ≪ (volume : Measure ℝ))
theorem dirac_zero_singularPart_eq_self :
    (Measure.dirac (0 : ℝ)).singularPart volume = Measure.dirac 0
theorem dirac_zero_rnDeriv_eq_zero :
    (Measure.dirac (0 : ℝ)).rnDeriv volume =ᵐ[volume] 0
theorem dirac_zero_lebesgueDecomposition :
    (Measure.dirac (0 : ℝ)) =
      (Measure.dirac (0 : ℝ)).singularPart volume +
        volume.withDensity ((Measure.dirac (0 : ℝ)).rnDeriv volume)
```

# 思维脉络

先造最简单的密度测度 `twoVolume`：由 `withDensity_absolutelyContinuous` 直接得到 `≪`，
由 `Measure.rnDeriv_withDensity` 直接得到导数 `2`（a.e.）。数值结论 `twoVolume [0,1] = 2`
需要把密度积分算出来：`withDensity_apply` 把测度值化为 `∫⁻ 2 in [0,1] ∂volume`，
`setLIntegral_const` 化为 `2 * volume [0,1]`，`Real.volume_Icc` 给出 `volume [0,1] = 1`。

接着把抽象定理换成实际分布：`gaussianReal 0 1` 恒等于 `volume.withDensity (gaussianPDF 0 1)`
（`variance ≠ 0` 分支），于是绝对连续与导数计算都只是上面的密度版本。

互奇异一侧用 Dirac 测度：`mutuallySingular_dirac` 给出 `δ₀ ⟂ₘ volume`。进一步证明
**不**绝对连续是本 Entry 的反例重点：绝对连续的定义要求“`volume s = 0 → δ₀ s = 0`”，
取 `s = {0}`，`Real.volume_singleton` 给 `volume {0} = 0`，而 `Measure.dirac_apply_of_mem`
给 `δ₀ {0} = 1 ≠ 0`。

最后由 `Measure.singularPart_eq_self` 与 `Measure.MutuallySingular.rnDeriv_ae_eq_zero` 把
分解的两项分别算成 `δ₀` 与 `0`，并用 `Measure.haveLebesgueDecomposition_add` 重写主等式。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 常密度 `2` 的测度 | `twoVolume` |
| 绝对连续 | `μ ≪ ν` |
| Radon–Nikodym 导数 | `μ.rnDeriv ν` |
| 几乎处处相等 | `=ᵐ[volume]` |
| 互奇异 | `⟂ₘ` |
| 奇异部分 / 密度部分 | `μ.singularPart ν` / `ν.withDensity (μ.rnDeriv ν)` |
| 标准正态测度 | `gaussianReal 0 1` |

# 依赖（人话版）

- `real-analysis.measure-derivative.absolute-continuity`：定义 `≪`、给出密度测度 `≪` 方向，
  以及零集单调性（反例证明直接使用其定义量词）。
- `real-analysis.measure-derivative.mutually-singular`：定义 `⟂ₘ`、给出 `μ ⟂ₘ ν` 时
  `rnDeriv` 几乎处处为零的接口。
- `real-analysis.measure-derivative.lebesgue-decomposition`：主分解等式
  `μ = μ.singularPart ν + ν.withDensity (μ.rnDeriv ν)`。
- `real-analysis.measure-derivative.radon-nikodym`：密度存在与 `rnDeriv` 的可测性／正性，
  是本 Entry 中“导数”一词的正式承载来源。

# 应用与陷阱

- **应用**：任何一个“密度函数”在教材中写出时都隐含本 Entry 的等式；正态、指数、
  均匀等分布关于 Lebesgue 测度的密度都可直接照此核对。
- **陷阱一**：`≪` 是测度层关系，不是函数层不等式。`μ ≪ ν` 并不推出 `μ ≤ ν`，
  也不推出 `rnDeriv` 处处有界；本 Entry 只对 `twoVolume`、`gaussianReal` 这类具体对象
  给出逐点／a.e. 结论。
- **陷阱二**：Dirac 测度是**反例**而非正例。若误把“存在密度”当成“任何测度都有密度”，
  `δ₀` 就是最直接的否定：它在 `volume`-零集 `{0}` 上给出正质量，因此不可能写成
  `volume.withDensity f`（否则该集合仍为零集）。奇异部分不为零正是这一点的定量形态。
