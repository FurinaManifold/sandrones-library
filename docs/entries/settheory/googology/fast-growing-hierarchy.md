---
id: settheory.googology.fast-growing-hierarchy
kind: definition
state: verified
title: "快速增长层级：后继处迭代前一级函数"
premises: ["settheory.googology.fundamental-sequence-system"]
mathlib: []
provenance: {source_type: book, ref: "wainer-ordinal-recursive-1970"}
---

# 动机

Hardy 层级每过一个后继只把输入增加一次。快速增长层级把后继步加强为“反复调用前一级函数”，因而很快越过加法、乘法、幂等固定层级。为了使极限下标也可计算，它同样必须先固定基本列。

# 直觉

零层只是把 `n` 变成 `n+1`。若站在某一级的后继处，就取前一级函数，从 `n` 出发连续按它 `n+1` 次；若站在极限处，则让输入 `n` 自己选择第 `n` 个基本列下标。燃料限制允许向记号内部展开的深度，但不限制单次自然数迭代的次数。

# 陈述（自然语言）

燃料近似的规则为：`F⁽ᶠ⁺¹⁾_0(n)=n+1`；若 `a` 是 `b` 的后继，则 `F⁽ᶠ⁺¹⁾_a(n)` 等于函数 `x ↦ F⁽ᶠ⁾_b(x)` 从 `n` 开始迭代 `n+1` 次；若 `a` 是极限，则 `F⁽ᶠ⁺¹⁾_a(n)=F⁽ᶠ⁾_{a[n]}(n)`。零燃料时返回 `n`，表示不再展开。

# 陈述（Lean 对照）

辅助定义 `iterate f times n` 表示从 `n` 开始应用 `f` 共 `times` 次。`fastGrowingApprox` 对燃料递归并匹配记号类别；`fastGrowingApprox_rules` 精确汇总三个分支。后继等式中的函数显式写为 `fun x => fastGrowingApprox system fuel previous x`。

# 思维脉络（thinking trace）

先独立定义有限函数迭代，避免把“迭代 `n+1` 次”藏进不透明库函数。再复用基本列接口处理极限。由于完整的记号良基递归尚未建立，定义仍以燃料确保 Lean 可执行并诚实表示完成范围；本条证明的是计算规则，不是某两个层级最终支配关系。

# 自然语言 ↔ Lean 映射

`F_a(n)` 对应 `fastGrowingApprox system fuel a n`；零层后继函数对应 `.zero => n + 1`；“前一级”对应 `previous`；“迭代 `n+1` 次”对应 `iterate ... (n + 1) n`；极限下标 `a[n]` 对应 `sequence n`。这里只使用自然数加一与有限迭代。

# 依赖（人话版）

概念上依赖基本列系统和有限函数迭代。若要去掉燃料并获得经典快速增长层级，需要一套良基的序数记号以及可接受的基本列；若要声称它刻画原始递归函数、Ackermann 函数或证明支配关系，还需要额外的归纳与增长估计，本条均未提供。

# 应用与陷阱

该定义可作为后续比较有限超运算、Ackermann 型函数和序数索引增长率的计算接口。常见错误是把“函数迭代 `n+1` 次”误读成普通乘法或幂；另一个错误是看到名字便宣称达到 `ε₀`。当前接口接受任意记号类型，但没有构造覆盖 `ε₀` 的正规记号系统，也没有证明基本列共尾。
