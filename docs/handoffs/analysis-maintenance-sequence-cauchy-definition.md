# Analysis maintenance handoff：Cauchy 列定义

## 交付定位

- 分支：`codex/analysis-maintenance-uniform-compact`
- 基线：`507485c`
- 成果提交：`9e630ea`
- 维护说明：`docs/maintenance/analysis-sequence-cauchy-definition.md`
- 影响等级：M1
- 范围：补充教材定义、定义展开和 Mathlib 桥，不迁移既有定理接口。

## 新增 API

```lean
SequenceIsCauchy (u : ℕ → ℝ) : Prop
sequenceIsCauchy_iff_epsilon_N :
  SequenceIsCauchy u ↔ ∀ ε > 0, ∃ N, ∀ m ≥ N, ∀ n ≥ N, |u m - u n| < ε
sequenceIsCauchy_iff_cauchySeq : SequenceIsCauchy u ↔ CauchySeq u
```

原 `convergent_is_cauchy`、`cauchy_seq_convergent` 以及全部 `CauchySeq` 使用保持不变。

当前全库 Lean 中 `CauchySeq` 共 22 处，其中 Analysis 为 17 处；课程文档中共 14 处。这些是
保留的正式接口使用，不是待清零债务。

## 文件清单

- `SandronesLibrary/Analysis/Sequence.lean`
- `docs/entries/analysis/sequence/cauchy.md`
- `docs/entries/analysis/DEFINITION-AUDIT.md`
- `docs/maintenance/analysis-sequence-cauchy-definition.md`
- `docs/handoffs/analysis-maintenance-sequence-cauchy-definition.md`

## Main 共有文件建议

- Registry 保持 `analysis.sequence.cauchy` 的 theorem 类型，补充 `SequenceIsCauchy` 为教材定义、
  `sequenceIsCauchy_iff_cauchySeq` 为桥。
- ROADMAP 状态可保持完成；说明改为“本库双指标 ε-N 定义 + Mathlib CauchySeq 桥 + 实数完备性”。
- RADAR 只记录定义挂靠已讲清，不建立 Mathlib 接口替换任务。
- 顶层 import 无变化。

## 边界

本轮没有改动完备性、级数或幂级数源码，没有建立一般度量空间的本库 Cauchy 定义，也没有运行
Main 的全库 build。

## 验证

- 修改后的 `Sequence.lean` 使用同一锁定依赖缓存类型检查通过。
- 临时聚合检查同时 `#check` 新定义、两个新桥和两个既有 Cauchy 收敛准则，通过。
- `#print axioms sequenceIsCauchy_iff_cauchySeq`：
  `[propext, Classical.choice, Quot.sound]`。
- `python3 scripts/audit.py`：381 个条目通过。
- Cauchy 文档严格包含规定的八个一级标题，顺序正确。
- 修改源码未发现 `sorry`、`admit`、`sorryAx` 或 `native_decide`；`git diff --check` 通过。
