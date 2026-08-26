# 抽象代数子群载体 Stage C 兼容层审查 RFC

## 结论与权限

本 RFC 基于 `main@594bf45`，影响等级为 **M2 的 Stage C 研究**。Stage B4 已由 Main
确认没有需要迁移的真实下游，因此本轮只分类剩余公开 API，不修改 Lean 源码。

总原则是区分“教材公式”和“正式对象”：

- Mathlib `Subgroup G` 是子群理论的正式语义载体；
- `SubgroupSet H` 是把单位元、乘法和逆元封闭性逐项写出的教材判定公式；
- `generatedSubgroupSet S` 是“所有包含 `S` 的子群之交”的教材集合式构造；
- 新理论不得继续用 `Set G + SubgroupSet H` 承载子群对象；
- 教材展开不能仅因 Mathlib 已有同义正式结构而删除，但只为旧实现服务的公开 plumbing
  也不应永久冒充课程主接口。

本轮权限只有 `research_open`。任何删除、改名、降为 `private`、添加弃用标记或改写
证明所有权，都等待 Main 另行授予精确 `development_open`。

## 当前影响图

全库排除
`SandronesLibrary/AbstractAlgebra/Group.lean` 与
`SandronesLibrary/AbstractAlgebra/FieldGaloisCorrespondence.lean` 后，
`SubgroupSet`、`NormalSubgroupSet` 和 `generatedSubgroupSet` 在 Lean 源码中没有
签名或证明消费者；只在两个 Galois Consequences 文件的模块说明中提到历史接口。

`GroupCyclic.lean` 与 `GroupProduct.lean` 已直接使用正式 `Subgroup`。
Galois 的两个跨文件真实消费者：

- `FieldGaloisConsequences.lean:82`；
- `FieldGaloisConsequencesRestriction.lean:145`；

均调用正式
`finiteExtension_fixingAutomorphismSubgroup_fixedFieldSet`。因此 Stage C 不承担下游迁移，
只审查定义文件内的教材层、兼容层和证明所有权。

## `Group.lean` 逐项分类

以下声明均归属 Entry `abstract-algebra.group.def`。

| 声明 | 当前角色与教学价值 | 外部破坏风险 | 建议 |
|---|---|---|---|
| `SubgroupSet`（55） | 逐项写出子群判定公式；适合教材首次解释，但不是正式对象 | 高：可能有外部用户直接以集合判定子群 | **keep**；文档明确“判定公式，不是第二种子群载体” |
| `generatedSubgroupSet`（72） | 所有包含生成元的子群集合之交；展示生成子群的教材构造 | 高：课程定义及外部集合式证明可能依赖 | **keep**；冻结新跨文件消费者，正式理论用 `Subgroup.closure` |
| `SubgroupSet.toSubgroup`（93） | 将教材判定证明一次性打包成正式 `Subgroup` | 中：是必要的有向桥，也是 Galois 正式 fixing 子群当前构造依赖 | **keep** |
| `SubgroupSet.mem_toSubgroup_iff`（103） | 桥不改变成员关系 | 低至中 | **keep**，作为桥的一手展开 |
| `SubgroupSet.coe_toSubgroup`（111） | 桥不改变 carrier | 低至中 | **keep**，作为运输旧集合定理的必要接口 |
| `Subgroup.subgroupSet`（125） | 正式子群退回教材封闭性证明 | 中：现有 compatibility wrapper 使用 | **document-as-compat**；禁止新主证明以此回到旧证明链 |
| `SubgroupSet.toSubgroup_subgroupSet`（140） | 正式载体与旧判定层往返不变 | 低 | **keep**，说明桥的无损性 |
| `SubgroupSet.toSubgroup_le_iff`（151） | 把旧集合包含关系转为正式子群序 | 低 | **keep**，通用消去桥 |
| `SubgroupSet.le_toSubgroup_iff`（159） | 正式子群包含于旧集合的反向序桥 | 低 | **keep**，通用消去桥 |
| `subgroupSet_iff_exists_subgroup`（167） | 判定公式等价于存在相同 carrier 的正式子群 | 中：是教材判定与正式承载的总语义核对 | **keep** |
| `generatedSubgroupSet_is_subgroup`（192） | 证明教材交构造确实封闭 | 中：教材定义的一手性质 | **keep** |
| `subset_generatedSubgroupSet`（205） | 生成元包含于生成子群 | 中：教材定义的一手性质 | **keep** |
| `generatedSubgroupSet_least`（213） | 集合式最小性；签名仍量化 `SubgroupSet` | 中：教材定义的核心泛性质 | **keep**，但不作为新理论的正式输入 |
| `generatedSubgroupSet_eq_mathlib_closure`（221） | 教材集合构造与正式 `Subgroup.closure` carrier 对齐 | 中：正式承载选择的核心证据 | **keep** |

