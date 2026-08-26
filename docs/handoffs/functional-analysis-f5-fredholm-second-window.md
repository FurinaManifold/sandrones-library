# F5.6 Fredholm alternative 第二开发窗 handoff

- 分支：`codex/functional-analysis-restart`
- Main 基线：`346bf00`
- 权限：`main-961f4a6-permissions-expanded.md` 的 `development_open`
- Entry：`functional-analysis.fredholm.alternative`
- 前置：Main 已集成第一窗的 Schauder 对偶紧性、有限维核与闭值域

## 文件

- `SandronesLibrary/FunctionalAnalysis/FredholmCokernel.lean`
- `SandronesLibrary/FunctionalAnalysis/FredholmIndex.lean`
- `docs/entries/functional-analysis/fredholm/alternative.md`
- 本 handoff

## 公开接口

- `evaluationOnDualKernel`
- `evaluationOnDualKernel_ker_eq_range`
- `dualOperator_identitySubCompact`
- `finiteDimensional_cokernel_identitySubCompact`
- `compactPowerRemainder`
- `identitySubCompact_compactPowerRemainder`
- `compactPowerRemainder_isCompactOperator`
- `isClosed_range_pow_identitySubCompact`
- `finiteDimensional_kernel_pow_identitySubCompact`
- `finiteDimensional_cokernel_pow_identitySubCompact`
- `index_identitySubCompact_eq_zero`

幂核稳定、闭子空间零化子反演、Fitting 分解和幂指数归纳均保持 private，只公开后续最终备择需要
复用的结论。

## 教材与证明路线

按用户要求以页面图像、多模态读取 Salamon PDF 199--203（印刷页 184--188），未使用
`pdftotxt`。教材 Theorem 4.4.2 通过紧扰动路径与指数局部常值推出指数不变。本窗没有把尚处于
`research_open` 的一般 F5.7 稳定性抢先公开；改用等价的 Riesz--Schauder/Fitting 路线证明特殊
结论 `index(I-K)=0`：

1. 闭值域零化子刻画把余核嵌入对偶算子核的代数对偶；
2. Schauder 对偶紧性给出目标有限维；
3. Riesz 引理和紧性迫使 `(I-K)^n` 的核链稳定；
4. 对偶幂核稳定与闭值域零化子反演迫使值域链稳定；
5. Fitting 分解使某个正幂指数为零，`LinearMap.index_comp` 反推原算子指数为零。

## Mathlib 挂靠与边界

- 余核继续使用 `E ⧸ T.range` 与 `FiniteDimensional`，不建立平行 cokernel 类型；
- 指数继续使用 `LinearMap.index`，不建立平行 Fredholm 指数；
- 使用 `Subspace.instModuleDualFiniteDimensional`、`LinearMap.quotKerEquivRange`、
  `Submodule.quotientEquivOfIsCompl` 与 `LinearMap.index_comp` 等基础 API；
- 未导入、调用或复制 Mathlib 最终 `Compact.FredholmAlternative`；
- 未将一般紧扰动／小扰动指数稳定性包装为公开接口，F5.7 仍遵守 `research_open`。

## 验证

- `lake build SandronesLibrary.FunctionalAnalysis.FredholmIndex`：8733 jobs 通过；
- 两个模块独立 `lake env lean`：通过，源码无自身警告；
- `finiteDimensional_cokernel_identitySubCompact` 与 `index_identitySubCompact_eq_zero` 的
  `#print axioms` 均仅含 `propext`、`Classical.choice`、`Quot.sound`；
- `git diff --check`：通过；源码无 `sorry`、`admit`，无最终 FredholmAlternative 引用。

## Main 集成与自动开放

- 按顺序在第一窗之后增加两个顶层 import，并更新同一 Entry；
- ROADMAP 将 F5.6 第二窗标为完成；
- 依权限通知，本 handoff 冻结接口后，最终“单射／满射备择”自动转为 `development_open`。
