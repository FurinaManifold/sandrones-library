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

- `CoordinateIntegrals.lean`：球体体积与常密度质量的球坐标计算；
- `SphericalMoments.lean`：均匀球体的重心与转动惯量；
- `GreenRegions.lean`：三角形、圆盘等具体区域上的 Green 公式。
- `GaussStokes.lean`：单位立方体上的 Gauss 公式与水平单位正方形上的 Stokes 公式。
- `MeasureDerivative.lean`：RA-F2 测度导数具体例（Entry `examples.real-analysis.measure-derivative`）。
- `CentralLimit.lean`：一般 CLT 的正态坐标乘积空间实例（Entry `examples.probability.clt`）。
- `TopologySpaces.lean`：内部／闭包／边界的实直线计算例（Entry `examples.topology.spaces`）。

上述 `CoordinateIntegrals`／`SphericalMoments`／`GreenRegions`／`GaussStokes` 目前仍是待转正
资产：能够编译不等于已经完成 Examples Entry、课程文档与覆盖映射（见 `docs/ROADMAP-examples.md`
E0.2–E0.4）。