### Group 层判定

`SubgroupSet` 与 `generatedSubgroupSet` 不是应该删除的“第二套正式结构”：前者是 Prop
判据，后者是集合式教材构造；二者都没有实例系统或上层理论继续传播。真正需要冻结的是把
它们重新当作正式子群对象的开发方式。

`Subgroup.subgroupSet` 是唯一明确的反向 compatibility 桥。它目前不宜弃用，因为旧
Galois wrapper 仍使用它；若 Stage C 后续完成 Galois 证明所有权倒置，可再评估
**deprecate-later**，而不是立即删除。

当前仓库不存在 `NormalSubgroupSet` 定义或消费者。正规子群已使用
`Subgroup.Normal`，不得重新引入集合式平行载体。

## `FieldGaloisCorrespondence.lean` 逐项分类

以下公开声明均归属 Entry
`abstract-algebra.field.galois-correspondence`。

| 旧集合式公开声明 | 正式接口 | 当前内部消费者 | 建议 |
|---|---|---|---|
| `fixingAutomorphismSet_isSubgroup`（101） | `fixingAutomorphismSubgroup`（113）及成员/carrier 桥 | 正式 fixing 子群构造（117） | **document-as-compat**；证明所有权倒置后 **deprecate-later** |
| `finiteExtension_subgroup_card_eq_fixingFixed`（1493） | `finiteExtension_subgroup_card_eq_fixingFixed_subgroup`（1508） | 正式基数定理（1515–1517）及私有恢复链（1547） | **document-as-compat**；正式定理成为证明根后 **deprecate-later** |
| `finiteExtension_fixingAutomorphismSet_fixedFieldSet`（1572） | `finiteExtension_fixingAutomorphismSubgroup_fixedFieldSet`（1585） | 正式恢复定理（1591–1593）与旧汇总（1636） | **document-as-compat**；证明所有权倒置后 **deprecate-later** |
| `finiteGalois_fundamental_correspondence`（1624） | `finiteGalois_fundamental_correspondence_subgroup`（1644） | 无 Lean 消费者 | **deprecate-later**；保留兼容期，不直接删除 |

`finiteGalois_fixedFieldSet_fixingAutomorphismSet`（1558）的输入是中间域集合而非
`Set + SubgroupSet` 子群载体；它表达中间域恢复，本 RFC 不把它列为旧子群 API。
其正式 fixing 子群版本
`finiteGalois_fixedFieldSet_fixingAutomorphismSubgroup`（1603）继续作为首选接口。

## 私有证明 plumbing

当前 Galois 证明链仍以旧集合判定层为根，至少包括：

- `subgroupSet_mathlibSubgroup_bridge`（798）；
- `fixedField_fixing_carrier_alignment_bridge`（886）；
- `subgroup_card_eq_fixingFixed_bridge`（1337）；
- `subgroup_and_fixingFixed_finite_bridge`（1356）；
- `finiteExtension_fixingAutomorphismSet_fixedFieldSet_bridge`（1538）。

