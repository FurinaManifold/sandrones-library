# Topology handoff：AT1-VK3b-11b dual path 与 vertex potential

## Scope and gate

- branch target: `codex/topology-foundations`；
- dependency: Main shared integration `06b451d`，正式 VK3b-11a；
- permission: `main-06b451d-vk3b11a-accepted-11b-open.md`；
- formal slice: exactly one source, one Entry, this handoff；
- frozen successor: VK3b-11c and 12--15。

本批把双标签环境道路提升到交集，建立成员基本群元素、Pushout equality、connector comparison 和
坐标无关 endpoint potentials。它不迁入 11c 完整 path gauge comparison。

## Files and imports

- `SandronesLibrary/Topology/VanKampenDualPathPotential.lean`；
- `docs/entries/topology/fundamental-group/van-kampen-dual-path-potential.md`；
- `docs/handoffs/topology-van-kampen-dual-path-potential-at1-vk3b-11b.md`。

源码只 import `SandronesLibrary.Topology.VanKampenLetterBlockWord`。

## Concept inventory

| 概念 | 教材含义 | Lean 承载 | 分类 | 真实消费者 | 边界 |
|---|---|---|---|---|---|
| dual path | 同时落在两个标签中的同一道路 | Mathlib `Path` 的交集 subtype lift | 正式承载上的桥 | 11c dual rebase | 不新建 Path |
| piece element | 交集规范 corrected loop 映入某成员基本群 | Mathlib `FundamentalGroup` | 前序桥的组合 | Pushout equality/comparison | 不是新群元素 carrier |
| connector comparison | 规范与局部 connectors 的端点变化 | `CommonEdgeConnectorComparison` | 已验收本库桥 | 11c/12 | 不复制 comparison 结构 |
| vertex potential | 端点 connector change 的 Pushout 像 | 已有 `binaryOpenCoverVertexPotentialFromIntersection` | 已验收本库桥 | 11c--14 | 本批只给稳定性和 specialization |
| Pushout relation | 交集两侧像相等 | Mathlib `Monoid.PushoutI` | 语义一致正式承载 | dual piece equality | 不另造自由积商 |

## Public surface: 21 public / 8 private

公开 21 项：

1. `mem_intersection_of_mem_binaryOpenCoverPieces_of_ne`；
2. `binaryOpenCoverDualPathInIntersection`；
3. `coe_binaryOpenCoverDualPathInIntersection`；
4. `binaryOpenCoverPathInPiece`；
5. `coe_binaryOpenCoverPathInPiece`；
6. `binaryOpenCoverDualPathPieceElement`；
7. `binaryOpenCoverDualPathPieceElements_pushout_eq`；
8. `binaryOpenCoverDualPathConnectorComparison`；
9. `binaryOpenCoverDualPathConnectorComparison_relation`；
10. `BinaryOpenCoverSquareSubdivision.gridCellVertexPotentialFromIntersection_eq_vertexPotential`；
11. `binaryOpenCoverVertexPotentialFromIntersection_proof_irrel`；
12. `binaryOpenCoverVertexPotentialFromIntersection_cast`；
13. `binaryOpenCoverVertexPotentialFromIntersection_cast_label`；
14. `binaryOpenCoverVertexPotentialFromIntersection_basepoint_eq_of_coe`；
15. `binaryOpenCoverIntersectionToPiece_basepoint_eq_of_coe`；
16. `binaryOpenCoverConnectorPotential_cast_label`；
17. `CommonEdgeConnectorComparison.pushout_startChange_inv_eq_vertexPotentials`；
18. `CommonEdgeConnectorComparison.pushout_endChange_inv_eq_vertexPotentials`；
19. `binaryOpenCoverDualPathConnectorComparison_startPotential_eq`；
20. `binaryOpenCoverDualPathConnectorComparison_endPotential_eq`；
21. `binaryOpenCoverDualPathConnectorComparison_sharedPotential`。

八个 private 后端：

1. `binaryOpenCoverDualPath_map_toPiece_cast_eq`；
2. `binaryOpenCoverDualPathPieceElement_eq_map`；
3. `binaryOpenCoverDualPathPieceElement_eq_correctedLoop`；
4. `binaryVanKampenPushout_of_intersection_eq_of_ne`；
5. `correctedLoop_cast_all_proof_irrel`；
6. `binaryOpenCoverDualPathConnectorComparison_leftElement`；
7. `binaryOpenCoverIntersectionMaps_connectorChange`；
8. `binaryOpenCoverVertexPotentialFromIntersection_eq_of_intersectionConnector`。

公开面来自完整 11c--15 消费者审计；private 八项无跨模块消费者。

## Semantic boundary

同一环境道路的两种 subtype 表示只通过 `Path.map`、`Path.cast` 和底层函数相等比较；没有假设这些
dependent `Path` 在不同类型中可直接相等。vertex potential 的 proof irrelevance 与 label-cast 定理
是后续避免展开 dependent equality 的稳定出口。

本批的道路成员性、交集提升和 endpoint gauge 是局部关系。它不进行整条左边界的有限乘积抵消，
不证明任意 kernel 字母词消失。

## Verification

```text
lake build SandronesLibrary.Topology.VanKampenDualPathPotential
✔ [1764/1764] Built SandronesLibrary.Topology.VanKampenDualPathPotential
Build completed successfully (1764 jobs).
```

- independent aggregate `#check` 全部 21 public names，exit code 0；
- `scripts.check_axioms.map_entry_to_decl` 唯一映射本 Entry 的 21 项，未吸入 private 声明；
- path lift、comparison、cast-label、shared potential 的 `#print axioms` 均为
  `[propext, Classical.choice, Quot.sound]`；
- `lake env lean` 直接编译未修改的 11c candidate，exit code 0、无输出，确认 21/8 表面满足真实消费者；
- placeholder、duplicate structure、instance/notation、import boundary 与 `git diff --check` 扫描通过。

## Honest boundary

本批不修改共有 `SandronesLibrary.lean`、Registry、ROADMAP 或 RADAR。11c、左边界 transport、cocycle、
telescope、kernel、单射和最终 van Kampen 同构均未提交。
