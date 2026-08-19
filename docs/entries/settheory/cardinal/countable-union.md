---
id: settheory.cardinal.countable-union
family: settheory.cardinal
variant: ecnu
kind: theorem
state: verified
title: 可数个可数集的并可数
summary: 可数个可数集的并仍可数
premises: [settheory.cardinal.countable-def]
mathlib: [Set.countable_iUnion]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 一章（预备知识）"
---

# 动机

分析里最常用的可数性工具之一：**几个乃至可数个可数集合，合起来还是可数**。
它支撑着：级数理论中"可数个不收敛点"的处理、拓扑中"每点某个性质的集合可数"、
测度论中"可数个零测集之并零测"的第一步。

# 直觉

把第 n 个集合写成 `Sₙ = {sₙ₀, sₙ₁, sₙ₂, ...}`（每个集合可枚举）。
把合并后的元素按 "我来自第 n 个集合的第 m 个位置" (n, m) 摆放——
(n, m) 是一个"可数网格"，沿对角线扫描即可把整个并集排成一行。
"配对可数"（countable-rat 里的种子思想）在这里显身手。

# 陈述（自然语言）

若指标集 ι 可数，且每个集合 Sᵢ 可数，则并集 ⋃ᵢ Sᵢ 可数。

# 陈述（Lean 对照）

```lean
theorem countable_iUnion {ι α : Type*} [Countable ι] (s : ι → Set α)
    (hs : ∀ i : ι, (s i).Countable) : (⋃ i, s i).Countable
```

| 人话 | Lean |
|---|---|
| 指标集可数 | `[Countable ι]` |
| 每个集合可数 | `hs : ∀ i, (s i).Countable` |
| 并集仍可数 | `(⋃ i, s i).Countable` |

# 思维脉络（thinking trace）

1. **定位**：目标是并集 `⋃ i, s i` 可数。已知两个输入：指标可数、每片可数。
2. **配对直觉**：元素 x ∈ ⋃ᵢ sᵢ ↦ 它来自某片 sₙ，且在那片里有位置 m：
   "来源 (n, m)" 编码进自然数（n、m 各一个号，配对合成一个号）。单射成立。
3. **为什么每片都要可数**：如果有一片不可数，元素"来源位标"会耗尽，并集就可能不可数
   （例：ℝ = ⋃_{x∈ℝ} {x}，指标不可数是关键）。
4. **形式化**：mathlib 的 `Set.countable_iUnion` 就是"配对证法"的打包，直接引用。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 可数并 | `Set.countable_iUnion` |
| 来自某片的某位 | 配对 (n, m) 单射 ℕ×ℕ → ℕ |

# 依赖（人话版）

- `settheory.cardinal.countable-def`：可数的判定（构造单射）承托配对论证。

# 公理依赖（#print axioms）

```
countable_iUnion 依赖: [propext, Classical.choice, Quot.sound]
```

**注意差异**：教科书"配对 (n,m) 编码"是显式构造，不提选择公理。
但 mathlib 的 `Set.countable_iUnion` 在处理任意指标 ι 的可数枚举时，
经由经典逻辑使用了 `Classical.choice`。本条目如实登记这个依赖。

# 应用与陷阱

**应用**：
- 单调函数不连续点至多可数（每个不连续点抓一个有理数，落进可数个"有趣位置"）。
- 级数收敛点集的结构论证。
- 测度论："可数个零测集之并可测且零测"的起点。

**陷阱**：
- **指标 vs 每片**：两个可数性**都必须**成立。指标可数但某片不可数 ⇒ 并不可数。
- **不是任意并**：任意（不可数）个集合的并没有这个性质。ℝ = ⋃_{x∈ℝ} {x} 就是反例。
  初学者常把"可数个"说成"任意个"。
- **有限并是特例**：有限个可数集的并可数，是它的直接推论（有限指标可数）。