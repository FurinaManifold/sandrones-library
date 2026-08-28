/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.FredholmDefinition

/-!
# Fredholm 算子的复合

本文件证明 Fredholm 算子在复合下稳定，并证明指数对复合可加。Fredholm 性通过连续拟逆的复合
证明；指数公式使用 Mathlib 的有限维六项正合列公式，而不是把最终稳定性结论重新命名。

> **Entry**: functional-analysis.fredholm.stability
-/

namespace SandronesLibrary.FunctionalAnalysis

variable {E F G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  [NormedAddCommGroup F] [NormedSpace ℝ F] [CompleteSpace F]
  [NormedAddCommGroup G] [NormedSpace ℝ G] [CompleteSpace G]

omit [CompleteSpace E] [CompleteSpace F] [CompleteSpace G] in
/-- 两个 Fredholm 算子的复合仍是 Fredholm 算子。 -/
theorem ContinuousLinearMap.IsFredholm.comp {S : E →L[ℝ] F} {T : F →L[ℝ] G}
    (hT : T.IsFredholm) (hS : S.IsFredholm) :
    (T.comp S).IsFredholm := by
  obtain ⟨S', hS'⟩ := hS.exists_isQuasiInverse
  obtain ⟨T', hT'⟩ := hT.exists_isQuasiInverse
  apply ContinuousLinearMap.IsFredholm.of_isQuasiInverse (v := S'.comp T')
  simpa using hS'.comp hT'

omit [CompleteSpace E] [CompleteSpace F] [CompleteSpace G] in
/-- Fredholm 指数对复合可加，采用约定 `dim ker - dim coker`。 -/
theorem fredholmIndex_comp {S : E →L[ℝ] F} {T : F →L[ℝ] G}
    (hT : T.IsFredholm) (hS : S.IsFredholm) :
    (T.comp S).toLinearMap.index =
      T.toLinearMap.index + S.toLinearMap.index := by
  let _ : FiniteDimensional ℝ S.ker := hS.finite_ker
  let _ : FiniteDimensional ℝ T.ker := hT.finite_ker
  let _ : FiniteDimensional ℝ (F ⧸ S.range) := hS.finite_coker
  let _ : FiniteDimensional ℝ (G ⧸ T.range) := hT.finite_coker
  exact LinearMap.index_comp T.toLinearMap

end SandronesLibrary.FunctionalAnalysis
