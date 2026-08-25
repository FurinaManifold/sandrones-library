---
id: settheory.computability.binary-machine-coding
kind: definition
state: verified
title: "固定状态数二符号机器的有限编码"
premises: ["settheory.googology.binary-machine"]
mathlib: ["Fintype.equivFin", "Fintype.card"]
provenance: {source_type: library_bridge, ref: "odifreddi-classical-recursion-1989"}
---

# 动机

此前的 `BinaryMachine (n+1)` 是有限指令表类型，但还没有公开的“第几台机器”接口。要把固定状态数
的统一停机界用于代码谓词，必须能在机器与有限编号之间来回，并说明哪些普通自然数是合法编号。
本条只处理固定 `n` 的有限枚举，不把不同状态数的程序统合成通用代码。

# 直觉

固定状态数后，状态、读到的符号和每种指令选择都有限，所以所有指令表可以排成一张有限名单。
`MachineCode n` 就是名单中的合法位置：它不仅保存自然数值，也随身携带“小于名单长度”的证明。
编码查机器在名单中的位置，解码按位置取回机器；越过名单末尾的普通自然数不能解码。

# 陈述（自然语言）

`MachineCode n` 是小于 `n+1` 状态机器总数的 `Fin` 类型。`encodeMachine` 和 `decodeMachine` 由同一
有限等价定义，先编码后解码以及先解码后编码都返回原对象，所以每台机器有唯一代码。
`decodeMachineNat n code` 对任意自然数先检查范围：合法则返回机器，越界返回 `none`；成功解码
当且仅当代码小于机器总数。

# 陈述（Lean 对照）

```lean
abbrev MachineCode (n : ℕ) := Fin (Fintype.card (BinaryMachine (n + 1)))
noncomputable def encodeMachine (machine : BinaryMachine (n + 1)) : MachineCode n
noncomputable def decodeMachine (code : MachineCode n) : BinaryMachine (n + 1)
theorem decodeMachine_encodeMachine (machine) :
  decodeMachine (encodeMachine machine) = machine
theorem encodeMachine_decodeMachine (code) :
  encodeMachine (decodeMachine code) = code
theorem exists_unique_machineCode (machine) :
  ∃! code : MachineCode n, decodeMachine code = machine
noncomputable def decodeMachineNat (n code : ℕ) : Option (BinaryMachine (n + 1))
theorem decodeMachineNat_isSome_iff (n code : ℕ) :
  (decodeMachineNat n code).isSome = true ↔ code < Fintype.card (BinaryMachine (n + 1))
```

# 思维脉络（thinking trace）

先复用上一批已经为 `HeadMove`、`Instruction` 和函数型机器表建立的 `Fintype` 实例，因此固定 `n`
的机器类型确实有限。mathlib 的 `Fintype.equivFin` 给出该有限类型与 `Fin (Fintype.card ...)` 的规范
等价；本库把等价的正反方向命名为机器编码和解码，并用等价的两条逆律证明往返。唯一代码由“任意
代码等于先解码再编码”得到。自然数接口则显式对 `< card` 分支，合法分支构造 `Fin` 后解码，
非法分支返回 `none`。

# 自然语言 ↔ Lean 映射

- “固定状态数机器总数” ↔ `Fintype.card (BinaryMachine (n+1))`。
- “名单中的合法位置” ↔ `MachineCode n`。
- “机器变成索引” ↔ `encodeMachine machine`。
- “索引取回机器” ↔ `decodeMachine code`。
- “双向无损” ↔ `decodeMachine_encodeMachine` 与 `encodeMachine_decodeMachine`。
- “普通自然数边界检查” ↔ `decodeMachineNat n code`。
- “代码合法范围” ↔ `code < Fintype.card ...`。
- “每台机器唯一编号” ↔ `exists_unique_machineCode`。

# 依赖（人话版）

依赖既有有限二符号机器模型及其 `Fintype` 枚举实例。mathlib 的 `Fintype.equivFin` 和
`Fintype.card` 是有限名单的实现与证明后端；本库公开自己的 `MachineCode`、编码、解码和自然数
边界桥。没有引入另一套机器执行或停机关系。

# 应用与陷阱

下游可以对固定 `n` 把机器性质改写成有限代码性质，并枚举所有 `MachineCode n`。但
`Fintype.equivFin` 是规范选择出的 `noncomputable` 等价，所以本条编码接口适合形式化索引和有限性
证明，不应冒充已经提取出的高效序列化程序。不同 `n` 的代码属于不同类型；本条没有构造把任意
状态数程序统一编码进自然数的通用 Gödel 编号，也没有构造通用解释器、证明停机不可判定或证明
Busy Beaver 不可计算。
