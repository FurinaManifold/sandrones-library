---
id: analysis.sequence.unique
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: 极限唯一
summary: 同一数列若有极限则极限唯一
premises: [analysis.sequence.definition]
mathlib: [tendsto_nhds_unique]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第二章 §2 收敛数列的性质（定理 2.1）
---

# analysis.sequence.unique

- **家族**: `analysis.sequence`
- **变体**: ecnu（华东师大《数学分析》第五版）
- **状态**: verified
- **一句话**: 序列不可能同时收敛到两个不同的数。

## 动机（为什么要这条）

极限如果不唯一，所有"求极限"的话语都是空的。它保证：
只要序列收敛，极限就是个确定的数，之后可以放心写 aₙ → l 。

## 直觉

- 若 aₙ 又趋向 a 又趋向 b（a ≠ b），取 ε 小于 |a−b|/2——
  那么足够大的 n 既要"最后落进 a 的 ε-邻域"，又要"落进 b 的 ε-邻域"，
  但这两个 ε-邻域互不相交（半径和小于距离）。无解，矛盾。
- 几何版：两个圆心距离超过 ε+ε，则开球不相交。

## 自然语言 ↔ Lean 映射

| 中文 | Lean |
|---|---|
| aₙ 趋向 a | `Tendsto u atTop (𝓝 a)` |
| 极限唯一 | `tendsto_nhds_unique ha hb : a = b` |

## 思维脉络

1. 教材用"取 ε = |a−b|/2 之半"的反证（详细写在一节）。
2. 机器版：`tendsto_nhds_unique` 是 Hausdorff 拓扑空间的一般事实——
   ℝ（连同通常拓扑）是 Hausdorff 空间，直接代入。

## 应用与陷阱

- 极限唯一是"记号安全"：`l = lim u` 才可定义。
- 用途：两个序列先求极限再比较；夹逼后验证两边极限相等（相等指同一数）。
- 反过来看：有界但不收敛的序列（(−1)ⁿ）不容衍生任何唯一的"极限符号"。

## 形式化层

```lean
theorem seq_limit_unique {u : ℕ → ℝ} {a b : ℝ}
    (ha : Tendsto u atTop (𝓝 a)) (hb : Tendsto u atTop (𝓝 b)) : a = b := by
  exact tendsto_nhds_unique (f := u) ha hb
```

**公理依赖（#print axioms）**

```
seq_limit_unique 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：类型含 ℝ 的拓扑结构（𝓝），ℝ 拓扑实例经典构造（§3.3）；
极限唯一的 Hausdorff 论断对 ℝ 成立本身不依赖选择公理，choice 来自实现路径。

## mathlib 参考

- `tendsto_nhds_unique`（T2Space 上的极限唯一）