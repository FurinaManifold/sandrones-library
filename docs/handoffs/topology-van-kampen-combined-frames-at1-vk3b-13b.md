# Topology handoff：AT1-VK3b-13b combined frames and grid potentials

## Scope and gate

- branch target: `codex/topology-foundations`；
- dependency: subject `ba38e35` / formal VK3b-13a；
- synchronized Main baseline: `a51b751` via `ec88223`；
- permission: automatic release train item 6；
- formal slice: one source, one Entry, this handoff；
- frozen in this commit: 13c block seam、14--15、telescope、kernel、injectivity、final equivalence。

## Files and import

- `SandronesLibrary/Topology/VanKampenCombinedFrames.lean`；
- `docs/entries/topology/fundamental-group/van-kampen-combined-frames.md`；
- `docs/handoffs/topology-van-kampen-combined-frames-at1-vk3b-13b.md`。

源码只 import `SandronesLibrary.Topology.VanKampenLeftBoundaryCocycle`。不修改共享 import、Registry、
ROADMAP、RADAR 或 Playbook。

## Concept inventory

| 概念 | 教材含义 | Lean 承载 | 分类 | 消费者 | 边界 |
|---|---|---|---|---|---|
| combined frame adjacency | 逐边 transport 与 cell frame 合成后相邻 | 群乘积等式 | 本批主桥 | 14 telescope | 只在 block 内 |
| block index adjacency | 相邻 block 首尾细边在全局网格相邻 | `Fin` 严格等式 | 索引桥 | 13c | 不含 connector cocycle |
| internal-edge potentials | 四方向真实内部边 transition 的统一角 potential 公式 | 既有 grid-cell potentials | 稳定接口 | 14c residual gauge | common/switch 私有化 |
| block connector endpoints | 首末 letter connectors 送回环境后为基点 | 两条 simp theorem | 端点桥 | 13c/15 | 不证明两 connector 相等 |

## Public surface: 10 public / 12 private

公开十项：

1. `PathConcatAlignedSquareSubdivision.combinedLeftBoundaryFrames_adjacent`；
2. `pathConcatSegmentGridEdgeIndex_block_adjacent`；
3. `PathConcatAlignedSquareSubdivision.segmentGridEdgeIndex_block_adjacent`；
4. `PathConcatAlignedSquareSubdivision.rightAnchoredBlockFrames_adjacent`；
5. `BinaryOpenCoverSquareSubdivision.verticalInternalEdgeTransitions_end_eq_gridCellPotentials`；
6. `BinaryOpenCoverSquareSubdivision.horizontalInternalEdgeTransitions_start_eq_gridCellPotentials`；
7. `BinaryOpenCoverSquareSubdivision.horizontalInternalEdgeTransitions_end_eq_gridCellPotentials`；
8. `BinaryOpenCoverSquareSubdivision.verticalInternalEdgeTransitions_start_eq_gridCellPotentials`；
9. `PathConcatAlignedSquareSubdivision.coe_leftBoundaryBlockLastLetterEnd`；
10. `PathConcatAlignedSquareSubdivision.coe_leftBoundaryBlockFirstLetterStart`。

十二个 private（均在 `BinaryOpenCoverSquareSubdivision` namespace）：

1. `verticalSwitchEdgeTransitions_start_eq_comparisonPotentials`；
2. `verticalCommonEdgeTransitions_end_eq_gridCellPotentials`；
3. `verticalSwitchBottom_endPotential_eq_gridCellPotential`；
4. `verticalSwitchTop_endPotential_eq_gridCellPotential`；
5. `horizontalCommonEdgeTransitions_start_eq_gridCellPotentials`；
6. `horizontalSwitchLeft_startPotential_eq_gridCellPotential`；
7. `horizontalSwitchRight_startPotential_eq_gridCellPotential`；
8. `horizontalCommonEdgeTransitions_end_eq_gridCellPotentials`；
9. `horizontalSwitchLeft_endPotential_eq_gridCellPotential`；
10. `horizontalSwitchRight_endPotential_eq_gridCellPotential`；
11. `verticalSwitchBottom_startPotential_eq_gridCellPotential`；
12. `verticalSwitchTop_startPotential_eq_gridCellPotential`。

13c/14/15 只消费十个公开出口，不读取十二个 common/switch 分支助手。

## Semantic audit

combined frame 公式真实组合 13a 的
`leftBoundaryCellToLetterTransitions_adjacent` 与 08b 的
`rightAnchoredGridRowFramesAt_vertical_compatible`。全局 block 索引桥证明前 block 的最后细边与后
block 的第一细边严格相邻，而不是依赖自然数值的非 typed 等式。

四个 internal-edge 公式对 common/switch 分类后都回到同一交集点处的相邻格角 potentials。公开签名
保留四方向对称性，因为 14c 的 residual gauge 分别读取其中三项，第四项是同一稳定几何 API；没有
把标签分类泄漏给下游。

## Verification

```text
lake build SandronesLibrary.Topology.VanKampenCombinedFrames
✔ [1769/1769] Built SandronesLibrary.Topology.VanKampenCombinedFrames
Build completed successfully (1769 jobs).
```

- 目标构建 zero warnings；
- combined-frame 主定理、代表性 internal-edge potential 定理和 block connector 端点定理的公理均为
  `[propext, Classical.choice, Quot.sound]`；
- 未修改的 13c 真实消费者
  `/tmp/sandrones-library/vk3b-13-formal-candidate/SandronesLibrary/Topology/VanKampenBlockBoundaryCocycle.lean`
  直接对正式 13b 编译，exit code 0、无输出；
- 表面严格为 10 public / 12 private；
- placeholder、新 `axiom`、carrier/instance/notation/import 与 `git diff --check` 扫描通过。

## Honest boundary

本批不建立跨 block transition cocycle，不执行 block/global telescope，不证明 residual gauge 消失、
kernel triviality、规范同态 injectivity 或最终 van Kampen equivalence。
