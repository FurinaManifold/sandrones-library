---
id: settheory.cardinal.finite-set
kind: definition
state: verified
title: "有限集：能够完整编号到某个 Fin n"
premises: ["settheory.cardinal.equinumerous"]
mathlib: ["Fin"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 3: Finite Cardinals"}
---

# 动机

“数元素会停下来”需要精确化为一个可验证的结构：找到自然数 `n`，并把集合的元素不重不漏地编号为 `0` 到 `n-1`。这也让不同来源的有限集合可以使用同一把标尺。

# 直觉

`Fin n` 是标准的 `n` 元类型。与 `Fin n` 双射表示恰有 `n` 个元素，而不只是有某个上界。`Fin 0` 为空，因此空集也有限；编号方式可以不同，但等势概念忽略具体名称与排列。

# 陈述（自然语言）

类型 `α` 可由有限枚举，当且仅当存在 `n : ℕ` 使 `α` 与 `Fin n` 等势。这样的精确枚举还给出一个较弱结论：`α` 可以单射到某个 `Fin n`，即拥有有限大小上界。

# 陈述（Lean 对照）

```lean
def FiniteByEnumeration (α : Type u) : Prop :=
  ∃ n : ℕ, Equinumerous α (Fin n)

theorem finiteByEnumeration_has_finite_bound
    (h : FiniteByEnumeration α) :
    ∃ n : ℕ, CardinalLE α (Fin n)
```

`FiniteByEnumeration` 是本库公开定义，`Fin n` 是 mathlib 的标准有限类型。配套定理通过已有的“等势推出比较”接口得到有限上界，而非重新计算元素个数。

# 思维脉络（thinking trace）

展开 `h` 取得某个 `n` 及 `Equinumerous α (Fin n)`。调用 `equinumerous_implies_both_le`，选取其中从 `α` 到 `Fin n` 的方向，再以同一个 `n` 作为存在见证。这里从精确双射忘掉满射信息，得到较弱的单射界。

# 自然语言 ↔ Lean 映射

- “前 `n` 个编号” ↔ `Fin n`。
- “恰有 `n` 个元素” ↔ `Equinumerous α (Fin n)`。
- “存在某个有限大小” ↔ `FiniteByEnumeration α`。
- “存在有限上界” ↔ `∃ n, CardinalLE α (Fin n)`。
- `equinumerous_implies_both_le` 是本条证明复用的公开桥。

# 依赖（人话版）

依赖等势和单射比较两个基础接口，以及 Lean 的 `Fin n`。不依赖选择公理。`n` 的唯一性和与 mathlib `Finite`／`Fintype` 的完整互换尚未作为本条公开定理登记。

# 应用与陷阱

该定义可作为有限计数、有限归纳及“有限必可数”的起点。有限不等于非空，可数也不等于有限。`Fin n` 恰有 `n` 个元素，最大编号在 `n>0` 时是 `n-1`；不要误数为 `n+1` 个。
