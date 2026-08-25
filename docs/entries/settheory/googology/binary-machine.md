---
id: settheory.googology.binary-machine
kind: definition
state: verified
title: "二符号有限状态图灵机"
premises: []
mathlib: ["Fin", "Finset"]
provenance: {source_type: book, ref: "rado-non-computable-functions-1962"}
---

# 动机

“Busy Beaver 增长极快”只有在先固定机器规则后才是精确的数学命题。状态怎么算、纸带上有几种
符号、停机发生在什么时候，都会改变具体数值。因此本条先冻结一种最朴素的模型：有限个工作
状态、符号 `0/1`、双向无限纸带和一个额外的停机结果。

# 直觉

可以把机器想成一张有限表格。表格的行是当前状态，列是读写头眼下看到的 `0` 或 `1`；每个格子
写着三件事：覆盖写入哪个符号、向左还是向右走、接下来进入哪个状态或停机。纸带虽然向两边无限，
但从全零纸带运行有限步，只可能改动有限多个格子，所以只记录“目前写着 1 的位置”就够了。

# 陈述（自然语言）

一个 `n` 状态二符号机器为每个工作状态和每个布尔符号指定唯一指令。指令写入一个布尔值，选择
左右移动，并给出可选的新状态；没有新状态表示停机。配置则记录当前状态、整数坐标表示的头位置，
以及所有值为 `1` 的位置组成的有限集。标准初始纸带不含任何 `1`，所以读到 `0`。

# 陈述（Lean 对照）

```lean
inductive HeadMove | left | right
structure Instruction (n : ℕ) where
  writeOne : Bool
  move : HeadMove
  nextState : Option (Fin n)
abbrev BinaryMachine (n : ℕ) := Fin n → Bool → Instruction n
structure Configuration (n : ℕ) where
  state : Fin n
  head : ℤ
  ones : Finset ℤ
theorem readSymbol_initially_blank (state : Fin n) :
  readSymbol ({ state := state, head := 0, ones := ∅ } : Configuration n) = false
```

# 思维脉络（thinking trace）

先把无限纸带默认解释成全零，随后只保存偏离默认值的位置。这样写 `1` 是向有限集插入坐标，写
`0` 是删除坐标；每条指令和每张有限状态表都可判等、可穷举。停机不是工作状态之一，而由
`Option (Fin n)` 的 `none` 表示，因而不会误把停机状态计入题目所说的 `n` 个状态。

# 自然语言 ↔ Lean 映射

- “`n` 个工作状态” ↔ `Fin n`。
- “两个纸带符号” ↔ `Bool`，其中 `false` 是 `0`，`true` 是 `1`。
- “双向纸带位置” ↔ `ℤ`。
- “非零格子有限记录” ↔ `ones : Finset ℤ`。
- “查指令表” ↔ `machine state symbol`。
- “停机出口” ↔ `nextState = none`。

# 依赖（人话版）

只依赖有限类型、布尔值、整数和有限集等基础数据结构。mathlib 提供这些容器，但机器模型、指令
含义和纸带编码都是本库公开定义，不是对现成 Busy Beaver 定义的改名包装。

# 应用与陷阱

这个模型适合从空白纸带做有限模拟和穷举。不要把 `Finset ℤ` 误解成纸带本身有限；有限的是当前
写着 `1` 的位置。不同文献可能允许读写头不移动、使用单向纸带或把停机列作一个状态，所得小规模
数表未必逐项相同，比较数值前必须先核对模型。
