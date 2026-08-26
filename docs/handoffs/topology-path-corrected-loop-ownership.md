# Topology infrastructure handoff：修正环路语言归位

## 范围与权限

- Main 基线：`cbd4bc5`，由分支同步提交承接。
- 权限来源：`review-inbox/topology/main-679dc3f-infrastructure-and-r3a-open.md` 与
  `main-cbd4bc5-first-two-infrastructure-accepted.md`。
- 本批只把既有四个 `Path.correctedLoop*` 声明从 VK2 移到中性模块；没有改名、alias、复制实现或
  新数学结论。`Path.map_reverseDfoldl` 明确保留在 VK2。

## 文件与所有权变化

- 新增 `SandronesLibrary/Topology/PathCorrectedLoop.lean`，成为四个声明的唯一所有者。
- `VanKampenSurjectivity.lean` 删除原声明并 import 中性模块；其余证明保持原结构。
- 新增 Entry `topology.fundamental-group.path-corrected-loop`。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接下游消费者 |
|---|---|---|
| `Path.correctedLoop` | 用两端 connector 把道路段闭合为基点环路 | VK2 的分段词与满射证明；VK3b-01 单格边；后续边与核词模块 |
| `Path.correctedLoop_product` | 两个相邻修正环路消去公共 connector | `correctedLoopWord_eq_concat`；VK3b 公共边 telescope |
| `Path.correctedLoopWord` | 有限道路段链的修正环路乘积 | VK2 `correctedLoopWord_eq_loop`；后续有限边界词模块 |
| `Path.correctedLoopWord_eq_concat` | 有限修正词等于整体 concat 的修正环路 | VK2 `correctedLoopWord_eq_loop`；后续 kernel/block word 模块 |

四项都具有真实跨模块消费者，保持公开。它们只要求拓扑空间、道路、有限拼接和基本群，不含覆盖、
Bool 标签、Pushout 或 van Kampen 假设。

## 概念清单与公开签名扫描

| 概念 | 教材语义 | Lean 正式承载／刻画 | 复用或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 基点修正环路 | connector、道路段、逆 connector 的依次拼接 | 本库 `Path.correctedLoop`，定义展开为 `left.trans (segment.trans right.symm)` | Mathlib 缺少该封装；复用其 `Path.trans/symm` | `correctedLoop_product` | `topology.fundamental-group.path-corrected-loop` |
| 修正环路有限词 | 各段修正环路元素的有序有限乘积 | 本库 `Path.correctedLoopWord`，以 `Fin.dfoldl` 展开 | Mathlib 缺少该 telescope；复用基本群乘法 | `correctedLoopWord_eq_concat` 与 VK2 | 同上 |
| 道路同伦商与基本群 | 基点环路按端点固定同伦取商并以拼接相乘 | Mathlib `Path.Homotopic.Quotient`、`FundamentalGroup.fromPath` | 与已登记基本群承载语义一致，直接复用 | `correctedLoop_product` | `topology.fundamental-group.carrier-standard` |

公开签名中的 `Path`、`FundamentalGroup`、`Fin` 均是已经解释的正式承载；`Path.concat` 与
`Fin.dfoldl` 是有限拼接／折叠的实现及公开刻画工具，没有暴露覆盖专用结构或更高层 typeclass。
同伦商的具体 `Quotient` 操作只出现在证明体，归为私有证明后端。没有全局实例、bridge alias 或
语义未核对的 Mathlib structure 泄漏。

## Mathlib 复用与 tactic-state 说明

固定 Mathlib 中已有道路反向、拼接、端点固定同伦商、基本群和有限依赖折叠，但没有 connector 修正
环路及其 telescope 封装。`correctedLoop_product` 的首个 `rw` 把群乘积等式改写为同伦类拼接等式；
结合律重写暴露中间 connector 的逆道路对，末尾 `simp` 只做该逆元消去。有限定理对段数归纳，零分支
识别空 concat；后继分支展开折叠与 concat 的最后一段，归纳假设替换前缀，最后明确调用二段公式。

## 验证

- 联合构建 `PathCorrectedLoop`、VK2、VK3a、VK3b-01：1750 jobs 通过。
- 正式 import 路径下的临时 aggregate 同时检查四个中性 API、VK2
  `correctedLoopWord_eq_loop` 与 VK3b-01 `gridCellPushoutEdgeWord_eq_one`，通过后已删除。
- `correctedLoop_product`、`correctedLoopWord_eq_concat` 及上述 VK3b-01 出口的公理集合均只有
  `propext`、`Classical.choice`、`Quot.sound`。
- `map_entry_to_decl` 精确映射本 Entry 的四个公开声明；Markdown id、源码 marker 和拟登记 id
  一致，唯一 `lean_file` 为 `Topology/PathCorrectedLoop.lean`。
- 全库源码声明搜索确认四个声明只由中性模块拥有；`map_reverseDfoldl` 只保留在 VK2。
- 禁用项扫描、`git diff --check` 通过。

本批是三个独立 ownership move 中第三项；不包含 VK3b 新数学内容或 T4-R3a。
