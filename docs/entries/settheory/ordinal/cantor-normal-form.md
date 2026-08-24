---
id: settheory.ordinal.cantor-normal-form
kind: theorem
state: verified
title: "Cantor 正规形"
premises: ["settheory.ordinal.exponentiation"]
mathlib: ["Ordinal.CNF.foldr"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 2: Cantor Normal Form"}
---

# 动机
Cantor 正规形为序数提供以 `ω` 为底的标准展开，也是 ε₀ 以下序数记号的基础。

# 直觉
正规形是一列指数递减的“幂 × 系数”；从右向左求值应还原原序数。

# 陈述（自然语言）
对任意底数 `b` 和序数 `o`，求值 `CNF b o` 得到 `o`。

# 陈述（Lean 对照）
`cantorNormalForm_reconstructs (b o)`。

# 思维脉络（thinking trace）
沿正规形列表右折叠，每项执行 `b^e·c+r`；mathlib 的构造保证该折叠与除法余数分解互逆。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| Cantor 正规形 | `Ordinal.CNF b o` |
| 求值 | `List.foldr (fun p r ↦ b ^ p.1 * p.2 + r) 0` |

# 依赖（人话版）
展开项使用序数幂、乘法与加法。

# 应用与陷阱
经典 Cantor 正规形取 `b=ω`；定理保留 mathlib 更一般的底数接口。
