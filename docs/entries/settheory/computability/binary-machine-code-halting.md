---
id: settheory.computability.binary-machine-code-halting
kind: theorem
state: verified
title: "固定状态数机器代码的有界停机检查"
premises: ["settheory.computability.binary-machine-coding", "settheory.googology.busy-beaver-time-halting-bound"]
mathlib: []
provenance: {source_type: book, ref: "odifreddi-classical-recursion-1989"}
---

# 动机

机器编码让我们可以谈论“第几台固定状态数机器”，而时间型 Busy Beaver 的统一界说明：只要知道一个
正确界，会停的机器一定已经在界内停下。还需要补上的桥是把两者真正接起来：给定一个
`MachineCode n`，先把它解码，再运行明确给出的有限步数，并说明这个代码级检查何时能够精确回答
最终停机问题。这里的目标不是跨越所有程序大小的通用算法，而是把两个已有接口的适用条件说清楚。

# 直觉

把 `MachineCode n` 想成一张固定长度机器名单中的座位号。检查某个座位号时，我们先找到座位上的
机器，然后给它 `fuel` 步运行时间；时间耗尽时看停机灯是否已经亮起。如果手中的 `fuel` 只是随意
猜的，灯没亮不能排除机器以后才停。只有当另有证明保证这个数控制名单里的每一台会停机器时，
“界时没停”才等于“永远不停”。经典最大停机时间满足这个保证，但本库没有算法把它算出来。

# 陈述（自然语言）

`CodeHaltedAt code fuel` 表示代码解码出的机器在 `fuel` 步时已经停机，
`CodeEventuallyHalts code` 表示它最终会停。`codeHaltsByFuel fuel code` 给出相应的布尔检查，并且返回
真当且仅当 `CodeHaltedAt` 成立。如果 `bound` 已被证明是全部 `n+1` 状态机器的统一停机界，那么
这个布尔检查返回真当且仅当代码最终停机。把 `bound` 换成经典最大停机时间也有同样的命题等价。

# 陈述（Lean 对照）

```lean
noncomputable def CodeHaltedAt (code : MachineCode n) (fuel : ℕ) : Prop
noncomputable def CodeEventuallyHalts (code : MachineCode n) : Prop
noncomputable def codeHaltsByFuel (fuel : ℕ) (code : MachineCode n) : Bool
theorem codeHaltsByFuel_eq_true_iff (fuel : ℕ) (code : MachineCode n) :
  codeHaltsByFuel fuel code = true ↔ CodeHaltedAt code fuel
theorem codeHaltsByFuel_decides_of_uniform_bound
  (hbound : IsUniformHaltingBound n bound) (code : MachineCode n) :
  codeHaltsByFuel bound code = true ↔ CodeEventuallyHalts code
theorem codeHaltsBy_classical_time_iff (code : MachineCode n) :
  codeHaltsByFuel (classicalBusyBeaverTimeValue n) code = true ↔
    CodeEventuallyHalts code
```

# 思维脉络（thinking trace）

第一步不另造执行语义，而是把代码谓词定义成原机器谓词在 `decodeMachine code` 上的取值。第二步把
机器层的 `haltsByFuel` 同样作用于解码结果，因此它返回真的规格可以原样搬到代码层。第三步使用
`IsUniformHaltingBound n bound`：这个前提已经逐台说明最终停机等价于界时停机，所以对解码出的那台
机器实例化即可。最后代入已经证明满足统一界规格的 `classicalBusyBeaverTimeValue n`。整个证明是
接口组合；它没有从代码本身推算界，也没有反向构造通用解释器。

# 自然语言 ↔ Lean 映射

- “固定名单中的座位号” ↔ `MachineCode n`。
- “按座位号找回机器” ↔ `decodeMachine code`。
- “界时已经停机” ↔ `CodeHaltedAt code fuel`。
- “某个有限时刻会停” ↔ `CodeEventuallyHalts code`。
- “给定步数后检查停机灯” ↔ `codeHaltsByFuel fuel code`。
- “这个数确实控制所有会停机器” ↔ `IsUniformHaltingBound n bound`。
- “正确界下检查精确” ↔ `codeHaltsByFuel_decides_of_uniform_bound`。
- “经典最大界下的命题等价” ↔ `codeHaltsBy_classical_time_iff`。

# 依赖（人话版）

机器侧依赖固定状态数二符号机器的 `MachineCode`、`decodeMachine` 和往返编码规格；时间侧依赖
`HaltedAt`、`EventuallyHalts`、有限燃料检查 `haltsByFuel`、统一界谓词以及经典最大时间满足统一界的
定理。这里没有新增机器模型、执行规则或停机概念。两个上游包分别负责“代码代表哪台机器”和
“什么条件使有限观察足以判断最终停机”，本条只在同一个解码结果上拼接它们。

# 应用与陷阱

若外部明确给出自然数 `bound` 及其统一界证明，本条提供代码层的精确检查规格。但
`encodeMachine` 与 `decodeMachine` 是由 `Fintype.equivFin` 的规范有限枚举选出的 `noncomputable`
函数，因此连带的 `CodeHaltedAt`、`CodeEventuallyHalts` 和 `codeHaltsByFuel` 也被诚实标为
`noncomputable`：底层机器拿到后，有限步执行可以计算，并不表示当前代码解码接口已经提取成可执行
程序。经典界 `classicalBusyBeaverTimeValue` 又是非构造的；把它代入定理只得到命题等价，不能运行出
一个通用停机判定器。本条也没有证明停机不可判定或 Busy Beaver 不可计算。
