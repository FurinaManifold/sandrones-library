/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.FunctionalAnalysis.ClosedRangeDuality
import Mathlib.Analysis.Normed.Operator.Fredholm.Basic
import Mathlib.Algebra.Module.LinearMap.Index

/-!
# Fredholm 算子的定义层

本文件直接采用 Mathlib 的 `ContinuousLinearMap.IsFredholm` 作为 Fredholm 算子的正式承载，
并将其结构字段展开成教材条件。Fredholm 指数直接采用底层线性映射的 `LinearMap.index`，
不建立平行谓词或平行指数定义。
-/

namespace SandronesLibrary.FunctionalAnalysis

open Set

variable {E F : Type*}
variable [NormedAddCommGroup E] [NormedSpace ℝ E]
variable [NormedAddCommGroup F] [NormedSpace ℝ F]

/-- **Fredholm definition, expanded.** A bounded operator between real normed spaces is Fredholm
precisely when it is strict, has closed range, finite-dimensional kernel and cokernel, and a
topologically complemented kernel. Here `T.range.CoFG` is definitionally the finite-generation
condition on the quotient `F ⧸ T.range`.

The extra strictness and complemented-kernel fields are the topological form chosen by Mathlib;
over Banach spaces they are the data needed by its general Fredholm API, rather than a second
notion introduced by this library.

> **Entry**: functional-analysis.fredholm.definition
-/
theorem isFredholm_iff_components (T : E →L[ℝ] F) :
    T.IsFredholm ↔
      _root_.Topology.IsStrictMap T ∧
      IsClosed (T.range : Set F) ∧
      FiniteDimensional ℝ T.ker ∧
      T.range.CoFG ∧
      T.ker.ClosedComplemented := by
  constructor
  · intro h
    exact ⟨h.isStrictMap, h.isClosed_range, h.finite_ker, h.finite_coker,
      h.closedComplemented_ker⟩
  · rintro ⟨hstrict, hclosed, hker, hcoker, hcomplemented⟩
    exact ⟨hstrict, hclosed, hker, hcoker, hcomplemented⟩

/-- A Fredholm operator has closed range in the ambient Banach space. -/
theorem ContinuousLinearMap.IsFredholm.isClosed_setRange {T : E →L[ℝ] F}
    (hT : T.IsFredholm) : IsClosed (Set.range T) := by
  change IsClosed ((T.toLinearMap.range : Submodule ℝ F) : Set F)
  exact hT.isClosed_range

/-- The kernel of a Fredholm operator is finite-dimensional. -/
theorem ContinuousLinearMap.IsFredholm.finiteDimensional_kernel {T : E →L[ℝ] F}
    (hT : T.IsFredholm) : FiniteDimensional ℝ T.ker :=
  hT.finite_ker

/-- The cokernel `F / range T` of a Fredholm operator is finite-dimensional. -/
theorem ContinuousLinearMap.IsFredholm.finiteDimensional_cokernel {T : E →L[ℝ] F}
    (hT : T.IsFredholm) : FiniteDimensional ℝ (F ⧸ T.range) :=
  hT.finite_coker

/-- The Fredholm index uses Mathlib's algebraic index with sign convention
`dim ker T - dim (F / range T)`. The formula is definitional; Fredholmness guarantees that both
dimensions appearing here are genuinely finite. -/
theorem fredholmIndex_eq_finrank_ker_sub_finrank_cokernel (T : E →L[ℝ] F) :
    T.toLinearMap.index =
      Module.finrank ℝ T.ker - Module.finrank ℝ (F ⧸ T.range) :=
  LinearMap.index_eq_finrank_sub

end SandronesLibrary.FunctionalAnalysis
