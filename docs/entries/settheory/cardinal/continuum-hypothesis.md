---
id: settheory.cardinal.continuum-hypothesis
kind: definition
state: verified
title: "连续统假设：可数与连续统之间没有中间基数"
premises: ["settheory.cardinal.aleph-hierarchy", "settheory.cardinal.beth-hierarchy"]
mathlib: ["Cardinal.beth_one", "Cardinal.two_power_aleph0"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 15: The Continuum Problem"}
---

# 问题从哪里来

自然数的大小是 `ℵ₀`，自然数幂集——等价地，无限二进制序列或实数——的大小是
`2^ℵ₀=ℶ₁`。Cantor 定理保证它严格大于 `ℵ₀`。问题是：它是否恰好就是下一个无限基数
`ℵ₁`，还是中间隔着别的基数？

# 两种等价陈述

连续统假设 `CH` 定义为

```lean
def ContinuumHypothesis : Prop := BethLevel 1 = AlephLevel 1
```

也就是 `ℶ₁=ℵ₁`。由于 `ℶ₁=2^ℵ₀`，定理 `continuumHypothesis_iff` 将它改写为熟悉的
`2^ℵ₀=ℵ₁`。

另一种自然语言说法是：不存在基数 `κ` 满足 `ℵ₀<κ<2^ℵ₀`。因为 `ℵ₁` 按定义就是
`ℵ₀` 之后的最小基数，这与等式陈述表达同一件事。

# 为什么 Cantor 定理没有解决 CH

Cantor 只证明 `ℵ₀<2^ℵ₀`，没有确定右边是“紧接着的下一档”还是跳过许多档。知道一个数严格
大于另一个数，并不自动知道它就是后继者。

# 独立性边界

在通常的 ZFC 集合论中，只要 ZFC 本身相容，就既不能证明 CH，也不能证明 `¬CH`：Gödel 给出
包含 CH 的相对一致性结果，Cohen 用 forcing 给出包含 `¬CH` 的相对一致性结果。

本库只形式化 CH 的准确基数等式及等价改写，不声称已经在 Lean 中构造 Gödel 可构造宇宙、forcing
模型或完成相对一致性证明。那些是独立的高阶模型论工程，不能用 `by exact` 某个经典公理冒充。

# CH 不是 Cantor 定理，也不是选择公理

- Cantor 定理在 ZF 中证明幂集严格增大。
- 选择公理使基数可以良序比较，但不决定连续统具体落在哪个 aleph 层级。
- CH 是额外的连续统大小断言，既可与 ZFC 相容，也可在相容模型中失败。

# 常见混淆

- `2^ℵ₀` 是基数幂，计算从自然数到二元素集合的全部函数。
- CH 不断言“实数可数”；它断言实数具有最小的不可数基数。
- “ZFC 不能决定”不是说命题没有真假，而是说在相容性假设下存在满足 ZFC 的不同模型。
- 广义连续统假设 GCH 对每个无限基数都作类似断言，严格强于单独的 CH。

