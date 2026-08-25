# 紧算子 API 审计

- 审计基线：Mathlib 当前 checkout（Main `837e93f`）
- 权限：compact operators `research_open`；Fredholm `frozen`
- 结论：定义、刻画、代数运算与闭性后端充分，可开放定义层窗口；Fredholm 仍不应进入开发

## 正式承载

- `IsCompactOperator f` 已是 Mathlib 的正式谓词：存在紧集，其原像是零邻域。
- `isCompactOperator_iff_isCompact_closure_image_ball` 与闭球版本给出教材常用刻画：单位球像的
  闭包紧致。
- `compactOperator` 是连续线性映射空间中的紧算子子模，不需要本地结构包装。

## 已有运算与例子

- `isCompactOperator_zero`、`IsCompactOperator.add`、`smul`、`neg`、`sub`。
- `IsCompactOperator.comp_clm` 与 `IsCompactOperator.clm_comp`：连续线性映射前后复合保持紧性。
- `isCompactOperator_of_locallyCompactSpace_dom`／`rng`：有限维路线的直接后端。
- `isCompactOperator_id_iff_finiteDimensional`：赋范空间恒等算子紧当且仅当有限维。
- `isClosed_setOfPred_isCompactOperator` 与 `isCompactOperator_of_tendsto`：算子范数极限保持紧性。

## 首个开发窗建议

只做定义展开、单位球像闭包刻画、零算子／有限维值域实例、复合与范数极限闭性。直接复用
`IsCompactOperator` 和 `compactOperator`，不创建 `CompactOperator` 包装类型。

## 冻结边界

`Mathlib.Analysis.Normed.Operator.Compact.FredholmAlternative` 虽已有强后端，但 Main 明确冻结
Fredholm；本审计不导入该文件、不创建相关 Entry，也不以 Mathlib 已有为理由越过权限门。
