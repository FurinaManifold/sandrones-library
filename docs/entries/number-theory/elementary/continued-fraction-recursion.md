---
id: number-theory.elementary.continued-fraction-recursion
family: number-theory.elementary
variant: textbook
kind: theorem
state: verified
title: 连分数收敛子的递归公式
summary: 去掉整数部分并取倒数后，后一层收敛子由同一规则递归产生
premises: [number-theory.elementary.continued-fraction-convergent]
mathlib: [Real.convergent_succ, Int.fract]
provenance:
  source_type: book
  ref: "Ireland--Rosen, A Classical Introduction to Modern Number Theory, continued fractions"
---

# 陈述

```lean
theorem continuedFractionConvergent_succ (ξ : ℝ) (n : ℕ) :
    continuedFractionConvergent ξ (n + 1) =
      (⌊ξ⌋ : ℤ) + (continuedFractionConvergent (Int.fract ξ)⁻¹ n)⁻¹
```

# 思维脉络

写 `ξ = ⌊ξ⌋ + fract ξ`。连分数的第一项是 `⌊ξ⌋`；余下尾部由
`1 / fract ξ` 的连分数给出。截断尾部到第 `n` 层，再把它取倒数并加回整数部分，正好得到
第 `n+1` 个收敛子。

# 边界与陷阱

有理数最终会出现 `fract = 0`。Lean 中 `0⁻¹ = 0`，所以递归仍是全定义的；不能把这个
全定义约定误读成“有理数的连分数永不终止”。
