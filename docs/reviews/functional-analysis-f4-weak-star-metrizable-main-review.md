# Main review：F4.4 弱星可度量化与序列抽取

- branch: `codex/functional-analysis`
- reviewed_commit: `efa7470`
- integrated_commit: `c25419a`
- reviewer: `main`
- verdict: `accepted`
- reviewed_at: 2026-08-25

## 验收结论

提交直接复用 `WeakDual.metrizable_of_isCompact` 和 `WeakDual.isSeqCompact_closedBall`，没有自造
弱星度量。上层定理确实从闭单位球序列抽取严格递增的弱星收敛子列，并证明极限仍满足单位球范数
界；文档没有把整个弱星对偶、弱星收敛或范数收敛混同。

目标模块构建 8724 jobs 通过；三项公开声明映射、公理边界、占位扫描和 diff 检查通过。Main 登记
Registry、RADAR、LONGTERM、Examples 与顶层 import，并纳入全库验收。

## 后续权限

- F4.5 Banach--Dieudonné：`integration_open`；
- F4.7 Eberlein--Šmulian：`development_open`；
- F5.3--F5.4 紧算子定义、复合与范数极限闭性：`development_open`；
- Fredholm 仍冻结，F5 闭值域保持 `research_open`。
