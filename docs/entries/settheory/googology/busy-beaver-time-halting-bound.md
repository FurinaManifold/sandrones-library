---
id: settheory.googology.busy-beaver-time-halting-bound
kind: theorem
state: verified
title: "最大首次停机时间给出的统一停机界"
premises: ["settheory.googology.busy-beaver-time"]
mathlib: []
provenance: {source_type: derivation, ref: "rado-non-computable-functions-1962"}
---

# 动机

时间型 Busy Beaver 值不仅是“最慢冠军”的成绩，也应控制同一状态数的所有机器：如果一台机器
最终会停，它不可能晚于最大首次停机时间才第一次停机。要把这句话变成判定界，还必须证明机器
一旦停机，增加运行步数不会让它重新变成运行状态。

# 直觉

固定状态数后，给每台机器同样长的倒计时，长度取最慢停机机器的首次停机时间。会停的机器都应在
倒计时结束前亮起停机灯；倒计时结束仍没停的机器就永远不会停。只要手里真的知道这个自然数界，
逐步模拟到那里并检查一次便够了。困难在于经典最大界本身没有由本库算法算出。

# 陈述（自然语言）

`HaltedAt machine` 关于时间单调。`IsUniformHaltingBound n bound` 表示对每台 `n+1` 状态机器，最终
停机当且仅当在 `bound` 步时已经停机。经典最大首次停机时间满足这一规格。对任意显式 `fuel`，
`haltsByFuel` 是有限执行的布尔检查；若已给出统一界证明，它返回真当且仅当机器最终停机。代入
经典时间值，同一命题等价仍成立，但该代入式不因此成为可执行算法。

# 陈述（Lean 对照）

```lean
theorem haltedAt_mono (machine : BinaryMachine (n + 1)) :
  Monotone (HaltedAt machine)
def IsUniformHaltingBound (n bound : ℕ) : Prop :=
  ∀ machine : BinaryMachine (n + 1),
    EventuallyHalts machine ↔ HaltedAt machine bound
theorem classicalBusyBeaverTime_is_uniform_bound (n : ℕ) :
  IsUniformHaltingBound n (classicalBusyBeaverTimeValue n)
def haltsByFuel (fuel : ℕ) (machine : BinaryMachine (n + 1)) : Bool
theorem haltsByFuel_decides_of_uniform_bound (hbound : IsUniformHaltingBound n bound)
  (machine : BinaryMachine (n + 1)) :
  haltsByFuel bound machine = true ↔ EventuallyHalts machine
```

# 思维脉络（thinking trace）

先证明多步执行可分解为前段和后段，并证明 `halted tape` 对后续单步是吸收态。给定较早时刻
`HaltedAt`，从执行结果提取停机分支，再把较晚时间写成“早期时间加额外步数”，即可得到较晚时刻
仍停机。若机器最终停机，上一批的最小时间规格给出首次停机时刻，最大时间规格给出它不超过经典
界，再用单调性推到界上；反向只需把界时停机作为 `EventuallyHalts` 的存在见证。有限布尔检查
直接读取界时运行状态，因而在任意已证明的统一界下与最终停机等价。

# 自然语言 ↔ Lean 映射

- “停机后保持停机” ↔ 私有 `runSteps_halted`。
- “增加观察时间不会失去停机” ↔ `haltedAt_mono`。
- “统一控制全部固定状态数机器” ↔ `IsUniformHaltingBound n bound`。
- “经典最大时间是统一界” ↔ `classicalBusyBeaverTime_is_uniform_bound`。
- “给定燃料有限模拟” ↔ `haltsByFuel fuel machine`。
- “布尔真表示界内已停” ↔ `haltsByFuel_eq_true_iff`。
- “已知统一界即可判定” ↔ `haltsByFuel_decides_of_uniform_bound`。

# 依赖（人话版）

依赖既有确定执行语义、`HaltedAt`、首次停机时间、经典最大时间及其上界和取得规格。没有定义新的
停机关系，也没有调用一个一般停机判定器。布尔检查本身只对用户明确给出的自然数燃料做有限递归，
因此可执行；把什么数选作完整统一界则是另一项信息。

# 应用与陷阱

如果外部已经给出固定 `n` 的正确统一界，就可以用 `haltsByFuel` 对这个有限机器类做完整判定。
但 `classicalBusyBeaverTimeValue n` 是上一批通过经典选择和有限最大值得到的 `noncomputable` 常量，
本库没有算法输出它；把它写进等价定理不等于能执行到那个未知数。本条没有证明一般停机问题已经
可判定，也没有证明时间型或产出型 Busy Beaver 不可计算。结论始终逐个固定状态数 `n` 成立，不
提供跨全部程序大小的可计算统一界。
