---
id: settheory.googology.busy-beaver-candidate
kind: definition
state: verified
title: "限定步数的 Busy Beaver 候选最大值"
premises: ["settheory.googology.bounded-halting"]
mathlib: ["Finset.sup"]
provenance: {source_type: book, ref: "Tibor Rado, On Non-Computable Functions, 1962"}
---

# 动机

经典 Busy Beaver 在所有最终停机的固定状态数机器中取最大输出，但“最终停机”没有统一的有限
搜索界。为了得到真正能执行的第一层对象，本条同时固定状态数和燃料，只在有限张指令表上比较
有限次模拟结果。

# 直觉

把所有 `n+1` 状态、二符号机器排成一张有限名单，每台从空白纸带跑 `fuel` 步。停下来的机器按
最终纸带有多少个 `1` 计分，尚未停的暂记零分，最后取最高分。燃料增大时，先前来不及停机的
机器可能贡献新分数，所以这是逐步逼近经典问题的候选值。

# 陈述（自然语言）

`boundedOnesScore fuel machine` 在机器于给定步数内停机时返回最终有限纸带上 `1` 的个数，否则
返回零。`busyBeaverCandidate n fuel` 穷举所有 `n+1` 状态机器并取这些分数的上确界；由于机器集
有限且分数为自然数，这就是最大值。每一台机器的限定分数不超过该候选值。

# 陈述（Lean 对照）

```lean
def boundedOnesScore (fuel : ℕ) (machine : BinaryMachine (n + 1)) : ℕ
def busyBeaverCandidate (n fuel : ℕ) : ℕ :=
  Finset.univ.sup (boundedOnesScore (n := n) fuel)
theorem boundedOnesScore_le_candidate (fuel) (machine) :
  boundedOnesScore fuel machine ≤ busyBeaverCandidate n fuel
```

# 思维脉络（thinking trace）

有限状态、有限字母和有限指令选择保证固定 `n` 时机器表类型是有限类型，所以可用
`Finset.univ` 真正枚举。对每台机器先执行有限步，再从停机纸带取 `Finset.card`；未停机分支给零，
让评分成为全函数。最后用有限集 `sup` 聚合，并由“元素不超过有限上确界”直接得到上界定理。

# 自然语言 ↔ Lean 映射

- “所有固定状态数机器” ↔ `Finset.univ : Finset (BinaryMachine (n + 1))`。
- “限定时间内的输出分数” ↔ `boundedOnesScore fuel machine`。
- “最终纸带中 1 的数量” ↔ `ones.card`。
- “没在界内停机暂记零分” ↔ `ExecutionStatus.running _ => 0`。
- “候选最大值” ↔ `busyBeaverCandidate n fuel`。
- “每台机器不超过冠军” ↔ `boundedOnesScore_le_candidate`。

# 依赖（人话版）

依赖有限机器模型、标准空白输入、有限步执行和限定停机语义。mathlib 的 `Finset.sup` 只负责对
有限分数表取最大值；机器枚举和评分规则由本库定义。这里不需要、也没有使用一般停机判定器。

# 应用与陷阱

这个值适合程序实验、验证小燃料搜索以及解释 Busy Beaver 的有限近似。它不是经典无时间界
Busy Beaver 函数：未在燃料内停机的机器可能后来停机并取得更高分。本条没有证明候选值随燃料
单调，也没有形式化经典 Busy Beaver 的不可计算性；这些都属于后续工作，标题和结论不得越级引用。
