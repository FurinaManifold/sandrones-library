---
id: functional-analysis.operator.continuous-linear-map
kind: definition
state: staging
title: 有界线性算子与连续线性映射
premises: [topology.normed-space.def, linear-algebra.maps.basic]
mathlib: [LinearMap.mkContinuous, ContinuousLinearMap.le_opNorm]
provenance: {source_type: book, ref: "Conway, A Course in Functional Analysis, Chapter I"}
---

# 动机

泛函分析研究的基本态射不是任意线性映射，而是不会把小向量无限放大的线性算子。教材上最直接
的表达是存在统一常数 `C`，使所有向量都满足 `‖Tx‖≤C‖x‖`。

# 定义

`IsBoundedLinearOperator T` 表示存在非负实数 `C`，对每个 `x` 都有
`‖T x‖ ≤ C * ‖x‖`。非负性使 `C` 真正表示大小上界，也便于后续定义最小上界即算子范数。

# 陈述（自然语言）

零线性算子有界。一个线性映射有界，当且仅当它能包装成具有同一底层线性映射的连续线性映射。

# 陈述（Lean 对照）

- `IsBoundedLinearOperator`：教材有界性定义。
- `isBoundedLinearOperator_zero`：直接由定义验证零算子有界。
- `toContinuousLinearMap`：从显式全局界构造 Mathlib 连续线性映射。
- `isBoundedLinearOperator_iff_exists_continuousLinearMap`：教材定义与打包实现的精确桥。

# 思维脉络

正向取出定义中的 `C`，交给 `LinearMap.mkContinuous`；反向对打包连续线性映射取其算子范数，
使用标准估计 `‖Lx‖≤‖L‖‖x‖`。因此 Mathlib 结构是实现承载，而不是未解释的课程定义。

# 自然语言 ↔ Lean 映射

- 线性算子：`T : E →ₗ[ℝ] F`。
- 统一全局界：`∃ C, 0 ≤ C ∧ ∀ x, ‖T x‖ ≤ C * ‖x‖`。
- 打包连续线性映射：`E →L[ℝ] F`。
- 遗忘打包：`L.toLinearMap`。

# 依赖

复用拓扑学已经验收的 `NormedLinearSpace` 与线性代数的线性映射；不重复建立赋范空间定义。

# 应用与边界

本条只讨论实赋范空间。复赋范空间与半线性算子的推广留到接口稳定后；本批也尚未定义算子范数。
