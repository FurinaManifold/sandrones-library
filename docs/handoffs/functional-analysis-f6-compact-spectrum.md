# F6.4 compact spectrum handoff

- 分支：`codex/functional-analysis-restart`
- 权限：F6.3 handoff 后由 `research_open` 自动转 `development_open`
- Entry：`functional-analysis.compact-spectrum`
- 前置提交：`d297f71`

## 文件

- `SandronesLibrary/FunctionalAnalysis/CompactSpectrum.lean`
- `docs/entries/functional-analysis/compact-spectrum.md`
- 本 handoff

## 教材核对

按渲染页面直接核对 `textbook/Salamon, Functional analysis.pdf`，未使用 `pdftotxt`：

- PDF 第 228 页／印刷第 213 页：Theorem 5.2.8 陈述非零谱点为特征值、广义特征空间有限维、
  非零谱点孤立；
- PDF 第 229 页／印刷第 214 页：以 Riesz 引理和紧性证明幂核链稳定，并给出 Fitting 分解；
- PDF 第 230 页／印刷第 215 页：总结谱为有限集或趋零序列，并引出谱投影。

## Mathlib 复用与新增核心

直接复用：

- `IsCompactOperator.hasEigenvalue_iff_mem_spectrum`。

本提交新增的一般复 Banach 空间证明：

- 普通非零特征空间有限维；
- 每个有限阶广义特征空间有限维；
- 对每个 `ε>0`，模至少 `ε` 的谱点有限；
- 任意互异谱点序列趋于零。

定量有限性证明使用特征向量线性无关、递增有限维张成、Riesz 引理和紧性反证，不以 Mathlib
最终 theorem 的薄包装冒充 F6.4。

## 公开接口

- `compact_hasEigenvalue_iff_mem_spectrum`
- `finiteDimensional_eigenspace_of_compact`
- `finiteDimensional_genEigenspace_of_compact`
- `finite_spectrum_norm_ge_of_compact`
- `tendsto_zero_of_injective_spectrum_sequence`

## 权限边界

没有导入内积、自伴性、正交分解、全纯函数演算或谱投影。F6.5 仍按 Main 最新意见保持
`research_open`，本 handoff 不主张自动转开发。
