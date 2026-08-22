---
id: analysis.multivariable.full-rank-theorem
kind: theorem
state: verified
title: "满秩秩定理"
premises: ["analysis.multivariable.implicit-function"]
mathlib: ["ContDiffAt.eventually_apply_eq_iff_implicitFunction"]
provenance:
  source_type: book
  ref: "多元微积分：秩定理的满秩形式"
---

# 动机

秩定理把导数的线性代数信息提升为非线性映射的局部坐标正规形。

# 直觉

满秩方向可作为局部坐标消去，剩余自由方向参数化水平集。

# 陈述（自然语言）

若隐变量方向的偏全微分可逆，则在基点邻域内，水平集 `f(v)=f(u)` 当且仅当
`v₂=ψ(v₁)`，即水平集局部是一个函数图像。

# 陈述（Lean 对照）

`full_rank_level_set_normal_form` 用邻域上的 eventually iff 表达局部正规形。

# 思维脉络（thinking trace）

直接提取隐函数定理中更强的局部唯一性结论，而不只保留“图像上的点满足方程”。

# 自然语言 ↔ Lean 映射

- 正则水平集 ↔ `f v = f u`；局部图像 ↔ `ψ v.1 = v.2`。

# 依赖（人话版）

依赖隐函数定理；这是秩等于值域维数的次浸没情形。

# 应用与陷阱

本条目是满秩秩定理，不是一般常秩 `r` 定理。一般版本还需同时分解核与像并构造
两侧坐标变换，已在 ROADMAP 中单列。
