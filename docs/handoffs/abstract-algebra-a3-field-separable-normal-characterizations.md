# 抽象代数 A3.8 第二批独立交接

## 权限与交付范围

- Main review 将 A3.8 第二批设为 `development_open`，要求独立模块交付。
- A3.9a 为 `development_open`，但正式集成等待本批完成。
- A3.9b 为 `research_open`，不得进入正式库集成。
- 源码模块：`FieldSeparableNormalCharacterizations.lean`。
- Entry：`abstract-algebra.field.separable-normal-characterizations`。
- 冻结的第一批源码、Entry、handoff 以及 Main 共享文件均未修改。

## 稳定公开 API

- `separablePolynomial_rootMultiplicity_le_one`
- `separablePolynomial_iff_rootMultiplicity_le_one_of_splits`
- `normalExtension_iff_irreducible_with_root_splits`

三个声明保留已验证临时框架的原始名称、参数顺序和数学签名。公开头只依赖
显式 `FieldEmbedding`、正式 `Polynomial`、第一批教材谓词以及 A3.4 根重数。

## 六项路线问题

1. **定义是否重开？** 不重开。第二批仅刻画冻结的 `SeparablePolynomial`
   与 `NormalExtension`。
2. **根重数在哪里计算？** 在 `p.map e.toRingHom : Polynomial L` 上计算，
   从而明确扩域和系数映射。
3. **逆向为何需要分裂与非零？** 分裂保证根多重集覆盖全部因子；非零排除
   `roots` 与根重数接口的零多项式边界。
4. **正规性如何从一个根推广到完全分裂？** 通过教材最小多项式的整除
   泛性质、不可约性给出的相伴关系，以及分裂性对因子的封闭性。
5. **Mathlib 高级结构是否泄漏？** 不泄漏。根多重集与成熟可分性接口只在
   私有桥和证明体中使用，公开签名不出现高级域论结构。
6. **后续窗口如何衔接？** A3.9a 可独立开发但集成等待本批；A3.9b 保持
   `research_open`，本交付不授权其正式集成。

## 验证边界

- 正式文件已由 `lake env lean` 单独编译，零 warning、零 error。
- 依赖闭包 `lake build SandronesLibrary.AbstractAlgebra.FieldSeparableNormalCharacterizations`
  通过，共 8716 jobs。
- 联合导入 `/tmp/sandrones-library/FieldSeparableNormalAudit.lean` 同时 `#check`
  第一批定义链与第二批三个使用者；核心公理仅为 `propext`、`Classical.choice`、`Quot.sound`。
- `map_entry_to_decl` 把第一批 Entry 映射到原 17 个声明，把本 Entry 精确映射到三个新定理，
  没有跨文件吸入。
- 已扫描源码中的未完成证明和占位标记，零命中；公开声明头没有 `Algebra`、`Module`、
  `IntermediateField`、`Submodule`、`AlgEquiv`、Mathlib `Normal` 或 `IsSeparable`。
- `git diff --check` 通过，工作树变更限于四个授权文件。
- 本次不修改顶层 import、Registry、ROADMAP、RADAR、Playbook、
  `reference.bib` 或派生文件。

## 子 Agent 边界

子 Agent `Sagan` 只写第二批临时框架和本独立交付的四个文件。负责人发现最初提交
`120cf97` 把第二批追加到冻结的第一批文件，不符合 Main 新发布的“独立文件／提交”要求；
同步合并 `fa34d9a` 恢复第一批 Main 版本，本交付改由当前独立模块承载。后续子 Agent
可以把这三个定理作为 A3.9a 临时框架的稳定前提，但在 Main
完成本批集成前不得假定顶层 import 已经暴露新模块。A3.9b 只能进行
`research_open` 范围内的只读审计或临时研究，不得写入正式学科源码。

## Main 共享更新建议

- 顶层 import 增加 `SandronesLibrary.AbstractAlgebra.FieldSeparableNormalCharacterizations`。
- Registry 新增 `abstract-algebra.field.separable-normal-characterizations`，前提为第一批 Entry
  与 `abstract-algebra.poly.factorization`，复用 Dummit--Foote citation key。
- ROADMAP 将 A3.8 第二批转为已集成后，才解除 A3.9a 的集成等待；A3.9b 继续保持
  `research_open`。
- RADAR 登记根重数充要判据、`nodup_roots_iff_of_splits` 私有后端与正规扩张不可约判据；
  Main 统一运行公理修复、Entry audit、派生索引和全库构建。
