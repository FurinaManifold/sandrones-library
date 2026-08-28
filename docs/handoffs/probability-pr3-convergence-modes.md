# Pr3 随机变量收敛模式正式层交接

- entry：`probability.convergence.modes`
- branch：`codex/probability`
- formal source：`SandronesLibrary/Probability/Convergence.lean`
- files：
  - `SandronesLibrary/Probability/Convergence.lean`
  - `docs/entries/probability/convergence/modes.md`
  - `docs/handoffs/probability-pr3-convergence-modes.md`

## 概念冻结表

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| a.s. 收敛 | 零测集外逐点收敛 | a.e. 量词内的 `Tendsto` | `almostSurelyConverges_iff_ae_tendsto` | 不另建 carrier | a.s.→概率 | `probability.convergence.modes` |
| 概率收敛 | 超过任意误差阈值的概率趋零 | `TendstoInMeasure μ X atTop Z` | `convergesInProbability_iff_measureReal_dist` | 概率测度上复用依测度收敛 | 概率→分布、a.s. 子列 | `probability.convergence.modes` |
| `Lᵖ` 收敛 | `eLpNorm (X n - Z) p μ → 0` | 普通 `Tendsto` + `eLpNorm` | `convergesInLp_inProbability` 的前提原样展示 | 不用旧 `snorm`，不强制 `Lp` carrier | `Lᵖ`→概率 | `probability.convergence.modes` |
| 分布收敛 | 推前概率测度弱收敛 | `TendstoInDistribution` | 正式 structure 自带 a.e. 可测性和 law `Tendsto` | 不另造同空间窄 carrier | 连续映射定理 | `probability.convergence.modes` |

## 已组装的蕴含和消费者

- `almostSurelyConverges_inProbability`：a.s. → 概率；
- `convergesInLp_inProbability`：`Lᵖ` → 概率，保留 `p ≠ 0`；
- `convergesInProbability_inDistribution`：概率 → 分布，保留 Borel／a.e. 可测条件；
- `almostSurelyConverges_inDistribution`：实际组装 a.s. → 概率 → 分布；
- `convergesInProbability_has_almostSurelyConvergent_subsequence`：只声称存在严格递增 a.s. 子列；
- `convergenceInDistribution_continuousMapping`：连续映射首个上层消费者。

## 边界

- 没有新增 convergence-mode enum、structure、def 或全局实例。
- a.s. 与 `Lᵖ` 模式直接使用组合表达；概率和分布模式复用成熟 carrier。
- 公开签名保留 a.e. 可测／强可测、概率测度、`p ≠ 0`、Borel 和拓扑条件。
- 没有声称任何一般逆命题成立。
- 没有包含 LLN、特征函数或 CLT。

## Main 集成门

- `lake build SandronesLibrary.Probability.Convergence`：通过。
- 临时聚合文件同时检查四种正式表达、全部蕴含、子列定理与连续映射消费者：通过。
- 新增声明 `#print axioms` 仅含 Lean／Mathlib 标准公理；无 `sorryAx`。
- 禁用占位扫描和 `git diff --check`：通过。

Main 集成时登记 Registry id `probability.convergence.modes`，唯一 `lean_file` 指向
`SandronesLibrary/Probability/Convergence.lean`；运行 Entry 映射、axiom/audit、索引生成和全库
构建。学科 worktree 不修改 Main 所有的共享文件。
