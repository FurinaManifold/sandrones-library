# 项目介绍与论文形式化验证工作流

成稿：[10 页 PDF](project-introduction.pdf)；可编辑正文：[Markdown](project-introduction.md)。

本文依据 Main `b2cd090c9208283ccd3c2f3740bcece3e3f0d6ea`，介绍项目资产、自然语言与 Lean 的逐声明对应审核、论文范围契约、Multi-agent 分工、调度契约、Eckart–Young 候选的任务拆解，以及验收流水线。

正文将当前实现、现场发现和建议扩展分别标明。论文案例是设计示范：本次未启动其正式证明，也未读取原论文全文。实际执行了结构审计、ε–N 案例定向构建、公开接口探测及单 Entry 强制公理复验；没有重新执行 Main 全库验收或修改既有数学条目。详见 [研究证据记录](research-evidence.json) 及 [验证日志](evidence/)。

重新生成 PDF：

```bash
python3 docs/reports/project-introduction/build_report.py
```

需要 Pandoc、XeLaTeX，以及 Python 的 `cairosvg` 和 `PyMuPDF`。字体使用 Noto Serif/Sans CJK SC、Noto Sans Math、TeX Gyre Pagella/Heros 和 Latin Modern Math。模板与 [流程图 SVG](workflow.svg) 均可编辑；`workflow.pdf` 由构建脚本生成。

脚本检查 10 页、每页相应章节及可打印文字边界，并输出 [render-receipt.json](render-receipt.json)。这些是文档渲染检查，不能替代正文中的数学、语义或论文覆盖验收。
