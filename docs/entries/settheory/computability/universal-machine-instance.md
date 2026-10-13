---
id: settheory.computability.universal-machine-instance
kind: definition
state: verified
title: "现有机器模型的通用 runner 实例"
premises: ["settheory.computability.universal-interpreter-spec", "settheory.computability.binary-machine-coding"]
mathlib: ["Nat.pair", "Nat.unpair", "Function.Injective"]
provenance: {source_type: textbook, ref: "odifreddi-classical-recursion-1989"}
---

# 动机

`UniversalNatInterpreter` 是一条“合格通用模拟器的验收集”，先前只有结构字段而没有 inhabitant。
既有 `NatProgram` 是“状态偏移 + 固定状态数机器表”，`BinaryMachineCoding` 又给了固定状态数的
有限代码。两者拼起来就足以真正构造一个通用 runner：先把程序编码成一个自然数，解码回程序后
交给现有解释器执行。本条补上这个此前缺失的实例，并说明它的实际强度。

# 直觉

通用 runner 就像一个查表模拟器：每份程序先被登记为一个自然数编号，运行时把编号拆回程序，
再逐步执行。这里的编号并不神秘——状态偏移和机器代码是两个可分开恢复的分量，配成一个数即可；
解码是编码的逆，因此不会把两份程序混为同一个编号。模拟定律只是“解码后运行原程序”的记账。

# 陈述（自然语言）

编码 `encodeNatProgram` 把程序的状态偏移与固定状态数机器代码经 `Nat.pair` 拼成一个自然数；
解码 `decodeNatProgram` 先拆配对，再用 `decodeMachineNat` 按偏移恢复机器并组装程序。于是：

1. 解码是编码的左逆：`decodeNatProgram (encodeNatProgram p) = p`；
2. 编码是单射：不同程序（包括状态数不同的程序）得到不同编码；
3. 以该编码、`interpretWithin ∘ decodeNatProgram` 和模拟定律组装出的
   `universalNatInterpreter` 是 `UniversalNatInterpreter` 的真实实例；
4. 实例在编码程序上的最终输出关系与原程序的 `ProgramOutput` 完全等价。

# 陈述（Lean 对照）

```lean
noncomputable def encodeNatProgram (program : NatProgram) : ℕ :=
  Nat.pair program.stateOffset (encodeMachine program.machine).val
noncomputable def decodeNatProgram (code : ℕ) : NatProgram :=
  decodeProgramPair code.unpair.1 code.unpair.2
theorem decodeNatProgram_encodeNatProgram (program) :
  decodeNatProgram (encodeNatProgram program) = program
theorem encodeNatProgram_injective : Function.Injective encodeNatProgram
noncomputable def universalNatInterpreter : UniversalNatInterpreter where
  encode := encodeNatProgram
  encode_injective := encodeNatProgram_injective
  eval := fun code fuel input => interpretWithin (decodeNatProgram code) fuel input
  simulate := fun program fuel input => by simp [decodeNatProgram_encodeNatProgram]
theorem universalNatInterpreter_outputs_encode_iff (program) (input output) :
  universalNatInterpreter.Outputs (encodeNatProgram program) input output ↔
    ProgramOutput program input output
```

最后一条直接复用 `PartialComputability` 的 `universal_outputs_encode_iff`，证明实例满足的正是
规格层已经冻结的语义，而不是另起一套输出关系。

# 思维脉络（thinking trace）

目标是把 `UniversalNatInterpreter` 的三个字段一次填齐。编码用 `Nat.pair` 分离状态偏移与机器
代码；解码必须避开在解码函数的 `match` 内部直接改写 `Nat.unpair`，否则会陷入依赖匹配的改写
失败；因此把“按偏移解码机器”抽成独立函数 `decodeProgramPair`，先在引数位置重写配对再化简。
左逆一旦成立，单射、`simulate` 与输出等价都只是把它代回。整个过程不需要假设编码可计算。

# 自然语言 ↔ Lean 映射

- “程序编号” ↔ `encodeNatProgram program`，由 `Nat.pair` 与 `encodeMachine` 复合。
- “拆回程序” ↔ `decodeNatProgram code`；越界代码走私有兜底程序 `fallbackNatProgram`。
- “编号不冲突” ↔ `encodeNatProgram_injective`。
- “模拟器” ↔ `universalNatInterpreter.eval code fuel input`，即对解码后的程序调用
  `interpretWithin`。
- “逐燃料忠实模拟” ↔ `simulate` 字段，由 `decodeNatProgram_encodeNatProgram` 化简。
- “编码程序的输出” ↔ `universalNatInterpreter.Outputs` 与 `ProgramOutput` 的等价定理。

# 依赖（人话版）

依赖 `settheory.computability.universal-interpreter-spec` 冻结的字段清单，以及
`settheory.computability.binary-machine-coding` 与更早的有限机器语义。`Nat.pair`／`Nat.unpair`
只是自然数配对的公开后端；`Fintype.equivFin` 的有限枚举与 `Classical.choice` 只用于解码，是
`noncomputable` 的实现后端。这里没有新增数学定义层的假设，只是把既有规格变为可用的实例。

# 应用与陷阱

下游对角论证现在可以在真实实例上运行，而不必再携带“假设存在通用解释器”的结构参数。但必须
保留三条边界：其一，编码与解码依赖 `noncomputable` 的有限枚举，本条没有给出可执行编译器或
通用 `NatProgram`；其二，`universalNatInterpreter` 是元层的自然数函数，**不是**本库 `NatProgram`
自身，因此不构成自解释器；其三，`eval` 在固定燃料下返回 `none` 只表示尚未停机，把它当作停机
判定算法或据此宣称停机不可判定都超出本条结论。
