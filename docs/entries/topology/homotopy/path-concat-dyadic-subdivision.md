---
id: topology.homotopy.path-concat-dyadic-subdivision
family: topology.homotopy
variant: left-associated-dyadic-breakpoints
kind: theorem
state: verified
title: Mathlib Path.concat 的 dyadic 分段
summary: 计算左结合 Path.concat 的 dyadic 断点，以共同 dyadic 尺度约束方格细分，并将每个规范子道路与对应输入道路作端点相对同伦
premises: [topology.fundamental-group.van-kampen-letter-word]
mathlib: [Path, Path.concat, Path.subpath, Path.Homotopic, Fin]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

教材常把有限道路拼接画成若干等长时间段，但 Mathlib 的 `Path.concat` 由左结合
`Path.trans` 递归构造，实际断点是 dyadic。van Kampen 网格若不对齐这些真实断点，后续“第
`i` 个细边属于第 `i` 个覆盖成员”的说法就没有正确的参数化依据。

# 直觉

为 `n` 条输入道路取共同尺度 `2^n`，递归记录每个断点的整数分子。旧拼接每增加一条道路就被
压缩到左半区，新终点放在 `1`，所以三个输入的断点分子是 `[0,2,4,8]`，而不是等长三等分。
相邻断点截出的 `subpath` 经端点 transport 后与对应输入道路同伦，并保留其逐点像集约束。

# 陈述（自然语言）

可以把二开集同伦方形细分为任意指定正整数倍数的网格步数，特别可取为 concat dyadic scale 的
倍数。dyadic 断点严格按输入顺序递增，`Path.concat` 在这些断点取得对应顶点。相邻断点间的规范
segment 与对应输入道路端点相对同伦；若输入道路逐点位于集合中，该 segment 也逐点位于其中。
对 van Kampen 字母词，每段还可提升为相应覆盖成员中的基点环路，并与所选基本群代表同伦。

# 陈述（Lean 对照）

```lean
theorem exists_binaryOpenCoverSquareSubdivision_steps_multiple ...
def pathConcatDyadicScale ...
theorem pathConcatDyadicScale_pos ...
theorem exists_binaryOpenCoverSquareSubdivision_concat_multiple ...
def pathConcatBreakpointNumerator ...
theorem pathConcatBreakpointNumerator_last ...
theorem pathConcatBreakpointNumerator_strictMonoAdjacent ...
def pathConcatBreakpoint ...
theorem pathConcatBreakpoint_last ...
theorem Path.concat_breakpoint_apply ...
def Path.concatDyadicSegment ...
theorem Path.concatDyadicSegment_homotopic ...
theorem Path.concatDyadicSegment_mem ...
theorem coe_binaryOpenCoverBasepoint ...
def binaryVanKampenLetterDyadicSegmentInPiece ...
```

# 思维脉络（thinking trace）

先由紧方形的 Lebesgue number 选择足够细的网格，再把步数替换成指定正整数与原步数的乘积。
breakpoint numerator 按 concat 递归定义，并对 `Fin.lastCases` 证明上界和相邻严格递增。
道路部分把 `Path.trans` 的左右半区分别还原为旧 concat 与末条道路，再按输入数归纳证明 segment
同伦和像集保持。最后把字母 segment 的逐点成员证明封装到覆盖成员子类型中。

# 自然语言 ↔ Lean 映射

网格倍数约束由 `exists_binaryOpenCoverSquareSubdivision_steps_multiple` 和
`exists_binaryOpenCoverSquareSubdivision_concat_multiple` 给出。尺度、整数分子与实际断点分别是
`pathConcatDyadicScale`、`pathConcatBreakpointNumerator`、`pathConcatBreakpoint`。
三者的正性／末端计算规则分别由 `pathConcatDyadicScale_pos`、
`pathConcatBreakpointNumerator_last`、`pathConcatBreakpoint_last` 公开，供后续 aligned grid
直接复用而不重复展开递归定义。
`Path.concatDyadicSegment` 是正式 segment；其同伦和像集性质分别是
`concatDyadicSegment_homotopic`、`concatDyadicSegment_mem`。字母覆盖成员中的提升及代表同伦由
`binaryVanKampenLetterDyadicSegmentInPiece*` 给出；`coe_binaryOpenCoverBasepoint` 则明确说明依赖
覆盖成员中的 Bool 基点强制回环境空间后就是原基点，供后续边界计算复用。

# 依赖（人话版）

道路、左结合拼接、子道路和端点相对同伦直接复用 Mathlib `Path` API，是语义一致的正式承载；
本库不重造道路结构或等长分段接口。方格细分复用 VK3a 的
`BinaryOpenCoverSquareSubdivision`，字母环路复用 VK3b-09。纯 dyadic 算术和道路 segment 不要求
覆盖；只有细分存在性要求两个覆盖成员开放且方形像逐点落入其并。

# 应用与陷阱

三个输入道路的 block 长度按共同分母为 `2,2,4`，不能替换为三个 `1/3`。本条目只产生 dyadic
segment 和可整除网格步数，尚未建立 block-local 到全局细边索引的 aligned certificate；该责任属于
VK3b-10b。本层也没有比较方格 cell 标签与字母标签，更没有证明 kernel 消失、规范同态单射或最终
van Kampen 同构。
