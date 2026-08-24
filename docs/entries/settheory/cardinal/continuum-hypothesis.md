---
id: settheory.cardinal.continuum-hypothesis
kind: definition
state: verified
title: "连续统假设：可数与连续统之间没有中间基数"
premises: ["settheory.cardinal.aleph-hierarchy", "settheory.cardinal.beth-hierarchy"]
mathlib: ["Cardinal.beth_one", "Cardinal.two_power_aleph0"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 15: The Continuum Problem"}
---

# 动机

自然数幂集、无限二进制序列与实数都具有连续统大小 `2^ℵ₀`。Cantor 定理只告诉我们它严格大于 `ℵ₀`，却没有说明它是不是紧接着的下一个无限基数。连续统假设精确提出这个缺口问题。

# 直觉

Aleph 层级是所有无限基数的编号表，Beth 层级记录幂集迭代。第一步幂集产生 `ℶ₁=2^ℵ₀`。CH 断言这一步没有跳过任何基数，即它恰好落在 `ℵ₁`；它绝不是说实数可数。

# 陈述（自然语言）

本库把连续统假设定义为 `ℶ₁=ℵ₁`，并证明它等价于常见公式 `2^ℵ₀=ℵ₁`。教材中“`ℵ₀` 与连续统之间不存在中间基数”是同一命题的顺序表述，但本条公开 Lean 接口登记的是上述两个等式之间的等价。

# 陈述（Lean 对照）

```lean
def ContinuumHypothesis : Prop :=
  BethLevel (1 : Ordinal) = AlephLevel (1 : Ordinal)

theorem continuumHypothesis_iff :
    ContinuumHypothesis ↔
      2 ^ Cardinal.aleph0 = AlephLevel (1 : Ordinal)
```

`continuumHypothesis_iff` 通过 Beth 第一层的计算规则改写定义。它不证明等式成立，也不证明其否定。

# 思维脉络（thinking trace）

先用 Aleph 记号表达“下一个无限基数”，再用 Beth 记号表达“自然数幂集大小”，把问题压缩成两层是否相等。随后展开 `ℶ₁` 为 `2^ℵ₀`，得到通常教科书公式。Lean 的工作到这个等价改写为止，没有进入模型构造或相对一致性证明。

# 自然语言 ↔ Lean 映射

- 连续统大小 ↔ `2 ^ Cardinal.aleph0`，基数幂。
- 第一次幂集层 ↔ `BethLevel 1`。
- 最小不可数基数 ↔ `AlephLevel 1`。
- CH 命题 ↔ `ContinuumHypothesis`，公开定义。
- 两种等式表述 ↔ `continuumHypothesis_iff`，公开定理。

# 依赖（人话版）

需要 Aleph、Beth 与基数幂，特别是 `ℶ₁=2^ℵ₀`。Cantor 定理提供严格大于，却不能决定是否为后继。选择公理也不决定 CH 的真假。

# 应用与陷阱

CH 是研究连续统大小的基准命题。元数学上，Gödel 与 Cohen 给出了相对一致性／独立性理论；但本库没有形式化可构造宇宙、forcing、`CH` 或 `¬CH` 的模型，也没有证明 CH 独立于 ZFC。不得把定义和等价改写报道成 CH 本身、其否定或独立性的 Lean 证明。
