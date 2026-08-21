---
id: linear-algebra.det.cramer
family: linear-algebra
variant: ecnu
kind: theorem
state: verified
title: Cramer 法则
summary: AX=b 时 (A.cramer b)ᵢ=det(A 的第 i 列换为 b)；A·(A.cramer b)=det A·b
premises: []
mathlib: ["Matrix.cramer", "Matrix.cramer_apply", "Matrix.mulVec_cramer"]
provenance:
  source_type: book
  ref: "线性代数教材：行列式与秩"
---

# linear-algebra.det.cramer

- **家族**: `linear-algebra`
- **变体**: ecnu
- **状态**: verified
- **一句话**: AX=b 时 (A.cramer b)ᵢ=det(A 的第 i 列换为 b)；A·(A.cramer b)=det A·b

## 直觉

线性方程组 AX=b：把 A 的第 i 列换成 b 得 Aᵢ，则 xᵢ=det Aᵢ/det A（det A≠0）。

## 陈述（教材记号）

(A.cramer b)ᵢ = det(A 第 i 列换为 b)；A·(A.cramer b)=det A·b

## 依赖（人话版）

前提：无；mathlib: Matrix.cramer, cramer_apply, mulVec_cramer

## 应用与陷阱

det A≠0 时 x=(A.cramer b)/det A 是 AX=b 的唯一解。
