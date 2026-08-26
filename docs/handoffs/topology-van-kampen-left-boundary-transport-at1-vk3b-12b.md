# Topology handoff：AT1-VK3b-12b left-boundary cell-to-letter transport

## Scope and gate

- branch target: `codex/topology-foundations`；
- synchronized Main baseline: `17cf24d`，merge commit `e41649b`；
- dependency: Main `2498e98`，正式 VK3b-12a；
- permission: `docs/ROADMAP-LONGTERM.md` 将 VK3b-12b 标为 `development_open`；
- formal slice: one source, one Entry, this handoff；
- frozen: VK3b-13--15、global telescope、kernel、injectivity、final equivalence。

## Files and import

- `SandronesLibrary/Topology/VanKampenLeftBoundaryTransport.lean`；
- `docs/entries/topology/fundamental-group/van-kampen-left-boundary-transport.md`；
- `docs/handoffs/topology-van-kampen-left-boundary-transport-at1-vk3b-12b.md`。

源码只 import `SandronesLibrary.Topology.VanKampenLeftBoundaryEdge`，没有修改共享 import、Registry、
ROADMAP、RADAR 或 Playbook。

## Concept inventory

| 概念 | 教材含义 | Lean 承载 | 分类 | 消费者 | 边界 |
|---|---|---|---|---|---|
| endpoint transitions | 从 cell connectors 切换到 letter connectors 的两端群元素 | 既有 `EdgeTransitions` | 正式承载复用 | 13 cocycle、14 telescope | 不是新 comparison carrier |
| transition potentials | 两套 connectors 相对统一交集坐标的 potential 商 | `transitionFromPotentials` | 本批刻画 | 相邻端点相容 | 不把群当交换群 |
| local transport | 同一真实道路的两套局部基本群元素比较 | `rebaseEdge` | 本批核心定理 | factor transport | 起终点变化次序固定 |
| factor transport | grid 左边界 factor 与 letter block factor 的逐边关系 | 12a 两个 `_Element_eq` 后的改写 | 稳定出口 | 13--14 | 尚未相乘 |

## Public surface: 9 public / 4 private

公开九项：

1. `PathConcatAlignedSquareSubdivision.leftBoundaryCellToLetterTransitions`；
2. `...leftBoundaryCellToLetterTransitions_start_potential_of_ne`；
3. `...leftBoundaryCellToLetterTransitions_end_potential_of_ne`；
4. `...leftBoundaryCellToLetterTransitions_end_eq_intersectionPotentials`；
5. `...leftBoundaryCellToLetterTransitions_start_eq_intersectionPotentials`；
6. `...leftBoundaryCellEndPotential_eq_gridCellPotential`；
7. `...leftBoundaryCellStartPotential_eq_gridCellPotential`；
8. `...leftBoundaryCellToLetter_relation`；
9. `...leftBoundaryCellEdgeToBlockFactor_relation`。

以上省略号均为 namespace `PathConcatAlignedSquareSubdivision`。四个 private：

1. `...leftBoundaryCellToLetterTransitions_start_potential_of_eq`；
2. `...leftBoundaryCellToLetterTransitions_end_potential_of_eq`；
3. `binaryOpenCoverSamePathComparison_left_pushout_eq`；
4. `binaryOpenCoverSamePathComparison_right_pushout_eq`。

九个公开项构成“定义—两分支计算—统一 potential—grid potential—局部关系—真实 factor 关系”的
线性消费者链。四个 private 只负责相等标签分支展开和 same-path Pushout 消元。

## Semantic audit

定义按 cell 标签与 letter 标签是否相等选择 same-path 或 dual-path comparison，但两个分支都返回
`EdgeTransitions (binaryVanKampenPushout ...)`。异标签时通过两侧交集 comparison potentials 得到
transition；同标签时比较同一成员内的两套 connectors。统一 potential 定理消去 Bool 分支，随后
cell-side potentials 被识别为既有 grid-cell potentials。

核心关系严格为

```text
cellElement = rebaseEdge T.startChange T.endChange letterElement
            = T.endChange⁻¹ * letterElement * T.startChange.
```

最终 factor theorem 真实使用 12a 的 cell/letter element equality；没有用一个孤立抽象群等式代替
网格消费者。源码没有新增 carrier、instance、notation、Path、基本群或 Pushout。

## Verification

```text
lake build SandronesLibrary.Topology.VanKampenLeftBoundaryTransport
exit code 0
```

- 正式源码逐字迁自已在 `/tmp/sandrones-library/vk3b-12-formal-candidate/` 对 12a 验证的候选，仅补
  标准文件头和模块边界说明；
- 独立 aggregate import 正式模块并 `#check` 12a/12b 主要消费者，exit code 0；
- 未修改的 13a 真实消费者
  `/tmp/sandrones-library/vk3b-13-formal-candidate/SandronesLibrary/Topology/VanKampenLeftBoundaryCocycle.lean`
  直接对正式 12b 执行 `lake env lean`，exit code 0、无输出；
- `rg` 计数为 9 public / 4 private；
- `sorry`、`admit`、新增 `axiom`、carrier/instance/notation 与 `git diff --check` 扫描通过；
- 目标构建没有 warning。

## Honest boundary

本批只建立每条左边界细边的 transport。它不证明相邻细边的 end/start potentials 相同，不处理
letter block 接缝，不对全部 factors 作有限乘积。因此 residual gauge、kernel triviality、规范同态
injectivity 与最终 van Kampen equivalence 均未提交，等待 Main 按依赖开放 VK3b-13--15。
