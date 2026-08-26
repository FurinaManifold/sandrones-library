# Topology infrastructure handoff：单位区间网格归位

## 范围与权限

- Main 基线：`22c062d`。
- 权限来源：`review-inbox/topology/main-679dc3f-infrastructure-and-r3a-open.md`。
- 本批只移动五个既有声明到中性模块，不改名、不建 alias、不复制实现。

## 文件与所有权变化

- 新增 `SandronesLibrary/Topology/UnitIntervalMesh.lean`，唯一拥有：
  `unitIntervalMeshPoint`、`unitIntervalMeshPoint_zero`、`unitIntervalMeshPoint_last`、
  `unitIntervalMeshPoint_castSucc_le_succ`、`dist_unitIntervalMeshPoint_castSucc_succ`。
- `VanKampenCoverSubdivision.lean` 删除上述五个声明并 import 中性模块；其余源码不变。
- 新增 Entry `topology.homotopy.unit-interval-mesh`，明确该设施不依赖道路、开覆盖或基本群。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接消费者 |
|---|---|---|
| `unitIntervalMeshPoint` | `i/N` 一致网格点 | VK1、VK3a、VK3b-01、T4-R3a 候选 |
| `unitIntervalMeshPoint_zero` | 首点为 `0` | VK1 拼接端点及后续边界计算 |
| `unitIntervalMeshPoint_last` | 末点为 `1` | VK1、VK3a、VK3b-01、T4-R3a 候选 |
| `unitIntervalMeshPoint_castSucc_le_succ` | 相邻点单调 | `Path.subpath` 值域接口、T4-R3a |
| `dist_unitIntervalMeshPoint_castSucc_succ` | 相邻距离为 `N⁻¹` | VK1/VK3a Lebesgue 数细分 |

五项均有跨模块消费者，保持公开；没有仅供本文件内部的辅助声明。

## 验证

- 同时构建 `UnitIntervalMesh`、VK1、VK2、VK3a 和当前 VK3b-01：1748 jobs 通过。
- 原研究 aggregate 在正式 import 路径下通过，检查五项 mesh API 及 VK1/VK2/VK3a 代表出口。
- 五项声明的 `#print axioms` 均只有 `propext`、`Classical.choice`、`Quot.sound`。
- Entry 标记将五项公开声明精确关联到 `topology.homotopy.unit-interval-mesh`。
- 全库搜索确认五项声明只在 `UnitIntervalMesh.lean` 定义；VK1 只保留调用点。
- `git diff --check` 与禁用项扫描通过。

本批是 Main 指定的三个独立 ownership move 中第一项；不包含 `PathCodRestrict`、
`PathCorrectedLoop`、VK3b-01 数学内容或 T4-R3a。
