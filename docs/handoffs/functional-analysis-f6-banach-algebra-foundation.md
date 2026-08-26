# F6.1 Banach algebra foundation handoff

- 分支：`codex/functional-analysis-restart`
- Main 基线：`346bf00`
- 权限：`main-961f4a6-permissions-expanded.md` / `development_open`
- Entry：`functional-analysis.banach-algebra.foundation`

## 文件

- `SandronesLibrary/FunctionalAnalysis/BanachAlgebraFoundation.lean`
- `docs/entries/functional-analysis/banach-algebra/foundation.md`
- 本 handoff

## 定义挂靠

本批没有建立平行 `BanachAlgebra` 类型或结构。复幺 Banach 代数精确挂靠为：

- `NormedRing A`；
- `NormedAlgebra ℂ A`；
- `CompleteSpace A`；
- 课程的归一化幺情形再带 `NormOneClass A`。

非幺情形直接使用 `Unitization ℂ B`；有界算子代数直接使用 `E →L[ℂ] E` 的既有实例。

## 公开接口

- `banachAlgebra_norm_mul_le`
- `banachAlgebra_hasSum_geometric_inverse`
- `banachAlgebra_one_sub_isUnit`
- `complexUnitization_complete`
- `complexUnitization_inclusion_isometry`
- `norm_complexUnitization_inclusion`
- `operator_hasSum_geometric_inverse`
- `operator_one_sub_isUnit`

## 边界与自动开放

本批只覆盖定义挂靠、单位化、Neumann 级数与 `I-T` 的小范数可逆性。不包含 `spectrum`、
`resolventSet`、预解算子或 `spectralRadius`。handoff 冻结 F6.1 接口后，F6.2 定义层依 Main 通知
自动转为 `development_open`；F6.3 以后仍冻结。

## Main 集成建议

- 增加本模块顶层 import；
- 登记新 Entry 并将 F6.1 标为完成；
- 允许 F6.2 继续使用同一 Mathlib carrier，不创建平行谱定义。
