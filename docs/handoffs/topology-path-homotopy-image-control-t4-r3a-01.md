# Topology handoff：T4-R3a-01 道路同伦像集控制

## 范围、基线与权限

- 分支：`codex/topology-foundations`。
- 同步 Main：`cbd4bc5`，merge `d5d0c59`。
- 权限：`main-679dc3f-infrastructure-and-r3a-open.md` 的 `T4-R3a development_open`。
- 本提交只迁移线性拆分的第一模块 `PathHomotopyImageControl`；不包含网格球细分、折线路径或最终
  approximation 定理。

## 文件与登记建议

- 源码：`SandronesLibrary/Topology/PathHomotopyImageControl.lean`。
- Entry：`topology.homotopy.path-homotopy-image-control`，拟唯一 `lean_file` 为上述源码。
- Main 顶层 import：新增该模块；Registry/RADAR/ROADMAP/生成索引由 Main 集成。
- 来源建议：Hatcher 道路同伦与拼接语义；具体 affine/concat 承载来自固定 Mathlib。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接消费者 |
|---|---|---|
| `Path.affineHomotopy` | 同端点道路的逐点仿射同伦 | `affineHomotopy_apply`、两个 maps-to 定理、R3a-02 |
| `Path.affineHomotopy_apply` | 仿射同伦逐点展开为 `Path.segment` | 教材计算规则及 R3a-02 局部直线化 |
| `Path.affineHomotopy_mapsTo_convex` | 凸集内仿射同伦像集控制 | `affineHomotopy_mapsTo_ball` |
| `Path.affineHomotopy_mapsTo_ball` | 公共球内仿射同伦控制 | R3a-02 `meshStraighteningHomotopyWithMapsTo` |
| `Path.Homotopy.hcomp_mapsTo` | 水平复合保持像集界 | 两个有限 concat 认证构造 |
| `Path.Homotopy.trans_mapsTo` | 竖直复合保持像集界 | `subpathTransSubpath_mapsTo`、R3a-02 最终复合 |
| `Path.Homotopy.reparam_mapsTo` | 重参数化不离开原道路像 | `transRefl_mapsTo` |
| `Path.Homotopy.transRefl_mapsTo` | 删除末尾常值道路时保持像集界 | `subpathTransSubpath_mapsTo` |
| `Path.Homotopy.subpathTransSubpathRefl_mapsTo` | 两相邻子道路结合时保持像集界 | `subpathTransSubpath_mapsTo` |
| `Path.Homotopy.subpathTransSubpath_mapsTo` | 公开子道路结合同伦保持像集界 | `concatSubpathWithMapsTo` |
| `Path.Homotopy.refl_mapsTo` | 常值同伦保持道路像集界 | 两个有限 concat 认证构造 |
| `Path.Homotopy.concatSubpathWithMapsTo` | 原道路有限子段 concat 到整体子道路的认证同伦 | R3a-02 子道路 concat 同伦 |
| `Path.Homotopy.concatWithMapsTo` | 局部认证同伦的有限水平拼接 | R3a-02 逐段仿射直线化 |
| `Path.concat_range_subset` | 有限道路 concat 的值域包含定理 | R3a-02 折线路径值域 |

## 概念清单与公开签名分类

| 概念 | 教材语义 | Lean 正式承载／展开 | 复用或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|
| 端点相对道路同伦 | 端点固定的连续方形 | Mathlib `Path.Homotopy` | 语义一致，直接复用，不自建结构 | `affineHomotopy` | 既有 `path-homotopy-standard` |
| 仿射道路同伦 | 同一参数点间作直线插值 | 本库 `Path.affineHomotopy`；`affineHomotopy_apply` 展开 | Mathlib 有 affine continuous-map 后端，但无该 Path 包装 | convex maps-to | 本 Entry |
| 同伦像集证书 | 方形每一点属于 `S` | `∀ t s, F (t,s) ∈ S` 与带证书 subtype | 本库补充组合层，不重造同伦 | concat APIs | 本 Entry |
| 有限依赖道路拼接 | 端点逐项匹配的有限 concat | Mathlib `Path.concat` | 语义一致，新增 range 与认证同伦性质 | R3a-02 | 本 Entry |

公开签名中 `Path.Homotopy`、`Path.concat`、`Convex`、`Metric.ball` 都是语义一致的正式承载；课程
文档解释其角色和结构假设。`ContinuousMap.Homotopy.affine`、cast 与 `Fin.dfoldl` 细节只作证明
后端。没有新实例、别名同伦结构或越级接口。

## 证明审核与诚实边界

复合 maps-to 定理展开真实求值式后仅按参数半区分支；有限构造对段数归纳，`cast_apply` 只处理
依赖端点等式，不替代像集证明；有限 range 定理由 `Path.trans_range` 和并集包含归纳得到。
本批没有要求同伦光滑，没有证明线积分不变，也没有声称任意集合中的两道路可由仿射同伦连接。

## 验证

- 单模块构建 `PathHomotopyImageControl`：1866 jobs 通过。
- formal aggregate 同时 `#check` Mathlib 正式承载、十四项公开 API 和完整有限组合链，通过后删除。
- `/tmp` 的 R3a-02 `PathPolygonalApproximation.lean` 直接 import 正式第一模块并完整编译通过，证明
  仿射、有限认证同伦及 range 接口具有真实上层消费者。
- `affineHomotopy_mapsTo_ball`、两个有限认证构造及 `concat_range_subset` 的公理集合均只有
  `propext`、`Classical.choice`、`Quot.sound`。
- Entry mapper 精确映射十四项公开声明；禁用项、唯一声明和 `git diff --check` 通过。
