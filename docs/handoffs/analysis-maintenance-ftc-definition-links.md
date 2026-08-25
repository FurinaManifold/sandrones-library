# Analysis maintenance handoff：FTC 教材概念挂靠

- 基线：Main `b5ceedc`
- Entry：`real-analysis.riemann.ftc`
- 影响等级：M0 文档挂靠；不改 Lean 公开签名或证明。

## 定义链

| FTC 概念 | 本库教材定义 | 具名桥／实现 | FTC 中的接口 |
|---|---|---|---|
| 区间连续 | `ContinuousOnTextbook` | `continuousOnTextbook_iff_continuousOn` | `ContinuousOn` |
| 全域连续 | `ContinuousOnTextbook f Set.univ` 的逐点语义 | 上桥加 `continuousOn_univ` | `Continuous` |
| 一元导数 | `HasDerivativeAtTextbook` | `hasDerivativeAtTextbook_iff_hasDerivAt` | `HasDerivAt` |
| Riemann 积分 | `riemannIntegral` | `riemannIntegral_eq_interval` 数值桥 | 结论左端仍为本库积分 |

FTC 的 Mathlib 区间积分定理是证明后端；`riemannIntegral_eq_interval` 是具名数值桥。课程主概念仍由
本库连续、差商导数和 Darboux–Riemann 定义提供。保留历史签名避免全面迁移现有下游。

## 验证

- `RiemannIntegralBridge` 定向构建与八项定义链聚合 `#check` 通过。
- `real-analysis.riemann.ftc` audit 通过；公理审计按未变 Lean 指纹增量跳过。
- `git diff --check` 通过。

同步 Main `b5ceedc` 后，定义审计中的无穷极限旧待办被集成版本恢复。本窗按已存在的四组定义、
展开和桥纠正为完成；不新增数学声明。
