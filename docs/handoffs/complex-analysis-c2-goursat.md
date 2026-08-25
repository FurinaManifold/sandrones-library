# 复分析 C2 一般局部三角形 Goursat handoff

## 分支、范围与依赖门

- 分支：`codex/complex-analysis`。
- 基线：Main 已在 `c715c9b` 接收 C1、C2 foundations/Cauchy 公式和 C3 foundations。
- 本批新增源码：`SandronesLibrary/ComplexAnalysis/Goursat.lean`。
- 本批新增文档：`docs/entries/complex-analysis/cauchy/triangle.md`。
- 本批完成 `complex-analysis.cauchy.triangle`，落实 Main 意见箱的第一优先级；它为下一批
  单连通域原函数与一般同伦不变提供局部三角形接口，但尚未独自打开完整 C2 依赖门。

## 公开定义、定理与 Mathlib 后端

- 闭三角形使用教材可读的 `convexHull ℝ ({a, b, c} : Set ℂ)` 表示；没有引入新的打包结构。
- 公开主定理 `pathIntegral_triangle_eq_zero_of_holomorphicOnTextbook` 只使用本库
  `HolomorphicOnTextbook` 与 `pathIntegral`，要求三角形包含在任意开集 `U` 内，不要求 `U`
  是球或凸集。
- `Convex.exists_forall_hasDerivWithinAt` 是证明后端：它在闭凸三角形上构造相对原函数。
  新辅助定理 `pathIntegral_segment_eq_sub_of_primitiveWithin_convex` 负责把相对导数转成路径积分
  端点公式；Mathlib 没有直接提供本条三角形路径积分结论。

## 负责人设计与审核记录

- 先在 `/tmp/sandrones-complex-goursat.lean` 建完整框架，只留下相对原函数端点公式一个
  `sorry`；上层三边组装已先通过类型检查。
- 消除该待办时发现普通 `HasDerivAt` 会错误强化闭三角形边界假设，因此最终接口保留
  `HasDerivWithinAt`。对参数区间内部使用 `Ioo_mem_nhds`，证明附近 `lineMap` 仍落在凸集，
  再使用链式法则和区间微积分基本定理。
- 正式模块无 `sorry`、`admit`、`sorryAx` 或 `native_decide`；圆盘 foundation 文件和 id
  未改名、未删除。

## 验证

- `lake build SandronesLibrary.ComplexAnalysis.Goursat`：通过（2748 jobs）。
- `lake env lean SandronesLibrary/ComplexAnalysis/Goursat.lean`：通过。
- 临时聚合文件导入 `CauchyTheorem` 与 `Goursat`，并 `#check` 相对端点公式、圆盘 foundation
  和一般三角形主定理：通过。
- 新文档 front matter、八个一级标题的精确顺序、唯一性和各段非空：自动检查通过。
- 新源码与新文档的唯一 Entry id 均为 `complex-analysis.cauchy.triangle`。
- 提交范围 `git diff --check` 和禁用占位扫描通过；学科负责人未运行全库 `lake build`。

## Main 共有文件更新建议

- 顶层新增 `import SandronesLibrary.ComplexAnalysis.Goursat`。
- Registry 新增 `complex-analysis.cauchy.triangle`，指向本模块和
  `cauchy/goursat-triangle.md`；由 Main 重算 `axioms` 与 `proof_sha`。
- RADAR 登记 `Convex.exists_forall_hasDerivWithinAt`、`convex_convexHull`、
  `HasDerivWithinAt.comp_hasDerivAt` 与 `Ioo_mem_nhds` 的后端角色。
- ROADMAP 把一般三角形 Cauchy 条目标为完成；保留 `triangle-ball` foundation，不把一般同伦
  不变或单连通域原函数标为完成。
- 本批没有需要修改 Playbook 的全新 tactic 规律；“教材概念先自建、Mathlib 只作后端”的现有
  规则已覆盖本设计。

## 下一批稳定 API 与诚实边界

后续可以依赖一般开集内的三角形边界积分为零及凸集相对原函数端点公式。仍未完成：一般
`Path.reparam`、单连通开集上的原函数存在、一般同伦不变、一般 Laurent 存在唯一性和系数公式、
奇点 Laurent 分类、有限多极点残数定理、绕数、一般辐角原理与 Rouché。圆盘实积分例题也不代表
一般残数法实积分路线完成。
