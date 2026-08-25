---
id: settheory.computability.conditional-diagonal
kind: theorem
state: verified
title: "自应用停机判定的条件式对角矛盾"
premises: ["settheory.computability.executable-universal-spec", "settheory.computability.machine-decidable"]
mathlib: []
provenance: {source_type: textbook, ref: "odifreddi-classical-recursion-1989"}
---

# 动机

“假设有停机判定器，让程序在判定自己停机时反而不停”这句口号隐藏了两个实现步骤：程序必须能
把代码用于自身输入，判定器还必须能被编译成一台翻转其答案的程序。本条把这些门全部写进前提，
然后展示真正的逻辑矛盾；尚未实现的编译器绝不被当作既成事实。

# 直觉

假设判定器能回答“代码 `e` 对输入 `e` 会不会停”。用一个翻转编译器造程序 `D`：判定答案为
“会停”时，`D` 故意不停；答案为“不会停”时，`D` 停机并输出零。再把 `D` 自己的代码喂给
`D`：若它停，翻转规则说它不停；若它不停，翻转规则又说它停。两种情况都矛盾。

# 陈述（自然语言）

`SelfHalts universal code` 表示通用解释器在代码同时作为程序代码和普通输入时最终产生某个输出。
`DiagonalFlipClosure` 要求：若某程序判定这个谓词，就能编译出一台程序，它恰在谓词为假时输出零，
为真时没有输出。给定可执行通用解释器和该翻转闭包后，不存在程序判定 `SelfHalts`。

# 陈述（Lean 对照）

```lean
def SelfHalts (universal : UniversalNatInterpreter) (code : ℕ) : Prop :=
  ∃ output, universal.Outputs code code output
structure DiagonalFlipClosure (universal : UniversalNatInterpreter) where
  flip : NatProgram → NatProgram
  flip_spec : ∀ decider,
    DecidesPredicate decider (SelfHalts universal) →
    ∀ code output, ProgramOutput (flip decider) code output ↔
      output = 0 ∧ ¬ SelfHalts universal code
theorem no_program_decides_selfHalts
    (executable : ExecutableUniversalInterpreter)
    (closure : DiagonalFlipClosure executable.universal) :
  ¬∃ decider, DecidesPredicate decider (SelfHalts executable.universal)
```

# 思维脉络（thinking trace）

反设存在判定程序，经 `closure.flip` 得到对角程序 `diagonal`，再取其编码 `diagonalCode`。抽象通用
解释器的编码模拟定律给出：`SelfHalts diagonalCode` 当且仅当对角程序在自身代码上有某个输出。
翻转规格又把后者等价成 `¬ SelfHalts diagonalCode`。最后不依赖排中之外的机器事实，只对
`SelfHalts diagonalCode` 分真假：真分支推出假，假分支推出真，矛盾闭合。
这里核心矛盾实际只读取 `executable.universal` 的编码模拟律与 `closure.flip_spec`；同一结构中的
`runner_spec` 没有出现在这段真假推导里。它被保留为“抽象通用语义确实能由当前机器程序执行”的
后续实现桥，不能被描述成这次条件矛盾已经构造出的事实。

# 自然语言 ↔ Lean 映射

- “代码在自身输入上停机” ↔ `SelfHalts universal code`。
- “假设有总判定程序” ↔ `DecidesPredicate decider (SelfHalts universal)`。
- “编译反向程序” ↔ `closure.flip decider`。
- “真时发散、假时输出零” ↔ `closure.flip_spec` 的双向等价。
- “对角程序自己的代码” ↔ `universal.encode diagonal`。
- “停当且仅当不停” ↔ 证明中的 `hself_iff` 与 `hdiagonal_iff` 复合。
- “条件式不存在判定器” ↔ `no_program_decides_selfHalts executable closure`。

# 依赖（人话版）

依赖程序编码的抽象通用解释器、谓词机器判定定义，以及显式提供的对角翻转编译闭包。定理参数使用
`ExecutableUniversalInterpreter` 统一携带未来所需的 runner 接口，但当前核心矛盾并不调用
`runner_spec`；该字段用于后续把抽象 `eval` 与当前 `NatProgram` 的实际执行连起来。定理没有偷偷
假设当前 `BinaryMachine` 已经能实现通用模拟或条件分支编译。

# 应用与陷阱

这条定理准确解释经典对角矛盾发生在哪里，也为未来实现编码器、runner 和翻转编译器后升级结论
准备接口。但在
`ExecutableUniversalInterpreter` 与 `DiagonalFlipClosure` 尚无构造实例时，结论必须读作条件句，
不能简写成“本库已证明停机问题不可判定”。它也没有涉及 Busy Beaver；从停机不可判定归约到
Busy Beaver 不可计算还需要另一条完整证明链。
