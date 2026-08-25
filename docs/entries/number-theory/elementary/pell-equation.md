---
id: number-theory.elementary.pell-equation
family: number-theory.elementary
variant: positive
kind: definition
state: verified
title: Pell 方程的整数解
summary: 用整数坐标记录正 Pell 方程 x²-dy²=1 的解
premises: []
mathlib: []
provenance:
  source_type: book
  ref: "ireland-rosen-number-theory-1990"
---

# 动机

Pell 方程是最基本的二次不定方程之一。为了让初等数论课程直接讨论整数坐标，而不是先学习
二次整数环，本库把“一对整数满足方程”建成公开结构，后续合成、存在性和基本解都围绕它陈述。

# 直觉

`PellSolution d` 就是一张证书：记录整数 `x,y`，再附上它们确实满足 `x²-dy²=1` 的证明。
结构中的证明字段不增加新的数值数据，只防止把不满足方程的二元组误当成解。

# 陈述（自然语言）

参数 `d` 的 Pell 解由整数 `x,y` 以及等式 `x²-dy²=1` 组成；对每个 `d`，`(1,0)` 都是平凡解。

# 陈述（Lean 对照）

```lean
structure PellSolution (d : ℤ) where
  x : ℤ
  y : ℤ
  equation : x ^ 2 - d * y ^ 2 = 1
```

公开接口就是教材中的整数二元组及其方程证明，没有暴露二次整数环、范数一元素或群结构。
`(1,0)` 对每个 `d` 都给出平凡解。

# 思维脉络（thinking trace）

1. 用 `structure` 同时保存坐标和方程证书，使“是解”成为类型不变量。
2. 构造平凡解时填写 `x=1,y=0`。
3. `ring` 将 `1^2-d*0^2=1` 规范化为显然恒等式；它只做交换环多项式归约。
4. 没有调用 Mathlib `Pell.Solution₁`，所以定义层完全是初等整数语言。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 参数 `d` 的 Pell 解 | `PellSolution d` |
| 第一、第二坐标 | `a.x`, `a.y` |
| 方程证书 | `a.equation` |
| 平凡解 `(1,0)` | `PellSolution.one d` |
| 核验多项式恒等式 | `ring` |

# 依赖（人话版）

- 整数的环运算与幂：书写 Pell 方程所需的全部基础。
- `ring` tactic：验证平凡解的等式，不引入新的数学假设。
- 本条没有库内前提，是 Pell 子线的定义起点。

# 应用与陷阱

这里只研究正 Pell 方程右端 `1`。右端 `-1` 的负 Pell 方程并不总有解，Mathlib 的 Pell 文件也
把它列为后续扩展，因此本条不作相关存在性声称。

- 应用：合成两个解、陈述正解与基本解存在性。
- 陷阱：“正 Pell 方程”指右端为 `+1`，并不自动表示 `x,y,d` 都为正；正性要另加条件。
- 陷阱：`d` 在定义中允许任意整数，只有存在性定理才要求 `d>0` 且非平方。
