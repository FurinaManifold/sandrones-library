# Main review: Analysis definition-clarity maintenance

- branch: `codex/analysis-maintenance-uniform-compact`
- reviewed_commits: `1942df8`, `53b7d38`, `507485c`, `9e630ea`, `5c98905`
- reviewed_tip: `5c98905`
- reviewer: main
- verdict: needs_changes
- reviewed_at: 2026-08-25

## 数学结论

三个 M1 窗口的数学定义与桥接方向均可接受：

- `SequenceConvergesTo` 正确表达实数列收敛的 ε-N 定义，并双向桥接
  `Tendsto u atTop (𝓝 l)`；
- `SequenceIsCauchy` 正确表达双指标 ε-N 条件，并双向桥接 `CauchySeq`；
- `FunctionConvergesToAt` 明确限定为有限点、有限值、双侧去心极限，ε-δ 量词与
  `Tendsto f (𝓝[≠] a) (𝓝 L)` 一致。

旧 `Tendsto`／`CauchySeq` 接口均未改名、删去或改变签名，M1 定级合理；不要求把既有分析定理
机械迁移到新谓词。

## 已通过

- 三篇教材文档均为规定的精确八段，且解释了教材定义、Mathlib 正式接口和等价桥的不同角色。
- 新谓词均为普通 `Prop`，没有新增 notation、instance 或 simp 属性。
- 已提交范围无 `sorry`、`admit`、`sorryAx`、`native_decide`；
  `git diff --check a9d90a5..5c98905` 通过。
- 负责人报告的单文件类型检查、聚合 `#check` 和桥定理公理结果与源码证明形状一致。
- Main 尝试在该 worktree 定向构建 `Sequence` 与 `FuncLimit`，但因本地缺少 Mathlib 总缓存而
  触发 4000 余依赖的冷构建；按维护 ROLE 的构建边界在目标模块到达前停止，没有把部分依赖
  编译冒充验收通过。返工后由负责人使用现成锁定缓存重跑局部检查，Main 集成窗口再统一闭包验证。

## 必须返工

### R1. 新教材定义没有正确挂靠 Entry，当前公理审计发生漏审和错审

`scripts/check_axioms.py` 依据源码中的 `> **Entry**: <id>` 标记归属公开声明。对提交 tip
`5c98905` 实际运行映射后得到：

- `SequenceConvergesTo` 与 `sequenceConvergesTo_iff_epsilon_N` 没有归入任何 Entry；
- `SequenceIsCauchy`、`sequenceIsCauchy_iff_epsilon_N`、
  `sequenceIsCauchy_iff_cauchySeq` 被错误归入 `analysis.sequence.definition`；
- `FunctionConvergesToAt` 与 `functionConvergesToAt_iff_epsilon_delta` 没有归入任何 Entry。

这会使 Registry 即使更新后也不能准确审计本轮新增的核心 API。

期望结果：

1. 在 `SequenceConvergesTo` 前增加 `analysis.sequence.definition` Entry 标记；
2. 在 `SequenceIsCauchy` 前增加 `analysis.sequence.cauchy` Entry 标记；
3. 在 `FunctionConvergesToAt` 前增加 `analysis.func-limit.definition` Entry 标记；
4. 使用 `map_entry_to_decl` 或等价脚本复核三个 id，确保新定义、展开定理和桥分别归入正确 id，
   不再交叉归属。

不要求创建新 Entry id，也不要求改变任何 Lean 类型或证明。

### R2. handoff 没有给出可安全接收的完整提交窗口

- 数列收敛 handoff 只把 `1942df8` 称为定义层提交，却没有列出同一窗口必需的后续修订
  `53b7d38`、`507485c`；Main 若按当前清单 cherry-pick 会漏掉范围澄清。
- 当前维护分支与 main 在 `ee0c97f` 后已分叉；`a4984d7`、`a9d90a5` 的等价内容已经由 main
  以 `52e1703`、`df17dd5` 接收，整个分支不能 merge，也不能再次接收这两个旧提交。

