# Topology handoff：T4-R3a-02 开集内相对折线逼近

## 范围、基线与依赖

- 分支：`codex/topology-foundations`；同步 Main `0f46a18`。
- 权限：`main-679dc3f-infrastructure-and-r3a-open.md` 的 `T4-R3a development_open`。
- 直接依赖：Main 已有 `UnitIntervalMesh`，以及本分支前一独立提交 `20d665d`
  `PathHomotopyImageControl`；因此本提交集成顺序等待前一提交。
- 范围止于开集内有限线段拼接与端点相对同伦；无光滑性、线积分或完整复分析 R3 声称。

## 文件与 Main-side 建议

- 源码：`SandronesLibrary/Topology/PathPolygonalApproximation.lean`。
- Entry：`topology.homotopy.path-polygonal-approximation`，拟唯一 `lean_file` 为该源码。
- Main 顶层 import、Registry、RADAR、ROADMAP 与生成索引由 Main 集成；建议把 T4-R3a 标为完成，
  T4-R3b 仍保持研究态。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接下游消费者 |
|---|---|---|
| `Path.MeshBallSubdivision` | 统一网格、正半径、子道路/线段公共球证书 | 本文件全部几何组装及以后局部道路替换 |
| `Path.exists_meshBallSubdivision` | 由开集、紧性和一致连续性产生证书 | 两个最终存在定理 |
| `Path.exists_mesh_segments_subset_open` | 只暴露网格直线段位于开集的弱出口 | 独立折线值域使用者 |
| `Path.meshPolygonal` | 相邻网格采样点直线段的有限拼接 | 后续所有折线路径接口 |
| `Path.meshPolygonal_eq_concat` | 折线路径的一手有限 concat 展开 | 计算/重写使用者 |
| `Path.meshSubpathConcat` | 原道路各网格子段的有限拼接 | 两类过渡同伦 |
| `Path.meshStraighteningHomotopy` | 原子段 concat 到直线段 concat 的相对同伦 | ambient 使用者 |
| `Path.meshStraighteningHomotopyWithMapsTo` | 带开集像证书的逐段直线化 | `meshPolygonalHomotopyWithMapsTo` |
| `Path.meshSubpathConcatHomotopy` | 原子段 concat 到原道路的重参数化同伦 | `meshPolygonalHomotopy` |
| `Path.meshSubpathConcatHomotopyWithMapsTo` | 带原道路像证书的重参数化同伦 | `meshPolygonalHomotopyWithMapsTo` |
| `Path.meshPolygonalHomotopy` | 原道路到折线路径的 ambient 相对同伦 | 一般折线替换使用者 |
| `Path.meshPolygonalHomotopyWithMapsTo` | 原道路到折线路径的开集内相对同伦 | 强最终存在定理 |
| `Path.meshPolygonal_range_subset_open` | 已给段证书时整体折线值域仍在开集 | 强最终存在定理 |
| `Path.exists_meshPolygonal_range_subset_open_and_homotopyWithin` | 返回网格、折线值域及完整开集内同伦 | T4-R3a 主要出口 |
| `Path.exists_meshPolygonal_range_subset_open_and_homotopy` | 忘掉同伦像证书的 ambient 推论 | 只需同伦存在的使用者 |

## 概念与公开签名分类

| 概念 | 教材语义 | Lean 正式承载／展开 | 复用或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|
| 有限折线路径 | 有限条直线段首尾拼接 | `meshPolygonal`，由 `meshPolygonal_eq_concat` 展开为 `Path.segment/concat` | Mathlib 提供原子构造，本库补统一网格组装 | 最终定理 | 本 Entry |
| 网格球细分证书 | 每个小段与替代线段共享一个开集内凸球 | 本库 `MeshBallSubdivision` 字段刻画 | 为实际缺失的证明数据桥，不复制道路 | straightening | 本 Entry |
| 开集内相对同伦 | 端点固定且整个方形像落在开集 | Mathlib `Path.Homotopy` 加逐点成员证书 | 复用正式同伦承载；证书层来自 R3a-01 | 主出口 | 本 Entry |
| 紧像与一致连续 | 紧道路像离补集有统一余量，参数控制可统一 | Mathlib `IsCompact`、`UniformContinuous` | 私有构造后端，不另造课程结构 | subdivision existence | 既有拓扑条目 |

公开签名中的 `NormedAddCommGroup`、`NormedSpace ℝ` 是折线语义所需的正式结构，不是证明方便而
泄漏；`Path.segment/concat/Homotopy` 均有教材解释。cthickening、uniform-continuity modulus 与
endpoint cast 仅在证明体，归为私有后端。没有新实例或与 Mathlib 同构的重复道路结构。

## 证明审核与验证

候选的紧性—统一连续—凸球—有限拼接证明链已逐段人工审核；自动化只处理明确的网格距离、cast
求值和集合包含归约。正式模块独立构建为 1868 jobs 通过。formal aggregate 同时检查 mesh、R3a-01
认证拼接、十五项公开 API 与两个最终出口；五项代表证明的公理集合均只有 `propext`、
`Classical.choice`、`Quot.sound`。Entry mapper 精确映射十五项公开声明；禁用项、唯一声明及
`git diff --check` 通过。
