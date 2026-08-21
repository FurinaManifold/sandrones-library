/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# Topology / Compact —— 紧致性与分离公理（点集拓扑第一学期 T2）

本文件当前条目（引理清单，§0 铁律4：一次一条，逐条编译）：

* **topology.compact.def**（紧致有限覆盖定义/有限子覆盖抽取/连续像紧/有限并紧）。
* **topology.compact.closed-bdd**（闭区间紧）。
* **topology.compact.finite**（T2 中紧集闭/紧集交闭）。
* **topology.separations**（T1/T2/正则/正规：单点闭、极限唯一）。

> **语言说明**：点集拓扑阶段（§Phase4）mathlib 的 `IsCompact`/`CompactSpace`/`T1Space`/
> `T2Space`/`NormalSpace` 等**教材结构可直接出现在签名**。
-/

namespace SandronesLibrary

namespace Topology.Compact

/-- **有限子覆盖抽取**：紧集的开覆盖存在有限子覆盖。 
> **Entry**: topology.compact.def
-/
theorem compact_elim_finite_subcover {X : Type*} [TopologicalSpace X] {s : Set X}
    (hs : IsCompact s) {ι : Type*} (U : ι → Set X) (hUo : ∀ i : ι, IsOpen (U i))
    (hsU : s ⊆ ⋃ i, U i) : ∃ t : Finset ι, s ⊆ ⋃ i ∈ t, U i := by
  exact hs.elim_finite_subcover U hUo hsU

/-- **连续像紧**：紧集的连续像是紧集。 
> **Entry**: topology.compact.def
-/
theorem compact_image_of_continuous {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    {s : Set X} (hs : IsCompact s) {f : X → Y} (hf : Continuous f) : IsCompact (f '' s) := by
  exact hs.image hf

/-- **紧集的有限并仍紧**。 
> **Entry**: topology.compact.def
-/
theorem compact_union {X : Type*} [TopologicalSpace X] {s t : Set X}
    (hs : IsCompact s) (ht : IsCompact t) : IsCompact (s ∪ t) := by
  exact hs.union ht

/-- **单点集紧**。 
> **Entry**: topology.compact.def
-/
theorem compact_singleton {X : Type*} [TopologicalSpace X] (x : X) : IsCompact ({x} : Set X) := by
  exact isCompact_singleton

/-- **闭区间紧**（Heine-Borel 的基础）：ℝ 上闭区间 [a,b] 紧。 
> **Entry**: topology.compact.closed-bdd
-/
theorem compact_Icc {a b : ℝ} : IsCompact (Set.Icc a b) := by
  exact isCompact_Icc

/-- **T2 中紧集是闭集**：Hausdorff 空间中紧集必闭。 
> **Entry**: topology.compact.finite
-/
theorem compact_isClosed_of_t2 {X : Type*} [TopologicalSpace X] [T2Space X] {s : Set X}
    (hs : IsCompact s) : IsClosed s := by
  exact hs.isClosed

/-- **T2 中紧集的交仍紧**：Hausdorff 空间中两个紧集的交紧。 
> **Entry**: topology.compact.finite
-/
theorem compact_inter_of_t2 {X : Type*} [TopologicalSpace X] [T2Space X] {s t : Set X}
    (hs : IsCompact s) (ht : IsCompact t) : IsCompact (s ∩ t) := by
  exact hs.inter ht

end Topology.Compact

end SandronesLibrary