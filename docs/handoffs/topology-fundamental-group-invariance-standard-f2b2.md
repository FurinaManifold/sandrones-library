# T4-F2b2 基点变换与同伦等价不变性 handoff

## 范围与基线

- 分支：`codex/topology-foundations`。
- 最新同步 Main `411aadb` 的提交为 `57606e2`。
- F2b 总窗口为 `integration_open`；本批独占 `FundamentalGroupInvarianceStandard.lean`。
- `integration_waits_for`: F2b1 `FundamentalGroupFunctorialityStandard.lean` 进入 Main。
- 本批按 Main 早期接口预审补齐三类真实公开使用者，不包含 F2c 计算或 T4-R。

## 概念链

| 教材概念 | Lean 正式承载 | 展开／一手性质 | 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 指定目标基点 | `FundamentalGroup.mapOfEq` | `fundamentalGroup_mapOfEq_toPath` | 端点等式 transport 与教材基点识别一致 | 指定基点诱导同态 | `topology.fundamental-group.invariance-standard` |
| 沿道路换基点 | `fundamentalGroupMulEquivOfPath` | `fundamentalGroup_changeBasepoint_toPath` | 展开为商上的 `p⁻¹ · g · p`；依赖选路 | 基点独立性 | 同上 |
| 同伦等价诱导群胚等价 | `equivOfHomotopyEquiv` | 正向 functor fully faithful | 群胚层语义一致 | 对应基点群等价 | 同上 |
| 对应基点基本群等价 | 本库 `fundamentalGroupMulEquivOfHomotopyEquiv` | `..._apply` | 从 fully faithful functor 的 End 等价提取，不重建结构 | 同伦不变量 | 同上 |

## 公开签名与边界

`mapOfEq`、道路商 cast、`fundamentalGroupMulEquivOfPath`、`equivOfHomotopyEquiv`、fully faithful
functor 与 `MulEquiv` 均为语义一致且已解释的 Mathlib 正式承载。本库新增一个真实 `MulEquiv`，把
群胚等价专门化到对应基点的自同态群；另外三条 theorem 展开 transport、共轭和正向作用。

选路换基点不是规范同构；同伦等价的目标基点严格是 `e x`；任意指定目标点仍需等式或道路。本批
不声称基本群同构足以推出空间同伦等价。

## Main 集成建议

- F2b1 集成后加入顶层 import `SandronesLibrary.Topology.FundamentalGroupInvarianceStandard`。
- Registry 新增 `topology.fundamental-group.invariance-standard`。
- 引用复用 `hatcher-algebraic-topology-2002`，定位 Section 1.1。

## 验证

- `/tmp/sandrones-library/FundamentalGroupBasepointInvariancePrototype.lean` 四条接口编译通过。
- `lake env lean SandronesLibrary/Topology/FundamentalGroupInvarianceStandard.lean` 通过。
- `lake build SandronesLibrary.Topology.FundamentalGroupInvarianceStandard
  SandronesLibrary.Topology.FundamentalGroupFunctorialityStandard
  SandronesLibrary.Topology.FundamentalGroupOperationsStandard
  SandronesLibrary.Topology.FundamentalGroupCarrierStandard
  SandronesLibrary.Topology.PathHomotopyQuotientStandard
  SandronesLibrary.Topology.HomotopyEquivalenceStandard SandronesLibrary.Topology.HomotopyStandard
  SandronesLibrary.Topology.PathReparameterization SandronesLibrary.Topology.PathConnected
  SandronesLibrary.Topology.MathlibCompatibility` 通过，共 1806 jobs。
- `/tmp/sandrones-library/TopologyF2b2FundamentalGroupInvarianceAudit.lean` 同时检查 F2b1 诱导映射、
  equality transport、沿道路换基点共轭、群胚等价、fully faithful End 等价及四条公开接口。
- `scripts.check_axioms.map_entry_to_decl` 将本 Entry 精确映射到 4 条公开声明，包括
  `noncomputable def`，没有跨文件吸入。
- 四条声明的公理均为 `propext`、`Classical.choice`、`Quot.sound`。
- 正式源码禁用占位及全部交付文件冲突标记扫描无结果；`git diff --check` 通过。
