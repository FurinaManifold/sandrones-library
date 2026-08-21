---
id: abstract-algebra.ring.iso
family: abstract-algebra.ring
variant: rotman
kind: theorem
state: verified
title: 环同态基本定理
summary: R/ker(f) ≅ im(f)（第一同构定理，环版）
premises: [abstract-algebra.ring.ideal]
mathlib: [RingHom.quotientKerEquivRange]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Ch 1（同态定理）
---

# abstract-algebra.ring.iso

- **家族**: `abstract-algebra.ring`
- **变体**: rotman
- **状态**: verified
- **一句话**: 商掉核之后，R/ker f 与值域 im f 完全同构。

## 直觉

环同态 f:R→S 的核 ker f 是理想（商环有意义）。第一同构定理：R/ker f ≅ im f。
群版的同构定理在 A1 已立，这是环版。

## 陈述（教材记号）

`ring_first_isomorphism f`：`R ⧸ ker f ≃+* im f`（环同构）。

## 依赖（人话版）

前提：abstract-algebra.ring.ideal（核是理想）。mathlib 的 `RingHom.quotientKerEquivRange f`
正是环版第一同构定理的显式同构。

## 应用与陷阱

- `RingHom.ker f : Ideal R`（理想），`f.range : Subring S`（子环）。
- 商环同构记号 `≃+*`。
