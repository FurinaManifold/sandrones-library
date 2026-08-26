/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.MeanErgodicReflexive

/-!
# 自反空间上的均值遍历极限投影

本文件把处处存在的 Cesàro 范数极限组装为连续线性算子，并证明教材恒等式
`ST = TS = S² = S`。它只消费 decomposition 与 reflexive convergence 的公开接口。
-/

namespace SandronesLibrary.FunctionalAnalysis

open Filter

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

private noncomputable def meanErgodicLimitVector
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) (x : E) : E :=
  Classical.choose (exists_tendsto_meanErgodicAverage_of_reflexive hT hE x)

private theorem tendsto_meanErgodicLimitVector
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) (x : E) :
    Tendsto (fun n ↦ meanErgodicAverage T n x) atTop
      (nhds (meanErgodicLimitVector hT hE x)) :=
  Classical.choose_spec (exists_tendsto_meanErgodicAverage_of_reflexive hT hE x)

private noncomputable def meanErgodicLimitLinearMap
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) : E →ₗ[ℝ] E where
  toFun := meanErgodicLimitVector hT hE
  map_add' x y := by
    apply tendsto_nhds_unique (tendsto_meanErgodicLimitVector hT hE (x + y))
    simpa only [map_add] using
      (tendsto_meanErgodicLimitVector hT hE x).add
        (tendsto_meanErgodicLimitVector hT hE y)
  map_smul' a x := by
    apply tendsto_nhds_unique (tendsto_meanErgodicLimitVector hT hE (a • x))
    simpa only [map_smul, RingHom.id_apply] using
      (tendsto_meanErgodicLimitVector hT hE x).const_smul a

private theorem norm_meanErgodicLimitLinearMap_le
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E))
    {c : ℝ} (hc : 0 ≤ c) (hpow : ∀ n : ℕ, ‖T ^ n‖ ≤ c) (x : E) :
    ‖meanErgodicLimitLinearMap hT hE x‖ ≤ c * ‖x‖ := by
  apply le_of_tendsto (tendsto_meanErgodicLimitVector hT hE x).norm
  exact Filter.Eventually.of_forall fun n ↦
    (ContinuousLinearMap.le_opNorm (meanErgodicAverage T n) x).trans
      (mul_le_mul_of_nonneg_right (norm_meanErgodicAverage_le hc hpow n) (norm_nonneg x))

/-- 自反 Banach 空间上幂一致有界算子的均值遍历极限，组装为连续线性算子。

> **Entry**: functional-analysis.ergodic.mean.projection
-/
noncomputable def meanErgodicLimitOperator
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) : E →L[ℝ] E :=
  LinearMap.mkContinuous (meanErgodicLimitLinearMap hT hE) (Classical.choose hT)
    (fun x ↦ norm_meanErgodicLimitLinearMap_le hT hE
      (zero_le_one.trans (Classical.choose_spec hT).1) (Classical.choose_spec hT).2 x)

/-- Cesàro 平均逐点范数收敛到均值遍历极限算子。 -/
theorem tendsto_meanErgodicAverage_meanErgodicLimitOperator
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) (x : E) :
    Tendsto (fun n ↦ meanErgodicAverage T n x) atTop
      (nhds (meanErgodicLimitOperator hT hE x)) :=
  tendsto_meanErgodicLimitVector hT hE x

/-- 均值遍历极限属于 `T` 的固定点空间。 -/
theorem meanErgodicLimitOperator_mem_fixed
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) (x : E) :
    meanErgodicLimitOperator hT hE x ∈ meanErgodicFixedSubmodule T := by
  obtain ⟨c, hc, hpow⟩ := hT
  exact mem_fixed_of_tendsto_meanErgodicAverage (zero_le_one.trans hc) hpow
    (tendsto_meanErgodicAverage_meanErgodicLimitOperator ⟨c, hc, hpow⟩ hE x)

/-- 均值遍历极限算子在固定点空间上是恒等算子。 -/
theorem meanErgodicLimitOperator_apply_fixed
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E))
    {x : E} (hx : x ∈ meanErgodicFixedSubmodule T) :
    meanErgodicLimitOperator hT hE x = x := by
  exact tendsto_nhds_unique
    (tendsto_meanErgodicAverage_meanErgodicLimitOperator hT hE x)
    (tendsto_meanErgodicAverage_fixed hx)

/-- 极限算子与 `T` 交换。 -/
theorem meanErgodicLimitOperator_commute
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) :
    (meanErgodicLimitOperator hT hE).comp T =
      T.comp (meanErgodicLimitOperator hT hE) := by
  ext x
  apply tendsto_nhds_unique
    (tendsto_meanErgodicAverage_meanErgodicLimitOperator hT hE (T x))
  have hlim := (T.continuous.continuousAt.tendsto.comp
    (tendsto_meanErgodicAverage_meanErgodicLimitOperator hT hE x))
  simpa only [ContinuousLinearMap.comp_apply] using hlim.congr' <|
    Filter.Eventually.of_forall fun n ↦ by
      exact (congrArg (fun A : E →L[ℝ] E ↦ A x) (meanErgodicAverage_commute T n)).symm

/-- `T` 作用在均值遍历极限之后不改变极限。 -/
theorem T_comp_meanErgodicLimitOperator
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) :
    T.comp (meanErgodicLimitOperator hT hE) = meanErgodicLimitOperator hT hE := by
  ext x
  exact LinearMap.mem_eqLocus.mp (meanErgodicLimitOperator_mem_fixed hT hE x)

/-- 均值遍历极限算子是幂等投影。 -/
theorem meanErgodicLimitOperator_idempotent
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) :
    (meanErgodicLimitOperator hT hE).comp (meanErgodicLimitOperator hT hE) =
      meanErgodicLimitOperator hT hE := by
  ext x
  exact meanErgodicLimitOperator_apply_fixed hT hE
    (meanErgodicLimitOperator_mem_fixed hT hE x)

/-- 教材恒等式 `ST = TS = S² = S`。 -/
theorem meanErgodicLimitOperator_identities
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) :
    (meanErgodicLimitOperator hT hE).comp T = meanErgodicLimitOperator hT hE ∧
      T.comp (meanErgodicLimitOperator hT hE) = meanErgodicLimitOperator hT hE ∧
      (meanErgodicLimitOperator hT hE).comp (meanErgodicLimitOperator hT hE) =
        meanErgodicLimitOperator hT hE := by
  have hTS := T_comp_meanErgodicLimitOperator hT hE
  exact ⟨(meanErgodicLimitOperator_commute hT hE).trans hTS, hTS,
    meanErgodicLimitOperator_idempotent hT hE⟩

end SandronesLibrary.FunctionalAnalysis
