# 抽象代数维护：子群载体 Stage C1 证明所有权倒置

## 基线、权限与范围

- 开发基线：`main@dc81d70`；该提交已集成 Stage C RFC。
- 分支：`codex/abstract-algebra-c1`，独立 worktree。
- 权限：Main `development_open`，只允许 Galois 私有证明所有权倒置。
- RFC：`docs/maintenance/abstract-algebra-subgroup-carrier-stage-c.md`。
- 影响等级：公开签名不变的 M0 实现调整，是 M2 兼容迁移的 C1 前置。

本批只修改：

- `SandronesLibrary/AbstractAlgebra/FieldGaloisCorrespondence.lean`；
- `docs/entries/abstract-algebra/field/galois-correspondence.md`；
- 本 handoff。

未修改 `Group.lean`、Examples、顶层 import、Registry、ROADMAP、RADAR、Playbook 或其他
Main 共有文件。

## 证明所有权变化

### fixing 子群

`fixingAutomorphismSubgroup` 现在直接由 carrier、单位、复合和逆封闭性构造正式
Mathlib `Subgroup`。历史 `fixingAutomorphismSet_isSubgroup` 保持原名和签名，但只从该
正式子群 carrier 退回教材 `SubgroupSet` 判定公式。

### 基数核心

以下私有组件现在直接接收 `H : Subgroup (FieldAutomorphismOver e)`：

- `subgroup_mathlibSubgroup_bridge`；
- `subgroupSubtype_mathlibSubgroup_equiv_bridge`；
- `fixingFixedSubtype_mathlib_equiv_bridge`；
- `subgroup_card_eq_fixingFixed_bridge`；
- `subgroup_and_fixingFixed_finite_bridge`；
- `fixedField_fixing_carrier_alignment_bridge`。

正式公开定理
`finiteExtension_subgroup_card_eq_fixingFixed_subgroup` 直接消费正式私有基数核心。
旧 `finiteExtension_subgroup_card_eq_fixingFixed` 只在最外层把
`Set + SubgroupSet` 无损转换为 `Subgroup`，再运输正式结论。

### 恢复核心

私有 `finiteExtension_fixingAutomorphismSubgroup_fixedFieldSet_bridge` 直接以正式子群为输入，
用自然包含、正式子群基数相等和有限 carrier 相等证明严格恢复。

正式公开
`finiteExtension_fixingAutomorphismSubgroup_fixedFieldSet` 直接调用该核心。旧集合版
`finiteExtension_fixingAutomorphismSet_fixedFieldSet` 只在外层转换一次并取 carrier 等式。
正式 `finiteGalois_fundamental_correspondence_subgroup` 因而沿正式恢复链闭合；旧汇总继续
保留 compatibility。

## 公开兼容性

本批没有新增、删除、改名或改签名任何公开声明，也没有改变 Entry 归属。四个旧 Galois
集合式接口继续存在：

- `fixingAutomorphismSet_isSubgroup`；
- `finiteExtension_subgroup_card_eq_fixingFixed`；
- `finiteExtension_fixingAutomorphismSet_fixedFieldSet`；
- `finiteGalois_fundamental_correspondence`。

正式首选接口继续是：

- `fixingAutomorphismSubgroup`；
- `finiteExtension_subgroup_card_eq_fixingFixed_subgroup`；
- `finiteExtension_fixingAutomorphismSubgroup_fixedFieldSet`；
- `finiteGalois_fundamental_correspondence_subgroup`。

两个跨文件真实消费者仍只调用正式恢复接口：

- `FieldGaloisConsequences.lean`；
- `FieldGaloisConsequencesRestriction.lean`。

## 带 sorry 框架记录

完整框架位于
`/tmp/sandrones-library/FieldGaloisCorrespondenceC1Framework.lean`。先完成上层旧/新接口组装，
框架阶段仅报告 sorry；随后按以下顺序逐项消除：

1. fixing 正式子群的单位、复合、逆字段；
2. 有限扩张到私有有限维后端；
3. 正式子群与 fixing 子群的有限性；
4. 正式子群到 Mathlib `AlgEquiv` 子群的对应；
5. 两侧 subtype 等价；
6. fixing-fixed subtype 等价；
7. 正式基数与恢复上层组装。

最终临时框架无 `sorry`、`admit` 或编译错误后，才移入正式文件。

## 回滚边界

C1 是单一 maintenance 提交。回滚只恢复
`FieldGaloisCorrespondence.lean` 的私有证明方向和两段 Entry 说明；所有旧公开接口始终保留，
不需要同步迁移任何下游类型或数据。

## 验证清单

实际结果：

- `lake env lean` 单独编译修改后的目标源码：通过；
- 隔离编译生成
  `/tmp/c1olean/SandronesLibrary/AbstractAlgebra/FieldGaloisCorrespondence.olean`：通过；
- 在完整只读 overlay 中优先加载该新目标产物，编译
  `FieldGaloisConsequences.lean` 与
  `FieldGaloisConsequencesRestriction.lean`：两者均通过；
- `/tmp/sandrones-library/FieldGaloisCorrespondenceC1Audit.lean`：十二项旧/新
  公开 API `#check` 全通过；
- 公理输出：fixing 封闭性为 `propext, Quot.sound`；旧/新基数、恢复和汇总接口均为
  `propext, Classical.choice, Quot.sound`，没有新增公理；
- 正式源码搜索 `sorry|admit|sorryAx|native_decide`：零命中；
- `python3 scripts/audit.py abstract-algebra.field.galois-correspondence`：通过；
- `.subgroupSet` 在 Correspondence 与两个直接下游中只剩旧 fixing 封闭性 wrapper 一处；
- `git diff --check`：通过。

全新 C1 worktree 的普通 `lake build` 会从零填充整个 Mathlib 缓存。Main 的正式预验收
确认隔离目标产物、两个真实下游和聚合审计已覆盖本批语义门，不要求学科提交等待纯缓存
重建；Main 将在缓存完整的集成工作树重跑目标、下游、公理审计和全库 build。

学科负责人不运行全库 `lake build`；共享状态与最终全库验收由 Main 处理。

## 诚实边界与后续维护发现

- 本批不做 C2/C3 deprecation 或删除。
- `SubgroupSet` 与 `generatedSubgroupSet` 继续作为教材判定/构造保留。
- 只读后续扫描发现公开 `finiteGalois_mathlibBackend` 的签名包含
  `FiniteDimensional`，与抽象代数公开签名禁止 `Module` 的规则存在潜在边界问题；这不是 C1
  授权范围，需另向 Main 提交影响图后处理。
- 环论的 `RingIsomorphism`、`TwoSidedIdealCarrier`、`SubringCarrier` 等重复正式载体也属于
  后续独立维护 RFC，不在本提交顺手迁移。
