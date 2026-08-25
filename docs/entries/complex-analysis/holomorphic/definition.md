---
id: complex-analysis.holomorphic.definition
family: complex-analysis.holomorphic
variant: textbook
kind: definition
state: verified
title: 复可微与集合上全纯
summary: 以去心邻域差商极限定义复可微，并把集合上全纯定义为每点全邻域复可微
premises: []
mathlib: [slope_def_field, hasDerivAt_iff_tendsto_slope, DifferentiableAt.hasDerivAt, HasDerivAt.tendsto_slope, IsOpen.mem_nhds]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

复分析的入口不是“连续”而是方向无关的复差商极限。若直接把 Mathlib 的 Fréchet 可微谓词当成
定义，教材中最关键的 `(f(w)-f(z))/(w-z)` 会被隐藏。因此本条先把差商极限正式写成库内概念，
再证明它与 Mathlib 的复标量可微接口等价。

# 直觉

当 `w` 从任意复方向趋近 `z` 且始终不等于 `z` 时，割线斜率若趋向同一个复数 `L`，就称 `f`
在 `z` 复可微。排除 `w=z` 是因为差商分母为零。集合上全纯要求集合内每一点都满足这个
**全邻域**条件，而不是只沿集合内部方向取极限。

# 陈述（自然语言）

- `f` 在 `z` 复可微：存在复数 `L`，使 `w→z, w≠z` 时差商趋于 `L`。
- `f` 在 `U` 上全纯：对每个 `z∈U`，`f` 在 `z` 的全邻域复可微。
- 该点态定义等价于 Mathlib 的 `DifferentiableAt ℂ f z`。
- 对开集 `U`，集合上全纯等价于 Mathlib 的相对谓词 `DifferentiableOn ℂ f U`；没有开集条件时
  只保留“每点 `DifferentiableAt`”桥，不声称与相对可微等价。

# 陈述（Lean 对照）

```lean
def ComplexDifferentiableAtTextbook (f : ℂ → ℂ) (z : ℂ) : Prop :=
  ∃ L : ℂ, Tendsto (fun w ↦ (f w - f z) / (w - z))
    (nhdsWithin z {z}ᶜ) (nhds L)

def HolomorphicOnTextbook (f : ℂ → ℂ) (U : Set ℂ) : Prop :=
  ∀ z ∈ U, ComplexDifferentiableAtTextbook f z

theorem complexDifferentiableAtTextbook_iff_differentiableAt :
  ComplexDifferentiableAtTextbook f z ↔ DifferentiableAt ℂ f z

theorem holomorphicOnTextbook_iff_differentiableOn (hU : IsOpen U) :
  HolomorphicOnTextbook f U ↔ DifferentiableOn ℂ f U
```

# 思维脉络（thinking trace）

1. `rintro ⟨L, hL⟩` 从教材定义取出候选导数和差商极限。
2. `slope_def_field` 说明 Mathlib 的 `slope f z w` 正是同一个差商；`funext` 把逐点等式提升成
   两个函数相等，`rw` 再把极限中的函数整体替换。
3. `hasDerivAt_iff_tendsto_slope.mpr hL` 把斜率极限转成 `HasDerivAt f L z`，其
   `.differentiableAt` 忘掉具体导数，得到 Mathlib 可微性。
4. 反向由 `hf.hasDerivAt.tendsto_slope` 取得导数 `deriv f z` 的斜率极限，再按同一函数等式改写回
   教材差商。
5. 集合桥逐点应用上述等价。由全邻域可微到相对可微使用 `.differentiableWithinAt`；反向必须用
   `hU.mem_nhds hz` 把开集成员的相对可微提升到全邻域可微。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| `w` 趋于 `z` 但 `w≠z` | `nhdsWithin z {z}ᶜ` |
| 差商趋于 `L` | `Tendsto (fun w ↦ ...) ... (nhds L)` |
| 在点复可微 | `ComplexDifferentiableAtTextbook f z` |
| 在集合每点全邻域全纯 | `HolomorphicOnTextbook f U` |
| Mathlib 的复标量点态可微 | `DifferentiableAt ℂ f z` |
| Mathlib 的集合内相对可微 | `DifferentiableOn ℂ f U` |
| 把逐点等式变成函数等式 | `funext` |
| 按等式改写极限 | `rw` |

# 依赖（人话版）

- `slope_def_field`：把 Mathlib 的抽象斜率还原成域上的普通差商。
- `hasDerivAt_iff_tendsto_slope`：差商极限与一维 Fréchet 导数之间的核心双向桥。
- `DifferentiableAt.hasDerivAt` / `HasDerivAt.tendsto_slope`：从“存在导数”取规范导数并返回斜率极限。
- `IsOpen.mem_nhds`：开集内点拥有包含于该集合的邻域，是相对可微提升为全邻域可微所必需的条件。
- 当前 Mathlib 中没有名为 `ComplexDifferentiableAt` 或 `ComplexDifferentiableOn` 的常量；准确接口是
  把标量域指定为 `ℂ` 的 `DifferentiableAt ℂ` 与 `DifferentiableOn ℂ`。

# 应用与陷阱

- 应用：后续 Cauchy--Riemann、幂级数、初等全纯函数和复积分定理都可通过明确桥接复用 Mathlib。
- 陷阱：不能在任意非开集上把 `HolomorphicOnTextbook` 与 `DifferentiableOn ℂ` 无条件互换；后者
  只沿集合取极限，可能在边界点更弱。
- 陷阱：`nhdsWithin z {z}ᶜ` 的补集只排除中心点，不限制趋近方向，这正是复导数比沿曲线导数强的原因。
- 边界：本条只定义复可微和全纯，没有定义相对复可微；若课程需要边界上的相对版本，应另立接口。
