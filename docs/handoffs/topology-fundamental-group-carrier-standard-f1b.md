# T4-F1b 基本群胚与基本群承载 handoff

## 范围与基线

- 分支：`codex/topology-foundations`。
- 同步 Main `2e17758` 的提交为 `267278c`；该 Main 已接入 F1a 学科提交并采用集中式 LONGTERM。
- 权限：T4-F1 整体为 `development_open`；本批独占 `FundamentalGroupCarrierStandard.lean`。
- `integration_waits_for`: Main 冻结并集成 F1a 道路同伦商公开接口。
- F2 群结构、函子性与计算保持冻结。

## 概念链

| 教材概念 | Lean 正式承载 | 展开／一手性质 | 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 范畴与群胚 | Mathlib `Category` / `Groupoid` | 群胚 Hom 类型的道路商等式 | 对象、态射、恒等、复合、逆均与教材层级一致；本批只公开承载 | 基本群胚 | `topology.fundamental-group.carrier-standard` |
| 基本群胚对象 | `FundamentalGroupoid X` | `fundamentalGroupoid_equiv_mk_apply` | 只是 `X` 的点 wrapper | 群胚 Hom | 同上 |
| 基本群胚态射 | `FundamentalGroupoid.mk x ⟶ FundamentalGroupoid.mk y` | `fundamentalGroupoid_hom_eq_pathHomotopyQuotient` | 定义性等于 F1a 道路同伦商 | 基点自同态群 | 同上 |
| 基本群载体 | `FundamentalGroup X x` | `fundamentalGroup_eq_loopHomotopyQuotient` | 自同态群底层类型定义性等于基点环路商 | `toPath/fromPath` | 同上 |
| 两种载体视角转换 | `FundamentalGroup.toPath/fromPath` | 两条严格往返定理 | 均为缩写，不选择代表元 | 后续 F2 运算解释 | 同上 |

## 公开签名与边界

公开 Mathlib 专用接口包括 `FundamentalGroupoid`、Category Hom 记号、`FundamentalGroup`、
`Path.Homotopic.Quotient` 和 `toPath/fromPath`，均分类为语义一致、已在课程文档解释的正式承载。
没有本库 wrapper、legacy 桥或装饰性别名；证明后端全部是定义展开 `rfl`。

本批只冻结对象与载体。群胚的复合／逆虽存在于 Mathlib 实例中，但本 Entry 不登记其代数性质；
尤其不发布群乘法、单位、逆、结合律、连续映射诱导、基点变换或计算。Mathlib `p*q` 与道路拼接的
反序约定只在文档警告中披露，正式公式留给 F2。

## Main 集成建议

- F1a 集成后加入顶层 import `SandronesLibrary.Topology.FundamentalGroupCarrierStandard`。
- Registry 新增 `topology.fundamental-group.carrier-standard`；F1 完成后才评估 F2 解锁。
- 引用复用 `hatcher-algebraic-topology-2002`，定位 Section 1.1。

## 验证

- `/tmp/sandrones-library/FundamentalGroupCarrierPrototype.lean` 中五条正式接口先行编译通过；冻结的群乘法顺序只作研究证据。
- `lake env lean SandronesLibrary/Topology/FundamentalGroupCarrierStandard.lean` 通过。
- `lake build SandronesLibrary.Topology.FundamentalGroupCarrierStandard SandronesLibrary.Topology.PathHomotopyQuotientStandard SandronesLibrary.Topology.HomotopyEquivalenceStandard SandronesLibrary.Topology.HomotopyStandard SandronesLibrary.Topology.PathReparameterization SandronesLibrary.Topology.PathConnected SandronesLibrary.Topology.MathlibCompatibility` 通过，共 1755 jobs。
- `/tmp/sandrones-library/TopologyF1bFundamentalGroupCarrierAudit.lean` 同时检查群胚对象、F1a 商承载、基本群及两个转换，并 `#check` 五条公开接口。对象还原只依赖 `Quot.sound`，其余四条公理均为 `propext`、`Classical.choice`、`Quot.sound`。
- `scripts.check_axioms.map_entry_to_decl` 将本 Entry 精确映射到 5 条公开声明，没有跨文件吸入。
- 正式源码禁用占位扫描及全部交付文件冲突标记扫描无结果；`git diff --check` 通过。