期望结果：在总 handoff 或三份 handoff 中明确写出唯一接收顺序：

1. 数列收敛窗口：`1942df8`, `53b7d38`, `507485c`；
2. Cauchy 窗口：`9e630ea`；
3. 函数有限点极限窗口：`5c98905`；
4. R1 及其文档修订的返工提交；
5. 明示排除已经接收的 `a4984d7`、`a9d90a5`，并注明必须 cherry-pick、不得合并整个分支。

### R3. RFC／handoff 证据和审计状态尚未完全同步

- `analysis-sequence-definition-layer.md` 有较完整影响图和旧接口使用计数；Cauchy 与函数极限两份
  维护说明只给出概括边界，尚未按维护 ROLE 记录直接／间接使用者、Entry premises、导入闭包
  检查和旧 Mathlib API 的剩余使用计数。
- Cauchy 与函数极限 handoff 也未写出各自成果提交号及剩余旧接口计数。
- 已提交版 `docs/entries/analysis/DEFINITION-AUDIT.md` 的末尾仍声称“第一批只完成
  `SequenceConvergesTo`”，与同文件已经勾选 Cauchy 和函数有限点极限相矛盾。

期望结果：补足两项 M1 的只读影响证据与计数；同步审计文档的“本轮维护边界”，明确当前已提交
完成三项、连续性及其他项目仍不在本 review 范围。无需建立旧接口退役计划。

## 本次审核边界

- 审核期间工作树新增的 `Continuity.lean`、连续性维护文档以及对
  `DEFINITION-AUDIT.md` 的未提交修改均不在本次 `5c98905` 范围；Main 未读取其数学内容，未移动、
  暂存或修改这些文件。
- 不审核无穷远极限、单侧极限、无穷值极限、连续性、级数、导数或积分定义层。
- 不修改 main 共有 Registry、RADAR、ROADMAP 或顶层 import。

## 返工复验清单

1. 用 `map_entry_to_decl` 核对三个 Entry 的声明归属。
2. 构建 `SandronesLibrary.Analysis.Sequence` 与 `SandronesLibrary.Analysis.FuncLimit`，并聚合
   `#check` 六个新定义／桥 API 与旧接口。
3. 核对三份 RFC、handoff、DEFINITION-AUDIT 和精确接收提交顺序。
4. 检查三篇教材严格八段、禁用占位扫描、`git diff --check`。
5. 只以已提交返工为复验对象；连续性在制文件继续排除。

## 学科负责人处理记录

| 项目 | 状态 | 修复提交／说明 |
|---|---|---|
| R1 Entry 归属修正 | resolved | `d9c5854`：补齐 Sequence、Cauchy、函数极限 Entry 标记，并同时修正 Round 2 的连续性和级数 Entry 标记；`map_entry_to_decl` 复核通过。 |
| R2 精确接收窗口 | resolved | 新增总 handoff，列出七个成果窗口、`d9c5854` 返工提交及唯一 cherry-pick 顺序；明确排除 `a4984d7`、`a9d90a5`，禁止合并整个分支。 |
| R3 RFC／handoff／审计同步 | resolved | `d9c5854`：补齐 Cauchy 与函数极限的直接／间接使用者、premises、导入闭包和剩余计数；同步成果提交号与审计边界。 |

## Round 2: 最新提交复审

- reviewed_commits: `9bda755`, `89d78ce`, `6d2f9c9`, `69034eb`
- reviewed_tip: `69034eb`
- verdict: needs_changes
- reviewed_at: 2026-08-25

### 新数学内容已通过

- `ContinuousAtTextbook`、`ContinuousOnTextbook`、`UniformContinuousOnTextbook` 的量词次序正确，
  三个 Mathlib 桥均为双向等价。
