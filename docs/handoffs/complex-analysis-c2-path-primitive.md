# 复分析 C2 由路径积分无关性构造原函数 handoff

## 分支、范围与门状态

- 分支：`codex/complex-analysis`；前置提交已完成一般三角形 Goursat 与 C² 同伦不变 foundation。
- 新源码：`SandronesLibrary/ComplexAnalysis/PrimitiveFromPathIntegral.lean`。
- 新文档：
  `docs/entries/complex-analysis/cauchy/primitive-from-path-independence-foundation.md`。
- 完成 id：`complex-analysis.cauchy.primitive-from-path-independence-foundation`。
- 本批完成单连通原函数路线中的分析构造层；标准 `IsSimplyConnected` 推出路径积分无关仍是拓扑
  缺口，完整 C2 门未打开。

## 本库公开定义与后端边界

- `AdmissiblePath f U gamma` 是由域内、可积的 `C¹` 道路经有限拼接生成的归纳证书；它不把任意
  连续 `Path` 误当作正则道路。
- `pathIntegral_eq_sub_of_primitive_of_admissiblePath` 对证书归纳，逐段应用微积分基本定理；
  `pathIntegralIndependentOn_of_primitive` 给出其端点无关推论。
- `PathIntegralIndependentOn f U` 表示任意同端点 admissible 道路积分相等；这是公开的教材中间
  命题，不是原函数存在性的改名。
- `exists_primitive_of_pathIntegralIndependentOn` 用基点到各点的 admissible 道路可达性和上述
  无关性构造 `g`，结论是 `∀ z ∈ U, HasDerivAt g (f z) z`。
- Mathlib 只承担凸球短线段、路径拼接、可积性和曲线积分对线段终点的导数；没有调用
  `IsExactOn` 或任何单连通原函数后端。

## 负责人开发与审核

- `/tmp/sandrones-complex-path-primitive.lean` 先冻结三个公开接口，再把唯一主要待办分成：依赖型
  道路选择、短线段 admissibility、拼接积分比较、邻域函数等式和局部导数转移。
- 负责人检查了定义没有把“存在原函数”藏入积分无关性：`PathIntegralIndependentOn` 只比较
  现有路径积分，主证明才首次构造 `g`。
- 接口复审发现单独的 `PathIntegrable` 仍不足：Mathlib 的默认 `derivWithin` 可能让病态连续道路
  通过可积性，却无法应用微积分基本定理。现已改为逐段同时携带 `ContDiffOn` 与可积性，并由
  新端点公式实际验收该设计。

## 验证

- `lake build SandronesLibrary.ComplexAnalysis.PrimitiveFromPathIntegral`：通过（2750 jobs）。
- 正式模块单文件编译通过。
- 临时聚合文件导入 `Goursat`、`HomotopyInvariance` 与本模块，并 `#check` 三个新公开 API：通过。
- 新文档 front matter、精确八段和段落非空通过；源码/文档唯一 Entry id 一致。
- `#print axioms` 将主定理实际依赖报告为 `propext`、`Classical.choice`、`Quot.sound`。
- 禁用占位扫描、`git diff --check` 与全部复分析模块联合构建通过；未运行全库构建。

## Main 共有文件更新建议

- 顶层 import 新增 `SandronesLibrary.ComplexAnalysis.PrimitiveFromPathIntegral`。
- Registry 新增 foundation id，由 Main 重算 axioms 和 proof hash。
- RADAR 登记 `HasFDerivWithinAt.curveIntegral_segment_source`、`Path.trans_range`、
  `curveIntegrable_segment`、`Metric.isOpen_iff`。
- ROADMAP 只登记“路径积分无关推出原函数”foundation；一般同伦和单连通域原函数继续未完成。

## 下一步与诚实边界

下一步已被压缩为单一拓扑—分析桥：证明标准开单连通集上，所有 admissible 同端点道路积分相等，
并提供从基点到各点的 admissible 道路。当前 C² 同伦 foundation 能处理给定光滑同伦，但标准
`Path.Homotopic` 仅连续；仍需相对端点平滑化或多边形逼近。完成该桥后即可直接调用本批主定理
得到标准单连通域原函数，再由原函数端点公式推出一般同伦不变。
