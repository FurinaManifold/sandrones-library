# 概率论 Pr1 基础交接

## 批次与所有权

- staging：`codex/probability`，唯一负责人 worktree 为
  `/home/pisquare/czt/sandrones-library-probability`。
- 本批新增 `SandronesLibrary/Probability/` 八个 Entry 对应模块及八篇课程文档。
- 不修改 Main 共有的 `SandronesLibrary.lean`、Registry、ROADMAP、RADAR、Playbook 或生成索引。
- 两个只读调研子 Agent 分别审核 M/R 与 E/独立性/不等式 Mathlib API；三个编码 worker 在用户
  指出 worktree 纪律后立即关闭，未产生提交。全部正式代码由负责人在唯一 staging 中收敛。

## 概念清单

| 概念 | 教材语义 | Lean 正式承载 | 展开／刻画 | 复用说明 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 概率测度 | 总质量为一的测度 | `IsProbabilityMeasure μ` | `probabilityMeasure_iff` | 语义一致，不建概率空间结构 | `distribution_isProbabilityMeasure` | `probability.space.definition` |
| 事件 | 样本空间中的可测集合 | `MeasurableSet A` | 补、交与补概率公式 | 不建 Event subtype | `independentEvents_iff` | `probability.space.definition` |
| 随机变量 | 可测函数 | `Measurable X` | `randomVariable_iff_preimage` | 不建 RandomVariable 结构 | `distribution_apply` | `probability.variable.definition` |
| 分布 | 随机变量的推前测度 | `μ.map X` | `distribution_apply` | 不建 distribution alias | 期望可在推前概率测度上使用 | `probability.distribution.pushforward` |
| 期望／有限期望 | Bochner 积分／可积 | `integral`、`Integrable` | `Integrable ↔ MemLp 1`、线性 | 不建 Expectation 运算 | 方差公式 | `probability.expectation.definition` |
| 方差／协方差 | 二阶中心矩／联合中心积 | `variance`、`evariance`、`covariance` | 二阶矩公式与有限性刻画 | 保留非 L2 时 variance 退化边界 | Chebyshev | `probability.moments.variance` |
| 事件独立 | 交概率等于概率乘积 | `IndepSet`、`Indep` | `independentEvents_iff` | 当前 Mathlib 无 `IndepEvents` 名称 | 变量独立原像刻画 | `probability.independence.events` |
| 变量独立 | 生成 σ-代数独立 | `IndepFun`、`iIndepFun` | 原像公式、可测复合 | 不建独立谓词 | 乘积期望分解 | `probability.independence.variables` |
| 基本概率不等式 | Markov/Chebyshev/Jensen | Mathlib 三个正式定理 | 三个课程接口 | 仅整理教材条件，不重证 | Pr2/Pr3 后续 | `probability.inequalities.basic` |

## 公开签名分类

- 正式公开承载：`Measure`、`IsProbabilityMeasure`、`MeasurableSet`、`Measurable`、
  `Measure.map`、`Integrable`、`MemLp`、`variance/evariance/covariance`、`IndepSet/IndepFun`、
  `ConvexOn`。均在对应 Entry 解释教材语义和类型类边界。
- 本库桥侧：没有新 carrier 或同义核心定义；新增声明均为展开、一手性质或教材条件包装。
- 私有后端：没有新增 private 数学结构，也没有新增 global instance。
- 越级泄漏：Jensen 的 `NormedSpace`、`CompleteSpace` 是其向量值积分真实语义，不是无关假设；
  其余接口没有 `Module`、条件期望、过滤、鞅或 Pr2/Pr3 概念。

## Main 共有文件建议

- 顶层依次 import 八个模块：`Space`、`Variable`、`Distribution`、`Expectation`、`Moments`、
  `IndependenceEvents`、`IndependenceVariables`、`Inequalities`。
- Registry 登记 ROADMAP 中八个 Pr1 id；状态转为 verified 后更新 G-Pr。
- ROADMAP 的 `probability.independence.events` Mathlib 栏把已失效的 `IndepEvents` 改成
  `IndepSet`／`Indep`。
- RADAR 记录 Mathlib 4.33 的 `Measure.map` 对非 a.e. 可测函数返回零测度，以及普通
  `variance` 对非 L2 函数退化为零这两个关键边界。

## 诚实边界

本批只完成 Pr1。条件概率、条件期望、过滤、鞅属于冻结的 Pr2；收敛方式、大数律、特征函数与
中心极限定理属于冻结的 Pr3。没有借现成强定理提前声称这些路线完成。
