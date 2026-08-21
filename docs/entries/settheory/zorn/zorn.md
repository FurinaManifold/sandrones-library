---
id: settheory.zorn.zorn
family: settheory.zorn
variant: halmos
kind: theorem
state: verified
title: Zorn 引理
summary: Zorn引理（偏序每条链有上界⟹极大元）；子集族⊆版/⊇版；极大元定义
premises: []
mathlib: [zorn_le, zorn_subset, zorn_superset, IsMax, IsChain, BddAbove]
provenance:
  source_type: book
  ref: Halmos, Naive Set Theory, Ch 16（Zorn 引理）
---

# settheory.zorn.zorn

- **家族**: `settheory.zorn`
- **变体**: halmos
- **状态**: verified
- **一句话**: 每条链都有上界的偏序集必有极大元（等价于选择公理）。

## 直觉

Zorn 引理：非空偏序集 X 中，若每条链（全序子集）都有上界，则 X 含极大元。
这是选择公理的等价形式，是证明"极大理想存在"、"每个向量空间有基"、"Tychonoff 定理"的公理级工具。

## 陈述（教材记号）

`zorn_lemma`：偏序每条链有上界 ⟹ ∃ 极大元（IsMax）。
`zorn_subset_lemma`：子集族 S 中每条 ⊆ 链有上界 ⟹ 含极大元（⊆ 序）。
`zorn_superset_lemma`：每条 ⊇ 链有下界 ⟹ 含极小元（⊇ 序）。
`isMax_def`：极大元的定义（m ≤ a ⟹ a ≤ m）。

## 依赖（人话版）

前提：无（纯序理论/选择公理）。mathlib 的 `zorn_le`/`zorn_subset`/`zorn_superset` 是三个版本，
`IsMax`/`IsChain`/`BddAbove` 是构件。

## 应用与陷阱

- Zorn 引理等价于选择公理/良序定理，是"存在性"定理的总闸。
- 实际用法：构造某个偏序（如理想按 ⊆ 排），验证链有上界（并），套 zorn 得极大元。
- 库内依赖：极大理想（ring.domain）、基存在性（vector-space）、Tychonoff（compact.tychonoff）。
