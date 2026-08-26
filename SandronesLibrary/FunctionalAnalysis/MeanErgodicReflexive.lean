/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.MeanErgodicDecomposition
import SandronesLibrary.FunctionalAnalysis.EberleinSmulian

/-!
# 自反空间上的均值遍历收敛

本文件是均值遍历 decomposition 的第一个消费者：在自反 Banach 空间中，幂一致有界算子的
Cesàro 平均在每个向量上范数收敛。证明复用已冻结的弱子列判据，不重证均值遍历分解。
-/

namespace SandronesLibrary.FunctionalAnalysis

open Filter Set

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

omit [CompleteSpace E] in
private theorem isBounded_range_meanErgodicAverage_of_powerBounded
    {T : E →L[ℝ] E} {c : ℝ} (hc : 0 ≤ c) (hT : ∀ n : ℕ, ‖T ^ n‖ ≤ c) (x : E) :
    Bornology.IsBounded (Set.range fun n ↦ meanErgodicAverage T n x) := by
  refine (Metric.isBounded_closedBall :
    Bornology.IsBounded (Metric.closedBall (0 : E) (c * ‖x‖))).subset ?_
  rintro y ⟨n, rfl⟩
  rw [Metric.mem_closedBall, dist_zero_right]
  exact (ContinuousLinearMap.le_opNorm (meanErgodicAverage T n) x).trans
    (mul_le_mul_of_nonneg_right (norm_meanErgodicAverage_le hc hT n) (norm_nonneg x))

/-- 自反 Banach 空间中，幂一致有界算子的均值遍历收敛域是全空间。

自反性经 Eberlein--Šmulian 给每条有界 Cesàro 轨道提供弱收敛子列；decomposition 批已经证明
存在弱收敛子列当且仅当整条 Cesàro 平均在范数中收敛。

> **Entry**: functional-analysis.ergodic.mean.reflexive
-/
theorem meanErgodicConvergenceSubmodule_eq_top_of_reflexive
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) :
    meanErgodicConvergenceSubmodule T = ⊤ := by
  apply top_unique
  intro x _hx
  obtain ⟨c, hc, hpow⟩ := hT
  have hseq : IsSeqCompact (weakClosedUnitBall (E := E)) :=
    weakClosedUnitBall_isSeqCompact_of_reflexive hE
  have hextract :=
    (weakClosedUnitBall_isSeqCompact_iff_bounded_sequence (E := E)).mp hseq
      (fun n ↦ meanErgodicAverage T n x)
      (isBounded_range_meanErgodicAverage_of_powerBounded (zero_le_one.trans hc) hpow x)
  obtain ⟨z, φ, hφ, hweak⟩ := hextract
  exact (mem_meanErgodicConvergenceSubmodule_iff_weak_subsequence_of_powerBounded
    ⟨c, hc, hpow⟩ x).2
    ⟨z, φ, hφ, hweak⟩

/-- 自反 Banach 空间中，每个向量的 Cesàro 平均都在范数中收敛。 -/
theorem exists_tendsto_meanErgodicAverage_of_reflexive
    {T : E →L[ℝ] E} (hT : IsPowerBounded T)
    (hE : Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)) (x : E) :
    ∃ y, Tendsto (fun n ↦ meanErgodicAverage T n x) atTop (nhds y) := by
  have hx : x ∈ meanErgodicConvergenceSubmodule T := by
    rw [meanErgodicConvergenceSubmodule_eq_top_of_reflexive hT hE]
    exact Submodule.mem_top
  exact hx

end SandronesLibrary.FunctionalAnalysis