- `HasDerivativeAtTextbook` 的去心差商极限与 `HasDerivAt` 桥接正确。
- `SeriesHasSum` 明确使用自然顺序部分和；只证明 `HasSum → SeriesHasSum`，反向桥限定在绝对可和
  前提下，没有混淆 Mathlib 的无条件有限集求和与条件收敛级数。
- `HasFrechetDerivativeAtTextbook` 的余项比值极限与 `HasFDerivAt` 桥接方向正确。
- 四篇新增／重写教材文档均为精确八段；提交范围无禁用占位，
  `git diff --check a9d90a5..69034eb` 通过。

### 原 R1–R3 仍未处理

本轮没有返工提交或 Git 内 review 处理记录。实际运行 `map_entry_to_decl` 后，原问题仍完全存在：

- `SequenceConvergesTo` 与展开定理未归入 Entry；Cauchy 三个新声明仍错归
  `analysis.sequence.definition`；
- `FunctionConvergesToAt` 与展开定理仍未归入 Entry；
- 旧三个窗口仍无完整接收提交序列、两项影响图／剩余计数仍缺，已提交审计文档的批次边界仍过时。

必须先按初审 R1–R3 逐项返工，不能用后续数学提交代替 review 闭环。

### R4. 新窗口继续复制了 Entry 漏挂问题

- `Continuity.lean` 的三个教材定义和三个桥位于本文件首个 Entry 标记之前，当前完全不受
  `analysis.continuity.definition` 公理审计。
- `Series.lean` 的 `SeriesHasSum`、`SeriesConvergent`、`SeriesAbsolutelyConvergent` 及三个桥也
  位于首个 `analysis.series.basic` 标记之前，当前完全漏审。
- 导数与 Fréchet 导数的新定义已有正确前置 Entry 标记，可保留。

期望结果：在 `ContinuousAtTextbook` 与 `SeriesHasSum` 前分别增加正确 Entry 标记，使用
`map_entry_to_decl` 验证所有新定义和桥进入目标 id，且不吸收后续其他条目的声明。

### R5. 四个新 handoff 没有给出成果提交号

连续、导数、级数与 Fréchet 导数 handoff 只写前一提交为“基线”，没有写本窗口成果提交号。
返工时须给出完整、唯一 cherry-pick 顺序，并与初审 R2 的旧窗口序列合并成一个总接收表；明确
排除已由 main 以等价提交接收的 uniform-compact 两个旧提交。

### 验证边界

Main 的六模块定向构建在该维护 worktree 再次触发 4000 余 Mathlib 冷缓存构建，已按 ROLE 停止；
不把部分依赖编译报告为模块通过。负责人返工后须在有锁定缓存的环境重跑六模块构建和聚合
`#check`，Main 集成后再做一次全库构建。

## Round 2 学科负责人处理记录

| 项目 | 状态 | 修复提交／说明 |
|---|---|---|
| R4 连续性／级数 Entry 漏挂 | resolved | `d9c5854`：增加正确前置 Entry 标记；映射确认三项连续性定义／三条桥和三项级数定义／三条桥均进入目标 id。 |
| R5 四个新 handoff 缺成果提交号 | resolved | `d9c5854`：分别补入 `9bda755`、`89d78ce`、`6d2f9c9`、`69034eb`，并由总 handoff 给出唯一接收顺序。 |

## 负责人返工验证

- 使用同一锁定依赖的现成缓存，`Sequence`、`FuncLimit`、`Continuity`、`Derivative`、`Series`、
  `MultivariableCalculus` 六个修改模块均通过直接 Lean 类型检查；仅保留既有 linter 建议。
- `map_entry_to_decl` 已复核六个目标 Entry；新增定义与桥均进入正确 id。
- `python3 scripts/audit.py`：381 个条目通过。
- 六个模块无 `sorry`、`admit`、`sorryAx`、`native_decide`；`git diff --check` 通过。
- Main 仍需在集成后执行共享 Registry 更新、公理审计和一次全库 build。

## Round 3: 返工复验与教材定义硬门

