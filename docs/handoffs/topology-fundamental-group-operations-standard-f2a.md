# T4-F2a 基本群运算与群律 handoff

## 范围与基线

- 分支：`codex/topology-foundations`。
- 最新同步 Main `c25419a` 的提交为 `7373909`；其中 Main `bcb1d8b` 已完成 T4-F1b 共享集成。
- 权限：T4-F2a 为 `integration_open`，可以提交正式验收。
- `integration_waits_for`: 已由 Main `bcb1d8b` 解除。
- F2b 函子性、同伦不变性与计算保持 `research_open`，未写入正式源码。

## 概念链

| 教材概念 | Lean 正式承载 | 展开／一手性质 | 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 基本群单位 | `One (FundamentalGroup X x)` | `fundamentalGroup_one_toPath` | `FundamentalGroup.one_def` 与恒等环路类语义一致 | 群单位律 | `topology.fundamental-group.operations-standard` |
| 基本群乘法 | `Mul (FundamentalGroup X x)` | `fundamentalGroup_mul_toPath` | `FundamentalGroup.mul_def`；解释范畴复合反序 | 代表元乘法公式 | 同上 |
| 基本群逆元 | `Inv (FundamentalGroup X x)` | `fundamentalGroup_inv_toPath` | `FundamentalGroup.inv_def` 与道路反向类语义一致 | 群逆元律 | 同上 |
| 基本群群律 | 标准 `Group (FundamentalGroup X x)` | 通用 `mul_assoc`、`one_mul`、`mul_one`、`inv_mul_cancel`、`mul_inv_cancel` | 直接复用稳定通用群律，不建立同义 wrapper | 后续诱导群同态 | 同上 |
| 代表道路乘法 | 道路经 `Quotient.mk` 后的基本群元素 | `fundamentalGroup_mk_mul_mk` | 等式只在商／基本群层，不声称原始道路严格相等 | 拼接次序示例 | 同上 |

## 公开签名与边界

`FundamentalGroup`、`Path.Homotopic.Quotient.refl/trans/symm`、`Group` 的单位／乘法／逆元记号均为
语义一致且已解释的 Mathlib 正式承载。四条本库 theorem 是 carrier 与操作之间的必要视角桥；没有
新 `def`、wrapper 群结构或全局实例。证明后端是 Mathlib 基本群胚实例的定义展开。

群律直接使用标准 `Group` API，不复制 `mul_assoc` 等定理。`fundamentalGroup_mk_mul_mk` 的等式
两边均为基本群元素；右边先对 `q.trans p` 取道路同伦类，因此没有把商上群律误写成原始道路严格
等式。F2b 的映射、基点变换、同伦不变性和计算不在本批范围。

## Main 集成建议

- 加入顶层 import `SandronesLibrary.Topology.FundamentalGroupOperationsStandard`。
- Registry 新增 `topology.fundamental-group.operations-standard`。
- ROADMAP 将 F2a 标为已集成后，再依据研究审计决定 F2b 的开发门。
- 引用复用 `hatcher-algebraic-topology-2002`，定位 Section 1.1。

## 验证

- `/tmp/sandrones-library/FundamentalGroupOperationsPrototype.lean` 已验证四条接口和直接群律 API。
- `lake env lean SandronesLibrary/Topology/FundamentalGroupOperationsStandard.lean` 通过。
- `lake build SandronesLibrary.Topology.FundamentalGroupOperationsStandard
  SandronesLibrary.Topology.FundamentalGroupCarrierStandard
  SandronesLibrary.Topology.PathHomotopyQuotientStandard
  SandronesLibrary.Topology.HomotopyEquivalenceStandard SandronesLibrary.Topology.HomotopyStandard
  SandronesLibrary.Topology.PathReparameterization SandronesLibrary.Topology.PathConnected
  SandronesLibrary.Topology.MathlibCompatibility` 通过，共 1756 jobs。
- `/tmp/sandrones-library/TopologyF2aFundamentalGroupOperationsAudit.lean` 同时检查 F1a/F1b 承载、
  四条操作桥、标准 `Group` 实例、五条通用群律和商上五条道路同伦等式。
- `scripts.check_axioms.map_entry_to_decl` 将本 Entry 精确映射到 4 条公开声明，没有跨文件吸入。
- 四条 theorem 的公理均为 `propext`、`Classical.choice`、`Quot.sound`。
- 正式源码禁用占位及全部交付文件冲突标记扫描无结果；`git diff --check` 通过。
