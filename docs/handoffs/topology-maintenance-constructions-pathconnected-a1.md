# 拓扑构造与道路连通 A1 第二波 handoff

## 批次与同步

- 分支：`codex/topology-foundations`。
- 开始前按 Main 通知以 `git merge main` 同步 `a1d019e`，合并提交为 `849e7d2`。
- 同步冲突采用 Main 的中文说明；同时恢复 Main 集成时意外遗漏、但 rereview 声称保留的 6 条
  legacy 闭集声明，使 `topology.foundation.structure` 仍保持已验收的 21 条映射。
- 范围严格限于 A1 第二波：诱导／子空间／积拓扑与道路连通的连续依赖链；A2/A3 未启动。

## 概念链与正式承载

| 教材概念 | Mathlib 正式承载 | 展开／一手性质 | legacy compatibility | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 映射诱导拓扑 | `TopologicalSpace.induced` | `isOpen_induced_iff_exists` | `toMathlib_induced` | subtype 规范拓扑 | `topology.foundation.constructions` |
| 子空间拓扑 | subtype 规范实例 | `continuous_subtype_iff` | `toMathlib_subspace` | 集合内道路 | 同上 |
| 积拓扑 | product 规范实例 | `isOpen_prod_iff_rectangles` | `toMathlib_product` | `continuous_prod_mk_iff` | 同上 |
| 积映射连续 | `continuous_fst/snd`、`Continuous.prodMk` | `continuous_prod_mk_iff` | 旧 `continuous_fst/snd/prod_mk` 冻结 | 后续参数空间 | 同上 |
| 两点道路连接 | `Joined`、`Path` | `joined_iff_nonempty_path` | 旧 `Joined` 冻结 | 道路分支 | `topology.connectedness.path-components-foundation` |
| 集合内道路连接 | `JoinedIn` | `isPathConnected_iff_nonempty_joinedIn` | 旧 subtype 定义冻结 | `IsPathConnected` | 同上 |
| 道路连通连续像 | `IsPathConnected.image` | `isPathConnected_image` | 旧像定理冻结 | 后续拓扑不变量 | 同上 |

## 公开签名与迁移边界

新公开签名只使用 `TopologicalSpace`、根 `IsOpen`／`Continuous`、subtype/product、`Path`、
`Joined`、`JoinedIn` 与 `IsPathConnected`，均属正式 Mathlib 承载。`TextbookTopology` 只出现在原有
冻结声明和三个显式结构等式桥中。没有新增 notation、全局 instance 或从 Mathlib 绕回 legacy 的
课程使用者。

旧 `continuous_of_closed_cover` 不迁移为同名包装；需要粘合定理时应核对 Mathlib 的成熟接口。
旧道路、同伦和基本群链没有扩张或删除。

## Entry 与文档

- `topology.foundation.constructions` 原地迁移，映射 16 条声明：前 4 条正式接口，后 12 条 legacy。
- `topology.connectedness.path-components-foundation` 原地迁移，映射 19 条声明：前 3 条正式接口，
  后 16 条 legacy。
- `topology.foundation.mathlib-compatibility` 增至 15 条迁移声明。
- 两篇课程文档均保持原 Entry id 并改写为 explained Mathlib reuse，精确八段；不建立第二套
  `*-mathlib-carrier` Entry。

## 验证与剩余门

- `/tmp` 分别验证 7 条正式接口和 3 条构造兼容等式后才写入正式模块。
- 完整旧拓扑闭包至 `PathReparameterization`，连同 `PathConnected` 与 `MathlibCompatibility` 联合
  构建通过，1418 jobs。
- 聚合文件同时检查 7 条正式接口、3 条构造兼容等式以及 Mathlib 的 `pathComponent`／连续像上层
  使用者；10 条结果的 `#print axioms` 均为 `propext`、`Classical.choice`、`Quot.sound`，来自
  Mathlib 拓扑结构、连续性与道路承载，不是新增数学假设。
- Entry 映射、精确八段、禁用占位与冲突标记扫描、`git diff --check` 均通过。旧 API 计数为 19 个
  拓扑文件、238 次 `TextbookTopology` 词法出现；新增 4 次均位于显式兼容桥，跨学科使用者仍为 0。
- Registry 仍保存第一版 verified 叙述与声明指纹，学科分支不直接修改；Main 集成时需按原 Entry id
  更新为 explained Mathlib reuse 并重建公理字段。
- 下一门只在 Main clean rereview 后决定；A2/A3 同伦和基本群迁移仍锁定。
