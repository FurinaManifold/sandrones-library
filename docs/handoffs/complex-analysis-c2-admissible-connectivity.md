# 复分析 C2 admissible 道路连通性 handoff

## 分支、范围与门状态

- 分支：`codex/complex-analysis`。
- 新源码：`SandronesLibrary/ComplexAnalysis/AdmissiblePathConnectivity.lean`。
- 新文档：
  `docs/entries/complex-analysis/cauchy/admissible-path-connectivity-foundation.md`。
- 完成 id：`complex-analysis.cauchy.admissible-path-connectivity-foundation`。
- 本批消除了路径积分原函数构造中的“从基点可积可达”假设；标准单连通路线现只缺
  `PathIntegralIndependentOn`，完整 C2 门仍未打开。

## 定义层与证明边界

- 不新增伪造的“多边形道路”结构，直接复用上一批 `AdmissiblePath`。
- `exists_admissiblePath_of_isPreconnected` 对任意连续 `f`、开预连通 `U` 成立；证明构造的道路由
  有限次短线段拼接隐式生成，但公开结论只承诺存在 admissible `Path`。
- 两个原函数推论仍显式要求 `PathIntegralIndependentOn f U`。其中标准
  `IsSimplyConnected U` 只自动提供非空与连通性，没有被错误当作光滑同伦桥。

## 负责人开发与审核

- 在 `/tmp/sandrones-complex-admissible-connectivity.lean` 先证明球内短线段 admissible，再定义
  可达集合 `R`。
- 负责人分别检查 `R` 和 `U \ R` 的开放性：后一方向必须从邻近可达点接反向线段回到当前点，
  不能仅引用前一方向的对称措辞。
- 使用 `IsPreconnected.subset_left_of_subset_union` 时显式验证两开集不交、覆盖 `U` 和基点所在的
  非空交，避免把环境空间的 clopen 与相对 clopen 混淆。

## 验证

- `lake build SandronesLibrary.ComplexAnalysis.AdmissiblePathConnectivity`：通过（2883 jobs）。
- 正式模块单文件编译通过。
- 聚合文件导入最近四个 C2 模块并 `#check` 三个公开定理：通过。
- 文档 front matter、精确八段、段落非空和源码/文档 Entry id 双射通过。
- 主推论公理为 `propext`、`Classical.choice`、`Quot.sound`。
- 禁用占位扫描、`git diff --check` 与全部复分析模块联合构建通过；未运行全库构建。

## Main 共有文件更新建议

- 顶层 import 新增 `SandronesLibrary.ComplexAnalysis.AdmissiblePathConnectivity`。
- Registry 接收 foundation id 并重算公理与 proof hash。
- RADAR 登记 `IsPreconnected.subset_left_of_subset_union`、`Metric.isOpen_iff`、
  `Path.trans_range`、`curveIntegrable_segment`。
- ROADMAP 只登记开连通域 admissible 可达 foundation；标准一般同伦与无条件单连通原函数仍未完成。

## 下一步与诚实边界

后续不再需要证明多边形可达。唯一核心缺口是：对开单连通 `U` 和全纯 `f`，证明
`PathIntegralIndependentOn f U`。当前 C² 同伦定理可处理给定光滑相对端点同伦；标准
`IsSimplyConnected` 只给连续相对端点同伦。必须继续补同伦正则化，或用 Goursat 和网格/多边形
逼近直接证明积分无关。完成后现有推论会立即给出无条件原函数。
