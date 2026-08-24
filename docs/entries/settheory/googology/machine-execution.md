---
id: settheory.googology.machine-execution
kind: definition
state: verified
title: "有限状态机的单步与多步执行"
premises: ["settheory.googology.binary-machine"]
mathlib: []
provenance: {source_type: book, ref: "Tibor Rado, On Non-Computable Functions, 1962"}
---

# 动机

仅有指令表还不能回答机器做了什么；必须明确一次执行的先后顺序，并说明已经停机后再给更多步数
会怎样。这个执行器是限定步数停机和 Busy Beaver 有限搜索共同依赖的语义基础。

# 直觉

每一步像照着卡片办事：先看脚下是 `0` 还是 `1`，查表，再覆盖这个格子，然后决定停机或进入
下一状态。若继续运行，读写头按卡片向左或向右移动。给机器一个自然数“燃料”，就是最多按这种
规则执行那么多次；机器提前停机后，剩余燃料不会让纸带继续变化。

# 陈述（自然语言）

`executeStep` 对运行配置执行一条指令，对停机结果保持不变。`runSteps machine k status` 递归执行
恰好 `k` 次上述转换。零步返回原状态；`k+1` 步等于先执行一步，再从所得状态执行 `k` 步。

# 陈述（Lean 对照）

```lean
inductive ExecutionStatus (n : ℕ) where
  | running (config : Configuration n)
  | halted (ones : Finset ℤ)
def executeStep (machine : BinaryMachine n) : ExecutionStatus n → ExecutionStatus n
def runSteps (machine : BinaryMachine n) : ℕ → ExecutionStatus n → ExecutionStatus n
theorem runSteps_zero_succ (machine) (status) (steps) :
  runSteps machine 0 status = status ∧
  runSteps machine (steps + 1) status =
    runSteps machine steps (executeStep machine status)
```

# 思维脉络（thinking trace）

用 `ExecutionStatus` 区分“仍在跑的配置”和“停机后的最终纸带”，避免拿某个普通工作状态冒充
停机。单步函数先读取旧纸带，再算出覆写后的 `newOnes`；无论指令是否停机，最后一次写入都生效。
多步执行只对单步函数作自然数递归，因此是可约简、可测试的程序。

# 自然语言 ↔ Lean 映射

- “还在运行” ↔ `ExecutionStatus.running config`。
- “已经停机” ↔ `ExecutionStatus.halted ones`。
- “读当前格” ↔ `readSymbol config`。
- “覆盖写入” ↔ `writeSymbol config instruction.writeOne`。
- “向左右移动” ↔ `moveHead`。
- “执行有限多步” ↔ `runSteps machine steps status`。

# 依赖（人话版）

依赖上一条定义的机器、指令和配置。执行规则由本库用模式匹配和自然数递归直接写出，没有调用
mathlib 的图灵机模拟器，也没有借助选择公理或不可执行的存在性定义。

# 应用与陷阱

该执行器可以用来计算具体小机器的轨迹。需要注意本库约定“写入后再停机”，而读写头只有在继续
运行时的新配置中才有意义。`runSteps` 的参数是转换次数，不是访问过的配置数量；初始配置本身
对应零步，手工核对轨迹时容易出现差一错误。
