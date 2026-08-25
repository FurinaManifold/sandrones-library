---
id: settheory.ordinal.power-bridge
kind: theorem
state: verified
title: "本库序数幂的通用运算桥"
premises: ["settheory.ordinal.exponentiation"]
mathlib: ["Ordinal.limitRecOn", "Ordinal.opow_succ", "Ordinal.opow_limit", "Ordinal.opow_lt_opow_iff_right"]
provenance: {source_type: derived, ref: "Transfinite recursion characterization of ordinal exponentiation"}
---

# 动机

本库没有把 mathlib 的 `a ^ b` 直接当作定义，而是用零、后继和极限三个分支定义 `ordinalPow a b`。这样才能在教材中看见超限递归的真实结构。但 Goodstein 度量又需要使用 mathlib 里成熟的序数幂比较定理，因此必须先证明两种写法真的是同一个运算。

# 直觉

序数幂由指数的三种形态唯一确定：指数是零时结果为一；指数是后继 `succ b` 时，在 `a^b` 右边再乘一个 `a`；指数是极限时，取所有更小指数幂值的上确界。本库定义和 mathlib 定义在这三个分支逐项相同，所以超限归纳能把它们完整对齐。

# 陈述（自然语言）

对任意序数底数 `a` 和任意序数指数 `b`，本库的 `ordinalPow a b` 等于 mathlib 的序数幂 `a ^ b`。这包括底数为零的边界情况：`0^0=1`，而非零指数时 `0^b=0`。作为直接结果，当 `1<a` 时，`ordinalPow a b < ordinalPow a c` 当且仅当 `b<c`。

# 陈述（Lean 对照）

`ordinalPow_eq_opow a b` 是通用等式。`ordinalPow_lt_ordinalPow_iff ha` 在假设 `ha : 1<a` 下把幂值严格比较改写为指数比较。`omegaPow_lt_omegaPow_iff` 则把底数固定为 `Ordinal.omega0`，正好对应遗传底数表达式的 `omegaValue` 中的幂项。

# 思维脉络（thinking trace）

证明先单独处理底数为零的分支，因为极限递归式在这里有特别值。对非零底数，按指数使用 `Ordinal.limitRecOn`：零分支直接化简；后继分支用 `ordinalPow_succ` 和 `Ordinal.opow_succ`，并展开本库 `ordinalMul`；极限分支先用归纳假设逐点对齐上确界中的函数，再用 `Ordinal.opow_limit`。完成等式后，严格比较只是将 mathlib 的指数比较定理沿该等式运回本库接口。

# 自然语言 ↔ Lean 映射

“按指数做超限归纳”对应 `induction b using Ordinal.limitRecOn`；“本库序数幂”对应 `ordinalPow`；“mathlib 序数幂”对应 `a ^ b`；“极限处取前面所有值的上确界”对应 `Ordinal.opow_limit`；“底数大于一时指数决定幂值顺序”对应 `Ordinal.opow_lt_opow_iff_right` 转移后的 `ordinalPow_lt_ordinalPow_iff`。

# 依赖（人话版）

本条只依赖已有的本库序数幂定义及其零、后继、极限方程。mathlib 提供同样三个分支下的原生序数幂方程，以及底数大于一时的严格比较刻画。证明不重新定义加法、乘法或幂，也不把 mathlib 运算偷换成本库的公开定义。

# 应用与陷阱

后续 Goodstein 展开可以先证明两个遗传指数的 `omegaValue` 严格大小，再用 `omegaPow_lt_omegaPow_iff` 把不等式提升到对应的 Cantor 幂项，不必在每个业务文件里重写一遍超限归纳。但这条桥本身不证明幂项前的有限系数界，不证明整个 Cantor 和的比较，也不证明 Goodstein 步骤或终止。特别地，严格比较接口必须保留 `1<a` 假设；底数为零或一时，幂函数不会对指数严格递增。
