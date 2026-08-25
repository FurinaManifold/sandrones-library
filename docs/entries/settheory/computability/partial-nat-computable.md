---
id: settheory.computability.partial-nat-computable
kind: definition
state: verified
title: "部分自然数函数的可计算性"
premises: ["settheory.computability.nat-computable"]
mathlib: []
provenance: {source_type: textbook, ref: "odifreddi-classical-recursion-1989"}
---

# 动机

总可计算函数要求程序在每个输入上停机，但停机问题和通用模拟首先自然地产生“有些输入停机、
有些输入没有输出”的对象。若把未停机强行记成零，就会混淆“真的输出零”和“永远没有输出”。
因此需要一种能诚实表达发散的部分函数接口。

# 直觉

把部分函数看成一张可能缺行的输入输出表。`graph x y` 表示输入 `x` 有输出 `y`；某一行完全没有
`y` 就表示在 `x` 上未定义。它仍然是函数，所以同一行不能出现两个不同输出。一台程序实现这张
表，意思是它恰在表中有输出的输入上停机，并给出表中那个唯一值。

# 陈述（自然语言）

`ProgramOutput program input output` 表示存在有限燃料使现有解释器返回 `some output`。
`SingleValued graph` 要求同一输入的任意两个关系输出相等。程序计算部分函数图像，是指关系成立
当且仅当程序最终产生该输出；单值关系部分可计算，是指存在这样的程序。总可计算函数的等式图像
总是部分可计算。

# 陈述（Lean 对照）

```lean
def ProgramOutput (program : NatProgram) (input output : ℕ) : Prop :=
  ∃ fuel, interpretWithin program fuel input = some output
def SingleValued (graph : ℕ → ℕ → Prop) : Prop :=
  ∀ ⦃input x y⦄, graph input x → graph input y → x = y
def ComputesPartialFunction (program : NatProgram) (graph : ℕ → ℕ → Prop) : Prop :=
  ∀ input output, graph input output ↔ ProgramOutput program input output
def PartialNatComputable (graph : ℕ → ℕ → Prop) : Prop :=
  SingleValued graph ∧ ∃ program, ComputesPartialFunction program graph
theorem natComputable_implies_partial {f : ℕ → ℕ} :
  NatComputable f → PartialNatComputable (totalFunctionGraph f)
```

# 思维脉络（thinking trace）

首先把解释器返回 `some output` 的有限见证抽成 `ProgramOutput`。上一批已经证明确定解释器在不同
燃料下不能给出两个不同输出，所以每台程序的输出关系自动单值。总函数 `f` 嵌入为
`output = f input` 的图像：正方向使用总计算程序的停机见证，反方向把观察到的输出与正确输出用
解释器唯一性对齐。这样没有给发散输入添加伪造的默认值。

# 自然语言 ↔ Lean 映射

- “程序最终输出” ↔ `ProgramOutput program input output`。
- “某输入未定义” ↔ 不存在任何 `output` 使图像关系成立。
- “同一输入至多一个输出” ↔ `SingleValued graph`。
- “程序精确实现图像” ↔ `ComputesPartialFunction program graph` 中的双向等价。
- “关系部分可计算” ↔ `PartialNatComputable graph`。
- “总函数的图像” ↔ `totalFunctionGraph f`。
- “总可计算嵌入部分可计算” ↔ `natComputable_implies_partial`。

# 依赖（人话版）

依赖上一批 `NatProgram`、一元输入解释器、总函数计算定义和输出唯一性。没有调用 mathlib 的另一套
部分递归函数体系；这使本条与已有 `BinaryMachine` 执行语义保持同一条公开定义链。

# 应用与陷阱

这一接口适合描述“程序在输入上停机并输出什么”，也是之后通用解释和对角关系的语言。注意
`PartialNatComputable` 的对象是带单值证明的关系性质，不是 Lean 的 `ℕ → Option ℕ` 可执行函数；
没有输出表示发散，而不是返回 `none` 这一有限计算结果。总可计算性的嵌入只有一个方向，本条没有
声称每个部分可计算关系都能补成总可计算函数。
