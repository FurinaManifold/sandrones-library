---
id: settheory.computability.nat-computable
kind: definition
state: verified
title: "自然数函数的机器可计算性"
premises: ["settheory.googology.unbounded-halting-relation"]
mathlib: ["Finset.range", "Finset.map"]
provenance: {source_type: textbook, ref: "Turing-machine computability with unary input encoding"}
---

# 动机

“函数可计算”不能只靠日常语言中的“有办法算”来定义；必须冻结程序模型、输入如何放上纸带、何时
算出结果。现有 `BinaryMachine` 只从空白纸带运行，本条给它补上一元自然数输入和自然数输出约定，
让后续归约可以逐项核对究竟是哪台机器计算了哪个函数。

# 直觉

把输入 `x` 写成连续 `x` 个 `1`：输入零是空纸带，输入三就是位置 `0,1,2` 上写 `1`。机器从
零号状态和原点开始运行；如果某时停机，就数最终整张纸带上有多少个 `1`，把这个数量当作输出。
一台程序计算函数 `f`，意味着每个输入最终都停机，并恰好留下 `f(x)` 个 `1`。

# 陈述（自然语言）

`NatProgram` 封装一个自然数状态偏移量和具有 `stateOffset+1` 个工作状态的二符号机器。
`interpretWithin program fuel input` 有限运行：界内停机则返回最终 `1` 数，否则返回 `none`。
程序计算 `f`，是指每个输入都存在某个燃料得到 `some (f input)`；函数可计算，是指存在这样的程序。

# 陈述（Lean 对照）

```lean
structure NatProgram where
  stateOffset : ℕ
  machine : BinaryMachine (stateOffset + 1)
def unaryTape (input : ℕ) : Finset ℤ
def inputStart (program : NatProgram) (input : ℕ) : ExecutionStatus _
def interpretWithin (program : NatProgram) (fuel input : ℕ) : Option ℕ
def ComputesNatFunction (program : NatProgram) (f : ℕ → ℕ) : Prop :=
  ∀ input, ∃ fuel, interpretWithin program fuel input = some (f input)
def NatComputable (f : ℕ → ℕ) : Prop :=
  ∃ program, ComputesNatFunction program f
```

# 思维脉络（thinking trace）

先用 `Finset.range input` 枚举 `0` 到 `input-1`，再单射映到整数位置，得到有限一元纸带。程序封装
状态数是因为“存在某台机器”也必须允许不同程序使用不同有限状态数。有限解释器直接复用既有
`runSteps`，而总函数规格把燃料放在每个输入内部的存在量词中，不要求所有输入共享时间界。最后还
证明停机是吸收态，所以同一确定程序在同一输入上两次观察到的输出必相同。

# 自然语言 ↔ Lean 映射

- “有限程序及其状态数” ↔ `NatProgram`。
- “输入 `x` 的一元编码” ↔ `unaryTape x`。
- “状态零、头在原点” ↔ `inputStart program input`。
- “给定燃料试运行” ↔ `interpretWithin program fuel input`。
- “每个输入最终得到正确值” ↔ `ComputesNatFunction program f`。
- “存在程序计算函数” ↔ `NatComputable f`。
- “确定输出唯一” ↔ `interpretWithin_output_unique`。

# 依赖（人话版）

直接依赖已有 `BinaryMachine`、`ExecutionStatus` 和 `runSteps` 的确定执行语义，并沿用无时间界停机
关系“存在某个有限时刻”的量词结构。mathlib 的有限区间和有限集映射只用于制作输入纸带，没有
提供另一套可计算性黑盒。

# 应用与陷阱

该定义为之后讨论函数可计算、程序归约和反证提供统一接口。但它采用一元输入和“最终纸带全部
`1` 的数量”作为输出；换成二进制编码或指定输出区会改变程序实现，证明等价需要编译器桥，不能
直接视为定义相同。`NatComputable` 要求全函数在每个输入上停机，不包括只对部分输入有输出的
部分可计算函数。本条没有断言哪些具体复杂函数不可计算。
