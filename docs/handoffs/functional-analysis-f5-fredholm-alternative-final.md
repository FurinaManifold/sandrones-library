# F5.6 Fredholm alternative 最终开发窗 handoff

- 分支：`codex/functional-analysis-restart`
- Main 基线：`346bf00`
- 权限：第二窗 handoff 后按 `main-961f4a6-permissions-expanded.md` 自动转
  `development_open`
- Entry：`functional-analysis.fredholm.alternative`
- 依赖提交：`516140d`、`4a275f7`

## 文件

- `SandronesLibrary/FunctionalAnalysis/FredholmAlternative.lean`
- `docs/entries/functional-analysis/fredholm/alternative.md`
- 本 handoff

## 交付

- `identitySubCompact_injective_iff_surjective`：`I-K` 单射当且仅当满射；
- `identitySubCompact_ker_eq_bot_iff_range_eq_top`：等价的核／值域子空间陈述。

证明只消费有限维核、有限维余核与 `index(I-K)=0`。单射使核维数为零，指数零继而使余核维数为
零；满射方向完全对称。没有重证紧性、闭值域、幂链稳定或指数零。

## Mathlib 挂靠与边界

- 单射／满射直接使用 `Function.Injective`、`Function.Surjective`；
- 核／值域直接使用 `ContinuousLinearMap.ker/range`；
- 维数与指数继续使用 `FiniteDimensional`、`Module.finrank`、`LinearMap.index`；
- 未导入或调用 Mathlib 最终 `Compact.FredholmAlternative`；
- 不包含预解集、谱、特征值或 F5.7 一般稳定性。

## Main 集成建议

- 在第二窗之后增加本模块顶层 import；
- 更新同一 Fredholm alternative Entry 并将 F5.6 标记完成；
- F5.7 继续维持 Main 当前权限，不因本特殊结论扩大一般接口。
