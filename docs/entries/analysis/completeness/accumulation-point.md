---
id: analysis.completeness.accumulation-point
family: analysis.completeness
variant: generated
kind: theorem
state: verified
title: 聚点定理
summary: 有界且无限的实集必有聚点
premises: ["analysis.sequence.bolzano-weierstrass", "analysis.real.bounded-sets.bdd-above", "analysis.real.bounded-sets.bdd-below"]
mathlib: ["Set.Infinite.exists_accPt_of_subset_isCompact", "AccPt"]
provenance:
  source_type: generated
  ref: "Rudin, Principles of Mathematical Analysis, Thm 2.37"
---

# analysis.completeness.accumulation-point

- **家族**: `analysis.completeness`
- **变体**: generated
- **状态**: verified
- **一句话**: 有界且无限的实集必有聚点

## 直觉

无限多个点挤在有界范围里，必然‘堆’出一个极限位置；每个去心邻域都还落着集合里的点。

## 陈述（Lean 对照）

`∃ x : ℝ, AccPt x (𝓟 s)`；把 s 包进 [sInf s, sSup s] 紧区间后用 `Set.Infinite.exists_accPt_of_subset_isCompact`。

## 依赖（人话版）

**前提**：`analysis.sequence.bolzano-weierstrass`（精神同源）、`analysis.sequence.bounded` 相关的双向有界。
**mathlib**：`Set.Infinite.exists_accPt_of_subset_isCompact`、`AccPt`。

## 应用与陷阱

AccPt = 去心邻域语言的聚点：`AccPt x (𝓟 s) ↔ ∀ U ∈ 𝓝 x, ∃ y ∈ U ∩ s, y ≠ x`。
