---
id: analysis.real.bounded-sets.bdd-below
family: analysis.real
variant: ecnu
kind: theorem
state: verified
title: 有下界集的刻画
summary: BddBelow s ⟺ 存在 a 使每个 x∈s 有 a ≤ x
premises: []
mathlib: [BddBelow]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第二章（数列极限·预备）
---

# analysis.real.bounded-sets.bdd-below

- **家族**: `analysis.real`
- **变体**: ecnu（华东师大《数学分析》第五版）
- **状态**: verified
- **一句话**: 集合有下界 ⟺ 有一条"地板"托住它的一切元素。

## 动机（为什么要这条）

`bdd-above` 讲"天花板"，这里讲"地板"。确界原理的反方向（下确界）需要它，
而常在证明里与上界成对出现（如"序列既有上界又有下界"）。一小段对称拷贝即可复用。

## 直觉

- 下界 = 数量 a，满足对 s 中每个 x 都有 a ≤ x：整组数都站在 a 上面。
- 与上界完全对称：上界把 `x ≤ M` 反过来就是下界 `a ≤ x`。
- 一个集合可以同时有上下界（有界），也可以只其一（如 ℕ 有下界 0，无上界）。

## 自然语言 ↔ Lean 映射

| 中文 | Lean |
|---|---|
| s 有下界 | `BddBelow s` |
| 存在下界 a | `∃ a : ℝ, ∀ x ∈ s, a ≤ x` |

## 思维脉络

教科书会说"若存在数 a 使得一切 x∈s 都有 a ≤ x，则称 a 是 s 的下界"。
既然 `BddBelow` 的定义就是这句话，左右两边逐词相同 → `rfl` 一步闭合。
> Lean 里"某条定义"与"它的展开"是定义相等（defeq），`rfl` 直接成立。

## 依赖

- 无（只用到定义展开与 ℝ 的 `≤`）。

## 应用与陷阱

- 与 `bdd-above` 配套使用：`BddBelow s ∧ BddAbove s` 同台出现时风格统一。
- 别把 `∃ a, ∀ x∈s, a ≤ x` 写成 `∀ x∈s, ∃ a, ...`——那是"每个元素都有自己的地板"，不是同一件事（前者是公共地板）。

## 形式化层

```lean
theorem bdd_below_iff (s : Set ℝ) : BddBelow s ↔ ∃ a : ℝ, ∀ x ∈ s, a ≤ x := by
  rfl
```

**公理依赖（#print axioms）**

```
bdd_below_iff 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：证明是 `rfl`（定义展开，证明体零公理），
但类型含 `ℝ` 的序结构，mathlib 4.33 的 `ℝ` 序实例定义体经典构造
（对照实验：ℚ/ℕ 同款 rfl 零公理，仅 ℝ 中招）——结构底线，不是噪声（Playbook §3.3）。

## mathlib 参考

- `BddBelow`