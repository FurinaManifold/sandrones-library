---
id: abstract-algebra.group.def
family: abstract-algebra.group
variant: rotman
kind: theorem
state: verified
title: 子群判定与基本性质
summary: 子群判定定理（含单位元+乘/逆封闭⟹子群）；子群含单位元；外延性；平凡子群；全子群
premises: []
mathlib: [Subgroup, Subgroup.ext, Subgroup.one_mem, Subgroup.mul_mem, Subgroup.inv_mem, Subgroup.mem_bot, Subgroup.mem_top]
provenance:
  source_type: book
  ref: Rotman, An Introduction to the Theory of Groups, Ch 2（子群判定）
---

# abstract-algebra.group.def

- **家族**: `abstract-algebra.group`
- **变体**: rotman（Rotman《群论导引》）
- **状态**: verified
- **一句话**: 子集是子群 ⟺ 含单位元、对乘法与取逆封闭。

## 直觉

群 G 的子集 H 要成为一个子群，只需验证三条：单位元在 H 中、H 对乘法封闭、H 对取逆封闭。
这三条保证 H 内乘法仍是群运算。mathlib 的 `Subgroup` 就是承载"子群"这个概念的结构。

## 陈述（教材记号）

`subgroup_of_closed S h1 hmul hinv`：S 含单位元、对乘法与取逆封闭 ⟹ 存在子群 H 恰以 S 为元素集。
`subgroup_one_mem H`：1 ∈ H。`subgroup_ext`：元素集相同的子群相等。
`subgroup_bot_eq_singleton`：平凡子群 = {1}。`subgroup_top_eq_univ`：全子群 = G。

## 依赖（人话版）

前提：无。证明内部用 mathlib 的 `Subgroup.mk`（从 Set + 封闭性构造子群）、`Subgroup.ext`（外延性）、
`Subgroup.mem_bot`/`mem_top`。

## 应用与陷阱

- 子群判定是最常用判据：验证封闭性即可，不需重证结合律（群已给）。
- `Subgroup` 元素投影到 G 用 `↑`，子群内乘法 = 群内乘法（`Subgroup.coe_mul`）。
