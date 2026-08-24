---
id: settheory.cardinal.beth-hierarchy
kind: definition
state: verified
title: "Beth 层级：反复取幂集产生的无穷"
premises: ["settheory.cardinal.exponentiation", "settheory.cardinal.aleph-hierarchy"]
mathlib: ["Cardinal.beth", "Cardinal.beth_zero", "Cardinal.beth_succ"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 5: Beth Numbers"}
---

# 从 Cantor 定理继续向上

对任意集合 `X`，幂集 `Set X` 都严格大于 `X`。从自然数的大小开始不断取幂集，便得到一条
永不停止的严格增长链。Beth 层级就是为这条特定链编号。

# 定义图景

- `ℶ₀ = ℵ₀`；
- `ℶ_(α+1) = 2^(ℶ_α)`，即上一层幂集的大小；
- 极限下标 `λ` 处，取此前全部 `ℶ_α` 的上确界。

这里 `2^κ` 来自函数空间：一个子集由取值为真／假的特征函数表示，所以“幂集大小”等于
“从原集合到二元素集合的函数数量”。

# Lean 接口

```lean
noncomputable def BethLevel (o : Ordinal) : Cardinal := Cardinal.beth o
```

`bethLevel_zero_and_successor` 记录起点和取幂集的后继步骤。实现复用 mathlib 已验证的超限递归，
但教材含义由上述三条规则决定，而不是把符号 `^` 当成未经解释的黑盒。

# 第一层：连续统

`ℶ₁ = 2^ℵ₀`，即自然数所有子集的数量，也等于无限二进制序列的数量。它与实数等势，通常记作
连续统 `𝔠`。Cantor 对角线给出 `ℵ₀ < ℶ₁`。

# 与 Aleph 层级怎样比较

因为 aleph 枚举所有无限基数，`ℶ₁` 必等于某个 `ℵ_α`，但 ZFC 不能决定这里的 `α` 必须是
`1`。连续统假设 `CH` 正是断言 `ℶ₁=ℵ₁`；广义连续统假设则断言每一步都有
`ℶ_(α+1)=ℵ_(对应后继层)`。

# 极限层不是再取一次幂集

在 `ℶ_ω` 处没有“上一层”，因此不能写成某个 `ℶ_n` 的幂集。它是所有有限层
`ℶ₀,ℶ₁,…` 的上确界。把后继规则机械套到极限位置是超限递归中常见错误。

# 常见混淆

- Aleph 是完整的无限基数清单；Beth 是幂集迭代产生的一条子序列。
- `ℶ_(α+1)` 一定严格大于 `ℶ_α`，这是 Cantor 定理，而非普通算术直觉。
- `ℶ₁=ℵ₁` 不是 ZFC 中可直接证明的定理。

