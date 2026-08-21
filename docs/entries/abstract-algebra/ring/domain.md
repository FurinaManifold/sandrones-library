---
id: abstract-algebra.ring.domain
family: abstract-algebra.ring
variant: rotman
kind: theorem
state: verified
title: 整环、域与素/极大理想
summary: 整环无零因子；域中非零元可逆；素理想判据；极大理想是素理想；素理想⟹商环整环；R是域⟺零理想极大
premises: [abstract-algebra.ring.ideal]
mathlib: [IsDomain, IsField.mul_inv_cancel, Ideal.isPrime_iff, Ideal.IsMaximal.isPrime, Ideal.Quotient.isDomain, Ring.isField_iff_maximal_bot]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Ch 1（整环/域/素极大理想）
---

# abstract-algebra.ring.domain

- **家族**: `abstract-algebra.ring`
- **变体**: rotman
- **状态**: verified
- **一句话**: 整环无零因子；素理想 = 商整环；极大理想 = 商域。

## 直觉

整环：无零因子（a·b=0 ⟹ a=0 或 b=0）。域：非零元都可逆。素理想 I（a·b ∈ I ⟹ a∈I 或 b∈I）
使商环 R/I 是整环；极大理想使商环是域。域 ⟺ 零理想极大。

## 陈述（教材记号）

`is_domain_mul_eq_zero`：整环无零因子。
`is_field_inv_exists`：域中 a ≠ 0 ⟹ ∃ b, a·b = 1。
`is_prime_iff`：素理想判据（教材定义）。
`is_maximal_implies_is_prime`：极大 ⟹ 素。
`quotient_is_domain_of_is_prime`：素理想 ⟹ 商环整环。
`is_field_iff_bot_is_maximal`：R 是域 ⟺ (0) 极大。

## 依赖（人话版）

前提：abstract-algebra.ring.ideal。mathlib 的 `IsDomain`/`IsField` 是 Prop；`Ideal.IsPrime/IsMaximal`
是理想属性；`Ideal.Quotient.isDomain`（素⟹整环）；`Ring.isField_iff_maximal_bot`（域⟺零理想极大）。

## 应用与陷阱

- `[IsField R]` 不是 typeclass binder（IsField 是 Prop），要写成显式参数 `(hF : IsField R)`。
- `Ring.isField_iff_maximal_bot` 在 `namespace Ring`（`open Ideal` 下定义），全名带 `Ring.` 前缀。
