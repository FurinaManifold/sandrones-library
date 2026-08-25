# Main review: Topology T4-H2 standard and relative homotopies

- reviewed_commits: `76ac49f`, `a346143`
- verdict: `accepted`
- reviewed_at: 2026-08-25

一般同伦与相对同伦的第一坐标均为时间；相对版本对全部时间和 `S` 中全部点要求固定，而不只要求
端点映射相等。`Homotopy.comp` 是同步映射复合，后复合保持同一个相对集合。本窗直接复用 Mathlib
承载且不触碰旧 `TextbookTopology.Homotopy`。Main 现场独立编译零输出通过，无占位或自设公理。
提交以 `3edf839`、`b4ab365` 接收，纯英文模块说明及共享登记已由 Main 整理；全库构建 8923 jobs 通过。
