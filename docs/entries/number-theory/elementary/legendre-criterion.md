---
id: number-theory.elementary.legendre-criterion
family: number-theory.elementary
variant: classical
kind: theorem
state: verified
title: Legendre 连分数判据
summary: 误差小于分母平方倒数的一半时，该有理数必为连分数收敛子
premises: [number-theory.elementary.continued-fraction-convergent]
mathlib: [Real.exists_rat_eq_convergent]
provenance:
  source_type: book
  ref: "Hardy--Wright, An Introduction to the Theory of Numbers, Legendre theorem"
---

# 动机

直接判断某个有理数是否出现在 `ξ` 的连分数展开里并不容易。Legendre 定理给出一个只检查
误差和分母的强判据：近似若好到越过明确阈值，就不可能是偶然的，必由连分数算法产生。

# 直觉

分母为 `b` 的不同约分分数之间存在离散间隔。误差小于 `1/(2b²)` 时，候选被锁定在足够窄的
区间；欧几里得式的整数部分与倒数步骤会被逐层强制，最终识别为收敛子。

# 陈述（自然语言）

若 `q : ℚ` 满足

`|ξ - q| < 1 / (2 * q.den²)`，

则存在 `n`，使 `q` 等于 `ξ` 的第 `n` 个连分数收敛子。

# 陈述（Lean 对照）

```lean
def IsLegendreApproximation (ξ : ℝ) (q : ℚ) : Prop :=
  rationalApproximationError ξ q < 1 / (2 * (q.den : ℝ) ^ 2)

theorem legendreApproximation_is_convergent { ξ : ℝ } {q : ℚ}
    (hq : IsLegendreApproximation ξ q) :
    ∃ n, q = continuedFractionConvergent ξ n
```

# 思维脉络（thinking trace）

阈值强到足以迫使近似具有连分数算法产生的整数部分与倒数尾部；对分母归纳后，每一步都保留
相应误差条件，最终识别出某个收敛子。本库把复杂归纳封装在 Mathlib 已验证的
`Real.exists_rat_eq_convergent` 后面，只公开教材式误差谓词和结论。

在 Lean 中 `hq` 的定义展开后正是 Mathlib 定理的假设；`exact Real.exists_rat_eq_convergent hq`
完成桥接。`exact` 不证明 Mathlib 内部的归纳，而是复用已经由内核检查的证明项。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 绝对误差 | `rationalApproximationError ξ q` |
| 规范分母 | `q.den` |
| Legendre 阈值 | `1 / (2 * (q.den : ℝ) ^ 2)` |
| 满足判据 | `IsLegendreApproximation ξ q` |
| 是某个收敛子 | `∃ n, q = continuedFractionConvergent ξ n` |

# 依赖（人话版）

- `continuedFractionConvergent`：结论使用的教材层收敛子。
- `Real.exists_rat_eq_convergent`：Mathlib 中 Legendre 定理的完整归纳证明。
- `Rat.den` 严格为正，阈值不存在除以零问题。

# 应用与陷阱

这是“非常好的近似 ⇒ 收敛子”的充分判据，不是“收敛子 ⇒ 最佳逼近”。后一个经典结论在
当前 Mathlib 接口中尚不存在，本条没有暗示其已经形式化。

- 应用：从一个外部误差估计反推出候选属于连分数收敛子序列。
- 陷阱：不等号必须严格；等于阈值的情形不能直接套本定理。
- 陷阱：阈值中的分母是约分后的 `q.den`，不是任意表示 `a/b` 的 `b`。
