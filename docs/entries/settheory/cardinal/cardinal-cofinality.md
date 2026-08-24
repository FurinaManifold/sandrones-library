---
id: settheory.cardinal.cardinal-cofinality
kind: definition
state: verified
title: "基数共尾性：逼近一个基数至少需要多长"
premises: ["settheory.ordinal.cofinality"]
mathlib: ["Cardinal.ord", "Ordinal.cof_ord_le"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 5: Cofinality"}
---

# 从“有多大”转向“怎样逼近”

基数 `κ` 告诉我们一个集合有多少元素，共尾性 `cf(κ)` 则问：若用一串严格小于 `κ` 的阶段
不断向上逼近 `κ`，至少需要多少个阶段才能不被任何较小界截住？

# 为什么先转成序数

基数本身只记录大小，没有内在排列。要谈“不断增大并趋近”，先选出大小为 `κ` 的最小序数，
即初始序数 `κ.ord`。然后取这个序数的共尾性：

```lean
noncomputable def CardinalCofinality (c : Cardinal) : Cardinal := c.ord.cof
```

选最小序数避免结果依赖任意良序方式。这也是基数共尾性与前一阶段序数共尾性之间的准确接口。

# 两个对比例子

`cf(ℵ₀)=ℵ₀`：任何有限自然数列都有最大值，无法逼近所有自然数；但整个自然数序列当然共尾。

`cf(ℵ_ω)=ℵ₀`：序列 `ℵ₀,ℵ₁,ℵ₂,…` 已能逼近其上确界 `ℵ_ω`。因此虽然 `ℵ_ω` 远大于
`ℵ₀`，逼近它只需要可数多个阶段。

# 基本上界

`cardinalCofinality_le c` 说明 `cf(c)≤c`。直观上，使用 `c` 自身长度的递增枚举总不会比所需
最短长度更短；共尾性是所有共尾方案中最小的大小。

# 共尾不是集合基数的同义词

两个基数可能大小不同却有相同共尾性，例如 `ℵ₀` 与 `ℵ_ω` 都具有可数共尾性。共尾性描述的
是极限结构，而非总元素数量。

# 自然语言 ↔ Lean

- 基数的初始序数 ↔ `c.ord`。
- 序数共尾性 ↔ `Ordinal.cof`。
- 基数共尾性 ↔ `CardinalCofinality c`。
- `cf(c)≤c` ↔ `cardinalCofinality_le c`。

# 常见混淆

- 展示一条可数共尾序列只证明 `cf(c)≤ℵ₀`，还需排除有限方案才能证明等号。
- 共尾序列不必遍历所有元素，只需最终越过每个较小阶段。
- 对基数直接谈递增顺序前，必须说明采用其初始序数代表。

