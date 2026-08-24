---
id: settheory.cardinal.regular-singular
kind: definition
state: verified
title: "正则与奇异基数：能否由较短序列逼近"
premises: ["settheory.cardinal.cardinal-cofinality"]
mathlib: ["Cardinal.isRegular_aleph0"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 5: Regular and Singular Cardinals"}
---

# 分类问题

对无限基数 `κ`，已知 `cf(κ)≤κ`。于是只有两种可能：共尾性恰等于自身，或者严格更小。这一区分
衡量 `κ` 能否由一条长度小于 `κ` 的递增过程逼近。

# 定义

```lean
def RegularCardinal (c : Cardinal) : Prop :=
  Cardinal.aleph0 ≤ c ∧ CardinalCofinality c = c

def SingularCardinal (c : Cardinal) : Prop :=
  Cardinal.aleph0 ≤ c ∧ CardinalCofinality c < c
```

两者都明确要求 `c` 无限。若省略这一条件，有限基数的共尾性行为会混进分类，偏离集合论中
“正则／奇异基数”的标准用法。

# 正则意味着什么

若 `κ` 正则，任何少于 `κ` 个、且每个都小于 `κ` 的阶段，其上确界仍小于 `κ`。换句话说，
想真正逼近 `κ`，至少要动用 `κ` 个阶段。

`ℵ₀` 是正则的：有限长度的自然数序列一定有最大值，不能在自然数中共尾。形式化定理
`aleph0_is_regular` 记录 `cf(ℵ₀)=ℵ₀`。

# 奇异意味着什么

若 `κ` 奇异，则存在一条长度严格小于 `κ` 的共尾序列。典型例子是 `ℵ_ω`：它本身不可数且
巨大，却由可数序列 `ℵ₀<ℵ₁<…` 逼近，所以 `cf(ℵ_ω)=ℵ₀<ℵ_ω`。

“奇异”并不表示矛盾或病态，只表示总大小与逼近所需长度之间存在落差。

# 两类不会重叠

`regular_not_singular` 展开两种定义：若同时成立，就会得到 `cf(c)=c` 与 `cf(c)<c`，立即矛盾。
对任意无限基数，结合 `cf(c)≤c`，经典序关系又保证它落入两类之一。

# 后继基数与极限基数

在通常的选择公理背景下，每个无限后继基数都是正则的；奇异基数必为极限基数。但极限基数未必
奇异：是否正则仍需检查共尾性，不能只看下标是不是极限。

# 常见混淆

- 正则性讨论的是基数共尾性，不是“正则集合”或正则拓扑空间。
- `cf(κ)<κ` 需要严格不等式；仅证明 `cf(κ)≤κ` 对所有基数都成立。
- `ℵ_ω` 的下标共尾性提示其基数共尾性，但一般不能不经定理就把二者直接等同。

