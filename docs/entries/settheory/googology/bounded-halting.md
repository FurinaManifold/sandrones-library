---
id: settheory.googology.bounded-halting
kind: definition
state: verified
title: "限定步数停机"
premises: ["settheory.googology.machine-execution"]
mathlib: []
provenance: {source_type: textbook, ref: "Computability theory: bounded simulation"}
---

# 动机

一般停机问题问“机器最终会不会停”，没有预先给出搜索终点。限定步数问题则只问一个有限实验：
给定 `fuel`，跑完这些步后是否已经停机。二者逻辑强度完全不同，Busy Beaver 的可执行近似必须
建立在后者上。

# 直觉

把燃料想成秒表：只允许机器走有限步。若这期间看到停机指令，就回答“是”；燃料耗尽仍在运行，
就回答“在这个界内没有停”，而不是断言它永远不会停。增加燃料可能改变后一个答案。

# 陈述（自然语言）

对至少一个工作状态的机器，从状态零、原点和空白纸带开始运行 `fuel` 步。最终状态为 `halted`
时定义 `HaltsWithin fuel machine` 成立，为 `running` 时不成立。它等价于存在一张最终纸带，使多步
执行经 `haltedTape?` 提取后恰好得到该纸带。

# 陈述（Lean 对照）

```lean
def blankStart (machine : BinaryMachine (n + 1)) : ExecutionStatus (n + 1)
def HaltsWithin (fuel : ℕ) (machine : BinaryMachine (n + 1)) : Prop
def haltedTape? : ExecutionStatus n → Option (Finset ℤ)
theorem haltsWithin_iff_exists_tape (fuel) (machine) :
  HaltsWithin fuel machine ↔
    ∃ tape, haltedTape? (runSteps machine fuel (blankStart machine)) = some tape
```

# 思维脉络（thinking trace）

先用 `n+1` 保证状态零确实存在，再构造唯一的标准起点。运行有限次后直接对结果分两种构造：
`running` 分支为假，`halted` 分支为真。等价定理表明这个布尔式分支判定确实对应“提取到某张
最终纸带”，而不是与运行语义脱节的标签。

# 自然语言 ↔ Lean 映射

- “至少一个工作状态” ↔ 状态类型 `Fin (n + 1)`。
- “状态零、原点、空白带” ↔ `blankStart machine`。
- “给定有限燃料” ↔ `runSteps machine fuel ...`。
- “界内已经停机” ↔ `HaltsWithin fuel machine`。
- “取得最终纸带” ↔ `haltedTape? status = some tape`。
- “燃料耗尽仍运行” ↔ `ExecutionStatus.running _`，只否定当前界内停机。

# 依赖（人话版）

依赖上一条的标准执行器，以及机器模型中可用的零号初始状态。证明只是对有限运行结果分类，不依赖
一般停机问题的任何结论，也没有假设机器在未来必停或永不停。

# 应用与陷阱

限定停机可以用于测试、模型检查和逐步扩大搜索界。最重要的陷阱是量词偷换：
`¬ HaltsWithin fuel machine` 只表示前 `fuel` 步没停，绝不推出机器永不停止。本条也没有证明一般
停机谓词可判定；它刻意只提供每个固定有限界下的可执行问题。
