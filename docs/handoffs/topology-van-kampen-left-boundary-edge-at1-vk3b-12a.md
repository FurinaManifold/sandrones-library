# Topology handoff：AT1-VK3b-12a aligned left-boundary edge

## Scope and gate

- branch target: `codex/topology-foundations`；
- dependency: Main `1cc9446` / latest shared baseline `2c67e3c`，正式 VK3b-11c；
- permission: `main-1cc9446-vk3b11c-accepted-12a-open.md`；
- source preaudit: `main-vk3b12a-source-preaudit-docs-open-one-style-fix.md`；
- formal slice: one source, one Entry, this handoff；
- frozen: 12b transitions/rebase，13--15，kernel、injectivity、final equivalence。

## Files and import

- `SandronesLibrary/Topology/VanKampenLeftBoundaryEdge.lean`；
- `docs/entries/topology/fundamental-group/van-kampen-left-boundary-edge.md`；
- `docs/handoffs/topology-van-kampen-left-boundary-edge-at1-vk3b-12a.md`。

源码只 import `SandronesLibrary.Topology.VanKampenPathGaugeComparison`。

## Concept inventory

| 概念 | 教材含义 | Lean 承载 | 分类 | 消费者 | 边界 |
|---|---|---|---|---|---|
| aligned boundary edge | 方格左边界与字母 block 共用的真实细边 | Mathlib `Path` | 正式承载 | cell/letter lifts | 不重建 grid |
| cell/letter membership | 同一边落在两种标签成员 | 逐点 membership theorem | 本批桥 | subtype paths、12b | 不表示标签相等 |
| endpoint connector | 基点到细边端点的成员内道路 | Mathlib `Path` 加既有 connector APIs | 正式承载组合 | local elements、13 | 四个定义保留 |
| local element | connector-corrected 细边基环路类 | Mathlib `FundamentalGroup` | 正式承载 | 12b relation | 不是新 group carrier |
| grid/block factor | 前序有限词中的已有因子 | 已有 cell/letter factor API | 已验收桥 | 12b、14 | 两个 `_eq` 接回既有词 |

## Public surface: 23 public / 6 private

公开 23 项：

1. `PathConcatAlignedSquareSubdivision.leftBoundaryAlignedGridEdge`；
2. `...leftBoundaryAlignedGridEdge_mem_cellPiece`；
3. `...leftBoundaryAlignedGridEdge_mem_letterPiece`；
4. `...leftBoundaryAlignedGridEdge_cellSource_eq`；
5. `...leftBoundaryAlignedGridEdge_cellTarget_eq`；
6. `...leftBoundaryAlignedGridEdgeCellStart`；
7. `...leftBoundaryAlignedGridEdgeCellEnd`；
8. `...leftBoundaryAlignedGridEdgeLetterStart`；
9. `...leftBoundaryAlignedGridEdgeLetterEnd`；
10. `...leftBoundaryAlignedGridEdgeLetterConnector_adjacent`；
11. `...leftBoundaryCellEnd_eq_verticalSwitchBottomStart`；
12. `...leftBoundaryCellStart_eq_verticalSwitchTopStart`；
13. `...leftBoundaryCellEnd_eq_verticalCommonLeftStart`；
14. `...coe_leftBoundaryCellStart_eq_verticalCommonRightStart`；
15. `...leftBoundaryDualCellEndPotential_eq_gridCellPotential`；
16. `...leftBoundaryDualCellStartPotential_at_sharedVertex`；
17. `...leftBoundaryDualCellEndPotential_eq_verticalSwitchBottom`；
18. `...leftBoundaryDualCellStartPotential_eq_verticalSwitchTop`；
19. `...leftBoundaryDualLetterPotential_adjacent`；
20. `...leftBoundaryAlignedGridEdgeCellElement`；
21. `...leftBoundaryAlignedGridEdgeLetterElement`；
22. `...leftBoundaryAlignedGridEdgeCellElement_eq`；
23. `...leftBoundaryAlignedGridEdgeLetterElement_eq`。

以上省略号均为 namespace `PathConcatAlignedSquareSubdivision`。六个 private：

1. `...leftBoundaryAlignedGridEdge_letterSource_eq`；
2. `...leftBoundaryAlignedGridEdge_letterTarget_eq`；
3. `...leftBoundaryDualCellEndPotential_eq_verticalCommonLeft`；
4. `...leftBoundaryAlignedGridEdgeInCellPiece_eq`；
5. `Path.concatDyadicSegment_apply`；
6. `...leftBoundaryAlignedGridEdgeInLetterPiece_eq`。

23/6 已由 12b--15 完整消费者链验证。四 connectors、两种 membership 和真实 edge 有高扇出，不能在
不迁移下游的情况下私有化；六个 private 仅服务本文件 pointwise/cast 展开。

## Semantic boundary

cell-side 与 letter-side 道路具有不同 subtype 端点，因此通过共同的环境 `Path`、coercion 公式和
endpoint cast 比较，不宣称跨类型道路直接相等。membership 解决 subtype 构造，connectors 解决开放
边变为基环路，local elements 进入基本群；最终两个 `_Element_eq` 才把它们接到既有 grid/block
factors。

12a 没有统一两侧 local elements，也没有定义 transition 或证明 rebase。源码中不应出现 12b 的
`leftBoundaryCellToLetterTransitions` 或 factor relation。

## Verification

```text
lake build SandronesLibrary.Topology.VanKampenLeftBoundaryEdge
✔ [1766/1766] Built SandronesLibrary.Topology.VanKampenLeftBoundaryEdge
Build completed successfully (1766 jobs).
```

- independent aggregate `#check` 全部 23 public names，exit code 0；
- Entry mapper 精确映射 23 项；
- 真实 edge、letter adjacency、cell potential 与两个 element equality 的公理均为
  `[propext, Classical.choice, Quot.sound]`；
- 未修改的 12b `VanKampenLeftBoundaryTransport` candidate 直接对正式 12a 编译，exit code 0、无输出；
- Main 指出的唯一超长 private 声明已按多行格式修复，目标构建 zero warnings；
- placeholder、6 private、carrier/instance/notation/import 与 `git diff --check` 扫描通过。

## Honest boundary

本批不修改共享 imports、Registry、ROADMAP 或 RADAR。不迁入 12b，不证明逐边 rebase、相邻 cocycle、
有限 telescope、residual gauge、kernel triviality、injectivity 或最终 equivalence。
