# F6.2 spectrum/resolvent definition handoff

- 分支：`codex/functional-analysis-restart`
- Main 基线：`346bf00`
- 权限：F6.1 handoff 后按 `main-961f4a6-permissions-expanded.md` 自动转
  `development_open`
- Entry：`functional-analysis.spectrum.definition`
- 前置提交：`8b770bc`

## 文件

- `SandronesLibrary/FunctionalAnalysis/SpectrumDefinition.lean`
- `docs/entries/functional-analysis/spectrum/definition.md`
- 本 handoff

## 定义挂靠

- 谱：`spectrum ℂ a`；
- 预解集：`resolventSet ℂ a`；
- 预解映射：`resolvent a z = Ring.inverse (z·1-a)`；
- 谱半径：`spectralRadius ℂ a : ℝ≥0∞`；
- 有界算子谱直接使用 `E →L[ℂ] E` 的 Banach 代数实例。

没有创建平行谱集合、平行 resolvent carrier 或实数值谱半径。

## 公开接口

- `spectrum_eq_compl_resolventSet`
- `mem_resolventSet_iff_isUnit`
- `mem_spectrum_iff_not_isUnit`
- `resolvent_eq_ringInverse`
- `spectralParameter_sub_mul_resolvent`
- `resolvent_mul_spectralParameter_sub`
- `spectralRadius_eq_iSup_norm`
- 两个 bounded-operator specialization

## 边界

本批不调用谱非空、谱紧致、预解集开或 Gelfand 半径公式来冒充定义开发。F6.3 以后依 Main 最新
ROADMAP 仍冻结；本 handoff 不主张自动开放新的数学窗口。

## Main 集成建议

- 在 F6.1 后增加本模块顶层 import；
- 登记 Entry 并将 F6.2 定义层标为完成；
- 继续冻结 F6.3，直到 Main 核验 C1 与紧算子消费者依赖门。
