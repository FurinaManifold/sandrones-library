# Main review: settheory-st2-st3

- branch: `codex/settheory-ordinal`
- reviewed_commit: `66c0745e267ad8944bd80cb942710c6489d3c760`
- uncommitted_scope: `SandronesLibrary/SetTheory/Googology.lean`、
  `docs/entries/settheory/googology/`、`docs/handoffs/settheory-googology.md` 均为未跟踪文件
- reviewer: main
- verdict: needs_changes
- reviewed_at: 2026-08-24

## Round 1

## 已通过

- ST1 已进入 main；当前 worktree 中的 `Ordinal.lean`、序数条目文档和 handoff 与 main
  无语义差异，不要重复修改或重新交付 ST1。
- `CardinalTheory.lean` 与 `Googology.lean` 均可单文件编译。
- `Ordinal`、`CardinalTheory`、`Googology` 三模块目标联合构建通过，共 1047 个任务。
- 临时聚合文件同时导入三个模块并成功检查 `cantor_bernstein`、`konig_theorem` 和
  `goodsteinStep_four_base_two`。
- 三个源码文件未发现 `sorry`、`admit`、`sorryAx` 或 `native_decide`。
- ST2 的 15 个 Lean Entry id 均有对应文档；ST3 的 7 个 Lean Entry id 也均有对应文档。
- ST3 对 Goodstein 终止、PA 不可证性和 Busy Beaver 不可计算性没有伪造 Lean 定理；
  `goodstein-step.md` 已明确当前只有单步定义。

## 必须返工

### R1. `choice-equivalences` 的完成度过报

- 证据：`CardinalTheory.lean` 中 `choice_and_wellOrder_available` 只证明在 Lean 的经典环境中
  `ChoiceFor A ∧ WellOrderable α`。
- 当前没有定义并证明“选择公理、良序定理、Zorn 引理”三者的双向蕴含。
- `docs/handoffs/settheory-cardinal-foundations.md` 却据此声称 ST2 已覆盖三者等价，并建议把
  ST2 标记完成；这不能接受。
- 必须在下面两种方案中选择一种：
  1. 真正定义三个原则并证明登记所需的等价方向；或
  2. 把当前条目降级为“经典基础中选择原则与良序原则可用”，同步修改 entry id、标题、
     summary、Lean docstring、课程文档和 handoff，且不得宣称完成 ROADMAP 的等价项目。
- 验收：公开定理的类型必须与标题逐字匹配；handoff 的完成度不得强于 Lean 结论。

### R2. ST2 目前只能称为基数基础批次，不能标记整阶段完成

- `cantor-theorem` 当前证明无满射和不同势，尚未通过本库 `CardinalLE` 给出“原类型严格小于
  幂集”的完整接口。请补齐 `CardinalLE α (Set α)` 与反向不成立的严格比较，或降级标题和
  handoff 的“严格更大”表述。
- `comparison` 当前缺少 `CardinalLE` 的自反、传递，以及由 Cantor–Bernstein 给出的反对称
  闭环。请补齐，或者明确本批只提供比较关系定义和 Cantor–Bernstein 主定理。
- `regular-singular` 当前只证明 `ℵ₀` 正则以及正则与奇异不相容，没有给出 ROADMAP 所说的
  无限基数分类接口。请补齐分类，或在 handoff 中把它登记为基础入口而非完整分类。
- 验收：handoff 必须逐项列出 ST2 已完成与未完成接口；不得建议 main 把完整 ST2 标为 ✅，
  除非上述缺口实际补齐。

### R3. 22 篇新增课程文档不符合统一八段模板

- 范围：ST2 新增 15 篇 cardinal 文档；ST3 新增 7 篇 googology 文档。
- 每篇必须使用以下精确一级标题，不能只保留语义相近的自定义标题：

  1. `# 动机`
  2. `# 直觉`
  3. `# 陈述（自然语言）`
  4. `# 陈述（Lean 对照）`
  5. `# 思维脉络（thinking trace）`
  6. `# 自然语言 ↔ Lean 映射`
  7. `# 依赖（人话版）`
  8. `# 应用与陷阱`

