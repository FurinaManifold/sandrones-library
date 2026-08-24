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

# 教材陈述

若 `q : ℚ` 满足

`|ξ - q| < 1 / (2 * q.den²)`，

则存在 `n`，使 `q` 等于 `ξ` 的第 `n` 个连分数收敛子。

# 思维脉络

阈值强到足以迫使近似具有连分数算法产生的整数部分与倒数尾部；对分母归纳后，每一步都保留
相应误差条件，最终识别出某个收敛子。本库把复杂归纳封装在 Mathlib 已验证的
`Real.exists_rat_eq_convergent` 后面，只公开教材式误差谓词和结论。

# 重要边界

这是“非常好的近似 ⇒ 收敛子”的充分判据，不是“收敛子 ⇒ 最佳逼近”。后一个经典结论在
当前 Mathlib 接口中尚不存在，本条没有暗示其已经形式化。
