---
id: analysis.real.sup
family: analysis.real
variant: ecnu
kind: theorem
state: verified
title: 确界原理
summary: 非空有上界集有上确界
premises: [analysis.real.bounded-sets.bdd-above]
mathlib: [Real.isLUB_sSup]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第一章（实数）"
---

# 动机

确界原理（完备性）是实数区别于有理数的**本质公理**：任何非空有上界的实数集合，
都有一个最小的上界（上确界）。这个"天花板本身也存在"的性质支撑了极限理论——
单调有界收敛、区间套、有限覆盖、微积分基本定理，追根溯源都到这里。

# 直觉

把集合 s 想成一列被天花板压住的点。确界原理说：把天花板**降到底**，
降到的那个位置（所有上界中最小的那个）依然存在，记作 sup s。
ℚ 里这常常失败：{q | q²<2} 有上界但没有最小上界（上确界 √2 ∉ ℚ）。

# 陈述（自然语言）

非空且有上界的实数集合 s 存在上确界：`sSup s` 是 s 的上界，
且小于它的任何数都不是上界（即它是所有上界的最小值）。

# 陈述（Lean 对照）

```lean
theorem sup_lub (s : Set ℝ) (hne : s.Nonempty) (hbdd : BddAbove s) : IsLUB s (sSup s) := by
  exact Real.isLUB_sSup hne hbdd
```

| 人话 | Lean |
|---|---|
| 上确界（最小上界） | `IsLUB s a` |
| 条件完备格给出的上确界算子 | `sSup s` |
| 前提：非空 | `s.Nonempty` |
| 前提：有上界 | `BddAbove s` |

# 思维脉络（thinking trace）

1. **理解 IsLUB**：`IsLUB s a` = a 是 s 的上界 ∧ a 小于等于所有上界
   （`∀ b, b 是上界 → a ≤ b`）。
2. **sSup 是什么**：ℝ 是条件完备格，`sSup` 是它的最小上界算子——在"非空且有上界"
   的条件下，`sSup s` 自动是上确界。
3. **证明**：`Real.isLUB_sSup hne hbdd` 一步给出；参数顺序（非空、有上界）要认准。
4. **数学意义**：这不是计算——"把天花板降到最低且不破"正是完备性，教科书把它
   作为公理（或其他等价的公理推出），mathlib 里它来自 `ConditionallyCompleteLinearOrder ℝ`。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 上确界 | `sSup s` |
| 最小上界 | `IsLUB s a` |
| 条件完备线性序（提供 sSup） | `ConditionallyCompleteLinearOrder ℝ` |

# 依赖（人话版）

- `analysis.real.bounded-sets.bdd-above`：确界原理的前提是"有上界"，概念上先理解有界。

# 公理依赖（#print axioms）

```
sup_lub 依赖: [propext, Classical.choice, Quot.sound]
```

choice 有两个来源，均不可削减：
1. **结构必需**：类型含 `ℝ` 的序结构（`≤`），mathlib 4.33 的 `ℝ` 序实例定义体经典构造；
2. **完备性构造**：条件完备格 `sSup` 的"最小上界存在"本质是经典选择
   （从所有上界中取最小者），这正是确界原理的形式化实现。

# 应用与陷阱

**应用**：
- 单调有界收敛定理（第三章）的直接来源。
- 定义极限、级数、积分时的"取极限对象"。
- 有限覆盖定理、闭区间连续函数性质（介值/最值）。

**陷阱**：
- **非空是硬前提**：空集有上界但没有有意义的 sSup（形式化里 `sSup ∅` 有约定值，
  但确界原理只在非空时讲"最小上界"）。
- **上确界未必属于集合**：sup 与 max 不同，sup s 可以不在 s 里（s=(0,1)，sup=1∉s）。
- 别把 sSup 当"最大元"——只在集合有最大元时才相等。
- ℚ 不满足确界原理，所以涉及确界的存在性论证必须回到 ℝ。