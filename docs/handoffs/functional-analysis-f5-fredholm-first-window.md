# F5.6 Fredholm alternative 第一开发窗 handoff

- 分支：`codex/functional-analysis-restart`
- 起始 Main 基线：`2c67e3c`
- 权限：第一窗 `development_open`
- Entries：`functional-analysis.compact-operator.dual`、`functional-analysis.fredholm.alternative`

## 文件

- `SandronesLibrary/FunctionalAnalysis/SchauderCompactness.lean`
- `SandronesLibrary/FunctionalAnalysis/CompactPerturbationIdentity.lean`
- `docs/entries/functional-analysis/fredholm/alternative.md`
- `docs/entries/functional-analysis/compact-operator/dual.md`
- 本 handoff

## 教材核对

按用户要求只读取 PDF 页面图像、未使用 `pdftotxt`：

- PDF 190--192（印刷页 175--177）：Theorem 4.2.10，尤其 part (iii) 的对偶紧性；
- PDF 196--198（印刷页 181--183）：Main Fredholm Lemma 4.3.9 的有限维核、模核下界与闭值域链。

教材使用 Arzelà--Ascoli 证明对偶紧性；Lean 证明改用等价的 Banach--Alaoglu 加有限网论证，以复用
Mathlib 已稳定的弱星闭球紧性，同时仍完整证明从弱星控制到对偶范数控制的关键步骤。

## Mathlib 挂靠审计

| 概念 | 正式承载 | 本库工作 |
|---|---|---|
| 紧算子 | `IsCompactOperator` | 不重定义；使用闭单位球像刻画 |
| Banach 对偶算子 | `ContinuousLinearMap.precomp` / `dualOperator` | 教材名与元素桥 |
| 弱星对偶闭球 | `WeakDual.isCompact_closedBall` | 组装 Schauder 定理 |
| 有限维核判据 | `isCompactOperator_id_iff_finiteDimensional` | 证明核上 `K=id` 后调用 |
| 闭补空间 | `Submodule.ClosedComplemented.of_finiteDimensional` | 在补空间上证明正下界 |
| 闭值域 | `AntilipschitzWith.isClosed_range` | 从自行证明的反 Lipschitz 估计收尾 |

Mathlib 全库搜索未发现 Schauder 对偶紧性声明。其最终
`Compact.FredholmAlternative` 文件虽有谱论备择，但本批未导入、未调用，也未复制其最终结论。

## 公开接口

- `dualOperator_isCompactOperator`
- `identitySubCompact`
- `identitySubCompact_apply`
- `finiteDimensional_kernel_identitySubCompact`
- `isClosed_range_identitySubCompact`

两个较长的技术构造保持 `private`：弱星球上的连续性提升，以及闭补空间上的反 Lipschitz 证明。

## 数学与权限边界

本批恰好覆盖 Main 开放的三项：对偶紧致、`I-K` 核有限维、`I-K` 值域闭。没有证明余核有限维、
index 零、单射／满射等价或最终 Fredholm 备择；也没有修改 Main 所有的顶层 import、Registry、
ROADMAP、RADAR 与生成索引。

## Main 集成建议

- 增加两个模块的顶层 import；
- 登记 Entry，并把 F5.6 标记为“第一窗完成、后续仍 research_open”；
- 在开放余核／指数路线前先冻结是否使用对偶闭值域链，以及 F5.7 紧扰动指数稳定性的依赖方向。
