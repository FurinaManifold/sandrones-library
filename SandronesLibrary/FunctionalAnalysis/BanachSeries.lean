/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.NormedSpace
import Mathlib.Analysis.Normed.Group.InfiniteSum

/-!
# Absolutely summable series in Banach spaces

Mathlib's `Summable` and `HasSum` already express the textbook semantics of convergence of a
series.  This file records the Banach-space theorem that summability of the norms implies
summability of the vector series, together with its partial-sum and norm consequences.
-/

namespace SandronesLibrary.FunctionalAnalysis

open Filter Finset
open SandronesLibrary.Topology.NormedSpace

variable {E : Type*}
variable [NormedAddCommGroup E] [NormedLinearSpace ℝ E] [BanachSpace E]

/-- In a Banach space, absolute summability implies summability.

Here the textbook premise “the series of norms converges” is represented directly by
`Summable (fun n ↦ ‖f n‖)`; no parallel predicate is introduced.

> **Entry**: functional-analysis.series.summable
-/
theorem summable_of_summable_norm {f : ℕ → E}
    (hf : Summable (fun n ↦ ‖f n‖)) : Summable f := by
  exact hf.of_norm

/-- Under absolute summability, the ordinary partial sums converge to Mathlib's series sum. -/
theorem tendsto_partialSums_tsum_of_summable_norm {f : ℕ → E}
    (hf : Summable (fun n ↦ ‖f n‖)) :
    Tendsto (fun N : ℕ ↦ ∑ n ∈ range N, f n) atTop (nhds (∑' n, f n)) := by
  exact (summable_of_summable_norm hf).hasSum.tendsto_sum_nat

/-- The norm of an absolutely convergent vector series is bounded by the sum of term norms. -/
theorem norm_tsum_le_tsum_norm_of_summable {f : ℕ → E}
    (hf : Summable (fun n ↦ ‖f n‖)) :
    ‖∑' n, f n‖ ≤ ∑' n, ‖f n‖ := by
  exact norm_tsum_le_tsum_norm hf

end SandronesLibrary.FunctionalAnalysis
