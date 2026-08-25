# 抽象代数 A3.9b 有限 Galois 基本对应交接

## 权限与依赖门

- A3.9b 当前为 `development_open`。
- 开工基线已按 Main 通知同步至 `main@96ff8ee`，学科分支以 merge commit
  `a8bd909` 合入该基线，没有覆盖 Main 共享文件。
- 本交付依赖 A3.9a `abstract-algebra.field.galois-definitions`、A3.6
  `abstract-algebra.field.degree` 与 `abstract-algebra.group.def`。
- 证明唯一来源为零占位的
  `/tmp/sandrones-library/FieldGaloisCorrespondenceFramework.lean`。
- 本次只新增学科源码、Entry 与 handoff；顶层导入、Registry、路线图、
  RADAR、rankings、参考文献键和派生文件均留给 Main。

## 交付与稳定 API

- 源码：`SandronesLibrary/AbstractAlgebra/FieldGaloisCorrespondence.lean`
- Entry：`abstract-algebra.field.galois-correspondence`
- fixing 层：`FixingAutomorphismSet`、成员展开、子群封闭、反变性和集合级
  Galois connection。
- restriction 层：`ExplicitIntermediateField`、`IntermediateFieldCarrier`、
  两个自然嵌入、`PreservesIntermediateField`、`restrictEmbedding`、
  `restrictAutomorphism` 及恒等／复合／逆相容。
- 数值层：fixing 闭包、fixing 群阶等于相对次数、闭包同次数、同维包含
  消去、子群与 fixing-fixed 闭包同基数。
- 恢复层：中间域恢复、子群恢复和合取形式的有限 Galois 基本对应。

## 六项路线问题

1. **公开承载如何选择？** 中间域与子群分别保持为
   `IntermediateFieldSet` 和 `SubgroupSet`；不把 Mathlib 打包对象放入公开头。
2. **restriction 是否真实存在？** 是。显式中间域子类型安装域结构，并构造
   基域嵌入、包含嵌入和限制自同构，逐点验证恒等、复合与逆。
3. **固定与限制如何连接？** fixing 推出正逆保持；在任意保持性证明下，
   逐点固定恰好等价于限制自同构为恒等。
4. **中间域恢复为何需要 Galois？** 换基后的 fixing 群阶等于 `L/F` 次数依赖
   有限 Galois；闭包共享 fixing 群阶，故共享次数，再由包含和同维数消去。
5. **子群恢复为何只需有限？** 自然包含始终成立；固定点后端给出原
   子群与 fixing-fixed 闭包的相同有限基数，因此有限集合消去即可得到
   等式。
6. **Mathlib 的边界在哪里？** `Algebra`、打包中间域／子群、`AlgEquiv`、
   有限维、Galois 类型类和固定点工具只服务私有桥；公开 API 始终是本库
   显式嵌入、集合谓词、`FiniteFieldExtension` 与 `GaloisExtension`。

## 证明路线与禁用边界

有限恢复没有包装 Mathlib 中直接给出最终固定域—固定子群互逆、完整
中间域—子群等价或群阶—次数结论的四个便捷接口。源码复现了所需的
中间层：自同构换基、固定点映射等价、相对有限 Galois、次数对齐、
有限基数传递和维数消去。
Main 集成时应保留这一证明边界，并继续执行四接口禁用扫描。

## 声明与文档审计

- 每个公开声明均标记 Entry `abstract-algebra.field.galois-correspondence`。
- 公开头只出现本库教材承载；高级 Mathlib 名称限于 private 声明和证明体。
- `ExplicitIntermediateField` 是集合数据的显式载体，不是公开 Mathlib
  `IntermediateField` 的别名。
- 子群恢复的精确假设是 `FiniteFieldExtension e`；中间域恢复另外需要
  `GaloisExtension e`，合取总定理采用两者。

## 验证与 Main 集成事项

- 正式单文件编译零 warning、零 error；负责人复核 target build 共
  8719 jobs 通过。
- 临时聚合审计中的 `#check` 与四项 `#print axioms` 均通过；公理集合
  仅为 `propext`、`Classical.choice` 与 `Quot.sound`。
- `audit`／`check_axioms` 因 Main Registry 尚未登记本 Entry，当前预期
  返回“无条目”；须由 Main 完成共享集成后重新运行，不记作本分支
  已通过。
- 占位扫描覆盖证明占位符、未授权公理与任务标记；禁用接口扫描覆盖
  四个直接最终恢复 API；另执行公开高级类型泄漏、长行和
  `git diff --check`。
- 学科分支将独立提交这三个文件；Main 只处理顶层 import、Registry、
  ROADMAP、RADAR、rankings、引用索引及其他共享集成。
- 后续次数—指数、正规子群与商群结果应另开开发窗口，不应扩张本
  Entry。
