# Analysis maintenance handoff：完备性定理的教材定义挂靠

- 基线：Main `9572873`
- 影响等级：M0 文档挂靠；不改 Lean 公开接口。

## 三项挂靠

| 定理族 | 教材定义 | Mathlib 桥 | 保留的历史接口 |
|---|---|---|---|
| 单调有界收敛 | `SequenceConvergesTo` | `sequenceConvergesTo_iff_tendsto` | 结论 `Tendsto` |
| 闭区间套单点性 | 长度列 `SequenceConvergesTo ... 0` | `sequenceConvergesTo_iff_tendsto` | 假设 `Tendsto` |
| Cauchy 完备性 | `SequenceIsCauchy`、`SequenceConvergent` | `sequenceIsCauchy_iff_cauchySeq`、`sequenceConvergesTo_iff_tendsto` | 假设 `CauchySeq`、结论 `Tendsto` |

这些公开签名是具名桥后的证明接口，不是新的教材概念，也不需要全面替换。完备性后端仍由
`CompleteSpace ℝ`、`cauchySeq_tendsto_of_complete` 和实数确界结构提供。

## 修改范围与验证

- 仅修改三篇课程文档、定义审计和本 handoff；未改 Lean、Registry、ROADMAP 或其他共有文件。
- `Completeness` 定向构建、八项定义链聚合 `#check` 和三个条目 audit 通过。
- `git diff --check` 通过。
