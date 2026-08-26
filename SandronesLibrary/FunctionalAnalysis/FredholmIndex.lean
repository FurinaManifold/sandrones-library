/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.FredholmCokernel
import Mathlib.LinearAlgebra.Projection

/-!
# 恒等减紧算子的 Fredholm 指数

本文件证明 `I-K` 的指数为零。证明不调用 Mathlib 的最终 Fredholm alternative：紧性先迫使
幂核链稳定；对偶算子上的同一结论与闭值域零化子定理迫使幂值域链稳定。由此得到一个
Fitting 分解，证明某个正幂指数为零，再用指数对复合的可加性回到 `I-K`。
-/

namespace SandronesLibrary.FunctionalAnalysis

open Filter Function Set _root_.Topology

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

/-- `1 - (1-K)^n`，它仍是紧算子。 -/
noncomputable def compactPowerRemainder (K : E →L[ℝ] E) (n : ℕ) : E →L[ℝ] E :=
  ContinuousLinearMap.id ℝ E - identitySubCompact K ^ n

omit [CompleteSpace E] in
@[simp]
theorem identitySubCompact_compactPowerRemainder (K : E →L[ℝ] E) (n : ℕ) :
    identitySubCompact (compactPowerRemainder K n) = identitySubCompact K ^ n := by
  ext x
  simp [compactPowerRemainder, identitySubCompact_apply]

omit [CompleteSpace E] in
theorem compactPowerRemainder_isCompactOperator (K : E →L[ℝ] E)
    (hK : IsCompactOperator K) (n : ℕ) :
    IsCompactOperator (compactPowerRemainder K n) := by
  induction n with
  | zero =>
      simpa [compactPowerRemainder] using
        (zero_isCompactOperator (E := E) (F := E))
  | succ n ih =>
      have heq : compactPowerRemainder K (n + 1) =
          compactPowerRemainder K n + (identitySubCompact K ^ n).comp K := by
        ext x
        simp [compactPowerRemainder, identitySubCompact_apply, pow_succ]
        module
      rw [heq]
      exact ih.add (hK.clm_comp (identitySubCompact K ^ n))

/-- 每个 `(I-K)^n` 都有闭值域。 -/
theorem isClosed_range_pow_identitySubCompact (K : E →L[ℝ] E)
    (hK : IsCompactOperator K) (n : ℕ) :
    IsClosed (Set.range (identitySubCompact K ^ n)) := by
  rw [← identitySubCompact_compactPowerRemainder K n]
  exact isClosed_range_identitySubCompact _
    (compactPowerRemainder_isCompactOperator K hK n)

/-- 每个 `(I-K)^n` 都有有限维核。 -/
theorem finiteDimensional_kernel_pow_identitySubCompact (K : E →L[ℝ] E)
    (hK : IsCompactOperator K) (n : ℕ) :
    FiniteDimensional ℝ (identitySubCompact K ^ n).ker := by
  rw [← identitySubCompact_compactPowerRemainder K n]
  exact finiteDimensional_kernel_identitySubCompact _
    (compactPowerRemainder_isCompactOperator K hK n)

/-- 每个 `(I-K)^n` 都有有限维余核。 -/
theorem finiteDimensional_cokernel_pow_identitySubCompact (K : E →L[ℝ] E)
    (hK : IsCompactOperator K) (n : ℕ) :
    FiniteDimensional ℝ (E ⧸ (identitySubCompact K ^ n).range) := by
  rw [← identitySubCompact_compactPowerRemainder K n]
  exact finiteDimensional_cokernel_identitySubCompact _
    (compactPowerRemainder_isCompactOperator K hK n)

