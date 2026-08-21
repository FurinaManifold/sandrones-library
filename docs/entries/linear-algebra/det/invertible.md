---
id: linear-algebra.det.invertible
family: linear-algebra.det
variant: ecnu
kind: theorem
state: verified
title: 可逆 ⟺ det≠0
summary: det A 可逆（≠0）⟹ A 有逆 A⁻¹
premises: []
mathlib: ["Matrix.nonsing_inv_mul", "Matrix.mul_nonsing_inv", "IsUnit"]
provenance:
  source_type: book
  ref: "线性代数教材：行列式"
---

# linear-algebra.det.invertible

- **家族**: `linear-algebra.det`
- **变体**: ecnu
- **状态**: verified
- **一句话**: det A 可逆（≠0）⟹ A 有逆 A⁻¹

## 直觉

det A≠0（即可逆元）⟺ A 可逆，且 A⁻¹ 是唯一逆。

## 陈述（教材记号）

IsUnit A.det ⟹ A⁻¹·A=1 ∧ A·A⁻¹=1

## 依赖（人话版）

前提：无；mathlib: Matrix.nonsing_inv_mul, mul_nonsing_inv

## 应用与陷阱

det=0 ⟺ 奇异矩阵；与秩满（rank=n）等价。
