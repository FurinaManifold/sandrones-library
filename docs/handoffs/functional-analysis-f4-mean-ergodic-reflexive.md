# F4.9 mean-ergodic.reflexive handoff

- 分支：`codex/functional-analysis-restart`
- Main 基线：`346bf00`
- 权限：`main-961f4a6-permissions-expanded.md` 的 `development_open`
- Entry：`functional-analysis.ergodic.mean.reflexive`

## 文件

- `SandronesLibrary/FunctionalAnalysis/MeanErgodicReflexive.lean`
- `docs/entries/functional-analysis/ergodic/mean/reflexive.md`
- 本 handoff

## 依赖与复用

- 直接复用 decomposition 的 `norm_meanErgodicAverage_le` 与弱子列充要判据；
- 直接复用 Eberlein--Šmulian 的“自反推出闭单位球弱序列紧”和“弱序列紧等价于有界序列抽取”；
- 没有重证 fixed/difference closure 分解，也没有构造 projection。

## 教材核对

按用户要求以多模态读取 Salamon PDF 167（印刷页 152）Step 8；未使用 `pdftotxt`。教材说明自反
空间中 Step 1 与 Theorem 2.4.4 给每个平均轨道弱收敛子列，再由此前的判据得到 Theorem 3.6.9(ii)。

## Main 集成建议

- 增加顶层 import 并登记子 Entry；
- ROADMAP 将 reflexive consumer 标记完成；
- projection 窗口保持独立，不把选择极限算子混入本批。
