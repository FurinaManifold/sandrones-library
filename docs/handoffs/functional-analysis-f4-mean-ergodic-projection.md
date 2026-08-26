# F4.9 mean-ergodic.projection handoff

- 分支：`codex/functional-analysis-restart`
- Main 基线：`346bf00`
- 权限：`main-961f4a6-permissions-expanded.md` 的 `development_open`
- Entry：`functional-analysis.ergodic.mean.projection`
- 依赖提交：`ca8ddf7`（reflexive consumer）

## 文件

- `SandronesLibrary/FunctionalAnalysis/MeanErgodicProjection.lean`
- `docs/entries/functional-analysis/ergodic/mean/projection.md`
- 本 handoff

## 公开接口

- 极限算子与逐点收敛；
- 极限落入 fixed space、在 fixed space 上恒等；
- 与 `T` 交换、`TS=S`、幂等；
- 合并恒等式 `ST=TS=S²=S`。

所有选择与线性组装后端保持 private。公开签名只出现既有课程概念和 Mathlib
`ContinuousLinearMap`、双对偶典范嵌入，没有新建投影 carrier。

## 教材核对与边界

按用户要求以多模态读取 Salamon PDF 167（印刷页 152）Step 8；未使用 `pdftotxt`。本批对应
“定义 `S` 后由 Step 3 得有界、由 Step 6 得极限、并证明 `ST=TS=S²=S`”。Lean 陈述明确是逐点
范数极限，不声称算子范数收敛。

## Main 集成建议

- 在 reflexive consumer 之后增加顶层 import 与 Entry；
- ROADMAP 将 projection consumer 标记完成；
- decomposition、reflexive、projection 三批保持独立提交顺序。
