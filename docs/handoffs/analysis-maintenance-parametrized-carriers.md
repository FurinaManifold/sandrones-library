# Analysis maintenance handoff：参数曲线与曲面载体归属

- 基线：Main `9572873`
- 影响等级：M0；仅补载体职责、源码 Entry 挂靠和审计说明。
- Entry：`analysis.multivariable.parametrized-curves-surfaces`

## 概念清单

| 概念 | 本库教材入口 | 底层数据 | 性质谓词 | 真实使用者 |
|---|---|---|---|---|
| 参数曲线 | `ParametrizedCurve n` | `ℝ → (Fin n → ℝ)` | `CurveRegularAt`、`CurveRegularOn` | 速度、速率、弧长和换参数定理 |
| 参数曲面 | `ParametrizedSurface n` | `(ℝ × ℝ) → (Fin n → ℝ)` | `SurfaceRegularAt`、`SurfaceRegularOn` | 坐标切向量、面积元和换参数定理 |

两个透明别名只固定课程中的参数域和值域，不暗含连续、可微或正则。函数是普通数据载体，没必要
重建结构；几何性质由本库谓词单独表达。`deriv`／`fderiv` 只作为速度和切向量的选择后端，
不可微点的默认零值不能替代正则性假设。

## 公开签名分类

- 普通函数、`ℝ`、`Fin n → ℝ`：课程通用数据载体。
- `DifferentiableAt`、`deriv`、`fderiv`：既有公开计算接口和证明后端；本维护窗不迁移旧接口。
- `LinearIndependent`：仿射平面正则性的具名教材判据一侧。
- 无新增第 4 类公开例外。

## Main-side 集成门

- 文档 front matter 当前为 `status: in-progress`，ROADMAP 却标为完成，Registry 又缺少该 id。
  本窗已补源码 Entry 标记；Main 应先裁定条目状态，再登记唯一
  `lean_file = Analysis/ParametrizedGeometry.lean` 并运行公理审计。

## 验证

- 模块定向构建与十项定义链聚合 `#check` 通过。
- Entry 映射从前置标记识别 48 个声明；待 Main 登记 Registry 后运行公理审计。
- 禁用占位扫描与 `git diff --check` 通过。
