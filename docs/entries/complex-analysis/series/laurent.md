---
id: complex-analysis.series.laurent-foundation
family: complex-analysis.series
variant: foundation
kind: definition
state: verified
title: 解析 Laurent 展开的基础接口
summary: 定义环域上的整数双向 HasSum 展开并验证常数和简单极点例子
premises: []
mathlib: [HasSum, hasSum_ite_eq, zpow]
provenance:
  source_type: book
  ref: "Ahlfors, Complex Analysis, Laurent series"
---

# 动机

Taylor 级数不能表示奇点周围的负次幂。我们需要一个真正表示整数双向解析求和的教材接口。

# 直觉

在环域每个点，把 `coeff n * (z-center)^n` 对所有 `n : ℤ` 求和。负数指标就是 Laurent 主部。

# 陈述（自然语言）

定义开环域和“`f` 在该环域上具有系数 `coeff` 的 Laurent 展开”。常数函数只有零次项，`1/(z-center)` 只有负一次项。

# 陈述（Lean 对照）

```lean
def ComplexAnnulus (center : ℂ) (inner outer : ℝ) : Set ℂ
def HasLaurentExpansionOnAnnulus (f : ℂ → ℂ) (center : ℂ)
    (inner outer : ℝ) (coeff : ℤ → ℂ) : Prop
theorem hasLaurentExpansionOnAnnulus_const ...
theorem hasLaurentExpansionOnAnnulus_inv_sub ...
```

# 思维脉络（thinking trace）

审计发现 Mathlib `LaurentSeries` 是形式 `HahnSeries ℤ`，必须具有良序支撑，不能冒充可含无穷负次项的解析展开。因此直接使用 `ℤ → ℂ` 和 `HasSum`，并只证明 Mathlib 当前能闭合的有限支撑例子。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 开环域 | `ComplexAnnulus center inner outer` |
| 整数次系数 | `coeff : ℤ → ℂ` |
| 级数收敛到函数值 | `HasSum ... (f z)` |

# 依赖（人话版）

`HasSum` 记录无条件求和收敛；`hasSum_ite_eq` 证明单项非零级数的和；`zpow` 提供整数次幂。

# 应用与陷阱

这是 foundation，不是“环域全纯函数必有 Laurent 展开”的存在定理，也未证系数唯一性。不得用 Mathlib 形式 `LaurentSeries` 代替本性奇点的解析主部。
