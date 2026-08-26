# Topology handoff：AT1-VK3b-11c path gauge comparison

## Scope and gate

- branch target: `codex/topology-foundations`；
- dependency: Main integration `46b283c`，正式 VK3b-11b；
- permission: `main-46b283c-vk3b11b-accepted-11c-open.md`；
- formal slice: one source, one Entry, this handoff；
- frozen: VK3b-12--15、kernel、单射、最终同构。

本批统一同一几何边的 same-label 和 dual-label 局部表示，止于两条 `rebaseEdge` 公式及方格 endpoint
potential 出口，不进行左边界 telescope。

## Files and import

- `SandronesLibrary/Topology/VanKampenPathGaugeComparison.lean`；
- `docs/entries/topology/fundamental-group/van-kampen-path-gauge-comparison.md`；
- `docs/handoffs/topology-van-kampen-path-gauge-comparison-at1-vk3b-11c.md`。

源码只 import `SandronesLibrary.Topology.VanKampenDualPathPotential`。

## Concept inventory

| 概念 | 教材含义 | Lean 承载 | 分类 | 消费者 | 边界 |
|---|---|---|---|---|---|
| switch edge | 同一边具有不同覆盖标签 | 11b dual path comparison | 已验收桥 | dual rebase、12 | 不宣称标签全局相等 |
| common edge | 同一边在同一覆盖成员中的两套 connectors | `CommonEdgeConnectorComparison` | 已验收通用桥 | same rebase、12 | 不复制 carrier |
| endpoint potential | 更换 connector 的群元素 | 既有 vertex potential | 已验收桥 | 方格 endpoint 公式 | 保留非交换方向 |
| rebase | `e⁻¹ * q * s` | 既有 `rebaseEdge` | 已验收群论桥 | 12 主输入 | 不是 telescope |
| same-path comparison | 同成员两套局部表示 | `binaryOpenCoverSamePathConnectorComparison` 构造既有 carrier | 本批具名桥 | 12--15 | 无新 structure |

## Public surface: 20 public / 4 private

公开 20 项：

1. `BinaryOpenCoverSquareSubdivision.horizontalSwitchLeft_startPotential_eq_vertexPotential`；
2. `BinaryOpenCoverSquareSubdivision.horizontalSwitchRight_startPotential_eq_vertexPotential`；
3. `BinaryOpenCoverSquareSubdivision.horizontalSwitchEdgeTransitions_start_eq_comparisonPotentials`；
4. `BinaryOpenCoverSquareSubdivision.horizontalSwitchLeft_endPotential_eq_vertexPotential`；
5. `BinaryOpenCoverSquareSubdivision.horizontalSwitchRight_endPotential_eq_vertexPotential`；
6. `BinaryOpenCoverSquareSubdivision.horizontalSwitchEdgeTransitions_end_eq_comparisonPotentials`；
7. `BinaryOpenCoverSquareSubdivision.verticalSwitchBottom_endPotential_eq_vertexPotential`；
8. `BinaryOpenCoverSquareSubdivision.verticalSwitchTop_endPotential_eq_vertexPotential`；
9. `BinaryOpenCoverSquareSubdivision.verticalSwitchBottom_startPotential_eq_vertexPotential`；
10. `BinaryOpenCoverSquareSubdivision.verticalSwitchTop_startPotential_eq_vertexPotential`；
11. `BinaryOpenCoverSquareSubdivision.verticalCommonEdgeTransitions_start_eq_gridCellPotentials`；
12. `binaryOpenCoverDualPath_localElements_pushout_rebase`；
13. `binaryOpenCoverSamePathConnectorComparison`；
14. `binaryOpenCoverSamePathConnectorComparison_edgeTarget`；
15. `binaryOpenCoverSamePathConnectorComparison_edgeSource`；
16. `coe_binaryOpenCoverSamePathConnectorComparison_leftStart`；
17. `coe_binaryOpenCoverSamePathConnectorComparison_rightStart`；
18. `coe_binaryOpenCoverSamePathConnectorComparison_leftEnd`；
19. `coe_binaryOpenCoverSamePathConnectorComparison_rightEnd`；
20. `binaryOpenCoverSamePath_localElements_pushout_rebase`。

四个 Main 冻结的 private 后端：

1. `BinaryOpenCoverSquareSubdivision.horizontalCommonEdgeTransitions_start_eq_vertexPotentials`；
2. `BinaryOpenCoverSquareSubdivision.horizontalCommonEdgeTransitions_end_eq_vertexPotentials`；
3. `BinaryOpenCoverSquareSubdivision.verticalCommonEdgeTransitions_end_eq_vertexPotentials`；
4. `BinaryOpenCoverSquareSubdivision.verticalCommonEdgeTransitions_start_eq_vertexPotentials`。

20 项公开面由 12--15 真实消费者审计决定；四个 private 只服务本文件更高层 common-edge 投影。

## Semantic boundary

本批输入的是“同一环境道路已经配有两套逐点成员性证明”。异标签时才从该事实推出道路在交集中；
它没有证明 cell label 与 letter label 在全网格相等。same-label comparison 只是把两套 connectors 放进
既有 comparison carrier，不新建道路或群论对象。

两条最终公式都严格使用 `rebaseEdge startChange endChange rightElement` 的既有方向。任何把它简写为
交换群式端点差、交换乘法次序或删除逆元的改写都会改变定理。

## Verification

```text
lake build SandronesLibrary.Topology.VanKampenPathGaugeComparison
✔ [1765/1765] Built SandronesLibrary.Topology.VanKampenPathGaugeComparison
Build completed successfully (1765 jobs).
```

- independent aggregate `#check` 全部 20 public names，exit code 0；
- Entry mapper 精确映射 20 项；长名称使用局部 namespace，既保持完全限定名又不逃逸审计器；
- switch endpoint、dual rebase、same comparison 和 same rebase 的公理均为
  `[propext, Classical.choice, Quot.sound]`；
- 未修改的 12a `VanKampenLeftBoundaryEdge` candidate 直接对正式 11c 编译，exit code 0、无输出；
- placeholder、四项 private 表面、重复 carrier、instance/notation、import 和 `git diff --check` 扫描通过。

## Honest boundary

本批不修改 `SandronesLibrary.lean`、Registry、ROADMAP 或 RADAR。它不迁入 12，不执行有限左边界乘积、
cocycle、telescope、residual gauge、kernel triviality、injectivity 或最终 van Kampen equivalence。
