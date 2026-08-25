# 抽象代数 A3.8 可分与正规扩张交接

## 接收窗口

- Main 已集成 A3.7：`2377baa`。
- A3.8 状态：`integration_open`。
- 新源码：`SandronesLibrary/AbstractAlgebra/FieldSeparableNormal.lean`。
- Entry：`abstract-algebra.field.separable-normal`。
- 证明来源：已独立通过的 A3.8 临时零占位源码。

## 数学成果

- 用多项式与导数的 Bézout 恒等式定义可分多项式。
- 用 A3.5 `MinimalPolynomialOf` 定义可分元，并逐元素定义可分扩张。
- 用代数性和最小多项式分裂定义正规扩张。
- 证明系数映射保持可分性、不可约导数判据及根处导数非零。
- 证明可分元与可分扩张的代数性，并给出具体最小多项式的可分性判据。
- 证明分裂域正规，以及有限正规扩张恰为某个非零多项式的分裂域。
- 证明有限基域上的显式有限扩张可分。

## 公开签名审计

- 公开 API 继续显式接受 `FieldEmbedding`，并使用 A3.5--A3.7 教材谓词。
- 公开声明不出现 `Algebra`、`Module`、`IntermediateField`、`Submodule`、`AlgEquiv`、
  Mathlib `Normal`、`IsSeparable` 或 `PerfectField`。
- Mathlib 高级结构只存在于私有桥和证明体。
- 有限正规存在性显式处理 Mathlib 可能给出的零多项式见证，保持 A3.7 非零边界。

## 核心概念与定义所有权

| 概念 | 教材语义 | 正式承载与展开 | Mathlib 角色 | 首个上层使用者 |
|---|---|---|---|---|
| 可分多项式 | 与形式导数满足 Bézout 恒等式 | `SeparablePolynomial`；`separablePolynomial_iff_bezout_derivative` | `Polynomial.Separable` 是私有对齐后端 | `separablePolynomial_ne_zero` |
| 可分元 | 教材最小多项式可分 | `SeparableElement`；`separableElement_iff_minimalPolynomial` | `IsSeparable` 与 `minpoly` 是私有后端 | `separableElement_isAlgebraic` |
| 可分扩张 | 每个目标域元素可分 | `SeparableExtension`；逐元素定义 | `Algebra.IsSeparable` 是私有后端 | `separableExtension_isAlgebraic` |
| 正规扩张 | 代数且每个元素的最小多项式分裂 | `NormalExtension`；两个公开投影定理 | Mathlib `Normal` 是私有后端 | `splittingFieldFor_normalExtension` |

四个新概念及其全部公开 API 由
`SandronesLibrary/AbstractAlgebra/FieldSeparableNormal.lean` 单独拥有；A3.5--A3.7 的
`FieldEmbedding`、`MinimalPolynomialOf`、`FiniteFieldExtension` 和 `SplittingFieldFor`
只作为稳定的既有公开前提。

## 子 Agent 所有权与负责人返工

- 子 Agent `Sagan` 只拥有临时框架以及上述四个学科文件，没有修改 Main 共享文件。
- 子 Agent 没有独立提交；最终提交由学科负责人完成并记录在本 handoff。
- 本批没有发生正式文件返工；负责人在临时框架阶段重点要求并复验两类风险：A3.8-04 必须先
  以泛性质证明教材最小多项式等于 `minpoly`；A3.8-11 必须处理成熟接口可能返回零多项式的
  边界，不能直接桥接。
- 正式迁移后，负责人另行补做定义链联合导入、声明映射和公理检查。

## 出版来源

Entry 复用已有 citation key `dummit-foote-abstract-algebra-2004`。正文注明第三版第 13 章
Section 4 “Splitting Fields and Algebraic Closures”与 Section 5
“Separable and Inseparable Extensions”的相关内容。

## 第二批边界

本批没有加入根重数版可分刻画，也没有加入“正规扩张当且仅当每个在扩域中有根的不可约
多项式均分裂”的公开等价定理。这两项会扩大对 A3.4 根重数和不可约因子论的依赖，留作
A3.8 第二批；四个核心定义及本批定理不依赖它们。

## Main 集成事项

- 顶层 import 加入 `SandronesLibrary.AbstractAlgebra.FieldSeparableNormal`。
- Registry 将 `abstract-algebra.field.separable-normal` 映射到新源码和 Entry 文档。
- ROADMAP 将 A3.8 第一批标记完成，并保留第二批与 Galois 后续边界。
- RADAR 登记 Bézout 可分定义、最小多项式桥、正规性、有限正规刻画和有限域完美性依赖。
- 运行生成索引、公理修复、Entry audit、依赖闭包和 Main 全库 build。

## 已运行验证

- 正式单文件 `lake env lean SandronesLibrary/AbstractAlgebra/FieldSeparableNormal.lean`。
- 学科依赖闭包 `lake build SandronesLibrary.AbstractAlgebra.FieldSeparableNormal`，8715 jobs 通过。
- 联合导入 `/tmp/sandrones-library/FieldSeparableNormalAudit.lean` 同时检查四个正式承载、
  展开／刻画和上层使用者；核心定理公理仅为 `propext`、`Classical.choice`、`Quot.sound`。
- `map_entry_to_decl` 将唯一 Entry 映射到四个核心定义及十三个公开定理；未发生跨 Entry 吸入。
- 禁用占位符与未完成证明标记扫描。
- 公开声明头高级类型泄漏扫描。
- `git diff --check`。

## 下一批稳定接口与禁止依赖

A3.8 第二批及 A3.9 研究框架可以稳定依赖四个核心定义、
`separableElement_iff_minimalPolynomial`、`separableExtension_isAlgebraic`、
`splittingFieldFor_normalExtension` 和 `finite_normalExtension_iff_exists_splittingFieldFor`。
在第二批正式完成前，不得依赖尚不存在的根重数可分刻画或“不可约多项式有根则分裂”等价；
A3.9 仍为 `research_open`，不得把 Galois 群或基本定理写入正式源码。

学科提交不修改顶层 import、Registry、ROADMAP、RADAR、Playbook、`reference.bib` 或派生文件；
共享集成事项由 Main 完成。正式成果提交为 `56429d7`。
