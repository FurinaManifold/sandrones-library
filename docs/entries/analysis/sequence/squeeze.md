---
id: analysis.sequence.squeeze
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: 夹逼定理
summary: aₙ ≤ bₙ ≤ cₙ 且 aₙ、cₙ 同趋于 l，则 bₙ 也趋于 l
premises: [analysis.sequence.definition]
mathlib: [tendsto_of_tendsto_of_tendsto_of_le_of_le]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第二章 §2 收敛数列的性质（定理 2.4/夹逼准则）
---

# analysis.sequence.squeeze

- **家族**: `analysis.sequence`
- **变体**: ecnu（华东师大《数学分析》第五版）
- **状态**: verified
- **一句话**: 两边夹住，中间自然收敛到同一个数。

## 动机（为什么要这条）

求极限时遇到的表达式常常算不出精确值，但能把它夹在两个好算的序列之间。
夹逼定理是"不求值而求极限"的第一把武器
（典型：lim (sin n)/n = 0，lim n^(1/n) = 1）。

## 直觉

- "aₙ 从下压着 bₙ，cₙ 从上压着 bₙ"，且上下两片都在 l 处合拢——
  夹在中间的 bₙ 没有别的出路，只能也到 l。
- 记住字诀：**同敛于一中，两边夹中间**。

## 自然语言 ↔ Lean 映射

| 中文 | Lean |
|---|---|
| 逐点不等式 | `∀ n, a n ≤ b n ≤ c n` |
| 上/下序列都趋于 l | `Tendsto a atTop (𝓝 l)`, `Tendsto c atTop (𝓝 l)` |
| 中间序列趋于 l | `tendsto_of_tendsto_of_tendsto_of_le_of_le ha hc hle₁ hle₂` |

## 思维脉络

1. 要把"逐点两不等式"送给机器，得把它们看成函数之间的 ≤
   （Pi 型的 ≤ 就是逐点 ≤），类型自动吻合。
2. mathlib 的通用夹逼引理 `tendsto_of_tendsto_of_tendsto_of_le_of_le` 一次到位：
   上、下各一个 Tendsto，加上两条逐点不等式，就给出中间序列的 Tendsto。

## 依赖

- `analysis.sequence.definition`（ε-N 判据；夹逼的证明本质是把两条
   ε-N 承诺叠在一起）。

## 应用与陷阱

- **两边必须同一极限** l。若两边极限不同，中间序列可能不收敛（或振荡）。
- 不等式不必恒成立——只要最终成立（对一切足够大的 n）也行；
  教材常写"从某项以后"。我们的形式化取逐点版（够用且简洁）。
- 使用套路：先找好上界/下界序列，再证它们收敛且极限相等，最后套定理。

## 形式化层

```lean
theorem squeeze_theorem {a b c : ℕ → ℝ} {l : ℝ}
    (hle₁ : ∀ n, a n ≤ b n) (hle₂ : ∀ n, b n ≤ c n)
    (ha : Tendsto a atTop (𝓝 l)) (hc : Tendsto c atTop (𝓝 l)) :
    Tendsto b atTop (𝓝 l) := by
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le ha hc hle₁ hle₂
```

**公理依赖（#print axioms）**

```
squeeze_theorem 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：类型含 ℝ 的拓扑/序结构（§3.7），choice 来自实例实现路径。

## mathlib 参考

- `tendsto_of_tendsto_of_tendsto_of_le_of_le`（OrderTopology 上的夹逼）