---
id: settheory.googology.hardy-hierarchy
kind: definition
state: verified
title: "Hardy 层级：沿记号下降，把后继变成输入递增"
premises: ["settheory.googology.fundamental-sequence-system"]
mathlib: []
provenance: {source_type: book, ref: "S. S. Wainer, A Classification of the Ordinal Recursive Functions"}
---

# 动机

普通迭代只告诉我们“把同一个函数做多少次”。Hardy 层级把迭代方案本身放到序数式记号上：零层什么也不做，后继层先把输入增加一，极限层则由输入决定沿基本列落到哪一级。这给快速增长函数提供了一种系统的索引语言。

# 直觉

计算 `H_a(n)` 像拿着数 `n` 沿记号 `a` 下楼。遇到后继，就把手里的数加一并走到前项；遇到极限，就用当前数 `n` 选择基本列的第 `n` 项；到零便交出手里的数。当前实现另给一箱有限燃料，每走一层消耗一格，耗尽便停止。

# 陈述（自然语言）

燃料近似满足三条规则：零记号处 `H⁽ᶠ⁺¹⁾_0(n)=n`；若 `a` 是 `b` 的后继，则 `H⁽ᶠ⁺¹⁾_a(n)=H⁽ᶠ⁾_b(n+1)`；若 `a` 是极限且基本列为 `a[k]`，则 `H⁽ᶠ⁺¹⁾_a(n)=H⁽ᶠ⁾_{a[n]}(n)`。燃料为零时，对任何记号都返回当前输入。

# 陈述（Lean 对照）

`hardyApprox system fuel a n` 对 `fuel` 做结构递归，再匹配 `system.stage a`。公开定理 `hardyApprox_rules` 同时给出零、后继、极限三个等式；每条等式都要求相应的 `stage` 等式，从而不会把一个未分类记号擅自当作后继或极限。

# 思维脉络（thinking trace）

经典公式先提示三种分支，但直接按任意记号递归不能让 Lean 看出终止。与其偷偷借用未说明的序数递归，本条把可执行深度显式化为自然数燃料。这样三条教材规则能够逐层计算，接口的不足也清晰暴露：它目前是近似器，不是已经证明与经典全域 Hardy 函数相等的对象。

# 自然语言 ↔ Lean 映射

教材下标 `a` 对应参数 `a : ι`；上标燃料对应 `fuel`；`a=b+1` 的角色由 `.successor previous` 表示，而不是调用序数加法；`a[n]` 对应 `.limit sequence` 分支中的 `sequence n`；“输入加一”就是自然数 `n + 1`。

# 依赖（人话版）

本条依赖前一条基本列接口来识别三类记号。计算等式本身不需要系统合法性，因为它们描述定义怎样展开；要把这些计算解释成沿严格较小记号下降，则需另外持有 `system.Legal`。它尚不依赖 `ε₀` 记号、良基递归或增长率比较定理。

# 应用与陷阱

它可用于演示某个已给记号系统中的有限层展开，也为快速增长层级说明“极限取基本列”的共同机制。不要省略燃料上标后声称已得到经典 `H_a`：燃料不足时计算会提前返回。不同教材也可能采用 `H_0(n)=n` 或略有平移的约定，比较数值前必须核对零层和后继规则。
