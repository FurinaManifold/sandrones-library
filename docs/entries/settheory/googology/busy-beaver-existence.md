---
id: settheory.googology.busy-beaver-existence
kind: theorem
state: verified
title: "经典 Busy Beaver 最大值的存在性"
premises: ["settheory.googology.unbounded-halting-relation", "settheory.googology.busy-beaver-value-relation"]
mathlib: ["Finset.sup", "Classical.choose"]
provenance: {source_type: book, ref: "Tibor Rado, On Non-Computable Functions, 1962"}
---

# 动机

经典 Busy Beaver 值不是固定燃料下的搜索结果：每台会停机的机器可能需要不同时间。尽管没有
统一停机界，固定状态数时指令表总数仍然有限。因此可以先为每台最终停机机器确定其输出，再在
有限台机器之间取最大，得到经典值的纯数学存在性。

# 直觉

想象桌上只有有限台机器。每台机器若最终停机，就只有一个确定的最终分数；永不停止者不参加
比赛。先暂时给不停止者记零分，随后对整张有限名单取最高分。即使最高的暂记零分来自不停止机器，
上一条构造的立即停机机器也确实能以零分达到它，所以冠军总由停机机器实现。

# 陈述（自然语言）

上一条公开定义 `IsBusyBeaverValue n value` 同时要求：任何 `n+1` 状态机器的任何最终停机输出
都不超过 `value`；并且存在一台这种机器最终输出恰为 `value`。本条证明对每个 `n` 都存在满足
该既有规格的值，并定义 `classicalBusyBeaverValue n` 为有限机器全集上最终分数的最大值。

# 陈述（Lean 对照）

```lean
-- 以下三个接口来自已导入的 `SandronesLibrary.SetTheory.BusyBeaver`
#check BusyBeaver.EventuallyHalts
-- EventuallyHalts (machine : BinaryMachine (n + 1)) : Prop
#check BusyBeaver.HasHaltingOnesScore
-- HasHaltingOnesScore (machine : BinaryMachine (n + 1)) (score : ℕ) : Prop
#check BusyBeaver.IsBusyBeaverValue
-- IsBusyBeaverValue (n value : ℕ) : Prop

-- 本条只新增经典选择得到的总函数及其存在性、规格定理
noncomputable def classicalBusyBeaverValue (n : ℕ) : ℕ :=
  Finset.univ.sup (eventualOnesScore (n := n))
theorem exists_isBusyBeaverValue (n : ℕ) : ∃ value, IsBusyBeaverValue n value
theorem classicalBusyBeaverValue_spec (n : ℕ) :
  IsBusyBeaverValue n (classicalBusyBeaverValue n)
```

# 思维脉络（thinking trace）

首先直接导入 `BusyBeaver` 模块的 `EventuallyHalts`、`HasHaltingOnesScore` 与
`IsBusyBeaverValue`，不另建同义关系。随后用 `Classical.choose` 从已存在的停机分数中取一个，
不停机时补零；确定执行的吸收性保证任意两个停机观察时刻分数一致。固定状态数的机器类型有限，
故 `Finset.univ.sup` 取得最大分数；有限集最大元给出候选机器，立即停机机器处理最大值为零的边界，
最后把结果组装回已有的 `IsBusyBeaverValue` 规格。

# 自然语言 ↔ Lean 映射

- “固定状态数的所有机器” ↔ `Finset.univ : Finset (BinaryMachine (n + 1))`。
- “机器真正最终停机” ↔ 已有 `EventuallyHalts machine`。
- “机器最终留下某分数” ↔ 已有 `HasHaltingOnesScore machine score`。
- “经典选择一个最终分数” ↔ `eventualOnesScore machine`。
- “所有停机输出的上界” ↔ `IsBusyBeaverValue` 的第一个合取。
- “有停机机器达到最大值” ↔ 第二个合取中的存在见证。
- “经典 Busy Beaver 总函数” ↔ `classicalBusyBeaverValue : ℕ → ℕ`。

# 依赖（人话版）

依赖 `unbounded-halting-relation` 提供的 `EventuallyHalts` 与 `HasHaltingOnesScore`，以及
`busy-beaver-value-relation` 已经固定的 `IsBusyBeaverValue`。本条只补“该关系确有实例”的证明，
没有重新定义这些概念。mathlib 的有限集上确界负责取最大；`Classical.choose` 只从已经存在的停机
分数中取一个，不提供停机判定算法。公开的最大值关系本身仍不含选择算子。

# 应用与陷阱

下游可以安全依赖“经典值支配全部最终输出且确实可达到”。但 `classicalBusyBeaverValue` 被明确
标记为 `noncomputable`：该存在性构造不能直接算出数值，也没有证明任何不可计算性定理。另需注意
参数 `n` 对应 `n+1` 个工作状态，这是为了保证标准零号初始状态存在；引用具体传统数表时必须先
转换参数，不能把本库下标直接当成工作状态数。
