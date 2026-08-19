---
id: analysis.sequence.cauchy
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: Cauchy 收敛准则（完备性）
summary: 实数列收敛当且仅当是 Cauchy 列
premises: [analysis.sequence.subsequence]
mathlib: [CauchySeq, Metric.cauchySeq_iff, cauchySeq_tendsto_of_complete]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第二章 §1-§3 数列极限
---

# analysis.sequence.cauchy

- **家族**: `analysis.sequence`
- **变体**: ecnu（华东师大《数学分析》第五版）
- **状态**: verified
- **一句话**: 实数列收敛 ⟺ 是 Cauchy 列（"和自己家族的尾巴靠拢" ⟺ "真有个极限去处"）。
- **Lean 名**: `convergent_is_cauchy`（收敛 ⟹ Cauchy）、`cauchy_seq_convergent`（Cauchy ⟹ 收敛）

## 动机（为什么要这条）

**不预知极限**就能判断收敛，这是 Cauchy 准则的真正价值：检验一个序列是否
"尾巴自相靠拢"只需要看它自己，不需要先猜出要奔谁去。它是实数完备性的
第一条实用形态——ℚ 里同样定义却会"收敛到 ℚ 外"（如 √2 的逼近列），
ℝ 把洞堵上了。后面的级数理论（部分和是 Cauchy ⟺ 级数收敛）全靠它。

## 直觉

- **收敛**：从某项起，全体落进某个 ε-邻域（"围着一个圆心挤"）。
- **Cauchy**：从某项起，任意两项之间的距离 < ε（"不需要圆心，自己围成圈"）。
- 收敛 ⟹ Cauchy：围着一个圆心挤，自然互相靠拢（双 ε/2 三角不等式）。
- Cauchy ⟹ 收敛（ℝ 完备）：圈围出来了，圆心必存在。这是 ℝ 的**结构事实**，
  mathlib 用 `CompleteSpace ℝ` 实例担保，定理 `cauchySeq_tendsto_of_complete` 直接发极限。

## 自然语言 ↔ Lean 映射

| 中文 | Lean |
|---|---|
| u 是 Cauchy 列 | `CauchySeq u` |
| Cauchy 的 ε-N 展开（距离判据） | `Metric.cauchySeq_iff` |
| Cauchy ⟹ 存在极限 | `cauchySeq_tendsto_of_complete` |
| 实轴上的距离 = 绝对值 | `Real.dist_eq` |
| 三角不等式 | `abs_add_le`、`abs_sub_comm` |

## 思维脉络

### 收敛 ⟹ Cauchy

1. 展开 `CauchySeq u` 成 `∀ ε > 0, ∃ N, ∀ m ≥ N, ∀ n ≥ N, dist (u m) (u n) < ε`。
2. 取 ε/2：收敛保证从某 N 起 |u m − l|、|u n − l| 都 < ε/2。
3. 三角不等式接力：|u m − u n| ≤ |u m − l| + |u n − l| < ε/2 + ε/2 = ε。

### Cauchy ⟹ 收敛

1. 直接调用 `cauchySeq_tendsto_of_complete`（ℝ 的 `CompleteSpace` 实例是"完备"这个词的机器表述）。

## 依赖

- `analysis.sequence.subsequence`（子列语言，第二章完备性证明习惯走子列 + 单调有界；
  本陈述直接调 mathlib 完备性，仅作语言准备）。

## 应用与陷阱

- 陷阱：**Cauchy 的定义不能"ε 缩到 0"**：`∃N ∀m n, dist < ε` 的 ε 在每一项独立、不能无限缩——区分开。
- 陷阱：Cauchy 的验证不用知道极限，这是它在"不知道值是多少"的场景胜出收敛判据的地方。
- 用途：级数收敛 ⟺ 部分和序列 Cauchy；函数列一致收敛里也用 Cauchy 套路（下一批会用到）。
- 口径：本库的 `CauchySeq` 用 mathlib 的滤子版定义，ε-N 展开即教材判据。

## 形式化层

```lean
theorem convergent_is_cauchy {u : ℕ → ℝ} {l : ℝ} (h : Tendsto u atTop (𝓝 l)) : CauchySeq u := by
  rw [Metric.cauchySeq_iff]
  intro ε hε
  have hε2 : 0 < ε / 2 := div_pos hε (by norm_num)
  rcases Metric.tendsto_atTop.mp h (ε / 2) hε2 with ⟨N, hN⟩
  refine ⟨N, ?_⟩
  intro m hm n hn
  rw [Real.dist_eq]
  have htri : |u m - u n| ≤ |u m - l| + |u n - l| := by
    calc
      |u m - u n| = |(u m - l) + (l - u n)| := by
        rw [show (u m - l) + (l - u n) = u m - u n by ring]
      _ ≤ |u m - l| + |l - u n| := abs_add_le _ _
      _ = |u m - l| + |u n - l| := by rw [abs_sub_comm l (u n)]
  linarith [htri,
    (show |u m - l| < ε / 2 by simpa [Real.dist_eq] using hN m hm),
    (show |u n - l| < ε / 2 by simpa [Real.dist_eq] using hN n hn)]

theorem cauchy_seq_convergent {u : ℕ → ℝ} (h : CauchySeq u) : ∃ l : ℝ, Tendsto u atTop (𝓝 l) := by
  exact cauchySeq_tendsto_of_complete h
```

**公理依赖（#print axioms）**

```
convergent_is_cauchy / cauchy_seq_convergent 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：类型含 ℝ 的拓扑/序实例（§3.7），choice 来自实例实现路径。

## mathlib 参考

- `CauchySeq`（柯西列：统一空间上的定义）
- `Metric.cauchySeq_iff`（ε-N 距离判据）
- `cauchySeq_tendsto_of_complete`（完备空间里 Cauchy 有极限；ℝ 完备）
- `abs_add_le` / `abs_sub_comm`（三角不等式与绝对值交换）