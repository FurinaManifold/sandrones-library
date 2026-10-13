# Main review: complex-analysis C2-C3 next window

- branch: `codex/complex-analysis`
- baseline integrated in main: `c715c9b`
- verdict: `next_work_required`
- reviewed_at: 2026-08-25

## 已接收

C1 六条、C2 路径积分/Cauchy 公式与估计/Liouville、C3 Taylor，以及六个明确降级的
foundation/special-case 已进入 main。Main 全库构建、公理审计与 Registry 审计通过。

## 下一批优先级

1. 先补一般局部三角形 Goursat，不得用圆盘原函数版本冒充。
2. 再补单连通开集上的原函数存在与一般同伦不变。
3. 在上述依赖门完成后，推进一般 Laurent 存在唯一性与系数公式。
4. 随后依次处理奇点 Laurent 分类、有限多极点残数定理、绕数、一般辐角原理与 Rouché。

## 验收边界

- foundation id 不得改名占用 ROADMAP 的完整课程 id。
- `real_integral_inv_one_add_sq` 的 Mathlib 后端不能算作残数法的一般实积分路线完成。
- 新交付继续要求精确八段文档、Entry/文件一一对应、聚合导入和关键 API `#check`。

## 学科负责人处理记录

- 优先级 1：`resolved`。新增 `Goursat.lean`，证明任意开集内闭三角形的
  `complex-analysis.cauchy.triangle`；公开假设是三点实凸包包含于该开集，不再要求圆盘。
- foundation 边界：`resolved`。原 `complex-analysis.cauchy.triangle-ball` 的源码、文档和 id
  原样保留；完整课程 id 只用于新的局部三角形定理。
- 文档与组装门：`resolved`。新文档具有 front matter 和精确八段；模块单独构建及临时聚合
  `#check` 结果记录在 `docs/handoffs/complex-analysis-c2-goursat.md`。
- 后续边界：单连通开集原函数、一般同伦不变及 Laurent 主线仍未在本提交中宣称完成。

## Round 3: 原函数构造与 admissible 可达性

- reviewed_commits: `770b7a8`, `1b9a009`
- reviewer: `main`
- verdict: `needs_changes`
- reviewed_at: 2026-08-25

### 已通过的提交内容

- `770b7a8` 将“同端点 admissible 道路积分无关”明确作为输入，并由基点路径积分构造原函数；
  没有把积分无关性藏成原函数存在。
- `1b9a009` 用开闭可达集论证消除基点到各点的 admissible 可达假设，并诚实保留
  `PathIntegralIndependentOn` 这一最终缺口。
- 两个目标模块构建、公开 API `#check`、公理审计、八段文档、Entry 对应、禁用占位扫描及
  `git diff --check a94884d..1b9a009` 均通过。

### 必须返工

- R1: 审核期间 worktree 出现未提交的公开接口修订：`AdmissiblePath` 新增正则性条件，并同步修改
  线段、常值路径和拼接证明。这是实质定义变更，必须完成证明、文档与 handoff 并独立提交。
- R2: 对 R1 最终状态重跑目标模块构建、核心 API `#check`、公理审计、占位扫描、Entry/八段检查、
  `git diff --check`，并恢复 clean worktree。

### 边界

在 R1 提交前，Main 不集成上述两个提交。一般单连通域上的积分无关性依旧未完成，不得因路径
正则性收紧而转正完整 C2 Entry。

### 学科负责人处理记录

- R1: `resolved` in `c1df76f`。`AdmissiblePath` 已改成有限拼接的归纳证书；每个叶节点同时携带
  域内值域、`PathIntegrable` 与 `ContDiffOn ℝ 1`。线段、常值路径、拼接、原函数构造和可达性证明
  已全部迁移，条目文档与两个 handoff 已同步。
- R1 语义验收：新增 `pathIntegral_eq_sub_of_primitive_of_admissiblePath`，对证书逐段应用微积分
  基本定理；并新增 `pathIntegralIndependentOn_of_primitive`。正则性条件由端点公式实际验收。
- R2: `resolved`。两个目标模块联合构建通过（2883 jobs）；全部复分析模块联合构建通过
  （2942 jobs）；八个关键公开 API 的临时聚合 `#check` 通过；两个核心定理的 `#print axioms` 均为
  `propext`、`Classical.choice`、`Quot.sound`；两篇 Entry 均为精确八段；禁用占位扫描与
  `git diff --check` 通过。
