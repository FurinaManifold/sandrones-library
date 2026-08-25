# F1 泛函分析基础 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`8d5d823`
- 设计 RFC：`docs/maintenance/functional-analysis-f1-design.md`
- 当前阶段：F1 六项学科开发与验证完成，等待 Main 审核集成

## 路线结论

- 赋范／Banach 空间复用已验收 Topology 条目。
- `ContinuousLinearMap` 是“线性且连续”的语义一致正式承载。
- 算子范数直接采用该承载上的 Mathlib 范数，以基本估计和最小界性质完成教材解释。
- 绝对可和直接写 `Summable (fun n ↦ ‖f n‖)`；闭子空间直接采用 `Submodule` 加 `IsClosed`。

## 重复造轮子修正

- 已删除 `IsBoundedLinearOperator` 及人工打包桥。
- 已撤回未提交的 `operatorBounds`、`operatorNorm := sInf ...`。
- `Operator.lean` 改为正式承载、全局界刻画与有界／连续等价；不创建平行接口。

## Main-side 建议

- ROADMAP F1 第 1 项标记为复用 `topology.normed-space.def`，不要创建重复 Entry。
- 后续集成新增 `SandronesLibrary.FunctionalAnalysis.*` imports、实际新 Entry 的 Registry 和 RADAR；
  共有文件不由本分支修改。

## 尚未完成

- 顶层 import、Registry、RADAR 和 ROADMAP 状态由 Main 集成。
- F2/F3/F4 保持锁定。

## 概念清单与公开签名分类

| 概念 | 教材语义 | Lean 正式承载 | 展开／性质 | 复用边界 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 连续线性算子 | 线性且连续 | `ContinuousLinearMap` | 全局范数界 | 语义一致，直接复用 | 有界／连续等价 | `functional-analysis.operator.continuous-linear-map` |
| 算子范数 | 最小全局放大界 | CLM 上的 `‖T‖` | 基本估计、最小界 | 不另定义 `sInf` 范数 | 算子空间完备 | `functional-analysis.operator.space` |
| 绝对可和 | 范数级数可和 | `Summable (fun n ↦ ‖f n‖)` | 推出 `Summable f` | 不建包装谓词 | 部分和与总和估计 | `functional-analysis.series.summable` |
| 闭线性子空间 | 线性子空间且闭 | `Submodule` + `IsClosed` | 零商范数刻画 | 不建包装结构 | 商空间完备 | `functional-analysis.subspace.quotient` |
| 商空间／商范数 | 模掉子空间；到子空间距离 | `E ⧸ S`、标准 `‖·‖` | `infDist` 公式 | 不建商集或范数 | 商映射估计 | `functional-analysis.subspace.quotient` |

全部 Mathlib 专用结构、Prop 和记号均属于“语义一致的正式公开承载”；没有本库特殊桥侧、私有
高阶后端、未披露全局 instance 或越级公开接口。

## 商空间验证

- `lake build SandronesLibrary.FunctionalAnalysis.QuotientSpace` 连同本批闭包：8709 jobs 通过；
  只重放既有 `Topology/Metric.lean` 格式警告。
- 聚合 `#check` 覆盖 `Submodule`、`IsClosed`、商映射、距离刻画、闭包边界和商完备性上层使用者。
- `functional-analysis.subspace.quotient` 精确映射到五个公开声明；没有新增 `def`、结构或 instance。
- 五个声明的 `#print axioms` 均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## Banach 级数验证

- 直接采用 `Summable f`、`HasSum f x` 与 `Summable (fun n ↦ ‖f n‖)`；未增加级数或
  “绝对可和”本地定义。
- `lake build SandronesLibrary.FunctionalAnalysis.BanachSeries`：8708 jobs 通过；新增模块仅有
  `BanachSpace` 教材语境中的未使用线性结构提示，另重放既有 Topology 格式警告。
- 聚合 `#check` 覆盖正式承载、Mathlib 复用定理和三个公开声明；Entry 精确映射为三个声明。
- 三个声明的 `#print axioms` 均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。
- 同步 Main 后已将临时 id `functional-analysis.banach-series.absolute-summable` 纠正为 ROADMAP
  冻结的 `functional-analysis.series.summable`。

## 算子空间验证

- `lake build SandronesLibrary.FunctionalAnalysis.OperatorSpace`：8709 jobs 通过；只重放既有
  `Topology/Metric.lean` 格式警告。
- 聚合 `#check` 覆盖 Mathlib 正式承载、上一窗有界刻画和本窗五个公开声明。
- `functional-analysis.operator.space` 精确映射到五个声明；没有新增 `def`、结构或 instance。
- 两个代表性结论的 `#print axioms` 均为 `propext`、`Classical.choice`、`Quot.sound`。
- 禁用占位扫描与 `git diff --check` 通过。

## 修正版验证

- `lake build SandronesLibrary.FunctionalAnalysis.Operator`：8708 jobs 通过；只重放既有 Topology
  格式警告。
- 聚合 `#check` 覆盖正式承载、算子范数基本估计、三条展开性质和有界／连续等价；公理检查通过。
- Entry 映射：continuous-linear-map 3 个声明，bounded-iff 1 个声明；无自建核心 `def`。
- 禁用占位扫描和 `git diff --check` 通过。
