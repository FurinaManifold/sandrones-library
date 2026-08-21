---
id: linear-algebra.eigen.independent
family: linear-algebra.eigen
variant: ecnu
kind: theorem
state: verified
title: 不同特征值对应特征向量线性无关
summary: 一族（成对不同）特征值各自对应的特征向量线性无关
premises: [linear-algebra.eigen.vector]
mathlib: [Module.End.eigenvectors_linearIndependent, Module.End.mem_eigenspace_iff]
provenance:
  source_type: book
  ref: 线性代数教材：特征向量与特征值
---

# linear-algebra.eigen.independent

- **家族**: `linear-algebra.eigen`
- **变体**: ecnu
- **状态**: verified
- **一句话**: 不同特征值对应特征向量线性无关。

## 直觉

若 x₁（属 μ₁）、x₂（属 μ₂）线性相关，则 x₁ = c·x₂；用 T 作用两边，
μ₁·x₁ = c·μ₂·x₂ = μ₂·x₁，得 (μ₁−μ₂)x₁=0，矛盾（μ₁≠μ₂ 且 x₁≠0）。
多特征值情形用归纳逐项消元。

## 陈述（教材记号）

对成对不同的一族特征值 μ，各取特征向量 x_μ（T x_μ = μ·x_μ，x_μ≠0），
则 {x_μ} 线性无关。

## 依赖（人话版）

premises: linear-algebra.eigen.vector（特征向量定义）；
mathlib: Module.End.eigenvectors_linearIndependent（证明内部桥接用）。

## 应用与陷阱

- 这是"n 个两两不同特征值 ⟹ 可对角化"的核心，也是特征多项式根个数判断对角化的基础。
- 证明中把教材的"特征向量（T x=μ·x）"桥接到 mathlib 的自同态语言（mem_eigenspace_iff），
  在证明内部完成，签名只见教材记号。
