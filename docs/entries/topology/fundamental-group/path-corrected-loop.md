---
id: topology.fundamental-group.path-corrected-loop
family: topology.fundamental-group
variant: connector-corrected-loop-telescope
kind: definition
state: verified
title: 道路段的基点修正环路与有限望远镜公式
summary: 用端点连接道路闭合道路段，并把有限修正环路乘积化为整条拼接道路的修正环路
premises: [topology.fundamental-group.carrier-standard]
mathlib: [Path, Path.concat, FundamentalGroup.fromPath, Fin.dfoldl]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

道路细分后，每一段通常并不是以公共基点为端点，因而不能直接表示基本群元素。选取从公共基点到
各分点的连接道路，就能把每段闭合成基点环路；有限乘积中的相邻连接道路应当逐一消去。本条目把
这一通用语言从任何具体开覆盖或 van Kampen 论证中独立出来。

# 直觉

道路段从 `z` 到 `w`，先沿 `left` 从基点走到 `z`，再走该段，最后沿 `right` 的反向从 `w` 回到
基点。两个相邻道路段使用同一条中间连接道路时，前一个修正环路末尾与后一个修正环路开头形成
一对逆道路；在端点固定同伦类中消去后，只剩两段拼接所得的修正环路。

# 陈述（自然语言）

给定道路段及其两端的基点连接道路，可以构造一个基点环路。相邻两段对应的基本群元素按道路拼接
约定相乘，等于两段拼接后的修正环路元素。对任意有限道路段链反复使用该等式，全部内部连接道路
消去，所得有限乘积等于整条 `Path.concat` 的修正环路元素。

# 陈述（Lean 对照）

```lean
def Path.correctedLoop (left : Path x₀ z) (segment : Path z w)
    (right : Path x₀ w) : Path x₀ x₀

theorem Path.correctedLoop_product ... :
    FundamentalGroup.fromPath ⟦correctedLoop middle second right⟧ *
      FundamentalGroup.fromPath ⟦correctedLoop left first middle⟧ =
    FundamentalGroup.fromPath ⟦correctedLoop left (first.trans second) right⟧

def Path.correctedLoopWord ... : FundamentalGroup X x₀
theorem Path.correctedLoopWord_eq_concat ... :
    correctedLoopWord q F connector =
      FundamentalGroup.fromPath
        ⟦correctedLoop (connector 0) (Path.concat q F) (connector (Fin.last n))⟧
```

# 思维脉络（thinking trace）

二段公式先把基本群乘法展开为道路同伦类拼接，再用拼接结合律让中间连接道路的反向与正向相邻，
最后消去这对逆元。有限公式对段数归纳：零段化为常值道路；后继步同时展开依赖折叠的最后一项和
`Path.concat` 的最后一段，再调用二段公式完成唯一的望远镜步骤。

# 自然语言 ↔ Lean 映射

左、右连接道路分别是 `left`、`right`；要闭合的道路段是 `segment`；单个闭合环路是
`Path.correctedLoop`。分点列为 `q`，第 `i` 段为 `F i`，连接道路族为 `connector`；有限乘积是
`correctedLoopWord`，其整体道路是 `Path.concat q F`。

# 依赖（人话版）

Mathlib 的 `Path.trans`、`Path.symm` 提供道路拼接和反向，`Path.Homotopic.Quotient` 负责端点固定
同伦商，`FundamentalGroup.fromPath` 把基点环路送入基本群，`Fin.dfoldl` 表达依赖端点的有限乘积。
Mathlib 当前没有已经封装好的 connector-corrected loop 或相应有限 telescope 接口。

# 应用与陷阱

基本群乘法约定与函数书写顺序容易造成乘积次序误判；这里的公式次序由 Mathlib 的
`FundamentalGroup.mul_def` 固定。连接道路无需唯一，不同选择通常需要额外比较定理。本模块不依赖
开覆盖、道路连通、Pushout 或 van Kampen 假设，也不包含一般的 `map_reverseDfoldl` 代数引理。
