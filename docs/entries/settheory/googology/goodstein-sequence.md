---
id: settheory.googology.goodstein-sequence
kind: definition
state: verified
title: "Goodstein 带证书序列：把重编码单步串起来"
premises: ["settheory.googology.goodstein-reencoding"]
mathlib: []
provenance: {source_type: paper, ref: "goodstein-restricted-ordinal-1944"}
---

# 动机

单步关系只说明两个状态如何衔接。Goodstein 序列则要求这种衔接在每个自然数阶段都成立，从而把换底、减一和重编码组成一条完整轨迹。

# 直觉

把序列想成无限排列的状态卡。第 `n+1` 张卡必须是第 `n` 张卡的合法后继：它的底数大一，数值是上一张卡换底减一的结果，且自带新表示证书。

# 陈述（自然语言）

一个从自然数索引到带证书状态的函数称为带证书 Goodstein 序列，当且仅当对每个 `n`，第 `n` 项到第 `n+1` 项都构成一次 Goodstein 重编码单步。

# 陈述（Lean 对照）

`IsCertifiedGoodsteinSequence states := ∀ n, GoodsteinReencodingStep (states n) (states (n+1))`。`certifiedGoodsteinSequence_step` 将这个全称条件在指定 `n` 处实例化，同时展开单步关系的两个核心等式。

# 思维脉络（thinking trace）

先把状态的局部正确性封装在结构里，再把两项之间的动力学封装在迁移关系里，最后用全称量词要求每对相邻项都满足该关系。这种分层使“表示正确”与“时间演化正确”不会混在一起。

# 自然语言 ↔ Lean 映射

“第 `n` 项”对应 `states n`；“下一项”对应 `states (n+1)`；“所有相邻项”对应 `∀ n`；“底数递增”和“数值按 Goodstein 单步更新”分别是定理结论中的两个等式。

# 依赖（人话版）

本条只依赖上一条的重编码单步关系。它给出“什么样的轨迹算 Goodstein 轨迹”的精确规格，但尚未从任意初始数构造这样的轨迹。

# 应用与陷阱

这个谓词可作为后续存在性、唯一性和终止性定理的公共接口。然而“已定义一条序列应满足的规格”不等于“已证明序列存在”，更不等于“已证明序列终止”。
