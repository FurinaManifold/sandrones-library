# 抽象代数 A3.9a Galois 定义层交接

## 权限与依赖门

- A3.9a 当前为 `development_open`。
- `integration_waits_for`: A3.8 第二批
  `abstract-algebra.field.separable-normal-characterizations`。
- A3.9b 为 `research_open`，本交付不包含基本定理。
- 证明来源是已独立零占位编译的 `FieldGaloisDefinitionsFramework.lean`。

## 交付与稳定 API

- 源码：`SandronesLibrary/AbstractAlgebra/FieldGaloisDefinitions.lean`
- Entry：`abstract-algebra.field.galois-definitions`
- 稳定概念：`FieldAutomorphismOver`、`FixedFieldSet`、`GaloisExtension`
- 稳定操作：identity、comp、inverse、三项 apply、五群律与 `GroupAxioms`
- 固定域：成员展开、empty/univ、子域、中间域、基域像包含与反变性
- Galois：定义展开、可分／正规／代数投影及不可约有根分裂刻画

## 六项路线问题

1. **是否重造自同构结构？** 否。缩写复用 `FieldIsomorphismOver e e`。
2. **如何表达群？** 显式安装单位、复合和逆，并以本库 `GroupAxioms` 逐条验证。
3. **固定域是否要求子群？** 定义接受任意自同构集合；共同固定点的域封闭性
   不需要子群假设，A3.9b 可另加本库 `SubgroupSet` 条件。
4. **如何保证包含基域？** 每个 `FieldIsomorphismOver e e` 保存 `fixes_base`，
   因此 `Set.range e.toFun` 包含于任意固定域。
5. **Galois 如何定义？** 严格采用 `SeparableExtension e ∧ NormalExtension e`，
   再消费 A3.8 第二批正规性刻画。
6. **Mathlib 如何使用？** `AlgEquiv`、打包固定域和 `IsGalois` 仅列为未来
   私有后端；本批没有真实公开使用者，因此不建立装饰性桥。

## 子 Agent 与人工审计

子 Agent `Sagan` 只拥有 A3.9a 临时框架和本批四个学科文件，不修改 Main 共享文件，
也不进入 A3.9b。负责人运行 `map_entry_to_decl` 后确认工具已自动登记
`FieldAutomorphismOver` 缩写；唯一 Entry 精确映射到该缩写、三个运算、群公理、固定域
和 Galois 定义链共 28 个公开声明，人工核对也确认没有跨 Entry 吸入。

## A3.9b 禁止边界

本批不含固定域—固定子群互逆、自同构群阶与扩张次数、中间域—子群反序
同构、正规子群刻画、商群／限制同态或有限 Galois 基本定理。这些内容即使
Mathlib 已有成熟接口，也仍受 A3.9b `research_open` 限制。

## 验证与 Main 集成事项

- 单文件 `lake env lean SandronesLibrary/AbstractAlgebra/FieldGaloisDefinitions.lean` 零输出通过。
- 依赖闭包 `lake build SandronesLibrary.AbstractAlgebra.FieldGaloisDefinitions` 通过，8718 jobs。
- 联合导入 `/tmp/sandrones-library/FieldGaloisDefinitionsAudit.lean` 同时 `#check` 三个正式
  承载、展开／群公理和上层使用者；核心公理不超出 `propext`、`Classical.choice`、`Quot.sound`。
- 禁用占位、公开高级类型泄漏、长行及 `git diff --check` 扫描均通过。
- Main 待依赖进入后处理顶层 import、Registry、ROADMAP、RADAR、生成索引和
  全库 build；本交付不修改这些共享或派生文件。
