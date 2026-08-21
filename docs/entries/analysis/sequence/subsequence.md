---
id: analysis.sequence.subsequence
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: 子序列的定义与性质
summary: 收敛序列的任何子列收敛到同一极限
premises: [analysis.sequence.definition]
mathlib: [StrictMono.tendsto_atTop, Filter.Tendsto.comp]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第二章 §1-§3 数列极限
---

# analysis.sequence.subsequence

- **家族**: `analysis.sequence`
- **变体**: ecnu（华东师大《数学分析》第五版）
- **状态**: verified
- **一句话**: 收敛序列的任何子列收敛到同一极限。
- **Lean 名**: `IsSubsequenceOf`（定义）、`subsequence_of_convergent`（定理）

## 动机（为什么要这条）

子列是"抓取无限信息"的刀片：不收敛时我们还能从尾巴里挖出点东西
（这正是波尔查诺-魏尔斯特拉斯定理把有界序列"挖出"收敛子列的底座）。
必须先立好子列的语言，后面才能谈极限点、紧性、以及第四章函数的子列判据。

## 直觉

- "子列"不是随便挑几项，而是"跳着取但**绝不回头**"：下标函数 φ : ℕ → ℕ 严格递增
  （φ(n) < φ(n+1)），新数列就是 u ∘ φ = (u_{φ(0)}, u_{φ(1)}, …)。
- 若主干 uₙ → l，那么"从某一项起都落进任意 ε-邻域"。子列跳得再远，
  只要 φ(n) 最终超过那个起跑线（严格递增函数把 atTop 映到 atTop），
  尾巴全体还是落在邻域里——所以子列 → 同一极限。
- 一句话：**收不收敛是干事；子列只是"迟到"的同一批干事。**

## 自然语言 ↔ Lean 映射

| 中文 | Lean |
|---|---|
| v 是 u 的子列（存在严格递增 φ 使 v = u∘φ） | `IsSubsequenceOf u v` |
| φ 严格递增 ⟹ φ 逆着滤子 atTop 趋于 atTop | `StrictMono.tendsto_atTop` |
| 收敛的复合仍收敛 | `Filter.Tendsto.comp` |

## 思维脉络

1. 定义 `IsSubsequenceOf u v := ∃ φ, StrictMono φ ∧ v = u ∘ φ`——把"取子列"固化为一个操作。
2. `StrictMono.tendsto_atTop` 先生成 φ : atTop → atTop。
3. `Tendsto u atTop (𝓝 l)` 与 `Tendsto φ atTop atTop` 复合（`hu.comp`），
   得 `Tendsto (u ∘ φ) atTop (𝓝 l)`。
4. 回代 v = u∘φ 得证。

## 依赖

- `analysis.sequence.definition`（收敛的语言：atTop、𝓝、Tendsto）。

## 应用与陷阱

- 陷阱：子列极限存在 ≠ 原序列收敛。这条只说收敛 ⟹ 子列收敛。
- 陷阱："无穷个取法"不是子列：取法必须是**严格递增**，不能跳回头，也不能在同一项打转。
- 用途：若一个序列的某子列发散，则原序列必发散（反证：收敛就全收敛了）。

## 形式化层

```lean
def IsSubsequenceOf (u : ℕ → ℝ) (v : ℕ → ℝ) : Prop :=
  ∃ φ : ℕ → ℕ, StrictMono φ ∧ v = u ∘ φ

theorem subsequence_of_convergent {u : ℕ → ℝ} {l : ℝ}
    (hu : Tendsto u atTop (𝓝 l)) {v : ℕ → ℝ} (hsub : IsSubsequenceOf u v) :
    Tendsto v atTop (𝓝 l) := by
  rcases hsub with ⟨φ, hφ, rfl⟩
  exact hu.comp (StrictMono.tendsto_atTop hφ)
```

**公理依赖（#print axioms）**

```
subsequence_of_convergent 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：类型含 ℝ 的拓扑/序实例（§3.3），choice 来自实例实现路径。

## mathlib 参考

- `StrictMono.tendsto_atTop`（严格递增 ⟹ 滤子极限保持 atTop）
- `Filter.Tendsto.comp`（收敛函数复合）