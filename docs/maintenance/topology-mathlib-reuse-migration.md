# 拓扑基础设施复用 Mathlib 的兼容迁移 RFC

## 决策与等级

- Main 指示：`/home/pisquare/czt/review-inbox/topology/topology-mathlib-reuse-guidance.md`。
- 基线：分支 `codex/topology-foundations` 已在提交 `2ceb668` 合并 Main `8d5d823`。
- 影响等级：**M2**。教材语义基本相同，但现有公开签名显式携带
  `TextbookTopology`，Mathlib 使用 `TopologicalSpace` typeclass；必须双轨迁移，不能直接删除。
- 立即冻结：不再给 `TextbookTopology`、本库 `Path`、`Homotopy`、`PathHomotopy`、
  `LoopHomotopyClasses` 增加新课程定理或群结构。
- 本轮不修改任何公开 Lean 接口；只完成影响审计和迁移设计。

## 教材概念与正式承载

| 教材概念 | Mathlib 正式承载 | 现有自建接口 | 语义核对 | 迁移方向 | 直接下游 |
|---|---|---|---|---|---|
| 拓扑空间、开闭集、连续、同胚 | `TopologicalSpace`、`IsOpen`、`IsClosed`、`Continuous`、`Homeomorph` | `TextbookTopology` 及其 `IsOpen/IsClosed/Continuous/Homeomorphism` | 教材语义一致；差异是显式参数对 typeclass | Mathlib 成为新公开承载；旧结构冻结为兼容层 | 所有当前自建拓扑模块 |
| 诱导、子空间、积拓扑 | `TopologicalSpace.induced`、subtype/product 实例 | `induced`、`subspace`、`product` | 语义一致 | 新条目直接解释并复用实例；不再扩张本库构造 | `RealLine`、`PathConnected`、`Homotopy` |
| 实直线与单位区间 | 实数标准拓扑、`unitInterval : Set ℝ` 及 subtype | `realLine`、`unitInterval` | 语义一致 | 新道路接口直接使用 Mathlib 单位区间 | `Path`、所有拼接与重参数化模块 |
| 道路、常值、反向、拼接、重参数化 | `Path`、`Path.refl/symm/trans/reparam` | `TextbookTopology.Path` 及同名运算 | 端点数据和连续参数道路语义一致 | 新课程签名直接用 Mathlib `Path` | `PathConnected`、`Homotopy`、基本群链 |
| 道路连通与道路分支 | `Joined`、`JoinedIn`、`IsPathConnected`、`pathComponent` | 本库同名谓词与集合 | 语义一致；本库 `IsPathConnected` 通过 subtype 表达，与 `JoinedIn` 等价 | 采用 Mathlib 正式承载并补教材解释，不复制定理 | `Homotopy`；当前无跨学科 Lean 使用者 |
| 一般同伦与相对端点道路同伦 | `ContinuousMap.Homotopy`、`ContinuousMap.HomotopyRel`、`Path.Homotopy`、`Path.Homotopic` | `Homotopy`、`PathHomotopy`、`Homotopic`、`PathHomotopic` | 语义一致；Mathlib 把连续映射和相对集合条件打包得更一般 | 新课程签名直接采用 Mathlib；旧二维粘合技术链冻结 | 同伦等价、可缩、道路商 |
| 同伦等价与可缩性 | `ContinuousMap.HomotopyEquiv`（记号 `X ≃ₕ Y`）、`ContractibleSpace` | `HomotopyEquivalence`、`IsContractible` | 教材语义一致；`ContractibleSpace` 采用 typeclass Prop | 保留“可缩 iff 存在收缩”作为可迁移教材定理，改用 Mathlib 承载 | 道路同伦类商 |
| 道路同伦类与基本群 | `Path.Homotopic.Quotient`、`FundamentalGroupoid`、`FundamentalGroup` | `LoopHomotopyClasses`、`concat`、`inverse` | 环路商语义一致；Mathlib 已完成群胚及端点自同态群包装 | 停止手建单位律、结合律、逆律；直接解释并使用 Mathlib 基本群 | 尚无跨学科 Lean 使用者 |

## 当前影响图

逐模块的声明级对应、Mathlib 精确名称和处置结论见
`docs/maintenance/topology-mathlib-api-matrix.md`。

自建链的 Lean 依赖拓扑为：

```text
Foundation
  -> Constructions -> RealLine -> Path -> PathConnected -> Homotopy
  -> RealOperations -----------------------------^       |
                                                        v
HomotopyRelation -> HomotopyEquivalence -> Contractible
  -> LoopHomotopyClasses -> PathHomotopyConcat -> LoopHomotopyConcat
  -> PathHomotopyReverse -> PathReverseConcat
  -> UnitIntervalInterpolation -> PathReparameterization
```

