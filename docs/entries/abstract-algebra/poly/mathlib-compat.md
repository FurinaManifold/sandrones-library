---
id: abstract-algebra.poly.mathlib-compat
family: abstract-algebra.poly
variant: compatibility
kind: theorem
state: verified
title: Mathlib 多项式正式承载的历史课程接口
summary: 以正式 Polynomial 承载提供外延、根、单位、整环与根数结论
premises: [abstract-algebra.poly.def]
mathlib: [Polynomial.ext, Polynomial.dvd_iff_isRoot, Polynomial.isUnit_iff]
provenance:
  source_type: library
  ref: Sandrone's Library legacy polynomial API
---

# 动机

早期模块直接以 Mathlib `Polynomial` 为课程多项式；语义复核确认它正是有限支撑系数多项式，
因此重新确认为后续课程正式承载。本文件保存其既有课程定理入口。

# 直觉

本条目直接使用正式承载 `R[X]`、`coeff`、`eval` 和 `roots`。`PolynomialSequence` 反而作为
旧平行承载保留，并通过双向桥迁回这里。

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
| 正式教材承载 | `Polynomial R` / `R[X]` |
| 旧兼容表示 | `PolynomialSequence` |
| 双向迁移桥 | `toMathlibPolynomial`、`fromMathlibPolynomial` |

# 依赖（人话版）

本条目依赖 `poly.def` 中对有限支撑系数语义的教材解释；Mathlib API 是语义一致的正式承载。

# 应用与陷阱

- 新增上层教材定理应直接使用 `Polynomial`，同时给首次出现的课程概念补足教材解释。
- 直接复用不等于静默挂靠：类型类假设、记号和关键展开仍必须在课程文档披露。
