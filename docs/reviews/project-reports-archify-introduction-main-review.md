# Archify 与项目介绍报告 Main 收录裁决

- 学科 worktree／分支：`sandrones-library-archify`／`codex/archify-feasibility`；
  `sandrones-library-introduction`／`codex/project-introduction`
- 学科提交：`e8b8475`；`537153f`、`4dfb2e5`、`b99d2de`
- 已接入 main：`a46ad2b`；`32b587e`、`b6a113f`、`c7bd772`
- Main 集成提交：本批共享状态提交
- Verdict：`accepted`（Main 文档审稿；两份报告均非数学 Entry）

## 裁决

两者都是面向项目自身的工程报告，不是教材或论文交付，因此不适用数学 verdict，也不建 Registry
条目、不改任何学科的完成状态。审稿只核对事实来源、边界声明、许可与可复现性：

- `docs/reports/archify-feasibility/`：Archify 作为项目介绍、论文依赖与协作流程可视化工具的
  适用性勘察。小样确实读取 Main Registry 的真实依赖与论文分支的 staging 提案，并把论文条目
  明确标为“待集成”；合成规模基准如实标注“单次工程探查、不能推定真实全库交互容量”，
  未把 10 000 节点超时的失败结果粉饰成通过。随附 Archify 的 MIT 许可与嵌入字体的 OFL 原文，
  第三方资产许可合规。
- `docs/reports/project-introduction/`：项目介绍与论文形式化工作流报告，含 10 页 PDF、可编辑
  Markdown、三张工作流图（SVG／PDF／PNG）与渲染检查回执。报告自述“渲染检查不能替代数学、
  语义或论文覆盖验收”，并在 `research-evidence.json` 中如实登记两处
  `file_fingerprint_mismatches`（`linear-algebra.vector-space.dimension`、
  `real-analysis.riemann.cont-integrable`），与 `check_axioms.py` 现场输出的两条 `SKIP` 一致。

## 边界与后续

- 两份报告的事实截止均为 Main `b2cd090`；数字是勘察快照，Main 已在
  `docs/reports/README.md` 写明“不得当作当前状态”。
- 报告中的绝对路径属于复现记录，不是凭据；未发现 token、密钥或凭据路径。
- 报告提出的检索层、调度层与 CI 分层集成方案只是规划建议，不构成对 ROADMAP 的承诺；
  是否立项仍由 ROADMAP 与对应 ROLE 决定。
- 两份报告不引入 Lean 依赖，不改变任何 Entry 的 `premises`／`dependedOnBy`。

## Main 规范化

新建 `docs/reports/README.md` 收录规则与索引，并在根 `README.md` 的目录结构与核心文档表中
登记该目录；三份分支的所有权扫描确认未触碰任何 Main 共享文件。