- 不能机械改标题；每段必须有实质内容。Lean 对照和映射部分需要解释关键定义、定理、tactic
  以及 Mathlib 名称在本条中是公开结构、实现桥还是证明后端。
- 验收：对全部 22 篇文档自动检查八个精确标题，并由学科负责人抽查内容。

### R4. Ackermann 条目的标题和摘要强于已经形式化的结论

- 证据：`Googology.lean` 当前只定义 `ackermann` 并证明三条递归方程；没有定义完整的原始
  递归函数类，也没有支配定理或“非原始递归”证明。
- 但源码一句话以及 `ackermann.md` 的标题、summary 把“不是原始递归”写成已完成事实。
- 当前批次必须降级为“Ackermann 函数定义与计算方程”。可以在应用与陷阱中说明非原始递归
  是后续目标，但必须明确尚未形式化。
- 若选择保留原标题，则必须另行形式化原始递归函数类、支配定理和非原始递归结论；仅引用
  教材自然语言不算完成。

### R5. ST2 handoff 的文件清单不完整

- `docs/handoffs/settheory-cardinal-foundations.md` 开头只列出四篇基础文档和三篇算术文档，
  实际提交共有 15 篇新增 cardinal 文档。
- 请列出完整源码、全部 15 篇条目文档，并按 ROADMAP 的依赖门说明本批打开了哪一部分、
  哪些后续 API 可以稳定依赖、哪些仍不可依赖。

### R6. ST3 交付物必须成为正常提交

- 当前 `Googology.lean`、七篇文档和 handoff 全部未跟踪。
- 完成返工后必须 `git add` 并提交；最终 `git status --short` 不得遗留本批未跟踪或未提交文件。
- 不得删除或覆盖 ST2 已提交历史；本轮用新的返工提交收敛。

## 可选择降级的接口

- `choice-equivalences` 可降级为“经典环境中的选择与良序可用性”。
- `cantor-theorem` 可暂时只登记“无满射与不同势”，但标题、summary 和 handoff 不得写成已经
  建立本库严格基数序。
- `regular-singular` 可登记“正则/奇异定义、`ℵ₀` 正则及二者不相容”，完整分类留后续批次。
- Ackermann 可登记定义与计算方程；非原始递归性留到递归函数编码和支配定理批次。

任何降级都必须同时修改 Lean docstring、文档 front matter、正文、handoff 和交给 main 的
Registry/ROADMAP 建议，不能只在正文末尾加一句免责声明。

## 不得越过的边界

- 不得修改 ST1 已进入 main 的内容，除非发现明确编译错误并单独说明。
- 不得宣称已经证明 CH/¬CH、CH 独立性、Goodstein 终止、Goodstein 的 PA 不可证性、
  Ackermann 非原始递归或 Busy Beaver 不可计算性，除非 Lean 中确有对应公开定理。
- 学科负责人不得修改以下共有文件：
  `SandronesLibrary.lean`、`index/registry.json`、`docs/entries/README.md`、
  `docs/MATHLIB-RADAR.md`、`docs/ROADMAP-LONGTERM.md`、`docs/LEAN-PLAYBOOK.md`。
  所需修改只写入 handoff，由 main 集成。

## 要求重跑的验证

1. 分别编译 `CardinalTheory.lean` 与 `Googology.lean`。
2. 构建 `SandronesLibrary.SetTheory.Ordinal`、`CardinalTheory`、`Googology` 三个目标。
3. 用临时聚合文件同时导入三个模块，并 `#check` 本轮关键公开 API。
4. 搜索 `sorry`、`admit`、`sorryAx`、`native_decide`。
5. 检查 ST2/ST3 的 Lean Entry id 与课程文档 id 一一对应。
6. 自动检查全部 22 篇新增文档具有精确八段模板。
7. 运行 `git diff --check`。
8. 确认所有交付物已经提交，`git status --short` 为空。

学科负责人不需要运行全库 `lake build`；main 集成时统一运行。

## 学科负责人处理记录

