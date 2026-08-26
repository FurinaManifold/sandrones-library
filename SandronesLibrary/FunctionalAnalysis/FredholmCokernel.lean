/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.SchauderCompactness
import SandronesLibrary.FunctionalAnalysis.CompactPerturbationIdentity
import SandronesLibrary.FunctionalAnalysis.ClosedRangeConsequences
import Mathlib.LinearAlgebra.Dual.Lemmas

/-!
# 恒等减紧算子的余核

本文件沿教材的闭值域与对偶零化子路线证明 `I-K` 的余核有限维。核心映射把向量送到
其在对偶算子核上的取值泛函；闭值域定理识别它的核，而 Schauder 定理保证目标有限维。

这里不调用 Mathlib 的最终 Fredholm alternative。

> **Entry**: functional-analysis.fredholm.cokernel
-/

namespace SandronesLibrary.FunctionalAnalysis

open Set

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

/-- 向量在对偶算子核上的典范取值泛函。它是识别余核与对偶核之对偶的代数映射。 -/
noncomputable def evaluationOnDualKernel (D : E →L[ℝ] E) :
    E →ₗ[ℝ] Module.Dual ℝ (dualOperator D).ker where
  toFun y :=
    { toFun := fun f ↦ f.1 y
      map_add' := fun _ _ ↦ rfl
      map_smul' := fun _ _ ↦ rfl }
  map_add' _ _ := by ext; simp
  map_smul' _ _ := by ext; simp

/-- 当 `D` 的值域闭时，在对偶核上为零的向量恰好属于 `D` 的值域。 -/
theorem evaluationOnDualKernel_ker_eq_range (D : E →L[ℝ] E)
    (hD : IsClosed (Set.range D)) :
    (evaluationOnDualKernel D).ker = D.range := by
  ext y
  rw [LinearMap.mem_ker]
  constructor
  · intro hy
    rw [mem_range_iff_forall_dualOperator_ker D hD]
    intro f hf
    exact congrFun (congrArg DFunLike.coe hy) ⟨f, hf⟩
  · intro hy
    ext f
    exact (mem_range_iff_forall_dualOperator_ker D hD y).mp hy f.1 f.2

omit [CompleteSpace E] in
/-- 对偶算子与恒等减紧扰动相容。 -/
theorem dualOperator_identitySubCompact (K : E →L[ℝ] E) :
    dualOperator (identitySubCompact K) = identitySubCompact (dualOperator K) := by
  ext f x
  simp [dualOperator_apply, identitySubCompact_apply]

/-- 紧算子 `K` 的恒等扰动 `I-K` 具有有限维余核。 -/
theorem finiteDimensional_cokernel_identitySubCompact (K : E →L[ℝ] E)
    (hK : IsCompactOperator K) :
    FiniteDimensional ℝ (E ⧸ (identitySubCompact K).range) := by
  let D := identitySubCompact K
  have hDclosed : IsClosed (Set.range D) := isClosed_range_identitySubCompact K hK
  have hdual : dualOperator D = identitySubCompact (dualOperator K) := by
    simpa [D] using dualOperator_identitySubCompact K
  have hKdual : IsCompactOperator (dualOperator K) :=
    dualOperator_isCompactOperator K hK
  let _ : FiniteDimensional ℝ (dualOperator D).ker := by
    rw [hdual]
    exact finiteDimensional_kernel_identitySubCompact (dualOperator K) hKdual
  let Q := evaluationOnDualKernel D
  let _ : FiniteDimensional ℝ (Module.Dual ℝ (dualOperator D).ker) := by
    exact Subspace.instModuleDualFiniteDimensional
      (K := ℝ) (V := (dualOperator D).ker)
  let _ : FiniteDimensional ℝ Q.range :=
    FiniteDimensional.of_injective Q.range.subtype Q.range.injective_subtype
  have hker : Q.ker = D.range := evaluationOnDualKernel_ker_eq_range D hDclosed
  rw [← hker]
  exact LinearEquiv.finiteDimensional (V := Q.range) Q.quotKerEquivRange.symm

end SandronesLibrary.FunctionalAnalysis
