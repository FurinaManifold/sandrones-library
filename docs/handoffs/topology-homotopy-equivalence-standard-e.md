# T4-E 标准同伦等价 handoff

## 范围与依赖门

- 分支：`codex/topology-foundations`；开工基于同步 Main `24014c0` 的提交 `c82f83c`；完成后
  同步 Main `b4ab365`，合并提交为 `ac14099`。
- 权限：`development_open`；独占 `HomotopyEquivalenceStandard.lean`。
- `integration_waits_for`: T4-H2 `topology.homotopy.standard` 进入 Main。
- 不修改任何 Main 共有文件。

## 概念链

| 教材概念 | Lean 正式承载 | 展开／一手性质 | 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 同伦等价与双侧同伦逆 | `X ≃ₕ Y` | `nonempty_homotopyEquiv_iff_exists_two_sided_homotopy_inverse` | 四字段与教材定义一致，直接复用 | `HomotopyEquiv.symm/trans` | `topology.homotopy.equivalence-standard` |
| 同伦等价存在关系 | `Nonempty (X ≃ₕ Y)` | `nonempty_homotopyEquiv_refl/symm/trans` | 不新增装饰性 Prop 别名 | 后续同伦不变量 | 同上 |
| 同胚诱导同伦等价 | `Homeomorph.toHomotopyEquiv` | `homeomorph_toHomotopyEquiv_apply` | 严格逆是双侧同伦逆的充分条件 | 同胚下不变量保持 | 同上 |

## 公开签名与数学边界

公开 Mathlib 专用接口 `ContinuousMap`、`Homotopic`、`HomotopyEquiv`、`Homeomorph` 以及两个等价
记号均为语义一致且已解释的正式承载。没有本库包装定义、旧结构桥或越级泄漏。证明后端仅使用
结构构造器、`Nonempty.map/map2` 和标准 `refl/symm/trans`。

左右方向固定为 `g.comp f ~ id_X` 与 `f.comp g ~ id_Y`。同胚只单向诱导同伦等价；本批不声称
逆命题，不证明具体空间例子、基本群不变性或其他拓扑不变量，也不修改旧
`TextbookTopology.HomotopyEquivalence`。

## Main 集成建议

- H2 进入 Main 后加入顶层 import `SandronesLibrary.Topology.HomotopyEquivalenceStandard`。
- Registry 新增 `topology.homotopy.equivalence-standard`，并更新 T4-E ROADMAP/RADAR。
- 引用复用 `hatcher-algebraic-topology-2002`，章节定位为 Section 0。

## 验证

- `/tmp/sandrones-library/HomotopyEquivalenceStandardPrototype.lean` 中五项无占位原型编译通过。
- `lake env lean SandronesLibrary/Topology/HomotopyEquivalenceStandard.lean` 通过。
- `lake build SandronesLibrary.Topology.HomotopyEquivalenceStandard SandronesLibrary.Topology.HomotopyStandard SandronesLibrary.Topology.PathReparameterization SandronesLibrary.Topology.PathConnected SandronesLibrary.Topology.MathlibCompatibility` 通过，共 1673 jobs。
- `/tmp/sandrones-library/TopologyEHomotopyEquivalenceAudit.lean` 同时检查正式承载、双侧展开、三个关系闭包、同胚桥及 H2 前置；五条公开声明的公理均为 `propext`、`Classical.choice`、`Quot.sound`。
- `scripts.check_axioms.map_entry_to_decl` 将本 Entry 精确映射到 5 条公开声明，没有跨文件吸入。
- 正式源码禁用占位扫描及交付文件冲突标记扫描无结果；`git diff --check` 通过。
