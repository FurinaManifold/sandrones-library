---
id: abstract-algebra.poly.mathlib-compat
family: abstract-algebra.poly
variant: compatibility
kind: theorem
state: verified
title: Mathlib 多项式历史兼容接口
summary: 保留旧代码直接使用 Mathlib Polynomial 时所需的外延、根、单位和整环包装定理
premises: [abstract-algebra.poly.def]
mathlib: [Polynomial.ext, Polynomial.dvd_iff_isRoot, Polynomial.isUnit_iff]
provenance:
  source_type: library
  ref: Sandrone's Library legacy polynomial API
---

# 动机

早期模块直接以 Mathlib `Polynomial` 为课程多项式。A3.1 定义转正后，既有调用仍需要稳定入口，
但这些包装定理不能继续冒充本库多项式定义。

# 直觉

本条目是兼容层：它让旧代码继续使用 `R[X]`、`coeff`、`eval` 和 `roots`，新课程定理则应迁移到
`PolynomialSequence`。

# 陈述（自然语言）

兼容层保留 Mathlib 多项式的外延性、根与因式判据、多项式整环性、单位判据、根集成员判据和
乘积根判据。它不新增教材定义。

# 陈述（Lean 对照）

声明位于旧 `Poly.lean`，包括 `poly_ext`、`is_root_iff_eval_eq_zero`、
`dvd_X_sub_C_iff_isRoot`、`poly_is_domain_of_is_domain`、`poly_isUnit_iff`、
`mem_roots_iff_isRoot` 与 `root_mul_iff`。

# 思维脉络（thinking trace）

这些结论直接转交 Mathlib 已验证 API；独立 Entry 使 Registry 和审计不会把它们误判为新的教材
定义层，也避免同一 `poly.def` 横跨两个 Lean 文件。

# 自然语言 ↔ Lean 映射

| 角色 | 接口 |
|---|---|
| 新教材类型 | `PolynomialSequence` |
| 历史 Mathlib 类型 | `Polynomial R` / `R[X]` |
| 双向迁移桥 | `toMathlibPolynomial`、`fromMathlibPolynomial` |

# 依赖（人话版）

本条目依赖新的 `poly.def` 作为概念来源；Mathlib API 只是旧调用的承载。

# 应用与陷阱

- 新增上层教材定理不得继续以本条目替代 `PolynomialSequence` 定义层。
- 本条目的直接 Mathlib 签名是有意保留的兼容边界，不代表 A3 后续允许跳过定义迁移。
