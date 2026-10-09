# AGENTS.md — Sandrone's Library 协作与交付规程

> 本文件是进入仓库的 Codex/自动化开发者的执行入口。数学细节以源码和编译器为准，
> 阶段状态以 ROADMAP 为准，工作方法以 Playbook 和对应 ROLE 为准。

## 1. 仓库快照与事实源

当前 Main 快照（2026-10-09）：565 个 verified Entry、694 条直接依赖边、
73 条合规 BibTeX 出版来源、563 个正式参排条目。全库构建结论不在此保存历史 jobs 数，
以最近一次 Main 验收或现场 `lake build` 为准。

这些数字是快照，不是开工依据。每次接手必须现场检查：

```bash
git branch --show-current
git status --short
git worktree list --porcelain
git log --oneline -10
```

权威事实源：

| 事实 | 唯一或主要来源 |
|---|---|
| Lean 是否成立 | 源码 + Lean 编译器 |
| 课程进度、学科路线、阶段状态与依赖门 | `docs/ROADMAP-LONGTERM.md` §1 及对应课程节 |
| Entry 身份、前提、文献和公理 | `index/registry.json` |
| 文献元数据 | `reference.bib` |
| 证明和协作规则 | `docs/LEAN-PLAYBOOK.md` |
| 当前角色职责 | `docs/roles/*-ROLE.md` |
| 返工期间的 Main 意见 | 仓库父目录 `review-inbox/<subject>/` |
| 已闭环审核 | `docs/reviews/` |

## 2. 开工前必读与角色选择

所有角色先读 `docs/LEAN-PLAYBOOK.md`、`docs/ROADMAP-LONGTERM.md` 和本文件。
Playbook 只规定跨学科工作方法；不得在其中另建课程批次。课程状态和计划只改 LONGTERM，Examples
覆盖计划只改专项 `docs/ROADMAP-examples.md`。
然后根据任务读完整 ROLE：

- Main 审核/集成：`docs/roles/MAIN-ROLE.md`；
- 新学科或新批次开发：`docs/roles/SUBJECT-MAINTAINER-ROLE.md`；
- 已完成学科的定义调整和兼容迁移：`docs/roles/SUBJECT-MAINTENANCE-ROLE.md`；
- 计算例、正例与反例巡视：`docs/roles/EXAMPLES-MAINTAINER-ROLE.md`。
- 常驻自然语言综合书稿《水仙十字的世界式》：`docs/roles/WORLD-FORMULA-EDITOR-ROLE.md`。

用户指定角色后直接从仓库发现状态，不要让用户填 maintainer、commit、worktree、
handoff 或验证命令表格。只有两个数学语义分支无法从仓库判定时，才问一个最小问题。

## 3. Worktree、分支与文件所有权

- 一个 Codex 使用一个独立 worktree 和分支。禁止多个写者共享物理目录。
- `main` 主 worktree 只由 Main 负责人写共享状态；学科证明在 `codex/<subject>` staging 分支完成。
- 既有修改默认属于用户或其他负责人。不得用 `git reset --hard`、`git checkout --`、
  整文件 ours/theirs 或覆盖写清除它们。
- 学科负责人一般只写 `SandronesLibrary/<Subject>/`、对应 `docs/entries/`、
  `docs/handoffs/`、`docs/maintenance/` 和审核处理记录。

Main 共享文件包括：

- `SandronesLibrary.lean`；
- `index/registry.json`、`index/rankings.json`；
- `reference.bib`；
- `docs/entries/README.md`、`docs/entries/RANKINGS.md`；
- `docs/MATHLIB-RADAR.md`、`docs/ROADMAP-*.md`、`docs/LEAN-PLAYBOOK.md`；
- `docs/world-formula/` 的总目录、跨章规范和 Main-side 最终审稿记录；
- `README.md`、`AGENTS.md` 及 Main-side 审计/生成工具。

学科 handoff 只提供这些文件的更新建议，不长期维护自己的分叉版本。

## 4. 教材层与 Mathlib 复用硬门

