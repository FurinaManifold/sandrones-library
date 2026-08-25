---
id: settheory.googology.goodstein-step
kind: definition
state: verified
title: "Goodstein 单步：遗传换底之后减一"
premises: ["settheory.googology.hereditary-base"]
mathlib: []
provenance: {source_type: paper, ref: "goodstein-restricted-ordinal-1944"}
---

# 动机

Goodstein 过程最容易被一句“换底再减一”掩盖细节：换底必须深入所有指数，而且两项操作顺序不可交换。本条先把单步变换定义清楚，不越级声称整条序列终止。

# 直觉

保持遗传表达式树不变，把树里所有“当前底数”统一从 `b` 解释为 `b+1`，得到一个通常大得多的自然数，最后减一。增长来自重新解释整棵树，而不是局部替换外层符号。

# 陈述（自然语言）

对底数 `b` 和遗传表达式 `e`，Goodstein 单步等于 `e` 在新底数 `b+1` 下的值减一。以 `4` 的遗传二进制表达式 `B^(B^1)` 为例，换到三进制得到 27，减一后得到 26。

# 陈述（Lean 对照）

`hereditaryBaseChangeValue newBase expr := expr.eval newBase` 是换底求值；`goodsteinStep base expr := ... (base+1) expr - 1` 固定操作顺序。`goodsteinStep_four_base_two` 用 `decide` 验证具体闭命题；这是可判定有限计算，不是 Goodstein 终止定理。

# 思维脉络（thinking trace）

先复用上一条的“语法不变、解释改变”设计，避免另写易错的树替换；再把升底与减一组合成单步；最后用 4→26 的标准例子校验深层换底和操作顺序。完整迭代所需的重新编码暂不混入本条。

# 自然语言 ↔ Lean 映射

“统一换底”对应 `hereditaryBaseChangeValue` 调用 `eval newBase`；“底数提高一”对应 `base + 1`；“最后减一”对应自然数截断减法 `- 1`；例子中的树由两层 `.basePow` 构造；`decide` 只是关闭该具体等式的证明后端。

# 依赖（人话版）

直接依赖遗传表达式和求值。当前没有任意自然数到当前底数遗传正规形的编码、一步后重新编码、序数解释或严格下降证明，因此也没有定义完整的规范 Goodstein 序列。

# 应用与陷阱

本条可用于检验具体单步和为后续状态机提供核心变换。必须先换底再减一，且换底深入指数。自然数值可能上升，当前条目没有证明终止；“以 `ω` 解释后序数下降”只是后续证明路线，需正规编码和小于 `ε₀` 的下降桥。`Nat` 中零减一截断为零，也应与规范正项步骤区分。
