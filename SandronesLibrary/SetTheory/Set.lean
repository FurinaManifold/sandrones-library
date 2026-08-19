/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# SetTheory / Set —— 集合语言（大一预备）

本文件当前条目：

* **settheory.set.ext**（外延性原理）：两个集合相等 ⟺ 元素完全相同。
* **settheory.set.operations.inter-distrib**（交对并的分配律）：
  `A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C)`，依赖 `settheory.set.ext`。
-/

namespace SandronesLibrary

namespace SetTheory.Set

/--
> **Entry**: settheory.set.ext
> **一句话**: 两个集合相等当且仅当它们的元素完全相同（外延性原理）。
> **直觉**: 集合由它的元素唯一决定——"集合相等"永远可以退化为"逐元素检查"。
> **依赖**: 无（直接使用 mathlib 的 `Set.ext`）
> **mathlib**: `Set.ext`
-/
theorem set_ext {α : Type*} (A B : Set α) : A = B ↔ ∀ x : α, x ∈ A ↔ x ∈ B := by
  -- 思路：这是集合语言的地基，等价关系 "A = B" 与 "逐元素互属" 互推。
  constructor
  · -- (⇒) 若 A = B，则任意 x 属于 A 当且仅当属于 B（相等的定义）。
    intro h x
    subst h
    exact Iff.rfl
  · -- (⇐) 若元素完全相同，由外延公理（mathlib 的 Set.ext）直接得到相等。
    intro h
    exact Set.ext h

/--
> **Entry**: settheory.set.operations.inter-distrib
> **一句话**: 交对并的分配律：`A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C)`。
> **直觉**: 集合恒等式 = "把集合语言翻译成命题逻辑，再翻译回来"。
>   外延性把等式化成逐元素判断，逻辑层的分配律自动完成其余工作。
> **依赖**: `settheory.set.ext`
> **mathlib**: `Set.inter_union_distrib_left`
-/
theorem inter_distrib_left {α : Type*} (A B C : Set α) :
    A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C) := by
  -- 思路（思维脉络）：目标是一个集合等式。第一反应永远是用外延性（Set.ext）
  -- 把 "集合相等" 降维成 "任意元素的双向属于"。之后每一步只是命题逻辑。
  ext x
  constructor
  · -- (⇒) x ∈ A 且 x ∈ B∪C：分 x ∈ B 或 x ∈ C 两路，各自汇入左侧某一支。
    rintro ⟨hxA, hxBC⟩
    rcases hxBC with hxB | hxC
    · exact Or.inl ⟨hxA, hxB⟩
    · exact Or.inr ⟨hxA, hxC⟩
  · -- (⇐) x ∈ (A∩B) ∪ (A∩C)：无论在哪一支，x 都属于 A，且属于 B 或 C 之一。
    rintro (⟨hxA, hxB⟩ | ⟨hxA, hxC⟩)
    · exact ⟨hxA, Or.inl hxB⟩
    · exact ⟨hxA, Or.inr hxC⟩

end SetTheory.Set

end SandronesLibrary
