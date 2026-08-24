---
id: settheory.cardinal.aleph-hierarchy
kind: definition
state: verified
title: "Aleph 层级：依次编号所有无限基数"
premises: ["settheory.cardinal.finite-set"]
mathlib: ["Cardinal.aleph", "Cardinal.aleph_zero", "Cardinal.succ_aleph"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 5: Alephs"}
---

# 动机

“无限”不是唯一的大小。Cantor 定理告诉我们，从任何集合出发都能得到更大的幂集；因此需要一套记号，按从小到大的次序列出所有无限基数。Aleph 层级承担的正是这项编号工作。

# 直觉

`ℵ₀` 是自然数的大小，也是最小无限基数。`ℵ₁` 是严格大于 `ℵ₀` 的最小基数，`ℵ₂` 又是 `ℵ₁` 的后继基数。到极限下标时没有“前一项”，例如 `ℵ_ω` 是 `ℵ₀, ℵ₁, …` 的上确界。这里的下标遍历全部序数，而不只遍历自然数。

# 陈述（自然语言）

定义 `AlephLevel(α)=ℵ_α`。零层等于 `ℵ₀`；下一序数对应当前 aleph 的后继基数。因此 `ℵ_(α+1)` 是严格大于 `ℵ_α` 的最小基数，而不是基数算术中的 `ℵ_α+1`。本条公开验证零层与后继层；极限层的上确界性质由底层 `Cardinal.aleph` 的完整理论提供，本条没有另行登记公开定理。

# 陈述（Lean 对照）

```lean
noncomputable def AlephLevel (o : Ordinal) : Cardinal := Cardinal.aleph o

theorem alephLevel_zero_and_successor (o : Ordinal) :
    AlephLevel 0 = Cardinal.aleph0 ∧
      Order.succ (AlephLevel o) = AlephLevel (o + 1)
```

`noncomputable` 表示定义依赖经典选取而不用于程序计算。`Order.succ` 是后继基数；右边序数下标的 `o + 1` 只出现在与 mathlib 接口对齐的定理中。

# 思维脉络（thinking trace）

先从“所有无限基数都要出现”确定索引必须足够长，于是用序数作下标。再固定起点为最小无限基数。后继处取下一个基数，保证没有漏掉中间大小；极限处汇总此前各层，保证枚举连续。Lean 实现复用 mathlib 已验证的 `Cardinal.aleph`，本库负责给出稳定命名并检验最常用的零、后继接口。

# 自然语言 ↔ Lean 映射

- 第 `o` 个无限基数 ↔ `AlephLevel o`，公开定义。
- 最小无限基数 ↔ `Cardinal.aleph0`，mathlib 基础对象。
- 后继基数 ↔ `Order.succ (AlephLevel o)`，不是基数加一。
- 零与后继规则 ↔ `alephLevel_zero_and_successor`，本条公开定理。
- `Cardinal.aleph_zero`、`Cardinal.succ_aleph` ↔ 证明后端，不是新增定义。

# 依赖（人话版）

概念上需要有限与无限的区别、序数索引以及后继／极限的观念。形式化上直接依赖 mathlib 的 aleph 层级；本条没有重新实现超限递归，也不以连续统假设为前提。

# 应用与陷阱

Aleph 记号用于定位任意无限基数，也为 CH、正则基数和奇异基数提供坐标。要警惕三点：`ω` 是序数而 `ℵ₀` 是基数；下标不限于自然数；后继基数不是“给集合添一个元素”，因为无限基数加有限数通常不改变大小。
