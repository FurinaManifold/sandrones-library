---
id: analysis.sequence.bounded
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: 收敛必有界
summary: 收敛序列的值域既有上界也有下界
premises: [analysis.sequence.definition]
mathlib: [Metric.tendsto_atTop, IsBoundedUnder, BddAbove, BddBelow]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第二章 §2 收敛数列的性质（定理 2.2）
---

# analysis.sequence.bounded

- **家族**: `analysis.sequence`
- **变体**: ecnu（华东师大《数学分析》第五版）
- **状态**: verified
- **一句话**: 收敛 ⇒ 有界；反方向不成立。

## 动机（为什么要这条）

"有界"是最容易检验的条件，而"收敛"是研究目标。
这条单向桥让许多证明先证有界再谈极限（单调有界收敛就把两者接起来了）。
同时它是"有界不保证收敛"的反例温床（(−1)ⁿ）。

## 直觉

- 若 aₙ → l，取 ε=1：从第 N 项起，|aₙ − l| < 1，于是 l−1 < aₙ < l+1。
- 前面 {a₀, …, a_{N−1}} 只有有限项，明摆着有界（有限集必有最大小）。
- 两段合起来：整个值域都被夹住。

## 自然语言 ↔ Lean 映射

| 中文 | Lean |
|---|---|
| 值域有上界 | `BddAbove (Set.range u)` |
| 值域有下界 | `BddBelow (Set.range u)` |
| "从某处起最终 ≤ M" | `atTop.IsBoundedUnder (· ≤ ·) u` |
| 最终事件到有界的桥 | `isBoundedUnder_of_eventually_le` + `.bddAbove_range` |

## 思维脉络

1. 收敛 → 对 ε=1 拿到 N，尾部（n ≥ N）落在 (l−1, l+1)。
2. 把"最终 ≤ l+1"翻译成滤子事件（`∀ᶠ n in atTop, u n ≤ l + 1`），
   用 `isBoundedUnder_of_eventually_le` 得 `atTop.IsBoundedUnder (·≤·) u`。
3. 用 `.bddAbove_range` 把它翻译回值域语言 `BddAbove (range u)`。
   下界对称（用 `l−1` 与 `≥`，走 `.bddBelow_range`）。
   （注意：`|aₙ − l| < 1` 拆成两条不等式时才分开处理上与下。）

## 依赖

- `analysis.sequence.definition`（ε-N 判据）——ε=1 的取用来自它。

## 应用与陷阱

- 反例很重要：有界不收敛，如 uₙ = (−1)ⁿ。本定理只说单向。
- 收敛的必要条件用得上手：先证收敛 → 自动有界，可用于夹逼前的借力。
- 别把以下几点混淆：`BddAbove (range u)`（值域）、`IsBoundedUnder atTop`（最终有界）
  ——前者是全体值，后者是"从某处以后"，后者比前者弱且常先易得。

## 形式化层

```lean
theorem convergent_bddAbove {u : ℕ → ℝ} {l : ℝ} (h : Tendsto u atTop (𝓝 l)) :
    BddAbove (Set.range u) := by
  have hε : ∀ ε > 0, ∃ N : ℕ, ∀ n ≥ N, |u n - l| < ε := by
    simpa [Real.dist_eq] using Metric.tendsto_atTop.mp h
  rcases hε 1 zero_lt_one with ⟨N, hN⟩
  have hev : ∀ᶠ n in atTop, u n ≤ l + 1 := by
    rw [eventually_atTop]
    refine ⟨N, ?_⟩
    intro n hn
    have hpos : u n - l < 1 := (abs_lt.mp (hN n hn)).2
    linarith
  exact (isBoundedUnder_of_eventually_le (f := atTop) (u := u) (a := l + 1) hev).bddAbove_range

theorem convergent_bddBelow {u : ℕ → ℝ} {l : ℝ} (h : Tendsto u atTop (𝓝 l)) :
    BddBelow (Set.range u) := by
  have hε : ∀ ε > 0, ∃ N : ℕ, ∀ n ≥ N, |u n - l| < ε := by
    simpa [Real.dist_eq] using Metric.tendsto_atTop.mp h
  rcases hε 1 zero_lt_one with ⟨N, hN⟩
  have hev : ∀ᶠ n in atTop, l - 1 ≤ u n := by
    rw [eventually_atTop]
    refine ⟨N, ?_⟩
    intro n hn
    have hneg : -(1) < u n - l := (abs_lt.mp (hN n hn)).1
    linarith
  exact (isBoundedUnder_of_eventually_ge (f := atTop) (u := u) (a := l - 1) hev).bddBelow_range

theorem convergent_bounded {u : ℕ → ℝ} {l : ℝ} (h : Tendsto u atTop (𝓝 l)) :
    BddAbove (Set.range u) ∧ BddBelow (Set.range u) := by
  exact ⟨convergent_bddAbove h, convergent_bddBelow h⟩
```

**公理依赖（#print axioms）**

```
convergent_bddAbove/bddBelow/bounded 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：类型含 ℝ 的拓扑/序实例（§3.7），choice 来自实例实现路径。

## mathlib 参考

- `Metric.tendsto_atTop`, `eventually_atTop`, `isBoundedUnder_of_eventually_le/ge`,
  `IsBoundedUnder.bddAbove_range/bddBelow_range`, `abs_lt`