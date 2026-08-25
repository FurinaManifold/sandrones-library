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
  ref: "ireland-rosen-number-theory-1990"
---

# 动机

只有一个名称还不足以计算或推理收敛子；必须知道怎样从 `ξ` 的整数部分和尾部收敛子得到
下一项。递归公式正是连分数算法的 Lean 化入口。

# 直觉

写 `ξ = ⌊ξ⌋ + fract ξ`。拿走 `⌊ξ⌋` 后，把小数部分倒置，得到下一层实数。
先求该尾部的第 `n` 个收敛子，再倒置并加回整数部分，就得到原数的第 `n+1` 个收敛子。

# 陈述（自然语言）

实数 `ξ` 的第 `n+1` 个收敛子，等于其整数部分加上 `1 / fract(ξ)` 的第 `n` 个收敛子的倒数。

# 陈述（Lean 对照）

```lean
theorem continuedFractionConvergent_succ (ξ : ℝ) (n : ℕ) :
    continuedFractionConvergent ξ (n + 1) =
      (⌊ξ⌋ : ℤ) + (continuedFractionConvergent (Int.fract ξ)⁻¹ n)⁻¹
```

# 思维脉络（thinking trace）

1. 展开本库 `continuedFractionConvergent` 后，目标变成 Mathlib 的递归等式。
2. `Real.convergent_succ ξ n` 已精确表达“整数部分 + 尾部倒数”。
3. `exact` 直接复用该等式；`@[simp]` 让以后遇到具体后继下标时能自动按递归式改写。
4. 没有用 `ring` 或数值自动化，因为这一步是定义递归，不是代数恒等式。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 小数部分 | `Int.fract ξ` |
| 下一层实数 | `(Int.fract ξ)⁻¹` |
| 有理尾部取倒数 | `(continuedFractionConvergent ... n)⁻¹` |
| 后继层 | `n + 1` |
| 递归改写规则 | `Real.convergent_succ` |

# 依赖（人话版）

- `number-theory.elementary.continued-fraction-convergent`：给出被递归的公开对象。
- `Int.fract`：`fract ξ = ξ - ⌊ξ⌋` 的小数部分。
- `Real.convergent_succ`：Mathlib 已验证的递归展开式。

# 应用与陷阱

有理数最终会出现 `fract = 0`。Lean 中 `0⁻¹ = 0`，所以递归仍是全定义的；不能把这个
全定义约定误读成“有理数的连分数永不终止”。

- 应用：对特定实数逐层展开；证明整数输入的所有收敛子保持不变。
- 边界：本式描述生成规则，并不单独证明误差趋于零。
- 陷阱：右侧外层和内层各有一次倒数，漏掉任意一次都会改变连分数层级。
