# Topology handoff：AT1-VK3b-13c adjacent block-boundary cocycle

## Scope and gate

- branch target: `codex/topology-foundations`；
- dependency: subject `ad063a3` / formal VK3b-13b；
- synchronized Main baseline: `a51b751` via `ec88223`；
- permission: automatic release train item 6；
- formal slice: one source, one Entry, this handoff；
- frozen in this commit: 14--15、finite telescope、kernel、injectivity、final equivalence。

## Files and import

- `SandronesLibrary/Topology/VanKampenBlockBoundaryCocycle.lean`；
- `docs/entries/topology/fundamental-group/van-kampen-block-boundary-cocycle.md`；
- `docs/handoffs/topology-van-kampen-block-boundary-cocycle-at1-vk3b-13c.md`。

源码只 import `SandronesLibrary.Topology.VanKampenCombinedFrames`。不修改共享 import、Registry、
ROADMAP、RADAR 或 Playbook。

## Concept inventory

| 概念 | 教材含义 | Lean 承载 | 分类 | 消费者 | 边界 |
|---|---|---|---|---|---|
| last block vertex | 前 block 最后细边终点为基点 | 环境 `X` 中等式 | 顶点桥 | 15 kernel | 不等同 subtype proofs |
| first block vertex | 后 block 第一细边起点为基点 | 环境 `X` 中等式 | 顶点桥 | 15 kernel | 不等同 subtype proofs |
| block seam cocycle | 相邻 blocks transitions 与竖直网格 transition 相容 | endpoint group equality | 本批主出口 | 14 telescope | 尚未相乘 |
| connector agreement | 两 letter connectors coercion 后逐点相等 | 环境 Path 点值等式 | 几何刻画 | 接缝审计 | 标签可不同 |

## Public surface: 4 public / 0 private

1. `PathConcatAlignedSquareSubdivision.leftBoundaryBlockLastVertex_eq_basepoint`；
2. `PathConcatAlignedSquareSubdivision.leftBoundaryBlockFirstVertex_eq_basepoint`；
3. `PathConcatAlignedSquareSubdivision.leftBoundaryBlockTransitions_cocycle`；
4. `PathConcatAlignedSquareSubdivision.coe_leftBoundaryBlockLetterConnectors_adjacent`。

四项均有跨批消费者或稳定几何含义；本文件没有 private 声明。

## Semantic audit

首末顶点定理通过 13b 的 connector coercion simp 公式回到环境基点，不伪造不同 subtype 的定义性
等式。主 cocycle 使用 `binaryOpenCoverIntersectionBasepoint` 同时表示下／上 cell 和两个 letter
endpoint；13b 的 vertical start-potential 公式给 grid 侧变化，公共基点 connector potential 等式给
letter 侧变化，最后应用通用 potential cocycle。

最终方向严格为

```text
lowerT.endChange = upperT.startChange * vertical.startChange,
```

与 13a block 内公式相同，因此 14 不需区分细边内部接缝和 letter block 接缝。

## Verification

```text
lake build SandronesLibrary.Topology.VanKampenBlockBoundaryCocycle
✔ [1770/1770] Built SandronesLibrary.Topology.VanKampenBlockBoundaryCocycle
Build completed successfully (1770 jobs).
```

- 目标构建 zero warnings；
- 顶点识别、block cocycle 与 connector agreement 的代表性公理均为
  `[propext, Classical.choice, Quot.sound]`；
- 未修改的 14a 真实消费者
  `/tmp/sandrones-library/vk3b-14-formal-candidate/SandronesLibrary/Topology/VanKampenLetterBlockTelescope.lean`
  直接对正式 13c 编译，exit code 0、无输出；
- 表面严格为 4 public / 0 private；
- placeholder、新 `axiom`、carrier/instance/notation/import 与 `git diff --check` 扫描通过。

## Honest boundary

本批不执行任何有限 factor product 或 telescope，不证明 residual gauge、kernel triviality、规范同态
injectivity 或最终 van Kampen equivalence。
