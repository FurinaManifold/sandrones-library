# T4-F2c1 单连通与可缩空间的平凡基本群 handoff

## 范围与基线

- 分支：`codex/topology-foundations`。
- 同步 Main `e073118` 的提交为 `1808081`；F2c 已为 `development_open`。
- 本批独占 `FundamentalGroupTrivialityStandard.lean`，只处理单连通、可缩和非空凸集。
- `integration_waits_for`: F2b1/F2b2 是否集成不影响本批数学定义链；本批只依赖已集成 F2a。
- 圆周基本群、积空间与 T4-R 使用独立窗口，不混入本批。

## 概念链

| 教材概念 | Lean 正式承载 | 展开／一手性质 | 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 单连通空间 | `SimplyConnectedSpace X` | `simply_connected_iff_unique_homotopic` | 与非空且道路商唯一的教材刻画一致 | 基本群平凡 | `topology.fundamental-group.triviality-standard` |
| 平凡基本群 | `∀ g : FundamentalGroup X x, g = 1` | `fundamentalGroup_eq_one_of_simplyConnected` | 不另造平凡群谓词 | 可缩空间专门化 | 同上 |
| 环路可缩 | `p = Quotient.refl x` | `loopHomotopyClass_eq_refl_of_simplyConnected` | 等式发生在道路同伦商 | 平凡基本群道路视角 | 同上 |
| 可缩空间 | `ContractibleSpace X` | `fundamentalGroup_eq_one_of_contractible` | Mathlib 已给可缩推出单连通实例 | 凸集计算 | 同上 |
| 非空凸集 | `Convex ℝ s` 与 `s.Nonempty` | `fundamentalGroup_eq_one_of_convex` | `Convex.contractibleSpace` 提供子空间可缩性 | 具体计算 | 同上 |

## 公开签名与边界

`SimplyConnectedSpace`、`ContractibleSpace`、`Convex`、`FundamentalGroup` 与
`Path.Homotopic.Quotient` 均为语义一致且已解释的 Mathlib 正式承载。没有新 `def`、重复结构或
全局实例。四条 theorem 都给真实计算结论；前三条直接使用标准 `Subsingleton` 实例，凸集条目在
证明内局部建立可缩性。

本批不声称基本群平凡反推单连通，不遗漏凸集非空前提，也不把子空间基本群与环境空间基本群混同。
圆周 `≃* ℤ` 当前没有发现 Mathlib 完成定理，必须另建覆盖/提升/绕数链。

## Main 集成建议

- 加入顶层 import `SandronesLibrary.Topology.FundamentalGroupTrivialityStandard`。
- Registry 新增 `topology.fundamental-group.triviality-standard`。
- 引用复用 `hatcher-algebraic-topology-2002`，定位 Section 1.1。
- F2c 后续把积空间和圆周分别拆批；不得用标题“examples”掩盖圆周缺失。

## 验证

- `/tmp/sandrones-library/FundamentalGroupTrivialityPrototype.lean` 四条接口编译通过。
- `lake env lean SandronesLibrary/Topology/FundamentalGroupTrivialityStandard.lean` 通过。
- `lake build SandronesLibrary.Topology.FundamentalGroupTrivialityStandard
  SandronesLibrary.Topology.FundamentalGroupOperationsStandard
  SandronesLibrary.Topology.FundamentalGroupCarrierStandard
  SandronesLibrary.Topology.PathHomotopyQuotientStandard
  SandronesLibrary.Topology.HomotopyEquivalenceStandard SandronesLibrary.Topology.HomotopyStandard
  SandronesLibrary.Topology.PathReparameterization SandronesLibrary.Topology.PathConnected
  SandronesLibrary.Topology.MathlibCompatibility` 通过，共 1809 jobs。
- `/tmp/sandrones-library/TopologyF2c1FundamentalGroupTrivialityAudit.lean` 同时检查 carrier、单位元、
  单连通刻画、可缩推出单连通、凸集可缩与四条计算 theorem。
- `scripts.check_axioms.map_entry_to_decl` 将本 Entry 精确映射到 4 条公开声明，没有跨文件吸入。
- 四条 theorem 的公理均为 `propext`、`Classical.choice`、`Quot.sound`。
- 正式源码禁用占位及全部交付文件冲突标记扫描无结果；`git diff --check` 通过。
