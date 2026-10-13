# 项目报告与工程评估

本目录保存面向项目自身的工程报告：它们解释工作流程、工具选型和规模化方案，**不是数学 Entry**，
不进入 `index/registry.json`，也不影响任何学科的完成状态。数学事实仍以源码、编译器和 Registry 为准。

收录规则（Main 维护）：

- 报告必须来自独立 worktree／staging 分支，并在 `docs/reports/` 下自成一目录；
- 报告属于 Main 文档审稿范围，不走数学 verdict；事实或结构错误退回作者，版式与链接由 Main 直接修；
- 第三方工具或字体随附许可原文，不引入未声明许可的资产；
- 报告中的规模数字是**勘察时的现场快照**，必须绑定所读取的 Main commit，不得当作当前状态。

## 已收录

| 目录 | 内容 | 事实截止 |
|---|---|---|
| [`archify-feasibility/`](archify-feasibility/README.md) | Archify 作为项目介绍、论文依赖与协作流程可视化工具的适用性勘察，含真实小样、浏览器检查、合成规模基准与接入顺序建议 | Main `b2cd090`（2026-10-11 勘察） |
| [`project-introduction/`](project-introduction/README.md) | 项目介绍与论文形式化验证工作流报告（10 页 PDF + 可编辑 Markdown），含三张科研工作流图与渲染检查记录 | Main `b2cd090`（2026-10-10 成稿） |

两份报告都不是 Lean 交付；其中出现的 Entry 依赖关系图只是对 Registry 的只读引用。
