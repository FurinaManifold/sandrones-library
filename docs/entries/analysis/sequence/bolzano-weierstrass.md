---
id: analysis.sequence.bolzano-weierstrass
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: 波尔查诺-魏尔斯特拉斯定理
summary: 有界实数列必有收敛的子列
premises: [analysis.sequence.bounded, analysis.sequence.subsequence]
mathlib: [CompactIccSpace.isCompact_Icc, IsCompact.isSeqCompact]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第二章 §1-§3 数列极限
---

# analysis.sequence.bolzano-weierstrass

- **家族**: `analysis.sequence`
- **变体**: ecnu（华东师大《数学分析》第五版）
- **状态**: verified
- **一句话**: 有界实数列必有收敛的子列。
- **Lean 名**: `bolzano_weierstrass`（闭区间版 `bolzano_weierstrass_interval`）

## 动机（为什么要这条）

"收敛"是大理想，但很多序列只是**有界**。本定理保证：有界并不算一无所有，
总能淘出至少一条收敛子列。它是实数**紧性**的第一次高调登场
（闭区间紧 ⟹ 其中的序列必有收敛子列），也是后面 Heine-Borel、
以及"极限点存在性"论证的万能抓手。

## 直觉

- 有上界又有下界 ⟹ 整个值域窝在某个闭区间 [−M, M] 里。
- 关键事实：**闭区间是紧的**；紧集上的每个序列都有收敛子列（序列紧）。
  mathlib 把这层包装在 `IsCompact.isSeqCompact` 里：紧集给任意 ∈ 该集的序列分派
  一条收敛子列，极限还落在集内。
- 一图流：有界 → 进区间 → 区间紧 → 挖出收敛子列（极限仍在区间里）。

## 自然语言 ↔ Lean 映射

| 中文 | Lean |
|---|---|
| 值域有上/下界 | `BddAbove (Set.range u)` / `BddBelow (Set.range u)` |
| 整体落在 [a,b] | `u n ∈ Set.Icc a b`（这层用引理 `sequence_bounded_in_interval` 建桥） |
| [a,b] 紧 | `CompactIccSpace.isCompact_Icc` |
| 紧集上的序列有收敛子列 | `IsCompact.isSeqCompact` |

## 思维脉络

1. 从上下界算出 M = max |a₀| |b₀|，证明 `-M ≤ u n ≤ M`（引理 `sequence_bounded_in_interval`）。
   - 上方向：u n ≤ b₀ ≤ |b₀| ≤ M；
   - 下方向：-M ≤ -|a₀| ≤ a₀ ≤ u n。
2. 闭区间版定理：值全在 [a,b] ⟹ `rcases hIcc.isSeqCompact h`，直接拿到
   φ（严格递增）、l、以及 `Tendsto (u∘φ) (𝓝 l)`。
3. 主定理：先从一般有界降到闭区间假设，再套闭区间版，丢掉"极限在区间里"的return。

## 依赖

- `analysis.sequence.bounded`（"有界"的口径：值域既有上界又有下界）。
- `analysis.sequence.subsequence`（子列语言：φ 严格递增、u∘φ）。

## 应用与陷阱

- 陷阱：**有界不保证原序列收敛**，只保证存在收敛子列（经典反例 uₙ = (−1)ⁿ）。
- 陷阱：子列极限 **∈ 闭区间**（紧性的"闭"字很关键，开区间 (0,1) 就不行：uₙ=1/n 推出收敛子列的极限落在 0 界外）。
- 用途：证明"有界序列有极限点"时，直接用：极限点 = 收敛子列的极限。
- 口径：本库把"有界"统一为"值域既有上界又有下界"，与处处用绝对值的 M-界写法等价。

## 形式化层

```lean
lemma sequence_bounded_in_interval {u : ℕ → ℝ}
    (hb : BddAbove (Set.range u)) (hbdl : BddBelow (Set.range u)) :
    ∃ a b : ℝ, ∀ n : ℕ, u n ∈ Set.Icc a b := by
  rcases hb with ⟨b₀, hb₀⟩
  rcases hbdl with ⟨a₀, ha₀⟩
  let M : ℝ := max |a₀| |b₀|
  refine ⟨-M, M, ?_⟩
  intro n
  constructor
  · dsimp [M]
    calc
      -max |a₀| |b₀| ≤ -|a₀| := neg_le_neg (le_max_left |a₀| |b₀|)
      _ ≤ a₀ := neg_abs_le a₀
      _ ≤ u n := ha₀ ⟨n, rfl⟩
  · dsimp [M]
    calc
      u n ≤ b₀ := hb₀ ⟨n, rfl⟩
      _ ≤ |b₀| := le_abs_self b₀
      _ ≤ max |a₀| |b₀| := le_max_right |a₀| |b₀|

theorem bolzano_weierstrass_interval {u : ℕ → ℝ} {a b : ℝ}
    (h : ∀ n : ℕ, u n ∈ Set.Icc a b) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧ ∃ l : ℝ, l ∈ Set.Icc a b ∧ Tendsto (u ∘ φ) atTop (𝓝 l) := by
  have hIcc : IsCompact (Set.Icc a b) := CompactIccSpace.isCompact_Icc
  rcases hIcc.isSeqCompact h with ⟨l, hl, φ, hφ, hlim⟩
  exact ⟨φ, hφ, l, hl, hlim⟩

theorem bolzano_weierstrass {u : ℕ → ℝ}
    (hb : BddAbove (Set.range u)) (hbdl : BddBelow (Set.range u)) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧ ∃ l : ℝ, Tendsto (u ∘ φ) atTop (𝓝 l) := by
  rcases sequence_bounded_in_interval hb hbdl with ⟨a, b, h⟩
  rcases bolzano_weierstrass_interval h with ⟨φ, hφ, l, _, hl⟩
  exact ⟨φ, hφ, l, hl⟩
```

**公理依赖（#print axioms）**

```
bolzano_weierstrass_interval / bolzano_weierstrass 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：类型含 ℝ 的拓扑/序实例（§3.7），choice 来自实例实现路径。

## mathlib 参考

- `CompactIccSpace.isCompact_Icc`（闭区间紧）
- `IsCompact.isSeqCompact`（紧集上序列必有收敛子列，极限在集内）
- `le_abs_self` / `neg_abs_le` / `le_max_left` / `le_max_right`（绝对值与 max 的比较）