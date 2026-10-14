# Examples E0.4 —— 存量 `examples` 类理论 Entry 的影响审计

- 窗口：`codex/examples-e1`（Examples 学科，E0 存量转正 + E1）
- 基线：`bc8d4feb59f639aa440d7719466297d918e9dd28`
- 范围：`docs/ROADMAP-examples.md` E0.4「既有 `analysis.integral.examples`、Taylor examples
  归档 —— 保留原理论 Entry 或迁移为 Examples Entry 的影响审计，不破坏下游」
- 结论一句话：**两条都保留在原理论文件，不迁移**；下游影响为零（独立复核），无需任何
  下游改动，因此本轮不存在「破坏下游」的风险面。

## 1. 审计对象

| Entry id | Lean 文件 | 叙述层 | kind | premises | provenance.ref |
|---|---|---|---|---|---|
| `analysis.integral.examples` | `SandronesLibrary/RealAnalysis/RiemannIntegralBridge.lean` | `docs/entries/analysis/integral/examples.md` | `theorem` | `real-analysis.riemann.ftc`、`real-analysis.riemann.parts-substitution`、`analysis.special-functions.basic` | `ecnu-mathematical-analysis-5` |
| `analysis.mvt.taylor-examples` | `SandronesLibrary/Analysis/MVT.lean` | `docs/entries/analysis/mvt/taylor-examples.md` | `theorem` | `analysis.mvt.taylor`、`analysis.special-functions.basic` | `ecnu-mathematical-analysis-5` |

两条都是**理论文件里的计算例**：内容确实是教材计算例（Riemann 定积分公式、有限阶
Taylor 展开），但它们的 Lean 声明与理论定义（`riemannIntegral`、`taylorWithinEval`）
同文件承载，属于「理论 Entry 带例子色彩」，而不是 `SandronesLibrary/Examples/**` 下的
Examples Entry。

## 2. 下游影响：独立复核，结果为零

`dependedOnBy` 是派生缓存，审计不采信缓存本身，做了三重独立核对：

1. **由 `index/registry.json` 的 `premises` 重算反向依赖**（脚本现场计算，不看缓存）：
   两条的反向依赖均为 `[]`，与缓存 `dependedOnBy: []` 一致。
2. **全库源码 grep**：两条名下的 6 个公开声明
   （`riemannIntegral_pow`、`riemannIntegral_exp`、`riemannIntegral_cos`、
   `riemannIntegral_sin`、`riemannIntegral_const_mul_cos_affine`、`cos_taylor_second_order`）
   在 `SandronesLibrary/**` 中除定义文件外**没有任何引用点**。
3. **Examples 侧导入面**：`SandronesLibrary/Examples/**` 目前没有 import
   `RealAnalysis.RiemannIntegralBridge` 或 `Analysis.MVT`；本轮新增的 4 个 E0 Entry
   与 4 个 E1 Entry 也没有引入对它们的依赖。

结论：迁移或保留在机械意义上都不会破坏现有下游；但「不破坏下游」不等于「迁移是安全的」。

## 3. 判定：保留（不迁移），三条理由

1. **反向依赖是硬伤（决定性理由）**。AGENTS §3 与 `EXAMPLES-MAINTAINER-ROLE.md`
   规定「理论模块永远不得导入 `Examples`」。若把这两条声明搬进
   `SandronesLibrary/Examples/**`，任何**将来**想在理论层复用 `riemannIntegral_pow`
   或 `cos_taylor_second_order` 的条目都会被迫反向依赖 Examples，直接违反硬规则。
   保留在理论文件里，未来 Examples 条目（E2.6 Taylor 与渐近、E2.9 Riemann 积分、
   E3.3 坐标积分）可以把它们当作 `premises` 正常引用。
2. **迁移是跨学科 M2 操作，不在本窗所有权内**。迁移要改
   `SandronesLibrary/RealAnalysis/RiemannIntegralBridge.lean` 与
   `SandronesLibrary/Analysis/MVT.lean`（属 RealAnalysis / Analysis 学科），
   而本窗 `ownership.writable` 只有 `SandronesLibrary/Examples/**`。按 AGENTS §10，
   公开签名迁移属 M2，须先出只读影响图与 `docs/maintenance/<subject>-<topic>.md` RFC，
   再由 Main 协调；本窗不自行扩权。
3. **ROADMAP 的出口是二选一的审计，不是强制迁移**。E0.4 的出口原文是
   「保留原理论 Entry **或**迁移为 Examples Entry 的影响审计」；本审计给出「保留」这一支
   的完整论证，且已把「迁移」支的代价（跨学科、M2、需要 RFC）写明，Main 若要改判有依据。

## 4. 保留支的后续动作（交给 Main / 后续窗口）

- **不需要**任何代码改动，也不需要改 Registry。
- 后续 Examples 条目（E2.6 / E2.9 / E3.3）应把这两条登记为 `premises`，而不是重算同一批
  公式；重算会制造两份事实源。
- 若未来确要迁移，最小可回滚路径是：新 Examples 文件先复制声明并保留理论侧原声明
  （双写）→ 下游改引 Examples 版 → 理论侧单独退役；在「下游计数为零」的当前状态下，
  该路径的收益仅是归档整洁，成本是跨学科改动，故不建议在 E0 阶段执行。

## 5. 顺带发现（Main 侧规范化项，不在本窗修复范围）

- `analysis.mvt.taylor-examples` 的叙述层 front matter 用了
  `source_type: textbook`，而 `docs/SCHEMA.md` §front matter 只列
  `book | paper | generated`。全库现场统计：`book` 约 480 处、`textbook` 约 55 处，
  另有 `derived`、`migration`、`library`、`internal`、`library_bridge`、`derivation`
  等值。`subject_package.py` 只校验 `provenance.ref`，不校验 `source_type`，所以这不是
  本窗的机械门异常，但属于「front matter 统一」这一 Main 职责。本窗新增的 8 条
  Entry 全部使用 SCHEMA 允许的 `book`。

## 6. 与 E0.2 / E0.3 的关系

E0.2（坐标积分与球体矩）与 E0.3（Green/Gauss/Stokes 具体区域）走的是另一条路：
把**已经存在于 `SandronesLibrary/Examples/**`、但没有 Entry 身份**的四个文件
补上 Entry 标记、课程文档与 Registry 建议（见 handoff §2）。这与 E0.4 的「理论文件里的
例子是否搬进来」是两个不同问题：E0.4 的答案是「不搬」，E0.2/E0.3 的答案是
「本来就在 Examples 里的，补齐身份」。
