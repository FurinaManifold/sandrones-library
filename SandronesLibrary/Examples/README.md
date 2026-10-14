# Examples

本目录是独立的 Examples 学科，与 `Analysis`、`Topology`、`LinearAlgebra` 等理论目录平行，
集中存放教材计算例、具体对象和反例。理论模块只提供可复用的定义与定理；例子模块调用这些接口，
但理论模块不得反向依赖本目录。

Examples 负责人持续巡视各学科的重要教材知识点。每个重要知识点至少应有一个 Lean 验证的正例；
有标准计算范式时给出完整计算，存在容易误信的逆命题或不可省略的假设时补反例。具体覆盖合同、
状态和批次见：

- `docs/roles/EXAMPLES-MAINTAINER-ROLE.md`；
- `docs/ROADMAP-examples.md`。

当前模块：

分析方向（E0.2／E0.3 存量转正，2026-10-14 起已有 Entry 与课程文档）：

- `CoordinateIntegrals.lean`：球体体积与常密度质量的球坐标计算
  （Entry `examples.analysis.coordinate-integrals`）；
- `SphericalMoments.lean`：均匀球体的重心与转动惯量，含 `I = (2/5)MR²`
  （Entry `examples.analysis.spherical-moments`）；
- `GreenRegions.lean`：直角三角形与单位圆盘上的 Green 公式，含边界定向反例
  （Entry `examples.analysis.green-regions`）；
- `GaussStokes.lean`：单位立方体上的 Gauss 公式与水平单位正方形上的 Stokes 公式，
  含法向／切向量次序定向反例（Entry `examples.analysis.gauss-stokes`）。

集合论方向（E1，2026-10-14）：

- `SetTheory/SetOperations.lean`：有限集上的并、交、差、补与 De Morgan 逐元素计算，
  含 `A ∪ B = A ∪ C` 推不出 `B = C` 的反例（Entry `examples.settheory.set-operations`）；
- `SetTheory/Functions.lean`：像／原像与单射／满射／双射的具体计算，含像不保持交、
  单射不必满射、满射不必单射三组反例（Entry `examples.settheory.functions`）；
- `SetTheory/Quotients.lean`：模 5 同余类与商映射，含「不同代表元给同一商元素」的辨析
  （Entry `examples.settheory.quotients`）；
- `SetTheory/Countability.lean`：`ℕ×ℕ` 配对、整数枚举、两个可数集之并，含「无限不必不可数」
  与幂集严格更大的有限原型（Entry `examples.settheory.countability`）；
- `SetTheory/CardinalArithmetic.lean`：有限基数加乘幂与可数／有限运算，含「基数相等不等于
  集合相等」与无限基数无消去律两个反例（Entry `examples.settheory.cardinal-arithmetic`）；
- `SetTheory/Ordinals.lean`：`0,1,2,ω,ω+1` 的序关系与后继／极限辨析
  （Entry `examples.settheory.ordinals`）；
- `SetTheory/OrdinalArithmetic.lean`：有限序数与 `ω` 的加乘幂、Cantor 正规形小例、
  消去律四向实测（Entry `examples.settheory.ordinal-arithmetic`）。

其他方向：

- `MeasureDerivative.lean`：RA-F2 测度导数具体例（Entry `examples.real-analysis.measure-derivative`）。
- `CentralLimit.lean`：一般 CLT 的正态坐标乘积空间实例（Entry `examples.probability.clt`）。
- `TopologySpaces.lean`：内部／闭包／边界的实直线计算例（Entry `examples.topology.spaces`）。

E0.2／E0.3 的存量转正已完成（四个分析方向模块已有 Entry 标记、课程文档与定向反例）；
E0.4 的「既有理论 Entry 是否迁移」审计结论为**保留不迁移**，见
`docs/maintenance/examples-e0-impact-audit.md`。覆盖状态与后续批次见
`docs/ROADMAP-examples.md`。
