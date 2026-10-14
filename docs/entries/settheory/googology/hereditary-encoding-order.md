---
id: settheory.googology.hereditary-encoding-order
kind: theorem
state: verified
title: "一般换底重编码保持 omegaValue"
premises: ["settheory.googology.canonical-goodstein-state", "settheory.googology.hereditary-natural-encoding", "settheory.googology.hereditary-natural-encoding-same-block-order"]
mathlib: ["Nat.mul_add_div", "Nat.mul_add_mod", "Nat.div_eq_of_lt", "Nat.mod_eq_of_lt"]
provenance: {source_type: book, ref: "pohlers-proof-theory-1989"}
---

# 动机

规范 Goodstein 状态已经把表达式固定成编码器的输出，但它的下降定理仍带一个前提 `CanonicalBaseChangeOmegaCompatible`。这条前提是一个很具体的义务：把旧规范树放到新底数下重新读取数值、再在新底数下重新编码之后，序数度量会不会变？只要它还停在假设位置，规范状态的下降就只是条件性的。本条把这条义务一般地证明掉：不限定旧底数与具体数值，只要求新底数不低于旧底数。

# 直觉

遗传编码的 `omegaValue` 满足 `R(n)=ω·R(n/base)+n%base`：商贡献一个 `ω` 块，余数是块内的有限尾巴。把同一棵树放到更大的底数 `c` 下求值，得到的自然数可以写成 `c·Q+r`，其中 `Q` 正是「商的编码在 `c` 下的求值」，而 `r` 仍是原来的余数 `n%b`——因为 `r<b≤c`，它在新底数下依然只是一位数字。于是用 `c` 重新编码时，商余方程读出的商恰好是 `Q`、余数恰好是 `r`，与 `b` 侧的方程逐项对齐；对商做强归纳，两边就完全一致。

# 陈述（自然语言）

设 `b,c` 是自然数，`2≤b≤c`，`n` 是任意自然数。把 `n` 在底数 `b` 下的规范遗传编码记作 `E`。先把 `E` 中所有底数位置换成 `c` 求值，得到自然数 `E(c)`；再在底数 `c` 下规范编码 `E(c)`，得到 `E'`。则 `E'` 的序数解释（把每个底数位置换成 `ω`）与 `E` 的序数解释完全相同。特别地，对任意规范 Goodstein 状态 `s`，取 `b=s.base`、`c=s.base+1`、`n=s.value`，即得 `CanonicalBaseChangeOmegaCompatible s` 无条件成立。

# 陈述（Lean 对照）

主定理 `hereditaryNatEncode_baseChange_omegaValue` 在 `{b c : ℕ} (hb : 2 ≤ b) (hbc : b ≤ c) (n : ℕ)` 下断言

```lean
(hereditaryNatEncode c (le_trans hb hbc) ((hereditaryNatEncode b hb n).eval c)).omegaValue =
  (hereditaryNatEncode b hb n).omegaValue
```

推论 `canonicalBaseChangeReencoding_preserves` 断言 `(s : CanonicalGoodsteinState) → CanonicalBaseChangeOmegaCompatible s`；后者的定义在 `CanonicalGoodsteinState.lean` 中，展开即 `s.baseChangeReencodingMeasure = s.ordinalMeasure`。文件内另有两条 `private` 商余引理 `div_mul_add_div_eq`、`div_mul_add_mod_eq` 供主证明使用，不进入公开接口。

# 思维脉络（thinking trace）

1. 先分清「换底求值」和「重新编码」两步，认出两侧共用同一条商余方程 `hereditaryNatEncode_omega_equation`，因此只需要把 `c` 侧的商和余认出来。
2. 关键一步是把新底数下的求值写成 `c*Q+r`：`hereditaryNatEncode_of_pos` 把编码展开成 `(B^1)·编码(n/b)+数字(n%b)`，在 `c` 下求值恰好是 `c*Q+r`（`pow_one`）。
3. 余数必须仍是同一位数字，否则商余方程对不上：`n%b < b ≤ c`，于是 `(c*Q+r)/c=Q`、`(c*Q+r)%c=r`。这两条由 `Nat.mul_add_div` 配 `Nat.div_eq_of_lt`、`Nat.mul_add_mod` 配 `Nat.mod_eq_of_lt` 完成。
4. 商严格变小（`n>0` 且 `b≥2` 给出 `n/b<n`），于是强归纳假设正好把 `Q` 那一项换回旧编码的商项，两边闭合。
5. 推论不重新做数学：把主定理在 `b:=s.base`、`c:=s.base+1` 处实例化，再展开 `CanonicalBaseChangeOmegaCompatible`、`baseChangeReencodingMeasure`、`ordinalMeasure`、`expression` 四个定义即可。

# 自然语言 ↔ Lean 映射

- 「规范遗传编码」→ `hereditaryNatEncode b hb n`
- 「换底求值」→ `(hereditaryNatEncode b hb n).eval c`
- 「在新底数下重新编码」→ `hereditaryNatEncode c (le_trans hb hbc) (…)`
- 「把每个底数位置换成 `ω`」→ `HereditaryBaseExpr.omegaValue`
- 「商余方程」→ `hereditaryNatEncode_omega_equation`
- 「余数在新底数下仍是一位数字」→ `n % b < c`（`Nat.mod_lt` 与 `hbc`）
- 「商变小」→ `Nat.div_lt_self`；「归纳假设」→ `ih (n / b) hdiv_lt`
- 「命名义务」→ `CanonicalBaseChangeOmegaCompatible`；「两个度量」→ `baseChangeReencodingMeasure` 与 `ordinalMeasure`

# 依赖（人话版）

本条站在三条既有 Entry 上。`settheory.googology.hereditary-natural-encoding` 提供编码器本身与正数展开式 `hereditaryNatEncode_of_pos`；`settheory.googology.hereditary-natural-encoding-same-block-order` 提供精确的 `ω·商+余` 方程；`settheory.googology.canonical-goodstein-state` 提供 `CanonicalGoodsteinState`、两个度量以及被命名的兼容义务。mathlib 只贡献自然数商余的机械引理（`Nat.mul_add_div`、`Nat.mul_add_mod`、`Nat.div_eq_of_lt`、`Nat.mod_eq_of_lt`），序数一侧完全沿用本库既有的 `omegaValue` 与 `ordinalAdd/Mul/Pow`。

# 应用与陷阱

应用：这是把 `CanonicalBaseChangeOmegaCompatible` 从「命名义务」升级为「已证定理」的那一步。此后 `canonicalGoodsteinStep_omega_lt_of_compatible` 的兼容性前提可以在任意规范状态上直接消去，规范状态的序数下降不再需要额外假设。

陷阱（诚实边界）：本条**只**证明换底重编码保持 `omegaValue`。它**不**证明无条件的 Goodstein 单步下降（`canonicalGoodsteinStep_omega_lt`），因为那还需要正的新数值与减一的严格性；更**不**声称完整 Goodstein 序列终止，也不涉及 PA 不可证性。同时注意定理要求新底数不低于旧底数（`b≤c`），不是任意换底；把这条桥读成终止定理是过度解读。
