# Analysis maintenance handoff：数列收敛定义层

## 交付定位

- 分支：`codex/analysis-maintenance-uniform-compact`
- 基线：`a9d90a5`
- 定义层提交：`1942df8`（新增教材定义、等价桥、审计、RFC 与课程文档）
- RFC：`docs/maintenance/analysis-sequence-definition-layer.md`
- 影响等级：M1
- 当前范围：补充教材定义与桥；不迁移或退役 Mathlib 接口。

## 公开 API

新增教材定义：

```lean
SequenceConvergesTo (u : ℕ → ℝ) (l : ℝ) : Prop
```

新增桥：

```lean
sequenceConvergesTo_iff_epsilon_N :
  SequenceConvergesTo u l ↔ ∀ ε > 0, ∃ N, ∀ n ≥ N, |u n - l| < ε

sequenceConvergesTo_iff_tendsto :
  SequenceConvergesTo u l ↔ Tendsto u atTop (𝓝 l)
```

原 `tendsto_iff_epsilon_N` 及全部既有主定理保持原名和原签名。新旧概念双向等价，没有语义降级。

## 文件清单

- `SandronesLibrary/Analysis/Sequence.lean`
- `docs/entries/analysis/sequence/definition.md`
- `docs/entries/analysis/DEFINITION-AUDIT.md`
- `docs/maintenance/analysis-sequence-definition-layer.md`
- `docs/handoffs/analysis-maintenance-sequence-definition-layer.md`

## 定义挂靠与既有使用者

- 已补齐：`analysis.sequence.definition` 的教材量词、定义展开和 Mathlib 等价桥。
- `Sequence.lean` 中极限唯一、有界、夹逼、单调收敛、子列、完备性、上下极限和极限运算继续
  使用 `Tendsto`，这是正式接口选择，不列为未迁移债务。
- `FuncLimit`、`Series`、`Completeness`、`PowerSeries`、`Series/CauchyProduct`、
  `Series/RiemannRearrangement` 也不因本维护批次要求替换 `Tendsto`。
- 当前 Analysis 源码内匹配数列型 `Tendsto ... atTop (𝓝 ...)` 的使用为 107 处、分布在 7 个文件；
  `CauchySeq` 为 14 处。该计数只说明 Mathlib 接口使用广泛，不是待清零指标。
- `tendsto_iff_epsilon_N` 在声明文件之外仍有引用；它是有效接口，没有退役计划。

## 验证

- 修改后的 `Sequence.lean` 使用锁定依赖缓存直接类型检查通过。
- 临时聚合检查同时 `#check` 新定义、两个新桥、旧 ε-N 接口和旧极限唯一接口，通过。
- `#print axioms sequenceConvergesTo_iff_tendsto`：
  `[propext, Classical.choice, Quot.sound]`。
- `python3 scripts/audit.py`：381 个条目通过。
- 修改源码未发现 `sorry`、`admit`、`sorryAx`、`native_decide`。
- `git diff --check` 通过。

维护 worktree 自身的 Mathlib 冷缓存缺少总模块 `Mathlib.olean`，因此本轮没有把一次依赖全重建
冒充学科闭包构建；类型检查复用了同一仓库锁定依赖的现成缓存。全库 build 仍由 Main 集成后执行。

## Main 共有文件建议

- Registry 保持 Entry id `analysis.sequence.definition`，把定义角色和公开声明更新为
  `SequenceConvergesTo`，并登记 `sequenceConvergesTo_iff_tendsto` 为 Mathlib 桥。
- `docs/ROADMAP-LONGTERM.md` 的该条状态可继续为完成，但说明应从“直接使用
  `Metric.tendsto_atTop`”改为“本库 ε-N 定义 + Mathlib 桥”。
- RADAR 记录数列教材定义与 Mathlib 桥已补齐；不要登记成接口替换工程。
- 顶层 import 无需变化；本轮仍只修改现有 `Sequence.lean`。

## 下一维护项

下一项可按同一原则给 Cauchy 列补充双指标 ε-N 定义及 `CauchySeq` 桥，或者给函数极限补充
ε-δ 定义及 `Tendsto` 桥。既有定理继续使用 Mathlib 接口，不需要先做全文件签名改写。
