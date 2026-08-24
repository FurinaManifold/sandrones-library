---
id: settheory.computability.executable-universal-spec
kind: definition
state: verified
title: "可由程序实现的通用解释器规格"
premises: ["settheory.computability.pairing-code"]
mathlib: []
provenance: {source_type: textbook, ref: "Universal machine and acceptable programming system"}
---

# 动机

上一批 `UniversalNatInterpreter` 只有抽象 `eval` 函数；它尚未说明这个模拟过程能由本库
`NatProgram` 自己完成。停机对角论证需要一台同属当前机器模型的通用 runner，因此必须把“抽象
解释正确”和“机器内部可实现”区分开，并增加一条明确的实现门。

# 直觉

抽象解释器像宿主电脑上的模拟函数；可执行通用机则必须是参赛机器语言自身写成的程序。它接收
配对后的 `(程序代码, 输入)`，最终输出必须与被编码程序相同。只有交出 runner 以及这条逐输出
正确性证明，才能说当前程序系统具备通用模拟能力。

# 陈述（自然语言）

`ExecutableUniversalInterpreter` 包含上一批抽象通用解释器、一份配对编码和一台 runner 程序。
`runner_spec` 要求 runner 在配对代码输入上的 `ProgramOutput`，当且仅当抽象解释器在原代码与
输入上产生相同输出。结合抽象解释器对已编码程序的模拟定律，可推出 runner 运行编码程序与原程序
自身运行的最终输出关系完全相同。

# 陈述（Lean 对照）

```lean
structure ExecutableUniversalInterpreter where
  universal : UniversalNatInterpreter
  coding : PairingCode
  runner : NatProgram
  runner_spec : ∀ code input output,
    ProgramOutput runner (coding.pair code input) output ↔
      universal.Outputs code input output
theorem runner_encode_iff (executable) (program) (input output) :
  ProgramOutput executable.runner
      (executable.coding.pair (executable.universal.encode program) input) output ↔
    ProgramOutput program input output
```

# 思维脉络（thinking trace）

先把抽象解释器、配对和 runner 封装成同一结构，使正确性不能脱离实现对象。对已编码程序，先用
`runner_spec` 把 runner 输出改写为抽象 `Outputs`，再用上一批
`universal_outputs_encode_iff` 改写为原程序的 `ProgramOutput`。两次等价重写就是完整桥，不引入
额外停机假设。

# 自然语言 ↔ Lean 映射

- “抽象通用解释器” ↔ `executable.universal`。
- “代码和输入打包” ↔ `executable.coding.pair code input`。
- “机器语言自身的模拟程序” ↔ `executable.runner`。
- “runner 忠实实现抽象解释” ↔ `runner_spec`。
- “模拟已编码程序” ↔ `runner_encode_iff`。
- “最终输出关系一致” ↔ 两边均使用 `ProgramOutput`。

# 依赖（人话版）

依赖自然数配对、抽象通用解释器、程序停机输出关系及其编码模拟定律。没有借用 mathlib 的通用图灵
机，也没有从 `BinaryMachine` 自动推断 runner 存在；所有实现责任都保留为结构字段。

# 应用与陷阱

一旦未来构造该结构实例，下游便可在当前机器模型内部调用通用 runner。当前文件仍只定义“合格
实例长什么样”，没有提供 inhabitant；因此不能无条件引用通用机存在，更不能跳到停机不可判定。
`runner_spec` 比单纯说 runner 能模拟更强也更精确：它要求所有最终输出双向一致，而非只保证一个
方向。
