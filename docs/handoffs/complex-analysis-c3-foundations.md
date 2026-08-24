# 复分析 C3 Taylor 与 Laurent/残数 foundations handoff

## 分支与文件

- 分支：`codex/complex-analysis`
- 新源码：`Taylor.lean`、`Laurent.lean`、`Singularity.lean`、`Residue.lean`、
  `ArgumentPrinciple.lean`，均位于 `SandronesLibrary/ComplexAnalysis/`。
- 新文档：`series/` 两篇、`singularity/classification.md`、`residue/` 三篇及
  `argument-principle.md`。

## 完成条目

- `complex-analysis.series.taylor`（完整课程条目）
- `complex-analysis.series.laurent-foundation`
- `complex-analysis.singularity.classification-foundation`
- `complex-analysis.residue.circle-foundation`
- `complex-analysis.residue.simple-pole`
- `complex-analysis.residue.real-integral-example`
- `complex-analysis.argument-principle.linear-special-case`

后六项均是 foundation/special-case，不占用 ROADMAP 中完整 Laurent、奇点 Laurent 分类、一般残数
定理、辐角原理或 Rouché 的 id。

## 定义层与后端边界

- Taylor 系数定义为 `iteratedDeriv n f c / n!`，Taylor 展开复用本库 `complexPowerSeries`；
  `AnalyticAt` 不是教材定义，Mathlib Taylor API 只在显式全纯桥之后使用。
- `ComplexAnnulus` 与 `HasLaurentExpansionOnAnnulus` 定义解析环域上的双向整数指标 `HasSum`。
  Mathlib 的形式 `LaurentSeries = HahnSeries ℤ` 要求良序支撑，不能表示本性奇点的无限负次主部，
  因此未作为解析 Laurent 展开的定义或一般存在性后端。
- 孤立、可去、极点、本性奇点均有本库教材谓词；`MeromorphicAt` 只桥接可去/有限极点，不能
  代表全部孤立奇点。
- `circleResidue` 是指定圆周的正规化积分，不是一般 Laurent `-1` 次系数定义；残数和辐角/Rouché
  只证明简单极点与线性特例。

## 子 Agent 与负责人审核

- C3-T：Taylor 展开、导数/阶乘系数、Cauchy 圆周系数和局部系数唯一性；负责人确认其覆盖
  ROADMAP Taylor 展开与唯一性，可使用完整 id。
- C3-L/S：解析 Laurent foundation 与奇点 foundation；负责人退回缺许可证头和非标准 Entry
  标记，修复后所有公开声明均被正确关联。
- C3-R/A：圆周 residue、简单极点、实积分和线性 argument/Rouché 特例；负责人退回四篇九段
  文档及遗漏 helper/definition Entry 标记，修复后复验通过。

## 验证

- 五个新模块分别 targeted build 通过。
- 五模块联合构建通过（2779 jobs）。
- 临时聚合导入五模块并 `#check` 十个关键 API，通过。
- 正式源码无 `sorry`、`admit`、`sorryAx`、`native_decide`；`git diff --check` 通过。
- 七篇文档均有完整 front matter，严格且仅含精确八段，各段非空。
- 七个唯一 Source Entry id 与七篇文档 id 完全一一对应。
- 学科负责人未运行全库 `lake build`。

## Main 更新建议

- 顶层 import 五个新模块；Registry 接收上述七个实际 id；RADAR 登记 Taylor/analytic uniqueness、
  meromorphic order、circle integral、log derivative 和 improper integral 后端。
- ROADMAP 只把 `complex-analysis.series.taylor` 标为完成。Laurent、奇点完整分类、一般残数定理、
  辐角原理、Rouché 与通用实积分计算继续保持未完成；可在其下登记六个 foundation 进度项。
- 不应因 `real_integral_inv_one_add_sq` 已存在而把“残数法实积分”标为完成：该证明当前直接复用
  Mathlib 广义积分定理，只是准确的课程例题接口。

## 下一步与诚实边界

稳定 API 包括圆盘 Taylor 展开/系数唯一性、Laurent 解析定义与两个单项例子、孤立奇点教材分类
谓词及 meromorphic order 桥、简单极点圆周公式和线性辐角/Rouché 特例。尚缺一般环域全纯函数的
Laurent 存在唯一性、Laurent 系数公式、用主部证明奇点三分类、有限多极点残数定理、绕数、一般
辐角原理与 Rouché。Mathlib 当前没有可直接闭合这些路线的完整 API。
