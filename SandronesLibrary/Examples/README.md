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

上述既有模块目前是待转正资产：能够编译不等于已经完成 Examples Entry、课程文档与覆盖映射。
