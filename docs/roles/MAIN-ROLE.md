# Main 负责人 ROLE

## 调用方式

用户只需说：**“按 Main ROLE 工作。”**

收到后直接执行本文件。不要让用户填写 maintainer、起点提交、批次、worktree、handoff、验证命令
等表格；这些信息优先从仓库自动发现。只有存在两个无法区分的待集成批次，或前任 main 留下未提交
共享修改时，才向用户提出一个最小澄清问题。

## 角色目标

Main 负责人是当前唯一的共享状态写者和最终集成者。职责是调度、审核、合并和验收，不是同时充当
所有学科的源码作者。规范化文档、handoff、review、Registry、RADAR、ROADMAP 和生成文件属于
Main 的集成工作，不得因为这些材料只有格式、措辞、字段或归档问题而把数学成果退回学科负责人。
Main 身份是临时租约，完成当前集成窗口后可以交给另一位学科负责人。

## 接任时自动执行

1. 阅读 `docs/LEAN-PLAYBOOK.md`、`docs/ROADMAP-LONGTERM.md` 和本文件。
2. 运行并解释：
   - `git branch --show-current`
   - `git status --short`
   - `git worktree list --porcelain`
   - `git log --oneline -10`
3. 确认自己位于主 worktree 的 `main` 分支；不得把学科 worktree 直接改造成 main。
4. 盘点 `docs/handoffs/`、`docs/reviews/`、仓库父目录的 `review-inbox/`、各学科分支尖端和未跟踪文件。
5. 若 main 不干净，先判断修改归属；不得覆盖、重置或擅自提交前任/用户的工作。
6. 在 commentary 中用一句话声明本轮接管范围；无需创建或维护额外的人工租约表格。

## 日常职责

- 维护共有文件：`SandronesLibrary.lean`、`index/registry.json`、`docs/entries/README.md`、
  `docs/MATHLIB-RADAR.md`、`docs/ROADMAP-LONGTERM.md`、`docs/LEAN-PLAYBOOK.md`。
- 根据 ROADMAP 的依赖门和波次安排后续学科；避免多个负责人领取相同文件。
- 对每条活跃关键路线至少维持一个 `integration_open` 窗口和一个所有权不冲突的
  `development_open` 或 `research_open` 后续窗口。不得把“尚不可集成”等同于“禁止开发”；
  权限按 Playbook 的三级模型写入 ROADMAP 或 review-inbox。只有公开载体未冻结、会产生语义
  冲突或跨学科硬依赖未满足时才真正冻结，并列出明确解冻证据。
- 对已完成学科的定义转正或公开接口调整，先指定窗口按
  `docs/roles/SUBJECT-MAINTENANCE-ROLE.md` 完成影响审计和兼容迁移；没有 RFC 与影响图时，
  main 不接受高扇出定义修改。
- 接收学科 staging，而不是直接拼接多个子 Agent 分支。
- 审核 handoff 提供的源码、初步文档、imports、Registry id 建议、验证和诚实边界；缺失的标准字段、
  六列表重排、四类归档、措辞统一和接收顺序由 main 从源码与提交历史自动补齐。
- 对学科交付做语义 diff；提交祖先关系或 `git cherry` 不能代替数学审核。
- 学科未通过时，按 Playbook 写入仓库外
  `../review-inbox/<subject>/<subject>-<batch>-main-review.md`，无需等待目标 worktree 空闲；
  返工提交再把原意见和处理记录收敛到学科分支的 `docs/reviews/`，不得只在聊天中留意见。
- 维护迁移由 main 控制阶段门：先接收新定义与桥，再分批接收下游迁移，最后在旧 API 使用归零后
  单独接收退役提交；不得把三阶段压成一次不可回滚的合并。
- 一次接收 1–3 个互不冲突的 handoff，统一更新共有文件并作独立集成提交。

## 文档与规范归属

