# 拓扑旧接口与 Mathlib API 逐模块对照

## 用途

本矩阵是 `topology-mathlib-reuse-migration.md` 的声明级补充。判定标准不是名称相似，而是比较
载体数据、量词、端点条件、相等方式和下游用途。结论分为：

- **直接采用**：Mathlib 接口与教材语义一致，课程文档解释后直接作为正式承载；
- **迁移教材结论**：数学陈述值得保留，但正式签名改用 Mathlib；
- **冻结重复实现**：现有代码只是在平行载体上重建成熟 API，不再扩张；
- **兼容桥**：仅为旧成果迁移暂时保留。

## 基础拓扑

| 旧模块／声明组 | Mathlib 正式 API | 核对结果 | 处理 |
|---|---|---|---|
| `Foundation.TextbookTopology` | `TopologicalSpace` | 都以开集谓词、全空间、二交、任意并为字段；结构语义相同 | 冻结旧结构；直接采用 Mathlib |
| `IsClosed`、`IsNeighborhood`、`Continuous`、`Homeomorphism` | `IsClosed`、`𝓝`／`IsOpen.mem_nhds`、`Continuous`、`Homeomorph` | 教材概念一致；Mathlib 邻域采用滤子但有教材刻画 | 不再复制谓词和结构 |
| `Constructions.induced/subspace/product` | `TopologicalSpace.induced`、subtype 与 product 实例 | 同一初始／子空间／积拓扑 | 冻结重复构造 |
| `continuous_subtype_val/mk`、`continuous_fst/snd/prod_mk` | `continuous_subtype_val`、`Continuous.subtype_mk`、`continuous_fst/snd`、`Continuous.prodMk` | 类型与数学内容一致 | 直接采用 Mathlib 定理 |
| `continuous_of_closed_cover` | Mathlib 的闭覆盖粘合／分段连续 API | 教材命题一致；旧证明仅为自建连续性服务 | 不迁移同名包装；课程需要时引用成熟 API |
| `MathlibBridge`、`MathlibCompatibility` | 显式结构转换 | 这是旧链迁移所需，而非教材新概念 | 暂时作为兼容桥保留 |

## 实直线与单位区间

| 旧模块／声明组 | Mathlib 正式 API | 核对结果 | 处理 |
|---|---|---|---|
| `realLine` | `ℝ` 的标准 `TopologicalSpace` 实例 | ε-邻域生成的拓扑与标准实拓扑相同 | 冻结旧实例 |
| 本库 `UnitInterval`、`zero/one` | `unitInterval : Set ℝ` 的 subtype，端点 `0/1` | 都是闭区间 `[0,1]` subtype | 直接采用 Mathlib 单位区间 |
| `realAffine` 与连续性、`realReflection` | 实数环连续性、`continuous_const.sub continuous_id` 等 | 只是标准拓扑连续运算的重证 | 冻结技术实现 |
| `UnitInterval.reflect`、左右倍速参数 | Mathlib 单位区间反射以及 `Path` 拼接／同伦内部参数 | 只为旧道路和同伦实现服务 | 不作为独立课程进度 |
| `RealOperations.realBall/realAdd/realMul` | `Metric.ball`、`continuous_add`、`continuous_mul` | 完全成熟的标准接口 | 冻结并停止迁移包装 |

## 道路与道路连通

| 旧模块／声明组 | Mathlib 正式 API | 核对结果 | 处理 |
|---|---|---|---|
| 本库 `Path`、`refl/map/symm/trans/reparam` | `Path`、`Path.refl/map/symm/trans/reparam` | 同为单位区间上的连续映射并记录两个端点 | 直接采用 Mathlib `Path` |
| `Path.symm_symm`、`Path.symm_trans` | `Path.symm_symm`、`Path.trans_symm` | 严格道路等式相同，仅命名方向不同 | 冻结重复定理 |
| `Joined`、对称／传递／映射 | `Joined`、`Joined.refl/symm/trans/map` | `Nonempty (Path x y)`，定义及运算相同 | 直接采用 Mathlib |
| `pathComponent` 与分支相等结论 | `pathComponent`、`mem_pathComponent_iff`、`pathComponent_congr` | 集合定义和等价类性质相同 | 直接采用 Mathlib |
| 本库 subtype 版 `IsPathConnected` | `JoinedIn`、`IsPathConnected`、`isPathConnected_iff_pathConnectedSpace` | 数学语义等价；Mathlib 已显式区分环境道路与集合内道路 | 课程解释 `JoinedIn`，不复制谓词 |
| 连续像保持道路连通 | `IsPathConnected.image`、`JoinedIn.map` | 定理强度相同，Mathlib 另有 `ContinuousOn` 版本 | 冻结重复定理 |

## 同伦、同伦等价与可缩性