omit [CompleteSpace E] in
/-- 紧扰动的幂核链最终停止严格增长。 -/
private theorem exists_kernel_pow_stabilizes (K : E →L[ℝ] E)
    (hK : IsCompactOperator K) :
    ∃ n : ℕ, (identitySubCompact K ^ (n + 1)).ker =
      (identitySubCompact K ^ n).ker := by
  let S : E →L[ℝ] E := identitySubCompact K
  let V (n : ℕ) : Submodule ℝ E := (S ^ n).ker
  by_contra! h
  have hVmono {p q : ℕ} (hpq : p ≤ q) : V p ≤ V q := by
    obtain ⟨d, rfl⟩ := Nat.exists_eq_add_of_le hpq
    intro u hu
    change (S ^ (p + d)) u = 0
    rw [Nat.add_comm, pow_add]
    change (S ^ d) ((S ^ p) u) = 0
    have hu0 : (S ^ p) u = 0 := LinearMap.mem_ker.mp hu
    rw [hu0, map_zero]
  have hproper (n : ℕ) : V n < V (n + 1) := by
    refine lt_of_le_of_ne (hVmono (Nat.le_succ n)) ?_
    exact Ne.symm (h n)
  obtain ⟨a : ℝ, ha⟩ := NormedField.exists_one_lt_norm ℝ
  have hx (n : ℕ) : ∃ x : E, x ∈ V (n + 1) ∧
      1 ≤ ‖x‖ ∧ ‖x‖ ≤ 1 + ‖a‖ ∧ ∀ y ∈ V n, 1 ≤ ‖x - y‖ := by
    have hclosed : IsClosed
        ((V n).comap (V (n + 1)).subtype : Set (V (n + 1))) := by
      exact (S ^ n).isClosed_ker.preimage (V (n + 1)).subtypeL.continuous
    obtain ⟨z : V (n + 1), hznorm, hdist⟩ :=
      riesz_lemma_of_norm_lt ha (show ‖a‖ < 1 + ‖a‖ by linarith) hclosed
        ⟨⟨Classical.choose (SetLike.exists_of_lt (hproper n)),
            (Classical.choose_spec (SetLike.exists_of_lt (hproper n))).1⟩,
          (Classical.choose_spec (SetLike.exists_of_lt (hproper n))).2⟩
    refine ⟨z.1, z.2, by simpa using hdist 0 (by simp), hznorm, ?_⟩
    intro y hy
    exact hdist ⟨y, hVmono (Nat.le_succ n) hy⟩ (by simpa)
  choose x hxV _hxlower hxupper hxfar using hx
  obtain ⟨Q, hQcompact, hQmem⟩ :=
    hK.image_closedBall_subset_compact (1 + ‖a‖)
  obtain ⟨y, _hyQ, ψ, hψmono, hKx⟩ := hQcompact.tendsto_subseq
    (x := fun n ↦ K (x n)) fun n ↦ hQmem ⟨x n, by
      simpa [Metric.mem_closedBall, dist_eq_norm] using hxupper n, rfl⟩
  have hS_mem (j : ℕ) {u : E} (hu : u ∈ V (j + 1)) : S u ∈ V j := by
    change (S ^ j) (S u) = 0
    have hu0 : (S ^ (j + 1)) u = 0 := LinearMap.mem_ker.mp hu
    rw [pow_succ] at hu0
    exact hu0
  have hsep (m n : ℕ) (hmn : m < n) : 1 ≤ ‖K (x n) - K (x m)‖ := by
    let z := S (x n) - S (x m) + x m
    have hz : z ∈ V n := by
      dsimp [z, V]
      apply Submodule.add_mem
      · exact Submodule.sub_mem _ (hS_mem n (hxV n))
          (hVmono hmn.le (hS_mem m (hxV m)))
      · exact hVmono (Nat.succ_le_of_lt hmn) (hxV m)
    have heq : K (x n) - K (x m) = x n - z := by
      dsimp [z, S]
      simp [identitySubCompact_apply]
      abel
    rw [heq]
    exact hxfar n z hz
  have hcauchy := hKx.cauchySeq
  rw [Metric.cauchySeq_iff'] at hcauchy
  obtain ⟨N, hN⟩ := hcauchy 1 (by norm_num)
  have hlt := hN (N + 1) (by omega)
  rw [dist_eq_norm] at hlt
  exact (not_le_of_gt hlt)
    (hsep (ψ N) (ψ (N + 1)) (hψmono (by omega)))

omit [CompleteSpace E] in
private theorem dualOperator_pow (T : E →L[ℝ] E) (n : ℕ) :
    dualOperator (T ^ n) = dualOperator T ^ n := by
  induction n with
  | zero =>
      change dualOperator (ContinuousLinearMap.id ℝ E) =
        ContinuousLinearMap.id ℝ (StrongDual ℝ E)
      exact dualOperator_id
  | succ n ih =>
      rw [pow_succ, pow_succ]
      change dualOperator ((T ^ n).comp T) =
        (dualOperator T ^ n).comp (dualOperator T)
      rw [dualOperator_comp, ih]
      exact (Commute.self_pow (dualOperator T) n).eq

omit [CompleteSpace E] in
/-- 两个闭子空间若具有相同的连续零化子，则相等。 -/
private theorem closedSubmodule_eq_of_annihilator_eq
    (A B : Submodule ℝ E) (hA : IsClosed (A : Set E))
    (hB : IsClosed (B : Set E))
    (hann : StrongDual.polarSubmodule ℝ A = StrongDual.polarSubmodule ℝ B) :
    A = B := by
  ext x
  rw [mem_closedSubspace_iff_forall_annihilator A hA,
    mem_closedSubspace_iff_forall_annihilator B hB, hann]

omit [CompleteSpace E] in
/-- 若幂核从次数 `k` 起稳定，则所有更高幂核都等于第 `k` 个幂核。 -/
private theorem kernel_pow_eq_of_stabilizes (T : E →L[ℝ] E) {k m : ℕ}
    (h : (T ^ (k + 1)).ker = (T ^ k).ker) :
    (T ^ k).ker = (T ^ (k + m)).ker := by
  have hlin : LinearMap.ker (T.toLinearMap ^ k) =
      LinearMap.ker (T.toLinearMap ^ k.succ) := by
    simpa [Nat.succ_eq_add_one] using h.symm
  simpa using Module.End.ker_pow_constant hlin m

/-- `I-K` 的某个正幂具有互补的核和值域。 -/
private theorem exists_isCompl_kernel_range_pow (K : E →L[ℝ] E)
    (hK : IsCompactOperator K) :
    ∃ N : ℕ, 0 < N ∧ IsCompl (identitySubCompact K ^ N).ker
      (identitySubCompact K ^ N).range := by
  let S := identitySubCompact K
  obtain ⟨k, hk⟩ := exists_kernel_pow_stabilizes K hK
  have hKdual : IsCompactOperator (dualOperator K) :=
    dualOperator_isCompactOperator K hK
  obtain ⟨d, hd⟩ := exists_kernel_pow_stabilizes (dualOperator K) hKdual
  let N := max k d + 1
  have hNpos : 0 < N := by simp [N]
  have hk_le_N : k ≤ N := by simp [N]; omega
  have hd_le_N : d ≤ N := by simp [N]; omega
  have hk_le_2N : k ≤ 2 * N := hk_le_N.trans (by omega)
  have hd_le_2N : d ≤ 2 * N := hd_le_N.trans (by omega)
  have hkN : (S ^ k).ker = (S ^ N).ker := by
    have h := kernel_pow_eq_of_stabilizes S (m := N - k) hk
    rwa [Nat.add_sub_of_le hk_le_N] at h
  have hk2N : (S ^ k).ker = (S ^ (2 * N)).ker := by
    have h := kernel_pow_eq_of_stabilizes S (m := 2 * N - k) hk
    rwa [Nat.add_sub_of_le hk_le_2N] at h
  have hker : (S ^ N).ker = (S ^ (2 * N)).ker := hkN.symm.trans hk2N
  let Sd := identitySubCompact (dualOperator K)
  have hdN : (Sd ^ d).ker = (Sd ^ N).ker := by
    have h := kernel_pow_eq_of_stabilizes Sd (m := N - d) hd
    rwa [Nat.add_sub_of_le hd_le_N] at h
  have hd2N : (Sd ^ d).ker = (Sd ^ (2 * N)).ker := by
    have h := kernel_pow_eq_of_stabilizes Sd (m := 2 * N - d) hd
    rwa [Nat.add_sub_of_le hd_le_2N] at h
  have hdualKer : (dualOperator (S ^ N)).ker =
      (dualOperator (S ^ (2 * N))).ker := by
    rw [dualOperator_pow, dualOperator_pow,
      dualOperator_identitySubCompact K]
    exact hdN.symm.trans hd2N
  have hann : StrongDual.polarSubmodule ℝ (S ^ N).range =
      StrongDual.polarSubmodule ℝ (S ^ (2 * N)).range := by
    rw [← dualOperator_ker_eq_range_annihilator,
      ← dualOperator_ker_eq_range_annihilator]
    exact hdualKer
  have hrange : (S ^ N).range = (S ^ (2 * N)).range :=
    closedSubmodule_eq_of_annihilator_eq _ _
      (isClosed_range_pow_identitySubCompact K hK N)
      (isClosed_range_pow_identitySubCompact K hK (2 * N)) hann
  refine ⟨N, hNpos, ?_⟩
  constructor
  · rw [Submodule.disjoint_def]
    rintro x hxker ⟨y, hy⟩
    have hx0 : x = 0 := by
      have hxker0 : (S ^ N) x = 0 := LinearMap.mem_ker.mp hxker
      have hyS : (S ^ N) y = x := hy
      have hy2 : (S ^ (2 * N)) y = 0 := by
        rw [show 2 * N = N + N by omega, pow_add]
        change (S ^ N) ((S ^ N) y) = 0
        rw [hyS]
        exact hxker0
      have hyN : y ∈ (S ^ N).ker := hker.symm ▸ hy2
      calc
        x = (S ^ N) y := hy.symm
        _ = 0 := LinearMap.mem_ker.mp hyN
    exact hx0
  · rw [codisjoint_iff]
    apply top_unique
    intro x _hx
    have hSx : (S ^ N) x ∈ (S ^ (2 * N)).range := by
      rw [← hrange]
      exact (S ^ N).mem_range_self x
    obtain ⟨y, hy⟩ := hSx
    apply Submodule.mem_sup.mpr
    refine ⟨x - (S ^ N) y, ?_, (S ^ N) y,
      (S ^ N).mem_range_self y, sub_add_cancel _ _⟩
    apply LinearMap.mem_ker.mpr
    change (S ^ N) (x - (S ^ N) y) = 0
    rw [map_sub]
    have hpow : (S ^ (2 * N)) y = (S ^ N) ((S ^ N) y) := by
      rw [show 2 * N = N + N by omega, pow_add]
      rfl
    rw [← hpow]
    exact sub_eq_zero.mpr hy.symm

omit [CompleteSpace E] in
/-- 若 `T` 的核和值域互补，则 `T` 的代数指数为零。 -/
private theorem index_eq_zero_of_isCompl_kernel_range (T : E →L[ℝ] E)
    (hcompl : IsCompl T.ker T.range) : T.toLinearMap.index = 0 := by
  rw [LinearMap.index_eq_finrank_sub]
  have hfin : Module.finrank ℝ (E ⧸ T.range) = Module.finrank ℝ T.ker :=
    (T.range.quotientEquivOfIsCompl T.ker hcompl.symm).finrank_eq
  omega

/-- 对所有正整数 `n`，有限核余核算子的幂指数是原指数的 `n` 倍。 -/
private theorem index_pow_identitySubCompact (K : E →L[ℝ] E)
    (hK : IsCompactOperator K) (n : ℕ) :
    (identitySubCompact K ^ n).toLinearMap.index =
      n * (identitySubCompact K).toLinearMap.index := by
  let S := identitySubCompact K
  induction n with
  | zero =>
      simp only [Nat.cast_zero, zero_mul]
      change (LinearMap.id : E →ₗ[ℝ] E).index = 0
      exact LinearMap.index_id
  | succ n ih =>
      let _ : FiniteDimensional ℝ (S ^ n).ker :=
        finiteDimensional_kernel_pow_identitySubCompact K hK n
      let _ : FiniteDimensional ℝ (E ⧸ (S ^ n).range) :=
        finiteDimensional_cokernel_pow_identitySubCompact K hK n
      let _ : FiniteDimensional ℝ S.ker :=
        finiteDimensional_kernel_identitySubCompact K hK
      let _ : FiniteDimensional ℝ (E ⧸ S.range) :=
        finiteDimensional_cokernel_identitySubCompact K hK
      rw [pow_succ]
      change (((S ^ n).toLinearMap ∘ₗ S.toLinearMap)).index = _
      rw [LinearMap.index_comp, ih]
      push_cast
      ring

/-- 紧算子 `K` 的恒等扰动 `I-K` 的 Fredholm 指数为零。

> **Entry**: functional-analysis.fredholm.alternative
-/
theorem index_identitySubCompact_eq_zero (K : E →L[ℝ] E)
    (hK : IsCompactOperator K) :
    (identitySubCompact K).toLinearMap.index = 0 := by
  obtain ⟨N, hNpos, hcompl⟩ := exists_isCompl_kernel_range_pow K hK
  have hpow : (identitySubCompact K ^ N).toLinearMap.index = 0 :=
    index_eq_zero_of_isCompl_kernel_range _ hcompl
  rw [index_pow_identitySubCompact K hK N] at hpow
  rcases mul_eq_zero.mp hpow with hN | hindex
  · have : (N : ℤ) ≠ 0 := by exact_mod_cast (Nat.ne_zero_of_lt hNpos)
    exact (this hN).elim
  · exact hindex

end SandronesLibrary.FunctionalAnalysis
