---
id: settheory.googology.hereditary-natural-encoding-same-block-order
kind: theorem
state: verified
title: "修正遗传编码的同商块严格保序"
premises: ["settheory.googology.hereditary-natural-encoding"]
mathlib: ["add_lt_add_iff_left", "Nat.div_add_mod"]
provenance: {source_type: derived, ref: "Ordinal order of corrected Horner encoding"}
---

# 动机

原商余编码把递归商放在底数幂左边，自然数求值正确，但序数解释会把不同有限商压成同一个 `ω`。由于该模块尚未进入 main，本批直接将原编码修正为“底数幂乘递归商”，避免长期保留两套同义公开编码。

# 直觉

修正后的序数方程是 `R(n)=ω·R(n/base)+n%base`。固定商时，前面的 `ω·R` 完全相同，所以两个数的次序只由最后的有限余数决定。这正是普通进位制中“高位相同则比较本位”的序数版本。

# 陈述（自然语言）

对固定底数 `base≥2`，修正编码的 `omegaValue` 精确等于 `ω` 乘以商的递归序数值，再加余数。若 `n<m` 且 `n/base=m/base`，则 `n%base<m%base`，因而 `n` 的编码序数值严格小于 `m` 的编码序数值。

# 陈述（Lean 对照）

`hereditaryNatEncode_omega_equation` 给出精确递推式。`hereditaryNatEncode_omega_lt_of_div_eq` 接收 `n<m` 和商相等证明，用 `Nat.div_add_mod` 推出余数严格不等式，然后用序数加法对右参数的严格单调性完成比较。

# 思维脉络（thinking trace）

首先在未进入 main 的阶段迁移原定义，把 `.mul encodeQuotient basePower` 改为 `.mul basePower encodeQuotient`，并重跑原有 `Valid/eval` 强归纳证明。然后展开 `omegaValue`，用本库的序数乘法、幂和加法接口还原精确方程。同商情形下，商余恒等式直接将自然数严格比较转化为余数严格比较。

# 自然语言 ↔ Lean 映射

“底数幂在左”对应 `.mul (.basePow (.digit 1)) recursiveQuotient`；“商的递归序数”对应 `(hereditaryNatEncode ... (n/base)).omegaValue`；“同商块”对应 `hdiv`；“余数严格增大”对应 `hmod`；“加上相同前缀保持严格比较”对应 `add_lt_add_iff_left`。

# 依赖（人话版）

本条直接依赖已迁移的商余遗传编码和本库序数运算定义。mathlib 在证明后端提供商余还原恒等式与序数加法的右参数严格单调性。

# 应用与陷阱

本条已消除已知不适合序数解释的旧乘法方向，也不再保留重复的 `orderedHereditaryNatEncode`。它提供精确序数方程与同商块严格保序；下一条在此基础上完成商增大时的 `ω` 块分离，并闭合全局严格单调。但次序定理本身仍不等于已完成一般 Goodstein 借位或终止证明。