| 旧模块／声明组 | Mathlib 正式 API | 核对结果 | 处理 |
|---|---|---|---|
| 本库 `Homotopy` | `ContinuousMap.Homotopy` | 都是 `I × X → Y` 的联合连续映射并固定时间端面；Mathlib 把端点映射打包为 `ContinuousMap` | 直接采用 Mathlib |
| 本库 `Homotopy.refl/symm/trans/precomp/postcomp` | `ContinuousMap.Homotopy.refl/symm/trans` 及 `Homotopic.comp` | 运算与关系闭包已经成熟 | 冻结二维粘合实现 |
| 本库 `PathHomotopy` | `Path.Homotopy`／`ContinuousMap.HomotopyRel` | 都固定道路两个端点；Mathlib 的相对集合接口更一般 | 直接采用 `Path.Homotopy` |
| `PathHomotopy.concat`、`PathHomotopic.concat` | `Path.Homotopy.hcomp`、`Path.Homotopic.hcomp` | 同为两条相邻道路同伦的水平拼接 | 冻结重复实现 |
| `Homotopic`、`PathHomotopic` 等价关系 | `ContinuousMap.Homotopic`、`Path.Homotopic` 及 `refl/symm/trans/equivalence` | Prop 与等价关系语义相同 | 直接采用 Mathlib |
| `HomotopyEquivalence` 与 `refl/symm/trans/ofHomeomorphism` | `ContinuousMap.HomotopyEquiv`、`Homeomorph.toHomotopyEquiv` | 数据字段和左右同伦逆条件相同 | 直接采用 Mathlib |
| `IsContractible`、存在收缩刻画、同伦等价保持 | `ContractibleSpace`、`contractible_iff_id_nullhomotopic`、`HomotopyEquiv.contractibleSpace_iff` | 教材语义和关键刻画均已有 | 迁移文档解释；不重证平行定理 |

## 道路同伦商与基本群

| 旧模块／声明组 | Mathlib 正式 API | 核对结果 | 处理 |
|---|---|---|---|
| `loopHomotopySetoid`、`LoopHomotopyClasses` | `Path.Homotopic.setoid`、`Path.Homotopic.Quotient x x` | 都是基点环路按端点固定同伦取商 | 直接采用 Mathlib 商 |
| `classOf`、相等判据、满射 | `Path.Homotopic.Quotient.mk/eq/mk_surjective` | 商映射接口逐项对应 | 冻结重复接口 |
| 商上的映射、恒等与复合 | `Path.Homotopic.Quotient.map/map_comp`、`FundamentalGroup.map` | Mathlib 已同时给商级与群同态级接口 | 直接采用 Mathlib |
| 商上的拼接和反向 | `Path.Homotopic.Quotient.trans/symm`、`mk_trans/mk_symm` | 定义均由代表元 `Path.trans/symm` 下降 | 冻结 `concat/inverse` |
| 拼接反向的逆序公式 | `Path.trans_symm`，商上的反向与范畴逆 | 严格道路公式已存在，商与群结构自动继承 | 冻结 `inverse_concat` |
| 旧单位律草案 | `Path.Homotopy.transRefl/reflTrans` | Mathlib 已给显式端点固定重参数化同伦 | 废止，不入库 |
| 尚未开发的结合律 | `Path.Homotopy.transAssoc` | Mathlib 已给显式重参数化同伦，并用于基本群胚 `CategoryStruct.assoc` | 不开发旧版本 |
| 尚未开发的逆律 | `Path.Homotopy.reflTransSymm/reflSymmTrans` | Mathlib 已给显式收缩同伦，并用于基本群胚的 `inv_comp/comp_inv` | 不开发旧版本 |
| 最终基本群 | `FundamentalGroupoid`、`FundamentalGroup X x` | 基本群是基本群胚点 `x` 的自态射群；`one_def/mul_def/inv_def` 给出道路解释 | 直接作为课程正式承载 |

## 可保留的课程增量

现有旧链没有发现 Mathlib 缺失的基本群基础数学定理。值得保留的是教材解释和接口导航：

1. 解释 `Path.Homotopic.Quotient` 为什么正是端点固定道路同伦类；
2. 解释基本群胚的对象、态射、复合和逆，以及 `FundamentalGroup` 为什么是基点自态射群；
3. 用 `FundamentalGroup.one_def/mul_def/inv_def` 把群运算还原为常值、拼接和反向道路；
4. 解释群律不是定义性道路等式，而由 `transRefl/reflTrans/transAssoc` 等显式同伦保证；
5. 后续只开发 Mathlib 尚无、且能在其正式承载上陈述的教材定理。

这些内容应通过现有 Entry 迁移或新的 explained-reuse Entry 落地，具体 id 策略等待 Main 对
`topology-mathlib-compatibility-review-request.md` 的决定。
