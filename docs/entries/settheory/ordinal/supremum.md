---
id: settheory.ordinal.supremum
kind: theorem
state: verified
title: "序数族的上确界"
premises: ["settheory.ordinal.transfinite-recursion"]
mathlib: ["Ordinal.lt_iSup_iff"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 2: Suprema of Ordinals"}
---

# 动机
极限阶段通常把此前所有值取上确界。

# 直觉
对小指标族，若 `a` 已低于上确界，则必在某一项之前越过 `a`。

# 陈述（自然语言）
`a < sup_i f(i)` 当且仅当存在 `i` 使 `a<f(i)`。

# 陈述（Lean 对照）
`lt_supremum_iff {ι} [Small ι] f a`。

# 思维脉络（thinking trace）
直接使用序数上确界的共终性刻画；`Small` 控制宇宙大小。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 上确界 | `⨆ i, f i` |
| 小指标族 | `[Small ι]` |

# 依赖（人话版）
上确界是超限递归极限分支的标准组装方式。

# 应用与陷阱
省略 `Small` 可能造成宇宙层级不允许形成同一层的序数上确界。
