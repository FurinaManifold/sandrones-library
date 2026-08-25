# 复分析 C1 学科 handoff

## 分支与范围

- 分支：`codex/complex-analysis`
- 批次：C1 复微分与全纯函数
- 源码：
  - `SandronesLibrary/ComplexAnalysis/Holomorphic.lean`
  - `SandronesLibrary/ComplexAnalysis/CauchyRiemann.lean`
  - `SandronesLibrary/ComplexAnalysis/PowerSeries.lean`
  - `SandronesLibrary/ComplexAnalysis/Elementary.lean`
- 文档：`docs/entries/complex-analysis/holomorphic/` 下六篇条目文档。

## 条目与依赖门

本批完成 ROADMAP C1 六条：

1. `complex-analysis.holomorphic.definition`
2. `complex-analysis.holomorphic.algebra`
3. `complex-analysis.holomorphic.cauchy-riemann`
4. `complex-analysis.holomorphic.cr-sufficient`
5. `complex-analysis.holomorphic.power-series`
6. `complex-analysis.holomorphic.elementary`

本批依赖 C0/AN-MV 的复数与实 Fréchet 微分基础；接收后为 C2 路径积分与 Cauchy 理论提供稳定的
全纯接口，但不表示 C2 已解锁完成。

## 本库定义与 Mathlib 后端

- 公开定义：`ComplexDifferentiableAtTextbook` 是去心邻域差商极限；
  `HolomorphicOnTextbook` 是集合内每点的全邻域复可微；`SatisfiesCauchyRiemannAt` 是四个实偏导
  分量满足 `uₓ=vᵧ`、`uᵧ=-vₓ`。
- 显式桥：点态差商定义与 `DifferentiableAt ℂ` 双向等价；只有集合开时才与相对谓词
  `DifferentiableOn ℂ` 等价。
- 证明后端：Mathlib 的 Fréchet derivative、`FormalMultilinearSeries`、复指数/三角函数/标准
  slit-plane 对数分支。它们不充当本库对复可微、全纯或 CR 方程的定义。

## 子 Agent 所有权与负责人审核

- C1-D：`Holomorphic.lean` 与 definition/algebra 文档；负责人要求把别名方案改为真实差商定义，
  并补上非开集不能与相对可微无条件等价的边界。
- C1-CR：`CauchyRiemann.lean` 与两篇 CR 文档；负责人确认充分性必须显式保留
  `DifferentiableAt ℝ`，避免不可微处 `fderiv` 默认值造成伪判定。
- C1-P/E：`PowerSeries.lean`、`Elementary.lean` 与两篇文档；负责人分批验收，确认逐项求导
  给出显式级数公式，局部 log 给出开域、中心成员、全纯和指数右逆。

## 验证

- 四个修改模块分别 targeted build 通过。
- 联合构建：
  `lake build SandronesLibrary.ComplexAnalysis.Holomorphic SandronesLibrary.ComplexAnalysis.CauchyRiemann SandronesLibrary.ComplexAnalysis.PowerSeries SandronesLibrary.ComplexAnalysis.Elementary`
- 临时聚合文件同时导入四模块，并 `#check` 八个关键公开 API，通过。
- 正式源码无 `sorry`、`admit`、`sorryAx`、`native_decide`。
- Main review 指出 `elementary.md` 与 `power-series.md` 曾各多出一个 `# 定义`。本次返工已把
  定义解释完整并入“陈述（自然语言）”和“陈述（Lean 对照）”；自动检查确认六篇文档现在均且
  仅按顺序包含精确八段模板，段落非空。`git diff --check` 通过。
- 学科负责人未运行全库 `lake build`。

## Main review 处理状态

- R1 `resolved`：两篇九段文档已改成精确八段，定义语义未丢失。
- R2 `resolved`：handoff 的验证记录已改为真实的返工后检查结果。
- R3 `resolved`：保留 Main review 原文，并在其处理记录中填写状态；修复提交为包含本记录的
  当前提交（见本分支 `git log`）。

## Main 共有文件更新建议

- `SandronesLibrary.lean`：新增上述四个模块 import。
- Registry：新增上述六个 Entry id，并由 main 运行公理字段生成器。
- ROADMAP：C1 六条在 main 集成和全库验收后改为 ✅；C2 从依赖 C1 的锁定状态转为可开工状态。
- RADAR：登记本批实际使用的 slope/Fréchet、CR、formal power series、exp/sin/cos/log 接口。
- Playbook：可记录“集合内逐点全邻域全纯仅在开集上等价于 `DifferentiableOn`”这一边界。

## 下一批稳定 API 与诚实边界

C2 可稳定依赖 `HolomorphicOnTextbook`、点态桥、全纯代数/复合、CR 双向判据、幂级数圆内全纯、
初等整函数和局部 log 分支。当前未定义路径、分段光滑路径、路径积分、绕数或同伦积分；没有证明
Cauchy 定理、Cauchy 公式、解析性、Liouville 或残数定理。旧 C0/C0.5 文档仍是历史 partial 格式，
不属于本批源码改动。
