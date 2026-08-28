# S1 估计量相合性正式交接

- entry：`statistics.estimator.consistency`
- branch：`codex/probability`
- synced Main：`8042fcb`
- gate：`development_open`
- formal source：`SandronesLibrary/Statistics/Consistency.lean`
- files：
  - `SandronesLibrary/Statistics/Consistency.lean`
  - `docs/entries/statistics/estimator/consistency.md`
  - `docs/handoffs/statistics-s1-consistency.md`

## 概念冻结表

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 估计量序列 | 每个样本量一个确定性统计量 | `T : ℕ → 𝓧 → ℝ` | 共同观测空间 | 避免无 coupling 的 kernel 序列泄漏 | pointwise theorem | `statistics.estimator.consistency` |
| 逐参数相合 | 固定参数下依概率收敛 | `TendstoInMeasure (P θ) T ...` | `pointwiseConsistency_iff` | 直接复用 Pr3 carrier | 偏差概率 | 同上 |
| 均方相合 | `L²` 误差趋零 | `eLpNorm ... 2 ... → 0` | `pointwiseConsistent_of_L2` | 复用 Lp-to-probability | 概率相合 | 同上 |
| 一致相合 | 参数最坏偏差概率趋零 | ENNReal measure `iSup` | 文档精确量词 | 未冒充由 pointwise 自动推出 | 后续消费者 | 同上 |

## 公开签名扫描

- 正式承载：`Kernel`、`IsMarkovKernel`、`TendstoInMeasure`、`eLpNorm`、`AEStronglyMeasurable`；Entry
  解释共同底空间与类型类条件。
- 两个公开声明：pointwise 偏差概率展开与 `L² →` 概率相合。
- 私有后端：`convergesInProbability_iff_measureReal_dist`、`convergesInLp_inProbability`。
- 越级泄漏：无随机化 coupling、MLE、渐近正态、Fisher 或 Cramér--Rao。

## 负责人验收

- `/tmp/StatisticsConsistencyAudit.lean` 先验证两项正式签名和一致相合量词，无错误、warning 或
  `sorry`。
- `lake build SandronesLibrary.Statistics.Consistency` 通过（3014 jobs）。
- `/tmp/StatisticsConsistencyAggregate.lean` 联合导入并 `#check` 正式承载与两个公开定理，通过。
- Entry 映射得到唯一 id `statistics.estimator.consistency`，准确覆盖两个公开声明。
- 两项 `#print axioms` 均仅含 `propext`、`Classical.choice`、`Quot.sound`，没有 `sorryAx`。
- 正式源码占位扫描与 `git diff --check` 均通过。

## 诚实边界与 Main 建议

- 共同观测空间未编码“只依赖前 n 个坐标”；一般变化空间和随机化 coupling 未完成。
- 未从逐参数相合推出一致相合；MSE 到 L² 的精确归一化桥留待后续消费者。
- Main 集成时请登记唯一 id、导入 `Consistency.lean` 并更新 ROADMAP。
