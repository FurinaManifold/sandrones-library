# Pr2 有界可选停止交接

- entry：`probability.martingale.optional-stopping-entry`
- branch：`codex/probability`
- formal source：`SandronesLibrary/Probability/OptionalStopping.lean`
- files：
  - `SandronesLibrary/Probability/OptionalStopping.lean`
  - `docs/entries/probability/martingale/optional-stopping-entry.md`
  - `docs/handoffs/probability-pr2-optional-stopping.md`

## 概念冻结表

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 停时 | 时刻 `i` 能判断是否已停止 | `IsStoppingTime 𝓕 τ` | `stoppingTime_iff_measurableSet_le` | 直接复用 `WithTop` 值停时 | 停止值 | `probability.martingale.optional-stopping-entry` |
| 停止值 | 在随机时刻读取过程 | `stoppedValue X τ` | `stoppedValue_apply` | 有界性排除 `untopA` 的无限分支 | 可选停止 | `probability.martingale.optional-stopping-entry` |
| 有界可选停止 | `τ ≤ σ ≤ N` 时鞅的两个停止期望相等 | `martingale_expected_stoppedValue_eq` | 初始时刻推论 `martingale_expected_stoppedValue_eq_initial` | 对 `X` 和 `-X` 复用 `Submartingale.expected_stoppedValue_mono` | 公平游戏期望公式 | `probability.martingale.optional-stopping-entry` |

## 边界与公开签名

- 只公开 `ℕ` 指标、`ℝ` 值、确定常数一致有界的教材版本；没有假装无界可选停止无条件成立。
- `SigmaFiniteFiltration μ 𝓕` 是 Mathlib 条件期望／停时积分链的真实假设。
- `ℕ∞` 允许无限停时，但上界 `σ ≤ N` 排除定理中的无限分支。
- 没有自建 stopping-time 或 stopped-process carrier，没有新增全局实例。
- 可选抽样、Doob 不等式和连续时间结论未在本条目中提前计入。

## Main 集成门

- `lake build SandronesLibrary.Probability.OptionalStopping`：通过。
- 临时聚合文件同时检查停时 carrier、定义展开、停止值、Mathlib 次鞅单调性和两个最终等式：通过。
- 新增声明的 `#print axioms` 仅含 Lean／Mathlib 标准公理；无 `sorryAx`。
- 禁用占位扫描和 `git diff --check`：通过。

Main 集成时请登记 Registry id `probability.martingale.optional-stopping-entry`，唯一 `lean_file`
指向 `SandronesLibrary/Probability/OptionalStopping.lean`；运行 Entry 映射、axiom/audit、索引生成及
全库 `lake build`。学科 worktree 不修改 Main 所有的共享文件。
