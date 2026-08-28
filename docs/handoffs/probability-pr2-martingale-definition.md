# Pr2 鞅定义层交接

- entry：`probability.martingale.definition`
- formal source：`SandronesLibrary/Probability/Martingale.lean`
- scope：鞅、上鞅、下鞅的定义展开、可积性桥与条件期望过程消费者
- branch：`codex/probability`
- files：
  - `SandronesLibrary/Probability/Martingale.lean`
  - `docs/entries/probability/martingale/definition.md`
  - `docs/handoffs/probability-pr2-martingale-definition.md`

## 概念冻结表

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 鞅 | 强适应，且未来关于当前信息的条件期望等于当前值 | `MeasureTheory.Martingale` | `martingale_iff_stronglyAdapted_conditionalExpectation` | 定义性展开；Banach 值域中由 `Martingale.integrable` 恢复逐时刻可积性 | 条件期望过程 | `probability.martingale.definition` |
| 上鞅 | 条件期望不超过当前值，并逐时刻可积 | `MeasureTheory.Supermartingale` | `supermartingale_iff_stronglyAdapted_conditionalExpectation` | 直接复用成熟 carrier，不另造过程结构 | 鞅的上下界刻画 | `probability.martingale.definition` |
| 下鞅 | 当前值不超过条件期望，并逐时刻可积 | `MeasureTheory.Submartingale` | `submartingale_iff_stronglyAdapted_conditionalExpectation` | 直接复用成熟 carrier，不另造过程结构 | 鞅的上下界刻画 | `probability.martingale.definition` |
| 条件期望过程 | `X_i = E[Y|𝓕_i]` | `fun i ↦ μ[Y | 𝓕 i]` | `conditionalExpectation_process_isMartingale` | 直接调用 `martingale_condExp`，消费过滤单调性与塔式性质 | 可选停止前置 | `probability.martingale.definition` |

## 接口边界

- 正式 carrier 使用 `StronglyAdapted`；没有把它无条件降成普通 `Adapted`。
- `Martingale` 本身未显式写可积性，但完备值域中 `i = j` 的条件期望等式推出可积性；上、下鞅
  则按 Mathlib 定义显式携带可积性。
- 时间指标仅要求 `Preorder`，没有提前收紧为离散时间或线性序。
- 本批没有定义停时，也没有声称可选停止、鞅收敛或连续时间正则化已经完成。

## 后续开放关系

按 Main 通知，本 handoff 冻结后，有界停时可选停止由 `research_open` 自动转
`development_open`。下一批仍须先审计 Mathlib 的停时和 stopped-process 正式接口，再冻结签名。

## 验证与 Main 集成门

- `lake build SandronesLibrary.Probability.Martingale`：通过。
- 临时聚合文件已同时 `#check` 三个正式 carrier、三个展开、可积性桥、上下鞅刻画和条件期望过程
  消费者：通过。
- `#print axioms`：仅报告 Mathlib／Lean 标准公理依赖；无 `sorryAx`。
- 正式文件及文档已扫描 `sorry`、`admit`、`sorryAx`、`native_decide` 和 `TODO`：无命中。
- `git diff --check`：通过。
- Main 集成时请登记 Registry id `probability.martingale.definition`，唯一 `lean_file` 指向
  `SandronesLibrary/Probability/Martingale.lean`，随后运行 Entry 声明映射、`check_axioms.py`、
  `audit.py`、生成索引和全库 `lake build`。学科 worktree 未修改这些 Main 所有的共享文件。
