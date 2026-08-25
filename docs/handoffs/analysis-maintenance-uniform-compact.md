# 分析维护交接：`uniform-compact` Mathlib 状态说明

- 分支：`codex/analysis-maintenance-uniform-compact`
- RFC：`docs/maintenance/analysis-uniform-compact-mathlib-status.md`
- 影响等级：M0
- 阶段：事实性文档修正完成，无 API 迁移

## 已修改

- 修正 `docs/entries/analysis/continuity/uniform-compact.md`：明确当前 Mathlib 已有
  `IsCompact.uniformContinuousOn_of_continuous`。
- 保留并准确描述本库证明的独立价值：逐点半径、有限子覆盖、有限正最小值的教材构造。
- 新增维护 RFC，记录公开接口、影响图、回滚点和诚实边界。

## API 与下游

Lean API、Entry id、Registry premises 和下游源码均未变化。`RealAnalysis/Riemann.lean` 继续稳定依赖
`continuousOn_compact_uniformContinuousOn`；旧 API 使用者无需迁移。

## Main 共有文件事项

Main 接收本提交后，应把 `docs/MATHLIB-RADAR.md` 中“mathlib 无此定理，自建”改为：
“Mathlib 已有通用 Heine–Cantor 定理；本条没有调用它，而是保留独立有限覆盖证明”。
Registry、ROADMAP、顶层 imports 和自动生成目录无需语义更新。

## 验证与边界

本批只改 Markdown，不修改 Lean 证明。独立 worktree 首次定向构建会从零重建 8715 个依赖任务，
在确认进入纯缓存初始化后主动终止；随后使用同一提交基线、已有完整缓存的 main worktree 定向复验
`Analysis.Continuity` 与 `RealAnalysis.Riemann`。另检查 Entry 文档 id、禁用占位证明与
`git diff --check`。学科维护负责人不运行全库构建。
