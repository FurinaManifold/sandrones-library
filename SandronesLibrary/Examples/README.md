# Examples

本目录与 `Analysis`、`Topology`、`LinearAlgebra` 等理论目录平行，集中存放教材例题、
具体区域和数值计算。理论模块只提供可复用的定义与定理；例子模块调用这些接口，
但理论模块不得反向依赖本目录。

当前模块：

- `CoordinateIntegrals.lean`：球体体积与常密度质量的球坐标计算；
- `SphericalMoments.lean`：均匀球体的重心与转动惯量；
- `GreenRegions.lean`：三角形、圆盘等具体区域上的 Green 公式。
- `GaussStokes.lean`：单位立方体上的 Gauss 公式与水平单位正方形上的 Stokes 公式。
