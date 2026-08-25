# T4-F2b1 基本群诱导映射函子律与同伦自然性 handoff

## 范围与基线

- 分支：`codex/topology-foundations`。
- 最新同步 Main `e073118` 的提交为 `1808081`；该 Main 已集成 F2a 并开放本批集成。
- 权限：T4-F2b 为 `integration_open`；本批独占 `FundamentalGroupFunctorialityStandard.lean`。
- `integration_waits_for`: 已由 Main `e073118` 解除。
- 按 Main 早期接口预审选择收窄方案：本批只处理诱导映射函子律与同伦自然性；基点变换和同伦
  等价不变性移至独立 F2b2。F2c 计算为 `development_open`，T4-R 保持 `research_open`。

## 概念链

| 教材概念 | Lean 正式承载 | 展开／一手性质 | 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 连续映射诱导基本群同态 | `FundamentalGroup.map` | `fundamentalGroup_map_toPath` | 与逐点映射环路语义一致，直接复用 | 恒等/复合律 | `topology.fundamental-group.functoriality-standard` |
| 基本群函子律 | `MonoidHom.id/comp` | `fundamentalGroup_map_id`、`fundamentalGroup_map_comp` | 本库补充稳定教材接口 | 后续同伦不变性 | 同上 |
| 同伦映射自然同构 | `homotopicMapsNatIso` | `homotopicMapsNatIso_app_eq_pathClass`、`homotopicMapsNatIso_naturality_loop` | 分量是基点同伦轨迹；不是严格相等 | 同伦不变性 | 同上 |

## 公开签名与边界

公开 Mathlib 专用接口包括 `ContinuousMap`、`FundamentalGroup.map`、`MonoidHom`、
`Path.Homotopic.Quotient.map`、基本群胚函子、自然同构及范畴复合，均为语义一致且已解释的正式承载。
没有新 `def`、重复 functor、重复群同态或全局实例。两条函子律用商归纳降至代表道路；其余三条
由标准定义或自然性字段给出。

本批明确区分同伦映射诱导函子是自然同构而非严格相等。`mapOfEq`、
`fundamentalGroupMulEquivOfPath`、`equivOfHomotopyEquiv` 不再只在文档中点名，而是从本 Entry 的
Mathlib 清单、概念链和声称范围移出；它们必须在独立 F2b2 由真实公开 theorem 使用。F2c 的
单连通、可缩、积空间与圆周计算均不在公开签名中。

## Main 集成建议

- 加入顶层 import `SandronesLibrary.Topology.FundamentalGroupFunctorialityStandard`。
- Registry 新增 `topology.fundamental-group.functoriality-standard`。
- 引用复用 `hatcher-algebraic-topology-2002`，定位 Section 1.1。
- F2c 保持独立窗口；圆周计算不得以 Mathlib 最终等价代替课程定义链。

## 验证

- `/tmp/sandrones-library/FundamentalGroupFunctorialityPrototype.lean` 的五项临时证明占位已全部消除并编译通过。
- `lake env lean SandronesLibrary/Topology/FundamentalGroupFunctorialityStandard.lean` 通过。
- `lake build SandronesLibrary.Topology.FundamentalGroupFunctorialityStandard
  SandronesLibrary.Topology.FundamentalGroupOperationsStandard
  SandronesLibrary.Topology.FundamentalGroupCarrierStandard
  SandronesLibrary.Topology.PathHomotopyQuotientStandard
  SandronesLibrary.Topology.HomotopyEquivalenceStandard SandronesLibrary.Topology.HomotopyStandard
  SandronesLibrary.Topology.PathReparameterization SandronesLibrary.Topology.PathConnected
  SandronesLibrary.Topology.MathlibCompatibility` 通过，共 1805 jobs。
- `/tmp/sandrones-library/TopologyF2bFundamentalGroupFunctorialityAudit.lean` 已更新为检查 F1/F2a
  承载、诱导同态、恒等/复合律、自然同构和自然性方程，不再把 F2b2 接口计入本批定义链。
- `scripts.check_axioms.map_entry_to_decl` 将本 Entry 精确映射到 5 条公开声明，没有跨文件吸入。
- 五条 theorem 的公理均为 `propext`、`Classical.choice`、`Quot.sound`。
- 正式源码禁用占位及全部交付文件冲突标记扫描无结果；`git diff --check` 通过。
