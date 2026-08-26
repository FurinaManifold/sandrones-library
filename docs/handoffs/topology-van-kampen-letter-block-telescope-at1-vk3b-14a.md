# Topology handoff：AT1-VK3b-14a single-letter block telescope

## Scope and gate

- branch target: `codex/topology-foundations`；
- synchronized Main baseline: `2283535` via current merge；
- dependencies: subject `ba38e35`、`ad063a3`、`25bbba0` / formal 13a--13c；
- permission: automatic release train item 6 opens 14a--14c after 11--12 enter main；
- formal slice: one source, one Entry, this handoff；
- frozen in this commit: 14b/14c、global block chain、full left-boundary word、residual gauge、15、kernel、
  injectivity、final equivalence。

## Files and import

- `SandronesLibrary/Topology/VanKampenLetterBlockTelescope.lean`；
- `docs/entries/topology/fundamental-group/van-kampen-letter-block-telescope.md`；
- `docs/handoffs/topology-van-kampen-letter-block-telescope-at1-vk3b-14a.md`。

源码只 import `SandronesLibrary.Topology.VanKampenBlockBoundaryCocycle`。不修改共享 import、Registry、
ROADMAP、RADAR 或 Playbook。

## Concept inventory

| 概念 | 教材含义 | Lean 承载 | 分类 | 消费者 | 边界 |
|---|---|---|---|---|---|
| combined frames | cell-to-letter 与 right-anchored frames 的端点乘积 | 两个 Pushout 元素 definitions | 稳定数据 | 14b/15 | inner * outer 次序 |
| block edge chain | 单 letter block 的 factors/end frames | 既有 `EdgeChain` | 稳定数据 | 14b | 反序读取 |
| actual framed chain | 二维网格真实左端 cell edges | `EdgeChain` | 网格桥 | 14b | 不另造 factor |
| one-block telescope | 全部细边压缩为一个 rebased letter | `reverseEdgeChainProduct` 等式 | 本批出口 | 14b | 不跨 block |

## Public surface: 9 public / 10 private

公开九项（均在 `PathConcatAlignedSquareSubdivision` namespace，除去此前缀）：

1. `leftBoundaryCombinedStartFrame`；
2. `leftBoundaryCombinedEndFrame`；
3. `leftBoundaryBlockEdgeChain`；
4. `rightAnchoredFramedLeftBoundaryCellEdge_eq_rowLeftEdge`；
5. `leftBoundaryFramedCellEdgeChain`；
6. `leftBoundaryCombinedFrames_adjacent`；
7. `leftBoundaryCombinedBlockFrames_adjacent`；
8. `leftBoundaryFramedCellEdges_eq_rebaseLetter`；
9. `leftBoundaryFramedCellEdges_eq_rebaseLetter_explicit`。

十个 private：

1. `leftBoundaryBlockFactor`；
2. `rightAnchoredFramedLeftBoundaryCellEdge`；
3. `leftBoundaryBlockEdgeChain_length`；
4. `rightAnchoredFramedLeftEdge_eq_rebaseBlockFactor`；
5. `rightAnchoredFramedLeftEdge_eq_rebaseNamedBlockFactor`；
6. `rebasedLeftBoundaryBlockEdgeChain_eq_framedCellEdges`；
7. `reverseLeftBoundaryBlockEdgeChain_eq_of_gridWord`；
8. `reverseLeftBoundaryBlockEdgeChain_eq_of_letter`；
9. `leftBoundaryBlockEdgeChain_end`；
10. `leftBoundaryFramedCellEdges_eq_rebaseBlockWord`。

`rightAnchoredFramedLeftBoundaryCellEdge_eq_rowLeftEdge` 保持 public 是编译发现的真实 14b 依赖；采用
9/10 修正面，不使用已废止的 8/11 文本审计。

## Semantic audit

每条 actual cell factor 先由 12b 搬到 letter factor，再由 13a 的 nested-rebase 次序合并
cell-to-letter 与 right-anchored frames。13a/13c 保证 block 内及 block seam 的 combined frames
相容。本批只在固定 block 内应用通用 edge-chain telescope，内部 frames 成对消去。

factor 顺序使用 `reverseEdgeChainProduct`，并通过 11a 的 block word 定理恢复输入字母；未使用交换律
或普通正序 `List.prod`。actual-grid bridge 只消费 08b completed-row 投影，不读取 07b prefix 实现。

## Verification

```text
lake build SandronesLibrary.Topology.VanKampenLetterBlockTelescope
✔ [1771/1771] Built SandronesLibrary.Topology.VanKampenLetterBlockTelescope
Build completed successfully (1771 jobs).
```

- 目标构建 zero warnings；
- actual-grid bridge 与显式单 block telescope 主定理的公理均为
  `[propext, Classical.choice, Quot.sound]`；
- 未修改的 14b 真实消费者
  `/tmp/sandrones-library/vk3b-14-formal-candidate/SandronesLibrary/Topology/VanKampenGlobalBlockTelescope.lean`
  直接对正式 14a 编译，exit code 0、无输出；
- 表面严格为 9 public / 10 private；
- placeholder、新 `axiom`、carrier/instance/notation/import 与 `git diff --check` 扫描通过。

## Honest boundary

本批不构造全局 block chain，不证明完整真实左边界词等于原字母词的 rebase，不消去 residual frames，
也不证明 kernel triviality、规范同态 injectivity 或最终 van Kampen equivalence。
