# T4-H2 一般与相对同伦 handoff

## 范围与依赖门

- 分支：`codex/topology-foundations`；开工基于同步 Main `c46e8a7` 的提交 `21e0c9d`；开发后
  再次同步 Main `24014c0`，合并提交为 `c82f83c`。
- 权限：`development_open`；独占 `HomotopyStandard.lean`。
- 原 `integration_waits_for` 已解除：T4-H1 随 Main `019a17e` 集成；当前 H2 为
  `integration_open`。
- 不修改 Registry、RADAR、ROADMAP、Playbook、顶层 import 或生成文件。

## 概念链

| 教材概念 | Lean 正式承载 | 展开／一手性质 | 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 一般同伦 | `ContinuousMap.Homotopy f g` | `nonempty_homotopy_iff_exists_continuous_deformation` | 连续时间族语义一致，直接复用 | `Homotopy.comp` | `topology.homotopy.standard` |
| 相对集合的同伦 | `ContinuousMap.HomotopyRel f g S` | `nonempty_homotopyRel_iff_exists_continuous_deformation_fixed_on` | `S` 上所有点全程固定，直接复用 | `HomotopyRel.compContinuousMap` | 同上 |
| 同伦复合 | `ContinuousMap.Homotopy.comp` | `homotopy_comp_apply` | 两个同伦共享时间坐标并逐点复合 | 同伦等价的传递构造 | 同上 |
| 相对同伦后复合 | `ContinuousMap.HomotopyRel.compContinuousMap` | `homotopyRel_compContinuousMap_apply` | 保持原固定集合 `S` | 后续相对同伦函子性 | 同上 |

## 公开签名与数学边界

公开 Mathlib 名称均属语义一致的正式承载：`ContinuousMap`、`Homotopy`、`HomotopyRel`、
`unitInterval`、`Continuous` 和 `Set`。没有本库包装定义、特殊桥或越级泄漏。证明后端只使用这些
结构的字段及定义展开。

`Homotopy.comp` 是两个映射同伦的同步复合，不是时间方向的 `trans`。相对同伦的固定条件量化所有
时间，不能降级为两个端点映射在 `S` 上相等。本批不定义同伦等价、同伦类、基本群或任何群运算，
也不复制 H1 的道路同伦公开签名。

## Main 集成建议

- 加入顶层 import `SandronesLibrary.Topology.HomotopyStandard`。
- Registry 新增 `topology.homotopy.standard`，并更新 ROADMAP/RADAR 的 H2 状态。
- 引用复用 `hatcher-algebraic-topology-2002`；章节定位保留在课程正文。

## 验证

- `/tmp/sandrones-library/HomotopyStandardPrototype.lean` 中四项无占位原型单独编译通过。
- `lake env lean SandronesLibrary/Topology/HomotopyStandard.lean` 通过。
- `lake build SandronesLibrary.Topology.HomotopyStandard SandronesLibrary.Topology.PathReparameterization SandronesLibrary.Topology.PathConnected SandronesLibrary.Topology.MathlibCompatibility` 通过，共 1671 jobs。
- `/tmp/sandrones-library/TopologyH2HomotopyStandardAudit.lean` 同时检查 H1 前置、两个正式承载、两个完整展开与两种复合；四条公开声明的公理均为 `propext`、`Classical.choice`、`Quot.sound`。
- `scripts.check_axioms.map_entry_to_decl` 将本 Entry 精确映射到 4 条公开声明，没有跨文件吸入。
- 正式源码禁用占位扫描及交付文件冲突标记扫描无结果；`git diff --check` 通过。
