---
id: settheory.googology.unbounded-halting-relation
kind: definition
state: verified
title: "无时间界停机关系与最终输出"
premises: ["settheory.googology.bounded-halting"]
mathlib: []
provenance: {source_type: book, ref: "pohlers-proof-theory-1989"}
---

# 动机

限定步数停机只回答“这台机器在给定的 `fuel` 步内是否已经停下”。经典 Busy Beaver 却要比较
所有最终会停机的机器，不能预先规定一个对所有机器都适用的时间上限。因此必须先把“最终停机”
写成独立的数学关系，再谈无时间界的最大输出。

# 直觉

“无时间界”不表示机器可以真的运行无限步，也不表示存在一个神奇的停机判定器。它只表示：
允许见证者自己给出某个有限自然数 `steps`，并证明机器运行这么多步后已经留下停机纸带。不同
机器可以有完全不同的见证步数，而且定义没有提供搜索何时一定结束的方法。

# 陈述（自然语言）

`EventuallyHalts machine` 表示存在步数和最终纸带，使机器从标准空白纸带运行该步数后处于停机
状态。`HasHaltingOnesScore machine score` 还要求该纸带恰有 `score` 个 `1`。机器最终停机，当且
仅当它拥有某个停机输出分数；在给定燃料内停机则必然最终停机。

# 陈述（Lean 对照）

```lean
def EventuallyHalts (machine : BinaryMachine (n + 1)) : Prop :=
  ∃ steps tape, haltedTape? (runSteps machine steps (blankStart machine)) = some tape
def HasHaltingOnesScore (machine : BinaryMachine (n + 1)) (score : ℕ) : Prop :=
  ∃ steps tape, haltedTape? (runSteps machine steps (blankStart machine)) = some tape ∧
    tape.card = score
theorem eventuallyHalts_iff_exists_score (machine) :
  EventuallyHalts machine ↔ ∃ score, HasHaltingOnesScore machine score
theorem haltsWithin_implies_eventuallyHalts (fuel) (machine) :
  HaltsWithin fuel machine → EventuallyHalts machine
```

# 思维脉络（thinking trace）

已有执行器 `runSteps` 对每个自然数步数都给出确定结果，停机状态在多跑若干步后也保持停机。
所以存在量化步数足以表达“迟早停机”。从停机纸带取 `card` 就得到输出分数；反过来，拥有分数
见证当然已经包含停机纸带见证。限定停机定理给出燃料时刻的纸带，把该燃料作为存在见证即可。

# 自然语言 ↔ Lean 映射

- “最终会停机” ↔ `EventuallyHalts machine`。
- “存在某个有限时刻” ↔ `∃ steps`。
- “停机后留下纸带” ↔ `haltedTape? (...) = some tape`。
- “纸带上有指定数量的 1” ↔ `tape.card = score`。
- “有限燃料内停机是充分条件” ↔ `haltsWithin_implies_eventuallyHalts`。

# 依赖（人话版）

依赖已有的二符号机器、标准空白起点、有限步执行器和限定停机关系。这里没有调用 mathlib 的
可计算性理论或停机问题定理；无界性完全由对自然数步数作存在量化表达。

# 应用与陷阱

该关系是定义经典 Busy Beaver 最大值的语义入口。最重要的陷阱是把“存在停机步数”误读为
“能够算法式找到停机步数”：存在命题本身没有提供判定过程。本条没有证明停机关系可判定或不可
判定，也没有证明任何不可计算性结论；后续条目不得把这些未证事实写进标题或正式结论。
