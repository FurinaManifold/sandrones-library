/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# SetTheory / Function —— 函数语言（大一预备）

本文件当前条目：

* **settheory.function.inj-comp**（单射的复合）：`f` 与 `g` 单射 ⇒ `g ∘ f` 单射。
* **settheory.function.surj-comp**（满射的复合）：`f` 与 `g` 满射 ⇒ `g ∘ f` 满射。
-/

namespace SandronesLibrary

namespace SetTheory.Function

/--
> **Entry**: settheory.function.inj-comp
> **一句话**: 两个单射的复合仍是单射。
> **直觉**: "复合不漏信息"：g 的注入性保证 f 的结果不塌缩，f 的注入性保证源头不塌缩。
> **依赖**: 无（单射/复合的直接定义展开）
> **mathlib**: `Function.Injective.comp`
-/
theorem injective_comp {α β γ : Type*} {f : α → β} {g : β → γ}
    (hf : Function.Injective f) (hg : Function.Injective g) :
    Function.Injective (g ∘ f) := by
  -- 思路：展开单射定义。假设 (g∘f) a = (g∘f) b，即 g (f a) = g (f b)。
  -- 用 hg 把等式"剥掉一层"得 f a = f b，再用 hf 剥掉第二层得 a = b。
  intro a b h
  apply hf
  apply hg
  exact h

/--
> **Entry**: settheory.function.surj-comp
> **一句话**: 两个满射的复合仍是满射。
> **直觉**: "复合不漏目标"：先由 g 的满射性找到"中间人" b，再由 f 的满射性找到源头 a。
> **依赖**: `settheory.function.inj-comp`（仅作同族引用的示范，本证明本身不依赖它）
> **mathlib**: `Function.Surjective.comp`
-/
theorem surjective_comp {α β γ : Type*} {f : α → β} {g : β → γ}
    (hf : Function.Surjective f) (hg : Function.Surjective g) :
    Function.Surjective (g ∘ f) := by
  -- 思路：目标 ∀ c, ∃ a, (g∘f) a = c。
  -- 从"终点"往回走：hg 给出 b 使 g b = c；hf 给出 a 使 f a = b；组合即得。
  intro c
  rcases hg c with ⟨b, hb⟩
  rcases hf b with ⟨a, ha⟩
  -- 组合：(g∘f) a = g (f a) = g b = c。`simpa` 负责展开复合记号 `Function.comp`。
  exact ⟨a, by simpa [Function.comp] using (congrArg g ha).trans hb⟩

end SetTheory.Function

end SandronesLibrary
