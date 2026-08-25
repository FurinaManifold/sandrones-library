# T4-R2 边界 collar 道路同伦相对平滑化 handoff

## 范围、权限与基线

- 分支：`codex/topology-foundations`。
- 正式源码、Entry 与 handoff 主提交：`874cf44`。
- 开工基线：Main `e81ce2e`；以合并提交 `6606d8d` 同步。
- 权限：`review-inbox/topology/main-t4r-rfc-r2-development-open.md` 将 T4-R2 标为
  `development_open`；T4-R3 仍为 `research_open`。
- 学科文件：`SandronesLibrary/Topology/BoundaryCollarHomotopySmoothing.lean`、
  `docs/entries/topology/homotopy/boundary-collar-smoothing.md` 与本 handoff。
- 不修改顶层 import、Registry、RADAR、ROADMAP、Playbook、参考文献或派生索引。

## 正式接口与诚实边界

Entry `topology.homotopy.boundary-collar-smoothing` 包含七条公开声明：闭方形、四边、四边闭性、
相对闭集且保持开域像的 `C²` 逼近、由四边相等重建道路同伦、标准双重延拓正则性，以及最终
boundary-collar 推论。

最终定理完整保留 Main 要求的全部输入：全局连续延拓 `f`；`f` 与原同伦 `F` 在闭方形上一致；
延拓在四边闭集某邻域 `V` 上 `ContDiffOn ℝ 2`；`F` 的像位于开集 `U`。输出保留 `U` 中的像，
并断言道路同伦的双重 `IccExtend` 在闭方形上 `ContDiffOn ℝ 2`。它不覆盖任意连续或分段 `C¹`
边界，不解除 T4-R3，不解锁复分析的一般同伦不变性。

## 概念清单与定义链

| 概念 | 教材语义 | Lean 正式承载 | 展开／刻画或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 闭单位方形 | 两坐标均在 `[0,1]` | `closedUnitSquare` | 定义为积空间中的 `Icc (0,0) (1,1)` | 逼近保持开域像定理 | 本 Entry |
| 闭方形四边 | 至少一坐标为 0 或 1 | `closedUnitSquareBoundary` | 四个积集合显式并 | `isClosed_closedUnitSquareBoundary` | 本 Entry |
| 边界 collar | 四边闭集的某个邻域 | `V ∈ nhdsSet closedUnitSquareBoundary` | 正则性假设 `ContDiffOn ℝ 2 f V` | 最终定理 | 本 Entry |
| 相对光滑逼近 | 在闭集逐点固定的光滑近似 | Mathlib `Continuous.exists_contDiff_approx_and_eqOn` | `exists_contDiffTwo_approx_eqOn_mapsTo_open` 增加闭方形像约束 | 最终定理 | 本 Entry |
| 开域统一余量 | 紧像有厚化仍包含于开集 | Mathlib `IsCompact.exists_cthickening_subset_open` | 仅作证明步骤，不制造包装 Entry | 相对逼近定理 | 本 Entry |
| 标准道路同伦 | 保持两条时间边与两个端点 | Mathlib `Path.Homotopy` | `pathHomotopyOfEqOnSquareBoundary` 从四边等式重建 | 最终定理 | 本 Entry |
| 标准双重延拓 | 两个参数均钳位到 `[0,1]` | `Homotopy.extend` 与 `Set.IccExtend` | 闭方形上逐点等于全局 `g` | 正则性定理 | 本 Entry |

## 公开签名四类扫描

- 语义一致的正式承载：`Path.Homotopy`、`Continuous`、`ContDiff`、`ContDiffOn`、`Set`、
  `EqOn`、`MapsTo`、`nhdsSet`、`IsOpen`、`unitInterval` 与 `Set.IccExtend`；文档已逐项解释课程语义。
- 本库特殊接口：`closedUnitSquare` 与 `closedUnitSquareBoundary` 是本批教材对象；前者展开成积序的
  `Icc`，后者展开成四个积集合之并。
- 私有证明后端：`IsCompact.exists_cthickening_subset_open`、
  `Continuous.exists_contDiff_approx_and_eqOn` 与度量厚化成员定理。
- 越级公开泄漏：无。范数线性空间假设正是所用全局光滑逼近接口的环境，并在 Entry 边界披露。

## 证明结构

1. 证明四边为闭集。
2. 对连续延拓的闭方形紧像取得开域内统一厚化余量。
3. 相对四边应用 Mathlib 光滑逼近，使 `g=f` 于四边且误差小于该余量。
4. 由四边相等逐项重建 `p.Homotopy q` 的两条时间边与两个固定端点。
5. 在闭方形内部展开两次标准钳位延拓，转化为全局 `g`，继承 `C²`。

## Main 集成建议

- 顶层加入 `import SandronesLibrary.Topology.BoundaryCollarHomotopySmoothing`。
- Registry 登记 `topology.homotopy.boundary-collar-smoothing`；引用复用
  `lee-smooth-manifolds-2012`。
- RADAR 登记两个证明后端及其本 Entry 使用者；ROADMAP 只可把 R2 标为已集成，R3 和复分析相关门
  保持未开放。

## 验证

- `/tmp/sandrones-library/SmoothApproximationToPathHomotopyResearch.lean` 的完整无占位原型通过；正式
  文件由该原型迁入并保留相同最终接口。
- `lake env lean SandronesLibrary/Topology/BoundaryCollarHomotopySmoothing.lean` 通过。
- `lake build SandronesLibrary.Topology.BoundaryCollarHomotopySmoothing` 通过，共 2758 jobs。
- `/tmp/sandrones-library/TopologyT4R2BoundaryCollarAudit.lean` 同时导入并 `#check` 七条本库声明、
  `Path.Homotopy`、`Set.IccExtend`、相对光滑逼近与紧集厚化后端，并以完整最终签名组装通过。
- `scripts.check_axioms.map_entry_to_decl` 精确映射七条公开声明；逐条公理均为 `propext`、
  `Classical.choice`、`Quot.sound`。
- 正式源码和交付文档的 `sorry`、`admit`、`sorryAx`、`native_decide`、冲突标记扫描无结果；
  新增全局 instance 扫描无结果；`git diff --check` 通过。

## 未完成边界

- 不证明任意连续或分段 `C¹` 边界可以相对平滑。
- 不证明一般连续道路同伦可无条件平滑。
- 不单独建立紧集开域余量包装 Entry。
- 不恢复复分析的一般同伦不变性、无条件单连通域积分无关或原函数存在。
