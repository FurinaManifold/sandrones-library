# F6.3 spectrum nonempty/compact/radius handoff

- 分支：`codex/functional-analysis-restart`
- 权限：`development_open`（`main-f5-final-f6-definition-accepted-more-open.md`）
- Entry：`functional-analysis.spectrum.nonempty-compact`
- 前置：F6.1、F6.2 已由 Main 集成

## 文件

- `SandronesLibrary/FunctionalAnalysis/SpectrumNonemptyCompact.lean`
- `docs/entries/functional-analysis/spectrum/nonempty-compact.md`
- 本 handoff

## 教材核对

按渲染页面直接核对 `textbook/Salamon, Functional analysis.pdf`，未使用文本抽取：

- PDF 第 226 页／印刷第 211 页：Theorem 5.2.7 陈述谱半径公式及谱非空；
- PDF 第 227 页／印刷第 212 页：完成半径估计，并以预解映射和 Liouville 定理证明谱非空。

教材对 `A : X → X` 陈述；本条使用 Mathlib 更一般的复 Banach 代数版本。有界算子代数是直接实例。

## 定义挂靠与公开接口

没有创建平行谱 carrier 或平行谱半径：

- `complexSpectrum_nonempty`
- `complexSpectrum_isCompact`
- `norm_spectrum_le`
- `spectralRadius_le_nnnorm`
- `exists_spectrum_nnnorm_eq_spectralRadius`
- `tendsto_nthRoot_nnnorm_pow_spectralRadius`

文档显式解释 `[Nontrivial A]`、`[NormOneClass A]`、`ℝ≥0∞` 谱半径和 `n = 0` 的总函数约定。

## Mathlib 复用边界

本条直接复用 Mathlib 已有的 Liouville、紧致性与 Gelfand 公式证明，不复制分析核心；但并非只包装
一个最终定理，而是组织非空、逐点范数界、紧致、最大值见证和极限公式，作为 F6.4 的完整前置接口。

## 权限推进

Main 最新意见规定 F6.4 在本 handoff 后由 `research_open` 自动转为 `development_open`。本 handoff
请求核验 F6.3，同时据协议开始 F6.4 紧算子非零谱窗口；F6.5 仍只维持 `research_open`。
