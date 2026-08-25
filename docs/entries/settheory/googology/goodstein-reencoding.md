---
id: settheory.googology.goodstein-reencoding
kind: definition
state: verified
title: "Goodstein 重编码单步：换底减一后补齐新证书"
premises: ["settheory.googology.goodstein-certified-state", "settheory.googology.goodstein-step"]
mathlib: []
provenance: {source_type: paper, ref: "goodstein-restricted-ordinal-1944"}
---

# 动机

原有 `goodsteinStep` 只返回一个自然数。要再走下一步，必须先把这个新数写成新底数下的遗传表达式。如果漏掉这次重编码，所定义的只是一次数值计算，而不是可迭代的 Goodstein 过程。

# 直觉

源状态告诉我们“用哪棵树换底”。先将该树改用 `b+1` 求值并减一，得到新数 `m`；然后目标状态提供另一棵在 `b+1` 下合法且求值为 `m` 的树。

# 陈述（自然语言）

带证书状态 `s` 到 `t` 构成一次 Goodstein 重编码单步，当且仅当 `t` 的底数是 `s` 的底数加一，并且 `t` 的数值等于对 `s` 的表达式执行换底减一所得的数值。

# 陈述（Lean 对照）

`GoodsteinReencodingStep s t` 是两个等式的合取。`goodsteinReencodingStep_specification` 还使用 `t.expression_evaluates`，推出目标表达式在新底数下的求值正是本步结果。

# 思维脉络（thinking trace）

单步定义不再试图从自然数凭空恢复表达式，而是把恢复结果放在目标状态中。目标状态的类型本身已经保证表达式合法且求值正确，所以迁移关系只需联系两个底数和两个数值。

# 自然语言 ↔ Lean 映射

“底数加一”对应 `t.base = s.base + 1`；“先换底后减一”对应 `goodsteinStep s.base s.expression`；“重编码正确”不是隐含假设，而是 `t.expression_evaluates` 字段。

# 依赖（人话版）

本条依赖带证书状态与已有的“换底减一”数值计算。它尚未提供一个可执行的正规化器，因而当前是关系式接口，不是对任意状态都能直接计算出目标的函数。

# 应用与陷阱

该关系可以精确检查一个候选后继状态是否正确。关键陷阱是把“目标状态携带证书”误读为“库已证明这种证书总能自动构造”。后者仍需自然数的遗传正规化算法及其正确性。