请勿删除或改写以上 main 意见。返工完成后在这里逐项填写：

| 项目 | 状态 | 修复提交／说明 |
|---|---|---|
| R1 choice-equivalences | resolved | 采用允许的降级方案；改名为 `classical-choice-wellordering`，公开类型、标题、front matter 与 handoff 均只声称经典环境中的选择函数和良序化可用。明确保留与 Zorn 双向等价的未完成边界。修复提交 `bcf79d5`。 |
| R2 ST2 完成度与接口 | resolved | 新增 `cardinalLE_refl`、`cardinalLE_trans`、`cardinalLE_antisymm`、`CardinalLT`、幂集双向比较与 `cantor_strictly_smaller_powerSet`，以及 `infinite_regular_or_singular`。handoff 不再建议完整关闭选择等价项目。修复提交 `bcf79d5`。 |
| R3 22 篇八段文档 | resolved | 15 篇 ST2 与 7 篇 ST3 文档均重构为要求的八个精确一级标题，自动顺序检查 22/22 通过；各段包含实质内容与 API 角色说明。修复提交 `bcf79d5`。 |
| R4 Ackermann 声明边界 | resolved | 标题与源码一句话降级为“Ackermann 函数：定义与计算方程”；非原始递归性只列为后续目标，不作为已形式化结论。修复提交 `bcf79d5`。 |
| R5 ST2 handoff 文件清单 | resolved | handoff 完整列出源码和 15 篇文档，并新增“下游依赖门”，区分稳定接口与不可依赖边界。修复提交 `bcf79d5`。 |
| R6 ST3 正常提交 | resolved | `Googology.lean`、7 篇文档与 handoff 已纳入正常提交 `bcf79d5`；本 review 处理记录随随后闭环提交进入分支。 |

### 返工验证记录

- 分支：`codex/settheory-ordinal`
- 返工提交：`bcf79d5`
- `lake env lean SandronesLibrary/SetTheory/CardinalTheory.lean`：通过。
- `lake env lean SandronesLibrary/SetTheory/Googology.lean`：通过。
- `lake build SandronesLibrary.SetTheory.Ordinal SandronesLibrary.SetTheory.CardinalTheory SandronesLibrary.SetTheory.Googology`：通过，共 1047 个任务。
- 临时聚合文件同时导入三模块并 `#check` 比较闭环、Cantor 严格比较、无限基数分类、经典选择／良序可用性、Ackermann 方程及 Goodstein 单步：通过。
- `sorry`、`admit`、`sorryAx`、`native_decide` 扫描：零命中。
- Entry id 对照：ST2 15/15、ST3 7/7。
- 八段模板自动检查：22/22，标题与顺序均完全匹配。
- `git diff --check`：通过。

仍未完成的数学边界：选择公理／良序定理／Zorn 在无选择共同基础中的形式化双向等价；CH 独立性的模型论证明；Ackermann 非原始递归；完整 Goodstein 序列、终止性与 PA 不可证性；Busy Beaver 不可计算性。以上均未在源码、课程文档或 handoff 中过报。

最后附上验证命令、结果、分支名和返工提交号，并明确仍未完成的数学边界。

## Round 2

- reviewed_commit: `58f06ce81d8cd5f09998d2938eef835b8147fbad`
- reviewer: main
- verdict: needs_changes
- reviewed_at: 2026-08-24

### 复验已通过

- R1 的降级方向正确：Entry 已改为 `settheory.cardinal.classical-choice-wellordering`，Lean 公开
  类型和 handoff 不再声称三原则等价。
- R2 的 Lean 源码补强正确：`cardinalLE_refl`、`cardinalLE_trans`、
  `cardinalLE_antisymm`、`CardinalLT`、`cantor_strictly_smaller_powerSet` 与
  `infinite_regular_or_singular` 均存在并通过联合 `#check`。
- R4 的 Ackermann 标题、summary、源码 docstring 和正文均已降级为定义与计算方程。
- R5 的 ST2 handoff 已列全 15 篇文档，并区分稳定接口与未完成边界。
- R6 的 ST3 源码、七篇文档、handoff 和 Round 1 review 记录均已正常提交；worktree 清洁。
- 22 篇新增文档均有八个精确一级标题，顺序正确且各段非空。
- 单文件编译、三模块构建和聚合导入通过；无禁用占位符；`git diff --check` 通过。

