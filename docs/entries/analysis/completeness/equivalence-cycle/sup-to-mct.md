---
id: analysis.completeness.equivalence-cycle.sup-to-mct
family: analysis.completeness.equivalence-cycle
variant: generated
kind: theorem
state: verified
title: 确界 ⟹ 单调收敛
summary: 环第1道：从确界原理推出单调收敛定理（tendsto_atTop_ciSup 直达）
premises: ["analysis.real.sup"]
mathlib: ["tendsto_atTop_ciSup", "IsLUB.ciSup_eq"]
provenance:
  source_type: generated
  ref: "本库自建：实数完备性六大等价环"
---

# analysis.completeness.equivalence-cycle.sup-to-mct

- **家族**: `analysis.completeness.equivalence-cycle`
- **变体**: generated
- **状态**: verified
- **一句话**: 环第1道：从确界原理推出单调收敛定理（tendsto_atTop_ciSup 直达）

## 直觉

单调递增且被天花板挡住 → 把天花板换成值域的上确界，mathlib 的 `tendsto_atTop_ciSup` 正好说‘单调 + 有界 ⟹ 收敛到上确界’。

## 陈述（Lean 对照）

`(h : SupProperty) : MonotoneConvergenceProperty`：rcases 拿 `IsLUB (range u) x`，`tendsto_atTop_ciSup` 给收敛到 `⨆ u`，再 `IsLUB.ciSup_eq` 换成 x。

## 依赖（人话版）

**前提**：`analysis.real.sup`（IsLUB 的语言）。
**mathlib**：`tendsto_atTop_ciSup`、`IsLUB.ciSup_eq`。

## 应用与陷阱

证明类别 B：语义化组装，没有手工 ε-N，因为最重的力学已被 mathlib 做完。
