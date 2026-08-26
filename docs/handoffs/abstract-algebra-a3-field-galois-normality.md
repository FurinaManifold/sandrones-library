# 抽象代数 A3.9c：Galois 正规性批次交接

## 范围

本批完成正规中间扩张—正规子群对应。公开 API 使用正式 `Subgroup`，不进入
restriction 核像和商群同构，也不包含 Examples。

## 去重维护

- A3.8 公开 `separableExtension_iff_mathlibIsSeparable` 与
  `normalExtension_iff_mathlibNormal`。
- A3.9b 公开自同构群乘法等价和有限 Galois 后端包。
- A3.9b 删除原先重复的可分／正规扩张转换链，统一消费 A3.8 桥。
- 新正规性模块不再复制自同构正逆构造、有限基后端或最小多项式转换。

## 交付

- `FieldGaloisConsequencesNormality.lean`
- Entry `abstract-algebra.field.galois-normality`
- `subgroup_normal_iff_fixedField_galoisExtension`
- `subgroup_normal_iff_fixedField_normalExtension`

## 关键证明状态的人类读法

1. 自同构对齐开始时，目标是把显式子群及其共同固定点送入 Mathlib 正式
   承载；构造乘法等价的子群像后，剩余目标变成逐元素成员等价和逐点固定
   条件，两者分别由像的定义与 `mem_fixedField_iff` 关闭。
2. 正规性转移开始时，目标是 `H.Normal ↔ G.Normal`；证明 `G` 等于 `H`
   在乘法等价下的像后，目标直接成为 Mathlib 的 `normal_map_iff`，没有让
   自动化吞掉群论内容。
3. 显式固定域与 Mathlib 固定域的 carrier 已相等，但 subtype 的域实例并非
   定义相同；因此先构造 carrier 恒等的基域代数同构，再把
   `IsGalois K F` 转成 `IsGalois K E`。这一步只做表示转移。
4. 核心目标 `G.Normal ↔ IsGalois K (fixedField G)` 的正向使用正规子群的
   固定域 Galois 定理；反向先得到固定域 fixing 子群正规，再由
   `fixingSubgroup_fixedField` 恢复为 `G`。最后才桥回本库扩张谓词。

## Main 集成

Main 需加入顶层导入、Registry、ROADMAP、RADAR 和派生索引。新 Entry
登记后复跑公理与条目审计。restriction 核像与商群同构仍是独立后续批次。

## 验证

- `lake env lean FieldGaloisConsequencesNormality.lean`：通过。
- 相关四模块目标构建通过，共完成 8721 个依赖任务。
- 临时聚合中的六项 `#check` 和四项 `#print axioms` 通过；关键定理只依赖
  `propext`、`Classical.choice`、`Quot.sound`。
- A3.8 与 A3.9b 既有 Entry 的 `check_axioms.py`、`audit.py` 通过。
- 新 Entry 等待 Main Registry 登记后复验；占位扫描和 `git diff --check`
  通过。
