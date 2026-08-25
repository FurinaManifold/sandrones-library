# 拓扑基础正式承载 A1 handoff

## 批次与提交范围

- 分支：`codex/topology-foundations`。
- 成果提交：`aa6079d`。
- Main 决定：`topology-mathlib-compatibility-main-review.md`，A1 原 Entry 原地迁移。
- Entry：`topology.foundation.structure`，仍由 `SandronesLibrary/Topology/Foundation.lean` 承载。
- 文档：`docs/entries/topology/foundation/structure.md`。
- 影响等级：M2 阶段 A1 第一波；旧 API 完整保留，不删除、不改名。

## 教材语义链

| 教材概念 | Mathlib 正式承载 | 展开／教材刻画 | legacy compatibility | 首个新使用者 | Entry |
|---|---|---|---|---|---|
| 拓扑空间与开集 | `TopologicalSpace`、`IsOpen` | `topologicalSpace_open_axioms` | `TextbookTopology`、`equivMathlib` | `continuous_iff_preimage_open` | `topology.foundation.structure` |
| 闭集 | `IsClosed` | 补集开；Mathlib 基础定义 | `TextbookTopology.IsClosed` | 后续 A1 子空间链 | `topology.foundation.structure` |
| 连续映射 | 根 `Continuous` | `continuous_iff_preimage_open` | 旧 `TextbookTopology.Continuous`、`continuous_iff_mathlib` | 后续 A1 构造链 | `topology.foundation.structure` |
| 同胚 | `Homeomorph`／`X ≃ₜ Y` | `nonempty_homeomorph_iff_exists_equiv` | 旧 `Homeomorphism` | 后续拓扑不变量 | `topology.foundation.structure` |

所有新声明的公开签名直接使用 Mathlib 正式承载。旧结构只留在同一文件后半部以及显式兼容桥中；
没有新增包装 `def`、notation、instance 或从 Mathlib 转回 legacy 的新课程使用者。

## 原地迁移说明

- Entry id 不变，不建立 `topology.foundation.*-mathlib-carrier` 第二套条目。
- `Foundation.lean` 的前三条公开教材接口现在先于 legacy 声明，并共享原 Entry 标记。
- 课程文档已把 typeclass 方括号、开集公理、连续原像条件和同胚正逆连续条件解释成人话。
- 原 `TextbookTopology` 链保留为兼容历史，不再描述为正式课程定义。

## 旧 API 使用计数

当前 `SandronesLibrary/Topology` 中：

- 含 `TextbookTopology` 的 Lean 文件：19；词法出现 222 次；
- 旧链目标模块中的 `Continuous` 词法出现约 96 次；
- 拓扑目录外直接使用 `TextbookTopology`、`PathHomotopic` 或 `LoopHomotopyClasses` 的 Lean 文件：0。

本波只建立正式入口，符合“先新增正式接口、后迁移下游”；使用计数暂未下降。第二波获准后迁移
`Constructions` 的子空间、积和道路连通链。

## Main 共有文件建议

- Registry 保持 id `topology.foundation.structure`，将正式承载改为 Mathlib explained reuse；旧声明
  标为 legacy compatibility，不另立课程 Entry。
- RADAR 登记 `TopologicalSpace`、`IsOpen`、`Continuous`、`Homeomorph` 及三个教材刻画接口。
- ROADMAP 将 A1 第一波标为 staging；顶层 import 路径无需变化。
- 公理字段和生成索引由 Main 集成后重建；学科分支不修改共有文件。

## 验收与边界

- `/tmp` 中三条新接口单独组装通过后才进入正式文件。
- `Foundation`、完整旧拓扑依赖闭包至 `PathReparameterization` 以及 `MathlibCompatibility` 联合构建
  通过，共 984 jobs。
- 聚合文件同时检查三条 Mathlib 正式接口、legacy 结构、连续性桥和结构等价桥；三条新结果的公理
  分别为：无、无、`Quot.sound`。最后一项来自 `Homeomorph/Equiv` 的既有承载，不是新增数学假设。
- Entry 映射得到 `topology.foundation.structure` 19 个声明，其中前三个是新正式接口，后 16 个是
  冻结 legacy 声明；文档保持精确八段。
- 暂不迁移子空间、积、道路连通、同伦或基本群；不删除旧 API。
