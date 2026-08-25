---
id: analysis.derivative.definition
family: analysis.derivative
variant: ecnu
kind: definition
state: verified
title: 一元导数的差商极限定义
summary: HasDerivativeAtTextbook 以去心差商极限定义导数值，并与 HasDerivAt 等价
premises: [analysis.func-limit.definition]
mathlib: [slope_def_field, hasDerivAt_iff_tendsto_slope, HasDerivAt]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第五章 §1 导数概念
---

# 动机

导数不是一个预先存在的符号，而是割线斜率在第二个点趋近基点时的极限。若直接把
`HasDerivAt f f' x` 当作定义，读者看不到差商、去心条件和候选导数值。本条先写出教材极限，
再把它与 Mathlib 的 Fréchet 导数特化接口连接起来。

# 直觉

固定基点 `x`，让另一个点 `y` 接近但不等于 `x`。割线斜率
`(f y-f x)/(y-x)` 若趋于同一个实数 `f'`，就称 `f'` 是 `f` 在 `x` 的导数。排除 `y=x`
是因为差商分母在中心点为零。

# 陈述（自然语言）

- `HasDerivativeAtTextbook f f' x` 表示差商在 `y→x, y≠x` 时趋于 `f'`。
- 它与 Mathlib 的 `HasDerivAt f f' x` 完全等价。
- `DifferentiableAt ℝ f x` 表示存在某个导数；`deriv f x` 是 Mathlib 在可导时给出的导数值。

# 陈述（Lean 对照）

```lean
def HasDerivativeAtTextbook (f : ℝ → ℝ) (f' x : ℝ) : Prop :=
  Tendsto (fun y => (f y - f x) / (y - x)) (𝓝[≠] x) (𝓝 f')

theorem hasDerivativeAtTextbook_iff_hasDerivAt {f : ℝ → ℝ} {f' x : ℝ} :
    HasDerivativeAtTextbook f f' x ↔ HasDerivAt f f' x
```

# 思维脉络（thinking trace）

1. 本库定义直接保存教材差商及去心邻域极限。
2. Mathlib 的 `slope f x y` 是统一处理割线斜率的函数。
3. `slope_def_field f x y` 在实数域上把它展开为 `(f y-f x)/(y-x)`；函数外延得到两个差商函数相等。
4. `hasDerivAt_iff_tendsto_slope` 说明 `HasDerivAt` 当且仅当 `slope f x` 在去心邻域趋于 `f'`。
5. 按函数等式改写后，两边逐字一致，得到无附加前提的双向桥。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| `f` 在 `x` 的导数为 `f'` | `HasDerivativeAtTextbook f f' x` |
| 割线斜率 | `(f y - f x) / (y - x)` |
| `y` 趋于 `x` 且不等于 `x` | `𝓝[≠] x` |
| 差商趋于 `f'` | `Tendsto ... (𝓝 f')` |
| Mathlib 指定导数值接口 | `HasDerivAt f f' x` |
| 导数存在 | `DifferentiableAt ℝ f x` |
| Mathlib 导数算子 | `deriv f x` |

# 依赖（人话版）

- `analysis.func-limit.definition`：提供去心函数极限的教材含义。
- `slope_def_field`：在域上把抽象 slope 还原成普通差商。
- `hasDerivAt_iff_tendsto_slope`：差商极限与 Mathlib 一元导数接口之间的核心桥。
- 实数的拓扑和域结构：分别解释极限与除法。

# 应用与陷阱

- 应用：导数唯一、四则运算、链式法则和反函数求导继续通过桥复用 `HasDerivAt` 定理。
- 陷阱：定义排除中心点，但极限仍使用 `f x`，因此函数在基点的实际取值参与差商。
- 陷阱：不可导时 `deriv f x` 仍是一个由 Mathlib 定义的值；使用求导公式时必须保留可导性前提。
- 边界：这是实函数的双侧有限导数，不包含单侧、无穷或 Fréchet 导数定义。
