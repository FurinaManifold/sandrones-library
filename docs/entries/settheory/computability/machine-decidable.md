---
id: settheory.computability.machine-decidable
kind: definition
state: verified
title: "谓词的机器判定与特征函数"
premises: ["settheory.computability.nat-computable"]
mathlib: []
provenance: {source_type: textbook, ref: "Decidable sets and characteristic functions"}
---

# 动机

判断问题不只是“真时能找到证据”；判定器必须在真、假两种输入上都最终停机，并明确告诉我们是哪
一种情况。把真编码成 `1`、假编码成 `0` 后，谓词判定就能与上一条自然数函数计算使用同一个机器
接口，而不必另造一套执行语义。

# 直觉

把程序看成回答是非问题的机器。输入满足 `P` 时，它最后留下一个 `1`；输入不满足 `P` 时，它
最后清成零个 `1`。两边都要求某个有限时刻停机。于是这台机器做的事情，正是计算函数
`χ_P(x)=1`（若 `P(x)`）或 `0`（若非 `P(x)`）。

# 陈述（自然语言）

`DecidesPredicate program P` 要求每个输入满足两个分支之一：`P input` 且程序最终输出一，或者
`¬P input` 且程序最终输出零。`MachineDecidable P` 表示存在这样的程序。若 `P` 在 Lean 中具有
逐点可判定实例，则程序判定 `P` 当且仅当同一程序计算其零一特征函数。

# 陈述（Lean 对照）

```lean
def DecidesPredicate (program : NatProgram) (P : ℕ → Prop) : Prop :=
  ∀ input,
    (P input ∧ ∃ fuel, interpretWithin program fuel input = some 1) ∨
    (¬P input ∧ ∃ fuel, interpretWithin program fuel input = some 0)
def MachineDecidable (P : ℕ → Prop) : Prop :=
  ∃ program, DecidesPredicate program P
def characteristicFunction (P : ℕ → Prop) [DecidablePred P] (input : ℕ) : ℕ :=
  if P input then 1 else 0
theorem decidesPredicate_iff_computes_characteristic (program) (P) [DecidablePred P] :
  DecidesPredicate program P ↔ ComputesNatFunction program (characteristicFunction P)
```

# 思维脉络（thinking trace）

判定规格先把数学真假与机器输出放在同一个析取中，因此每个分支同时携带命题事实和停机见证。
向特征函数方向证明时，按已有真假分支化简 `if`；反方向则在 Lean 可判定实例下对 `P input`
分情况，再把计算特征函数的停机见证放回相应分支。整个证明只转换规格，程序和运行轨迹完全不变。

# 自然语言 ↔ Lean 映射

- “程序回答真” ↔ `P input` 且 `interpretWithin ... = some 1`。
- “程序回答假” ↔ `¬P input` 且 `interpretWithin ... = some 0`。
- “两个方向都停机” ↔ 两个析取分支各自含 `∃ fuel`。
- “程序判定谓词” ↔ `DecidesPredicate program P`。
- “存在某个判定程序” ↔ `MachineDecidable P`。
- “真假编码成零一” ↔ `characteristicFunction P`。
- “判定即计算特征函数” ↔ `decidesPredicate_iff_computes_characteristic`。

# 依赖（人话版）

依赖上一条的程序封装、一元输入、有限解释器与总函数计算规格。特征函数需要 `[DecidablePred P]`
才能在 Lean 中执行真假分支；这只是本条等价定理的逻辑接口，不等于已经构造出机器判定器。机器
判定性本身仍由显式存在的 `NatProgram` 见证。

# 应用与陷阱

该等价是以后把“若存在某函数算法”转换成“便能判定某谓词”的基础规格。不要把 Lean 的
`DecidablePred P` 与 `MachineDecidable P` 混为一谈：前者是当前形式化环境中的判定实例，后者
要求具体有限机器最终输出零或一。本条没有证明停机谓词缺少机器判定器，也没有由此推出 Busy
Beaver 不可计算；这些都需要额外编码和完整归约。
