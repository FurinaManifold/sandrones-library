---
id: linear-algebra.vector-space.span
family: linear-algebra.vector-space
variant: ecnu
kind: theorem
state: verified
title: 生成子空间
summary: span(s) 是包含 s 的最小子空间；span(s)⊆W ⟺ s⊆W
premises: []
mathlib: ["Submodule.span_le", "Submodule.span_mono"]
provenance:
  source_type: book
  ref: "线性代数教材：子空间与生成"
---

# linear-algebra.vector-space.span

- **家族**: `linear-algebra.vector-space`
- **变体**: ecnu
- **状态**: verified
- **一句话**: span(s) 是包含 s 的最小子空间；span(s)⊆W ⟺ s⊆W

## 直觉

s 的生成子空间是包含 s 的最小子空间；s⊆W ⟺ span(s)⊆W。

## 陈述（教材记号）

span(s)⊆W ⟺ s⊆W；s⊆span(s)；s⊆t→span(s)⊆span(t)

## 依赖（人话版）

前提：无；mathlib: Submodule.span_le

## 应用与陷阱

最小子空间是核心。
