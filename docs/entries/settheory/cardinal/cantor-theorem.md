---
id: settheory.cardinal.cantor-theorem
kind: theorem
state: verified
title: "Cantor 定理：幂集严格更大"
premises: ["settheory.cardinal.comparison"]
mathlib: []
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 3: Cantor's Theorem"}
---

# 动机

给一个集合 `α`，它的幂集 `Set α` 包含 `α` 的全部子集。Cantor 定理说明，无论 `α` 有限还是
无限，幂集都无法由 `α` 自身完整编号。这产生了永不终止的更大无穷层级。

# 陈述（自然语言）

对任意函数 `f : α → Set α`，`f` 都不是满射。特别地，`α` 不与 `Set α` 等势。

# 对角集合

假设 `f` 声称列出了 `α` 的所有子集，第 `x` 项是 `f(x)`。构造

`D = {x ∈ α | x ∉ f(x)}`。

集合 `D` 在第 `x` 个位置故意与名单第 `x` 项相反：若 `x` 属于 `f(x)`，就不把 `x` 放入
`D`；若不属于，就放入。

# 为什么 D 不在名单中

若 `f` 满射，应存在 `a` 使 `f(a)=D`。检查元素 `a` 是否属于 `D`：

- 若 `a∈D`，按定义有 `a∉f(a)`；但 `f(a)=D` 又给 `a∈f(a)`。
- 若 `a∉D`，按定义有 `a∈f(a)`；由 `f(a)=D` 又得到 `a∈D`。

两种情况都矛盾，所以不存在这样的 `a`，名单必遗漏 `D`。

# Lean 对照

`diagonalSet f := {x | x ∉ f x}` 显式定义对角集合。
`cantor_no_surjection f` 对 `a∈diagonalSet f` 分情况完成上述矛盾。
`cantor_not_equinumerous α` 再说明双射必然给出满射，从而排除等势。

# “严格更大”还需要哪一边

把 `x` 映到单元素集合 `{x}`，可得到 `α→Set α` 的单射，所以 `|α|≤|Set α|`；本条证明反方向
不可能等势。两者结合即 `|α|<|Set α|`。正式的严格比较接口会在后续基数算术批次登记。

# 应用与陷阱

- 对角集合依赖函数 `f`；不是预先固定的某个神秘子集。
- 定理排除满射，比单纯排除双射更强。
- 这不是 Russell 悖论：`D` 只在给定类型 `α` 内构造，不讨论“所有集合组成的集合”。
- 连续统 `Set ℕ` 因而不可数；这给出实数不可数性的集合论核心。
