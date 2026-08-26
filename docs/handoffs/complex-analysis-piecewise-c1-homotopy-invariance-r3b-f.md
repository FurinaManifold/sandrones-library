# Complex analysis handoff：T4-R3b-F continuous relative-homotopy invariance

## Scope and automatic gate

- branch: `codex/topology-foundations`；
- Main baseline: `346bf00`，同步合并提交 `55cc854`；
- direct dependencies: A commit `8379713`、B commit `43e06dc`、E commit `435c24f`；C/D 经 E 消费；
- permission: `main-961f4a6-permissions-expanded.md` 规定 A+B+E handoff 后 F 自动
  `integration_open`；三份 handoff 与 ready notices 已完成；
- namespace: `SandronesLibrary.ComplexAnalysis`；
- Entry: `complex-analysis.path-integral.piecewise-c1-homotopy-invariance`。

本批新增最终模块、一篇 Entry 与本 handoff，不修改共有文件。

## Final mathematical API

公开面为两项：

1. `pathIntegral_eq_of_piecewiseC1_homotopyWithin`：开集 `U` 上全纯的 `f`，沿同端点 PiecewiseC1
   道路 `gamma/delta`，若存在全像位于 `U` 的标准连续 `Path.Homotopy`，则两道路积分相等；
2. `pathIntegral_eq_zero_of_piecewiseC1_nullHomotopyWithin`：取目标为常道路的零同伦直接推论。

主定理不要求同伦方形全局或分片 C2；只要求边界道路 PiecewiseC1。零同伦结果是推论，不取代主接口。

## Concept inventory and public signature

| 概念 | 教材语义 | Lean 正式承载 | 展开／桥 | Mathlib 角色 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 连续端点相对同伦 | 连续道路族且端点固定 | Mathlib `Path.Homotopy` | shared `pathHomotopySquare` | 正式承载 | main theorem | 本 Entry |
| 同伦全像控制 | 方形每一点落入 U | `∀ z, pathHomotopySquare F z ∈ U` | 显式量词 | `Set` membership | local balls | 本 Entry |
| 分段 C1 边界 | 两条可积分边界道路 | `Path.PiecewiseC1` | A common depth | 本库 verified 谓词 | dyadic leaves | 本 Entry |
| 全纯被积函数 | 开集上复可微 | `HolomorphicOnTextbook` | bridge to `DifferentiableOn` | 课程正式入口 | local primitives | 本 Entry |
| 局部 primitive balls | 每个小格所在球上 exact | `Complex.IsExactOn` | Mathlib `isExactOn_ball` | 私有证明数据 | E cancellation | premise E |
| 道路积分相等 | 源／目标整道路积分一致 | `pathIntegral` equality | C outer-boundary assembly | 正式承载 | null corollary | 本 Entry |

公开签名只有 `IsOpen`、`HolomorphicOnTextbook`、`Path.PiecewiseC1`、`Path.Homotopy`、方形全像量词和
`pathIntegral`；没有 grid indices、cover labels、choice、primitive function、C2、carrier 或 instance
泄漏。所有公开概念均在本 Entry 或 premises 具有教材解释与真实消费者。

## Proof dependency chain

1. A 从两条边界证书取得共同 dyadic depth；
2. B 在同伦像的 indexed open-ball cover 下取得至少该深度的方格；
3. shared foundation 组装 D 的 raw grid；
4. holomorphic bridge 与 Mathlib ball primitive 给出逐格 exactness；
5. E 产生 raw outer-boundary integral zero；
6. C 识别上下零贡献、左右 dyadic leaf sums并恢复整道路积分；
7. 常道路实例给出 null-homotopy corollary。

该链不导入旧 `HomotopyInvariance` 最终包，也不经过 van Kampen cell-boundary/theorem 模块。

## Verification contract

已验证：

- `lake build SandronesLibrary.ComplexAnalysis.PiecewiseC1HomotopyInvariance`：2837 jobs，通过，包含正式
  A--F 依赖闭包；
- `R3bSquareAggregate.lean` 同时检查 A--F 核心 carrier、双向桥、真实消费者、最终 theorem 与 null
  corollary；最终两项公理均为 `[propext, Classical.choice, Quot.sound]`；
- `R3bSemanticConsumers.lean` 实际证明深度继续加细、任意 minimum depth recovery、零格解析消去、
  holomorphic local ball primitive、反身连续同伦实例以及外边界方向，全部通过；
- mapper 严格得到 13 / 10 / 1 / 2 / 2 / 1 / 2，共 31 项互不重复公开声明；
- 最终模块的 SandronesLibrary 递归源码闭包为 19 nodes，不含旧 `HomotopyInvariance`、`Goursat`、
  `CauchyTheorem`，也不含 `VanKampenHomotopySquareBoundary`、`VanKampenSquareSubdivision` 或
  `VanKampenTheorem`；
- placeholder、新 axiom、instance、notation、全名碰撞、冲突标记与 `git diff --check` 扫描通过。

## Honest boundary

结论限于复平面、开集上的 `HolomorphicOnTextbook`、PiecewiseC1 边界和全像受控的标准连续相对同伦。
不处理一般不可整或仅 rectifiable 曲线，不产生全局 primitive，不证明 many-parameter smooth homotopy
理论，也不恢复已否决的 relative-`C²` 签名。旧 C2 定理仍可独立存在，本批没有退役它。
