---
id: number-theory.elementary.continued-fraction-convergent
family: number-theory.elementary
variant: textbook
kind: definition
state: verified
title: 实数连分数的有理收敛子
summary: 用递归的有理数序列表示实数简单连分数的逐级截断
premises: []
mathlib: [Real.convergent, Real.convergent_zero]
provenance:
  source_type: book
  ref: "ireland-rosen-number-theory-1990"
---

# 动机

简单连分数把实数的无限信息压缩成一串整数。为了在有限步骤里使用这串数据，需要把展开在
第 `n` 层截断；所得有理数就是第 `n` 个收敛子。它是后续误差估计、最佳逼近和 Legendre
判据共同使用的对象，所以必须先有一个只返回 `ℚ` 的教材接口。

# 直觉

每次从实数中拿走整数部分，再把剩余小数部分取倒数，就进入下一层。走有限次后反向代回，
只进行了整数加法和有理数倒数，因此结果是有理数。`n=0` 时还没进入尾部，答案就是 `⌊ξ⌋`。

# 陈述（自然语言）

`continuedFractionConvergent ξ n` 表示实数 `ξ` 的第 `n` 个简单连分数收敛子；特别地，第零个
收敛子等于 `ξ` 的向下取整。

# 陈述（Lean 对照）

```lean
noncomputable def continuedFractionConvergent (ξ : ℝ) (n : ℕ) : ℚ

theorem continuedFractionConvergent_zero (ξ : ℝ) :
    continuedFractionConvergent ξ 0 = (⌊ξ⌋ : ℤ)
```

`noncomputable` 来自实数取整及其实数表示，不改变数学陈述。公开接口返回 `ℚ`，因此读者不必
接触 Mathlib 的广义连分数结构。

# 思维脉络（thinking trace）

1. 教材需要的是有理数收敛子，而不是广义连分数的内部状态。
2. 用 `Real.convergent ξ n` 作为可靠实现，但以本库名称隐藏该实现选择。
3. 第零项定理调用 `Real.convergent_zero ξ`；它给出的等式与本库定义展开后完全一致。
4. `exact` 在这里表示“当前目标正是该 Mathlib 定理”，不进行搜索或额外推理。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 第 `n` 个收敛子 | `continuedFractionConvergent ξ n` |
| 实数的整数部分 | `⌊ξ⌋ : ℤ` |
| 第零个收敛子 | `continuedFractionConvergent ξ 0` |
| 用现成定理关闭同一目标 | `exact Real.convergent_zero ξ` |

# 依赖（人话版）

- `Real.convergent`：Mathlib 的有理值递归收敛子，承担实际定义。
- `Real.convergent_zero`：说明上述递归在零层就是向下取整。
- 本条没有库内前提，是 N1.5 其余连分数条目的起点。

# 应用与陷阱

本条只定义收敛子并给出第零项；收敛性、最佳逼近性质不是定义的一部分。Mathlib 的
`Real.convergent` 是本条的实现地基。

- 应用：递归公式和 Legendre 判据都以这个公开定义陈述结论。
- 陷阱：`noncomputable` 不等于“定理不可证明”，只说明一般实数不能由程序直接求出其取整序列。
- 陷阱：本条没有声称 `continuedFractionConvergent ξ n → ξ`，也没有声称每个收敛子最佳。