这些声明本来就是 `private`，不构成外部 API，但说明正式接口仍反向包装旧集合证明。后续若
Main 开放实现波次，建议进行 **证明所有权倒置**：

1. 核心私有引理直接接收 `H : Subgroup (FieldAutomorphismOver e)`；
2. 正式基数、恢复和基本对应接口直接消费这些私有核心；
3. 旧集合公开定理只在最外层调用一次 `SubgroupSet.toSubgroup H hH`，利用 carrier 等式
   运输正式结论；
4. `.subgroupSet` 不再出现在 Galois 核心证明链；
5. 不新增 fixing、closure、subgroup 或 normal 的平行包装对象。

这是一项公开签名不变的内部所有权调整，可单独作为 M0 实现提交；但它是后续弃用旧 API 的
必要前置，不应与 deprecation 或删除压在同一提交。

## Stage C 建议波次

### C0：本 RFC

- 只完成逐声明分类和影响图；
- 不修改 Lean；
- 回滚点为 docs-only 提交。

### C1：证明所有权倒置

- 仅改 `FieldGaloisCorrespondence.lean` 私有实现和现有定理证明体；
- 所有公开签名、声明名和 Entry 归属保持不变；
- 验收要求旧/新接口聚合 `#check` 全通过，两个真实下游定向构建通过；
- 该波次需要 Main 单独授予 `development_open`。

### C2：兼容说明与可选弃用

- 在 docstring/Entry 中把四个 Galois 集合接口明确标为 compatibility；
- 若 Main 决定添加 Lean deprecation，必须指定替代名和兼容期限；
- `Group.lean` 的教材判定和生成构造继续保留；
- 不删除任何公开声明。

### C3：潜在退役

只有全库源码、文档、Registry、RADAR、Examples 的旧 API 使用归零、跨学科负责人复核、
Main 全量公理审计/audit/build 通过，并明确考虑外部 API 破坏后才能申请。默认结论是保留
薄兼容 wrapper，而不是自动删除。

## 公开签名角色清单

| 数学概念 | 教材语义 | 正式 Lean 承载 | 展开/桥 | 首个真实上层使用者 |
|---|---|---|---|---|
| 子群 | 群中对运算封闭的子对象 | Mathlib `Subgroup` | `SubgroupSet` 与 `toSubgroup` | 循环子群、内部直积、Galois fixing 子群 |
| 生成子群 | 包含给定集合的最小子群 | Mathlib `Subgroup.closure` | `generatedSubgroupSet_eq_mathlib_closure` | `generatedSubgroup` 及循环子群理论 |
| fixing 自同构群 | 逐点固定给定集合的基域自同构子群 | Mathlib `Subgroup`，由 `fixingAutomorphismSubgroup` 给出 | 成员与 carrier 桥 | Galois Consequences 与 Restriction |
| 有限 Galois 对应 | 中间域与自同构子群反变恢复 | `IntermediateFieldSet` 与 Mathlib `Subgroup` | 旧集合接口仅作兼容 | 次数—指数和限制同态结论 |

## 诚实边界与 Main 需要裁决的事项

- 本 RFC 不声称仓库外用户已经归零。
- 文档注释中的历史名称不等于代码消费者，但潜在外部兼容仍需考虑。
- `SubgroupSet` 和 `generatedSubgroupSet` 有独立教材价值，本 RFC 明确建议保留。
- 四个 Galois 集合式公开接口建议先完成 C1，再讨论 deprecation；当前不建议删除。
- Main 共有文件 `PLAYBOOK`、Registry、ROADMAP、RADAR 和顶层 import 未修改。
- 请求 Main 审核后只开放最窄 C1：Galois 私有证明所有权倒置；若 Main 判断收益不足，也可
  保持现状并关闭 Stage C，不应为了产生提交而重写已验证证明。
