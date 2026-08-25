# Main review: complex-analysis C2-C3 next window

- branch: `codex/complex-analysis`
- baseline integrated in main: `c715c9b`
- verdict: `next_work_required`
- reviewed_at: 2026-08-25

## 已接收

C1 六条、C2 路径积分/Cauchy 公式与估计/Liouville、C3 Taylor，以及六个明确降级的
foundation/special-case 已进入 main。Main 全库构建、公理审计与 Registry 审计通过。

## 下一批优先级

1. 先补一般局部三角形 Goursat，不得用圆盘原函数版本冒充。
2. 再补单连通开集上的原函数存在与一般同伦不变。
3. 在上述依赖门完成后，推进一般 Laurent 存在唯一性与系数公式。
4. 随后依次处理奇点 Laurent 分类、有限多极点残数定理、绕数、一般辐角原理与 Rouché。

## 验收边界

- foundation id 不得改名占用 ROADMAP 的完整课程 id。
- `real_integral_inv_one_add_sq` 的 Mathlib 后端不能算作残数法的一般实积分路线完成。
- 新交付继续要求精确八段文档、Entry/文件一一对应、聚合导入和关键 API `#check`。

## 学科负责人处理记录

- 优先级 1：`resolved`。新增 `Goursat.lean`，证明任意开集内闭三角形的
  `complex-analysis.cauchy.triangle`；公开假设是三点实凸包包含于该开集，不再要求圆盘。
- foundation 边界：`resolved`。原 `complex-analysis.cauchy.triangle-ball` 的源码、文档和 id
  原样保留；完整课程 id 只用于新的局部三角形定理。
- 文档与组装门：`resolved`。新文档具有 front matter 和精确八段；模块单独构建及临时聚合
  `#check` 结果记录在 `docs/handoffs/complex-analysis-c2-goursat.md`。
- 后续边界：单连通开集原函数、一般同伦不变及 Laurent 主线仍未在本提交中宣称完成。

## 优先级 2 阶段性处理

- `resolved foundation`：新增 `HomotopyInvariance.lean`，不假设原函数，直接证明全纯路径积分在
  `C²` 相对端点同伦下不变，并证明光滑零同伦闭路积分为零。
- `boundary retained`：该结果使用独立 id
  `complex-analysis.cauchy.smooth-homotopy-foundation`，没有占用一般
  `complex-analysis.cauchy.homotopy`。标准 `IsSimplyConnected` 只提供连续道路同伦，而当前
  Mathlib 没有保持开域与端点的同伦平滑化桥；一般同伦和单连通域原函数仍记为未完成。
- `external audit`：Mathlib 的 `HasPrimitives.lean` 仍明确把单连通域原函数列为 TODO；官方
  Riemann mapping PR `#33505` 截至 2026-08-25 仍为 open，包含 974 行新增和三文件变更，未作为
  本库依赖或复制来源。
