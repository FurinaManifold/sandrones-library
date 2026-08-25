# T4-F2c3 积空间基本群 handoff

## 范围与基线

- 分支：`codex/topology-foundations`。
- 同步 Main `c53ada8` 的 merge commit 为 `6a74340`。
- Main 定点权限：T4-F2c3 `development_open`；要求 `prodIso` 有真实公开使用者并给出指定基点公式。
- 本批独占 `FundamentalGroupProductStandard.lean` 和对应 Entry，不进入 AT1/van Kampen。

## 概念链

| 教材概念 | Lean 正式承载 | 展开／一手性质 | Mathlib 角色 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 积空间基本群 | 指定基点的 `FundamentalGroup (X × Y) (x,y)` | `fundamentalGroupProdMulEquiv_apply` | 标准 carrier | 两方向复合恒等 | `topology.fundamental-group.product-standard` |
| 基本群胚积比较 | `FundamentalGroupoidFunctor.prodIso` | 正向 `hom.map` 展开为 `Path.Homotopic.prod` | 正式复用且在 def 中真实使用 | 群级等价 | 同上 |
| 坐标投影同态 | 两个 `FundamentalGroup.map` 的 `MonoidHom.prod` | `fundamentalGroupProdProjections_apply` | 投影连续映射为正式承载 | 逆向复合公式 | 同上 |
| 积道路与投影道路 | `prod`、`projLeft`、`projRight` | 三条 Mathlib 互逆定理 | 道路同伦商后端 | 群等价及互逆证明 | 同上 |

## 公开签名与边界

公开 Mathlib 对象 `FundamentalGroup`、`Path.Homotopic.prod/projLeft/projRight`、`MonoidHom` 和
`MulEquiv` 均是已解释或语义一致的正式承载。`FundamentalGroupoidFunctor.prodIso` 没有成为额外
高阶公开前提，但在 `fundamentalGroupProdMulEquiv` 定义体中直接提供正向 `map`，其公开 apply
定理把作用降到教材积道路类，满足真实使用门。

本批无连通性假设；只处理固定 `(x,y)` 的二元积。任意积、一般极限、基点改变自然性和 van Kampen
不在范围内。乘法证明明确遵循 F2a 的范畴复合反序。

## Main 集成建议

- 顶层加入 `SandronesLibrary.Topology.FundamentalGroupProductStandard`。
- Registry 新增 `topology.fundamental-group.product-standard`，引用 Hatcher Section 1.1。
- ROADMAP 可将 T4-F2c3 积空间计算标为完成；AT1 与 T4-R 权限不变。

## 验证

- `/tmp/sandrones-library/FundamentalGroupProductPrototype.lean` 完整接口编译通过。
- 正式模块单文件编译通过。
- `lake build SandronesLibrary.Topology.FundamentalGroupProductStandard` 依赖闭包通过，共 1786 jobs。
- `/tmp/sandrones-library/TopologyF2c3FundamentalGroupProductAudit.lean` 同时检查 `prodIso`、积/投影道路
  商、两个定义、两个作用公式和两个复合恒等式，编译通过。
- Entry 声明映射精确得到 6 条公开声明，没有跨文件吸入。
- 6 条声明的公理均为 `propext`、`Classical.choice`、`Quot.sound`。
- 禁用占位、冲突标记和 `git diff --check` 扫描通过。
- 学科负责人不运行全库构建。
