---
id: settheory.ordinal.cantor-normal-form
kind: theorem
state: verified
title: "Cantor 正规形"
premises: ["settheory.ordinal.exponentiation"]
mathlib: ["Ordinal.CNF.foldr"]
provenance: {source_type: book, ref: "jech-set-theory-2003"}
---

# 动机
Cantor 正规形为序数提供以 `ω` 为底的标准展开，也是 ε₀ 以下序数记号的基础。

# 直觉
正规形是一列指数递减的“幂 × 系数”；从右向左求值应还原原序数。

# 陈述（自然语言）
对任意底数 `b` 和序数 `o`，使用本库 `ordinalPow`、`ordinalMul`、`ordinalAdd`
求值 `CNF b o` 得到 `o`。

# 陈述（Lean 对照）
`cantorNormalForm_reconstructs (b o)`。

# 思维脉络（thinking trace）
沿正规形列表右折叠，每项执行 `b^e·c+r`；mathlib 的构造保证该折叠与除法余数分解互逆。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| Cantor 正规形 | `Ordinal.CNF b o` |
| 求值 | `List.foldr (fun p r ↦ ordinalAdd (ordinalMul (ordinalPow b p.1) p.2) r) 0` |

# 依赖（人话版）
展开项使用序数幂、乘法与加法。

# 像十进制，但位值是序数幂

十进制把自然数写成 `10^k·c_k+⋯+10^0·c_0`。Cantor 正规形类似，只是经典底数取 `ω`，
指数本身也可以是序数：

`ω^{β₁}·c₁ + ω^{β₂}·c₂ + ⋯ + ω^{βₙ}·cₙ`，其中
`β₁>β₂>⋯>βₙ`，系数是正的有限序数。

例如 `ω·3+5`、`ω²+ω·4+7` 都是正规形；`ω^ω` 也合法，其指数已经是无限序数。

# 为什么指数必须递减

序数加法不交换，低阶项放在高阶项左边可能被吸收，例如 `1+ω=ω`。高阶项先出现、低阶修正项
后出现，才能得到稳定的标准表示。

# 本条证明的重建性质

`Ordinal.CNF b o` 返回 `(指数, 系数)` 列表。本库逐项调用 `ordinalPow`、`ordinalMul`、
`ordinalAdd` 从右向左重建。定理证明重建值恰为 `o`，把数据表示与前面建立的教材运算接起来。

# 应用与陷阱
- 经典 Cantor 正规形取 `b=ω`；定理保留 mathlib 更一般的底数接口。
- 指数递减而非递增；非交换性使项的顺序不能随意调整。
- 列表有限，但指数可继续包含自己的 CNF，所以仍能表达很大的可数序数。
