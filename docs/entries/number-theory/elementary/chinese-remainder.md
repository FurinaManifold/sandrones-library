---
id: number-theory.elementary.chinese-remainder
kind: theorem
state: verified
title: "中国剩余定理"
summary: 互素模数下联立同余方程有解，并给出 ZMod(mn) 与 ZMod(m)×ZMod(n) 的环同构
premises: ["number-theory.elementary.congruence"]
mathlib: ["Nat.chineseRemainder", "ZMod.chineseRemainder"]
provenance:
  source_type: book
  ref: "Hardy and Wright, An Introduction to the Theory of Numbers（中国剩余定理）"
---

# 动机

中国剩余定理把两个互素模数下的局部信息合成为模乘积的全局信息。课程中既需要“方程组
存在共同解”的可计算语言，也需要“剩余环分解成直积”的结构语言。

# 直觉

模数互素意味着一个模数在另一个模数下可逆，因此可制造分别在一个模数下为 `1`、另一个
模数下为 `0` 的权重，再用它们拼出指定的两个余数。

# 陈述（自然语言）

若 `m,n` 互素，则任意 `a,b` 存在自然数 `x`，使 `x ≡ a (mod m)` 且
`x ≡ b (mod n)`；更强地，`ZMod (mn)` 与 `ZMod m × ZMod n` 环同构。

# 陈述（Lean 对照）

- `chinese_remainder_exists` 返回共同解及两项同余证明。
- `chineseRemainderEquiv` 返回保持加法、乘法和单位元的 `RingEquiv`。

# 思维脉络（thinking trace）

存在形式投影 `Nat.chineseRemainder` 返回的子类型元素及其 `.property`。结构形式直接保留
Mathlib 的环同构，因为这比仅有双射更准确，并可供后续单位群和乘法函数结果使用。

# 自然语言 ↔ Lean 映射

- `m.Coprime n` 表示 `gcd(m,n)=1`。
- `∃ x, ... ∧ ...` 是共同解及两个约束。
- `{k // P k}` 是携带性质证明的子类型；强制转换取出 `k`，`.property` 取出证明。
- `≃+*` 表示环同构。
- `noncomputable def` 表示接口的逆映射依赖经典选择，不影响定理的逻辑内容。

# 依赖（人话版）

本条目建立在同余和 `ZMod` 的桥上；Mathlib 的 `Nat.chineseRemainder` 给出具体共同解，
`ZMod.chineseRemainder` 给出完整环同构。

# 应用与陷阱

互素条件不可省略。非互素模数仍可能有解，但需要两个指定余数在最大公因数模下相容，
那是广义中国剩余定理，不是本条目的陈述。
