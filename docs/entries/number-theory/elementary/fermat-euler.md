---
id: number-theory.elementary.fermat-euler
kind: theorem
state: verified
title: "Euler 定理与 Fermat 小定理"
summary: 由互素剩余类的单位群阶推出 Euler 定理及 Fermat 小定理的两种形式
premises: ["number-theory.elementary.totient", "number-theory.elementary.congruence"]
mathlib: ["Nat.ModEq.pow_totient", "Nat.totient_prime", "Nat.Prime.coprime_iff_not_dvd", "Nat.modEq_zero_iff_dvd"]
provenance:
  source_type: book
  ref: "hardy-wright-number-theory-2008"
---

# 动机

Euler 定理描述可逆剩余类的统一幂周期；当模数是素数时，除零以外的剩余类都可逆，立即
得到 Fermat 小定理。保留这条推导链比孤立登记两个终点更能说明二者关系。

# 直觉

与 `n` 互素的 `a` 是有限单位群 `(ZMod n)ˣ` 的元素。有限群中元素的阶整除群阶
`φ(n)`，所以 `a^φ(n)=1`。素数 `p` 满足 `φ(p)=p-1`。

# 陈述（自然语言）

- 若 `gcd(a,n)=1`，则 `a^φ(n) ≡ 1 (mod n)`。
- 若素数 `p` 不整除 `a`，则 `a^(p-1) ≡ 1 (mod p)`。
- 对任意自然数 `a`，都有 `a^p ≡ a (mod p)`。

# 陈述（Lean 对照）

教材定义版本对应 `euler_theorem_congruent`，其结论使用 `Congruent` 与 `EulerTotient`。
兼容版本依次为 `euler_theorem`、`fermat_little_theorem_of_not_dvd` 和
`fermat_little_theorem`，继续使用 Mathlib 签名以避免破坏既有调用者。

# 思维脉络（thinking trace）

教材版本先用两条精确桥把定义还原为 Mathlib 的 Euler 定理。既约 Fermat 版本再把“不整除”
经素数互素判据转成 `a.Coprime p`，调用 Euler 定理后以
`φ(p)=p-1` 化简。无条件版本按 `p ∣ a` 分类：可整除时 `a` 与 `a^p` 都同余于零；否则将
既约版本两边乘 `a`，再用 `p-1+1=p` 整理指数。

# 自然语言 ↔ Lean 映射

- `by_cases hpa : p ∣ a` 对命题是否成立分情况。
- `euler_theorem_congruent` 是正文首选的教材签名。
- `have` 为中间数学事实命名。
- `.mul_right a` 把同余两边同时乘 `a`。
- `.trans` 连接两条首尾相接的同余关系。
- `simpa [...] using h` 用列出的恒等式把已有事实整理成目标的写法。

# 依赖（人话版）

`Nat.ModEq.pow_totient` 是 Euler 定理的 Mathlib 基础结果；`Nat.totient_prime` 计算素数的
φ 值；素数互素判据和零同余判据负责两个 Fermat 分支。

# 应用与陷阱

`a^(p-1) ≡ 1` 必须要求 `p ∤ a`；只有 `a^p ≡ a` 的版本对所有 `a` 无条件成立。
