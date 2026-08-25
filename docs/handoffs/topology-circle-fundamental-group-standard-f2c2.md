# T4-F2c2 圆周基本群与整数绕数 handoff

## 范围与基线

- 分支：`codex/topology-foundations`。
- 开工前以 merge commit `5b365a7` 同步 Main `aacbd3d`；F2c 为 `development_open`。
- 本批独占 `CircleFundamentalGroupStandard.lean` 及对应 Entry，只计算基点 `1` 的圆周基本群。
- 本批沿 Hatcher 1.1 的圆周覆盖/提升路线推进；不新增一般覆盖空间课程，不进入 van Kampen。

## 概念链

| 教材概念 | Lean 正式承载 | 展开／一手性质 | Mathlib 角色 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 圆周与指数覆盖 | `Circle`、`Circle.exp` | `circleLoopLift_exp` | 正式承载；覆盖性由 Mathlib 证明 | 从零提升 | `topology.fundamental-group.circle-standard` |
| deck 变换整数标签 | `zmultiples (2 * π) ≃+ ℤ` | `circleDeckIntEquiv_symm_apply_coe` | 本库显式构造桥，不调用最终基本群等价 | 绕数同态 | 同上 |
| 从零出发的环路提升 | `circleLoopLift g` | `circleLoopLift_zero`、`circleLoopLift_exp` | `liftPath` 是解释后的证明后端 | 提升终点刻画 | 同上 |
| 绕数同态 | `circleWindingHom` | `circleWindingHom_eq_iff_lift_endpoint` | monodromy 是私有构造后端 | 单射、满射 | 同上 |
| 圆周基本群计算 | `circleFundamentalGroupEquivInt` | 由公开绕数同态双射打包 | 不调用通用 `fundamentalGroupEquiv` | F2c 最终结论 | 同上 |

## 公开签名与数学边界

公开 Mathlib 对象 `Circle`、`Path`、`FundamentalGroup`、`ContinuousMap`、`AddSubgroup.zmultiples`、
`Multiplicative ℤ` 都是语义一致的正式承载。`IsCoveringMap.liftPath` 和商覆盖 monodromy 出现在定义体
与证明体，属于已解释的覆盖提升后端；没有把通用覆盖空间最终群等价暴露成课程结论。

最终 `circleFundamentalGroupEquivInt` 明确由 `circleWindingHom_injective` 和
`circleWindingHom_surjective` 构造。单射的数学输入是覆盖空间 `ℝ` 单连通，满射的输入是 `ℝ`
道路连通；终点充要条件把抽象 monodromy 与教材整数绕数连接起来。本批只固定基点 `1` 和初始提升点
`0`，不声称一般基点版本，也不把一般覆盖空间理论、van Kampen 或任意空间计算标为完成。

## Main 集成建议

- 顶层加入 `SandronesLibrary.Topology.CircleFundamentalGroupStandard`。
- Registry 新增 `topology.fundamental-group.circle-standard`，引用
  `hatcher-algebraic-topology-2002` Section 1.1。
- ROADMAP 可将 T4-F2c 的圆周重点结果标为完成；一般覆盖空间与 van Kampen 保持 AT 后续。
- 本批可独立于尚待 Main 回复的 F2b2 集成；直接前提均已在 Main 或 F2c1 学科提交中冻结。

## 验证与诚实记录

- `/tmp/sandrones-library/CircleFundamentalGroupPrototype.lean` 已在正式落盘前验证完整接口链。
- `lake env lean SandronesLibrary/Topology/CircleFundamentalGroupStandard.lean` 已通过。
- `lake build SandronesLibrary.Topology.CircleFundamentalGroupStandard` 依赖闭包通过，共 2191 jobs。
- `/tmp/sandrones-library/TopologyF2c2CircleFundamentalGroupAudit.lean` 同时检查指数覆盖、提升、deck
  整数桥、绕数终点刻画、单射、满射和最终等价，编译通过。
- `scripts.check_axioms.map_entry_to_decl` 将本 Entry 精确映射到 10 条公开声明；没有跨文件吸入。
- 10 条声明的公理均为 `propext`、`Classical.choice`、`Quot.sound`。
- 正式源码禁用占位、交付文件冲突标记与 `git diff --check` 扫描均通过。
- 学科负责人未运行全库 `lake build`。
