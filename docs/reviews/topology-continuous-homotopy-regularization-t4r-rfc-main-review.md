# Main review：T4-R 连续同伦正则化 RFC

- branch: `codex/topology-foundations`
- reviewed_artifact: `review-inbox/topology/topology-continuous-homotopy-regularization-t4r-rfc.md`
- reviewer: `main`
- verdict: `partial_route_accepted`
- reviewed_at: 2026-08-25

## 裁决

RFC 已证明一个边界明确的正式开发窗口可行：若标准道路同伦具有全局连续延拓，该延拓在闭方形
四边的某个邻域已经二阶连续可微，并且原同伦像位于给定开集，则可以相对四边作二阶光滑逼近，
保持开域像，并重新组装为上下边和固定端点不变的标准 `Path.Homotopy`。候选定理的统一余量、
相对闭集近似、四边语义和双重 `IccExtend` 正则性均已有编译原型。

因此 T4-R2“边界 collar 相对平滑化”提升为 `development_open`。统一开域余量由 Mathlib 的
`IsCompact.exists_cthickening_subset_open` 精确承载，不另设装饰性 Entry。

## 未解除的门

R2 假设边界邻域事先已经 `C²`，不能处理一般连续或仅分段 `C¹` 的边界道路。因此 T4-R3 保持
`research_open`；G-T4/C 仍未完成，复分析一般连续同伦不变性、无条件单连通域积分无关和原函数
存在均不得解冻。
