# Analysis maintenance handoff：条件收敛定义

- 基线：`01fa4ac`
- 定义：`SeriesConditionallyConvergent`
- 展开：定义本身为自然顺序收敛且非绝对收敛。
- 真实使用者：`seriesConvergent_of_seriesConditionallyConvergent`、
  `not_seriesAbsolutelyConvergent_of_seriesConditionallyConvergent`
- Entry：`analysis.series.basic`
- Mathlib 边界：不与 `Summable` 建立错误等价；历史接口保持不变。
- 验证：Series 模块、Entry 映射、audit、占位扫描及差异检查通过。
