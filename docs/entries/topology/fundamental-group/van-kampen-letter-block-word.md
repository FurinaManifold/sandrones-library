---
id: topology.fundamental-group.van-kampen-letter-block-word
family: topology.fundamental-group
variant: aligned-fine-edge-word-recovery
kind: theorem
state: verified
title: van Kampen 字母 block 的细边词恢复
summary: 在一个输入字母指定的覆盖成员内连接 aligned block 的细网格顶点，将全部 connector-corrected 细边组成基本群词，并证明该词严格恢复原输入字母
premises: [topology.fundamental-group.van-kampen-concat-aligned-subdivision]
mathlib: [Path, Path.subpath, Path.Homotopic, FundamentalGroup, IsPathConnected, Fin]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

10b 已把输入字母的 dyadic block 对齐到零同伦方格的真实左边界网格，但后续不能只知道每条细边
位于正确覆盖成员：还必须把这些细边重新组合成该成员基本群中的词，并证明它没有改变原输入字母。
这是把几何网格边界重新识别为原 Pushout 字母词的第一步。

# 直觉

固定一个字母 block，在该字母指定的覆盖成员内，从公共基点分别连接到每个细网格顶点。每条细边
前后接上两端 connector，就成为以公共基点为端点的 corrected loop。按既有约定反序相乘这些
corrected loops，中间 connectors 望远镜消去，剩下整块 dyadic segment。这个 segment 已在 09 中
证明代表原字母选择的基本群元素，因此整个细边词严格等于原字母。

# 陈述（自然语言）

每个字母 block 的局部网格顶点和相邻细边都可在该字母指定的覆盖成员中构造。若两个覆盖成员道路
连通，则可选择从公共基点到各顶点的内部 connectors，并把首末 connector 规范取为常值道路。
由这些数据形成的 corrected-loop word 等于整块细边拼接所代表的基本群元素，进而等于该 block
对应的原输入字母。

# 陈述（Lean 对照）

```lean
def binaryVanKampenLetterBlockGridVertex ...
def binaryVanKampenLetterBlockGridConnector ...
def binaryVanKampenLetterBlockGridEdgeInPiece ...
def binaryVanKampenLetterBlockGridWord ...

theorem binaryVanKampenLetterBlockGridWord_eq_concat ...
theorem binaryVanKampenLetterBlockGridWord_eq_letter ...
```

# 思维脉络（thinking trace）

先把 10b 的 lifted dyadic segment 在一致网格点求值，得到覆盖成员 subtype 中的顶点。中间顶点的
connector 由 `IsPathConnected.joinedIn` 选择；首末顶点使用常值道路，以便后续 residual gauge
有规范端点。细边直接复用 `Path.subpath`，不建立平行的道路结构。将这些数据送入通用
`Path.correctedLoopWord` 后，既有 subdivision 定理把有限词化为整个 segment；最后用 09 的
segment-representative 同伦和 `Quotient.sound` 识别基本群类。

# 自然语言 ↔ Lean 映射

细网格顶点、connector、细边和 block word 分别由
`binaryVanKampenLetterBlockGridVertex`、`binaryVanKampenLetterBlockGridConnector`、
`binaryVanKampenLetterBlockGridEdgeInPiece`、`binaryVanKampenLetterBlockGridWord` 承载。
`binaryVanKampenLetterBlockGridWord_eq_concat` 是通用 corrected-word telescope 的公开出口；
`binaryVanKampenLetterBlockGridWord_eq_letter` 完成对原输入字母的恢复。

# 依赖（人话版）

道路、子道路、道路同伦和基本群全部复用 Mathlib 的 `Path`、`Path.subpath`、`Path.Homotopic` 与
`FundamentalGroup`。有限细网格使用 Mathlib `Fin`；成员内部 connector 使用 `IsPathConnected`。
10b 提供 block 长度、aligned mesh 和 lifted dyadic segment，09 提供该 segment 与字母代表道路的
同伦。本层没有另造道路、同伦、基本群或有限拼接承载。

# 应用与陷阱

- 这里恢复的是单个字母 block 的成员基本群元素，不是整个 kernel 字母词已经等于 `1`。
- `letters.reverse` 来自既有 `Path.concat` 与群乘法方向约定，不能擅自改成原列表顺序。
- 首末 connector 的规范常值选择是后续 gauge 消去所需接口，不只是证明内部实现。
- 本层只需 `U`、`V` 道路连通；不需要交集道路连通、开性或 `U ∪ V = univ`。
- dual-label 道路、cell/letter gauge comparison、左边界 transport、telescope、kernel、单射及最终
  van Kampen 同构均属于后续批次。
