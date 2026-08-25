# Analysis maintenance handoff：数项级数定义

## 交付定位

- 分支：`codex/analysis-maintenance-uniform-compact`
- 基线：`89d78ce`
- 成果提交：`6d2f9c9`
- 维护说明：`docs/maintenance/analysis-series-definitions.md`
- 影响等级：M1；新增概念并明确语义差别，不修改或替代既有 Mathlib 概念。

## 新增 API 与桥

```lean
SeriesHasSum (f : ℕ → ℝ) (s : ℝ) : Prop
SeriesConvergent (f : ℕ → ℝ) : Prop
SeriesAbsolutelyConvergent (f : ℕ → ℝ) : Prop

hasSum_seriesHasSum : HasSum f s → SeriesHasSum f s
seriesHasSum_iff_hasSum_of_summable_abs :
  Summable (fun n => |f n|) → (SeriesHasSum f s ↔ HasSum f s)
seriesAbsolutelyConvergent_iff_summable_abs :
  SeriesAbsolutelyConvergent f ↔ Summable (fun n => |f n|)
```

`SeriesHasSum` 固定自然顺序，`HasSum` 使用有限集滤子；二者无条件等价是错误命题。新 Entry id
没有另立，因为本批是在 `analysis.series.basic` 内把此前含混的基础概念拆清，而不是把旧概念改名。

## 文件与共享状态建议

- 修改 `SandronesLibrary/Analysis/Series.lean`、`analysis.series.basic` 文档和定义审计。
- 新增维护说明及本 handoff。
- Main 保持 `analysis.series.basic` 已完成，但 Registry/RADAR 需记录自然顺序和无条件求和的语义差别。
- 不应把所有 `HasSum`/`Summable` 使用登记为待替换；绝对收敛和无条件求和定理继续使用它们。
- 顶层 import 无变化。

## 边界

本批不重写几何级数、判别法、Cauchy 准则、条件收敛或重排定理，不定义级数数值算子，也不运行
Main 的全库 build。

## 验证

- 修改后的 `Series.lean` 使用同一锁定依赖缓存类型检查通过；仅有文件中既有未使用变量警告。
- 临时聚合检查同时 `#check` 三个新定义和三条桥，通过。
- 两条双向桥的 `#print axioms` 均为 `[propext, Classical.choice, Quot.sound]`。
- `python3 scripts/audit.py`：381 个条目通过。
- `analysis.series.basic` 文档严格包含规定的八个一级标题，顺序正确。
- 修改源码未发现 `sorry`、`admit`、`sorryAx` 或 `native_decide`；`git diff --check` 通过。
