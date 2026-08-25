---
id: settheory.cardinal.regular-singular
kind: definition
state: verified
title: "正则与奇异基数：能否由较短序列逼近"
premises: ["settheory.cardinal.cardinal-cofinality"]
mathlib: ["Cardinal.isRegular_aleph0"]
provenance: {source_type: book, ref: "jech-set-theory-2003"}
---

# 动机

对无限基数 `κ`，共尾性总满足 `cf(κ)≤κ`。于是自然要问：逼近 `κ` 是否必须使用 `κ` 个阶段，还是存在更短的共尾过程？这一区别产生正则与奇异基数。

# 直觉

正则基数不能被短序列“拼到顶”：少于 `κ` 个较小阶段仍不足以共尾。奇异基数则能被比自身短的序列逼近。`ℵ₀` 是正则的；`ℵ_ω` 是典型奇异候选，因为有限编号的 aleph 序列已经向它共尾。

# 陈述（自然语言）

本库把无限且满足 `cf(c)=c` 的基数定义为正则，把无限且满足 `cf(c)<c` 的基数定义为奇异。公开结论包括：`ℵ₀` 正则；正则与奇异不能同时成立；每个无限基数按线性序比较落入二者之一。这里给出的是定义层面的分类接口，不包含“所有无限后继基数正则”等更深定理。

# 陈述（Lean 对照）

```lean
def RegularCardinal (c : Cardinal) : Prop :=
  Cardinal.aleph0 ≤ c ∧ CardinalCofinality c = c

def SingularCardinal (c : Cardinal) : Prop :=
  Cardinal.aleph0 ≤ c ∧ CardinalCofinality c < c
```

对应公开定理为 `aleph0_is_regular`、`regular_not_singular` 与 `infinite_regular_or_singular`。最后一条需要显式传入 `Cardinal.aleph0 ≤ c`。

# 思维脉络（thinking trace）

先用 `ℵ₀≤c` 排除有限基数，再按 `cf(c)=c` 或 `cf(c)<c` 分支。共尾性上界排除了 `c<cf(c)`，基数的线性序于是闭合分类。`ℵ₀` 的正则性直接接到 mathlib 已证明事实；互斥性则把等式代入严格不等式得到矛盾。

# 自然语言 ↔ Lean 映射

- “无限” ↔ `Cardinal.aleph0 ≤ c`，两个定义共有前提。
- “无法较短逼近” ↔ `CardinalCofinality c = c`。
- “可被较短逼近” ↔ `CardinalCofinality c < c`。
- 分类闭合 ↔ `infinite_regular_or_singular`，公开定理。
- `Cardinal.isRegular_aleph0` ↔ `ℵ₀` 正则证明的后端。

# 依赖（人话版）

直接依赖基数共尾性的定义和上界，以及基数线性序。分类定理是纯序关系闭环；它没有形式化构造每个奇异基数的具体共尾序列，也没有证明后继基数正则。

# 应用与陷阱

正则性控制并集、递归长度和基数算术中的闭包性质。不要把“奇异”理解为矛盾或病态，它只是共尾性较小。`cf(c)≤c` 不能单独证明奇异，必须严格小于。教材常见的后继基数正则论断也不能由本条现有接口直接引用。
