---
id: settheory.googology.graham-number
kind: definition
state: verified
title: "Graham 数：让前一项决定下一步的箭头数量"
premises: ["settheory.googology.knuth-arrow"]
mathlib: []
provenance: {source_type: book, ref: "Ronald Graham, Bruce Rothschild, Joel Spencer, Ramsey Theory"}
---

# 动机

固定四支箭头已经产生难以想象的数。Graham 数进一步让前一阶段的巨大结果成为下一阶段的箭头数量，展示有限递归如何精确命名远超可展开范围的数。

# 直觉

起点是 `3 ↑↑↑↑ 3`。若当前项为 `g`，下一项不是把 `g` 当指数或塔高，而是形成 `3 ↑^g 3`；运算等级本身被前项抬高。这个更新有限地进行 64 个阶段。

# 陈述（自然语言）

本库零编号：`G₀=knuthArrow(3,4,3)`，`G_(n+1)=knuthArrow(3,G_n,3)`，并定义 Graham 数为 `G₆₃`。从 0 到 63 恰有 64 项，对应文献常写的 `g₁` 到 `g₆₄`。

# 陈述（Lean 对照）

`grahamSequence` 用自然数递归给出初项和后继项，`grahamNumber` 定义为 `grahamSequence 63`。`grahamSequence_equations` 的两个 `rfl` 暴露计算方程；`grahamNumber_is_64th_stage` 也是定义等式。这里没有调用 Mathlib 的现成 Graham 数。

# 思维脉络（thinking trace）

先以已固定语义的 `knuthArrow` 表示每阶段；再选择适合 Lean 的零编号并明确与传统编号的换算；最后以定理锁定 64 阶段接口，防止后续使用者把 `63` 误判为只有 63 项。

# 自然语言 ↔ Lean 映射

“初始四箭头”对应 `knuthArrow 3 4 3`；“前项成为箭头数”对应 `knuthArrow 3 (grahamSequence n) 3`；“第 64 项”在零编号中对应 `grahamSequence 63`；`rfl` 说明这些是公开定义的直接展开，而非数值计算。

# 依赖（人话版）

只依赖 Knuth 上箭头和自然数有限递归。定义不需要展开任何巨大结果，也不依赖无限集合。其历史背景来自 Ramsey 理论，但当前条目只形式化数的定义与阶段方程，没有形式化原组合上界。

# 应用与陷阱

它说明“精确定义”不等于“能够写出所有数字”。64 是阶段数，不是最终箭头数；后期箭头数本身就是前项。Graham 数仍可计算且有限，不是 `ℵ₀`，也不能据其知名度断言它大于 TREE(3) 或 Busy Beaver 的适当取值。