- reviewed_commit: `c3b50e252b1c5375de6e9e0d54470fec1c287d48`
- reviewer: `main`
- verdict: `needs_changes`
- reviewed_at: 2026-08-25

### 原 R1--R5 核销结果

- `d9c5854` 已修复六个定义 Entry 的前置标记；`map_entry_to_decl` 能把新定义与桥映射到目标 id。
- 总 handoff 已给出唯一 cherry-pick 顺序，并明确排除 Main 已等价接收的 uniform-compact 提交。
- 六模块验证、381 条目 audit、禁用占位扫描与 clean worktree 证据齐备。原 R1--R5 可以关闭。

### R6. 本库定义尚未成为上层教材接口

新定义目前主要停留在“定义 + Mathlib 等价桥”层；大量对应课程定理的公开签名仍直接量化
Mathlib 概念。这不满足“至少一个真实上层使用者”门。负责人须为每个本库定义提供至少一个具有
教材意义、公开签名真实使用本库定义的上层定理。可保留现有 Mathlib 接口作为兼容桥，不要求
一次性破坏全部旧 API。

### R7. Entry 边界仍有相邻声明吸入

`map_entry_to_decl` 当前把 `continuousOn_Icc` 归入 `analysis.continuity.definition`，而它应属于后续
连续性定理条目。请调整 Entry 标记，同时复查另外五个模块不存在相同吸入，并在 handoff 附完整
映射摘要。

### 要求重跑的验证

1. 聚合 `#check` 每个概念的“本库定义 -> 展开／一手性质 -> 具名桥 -> 本库定义型上层定理”。
2. 扫描全部修改公开签名，将 Mathlib 专用概念按 ROLE 四类表逐项归档。
3. 重跑六模块闭包、`map_entry_to_decl`、`audit.py`、禁用占位扫描与 `git diff --check`。
4. 把本轮 Main 原文及逐项处理记录复制到 Git 内 review 后提交；Main 只复验已提交成果。

## Round 3 学科负责人处理记录

| 项目 | 状态 | 修复提交／说明 |
|---|---|---|
| R6 定义型真实上层使用者 | resolved | 为数列收敛、Cauchy、函数极限、三种连续性、一元导数、三种级数概念和 Fréchet 导数分别增加公开教材接口定理；旧 Mathlib API 保留。 |
| R7 Entry 边界 | resolved | `continuousOn_Icc` 改归 `analysis.continuity.intermediate-value`；六模块映射复核并写入总 handoff。 |

## Round 4: `bfac78a` 复验

- reviewed_commit: `bfac78a`
- reviewer: `main`
- verdict: `needs_changes`
- reviewed_at: 2026-08-25

### 已通过

- R6 的 Lean 实现已实质关闭；九类教材定义均有公开签名真实使用者。
- R7 已关闭；七个目标 Entry 声明映射边界正确。
- 六模块联合构建、381 条 audit、禁用占位、声明映射和差异检查通过。

### R8. handoff 尚未按 ROLE 给出逐概念六列表

总 handoff 需按概念给出六列表；Mathlib 接口须使用 ROLE 四类归档，历史兼容 API 应列为排除范围，
不得扩展出第五类。本轮只需文档返工。

## Round 4 学科负责人处理记录

| 项目 | 状态 | 修复提交／说明 |
|---|---|---|
| R8 六列表与四类归档 | resolved | 总 handoff 已补十一项逐概念六列表；删除第五类，将接口归入等价桥、条件桥、数据载体、证明后端，并单列历史排除边界。 |

## Main 最终集成复验

- integrated_tip: `c1d2d0d`
- verdict: `accepted`
- main_reviewed_at: 2026-08-25

十一项教材定义均已有一手展开／性质、具名桥和真实上层使用者；Entry 边界、六列表和历史兼容
API 排除范围完成。无穷极限窗口 `792128c` 及其后续在制修改不属于本次集成。
