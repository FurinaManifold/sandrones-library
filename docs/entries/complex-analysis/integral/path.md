---
id: complex-analysis.integral.path
family: complex-analysis.integral
variant: textbook
kind: definition
state: verified
title: 复路径与路径积分
summary: 以标量一形式定义复路径积分及可积性，并给出连续 integrand 沿 C1 路径的可积性与线段公式
premises: [complex-analysis.holomorphic.definition]
mathlib: [Path, curveIntegral, CurveIntegrable, curveIntegral_segment, ContinuousLinearMap.smulRight]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

复分析教材写 `∫_γ f(z) dz`，而 Mathlib 的核心对象是连续路径 `Path a b` 上的一形式曲线积分。本条目提供两者之间的显式桥梁，同时保留 Mathlib 已有的端点、反向与拼接结构。

# 直觉

复函数 `f` 决定一形式 `f(z) dz`：它在点 `z` 把速度向量 `v` 送到 `v * f z`。沿路径积分这个一形式，就是熟悉的复路径积分。路径本身只要求连续；可积性由 `PathIntegrable` 单独记录，因此 C¹ 以及分段 C¹ 情形都能使用同一接口。

# 陈述（自然语言）

定义标量一形式、复路径积分及其可积性。若 `f` 连续且路径的延拓在 `[0,1]` 上为 C¹，则积分存在。在线段 `a` 到 `b` 上，积分化为

`∫₀¹ (b-a) f((1-t)a+tb) dt`。

# 陈述（Lean 对照）

```lean
scalarOneForm (f : ℂ → ℂ) : ℂ → ℂ →L[ℂ] ℂ
pathIntegral (f : ℂ → ℂ) (γ : Path a b) : ℂ
PathIntegrable (f : ℂ → ℂ) (γ : Path a b) : Prop
pathIntegrable_of_continuous_of_contDiffOn
pathIntegral_segment
```

# 思维脉络（thinking trace）

先不重新定义“路径”，避免复制 `Path` 的端点与拼接公理。再把教材的 `f(z) dz` 翻译成连续线性映射值函数，交给 `curveIntegral`。C¹ 条件只用来推出可积性；分段 C¹ 路径则逐段应用该结论，再用拼接保持可积性。

# 自然语言 ↔ Lean 映射

“路径”对应 `Path a b`；“`f(z) dz`”对应 `scalarOneForm f`；“沿路径积分”对应 `pathIntegral f γ`；“积分存在”对应 `PathIntegrable f γ`；“直线段”对应 `Path.segment a b`。

# 依赖（人话版）

`CurveIntegral.Basic` 提供一形式曲线积分、路径反向和拼接。`ContinuousLinearMap.smulRight` 把复数 `f z` 变成作用于速度的连续线性映射。区间积分负责线段参数公式。

# 应用与陷阱

`Path` 只编码连续性，不声称每条路径都分段 C¹；需要积分定理时应携带 `PathIntegrable`，或用 C¹ 条件推出它。`pathIntegral_segment` 使用有向区间和从 `a` 到 `b` 的标准参数，不应遗漏因子 `b-a`。
