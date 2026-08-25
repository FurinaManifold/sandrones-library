---
id: settheory.computability.universal-interpreter-spec
kind: definition
state: verified
title: "通用自然数解释器的抽象规格"
premises: ["settheory.computability.partial-nat-computable"]
mathlib: ["Function.Injective"]
provenance: {source_type: textbook, ref: "odifreddi-classical-recursion-1989"}
---

# 动机

对角论证需要把“程序本身”当成自然数输入，并让一个固定解释器按代码模拟它。现有
`BinaryMachine` 只有有限指令表和执行器，尚未提供语法编码、解码器或机器内部自解释器。为了不
越级，本条先精确冻结未来通用解释器必须兑现的接口，而不假装实现已经存在。

# 直觉

通用解释器像一台模拟器：每份程序有一个不与其他程序冲突的自然数编号；输入编号、燃料和普通
输入后，模拟器应返回被编号程序在相同燃料和输入下的相同结果。这里我们只写“合格模拟器的验收
表”，没有交出一台合格模拟器。

# 陈述（自然语言）

`UniversalNatInterpreter` 包含程序到自然数的编码、编码单射性、按代码运行的有限解释函数，以及
逐程序、逐燃料、逐输入与现有 `interpretWithin` 完全一致的模拟定律。它的 `Outputs` 关系表示
存在燃料使某代码产生某输出。对任何实际程序，其编码的通用输出关系等价于该程序自身的
`ProgramOutput`。

# 陈述（Lean 对照）

```lean
structure UniversalNatInterpreter where
  encode : NatProgram → ℕ
  encode_injective : Function.Injective encode
  eval : ℕ → ℕ → ℕ → Option ℕ
  simulate : ∀ program fuel input,
    eval (encode program) fuel input = interpretWithin program fuel input
def UniversalNatInterpreter.Outputs (universal) (code input output : ℕ) : Prop :=
  ∃ fuel, universal.eval code fuel input = some output
theorem universal_outputs_encode_iff (universal) (program) (input output) :
  universal.Outputs (universal.encode program) input output ↔
    ProgramOutput program input output
```

# 思维脉络（thinking trace）

编码字段让程序能够作为自然数数据出现，单射字段排除两个不同程序被强制视为同一代码。`eval`
仍带有限燃料，因此它是普通可执行形状，而不是直接回答是否最终停机。最关键的 `simulate` 字段把
抽象代码解释与现有具体解释器逐步对齐；由此在存在量词两侧重写一次，就得到两种最终输出关系的
等价。整个过程只推导“若给定合格通用解释器，则它满足什么”，没有构造该结构的实例。

# 自然语言 ↔ Lean 映射

- “程序的自然数编号” ↔ `universal.encode program`。
- “不同程序编号不同” ↔ `encode_injective`。
- “按代码、燃料、输入模拟” ↔ `universal.eval code fuel input`。
- “逐燃料忠实模拟” ↔ `universal.simulate program fuel input`。
- “代码最终产生输出” ↔ `universal.Outputs code input output`。
- “编码程序与原程序输出一致” ↔ `universal_outputs_encode_iff`。

# 依赖（人话版）

依赖程序封装、有限解释器和部分函数的 `ProgramOutput` 关系。只借用函数单射的基础概念。尤其不
依赖一个尚不存在的 `NatProgram` 编码实现：编码、模拟器及正确性都作为结构使用者必须提供的字段。

# 应用与陷阱

下一轮可以在明确假设 `universal : UniversalNatInterpreter` 后陈述对角关系，并清楚指出结论依赖
这一实现门。当前库没有该结构的 inhabitant，不能写“令现有通用机……”或据此断言停机不可判定。
`eval` 在固定燃料下返回 `none` 只表示尚未停机，不表示永不停止；把它误当停机判定器会破坏整个
归约。构造真实实例还需程序语法的自然数编码、解码和模拟正确性证明。
