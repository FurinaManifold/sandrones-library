# F4.8 Krein--Milman handoff

- 分支：`codex/functional-analysis-restart`
- Main 基线：`2c67e3c`（从最新 Main 建立干净分支）
- 权限：窄幅 `development_open`
- Entry：`functional-analysis.krein-milman`

## 文件

- `SandronesLibrary/FunctionalAnalysis/KreinMilman.lean`
- `docs/entries/functional-analysis/krein-milman.md`
- 本 handoff

## 概念清单

| 概念 | 教材语义 | 正式承载 | 展开／桥 | 首个使用者 |
|---|---|---|---|---|
| face | 非空凸子集，开线段内点落入则两端落入 | `Nonempty ∧ Convex ∧ IsExtreme` | `textbookFace_iff_nonempty_convex_isExtreme` | 定义链本身 |
| 极点 | 不存在非平凡严格凸分解 | `Set.extremePoints` | `mem_extremePoints_iff_textbook` | singleton 桥与最终定理 |
| singleton face | `{x}` 的极性条件 | `IsExtreme ℝ K {x}` | `singleton_isExtreme_iff_mem_extremePoints` | 极点定义链 |
| 闭凸包 | 最小闭凸超集 | `closedConvexHull` | `closedConvexHull_eq_closure_convexHull` | Krein--Milman 组装 |
| Krein--Milman | 紧凸集由极点闭凸生成 | Mathlib 最终 theorem | `closedConvexHull_extremePoints_eq` | 课程 Entry |

## 公开签名扫描

- 正式 Mathlib 承载：`IsExtreme`、`Set.extremePoints`、`Convex`、`IsCompact`、
  `closedConvexHull`、局部凸与 Hausdorff 类型类；均在 Entry 解释。
- 桥侧接口：无本库特殊定义；四个公开 theorem 只做教材展开与必要组装。
- 私有证明后端：Mathlib `right_mem_of_mem_openSegment`、
  `closedConvexHull_eq_closure_convexHull` 与最终 Krein--Milman theorem。
- 越级泄漏：无。

## 数学边界

本批修正研究稿中的过强说法：Mathlib `IsExtreme` 不含非空与凸性，只有与教材 face 的极性部分
一致。没有平行造定义，没有重证 Mathlib 最终 theorem，也不进入 Choquet、有限维凸组合上界或
具体实例。

## Main 集成建议

- 增加顶层 `KreinMilman` import；
- 登记 Entry 并把 ROADMAP F4.8 标记完成；
- Registry、ROADMAP、RADAR 与生成索引均由 Main 修改。
