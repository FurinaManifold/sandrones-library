---
id: number-theory.elementary.congruence
kind: theorem
state: verified
title: "同余运算与剩余环"
premises: ["number-theory.elementary.divisibility"]
mathlib: ["ZMod.natCast_eq_natCast_iff", "Nat.ModEq.add", "Nat.ModEq.mul", "Nat.ModEq.pow"]
provenance:
  source_type: book
  ref: "Hardy and Wright, An Introduction to the Theory of Numbers（同余）"
---

# 动机

同余既可理解为“除以同一模数所得余数相同”，也可理解为剩余环中的相等。后一种观点使
普通的环运算自动变成合法的模运算，是从初等数论进入代数结构的桥梁。

# 直觉

把自然数 `a` 映入 `ZMod n`，就是忘掉它相差多少个 `n`。因此 `a ≡ b (mod n)` 恰好表示
两个像相等；相等可在等式两边同时做加法、乘法和乘方，于是同余也保持这些运算。

# 陈述（自然语言）

两个自然数模 `n` 同余当且仅当它们在 `ZMod n` 中相等；两组同余可逐项相加、相乘，
同一组同余还可同时取任意自然数次幂。

# 陈述（Lean 对照）

- `modEq_iff_zmod_eq`：`Nat.ModEq` 与 `ZMod` 相等之间的双向桥。
- `modEq_add_mul_pow`：一次返回加法、乘法和乘方三种闭包性质。

# 思维脉络（thinking trace）

第一条把 Mathlib 原有等价的方向翻转成“同余在左、剩余环相等在右”的课程顺序。第二条
不重新展开整除定义，而是组合 `Nat.ModEq` 已证明的三个运算闭包，从而突出结构而非算术细节。

# 自然语言 ↔ Lean 映射

- `a ≡ b [MOD n]` 是 Lean 对自然数模同余的专用记号。
- `(a : ZMod n)` 把自然数强制转换为模 `n` 的剩余类。
- `.symm` 翻转等价命题或同余关系的方向。
- `⟨hab.add hcd, hab.mul hcd, hab.pow k⟩` 构造三个结论组成的合取。

# 依赖（人话版）

`Mathlib.Data.ZMod.Basic` 定义剩余环及自然数到剩余环的映射；自然数同余的加、乘、幂接口
由 `Nat.ModEq` 提供。

# 应用与陷阱

`ZMod 0` 在 Mathlib 中有统一定义，因此相等桥不要求 `n > 0`；但涉及“余数范围”或有限
单位群计数时通常仍需排除零模数。
