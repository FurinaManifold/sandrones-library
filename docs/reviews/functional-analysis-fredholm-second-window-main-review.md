# Main review：F5.6 Fredholm 备择第二窗

- reviewed commits: `516140d`、`4a275f7`
- verdict: `accepted`
- reviewed at: 2026-08-26

余核有限维沿闭值域零化子与 Schauder 对偶紧性建立；指数零通过幂核/幂值域稳定、Fitting 分解及
指数复合可加性完成。公开接口保留 `E ⧸ range`、`FiniteDimensional` 与 `LinearMap.index` 的正式
承载，没有另造 cokernel/index，也没有调用 Mathlib 最终 Fredholm alternative。

Main 构建 `FredholmIndex` 并复验同一 Entry 的全部公开声明公理边界。未跟踪的最终备择草稿不属于
本批，也没有被 Main 读取或集成。

后续权限：最终单射／满射备择自动转 `development_open`；F5.7 和 F6.1/F6.2 的既定并行权限保持。
