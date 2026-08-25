---
id: settheory.googology.knuth-arrow
kind: definition
state: verified
title: "Knuth 上箭头：用符号数量提升运算等级"
premises: ["settheory.googology.hyperoperation"]
mathlib: ["Nat.hyperoperation"]
provenance: {source_type: paper, ref: "knuth-coping-finiteness-1976"}
---

# 动机

指数能压缩重复乘法，但完整幂塔仍会迅速写不下。上箭头记号把“迭代哪一级运算”压进箭头数量，使一个有限表达式能够精确指定极大的有限数。

# 直觉

一支箭头是幂，两支箭头把幂重复成右结合幂塔；再加箭头，就是反复执行前一种箭头运算。箭头不是装饰，而是自然数参数。

# 陈述（自然语言）

本库定义 `a ↑^r b` 为第 `r+2` 级超运算，因此一支箭头满足 `a ↑ b=a^b`。递推式为：拥有 `r+1` 支箭头且右参数加一的值，等于先算同样箭头数的前一步，再把结果送入 `r` 支箭头运算。

# 陈述（Lean 对照）

`knuthArrow a arrows b := hyperOperation (arrows + 2) a b` 明确固定等级偏移。`knuthArrow_one` 调用 `hyperOperation_first_levels` 的幂分量；`knuthArrow_succ_succ` 用 `simp only` 展开定义和超运算后继式。`Nat.hyperoperation` 只通过前条间接作为 Mathlib 对照。

# 思维脉络（thinking trace）

先选择“一箭头等于幂”的常用约定，于是超运算等级必须偏移二；再从超运算统一递推式推出箭头递推式；最后单独固定一箭头桥，方便后文在不展开内部定义的情况下推理。

# 自然语言 ↔ Lean 映射

底数对应 `a`，箭头数对应 `arrows`，迭代参数对应 `b`；符号 `↑^r` 在正文中对应函数 `knuthArrow a r b`；“一箭头是幂”对应 `knuthArrow_one`；“减少一支箭头处理前一步结果”对应 `knuthArrow_succ_succ` 的右侧嵌套。

# 依赖（人话版）

直接依赖本库超运算定义及其前四级定理。证明只需要自然数加法结合和定义化简，不依赖序数或无限基数。文献间零箭头约定可能不同，本库以 `arrows+2` 消除歧义。

# 应用与陷阱

两箭头的 `a ↑↑ 3` 是 `a^(a^a)`，幂塔必须右结合。Graham 序列将把前项用作箭头数量。所有参数有限时结果仍是有限自然数；无法打印十进制展开不等于无限，也不能忽略不同作者的下标约定。