全库扫描未发现 `SandronesLibrary/Topology` 以外的 Lean 模块直接使用
`TextbookTopology`、`PathHomotopic` 或 `LoopHomotopyClasses`。因此当前迁移扇出局限在拓扑学科；
文档、Registry、RADAR 和顶层 import 仍由 Main 在集成阶段处理。

## 三类近期成果

### A. 保留数学内容并迁移正式签名

- 教材对道路、道路同伦、同伦等价、可缩性和基本群的自然语言定义及端点条件说明。
- `IsContractible ↔ 存在收缩同伦` 这类教材刻画；迁移后以 `ContractibleSpace` 和
  `ContinuousMap.Homotopy` 陈述。
- 基本群是基本群胚某点自态射群、代表元拼接对应群乘法等教材接口说明。

### B. 冻结的重复承载

- `TextbookTopology` 与本库 `Continuous/Homeomorphism`。
- `realLine`、`unitInterval`、本库 `Path/Loop`。
- 本库 `Homotopy/PathHomotopy/HomotopyEquivalence`。
- `LoopHomotopyClasses` 及其 `concat/inverse`。

这些名称在阶段 C 以前保留以保证既有提交可编译，但不得成为新条目的依赖入口。

### C. 暂停累计的承载维护引理

- 本库实数加法、乘法、仿射映射连续性的重证。
- 单位区间左右倍速、反射、插值及二维闭覆盖粘合技术。
- 仅用于自建道路／同伦的拼接连续性、重参数化、单位律、结合律和逆律证明。

这类结果可留作历史实现证据，但不再计为拓扑课程前沿进度。`/tmp` 中尚未入库的
`PathUnitLaws.lean` 明确废止，不进入正式库。

## 兼容桥与等价边界

当前 `TextbookTopology.toMathlib` 只给出旧结构到 `TopologicalSpace` 的显式桥，并有
`continuous_iff_mathlib`。它足以核对单个旧签名，但还不是结构级双向等价。

阶段 A 如需让旧定理服务于迁移，只新增隔离的兼容桥：

1. 从 `TopologicalSpace X` 构造冻结的 `TextbookTopology X`；
2. 证明开集逐点相同以及两次转换的结构外延等式；
3. 对高层对象只在确有旧定理需要复用时建立方向明确的转换，不复制 Mathlib API；
4. 新课程模块不得通过“先转回 TextbookTopology”继续开发。

若某个高层对象无法证明双向等价，应把它升级为 M3 单独审查，不能以同名推断等价。

## 迁移波次与回滚点

1. **A0 解释入口**：新建 Mathlib 正式承载的拓扑概念说明与最小 `#check` 入口；旧链零改动。
   回滚点是删除该新增入口。
2. **A1 基础课程迁移**：连续、同胚、子空间、积、道路连通的课程条目改指 Mathlib 承载；
   保留旧 Entry 为 legacy，不改旧 Lean 名称。
3. **A2 同伦课程迁移**：以 `ContinuousMap.Homotopy`、`Path.Homotopy`、
   `ContinuousMap.HomotopyEquiv`、`ContractibleSpace` 建立教材出口。
4. **A3 基本群课程迁移**：直接以 `Path.Homotopic.Quotient`、`FundamentalGroupoid`、
   `FundamentalGroup` 解释商、复合、逆和群结构；不再手证旧商的群律。
5. **B 下游切换**：按同文件、拓扑上层、跨学科、文档顺序迁移。目前跨学科 Lean 直接使用数为零。
6. **C 旧接口退役**：只有全库源码／文档／Registry／RADAR／示例使用归零、Main 全库构建和公理
   审计通过后才申请；外部兼容需要时保留 deprecated 薄层。

每个波次独立提交，不能把新增正式入口、迁移所有条目和删除旧链压成一次提交。

## 验收与诚实边界

- 已用临时聚合文件核对 Mathlib 正式名称：`TopologicalSpace`、`Continuous`、`Homeomorph`、
  `unitInterval`、`Path`、`Path.Homotopy`、`Path.Homotopic.Quotient`、
  `ContinuousMap.Homotopy/ HomotopyRel/HomotopyEquiv`、`ContractibleSpace`、`Joined/JoinedIn`、
  `IsPathConnected`、`pathComponent`、`FundamentalGroupoid`、`FundamentalGroup`。
- 尚未修改公开接口，尚未建立新旧高层对象的完整等价桥，也未迁移任何 Registry Entry。
- 当前拓扑分支中的后续自建同伦与基本群提交只算冻结中的施工成果，不应由 Main 登记为课程完成。
- Main 共有文件由 Main 维护；本 RFC 不修改 Registry、RADAR、ROADMAP 或顶层 import。
