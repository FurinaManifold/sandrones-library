# T4-F1a 道路同伦商标准承载 handoff

## 范围与基线

- 分支：`codex/topology-foundations`。
- Main `2377baa` 已集成 T4-E 并将 F1 提升为 `development_open`；同步提交为 `925f90d`。
- 本批独占 `PathHomotopyQuotientStandard.lean`，只冻结道路同伦商的承载、判等和代表存在。
- `integration_waits_for`: Main 审核并冻结本批同伦商公开接口。
- F1b 基本群承载可在本批签名冻结后开发；F2 群结构、函子性和计算仍冻结。

## 概念链

| 教材概念 | Lean 正式承载 | 展开／一手性质 | 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 道路端点固定同伦关系 | `Path.Homotopic p q` | `pathHomotopyQuotient_mk_eq_iff_homotopic` | Mathlib 已证明为等价关系，直接复用 | 道路同伦商判等 | `topology.homotopy.path-homotopy-quotient-standard` |
| 道路同伦商 | `Path.Homotopic.Quotient x y` | `pathHomotopyQuotient_mk_eq_iff_exists_fixed_endpoint_deformation` | 直接复用标准商；完整展开使用 H1 接口 | 代表存在定理；未来基本群胚 Hom | 同上 |
| 商类代表 | `Path.Homotopic.Quotient.mk` | `pathHomotopyQuotient_exists_representative` | 商映射满射，无唯一性 | 后续商上构造的代表归纳 | 同上 |

## 公开签名与边界

公开 Mathlib 名称 `Path`、`Path.Homotopy/Homotopic`、`Path.Homotopic.Quotient`、`unitInterval` 和
`Continuous` 均为已解释、语义一致的正式承载。没有本库包装定义、旧结构桥或越级泄漏。核心判等
定理真实调用 H1 的连续正方形展开，避免课程链停在未解释的关系名上。

本批不发布商上 `refl/symm/trans` 的代数律，不定义基本群胚或基本群，不触碰群乘法顺序、单位、
逆、结合律、函子性及计算。未来 F1b 只可稳定依赖本批三条接口；F2 继续冻结。

## Main 集成建议

- 同伦商公开签名冻结后加入顶层 import `SandronesLibrary.Topology.PathHomotopyQuotientStandard`。
- Registry 新增 `topology.homotopy.path-homotopy-quotient-standard`，更新 F1 状态但不要提前开放 F2。
- 引用复用 `hatcher-algebraic-topology-2002`，章节定位为 Section 1.1。

## 验证

- `/tmp/sandrones-library/FundamentalGroupCarrierPrototype.lean` 中本批三条接口先行验证通过。
- `lake env lean SandronesLibrary/Topology/PathHomotopyQuotientStandard.lean` 通过。
- `lake build SandronesLibrary.Topology.PathHomotopyQuotientStandard SandronesLibrary.Topology.HomotopyEquivalenceStandard SandronesLibrary.Topology.HomotopyStandard SandronesLibrary.Topology.PathReparameterization SandronesLibrary.Topology.PathConnected SandronesLibrary.Topology.MathlibCompatibility` 通过，共 1674 jobs。
- `/tmp/sandrones-library/TopologyF1aPathHomotopyQuotientAudit.lean` 同时检查关系、setoid、商承载、商映射、H1 展开及三条公开接口；三条声明的公理均为 `propext`、`Classical.choice`、`Quot.sound`。
- `scripts.check_axioms.map_entry_to_decl` 将本 Entry 精确映射到 3 条公开声明，没有跨文件吸入。
- 正式源码禁用占位扫描及全部交付文件冲突标记扫描无结果；`git diff --check` 通过。
