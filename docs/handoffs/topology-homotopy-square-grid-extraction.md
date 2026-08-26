# Topology handoff：共享道路同伦方格网格基础层抽取

## Scope and permission

- branch: `codex/topology-foundations`；
- Main baseline: `346bf00`；同步合并提交为 `55cc854`；
- permission: `review-inbox/topology/main-8543797-vk3b15-accepted-r3b-open.md` 与
  `main-961f4a6-permissions-expanded.md` 要求先迁移 shared square-grid foundation；
- 本提交只迁移既有公开声明的所有权，不改变名称、签名或证明内容。

不修改 `SandronesLibrary.lean`、Registry、ROADMAP、RADAR、Playbook 或自动生成索引。Main 集成时应
新增 Entry 登记与顶层 import，并重生成派生文件。

## Files and Entry ownership

- 新增 `SandronesLibrary/Topology/HomotopySquareGrid.lean`；
- 修改 `VanKampenSquareSubdivision.lean`：复用新基础层，删除原地 `unitSquareCellPoint`；
- 修改 `VanKampenHomotopySquareBoundary.lean`：复用新基础层，删除原地同伦方形、网格顶点、格边与
  四条外边识别声明；
- 新增 `docs/entries/topology/homotopy/homotopy-square-grid.md`；
- 更新 square-subdivision 与 cell-boundary 两篇 Entry 的 premise 和自然语言所有权；
- 本 handoff。

新 Entry `topology.homotopy.homotopy-square-grid` 独占 13 项公开声明；既有
`van-kampen-square-subdivision` 与 `van-kampen-cell-boundary` 在迁移后分别独占 4 项和 28 项。

## Concept inventory

| 概念 | 教材语义 | Lean 正式承载 | 展开／一手性质 | Mathlib 角色 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 端点相对道路同伦 | 连续道路族且两端始终固定 | Mathlib `Path.Homotopy` | `pathHomotopySquare` 与四侧 simp 规则 | 语义一致的正式承载 | 外边网格识别 | `topology.homotopy.homotopy-square-grid` |
| 同伦参数方形 | 第一坐标为同伦参数，第二坐标为道路参数 | `ContinuousMap` 包装 `pathHomotopySquare` | 四侧计算规则 | `ContinuousMap` 为正式承载 | square subdivision | 同上 |
| 一致方格 | 两轴共享 `i/N` 网格 | `squareGridVertex`、`unitSquareCellPoint` | 逐坐标 `Icc.convexComb` | 凸组合为正式参数化运算 | labelled subdivision | 同上 |
| 有向格边 | 横边向右、竖边向上 | Mathlib `Path` | 四条外边识别定理 | `Path` 为正式承载 | cell boundary | 同上 |

这些 Mathlib 名称都在公开签名中承担与教材一致的正式对象层角色；没有越级泄漏。证明体的 `fun_prop`
和 subtype simp 只是私有后端。新模块没有建立重复 carrier、instance 或 notation。

## Signature preservation and consumers

抽取的 13 项声明全部保留原 namespace、名称、参数次序、返回类型、属性和证明；源码 diff 显示它们
从两个旧模块逐字迁入中性模块，没有兼容别名或第二份定义。跨模块聚合按原类型直接消费全部 13 项；上层
`VanKampenSquareSubdivision`、`VanKampenHomotopySquareBoundary` 及最终 `VanKampenTheorem` 无需调用方
迁移。新中性模块同时是获准迁移的 R3b A/B/D 批次的稳定基础。

## Verification

已执行：

- `lake build SandronesLibrary.Topology.HomotopySquareGrid`：1657 jobs，通过；
- `lake build SandronesLibrary.Topology.VanKampenTheorem`：1777 jobs，通过，覆盖两个既有消费者的最终
  依赖闭包；
- `/tmp/HomotopySquareGridExtractionAggregate.lean` 同时 `#check` 四项 Mathlib 正式承载、全部 13 项
  基础 API、square subdivision、cell boundary 和最终 van Kampen 等价，通过；
- `scripts.check_axioms.map_entry_to_decl` 精确得到 13 / 4 / 28，没有跨 Entry 吸入；
- 聚合对方形定义、两类格边、外边识别、单格关系和最终 van Kampen 等价执行 `#print axioms`；
- placeholder、新 `axiom`、冲突标记扫描与 `git diff --check` 通过。

所检查公开声明的公理集合均为 `[propext, Classical.choice, Quot.sound]`。

## Honest boundary

本批只是无语义变化的共享基础层抽取。它不新增 van Kampen 数学结果，也不证明连续同伦下的道路积分
不变性；后者仍须按 Main 开放的 A--F 独立批次完成。这里没有引入已被否决的全局 relative-`C²`
同伦方形签名，也没有声称任意连续方形的网格边自动分片 `C¹`。
