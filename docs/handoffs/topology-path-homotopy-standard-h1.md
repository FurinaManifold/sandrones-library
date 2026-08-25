# T4-H1 标准道路同伦 handoff

## 范围与基线

- 分支：`codex/topology-foundations`。
- 开工前以 `git merge main` 同步 Main `5946cc2`，同步提交为 `94149b4`。
- 权限：`integration_open`；独占 `PathHomotopyStandard.lean`。
- 本批不修改 Registry、RADAR、ROADMAP、顶层 import 或其他 Main 共有文件。

## 概念链

| 教材概念 | Lean 正式承载 | 展开／一手性质 | 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 端点固定道路同伦 | `Path.Homotopy p q` | `nonempty_pathHomotopy_iff_exists_fixed_endpoint_deformation` | 语义等同于端点集合 `{0,1}` 上的 `ContinuousMap.HomotopyRel`，直接复用 | `Path.Homotopy.refl/symm/trans` | `topology.homotopy.path-homotopy-standard` |
| 反身道路同伦 | `Path.Homotopy.refl` | `pathHomotopy_refl_apply` | 时间坐标上恒定 | 后续同伦关系 | 同上 |
| 同伦反向 | `Path.Homotopy.symm` | `pathHomotopy_symm_apply` | 只反射同伦时间，不反向道路参数 | 后续对称性 | 同上 |
| 同伦传递 | `Path.Homotopy.trans` | 两条时间半区取值定理 | 两个变形分别压缩到半段时间 | 后续传递性 | 同上 |

## 公开签名与边界

`Path.Homotopy`、`ContinuousMap.HomotopyRel`、`unitInterval` 和 `Continuous` 都属于语义一致且已解释的正式公开承载；没有本库特殊桥或越级泄漏。证明使用 Mathlib 的结构投影、`linarith` 与集合 `{0,1}` 的析构作为证明后端。

坐标顺序固定为“同伦时间、道路位置”。`Path.Homotopy.symm` 不等于道路逆向；同伦 `trans` 不等于道路拼接。本批没有建立 `Path.Homotopic` 取商、基本群、群结构、函子性或计算接口，也没有从旧 `TextbookTopology` 同伦复制任何声明。

## Main 集成建议

- 顶层 import：加入 `SandronesLibrary.Topology.PathHomotopyStandard`。
- Registry：新增 `topology.homotopy.path-homotopy-standard`，课程文档在 Main 集成时由 `staging` 收敛。
- ROADMAP/RADAR：将 T4-H1 标记已交付；H2 的集成门可在 H1 进入 Main 后解除。
- 建议引用：Hatcher, *Algebraic Topology*, Section 1.1；由 Main 复用或分配 `reference.bib` key。

## 验证

- `/tmp/sandrones-library/PathHomotopyStandardPrototype.lean` 中先完成无 `sorry` 原型并单独编译。
- `lake env lean SandronesLibrary/Topology/PathHomotopyStandard.lean` 通过。
- `lake build SandronesLibrary.Topology.PathHomotopyStandard SandronesLibrary.Topology.PathReparameterization SandronesLibrary.Topology.PathConnected SandronesLibrary.Topology.MathlibCompatibility` 通过，共 1670 jobs。
- `/tmp/sandrones-library/TopologyH1PathHomotopyAudit.lean` 同时 `#check` 正式承载、存在刻画、四条操作展开和 Mathlib 原始操作；五条声明的公理均为 `propext`、`Classical.choice`、`Quot.sound`。
- `scripts.check_axioms.map_entry_to_decl` 将本 Entry 精确映射到上述 5 条公开声明，没有跨文件或相邻 Entry 吸入。
- 正式源码、Entry 文档和 handoff 的占位／冲突标记扫描无结果；`git diff --check` 通过。
