---
id: settheory.googology.busy-beaver-time
kind: theorem
state: verified
title: "时间型 Busy Beaver：最大首次停机时间"
premises: ["settheory.googology.unbounded-halting-relation", "settheory.googology.busy-beaver-existence"]
mathlib: ["Nat.find", "Finset.sup"]
provenance: {source_type: book, ref: "Tibor Rado, On Non-Computable Functions, 1962; maximum-shift variant"}
---

# 动机

产出型 Busy Beaver 比较停机纸带上有多少个 `1`，另一种经典变体比较机器停机前运行了多少步。
要讨论“最长运行时间”，必须先排除同一机器停机后继续观察得到的任意更大步数：真正应比较的是
每台机器首次进入停机状态的最小时间，而不是任意一个已经停机的观察时刻。

# 直觉

给每台最终会停的机器按下秒表，从空白纸带开始逐步运行，第一次亮起停机灯时立即记录时间。固定
状态数后，可能的指令表只有有限张，因此这些首次停机时间中一定有最大者。永不停止的机器没有参赛
时间；证明中暂时给它记零，但立即停机机器的一步成绩保证这种技术补零不会冒充冠军。

# 陈述（自然语言）

`HaltedAt machine time` 表示机器运行 `time` 步后已经停机，它与已有 `EventuallyHalts` 的关系是：
机器最终停机当且仅当存在某个 `HaltedAt` 时刻。`IsFirstHaltingTime` 还要求所有更早时刻未停机。
`IsBusyBeaverTimeValue n value` 表示 `value` 支配全部 `n+1` 状态机器的首次停机时间，并由某台机器
达到。本库定义经典最大时间，证明它满足该规格，因此值存在、取得、是上界且唯一。

# 陈述（Lean 对照）

```lean
def HaltedAt (machine : BinaryMachine (n + 1)) (time : ℕ) : Prop
theorem eventuallyHalts_iff_exists_haltedAt (machine) :
  EventuallyHalts machine ↔ ∃ time, HaltedAt machine time
def IsFirstHaltingTime (machine : BinaryMachine (n + 1)) (time : ℕ) : Prop :=
  HaltedAt machine time ∧ ∀ earlier, earlier < time → ¬HaltedAt machine earlier
noncomputable def classicalBusyBeaverTimeValue (n : ℕ) : ℕ
def IsBusyBeaverTimeValue (n value : ℕ) : Prop :=
  (∀ machine time, IsFirstHaltingTime machine time → time ≤ value) ∧
  ∃ machine, IsFirstHaltingTime machine value
theorem classicalBusyBeaverTimeValue_spec (n : ℕ) :
  IsBusyBeaverTimeValue n (classicalBusyBeaverTimeValue n)
theorem isBusyBeaverTimeValue_unique (hx : IsBusyBeaverTimeValue n x)
  (hy : IsBusyBeaverTimeValue n y) : x = y
```

# 思维脉络（thinking trace）

先把 `HaltedAt` 定义为既有 `runSteps` 结果能提取停机纸带，随后直接与已有 `EventuallyHalts` 的
存在见证互换，避免第二套最终停机关系。对会停机的机器，用 `Nat.find` 从所有停机时刻中取最小者，
`Nat.find_spec` 给出确已停机，`Nat.find_min` 排除更早时刻。再给不停机机器辅助记零，对有限机器
全集用 `Finset.sup` 取最大；若取得最大辅助分数的机器不停机，其分数为零，但立即停机机器的首次
时间为一，产生矛盾。因此最大值确由停机机器达到。任意首次时间等于该机器的最小时间，从而受
有限最大值控制；两份最大值规格互相用冠军机器给出上下界，得到唯一性。

# 自然语言 ↔ Lean 映射

- “运行到某时刻已经停机” ↔ `HaltedAt machine time`。
- “最终会停机” ↔ 既有 `EventuallyHalts machine`。
- “第一次停机” ↔ `IsFirstHaltingTime machine time`。
- “取最小停机时刻” ↔ `Nat.find` 与 `machineHaltingTime`。
- “固定状态数全部机器” ↔ `Finset.univ : Finset (BinaryMachine (n+1))`。
- “最大首次停机时间” ↔ `classicalBusyBeaverTimeValue n`。
- “上界且被达到” ↔ `IsBusyBeaverTimeValue n value`。
- “规格唯一确定值” ↔ `isBusyBeaverTimeValue_unique`。

# 依赖（人话版）

复用已有二符号机器、空白起点、多步执行、`EventuallyHalts` 和立即停机机器；没有重新定义“最终
停机”。mathlib 的 `Nat.find` 负责从已有自然数存在见证中取最小值，`Finset.sup` 负责在有限机器
表上取最大。两者用于经典存在性证明，不提供识别不停机机器的算法。

# 应用与陷阱

该时间值可作为未来研究有限运行界和停机归约的基础。必须区分 `HaltedAt machine time` 与“恰好
在该步第一次停机”：机器停机后继续给燃料，前者仍成立，只有 `IsFirstHaltingTime` 排除了更早
时刻。`classicalBusyBeaverTimeValue` 是 `noncomputable` 的存在性定义，本条没有给出计算最大时间
的程序，也没有证明停机不可判定或时间型／产出型 Busy Beaver 不可计算。参数 `n` 仍代表
`n+1` 个工作状态。
