---
id: number-theory.elementary.pell-positive-existence
family: number-theory.elementary
variant: positive-nonsquare
kind: theorem
state: verified
title: 正非平方参数的 Pell 非平凡解存在
summary: d>0 且 d 不是平方时，存在 x>1、y>0 满足 x²-dy²=1
premises: [number-theory.elementary.pell-equation]
mathlib: [Pell.Solution₁.exists_pos_of_not_isSquare, Pell.Solution₁.prop]
provenance:
  source_type: book
  ref: "ireland-rosen-number-theory-1990"
---

# 动机

平凡解 `(1,0)` 对任何参数都存在，却没有表现 Pell 方程的数论内容。核心存在性问题是：何时能
保证有 `y≠0` 的真正新解？正且非平方的参数正是经典 Pell 定理的条件。

# 直觉

当 `d` 是平方时，`x²-dy²` 可分解，正解行为退化；当 `d>0` 且非平方时，`√d` 是无理数，
其有理逼近最终产生范数一的整数对。Mathlib 已完成严格存在性证明，本条把结果拉回坐标语言。

# 陈述（自然语言）

对正整数参数 `d`，若不存在整数 `z` 使 `d=z²`，则正 Pell 方程存在 `x>1`、`y>0` 的解。
严格正性排除了 `(1,0)` 这个平凡解。

# 陈述（Lean 对照）

```lean
def IsIntegerSquare (d : ℤ) : Prop := ∃ z : ℤ, z ^ 2 = d

theorem isIntegerSquare_iff_isSquare (d : ℤ) :
    IsIntegerSquare d ↔ IsSquare d

theorem exists_positive_pellSolution_of_not_integerSquare {d : ℤ} (hd : 0 < d)
    (hns : ¬IsIntegerSquare d) :
    ∃ a : PellSolution d, 1 < a.x ∧ 0 < a.y

theorem exists_positive_pellSolution {d : ℤ} (hd : 0 < d) (hns : ¬IsSquare d) :
    ∃ a : PellSolution d, 1 < a.x ∧ 0 < a.y
```

前三项是教材定义、精确桥和课程主签名；最后一项保留为 Mathlib 兼容签名。

# 思维脉络（thinking trace）

先用整数坐标明确给出“平方”的定义，再由 `isIntegerSquare_iff_isSquare` 进入 Mathlib。
Mathlib 在 `Pell.Solution₁` 中以二次整数环的范数一元素证明存在性。本条只在证明内部取出其
`x`、`y` 坐标和方程证书，再包装成本库的 `PellSolution`；高层代数表示没有泄漏到教材签名。

1. `obtain ⟨a, hax, hay⟩ := Pell.Solution₁.exists_pos_of_not_isSquare hd hns` 取出打包解及正性。
2. `a.prop` 是该打包解满足 `a.x²-d*a.y²=1` 的证书。
3. `exact ⟨⟨a.x, a.y, a.prop⟩, hax, hay⟩` 先构造本库坐标解，再附上两条正性。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| `d` 严格为正 | `hd : 0 < d` |
| `d` 不是整数平方 | `hns : ¬ IsIntegerSquare d` |
| 取出存在的解 | `obtain ⟨a, hax, hay⟩ := ...` |
| Mathlib 解的方程 | `a.prop` |
| 重新包装坐标 | `⟨a.x, a.y, a.prop⟩ : PellSolution d` |

# 依赖（人话版）

- `Pell.Solution₁.exists_pos_of_not_isSquare`：Mathlib 的正非平凡解存在定理。
- `Pell.Solution₁.prop`：从内部打包解取得整数坐标方程。
- `number-theory.elementary.pell-equation`：公开结论所用的教材结构。

# 应用与陷阱

该存在性证明没有建立解与 `√d` 连分数周期的对应。Mathlib 原文件明确把这个连接列为 TODO。

- 应用：为基本解取最小正坐标提供非空性；给合成法提供非平凡起点。
- 陷阱：`IsIntegerSquare d` 的见证是整数；不能只检查自然数平方而忽略类型。
- 陷阱：本定理不覆盖 `d≤0`、平方参数或负 Pell 方程。