- 边界保持：一般单连通域上的 `PathIntegralIndependentOn` 尚未证明，完整 C2 Entry 未转正。

## 优先级 2 阶段性处理

- `resolved foundation`：新增 `HomotopyInvariance.lean`，不假设原函数，直接证明全纯路径积分在
  `C²` 相对端点同伦下不变，并证明光滑零同伦闭路积分为零。
- `boundary retained`：该结果使用独立 id
  `complex-analysis.cauchy.smooth-homotopy-foundation`，没有占用一般
  `complex-analysis.cauchy.homotopy`。标准 `IsSimplyConnected` 只提供连续道路同伦，而当前
  Mathlib 没有保持开域与端点的同伦平滑化桥；一般同伦和单连通域原函数仍记为未完成。
- `external audit`：Mathlib 的 `HasPrimitives.lean` 仍明确把单连通域原函数列为 TODO；官方
  Riemann mapping PR `#33505` 截至 2026-08-25 仍为 open，包含 974 行新增和三文件变更，未作为
  本库依赖或复制来源。
- `resolved analytic construction`：新增 `PrimitiveFromPathIntegral.lean`，从“基点可由可积域内
  道路到达每点”与“同端点道路积分无关”构造全局原函数，并逐点证明导数等于原函数。该结果用
  `complex-analysis.cauchy.primitive-from-path-independence-foundation`，没有把尚待证明的积分无关性
  或标准单连通结论写成已完成。
- `resolved admissible reachability`：新增 `AdmissiblePathConnectivity.lean`，以可达集合的相对开闭
  论证证明任意开连通域内从基点到每点存在 admissible 道路；并把标准 `IsSimplyConnected` 原函数
  路线压缩为唯一剩余假设 `PathIntegralIndependentOn`。该推论仍保留此显式前提，不冒充最终定理。

## Round 5: Mathlib 复用口径更正与最终接收

- reviewed_commit: `3c6f82eece0db5da6885337a3bd2711e172361eb`
- reviewer: `main`
- verdict: `accepted_main_docs`
- reviewed_at: 2026-08-25

此前要求为“原函数”另造本库谓词的意见撤回：课程文档已经把原函数解释为 `g` 在 `U` 上逐点满足
`HasDerivAt g (f z) z`，该 Mathlib 接口与教材语义一致，可以作为正式公开承载。`inductive`
声明映射覆盖属于 Main-side 审计器问题，也不再退回负责人。

Main 定向构建四个新模块通过，并在集成工作树完成 406 条 Registry 审计、仓库 audit 与
8890-job 全库构建。一般连续同伦正则化、无条件单连通域积分无关和原函数存在仍未完成；三个相关
结果继续以 foundation 条目接收，不扩大完整 C2 的完成度。

## Round 6: Main-side 集成门 R3 关闭记录

- reviewer: `main`
- reviewed_at: 2026-10-13
- 关闭对象: Round 4 的 R3（`inductive` 声明无法进入 Entry 声明映射）

Round 4 曾把"`AdmissiblePath` 这一 `inductive` 定义没有进入 `map_entry_to_decl` 报告"记为
Main-side 集成门。Main 现已核查并关闭该门：

- `scripts/check_axioms.py` 的 `DECL_RE` 已包含 `inductive`；
- 实测 `map_entry_to_decl(read('SandronesLibrary/ComplexAnalysis/PrimitiveFromPathIntegral.lean'))`
  返回
  `complex-analysis.cauchy.primitive-from-path-independence-foundation ->`
  `[SandronesLibrary.ComplexAnalysis.AdmissiblePath,` `...AdmissiblePath.range_subset,`
  `...AdmissiblePath.pathIntegrable,` `...pathIntegral_eq_sub_of_primitive_of_admissiblePath,`
  `...PathIntegralIndependentOn,` `...pathIntegralIndependentOn_of_primitive,`
  `...exists_primitive_of_pathIntegralIndependentOn]`。

即核心 `inductive` 定义、它的性质、以及本条目全部上层使用者都在同一 Entry 下，没有被相邻条目
吸入，也没有因声明类型支持不足而漏审。**该门关闭不是数学验收结论**：本条目其它边界（一般连续
同伦正则化、无条件单连通域积分无关、原函数存在）仍然未完成。

该核查与 Wave D 的 D1（`complex-analysis.integral.finite-cycle-foundation`）直接相关：cycle
carrier 很可能是新 `inductive`／`structure` 类型，本门关闭意味着它不会被审计器盲区吞掉。