“禁止挂靠”的准确含义是：禁止**未解释、未分类、未披露边界地**把 Mathlib 高阶接口
当作教材概念。它不禁止复用 Mathlib，更不要为了制造本库名称重造等价结构。

每个首次出现或首次成为公开前提/结论的核心概念，必须说明：

1. 教材定义、量词和对象层级；
2. Lean 正式承载；
3. 一个公开展开/等价刻画或精确 Lean 对照；
4. Mathlib 在此是正式承载、桥侧接口还是私有证明后端；
5. 至少一个真实使用该承载的上层公开定理；
6. Entry 归属和未完成边界。

公开签名中的 Mathlib 专用对象逐项分为：语义一致的正式承载、本库特殊定义的桥、
私有证明后端、或超出课程层级的公开泄漏。第一类是推荐做法；第四类需修改或由 Main 明确批准。

## 5. Lean 证明工作流

- 大定理先在 `/tmp/sandrones-library/` 建完整 `sorry` 框架，把每个 `sorry` 列为独立 todo。
- 下层接口签名先与上层组装通过类型检查，再逐个消除 `sorry`。
- 同一子证明连续试错五次仍失败时，停止盲试，再拆更小框架。
- 正式 `SandronesLibrary/` 文件不允许 `sorry`、`admit`、`sorryAx`、`native_decide`。
- 一次只编译一个最小模块/引理链，通过后再扩大到依赖闭包。
- 命名先查 Mathlib 冲突；证明意图与 tactic 映射见 Playbook，不在本文件复制所有技巧。
- 面向人类审阅者解释证明时，以 `docs/LEAN-TACTIC-REVIEW-GUIDE.md` 为共同术语表；审核报告应说明
  tactic 前后的数学目标，不只罗列 tactic 名称。

正式 Entry 最低交付：Lean 声明和 Entry docstring、可审核的教材文档、准确依赖和
Mathlib 列表、真实验证、以及不强于 Lean 陈述的 summary。

## 6. Entry、Registry、文献与派生数据

- 一个 Entry id 只对应一个 Lean 文件；源码、Markdown 和 Registry id 一致。
- `premises` 只列库内 Entry；Mathlib 名称只进 `mathlib`。
- `provenance.ref` 只存 `reference.bib` 中已定义的 citation key。
- `reference.bib` 只接受已出版书籍、已发表论文，或带 `eprinttype = {arXiv}` 与 arXiv 编号的
  论文预印本。课程讲义、网页、Mathlib 文件、证明思路、本库自建说明和无出版信息的主题描述
  都不是合规参考文献；章节定位写在 Entry 正文，不为同一本书的每一章复制 BibTeX 条目。
- `axioms` 和 `proof_sha` 由 `check_axioms.py` 根据当前 Lean 文件生成，不从冲突两边任选。
- `dependedOnBy` 是 `premises` 的反向缓存，禁止手工修改。
- `docs/entries/README.md`、`index/rankings.json` 和 `docs/entries/RANKINGS.md` 是派生文件，禁止手工解决冲突。

Main 语义合并 Registry 后按以下顺序重建：

```bash
python3 scripts/extract_registry_references.py
python3 scripts/update_dependency_graph.py
python3 scripts/gen_entries_index.py
python3 scripts/gen_entry_rankings.py
python3 scripts/check_axioms.py --all --fix
python3 scripts/check_axioms.py --all
python3 scripts/audit.py
git diff --check
lake build
```

## 7. 学科负责人交付门

学科负责人可管理 2–3 个文件所有权不重叠的子 Agent，但必须亲自验收。
子 Agent 的“完成”不是学科交付。

每批至少完成：

1. 冻结核心概念清单和公开签名四类扫描；
2. 证明“正式承载 → 展开/刻画 → 必要桥 → 上层使用者”能在聚合文件中组装；
3. 逐模块编译、学科依赖闭包构建和关键 `#check`；
4. Entry 声明映射、禁用占位、冲突标记、全局 instance 与公开泄漏扫描；
5. `git diff --check`，并确保交付成果已提交；
6. `docs/handoffs/<subject>-<batch>.md` 中如实记录范围、提交、验证、共享更新建议和未完成边界。