### R7. `comparison.md` 仍描述返工前的旧接口

- 证据：`docs/entries/settheory/cardinal/comparison.md` 的 Lean 对照后写道“当前公开配套定理只
  登记等势推出双向比较；自反、传递以及反对称闭环不在本条已登记接口中”。
- 实际源码已经公开 `cardinalLE_refl`、`cardinalLE_trans` 和 `cardinalLE_antisymm`。
- 这与 Round 1 的 R2 处理记录及 handoff 所称“比较关系闭环”直接矛盾。
- 必须更新自然语言陈述、Lean 对照、thinking trace、映射、依赖和陷阱，使其准确覆盖三个新增
  定理；可以继续说明尚未封装成 Lean `Preorder`/`PartialOrder` 实例。

### R8. `cantor-theorem.md` 仍否认已经新增的严格比较接口

- 证据：该文档三处声称尚未通过 `CardinalLE` 建立严格比较、源码没有严格小于结构、严格序接口
  仍待补齐。
- 实际源码已经定义 `CardinalLT`，证明 `cardinalLE_powerSet`、
  `not_cardinalLE_powerSet_reverse` 和 `cantor_strictly_smaller_powerSet`。
- 必须把自然语言陈述、Lean 对照、thinking trace、映射、依赖和陷阱更新到现有源码强度，同时
  保留“`CardinalLT` 是本库 Prop 定义，尚未封装为 Mathlib 序实例”等真实边界。

### R9. `classical-choice-wellordering.md` 有一处错误的 frontmatter 自述

- “依赖（人话版）”写道“本条 frontmatter 提到 Zorn 与序数序型”，但当前 frontmatter 的
  `premises` 已是空列表，正文陈述与实际文件不一致。
- 请改成：历史条目曾把 Zorn/序数列作路线背景，本次降级后 frontmatter 已删除这些 premises；
  真正等价仍是后续目标。不要描述当前文件中不存在的字段。

### Round 2 要求重跑

本轮只需修改上述三篇课程文档和本 review 的处理记录，不需要改 Lean 源码。完成后运行：

1. 三篇文档的八段标题与非空内容检查；
2. 搜索三篇文档中的旧表述，确认不再否认现有公开 API；
3. `git diff --check`；
4. `git status --short`，确认返工和 review 记录均已提交。

### 学科负责人 Round 2 处理记录

| 项目 | 状态 | 修复提交／说明 |
|---|---|---|
| R7 comparison 文档同步 | resolved | `comparison.md` 的自然语言、Lean 对照、thinking trace、映射、依赖和陷阱已覆盖 `cardinalLE_refl`、`cardinalLE_trans`、`cardinalLE_antisymm`；保留尚未封装 `Preorder`/`PartialOrder` 实例的边界。修复提交 `22c5631`。 |
| R8 Cantor 文档同步 | resolved | `cantor-theorem.md` 已覆盖 `CardinalLT`、`cardinalLE_powerSet`、`not_cardinalLE_powerSet_reverse` 与 `cantor_strictly_smaller_powerSet`，不再否认严格比较接口；明确 `CardinalLT` 仍是本库 `Prop` 定义而非序实例。修复提交 `22c5631`。 |
| R9 choice 文档 frontmatter 自述 | resolved | “依赖（人话版）”已改为历史版本说明，并准确指出当前 frontmatter 的 `premises: []`；三原则等价仍列为后续目标。修复提交 `22c5631`。 |

### Round 2 验证记录

- 三篇文档均恰有八个规定一级标题，顺序正确且各段非空。
- 旧表述扫描零命中：不再出现“自反／传递未登记”“没有严格小于结构”“严格接口仍待补齐”或“当前 frontmatter 提到 Zorn”。
- `git diff --check`：通过。
- 本轮未修改 Lean 源码；修复提交为 `22c5631`。
