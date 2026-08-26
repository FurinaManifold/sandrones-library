# 抽象代数 A3.9c：Galois 次数—指数交接

## 权限与范围

- Main 已将 A3.9c 一般推论提升为 `development_open`。
- 本批只完成次数—指数公式，不进入正规子群、restriction 核像或商群
  同构。
- 具体有限扩张计算继续归 Examples E6.12。
- 子群公开签名使用正式 `Subgroup`；`SubgroupSet` 仅在 A3.9b 兼容调用中出现。

## 交付

- A3.9b 薄数值接口：`finiteGalois_automorphism_card_eq_degree`。
- 新模块：`SandronesLibrary/AbstractAlgebra/FieldGaloisConsequences.lean`。
- 新 Entry：`abstract-algebra.field.galois-consequences`。
- 固定域载体：`fixedFieldIntermediateField`。
- 两项核心公式：`finiteGalois_fixedField_relativeDegree_eq_card` 与
  `finiteGalois_fixedField_degree_eq_index`。

## 证明结构

相对次数公式复用 A3.9b 的 fixing 群阶公式和子群恢复。指数公式使用总扩张
有限基推出固定域对基域有限，再组装扩张塔次数乘法、总自同构群阶—
次数、
Lagrange 公式和正次数消去。没有复制 A3.9b 的 `GaloisExtension → IsGalois`
私有转换链。

## Main 集成事项

Main 需要处理顶层导入、Registry、ROADMAP、RADAR 与派生索引。下一批
“正规中间扩张—正规子群”仍应独立审核；本提交不自动打开子群载体
迁移 Stage B。

## 验证

- `lake env lean SandronesLibrary/AbstractAlgebra/FieldGaloisConsequences.lean`：通过。
- `lake build SandronesLibrary.AbstractAlgebra.FieldGaloisConsequences`：通过，完成
  8720 个依赖任务。
- `/tmp/sandrones-library/GaloisConsequencesDegreeIndexAudit.lean`：四个公开接口
  `#check` 通过；三项关键定理只依赖 `propext`、`Classical.choice`、`Quot.sound`。
- 旧 Entry `abstract-algebra.field.galois-correspondence` 的 `check_axioms.py` 与
  `audit.py` 通过。
- 新 Entry 尚未由 Main 登记，故学科分支运行相同脚本预期报告
  “registry 中无此条目”；
  Main 完成 Registry 映射后必须复验。
- 源码与文档占位扫描及 `git diff --check` 通过。
