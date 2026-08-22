---
id: analysis.series.riemann-rearrangement
kind: theorem
state: verified
title: "Riemann 条件重排的直接分块构造"
premises: ["analysis.series.conditional", "analysis.sequence.liminf-limsup"]
mathlib: ["Nat.find", "Finset.sum_Ico_eq_sub", "Equiv.ofBijective", "Filter.liminf_le_iff", "Filter.le_limsup_iff", "tendsto_of_tendsto_of_tendsto_of_le_of_le'"]
provenance:
  source_type: book
  ref: "Walter Rudin, Principles of Mathematical Analysis, Chapter 3, Theorem 3.54"
---

# 内容

把原级数的正项和负项分别枚举。给定 `α < β`，递归地加入至少一个正项直到部分和越过
趋于 `β` 的上目标，再加入至少一个负项直到部分和越过趋于 `α` 的下目标。所得正、负块
覆盖所有位置，并且块内的仿射索引给出原指标集的双射。

`direct_rudin_rearrangement` 返回构造的 `DirectBlockEvidence`：显式块索引是双射，重排部分和
最终夹在趋于 `α` 的负块端点与趋于 `β` 的正块端点之间。因此其 `liminf` 为 `α`，`limsup`
为 `β`。

# 公理依赖

构造首次越界位置和把双射函数提升为 `Equiv` 使用经典选择；其余证明建立在 Lean 的命题外延
与商类型健全性基础上。
