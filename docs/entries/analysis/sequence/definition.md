---
id: analysis.sequence.definition
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: 数列收敛的 ε-N 判据
summary: Tendsto u atTop (𝓝 l) ⟺ 对每个 ε>0，存在 N，∀n≥N 有 |u n − l| < ε
premises: []
mathlib: [Metric.tendsto_atTop]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第二章 §1 数列极限概念
---

# analysis.sequence.definition

- **家族**: `analysis.sequence`
- **变体**: ecnu（华东师大《数学分析》第五版）
- **状态**: verified
- **一句话**: "aₙ → l" = 无论你要求多近（ε），从某一项起所有项都落在 l 的 ε-邻域里。

## 动机（为什么要这条）

极限是全书第一个"无限"概念。它的困难在于：不能说"第∞项等于 l"，
而要把"最终趋势"翻译成只用有限步检查的命题——这正是 ε-N 语言。
这条定义是后面所有极限定理的语法起点。

## 直觉

- "aₙ 越来越靠近 l"不是预言，是承诺：**每个 ε 都能兑现**。
- ε 扮演"考核标准"，N 扮演"信赖的起点"：从第 N 项起全部过关。
- 等价形式：`Tendsto u atTop (𝓝 l)`（mathlib 的滤子语言）⟺
  `∀ ε > 0, ∃ N, ∀ n ≥ N, |u n − l| < ε`（教材语言）。

## 自然语言 ↔ Lean 映射

| 中文 | Lean |
|---|---|
| 数列趋于 l | `Tendsto u atTop (𝓝 l)` |
| ε-N 判据 | `∀ ε > 0, ∃ N : ℕ, ∀ n ≥ N, |u n - l| < ε` |
| 距离 | `|u n - l|`（实轴上 `dist (u n) l`） |

## 思维脉络

1. `Metric.tendsto_atTop` 说"趋于 l = 距离最终 < ε"——这正是度量空间的语言。
2. 实轴上距离就是绝对值 `|x − y|`（`Real.dist_eq`）。
3. 把两句话拼起来，就是教材一字不差的 ε-N 判据。

## 应用与陷阱

- ε 要任意正——你不能说"ε = 0.001 就够"；但**通用引理只需证明一个**，
  使用时给具体 ε 是对的（如证明有界时取 ε=1）。
- N 依赖 ε：N=N(ε)，不能反过来。
- 两个方向都会用：已知收敛 → 取任意 ε 拿到 N；要证收敛 → 对任意 ε 造出 N。

## 形式化层

```lean
theorem tendsto_iff_epsilon_N {u : ℕ → ℝ} {l : ℝ} :
    Tendsto u atTop (𝓝 l) ↔ ∀ ε > 0, ∃ N : ℕ, ∀ n ≥ N, |u n - l| < ε := by
  simpa [Real.dist_eq] using Metric.tendsto_atTop (u := u) (a := l)
```

**公理依赖（#print axioms）**

```
tendsto_iff_epsilon_N 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：类型含 `ℝ` 的拓扑（`𝓝`）与序结构，
mathlib 的 ℝ 实例（拓扑、度量、有序域）定义体经典构造（Playbook §3.7）。

## mathlib 参考

- `Metric.tendsto_atTop`, `Real.dist_eq`, `Tendsto`, `atTop`, `𝓝`