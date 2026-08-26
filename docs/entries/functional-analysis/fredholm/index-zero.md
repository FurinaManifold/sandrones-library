---
id: functional-analysis.fredholm.index-zero
family: functional-analysis.fredholm
variant: identity-minus-compact-index-zero
kind: theorem
state: verified
title: 恒等减紧算子的 Fredholm 指数为零
summary: 由幂核和值域稳定、Fitting 分解及指数复合可加性证明 index(I-K)=0
premises: [functional-analysis.fredholm.cokernel]
mathlib: [LinearMap.index, LinearMap.index_comp, Submodule.quotientEquivOfIsCompl, LinearMap.ker]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 指数记录什么

当核和余核都有限维时，Fredholm 指数是“核维数减余核维数”。本条直接使用
`LinearMap.index`，不建立第二套整数值不变量。

# 证明主线

先把 `(I-K)^n` 写成另一个“恒等减紧算子”，从而得到每个幂的闭值域、有限维核和有限维余核。
紧性与 Riesz 引理迫使幂核链最终停止增长；对偶算子上的同一论证和闭值域零化子刻画迫使幂值域链
最终停止下降。在足够高的正幂上，核和值域互补，Fitting 分解使该幂的指数为零。最后用指数对复合
的可加性得到该幂指数等于 `n · index(I-K)`，由 `n>0` 推出原指数为零。

# Lean 对照与边界

`compactPowerRemainder`、三个幂的有限性/闭性桥为公开消费者；稳定性和 Fitting 组装保持私有。
最终结论是 `index_identitySubCompact_eq_zero`。这不是一般紧扰动指数稳定性定理，也没有调用
Mathlib 的最终 Fredholm alternative package。

# 易混点

- 指数为零只说明核与余核维数相同，不单独推出核为零或余核为零。
- 单射与满射的等价还需要把“核为零”和“余核为零”分别连接到这两个性质。
- 幂稳定是证明工具，不表示算子本身幂等。
