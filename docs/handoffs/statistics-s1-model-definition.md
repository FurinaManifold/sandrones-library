# S1 统计模型定义层交接

- entry：`statistics.model.definition`
- branch：`codex/probability`
- formal source：`SandronesLibrary/Statistics/Model.lean`
- files：
  - `SandronesLibrary/Statistics/Model.lean`
  - `docs/entries/statistics/model/definition.md`
  - `docs/handoffs/statistics-s1-model-definition.md`

## 概念冻结表

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 统计模型 | 样本空间上一族随参数可测的概率测度 | `P : Kernel Θ 𝓧` 与 `[IsMarkovKernel P]` | `statisticalModel_measurable`、`statisticalModel_fiber_isProbabilityMeasure` | 不自建 `StatisticalModel`；直接接入 Mathlib 决策论 | 事件概率、后续 risk/density | `statistics.model.definition` |
| 事件概率 | 参数 `θ` 下事件 `s` 的概率 | `P θ s` | `statisticalModel_eventProbability_measurable`、`statisticalModel_measure_univ` | 消费 kernel 的测度值可测性和 Markov 条件 | likelihood／风险积分 | `statistics.model.definition` |
| 常模型 | 所有参数共享同一概率测度 | `Kernel.const Θ μ` | `constantProbabilityMeasure_isStatisticalModel` | 复用 const kernel 的 Markov 实例 | 基准模型 | `statistics.model.definition` |
| 确定性观测模型 | 参数唯一决定观测值 | `Kernel.deterministic f hf` | `deterministicObservation_isStatisticalModel` | Dirac 分布组成的成熟 Markov kernel | 确定性模型进入统一接口 | `statistics.model.definition` |

## 接口边界

- 没有新增与 `Kernel` 重复的 structure、def 或全局实例。
- 参数空间和样本空间都显式携带 `MeasurableSpace`；没有假装任意非可测测度族自动成为 kernel。
- `IsMarkovKernel` 提供逐纤维概率测度性质；没有把一般 finite kernel 冒充统计模型。
- 本批未定义 density、likelihood、估计量或一般估计定理。

## 后续开放关系

按 Main 通知，本 handoff 冻结后，statistics density 由 `research_open` 自动转
`development_open`。密度批必须沿既有审计使用 `Kernel.rnDeriv P (Kernel.const Θ ν)`，保留联合
可测版本所需的 countable/countably-generated 和有限 kernel 边界。

## Main 集成门

- `lake build SandronesLibrary.Statistics.Model`：通过。
- 临时聚合文件同时 `#check` 正式 carrier、全部展开／构造以及 Mathlib 的 `avgRisk`、`bayesRisk`、
  `minimaxRisk` 消费者：通过。
- 全部新增声明 `#print axioms` 仅含 Lean／Mathlib 标准公理依赖；无 `sorryAx`。
- 占位扫描与 `git diff --check`：通过。

Main 集成时请登记 Registry id `statistics.model.definition`，唯一 `lean_file` 指向
`SandronesLibrary/Statistics/Model.lean`；随后运行 Entry 声明映射、axiom/audit、生成索引与全库
`lake build`。学科 worktree 不修改 Registry、聚合 imports、ROADMAP 或生成索引等共享文件。
