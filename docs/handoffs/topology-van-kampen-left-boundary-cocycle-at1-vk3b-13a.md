# Topology handoff：AT1-VK3b-13a adjacent left-boundary cocycle

## Scope and gate

- branch target: `codex/topology-foundations`；
- synchronized Main baseline: `a51b751`，merge commit `ec88223`；
- dependency: Main `a51b751`，正式 VK3b-12b；
- permission: `main-vk3b08-15-interface-prereview-and-release-train.md` 第 6 条在 11--12 进入 main 后
  自动开放 13a--13c、14a--14c；
- formal slice: one source, one Entry, this handoff；
- frozen in this commit: 13b/13c、combined frames、block seam、14--15、kernel、injectivity、final
  equivalence。

## Files and import

- `SandronesLibrary/Topology/VanKampenLeftBoundaryCocycle.lean`；
- `docs/entries/topology/fundamental-group/van-kampen-left-boundary-cocycle.md`；
- `docs/handoffs/topology-van-kampen-left-boundary-cocycle-at1-vk3b-13a.md`。

源码只 import `SandronesLibrary.Topology.VanKampenLeftBoundaryTransport`。未修改共享 import、Registry、
ROADMAP、RADAR 或 Playbook。

## Concept inventory

| 概念 | 教材含义 | Lean 承载 | 分类 | 消费者 | 边界 |
|---|---|---|---|---|---|
| nested rebase | 两层 connector/frame 变化合并 | `rebaseEdge_rebaseEdge` | 通用群引理 | 13b combined transport | 次序为 inner * outer |
| potential cocycle | 三组 endpoint changes 来自三个共享 potentials | `edgeTransitions_cocycle_of_potentials` | 通用桥 | 四标签分支 | 不假设交换 |
| combined compatibility | transition cocycle 与 cell frame 相容合成 | `combinedVertexFrames_compatible` | frame 桥 | 13b | 不构造 combined frame |
| adjacent-edge cocycle | 同一 block 相邻细边在共享顶点相容 | `leftBoundaryCellToLetterTransitions_adjacent` | 本批几何出口 | 13b/14 | 不跨 block |

## Public surface: 4 public / 12 private

公开四项：

1. `rebaseEdge_rebaseEdge`；
2. `combinedVertexFrames_compatible`；
3. `edgeTransitions_cocycle_of_potentials`；
4. `PathConcatAlignedSquareSubdivision.leftBoundaryCellToLetterTransitions_adjacent`。

十二个 private（均在 `PathConcatAlignedSquareSubdivision` namespace）：

1. `leftBoundaryCellToLetterTransitions_adjacent_of_common_ne`；
2. `leftBoundarySameComparisonTarget_eq_switchSource`；
3. `leftBoundarySameTransitionEnd_eq_switchVertexPotentials`；
4. `leftBoundarySameCellEndPotential_eq_switchBottom`；
5. `leftBoundarySameLetterEndPotential_eq_upperDual`；
6. `leftBoundaryCellToLetterTransitions_adjacent_of_lower_eq`；
7. `leftBoundaryUpperSameComparisonSource_eq_switchTopSource`；
8. `leftBoundaryUpperSameTransitionStart_eq_switchVertexPotentials`；
9. `leftBoundaryUpperSameCellStartPotential_eq_switchTop`；
10. `leftBoundaryUpperSameLetterStartPotential_eq_lowerDual`；
11. `leftBoundaryCellToLetterTransitions_adjacent_of_upper_eq`；
12. `leftBoundaryCellToLetterTransitions_adjacent_of_both_eq`。

四个公开项形成通用 nested rebase、potential cocycle、frame compatibility、真实相邻边 cocycle 的
消费者链。十二个 private 只消解标签四分支和 dependent casts，13b 不读取它们。

## Semantic audit

主定理穷尽上下 cell 标签相对固定 letter 标签的四种情况。上下相同且均异于 letter 时使用 common
vertical transition；mixed 分支将 same comparison 的 endpoint potential 对齐到 switch edge 的对应
上／下格 potential；上下都等于 letter 时在同一成员内直接比较。最终统一得到

```text
lowerT.endChange = upperT.startChange * vertical.startChange.
```

该方向与 12b 的 `end⁻¹ * letter * start` 以及
`transitionFromPotentials_mul` 一致。`rebaseEdge_rebaseEdge` 的组合次序为 `inner * outer`，源码未把
Pushout 当交换群使用。

## Verification

```text
lake build SandronesLibrary.Topology.VanKampenLeftBoundaryCocycle
✔ [1768/1768] Built SandronesLibrary.Topology.VanKampenLeftBoundaryCocycle
Build completed successfully (1768 jobs).
```

- 目标构建 zero warnings；
- `rebaseEdge_rebaseEdge` 公理为 `[propext]`，最终相邻边主定理公理为
  `[propext, Classical.choice, Quot.sound]`；
- 未修改的 13b 真实消费者
  `/tmp/sandrones-library/vk3b-13-formal-candidate/SandronesLibrary/Topology/VanKampenCombinedFrames.lean`
  直接对正式 13a 执行 `lake env lean`，exit code 0、无输出；
- 表面计数严格为 4 public / 12 private；
- placeholder、新 `axiom`、carrier/instance/notation/import 与 `git diff --check` 扫描通过。

## Honest boundary

本批不构造 combined frames，不证明全局网格行相容、block 首末端点或跨 block cocycle，不执行有限
telescope。residual gauge、kernel triviality、规范同态 injectivity 与最终 van Kampen equivalence
均未提交。
