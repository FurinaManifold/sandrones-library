---
id: abstract-algebra.group.index-two
family: abstract-algebra.group
variant: rotman
kind: theorem
state: verified
title: 指数 2 子群正规
summary: H.index = 2 ⟹ H.Normal（指数为 2 的子群必正规，教材经典定理）
premises: [abstract-algebra.group.coset]
mathlib: [Subgroup.normal_of_index_eq_two]
provenance:
  source_type: book
  ref: Rotman, An Introduction to the Theory of Groups, Ch 2（正规子群）
---

# abstract-algebra.group.index-two

- **家族**: `abstract-algebra.group`
- **变体**: rotman
- **状态**: verified
- **一句话**: 指数为 2 的子群必正规。

## 直觉

H 的指数 [G:H] = 2 ⟹ G 恰有两个左陪集 H 与 aH。对任意 g，gH 与 H 同侧
（要么 g∈H，要么 gH=aH 是另一个陪集），共轭 g·n·g⁻¹ 必然落回 H。

## 陈述（教材记号）

`normal_of_index_two H hH`：`H.index = 2` ⟹ `H.Normal`。

## 依赖（人话版）

前提：abstract-algebra.group.coset（index 定义）。mathlib 的 `Subgroup.normal_of_index_eq_two`
正是此定理。这是正规子群判断的重要工具（非平凡正规子群的"最小指数"情形）。

## 应用与陷阱

- 应用：指数 2 子群在有限群论中常用来构造正规子群。
- `H.index` 是陪集个数（= |G/H|），由 Lagrange 联系到阶。
