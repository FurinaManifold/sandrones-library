---
id: complex-analysis.holomorphic.algebra
family: complex-analysis.holomorphic
variant: textbook
kind: theorem
state: verified
title: 全纯函数的代数与复合封闭性
summary: 全纯函数对和、积、非零分母的商及满足值域条件的复合封闭
premises: [complex-analysis.holomorphic.definition]
mathlib: [DifferentiableAt.add, DifferentiableAt.mul, DifferentiableAt.div, DifferentiableAt.comp]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

定义全纯函数后，最先需要的是一套可组合的演算规则。若每遇到 `f+g`、`fg`、`f/g` 或 `f∘g` 都
重新展开差商，证明会重复同一批代数恒等式和极限规则。本条把这些基本闭包性质一次建立为公开接口。

# 直觉

复导数遵守与实微积分相同的和、积、商、链式法则。和与积处处安全；商在分母为零时没有定义良好
的局部倒数，因此必须逐点排除零；复合还必须保证内层函数 `g` 把 `U` 中的点送到外层函数 `f`
已知全纯的集合 `V`。

# 陈述（自然语言）

设 `f,g` 在 `U` 上全纯。

- `f+g` 在 `U` 上全纯；
- `fg` 在 `U` 上全纯；
- 若对所有 `z∈U` 都有 `g(z)≠0`，则 `f/g` 在 `U` 上全纯；
- 若 `g` 在 `U` 上全纯、`f` 在 `V` 上全纯且 `g(U)⊆V`，则 `f∘g` 在 `U` 上全纯。

# 陈述（Lean 对照）

```lean
theorem holomorphicOnTextbook_add
    (hf : HolomorphicOnTextbook f U) (hg : HolomorphicOnTextbook g U) :
    HolomorphicOnTextbook (fun z ↦ f z + g z) U

theorem holomorphicOnTextbook_mul ... :
    HolomorphicOnTextbook (fun z ↦ f z * g z) U

theorem holomorphicOnTextbook_div ...
    (hg0 : ∀ z ∈ U, g z ≠ 0) :
    HolomorphicOnTextbook (fun z ↦ f z / g z) U

theorem holomorphicOnTextbook_comp
    (hf : HolomorphicOnTextbook f V) (hg : HolomorphicOnTextbook g U)
    (hmap : MapsTo g U V) : HolomorphicOnTextbook (f ∘ g) U
```

# 思维脉络（thinking trace）

四个证明共用同一骨架。先 `intro z hz`，把集合上全纯展开成固定点的目标；再用
`complexDifferentiableAtTextbook_iff_differentiableAt.mpr` 把教材目标转成 Mathlib 点态可微。
输入假设通过同一桥的 `.mp` 方向变成 `DifferentiableAt ℂ`，随后分别调用：

1. `.add` 组合两个点态可微证明；
2. `.mul` 使用乘法的连续双线性结构；
3. `.div ... (hg0 z hz)` 在当前点加入分母非零证书；
4. 外层可微证明的 `.comp z` 接受内层可微证明。`hmap hz` 先给出 `g z ∈ V`，使外层假设可用。

最后桥的 `.mpr` 把 Mathlib 结果还原成本库差商定义，因此公开定理没有把 Fréchet API 泄漏到签名。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 固定 `U` 中一点 | `intro z hz` |
| 教材定义转 Mathlib 可微 | `..._iff_differentiableAt.mp` |
| Mathlib 可微转回教材定义 | `..._iff_differentiableAt.mpr` |
| 和法则 | `DifferentiableAt.add` |
| 积法则 | `DifferentiableAt.mul` |
| 商法则与分母非零 | `DifferentiableAt.div ... (hg0 z hz)` |
| 链式法则 | `DifferentiableAt.comp` |
| `g(U)⊆V` | `hmap : MapsTo g U V` |

# 依赖（人话版）

- `complex-analysis.holomorphic.definition`：提供差商定义和点态 Mathlib 双向桥。
- `DifferentiableAt.add` / `.mul`：Mathlib 已验证的和法则、积法则。
- `DifferentiableAt.div`：商法则；其非零参数准确对应教材中“避开分母零点”。
- `DifferentiableAt.comp`：链式法则的可微性部分；本条只证明复合仍全纯，不在签名中计算导数值。
- `Set.MapsTo`：记录内层值域落入外层全纯域，避免错误地在 `V` 外调用 `hf`。

# 应用与陷阱

- 应用：多项式、有理函数、指数与三角函数的组合可由这些规则模块化证明全纯。
- 陷阱：商定理要求 `g` 在整个 `U` 上逐点非零；只知道 `g` 不是恒零远远不够。
- 陷阱：复合顺序是外层 `f`、内层 `g`，Lean 写作 `f ∘ g`；`hmap` 的方向必须是 `g(U)⊆V`。
- 边界：本批只建立封闭性，没有在公开接口中给出和、积、商、复合的导数公式；后续若课程需要
  公式，应在“具有指定导数”的接口上另立定理。
