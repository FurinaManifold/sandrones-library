# Topology handoff：AT1-VK3b-14b global block-chain telescope

## Scope and gate

- branch target: `codex/topology-foundations`；
- dependency: subject `d80f8d9` / formal 14a；
- synchronized Main baseline: `2283535`；
- permission: automatic release train item 6；
- formal slice: one source, one Entry, this handoff；
- frozen in this commit: 14c word identification、residual gauge、15、kernel、injectivity、final equivalence。

## Files and import

- `SandronesLibrary/Topology/VanKampenGlobalBlockTelescope.lean`；
- `docs/entries/topology/fundamental-group/van-kampen-global-block-telescope.md`；
- `docs/handoffs/topology-van-kampen-global-block-telescope-at1-vk3b-14b.md`。

源码只 import `SandronesLibrary.Topology.VanKampenLetterBlockTelescope`。不修改共享 import、Registry、
ROADMAP、RADAR 或 Playbook。

## Concept inventory

| 概念 | 教材含义 | Lean 承载 | 分类 | 消费者 | 边界 |
|---|---|---|---|---|---|
| letter block chain | 原 letters 作为第二层 factors | `EdgeChain` list | 稳定数据 | 14c/15 | 尚未恢复原 word |
| framed block chain | 每 block 的 actual fine-edge product | `EdgeChain` list | 中间公开桥 | 14c | factors 已单 block telescope |
| flattened fine chain | 全部真实细边按全局行顺序 flatten | list flatten | 网格桥 | 14c | 仍反序读取 |
| second telescope | 消去全部 block seam frames | `reverseEdgeChainProduct` 等式 | 本批出口 | 14c | 保留首末 frames |

## Public surface: 6 public / 2 private

公开六项（均在 `PathConcatAlignedSquareSubdivision` namespace）：

1. `leftBoundaryLetterBlockChain`；
2. `leftBoundaryFramedBlockChain`；
3. `leftBoundaryAllFramedCellEdgeChain`；
4. `reverseAllFramedCellEdges_eq_framedBlocks`；
5. `reverseAllFramedCellEdges_eq_gridLeftBoundaryWord`；
6. `leftBoundaryFramedBlocks_eq_rebaseLetterChain`。

private 两项：`reverse_flatten_prod`、`rebasedLetterBlockChain_eq_framedBlocks`。

## Semantic audit

`reverse_flatten_prod` 在任意非交换群中验证“两层反序”次序：先 flatten 后整体 reverse/product，等于
每 block reverse/product 后再反转 block 列表并 product。源码不调用交换律。

第二层 letter/framed chains 使用相同 block end frames。14a 的显式 telescope 提供逐项 factor rebase，
13c 的 block cocycle 提供相邻 start/end frame 相容，通用 edge-chain telescope 最终只留下整个 chain
的首末 frames。actual-grid bridge真实使用 14a 保留公开的
`rightAnchoredFramedLeftBoundaryCellEdge_eq_rowLeftEdge`。

## Verification

```text
lake build SandronesLibrary.Topology.VanKampenGlobalBlockTelescope
✔ [1772/1772] Built SandronesLibrary.Topology.VanKampenGlobalBlockTelescope
Build completed successfully (1772 jobs).
```

- 目标构建 zero warnings；
- grid-left-boundary bridge 与第二层 telescope 主定理的公理均为
  `[propext, Classical.choice, Quot.sound]`；
- 未修改的 14c 真实消费者
  `/tmp/sandrones-library/vk3b-14-formal-candidate/SandronesLibrary/Topology/VanKampenRebasedLetterWord.lean`
  直接对正式 14b 编译，exit code 0、无输出；
- 表面严格为 6 public / 2 private；
- placeholder、新 `axiom`、carrier/instance/notation/import 与 `git diff --check` 扫描通过。

## Honest boundary

本批不将 letter block chain product 识别为原输入字母词，不证明完整网格左边界导致的 rebased word
等于一，不消去 residual frames，也不证明 kernel triviality、规范同态 injectivity 或最终 van Kampen
equivalence。
