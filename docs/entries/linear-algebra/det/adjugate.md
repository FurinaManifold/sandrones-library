---
id: linear-algebra.det.adjugate
family: linear-algebra
variant: ecnu
kind: theorem
state: verified
title: 伴随矩阵
summary: adj A 满足 A·adj(A)=adj(A)·A=det A·I
premises: []
mathlib: ["Matrix.adjugate", "Matrix.mul_adjugate", "Matrix.adjugate_mul"]
provenance:
  source_type: book
  ref: "线性代数教材：行列式与秩"
---

# linear-algebra.det.adjugate

- **家族**: `linear-algebra`
- **变体**: ecnu
- **状态**: verified
- **一句话**: adj A 满足 A·adj(A)=adj(A)·A=det A·I

## 直觉

伴随矩阵 adj A 是代数余子式矩阵的转置；核心性质 A·adj(A)=adj(A)·A=det A·I。

## 陈述（教材记号）

A·adj A = det A·I；adj A·A = det A·I

## 依赖（人话版）

前提：无；mathlib: Matrix.adjugate, mul_adjugate, adjugate_mul

## 应用与陷阱

伴随矩阵是逆矩阵公式 adj/det 与 Cramer 法则的基础。
