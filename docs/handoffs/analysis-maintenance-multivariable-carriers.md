# Analysis maintenance handoff：多元分析透明载体归属

- 基线：Main `f8b1f3a`
- 影响等级：M0 文档归属；`TotalDerivative` 的教材谓词签名作定义等价的透明别名挂靠。

## 逐项结论

| 名称 | 归属 | 底层实现 | 性质谓词／条件 | 真实使用者 |
|---|---|---|---|---|
| `TotalDerivative` | 全微分线性主部的数据载体 | `ContinuousLinearMap` | `HasFrechetDerivativeAtTextbook` | 教材 Fréchet 定义、唯一性和方向导数桥 |
| `DifferentialForm` | 点态连续交替映射场的数据载体 | `ContinuousAlternatingMap` | `DifferentiableAt`、`ContDiff` | 取值、拉回、外微分和楔积 |
| `RiemannBox` | 轴平行盒端点的数据载体 | `BoxIntegral.Box` | `HasRiemannBoxIntegral`、`RiemannIntegrableOnBox` | 盒积分、连续可积和体积校准 |

三者均不另建重复结构：下游证明需要 Mathlib 底层已有的连续线性、交替映射、盒分割和体积 API。
透明载体只提供课程记号，不能替代“确为导数”“具有正则性”“可积”等本库教材性质。

## 公开签名分类

- `ContinuousLinearMap`、`ContinuousAlternatingMap`、`BoxIntegral.Box`：已验收本库别名的底层数据承载。
- `HasFDerivAt`、Mathlib `DifferentiableAt`／`ContDiff`、盒积分接口：具名桥或历史证明后端；本窗不迁移旧接口。
- 无新增第 4 类公开例外。

## Main-side 集成门

- `analysis.multivariable.riemann-box` 已存在于课程文档和 ROADMAP，但当前 Main Registry 缺少该 id。
  本窗已在 `RiemannBox` 前补源码 Entry 标记；Main 集成时须登记唯一
  `lean_file = Analysis/MultivariableRiemann.lean` 后运行公理审计。

## 验证

- 三个对应模块构建通过；三组载体定义链聚合 `#check` 通过。
- Fréchet、微分形式条目 audit 通过；Riemann-box 因 Registry 缺项留作上述 Main-side 集成门。
- Entry 映射分别识别 14、62、8 个声明；已登记的两个 Entry 公理审计一致。
- 禁用占位扫描与 `git diff --check` 通过。
