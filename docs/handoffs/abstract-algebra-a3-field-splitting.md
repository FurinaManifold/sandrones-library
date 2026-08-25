# 抽象代数 A3.7-S 分裂域交接

## 接收窗口

- Main 接收 A3.6 的提交：`837e93f`，A3.7 状态为 `integration_open`。
- 新源码：`SandronesLibrary/AbstractAlgebra/FieldSplitting.lean`。
- Entry：`abstract-algebra.field.splitting`。
- 证明来源：已独立通过的 A3.7-S 临时零占位源码。

## 数学成果

- 定义显式扩域中的多项式根集、分裂谓词和“分裂且由全部根生成”的分裂域谓词。
- 定义固定基域的嵌入与显式正逆域同构，并给出恒等、对称和传递复合。
- 给出零、常数、一次与非零乘积的分裂规则，以及线性因子多重集刻画。
- 证明分裂域有限且代数，并可嵌入任意使原多项式分裂的扩域。
- 构造每个非零多项式的分裂域见证，并证明任意两个分裂域在基域上同构。

## 公开签名审计

- 公开 API 继续显式接受 A3.5 的 `FieldEmbedding`，生成条件使用
  `generatedIntermediateFieldSet`。
- 公开声明不出现 `Algebra`、`IntermediateField`、`Module`、`AlgEquiv` 或
  `Polynomial.IsSplittingField`。
- Mathlib 根集、生成中间域、有限维、`lift`、标准分裂域和代数同构只作为私有证明后端。
- 零多项式边界已明确：它满足 `PolynomialSplitsIn`，但根集为空且不满足
  `SplittingFieldFor`。

## 出版来源建议

本 Entry 复用 Main 已登记的出版教材 key `dummit-foote-abstract-algebra-2004`，章节定位为
Dummit and Foote, *Abstract Algebra*, Third Edition, Chapter 13, Section 4,
“Splitting Fields and Algebraic Closures”。本次交接没有修改共享文献注册表。

## Main 集成事项

- 顶层 import 加入 `SandronesLibrary.AbstractAlgebra.FieldSplitting`。
- Registry 将 `abstract-algebra.field.splitting` 唯一映射到新源码和 Entry 文档。
- ROADMAP 将 A3.7-S 分裂域标记为完成；可分、正规与 Galois 后续窗口仍由 Main 决定。
- RADAR 登记零多项式边界、根生成条件、有限性、存在性和唯一到基域上同构。
- Main 运行生成索引、Entry audit、依赖闭包及全库 build。

## 验证边界

本次只验证独立正式模块，不修改 `SandronesLibrary.lean`、Registry、ROADMAP、RADAR、
Playbook 或 `reference.bib`，也不提交 git commit。最终集成和共享文件更新由 Main 完成。
