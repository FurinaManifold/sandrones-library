---
id: settheory.cardinal.finite-set
kind: definition
state: verified
title: "有限集：能够完整编号到某个 Fin n"
premises: ["settheory.cardinal.equinumerous"]
mathlib: ["Fin"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 3: Finite Cardinals"}
---

# “有限”不能只解释成“不无限”

初学时我们说一个集合有限，是因为数它的元素会停下来。但教材定义还需要说明“停在 `n`”究竟
意味着什么：必须能把每个元素不重不漏地编号为 `0,1,…,n-1`。这是一张到标准有限集的双射。

# 标准的 n 元集合

Lean 中 `Fin n` 由所有小于 `n` 的自然数组成：

- `Fin 0` 没有元素；
- `Fin 1` 只有编号 `0`；
- `Fin 3` 有编号 `0,1,2`。

选择 `Fin n` 的好处是，不同来源、不同名字的有限集合都能拿同一把标尺测量。

# 定义

```lean
def FiniteByEnumeration (α : Type u) : Prop :=
  ∃ n : ℕ, Equinumerous α (Fin n)
```

这句话包含两层存在：先找到一个自然数 `n`，再找到一张双射。只有单射到 `Fin n` 虽足以说明
存在有限上界，却没有直接说出集合恰有多少个元素；双射则给出精确计数。

# 例子

一周七天与 `Fin 7` 等势：任选一个固定次序，将星期一编号为 `0`，依次到星期日编号为 `6`。
编号方式并不唯一，但数字 `7` 不会因重新排列而改变。

空类型与 `Fin 0` 等势，所以空集也是有限集，大小为零。只含一个指定对象的类型与 `Fin 1`
等势，大小为一。

# 为什么 n 是唯一的

如果同一个类型同时与 `Fin m`、`Fin n` 等势，复合两张双射可得到 `Fin m ≃ Fin n`。有限集合
的鸽巢原理告诉我们这迫使 `m=n`。因此“元素个数”不是编号方案的偶然产物。当前条目先建立
定义接口；该唯一性可复用 mathlib 的有限类型计数定理继续证明。

# 与可数的关系

若 `α ≃ Fin n`，双射的正向函数当然是单射，所以 `α` 能嵌入一个标准有限集；定理
`finiteByEnumeration_has_finite_bound` 明确记录了这一点。再把 `Fin n` 嵌入自然数，就能看出每个
有限集都可数。反过来不成立：自然数集可数，却不与任何 `Fin n` 等势。

# 自然语言 ↔ Lean

- 前 `n` 个编号 ↔ `Fin n`。
- 恰有 `n` 个元素 ↔ `Equinumerous α (Fin n)`。
- 存在某个有限大小 ↔ `FiniteByEnumeration α`。
- 有一个有限上界 ↔ `∃ n, CardinalLE α (Fin n)`。

# 常见混淆

- 有限不等于非空；`Fin 0` 说明空集有限。
- 可数包含有限与可数无限两种情况，不能把“可数”当成“有限”的同义词。
- `Fin n` 的下标 `n` 是元素总数，最大编号是 `n-1`；不要误数成 `n+1` 个。