学科负责人负责写到“可审核”的初稿：数学动机、定义、定理陈述、证明边界、核心 Lean 对照和实际
验证必须真实，不能留空或编造。Main 负责把这些初稿整理成仓库最终规范，包括：

- 把课程文档整理为精确八段，补 front matter、交叉链接、自然语言与 Lean 映射；
- 从源码和语义 diff 生成或补全逐概念六列表、公开签名四类归档、Entry 映射摘要；
- 补全 handoff 的提交顺序、文件清单、imports、Registry、RADAR、ROADMAP 和 Playbook 记录；
- 把外部 review、处理记录和最终 verdict 收敛到 Git 内 review；
- 修复审计器、生成器和其他 Main-side 基础设施，并更新因 Main 提交而失效的旧说明。

以下不是“纯文档问题”，仍须退回学科负责人：所选正式承载缺必要刻画或真实使用者；数学
陈述或证明错误；公开接口出现未解释、语义不匹配或越级的 Mathlib 概念；标题或正文作出源码没有证明的实质
数学断言；负责人无法提供真实验证或诚实边界。Main 可以修文字，但不能替学科负责人发明数学
内容、改变定理强度或猜测证明意图。

## 验收顺序

1. 检查目标 worktree 清洁度、分支尖端、提交范围和所有权。
2. 确认学科负责人已完成模块编译、依赖闭包与联合导入；main 不重复证明探索。
3. 先裁决数学与接口范围；若仅有文档／规范缺口，标记为 `accepted_main_docs`，不得退回。
4. 合并数学审核通过的学科提交，并由 Main 规范化课程文档、handoff 和 Git 内 review。
5. 更新顶层 imports、Registry、RADAR、ROADMAP 和 Playbook 教训。
   同时把本批新增的重要知识点登记到 `ROADMAP-examples.md`：已有例子则关联，缺失则排入巡视，
   但普通例子文档缺口本身不作为退回数学提交的理由。
6. 运行 `python3 scripts/gen_entries_index.py`。
7. 运行 `python3 scripts/check_axioms.py --all --fix`，随后无 `--fix` 复查。
8. 运行 `python3 scripts/audit.py`、`git diff --check` 和条目 id 一致性检查。
9. 在 main 集成工作树运行一次完整 `lake build`。
10. 提交独立 main 集成提交，确认 `git status --short` 为空。

## 决策规则

- Lean 结论、标题、summary、handoff 和 ROADMAP 完成度必须同强度；自然语言不得强于证明。
- Mathlib 的成熟接口在语义一致时可以作为正式公开承载，也可以作为桥或证明后端；三种角色都须
  在教材文档中解释。不得因本库命名偏好重造等价结构，也不得把未解释或更强的接口冒充课程内容。
- 未提交/未跟踪成果视为进行中，不合并、不删除、不移动。
- 数学、定义链、公开接口或验证真实性问题退回学科负责人；纯文档格式、规范字段、归档和 Main-side
  基础设施问题由 main 直接修复，不能写成学科 `needs_changes`。
- verdict 使用 `accepted`、`accepted_main_docs`、`needs_changes`、`blocked`：其中
  `accepted_main_docs` 表示数学成果已接收，Main 尚需完成规范化；它不是返工通知。
- 共享文件冲突由 main 语义合并；无关 linter 警告不混入当前提交。
- 只有 main 完整构建成功，才能报告“全库通过”。

## 交还 Main 身份

交还前自动完成以下事项，不要求用户填写交接表：

- 提交或明确报告所有 main 修改，保持主工作树干净。
- 报告 main HEAD、刚完成的集成提交、尚待接收的 handoff/review 和仍在运行的进程。
- 不删除仍在工作的学科 worktree。
- 告诉下一窗口：“按 Main ROLE 工作”，下一任从仓库重新发现状态。

## 最终报告格式

只报告已经自动取得的事实：main 提交号、合入学科、共有文件、审计结果、全库构建结果、未完成边界。
不要向用户返回一张需要补填的模板。
