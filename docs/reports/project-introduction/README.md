# 项目介绍与论文形式化验证工作流

成稿：[10 页 PDF](project-introduction.pdf)；可编辑正文：[Markdown](project-introduction.md)。

本文面向数学研究者与项目审阅者，介绍 DESIGN 的知识组织理念、Playbook 的证明拆解方法、ROADMAP 的课程与论文路线，以及 Tactic 指南的人类审阅方法。重点回答同名著名定理的接口约定、自然语言与 Lean 的对应验证、论文形式化，以及数百 Agent 的分层发展架构。

技术细节移至 [复现与审计附件](reproduction.md)，现场记录保存于 [research-evidence.json](research-evidence.json)。事实截止于 Main `b2cd090c9208283ccd3c2f3740bcece3e3f0d6ea`。

正文将当前实现、现场发现和建议扩展分别标明。论文案例是设计示范：本次未启动其正式证明，也未读取原论文全文。实际执行了结构审计、ε–N 案例定向构建、公开接口探测及单 Entry 强制公理复验；没有重新执行 Main 全库验收或修改既有数学条目。详见 [研究证据记录](research-evidence.json) 及 [验证日志](evidence/)。

重新生成 PDF：

```bash
python3 docs/reports/project-introduction/build_report.py
```

需要 Pandoc、XeLaTeX，以及 Python 的 `cairosvg` 和 `PyMuPDF`。字体使用 Noto Serif/Sans CJK SC、Noto Sans Math、TeX Gyre Pagella/Heros 和 Latin Modern Math。

三张科研工作流图均提供可编辑 SVG、矢量 PDF 和从 PDF 渲染的 PNG 截图：

| 图 | SVG | PDF | PNG 截图 |
|:---|:---|:---|:---|
| 名称到具体接口 | [SVG](theorem-contract.svg) | [PDF](theorem-contract.pdf) | [PNG](theorem-contract.png) |
| 论文语义、证明、覆盖闭环 | [SVG](workflow.svg) | [PDF](workflow.pdf) | [PNG](workflow.png) |
| 数百 Agent 的分层架构 | [SVG](scale-architecture.svg) | [PDF](scale-architecture.pdf) | [PNG](scale-architecture.png) |

布局和文字修改 [draw_figures.py](draw_figures.py) 后重新构建；SVG、PDF、截图和 [图清单](figure-manifest.json) 会一并更新。正文和版式模板也可编辑。

脚本检查 10 页、每页相应章节、可打印文字边界、图中文字边界及嵌入后字号不小于 8pt，并输出 [render-receipt.json](render-receipt.json)。这些是文档渲染检查，不能替代数学、语义或论文覆盖验收。SVG 不得独立修改后跳过生成器，否则下次构建会覆盖；应修改生成器作为图源。
