# Main review：F4.8 Krein--Milman 定义链

- reviewed commit: `366ae44`
- integrated commit: `af847be`
- verdict: `accepted`
- reviewed at: 2026-08-26

## 验收结论

本批没有复制 face 或极点 carrier，而是明确指出 Mathlib `IsExtreme` 只承载开线段的极性条件，教材
完整 face 还必须加非空与凸性。五个公开定理依次给出完整 face 展开、极点线段判据、singleton
极性桥、Krein--Milman 闭凸包等式和极点存在性。

按既定 F4.8 权限，最终定理直接复用 Mathlib 成熟 API，不重放 Zorn 与几何 Hahn--Banach 证明链。
Main 目标构建通过（2261 jobs、零 warning）。唯一文档计数措辞由 Main 直接修正为 5 public / 0
private，不构成学科返工；本批接收。