学科负责人不运行全库 `lake build`，不直接维护 Main 共享文件。精确八段重排、
front matter 统一、review 归档和 Registry/RADAR/ROADMAP 规范化是 Main 职责；
不得因为只有这些文档问题而退回数学成果。

## 8. Main 审核、通知与集成

Main 的验收顺序：

1. 核对 worktree 清洁度、分支尖端、基线、commit 范围和文件所有权；
2. 做语义 diff，审核数学陈述、定义链、公开接口、Mathlib 角色和诚实边界；
3. 独立复验学科模块、依赖闭包和联合导入；
4. 数学通过后合并学科提交，由 Main 补共享文档、Examples 巡视和 Git 内 review；
5. 只在共享状态完成后运行公理、audit、diff 和一次全库构建；
6. 作独立 Main 集成提交，并确保主工作区清洁。

verdict 只使用：

- `accepted`：数学和 Main 规范都已完成；
- `accepted_main_docs`：数学通过，只剩 Main 共享文档/工具整理；
- `needs_changes`：数学、定义链、公开接口、强度或验证真实性必须返工；
- `blocked`：依赖门或外部状态尚未满足。

`needs_changes` 的权威通知写到：

```text
../review-inbox/<subject>/<subject>-<batch>-main-review.md
```

返工期间以该文件为准，不以聊天摘要为准。学科负责人不删除或改写 Main 意见，
在 Git 内 review 的处理记录中逐项标记 `resolved`、`declined with reason` 或 `still blocked`。
Main 复验通过后将意见和处理结果收敛到 `docs/reviews/`。

## 9. Main 提交后的学科同步门

Main 发布集成提交后，所有学科负责人在下一批开工或返工前必须同步最新 Main。
工作区清洁且当前成果已提交时推荐：

```bash
git fetch origin
git rebase origin/main
```

若已确认本地 `main` 就是最新集成提交，可用 `git rebase main`。多人共享 staging 分支时
由分支负责人使用 `git merge origin/main`，不擅自改写公共历史。不带目标的 `git pull`
不是“已同步 Main”的证据。需要更新已推送的个人 rebase 分支时只用 `--force-with-lease`。

共享文件冲突以最新 Main 为基线；学科只保留 handoff 建议，不恢复旧 Registry、RADAR、
ROADMAP、Playbook、文献或派生文件。handoff 要记录同步 Main commit 和同步方式。

## 10. 已完成学科的维护

公开定义或高扇出接口调整不按普通新批次直接改写。先生成只读影响图与
`docs/maintenance/<subject>-<topic>.md` RFC，再定级：

- M0：私有实现/证明体变化，签名不变；
- M1：新增教材定义或桥，旧 API 保留；
- M2：等价的公开签名迁移；
- M3：数学语义变化，必须新 Entry id。

M2 分三个可回滚阶段：新定义与桥 → 按依赖层迁移下游 → 旧 API 单独退役。
下游计数非零、缺等价桥、未经跨学科验收或未有 Main 全库构建时，禁止删除旧 API。

## 11. Git、安全与报告

- 未经用户明确要求，不 push、不创建 PR、不删除 worktree。
- 不在日志、文档或聊天中暴露 token、密钥和凭据路径。
- 不把未跟踪文件、未提交工作树或子 Agent 报告当作已交付。
- 不把局部模块构建说成全库通过。
- 最终报告只陈述现场取得的分支、commit、文件范围、审核 verdict、验证结果和诚实边界。

## 12. 当前工作的发现顺序

本文件不维护容易过期的学科待办清单。每次从现场发现：

1. 读 ROADMAP 的阶段状态和依赖门；
2. 检查主分支、worktree、学科分支尖端和未提交文件；
3. 按时间检查 `review-inbox/`、`docs/handoffs/` 和 `docs/reviews/`；
4. 用 `scripts/update_dependency_graph.py` 和 `scripts/audit.py` 核对依赖与 Registry；
5. 只启动已解锁、文件所有权明确且不与正在进行窗口冲突的任务。
