---
id: number-theory.elementary.pell-composition
family: number-theory.elementary
variant: brahmagupta
kind: definition
state: verified
title: Pell 解的 Brahmagupta 合成
summary: 两个同参数 Pell 解按显式坐标公式合成后仍是解
premises: [number-theory.elementary.pell-equation]
mathlib: []
provenance:
  source_type: book
  ref: "Ireland--Rosen, A Classical Introduction to Modern Number Theory, Section 17.5"
---

# 动机

一个非平凡 Pell 解不只是孤立样本：两个解可以合成新的解。显式合成公式是“由一个解生成更多
解”以及后来建立解群结构的初等代数核心。

# 直觉

把 `(x,y)` 暂时想成形式表达式 `x+y√d`。两个这样的表达式相乘，实部变成
`x₁x₂+d y₁y₂`，`√d` 的系数变成 `x₁y₂+y₁x₂`；范数
`x²-dy²` 相乘，所以两个范数一元素的积仍范数一。

# 陈述（自然语言）

两个同参数 `d` 的 Pell 解按 Brahmagupta 公式合成后仍满足 `X²-dY²=1`，其坐标分别是
`X=x₁x₂+d y₁y₂` 与 `Y=x₁y₂+y₁x₂`。

# 陈述（Lean 对照）

```lean
def PellSolution.comp (a b : PellSolution d) : PellSolution d

theorem pell_comp_x (a b : PellSolution d) :
    (a.comp b).x = a.x * b.x + d * (a.y * b.y)

theorem pell_comp_y (a b : PellSolution d) :
    (a.comp b).y = a.x * b.y + a.y * b.x
```

# 思维脉络（thinking trace）

若 `a=(x₁,y₁)`、`b=(x₂,y₂)`，定义

- 新的第一坐标为 `x₁x₂ + d y₁y₂`；
- 新的第二坐标为 `x₁y₂ + y₁x₂`。

# 为什么仍是解

直接展开可得

`X² - dY² = (x₁²-dy₁²)(x₂²-dy₂²) = 1·1 = 1`。

Lean 证明使用 `ring` 核验这个多项式恒等式，再代入两个输入解的方程。这个证明展示了合成律的
初等来源，不依赖 Mathlib 的打包群运算。

具体地，`calc` 先把新坐标的 Pell 表达式变成两个旧表达式之积；`rw [a.equation,
b.equation, one_mul]` 再把二者都替换成 `1`。两个坐标投影定理用 `rfl`，因为它们按定义相等。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 合成两个解 | `a.comp b` |
| 展开多项式并核验恒等式 | `ring` |
| 分段等式推理 | `calc ... := by ...` |
| 代入输入解方程 | `rw [a.equation, b.equation]` |
| 按定义相等 | `rfl` |

# 依赖（人话版）

- `number-theory.elementary.pell-equation`：提供坐标与方程证书。
- 整数交换环恒等式：范数乘法公式的全部数学内容。
- 不依赖 Mathlib 的 `Pell.Solution₁` 群结构；合成闭性在本库中直接可见。

# 应用与陷阱

- 应用：反复合成非平凡解可构造更多 Pell 解；公式也是乘法群接口的前身。
- 陷阱：两个输入必须使用同一个参数 `d`，不同 Pell 方程的解不能直接套此公式。
- 陷阱：合成保持方程，但本条本身没有证明结合律、逆元或不同幂彼此不同。
