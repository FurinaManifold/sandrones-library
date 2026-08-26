# 抽象代数维护：子群载体迁移 Stage A

## 结论

本批次把 Mathlib `Subgroup G` 确立为子群的正式语义载体。历史定义 `SubgroupSet H`
不删除，只作为“集合对群运算封闭”的教材判定法和兼容层。此前 RFC 位于学科分支提交
`e689a9d`，经 Main 审核后不作为永久事实源入库；本文件记录获准实施的 Stage A。

## 本批次接口

- `SubgroupSet.toSubgroup`：由集合式封闭性证明直接构造正式子群。
- `SubgroupSet.mem_toSubgroup_iff`、`SubgroupSet.coe_toSubgroup`：转换不改变成员与承载集。
- `Subgroup.subgroupSet`、`SubgroupSet.toSubgroup_subgroupSet`：兼容反向桥和往返不变性。
- `SubgroupSet.toSubgroup_le_iff`、`SubgroupSet.le_toSubgroup_iff`：与任意正式子群比较的
  通用消费者，后续理论可直接使用 `H : Subgroup G`。
- `subgroupSet_iff_exists_subgroup` 的公开签名保持不变，但实现改用直接桥。

## 迁移边界

`generatedSubgroupSet` 从本批次起冻结；新 API 使用 `Subgroup.closure`。本批次不迁移
`NormalSubgroupSet`、商群、Galois 对应或其他下游公开签名，也不加入稳定子、交错群、
内自同构群等具体例子。后者属于 Examples 学科。

Stage B 必须再次取得 Main 许可，且只迁移一般理论接口；Stage C 删除兼容层仍冻结，
必须等待旧载体用户归零、跨学科复核及 Main 全库构建通过。

## 兼容性与回滚

旧 `SubgroupSet`、`generatedSubgroupSet` 及其现有定理均保留，因此当前直接消费者无需
同步修改。Stage A 完成时，除 `Group.lean` 外仍有 6 个直接使用旧载体的文件，共 25 处：
`FieldGaloisCorrespondence.lean` 13 处、`GroupAction.lean` 1 处、
`GroupAutomorphism.lean` 2 处、`GroupCyclic.lean` 4 处、`GroupPermutation.lean` 2 处、
`GroupProduct.lean` 3 处。这些数字只用于后续影响评估，不构成 Stage B 开工许可。

本批次的回滚边界是单独的 Stage A 学科提交；回滚不会要求恢复任何下游签名。

## 验证

- `lake env lean SandronesLibrary/AbstractAlgebra/Group.lean`：通过。
- `lake build` 指定 `Group`、`GroupCyclic`、`GroupProduct`、
  `FieldGaloisCorrespondence`：通过，共完成 8722 个依赖任务。
- `/tmp/sandrones-library/SubgroupCarrierMigrationStageAAudit.lean`：新桥、旧接口的
  `#check` 全通过；关键定理只依赖 Lean/Mathlib 标准公理 `propext`、`Quot.sound`。
- `python3 scripts/check_axioms.py abstract-algebra.group.def`：公理字段一致。
- `python3 scripts/audit.py abstract-algebra.group.def`：条目审计通过。
