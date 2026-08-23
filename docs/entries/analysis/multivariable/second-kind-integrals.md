---
id: analysis.multivariable.second-kind-integrals
kind: theorem
state: verified
title: "第二型曲线积分与曲面积分"
premises: ["analysis.multivariable.differential-forms"]
mathlib: ["AlternatingMap.map_smul_univ", "intervalIntegral.integral_comp_mul_deriv_of_deriv_nonneg",
  "intervalIntegral.integral_comp_mul_deriv_of_deriv_nonpos",
  "intervalIntegral.integral_deriv_eq_sub", "intervalIntegral.integral_add",
  "MeasureTheory.integral_add", "HasDerivAt.const_sub"]
provenance:
  source_type: book
  ref: "数学分析 II：第二型曲线积分与曲面积分"
---

# 动机

第一型积分只测量无向长度、面积或质量；第二型积分还记录曲线和曲面的方向。
Green、Gauss、Stokes 公式中的边界方向和法向符号，都必须通过第二型积分表达。

# 直觉

让 1-形式吃掉曲线速度 `γ'(t)`，得到沿曲线的有向密度；让 2-形式依次吃掉
`∂ᵤσ`、`∂ᵥσ`，得到曲面上的有向面积密度。交换切向量次序会使交替形式变号。

# 陈述（自然语言）

本条目定义 1-形式沿参数曲线、2-形式沿矩形参数曲面的第二型积分，并证明：
保向可微换参数不改变曲线积分；积分对形式可加；势函数外微分沿曲线的积分等于
势函数在终点与起点的值之差。

# 陈述（Lean 对照）

`curveFormIntegrand` 与 `surfaceFormIntegrand` 是两个拉回密度；
`secondKindCurveIntegral` 使用有向区间积分，`secondKindSurfaceIntegral` 使用已有的
矩形 Lebesgue 积分。`secondKindCurveIntegral_exact` 是曲线积分基本定理；
`covectorFieldAsOneForm` 给出坐标协向量场接口，`secondKindCurveIntegral_reverse`
给出反向变号。

# 思维脉络（thinking trace）

链式法则给出 `(γ ∘ φ)' = φ' • γ'(φ)`，1-形式的线性把 `φ'` 提到外面，再由
一元积分换元得到保向参数不变性。若 1-形式是 `df`，同一链式法则把被积函数化为
`(f ∘ γ)'`，最后应用 Newton–Leibniz 公式得到端点差。

# 自然语言 ↔ Lean 映射

- 1-形式曲线密度：`curveFormIntegrand`
- 第二型曲线积分：`secondKindCurveIntegral`
- 保向换参数：`secondKindCurveIntegral_comp_of_deriv_nonneg`
- 恰当形式端点公式：`secondKindCurveIntegral_exact`
- 协向量场写成 1-形式：`covectorFieldAsOneForm`
- 反向参数化变号：`secondKindCurveIntegral_reverse`
- 恰当形式沿闭曲线积分为零：`secondKindCurveIntegral_exact_closed`
- 2-形式曲面密度：`surfaceFormIntegrand`
- 第二型曲面积分：`secondKindSurfaceIntegral`

# 依赖（人话版）

依赖参数曲线和参数曲面的切向量、连续微分形式、外微分、一元有向积分与矩形二重
积分。线性定向接口解释正负号；基础定义本身由切向量的有序排列编码方向。

# 应用与陷阱

积分可加性必须假设相应密度可积，因为 Bochner 积分对不可积函数采用默认零值，
无条件加法不成立。当前曲面积分以矩形参数域定义；一般 Jordan 参数域可通过零延拓
和已有区域积分桥扩展。协向量场与反向参数化已经建立；二维 `P dx+Q dy`、三维通量
2-形式的显式分量公式以及 Green–Stokes 公式属于下一批。
