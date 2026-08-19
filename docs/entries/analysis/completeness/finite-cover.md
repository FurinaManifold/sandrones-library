---
id: analysis.completeness.finite-cover
family: analysis.completeness
variant: generated
kind: theorem
state: verified
title: 有限覆盖原理（Heine-Borel）
summary: 闭区间 [a,b] 的每个开覆盖都有有限子覆盖
premises: []
mathlib: ["CompactIccSpace.isCompact_Icc", "IsCompact.elim_finite_subcover"]
provenance:
  source_type: generated
  ref: "Rudin, Principles of Mathematical Analysis, Thm 2.40"
---

# analysis.completeness.finite-cover

- **家族**: `analysis.completeness`
- **变体**: generated
- **状态**: verified
- **一句话**: 闭区间 [a,b] 的每个开覆盖都有有限子覆盖

## 直觉

无限多开片包住 [a,b] 时，真正出力的其实只有其中有限片——紧性的实质就是‘任意开覆盖可抽有限子覆盖’。

## 陈述（Lean 对照）

`∃ t : Finset ι, Set.Icc a b ⊆ ⋃ i ∈ t, U i`，直接用 ℝ 的紧实例 `CompactIccSpace.isCompact_Icc.elim_finite_subcover`。

## 依赖（人话版）

**前提**：无（直接来自 ℝ 的紧性实例）。
**mathlib**：`CompactIccSpace.isCompact_Icc`、`IsCompact.elim_finite_subcover`。

## 应用与陷阱

这一条是‘真定理’，环第 3 道要从闭区间套**手工**把它造出来时，是整条推理链最硬的一段。
