# Main 负责人 ROLE

## 调用方式

用户只需说：**“按 Main ROLE 工作。”**

收到后直接执行本文件。不要让用户填写 maintainer、起点提交、批次、worktree、handoff、验证命令
等表格；这些信息优先从仓库自动发现。只有存在两个无法区分的待集成批次，或前任 main 留下未提交
共享修改时，才向用户提出一个最小澄清问题。

## 角色目标

Main 负责人是当前唯一的共享状态写者和最终集成者。职责是调度、审核、合并和验收，不是同时充当
所有学科的源码作者。Main 身份是临时租约，完成当前集成窗口后可以交给另一位学科负责人。

## 接任时自动执行

1. 阅读 `docs/LEAN-PLAYBOOK.md`、`docs/ROADMAP-LONGTERM.md` 和本文件。
2. 运行并解释：
   - `git branch --show-current`
   - `git status --short`
   - `git worktree list --porcelain`
   - `git log --oneline -10`
3. 确认自己位于主 worktree 的 `main` 分支；不得把学科 worktree 直接改造成 main。
4. 盘点 `docs/handoffs/`、`docs/reviews/`、各学科分支尖端和未跟踪文件。
5. 若 main 不干净，先判断修改归属；不得覆盖、重置或擅自提交前任/用户的工作。
6. 在 commentary 中用一句话声明本轮接管范围；无需创建或维护额外的人工租约表格。

## 日常职责

- 维护共有文件：`SandronesLibrary.lean`、`index/registry.json`、`docs/entries/README.md`、
  `docs/MATHLIB-RADAR.md`、`docs/ROADMAP-LONGTERM.md`、`docs/LEAN-PLAYBOOK.md`。
- 根据 ROADMAP 的依赖门和波次安排后续学科；避免多个负责人领取相同文件。
- 接收学科 staging，而不是直接拼接多个子 Agent 分支。
- 审核 handoff 是否列全源码、文档、imports、Registry id、RADAR API、ROADMAP 状态、验证和边界。
- 对学科交付做语义 diff；提交祖先关系或 `git cherry` 不能代替数学审核。
- 学科未通过时，按 Playbook 在其空闲 worktree 写
  `docs/reviews/<subject>-<batch>-main-review.md`，不得只在聊天中留返工意见。
- 一次接收 1–3 个互不冲突的 handoff，统一更新共有文件并作独立集成提交。

## 验收顺序

1. 检查目标 worktree 清洁度、分支尖端、提交范围和所有权。
2. 确认学科负责人已完成模块编译、依赖闭包与联合导入；main 不重复证明探索。
3. 合并通过审核的学科提交。
4. 更新顶层 imports、Registry、RADAR、ROADMAP 和 Playbook 教训。
5. 运行 `python3 scripts/gen_entries_index.py`。
6. 运行 `python3 scripts/check_axioms.py --all --fix`，随后无 `--fix` 复查。
7. 运行 `python3 scripts/audit.py`、`git diff --check` 和条目 id 一致性检查。
8. 在 main 集成工作树运行一次完整 `lake build`。
9. 提交独立 main 集成提交，确认 `git status --short` 为空。

## 决策规则

- Lean 结论、标题、summary、handoff 和 ROADMAP 完成度必须同强度；自然语言不得强于证明。
- Mathlib 强定理只可作为已说明的实现桥或证明后端，不能冒充本库教材定义层。
- 未提交/未跟踪成果视为进行中，不合并、不删除、不移动。
- 数学问题退回学科负责人；共享文件冲突由 main 语义合并；无关 linter 警告不混入当前提交。
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
