# 抽象代数维护：子群载体迁移 Stage B1 Galois

## 范围与结论

本批次把有限 Galois 对应的群一侧迁移到 Mathlib `Subgroup` 正式载体，并让
次数—指数与 restriction 两个真实下游消费者直接使用新恢复接口。历史
`SubgroupSet` API 全部保留为 compatibility；本批没有删除声明、改变旧签名，
也没有复制有限 Galois 基本对应的证明链。

本批权限为 Main `development_open`，实施基线为 Main `0f46a18`。修改范围仅为
Correspondence、两个既有消费者、本 Entry 文档及本 handoff；共享导入、Registry、
ROADMAP、RADAR 与 Playbook 留给 Main 集成。

## 新增稳定接口

- `fixingAutomorphismSubgroup e E`：carrier 为 `FixingAutomorphismSet e E` 的
  正式 `Subgroup (FieldAutomorphismOver e)`。
- `mem_fixingAutomorphismSubgroup_iff`：成员等价于逐点固定 `E`。
- `fixingAutomorphismSubgroup_carrier`：正式子群 carrier 与旧 fixing 集合严格相等。
- `finiteExtension_subgroup_card_eq_fixingFixed_subgroup`：有限扩张下正式子群与
  其固定域 fixing 子群基数相同。
- `finiteExtension_fixingAutomorphismSubgroup_fixedFieldSet`：有限扩张下正式
  子群由其固定域严格恢复。
- `finiteGalois_fixedFieldSet_fixingAutomorphismSubgroup`：有限 Galois 下显式
  中间域由 fixing 正式子群恢复。
- `finiteGalois_fundamental_correspondence_subgroup`：首选正式子群汇总接口。

旧 `fixingAutomorphismSet_isSubgroup`、集合级数值接口、两个集合恢复定理及
`finiteGalois_fundamental_correspondence` 均保持原名和签名。旧汇总已明确标注
为 compatibility，新汇总为后续课程代码首选。

## 六项路线问题

1. **教材对象是什么？** 固定集合的自同构群，以及有限 Galois 扩张中
   中间域与自同构子群的反变恢复。
2. **正式承载是什么？** fixing 条件仍由 `FixingAutomorphismSet` 展开，子群
   数据直接使用 Mathlib `Subgroup`；不新造第二种子群结构。
3. **是否重复造轮子？** 否。正式接口通过 `SubgroupSet.toSubgroup`、
   carrier extensionality 和既有集合级恢复结果组装，没有复制固定点、
   基数或维数证明。
4. **真实消费者是谁？** `FieldGaloisConsequences` 的相对次数公式和
   `FieldGaloisConsequencesRestriction` 的 kernel 识别都改为消费正式子群恢复。
5. **兼容边界是什么？** 旧 API 保留；`.subgroupSet` 只允许存在于
   Correspondence 内部的薄兼容证明，不再出现在两个下游消费者中。
6. **后续门禁是什么？** Main 登记变更后运行全库 build、Entry/公理审计并
   复核其他旧载体消费者；本批不授权迁移群作用、循环群、内部直积或
   商群。

## 概念清单与公开签名分类

| 概念 | 教材语义 | Lean 正式承载 | 展开／桥 | 首个真实使用者 |
|---|---|---|---|---|
| fixing 自同构群 | 逐点固定给定集合的基域自同构 | Mathlib `Subgroup` | `mem_fixingAutomorphismSubgroup_iff` 与 carrier 等式 | 正式子群恢复 |
| 固定域 | 被给定自同构族共同固定的元素 | 本库 `FixedFieldSet`，仍接受任意 `Set` | fixing/fixed 反变关系 | 有限 Galois 基本对应 |
| 有限 Galois 对应 | 中间域与正式自同构子群互相恢复 | `IntermediateFieldSet` 与 Mathlib `Subgroup` | 两个正式恢复定理 | Consequences 与 Restriction |

`Subgroup` 是语义一致且已解释的正式公开承载；`SubgroupSet` 只在兼容
声明和 Correspondence 内部的薄运输证明中出现。`FiniteDimensional`、
`IsGalois`、Mathlib 打包中间域和 `AlgEquiv` 继续只属既有私有后端。
本批没有新的越级公开结构，也没有把任意 fixing 族错误要求为子群。

## 证明复用与回滚

正式 fixing 子群直接消费已验证的 `fixingAutomorphismSet_isSubgroup`。正式群阶
接口用 subtype 的定义性对齐复用旧群阶结果；正式子群恢复只对旧 carrier
等式做 `Subgroup.ext`；正式中间域恢复只用 carrier simp 搬运旧恢复定理。

两个下游证明都先取得
`finiteExtension_fixingAutomorphismSubgroup_fixedFieldSet e hfin H`，再用
`congrArg` 取 carrier 等式。因此它们不再携带 `H.subgroupSet`，且没有依赖
新实现细节。

回滚点是本批独立学科变更：恢复两个下游旧证明并删除七个薄接口即可；
旧 API 从未删除，故回滚不涉及数学证明链或数据迁移。

## 验证命令

```bash
lake env lean \
  SandronesLibrary/AbstractAlgebra/FieldGaloisCorrespondence.lean
lake env lean \
  SandronesLibrary/AbstractAlgebra/FieldGaloisConsequences.lean
lake env lean \
  SandronesLibrary/AbstractAlgebra/FieldGaloisConsequencesRestriction.lean

lake build SandronesLibrary.AbstractAlgebra.FieldGaloisCorrespondence
lake build SandronesLibrary.AbstractAlgebra.FieldGaloisConsequences
lake build SandronesLibrary.AbstractAlgebra.FieldGaloisConsequencesRestriction

rg -n "\\.subgroupSet" \
  SandronesLibrary/AbstractAlgebra/FieldGaloisConsequences.lean \
  SandronesLibrary/AbstractAlgebra/FieldGaloisConsequencesRestriction.lean
rg -n "sorry|TODO|admit|sorryAx|native_decide" \
  SandronesLibrary/AbstractAlgebra/FieldGaloisCorrespondence.lean \
  SandronesLibrary/AbstractAlgebra/FieldGaloisConsequences.lean \
  SandronesLibrary/AbstractAlgebra/FieldGaloisConsequencesRestriction.lean
git diff --check
```

Main 集成时还需处理 Registry/路线图等共享文件，并在 Entry 登记后运行
`scripts/audit.py`、`scripts/check_axioms.py` 与全库 build。本学科分支不提交
或修改这些共享集成文件。

负责人复验结果：三个目标联合构建完成 `8722/8722`；临时聚合同时
`#check` 七项新 API 与五项旧兼容 API。六项可证明公开声明的公理依赖为
`propext`、`Quot.sound`，或再加既有有限 Galois 证明所需的
`Classical.choice`。声明映射确认 Entry
`abstract-algebra.field.galois-correspondence` 共关联 46 项公开声明，新增七项
全部归入该唯一 Entry。子 Agent 只修改本批五个所有权文件，负责人复审后
未发现需要退回的数学、接口或重复承载问题。
