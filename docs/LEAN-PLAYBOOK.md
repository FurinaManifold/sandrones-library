# Sandrone's Library — Lean Tactic Playbook（自我驯化手册）

> ## ⚠️ 最核心方法论（每次写大定理前先读这条）
>
> **带 sorry 框架法**：写大定理时**先立"带 sorry 框架"**——把完整定理写出来，内部所有
> 前置引理/子证明用 `sorry` 占位；然后**每个 sorry 单独列成 todo**，逐个解决后填回框架
> （替换 sorry）才算完成。组装不是终点，而是"填最后一个 sorry"；组装 = 填元件，不是新证明。
> 若中途冒出框架外的新引理 ⟹ 停下补框架，新引理也列成独立 todo。禁止带 sorry 提交。
>
> **临时文件隔离**：带 `sorry` 的框架、辅助引理和最小复现**只能写在 `/tmp`**（建议
> `/tmp/sandrones-library/`）；正式库中的 `.lean` 文件不得出现 `sorry`。只有在临时文件中
> 已经完成证明、单独编译通过，并完成必要的公理/审计检查后，才允许把无 `sorry` 的版本写入
> `SandronesLibrary/`，同时完成 registry、叙述层和 RADAR 更新。
>
> **带 sorry 工作流的三步验收协议**：
> 1. 先列出完整的带 `sorry` 框架，在临时文件中运行
>    `lake env lean <临时文件>`；框架阶段只能有 `sorry` 警告，不得有其他错误。
> 2. 把框架中的每一个 `sorry` 单独列为待办事项，分别拎出并证明；完成后整合回框架，
>    再运行 `lake env lean <临时文件>`，直到该项不再报错，才算这一项完成。
> 3. 某个单独待办连续试错超过 5 次仍未解决时，停止继续盲试；针对**这个单独的
>    `sorry`**重新建立更小的带 `sorry` 子框架，再按第 1–2 步推进。
>
> **辅助引理必须先进入框架**：解决某个 `sorry` 时，如果需要辅助引理，必须先在
> 该 `sorry` 对应的临时子框架中列出完整签名，并把主 `sorry` 改为调用这些引理的
> 组装版本；然后逐个消除辅助引理并重新编译整合后的框架。禁止先在框架外凭空写
> 辅助引理，最后才在组装阶段反复试错。
>
> **下层接口先组装验收**：每次把一个 `sorry` 拆成下层 `sorry` 后，必须立即让上层
> `sorry` 改为调用这些下层接口并运行 Lean；只有组装类型检查通过，才允许开始证明
> 下层接口。这样可以避免错误的下层命题在未验证的情况下继续扩散。

> ## ⚠️ 多 Codex 协作模式（开始修改前必须确认）
>
> 本库可能同时由多个 Codex 维护。每个 Codex 通常负责不同学科，但顶层导入、Registry、
> ROADMAP、RADAR、Playbook 和自动生成目录是共有状态。**看到一个干净或陌生的工作区，
> 不代表没有其他 Codex 正在另一个 worktree/分支工作。**开始任务前必须检查当前分支、
> worktree 和工作区状态，不得覆盖、回退或改写其他维护者的成果。
>
> **1. 一个 Codex = 一个独立 worktree + 一个独立分支**
>
> - 禁止多个 Codex 同时在同一个物理目录中工作；Lean 构建缓存和未提交文件都会互相污染。
> - 分支按学科或任务命名，例如 `codex/analysis`、`codex/algebra`、`codex/topology`。
> - 开始修改前运行 `git branch --show-current`、`git status --short`、`git worktree list`；
>   未经用户授权，不得切换、删除或重置其他 Codex 的分支/worktree。
>
> **2. 学科文件分区所有权**
>
> - 各 Codex 原则上只直接维护自己学科的 `SandronesLibrary/<Subject>/` 和
>   `docs/entries/<subject>/`。
> - 发现其他学科的问题可以记录，但不能顺手大范围修改；确有编译依赖时只做最小兼容改动，
>   并在交付中明确列出跨学科修改。
> - 工作区中的既有修改默认属于用户或其他 Codex。禁止用 `git checkout --`、
>   `git reset --hard`、覆盖写文件等方式清除它们。
>
> **3. 共有文件实行单写者/集成者制度**
>
> 以下文件容易产生文本无冲突但语义丢失的问题，最终应由一个指定的集成 Codex 统一修改：
>
> - `SandronesLibrary.lean`
> - `index/registry.json`
> - `reference.bib`
> - `docs/entries/README.md`
> - `docs/MATHLIB-RADAR.md`
> - `docs/ROADMAP-LONGTERM.md`
> - `docs/LEAN-PLAYBOOK.md`
>
> 学科 Codex若不是本轮集成者，应提交学科源码和条目文档，并把所需的顶层 import、Registry
> 条目、ROADMAP 状态、RADAR API、Playbook 教训列成交接清单；不要让多个分支各自长期维护
> 一份共有文件。若用户明确要求当前 Codex完成登记并提交，则当前 Codex暂时承担该批次的
> 集成职责，但提交前仍必须先同步并核对其他分支的共有文件变化。
>
> **参考文献单一来源规则**：`index/registry.json` 的 `provenance.ref` 只写
> `reference.bib` 中的 citation key，不在 Registry 重复书名、论文名或资料说明。
> `reference.bib` 只收录已出版书籍、已发表论文，或带 arXiv 编号的论文预印本；课程讲义、网页、
> Mathlib 文件、本库 RFC/自建证明、例题描述和无出版信息的主题名不得登记为来源。同一出版物
> 只保留一个 citation key，章节与定理编号留在 Entry 教材正文。`extract_registry_references.py`
> 只验证已有 key，不再把自由文本自动生成为 `@misc`。
> 学科负责人在 handoff 中提交建议引用及精确章节；Main 负责分配 key、去重、
> 补全 BibTeX 字段并运行 `audit.py` 验证所有 key 均有定义。
>
> **4. 自动生成文件只能在合并后重生成**
>
> - `docs/entries/README.md` 不手工解决冲突；合并全部条目后运行生成脚本重建。
> - `index/rankings.json` 与 `docs/entries/RANKINGS.md` 不手工编辑；先运行
>   `scripts/update_dependency_graph.py`，再运行 `scripts/gen_entry_rankings.py` 重建。
> - Registry 中的 `proof_sha`、`axioms` 不从冲突两边任选一个；源码合并后重新运行
>   `check_axioms.py --all --fix`。
> - 即使 Git 没报告冲突，也要检查重复 id、丢失 import、ROADMAP 状态回退和 RADAR 条目覆盖。
>
> **5. 学科提交与集成提交分离**
>
> 推荐顺序：学科 Codex提交源码与本学科叙述层 → 集成者合并各学科分支 → 统一更新共有文件
> → 按 AGENTS §6 重建引用、依赖图、索引和排名 → 全库 `lake build`
> → `check_axioms.py --all --fix` → `check_axioms.py --all` → `audit.py` → `git diff --check`
> → 集成提交。新模块必须先生成 `.olean` 再运行公理探针；`release_gate.py` 在审计后另作最终
> build 确认。禁止多个 Codex直接向 `main` 并发提交共有文件。
>
> **Main 集成提交后的基线同步是下一批开工门。** Main 宣布集成提交完成后，各学科负责人必须
> 在开始下一批开发或返工前，将自己的 staging 分支同步到最新 `main`。推荐在工作区干净且当前
> 成果已经提交后执行：
>
> ```bash
> git fetch origin
> git rebase origin/main
> ```
>
> 若本地 `main` 已确认指向刚发布的 Main 提交，也可执行 `git rebase main`。多人共享同一 staging
> 分支时不得擅自改写公共历史，应由分支负责人统一执行 `git merge origin/main`。不带目标的
> `git pull` 只更新当前分支的上游，未必包含 `main`，因此不能作为“已同步 Main”的验收证据。
> rebase 后若需更新已经推送的个人 staging 分支，只能使用 `git push --force-with-lease`，禁止
> 使用普通 `--force`。
>
> 同步冲突先由学科负责人处理：本学科源码和课程文档做语义合并；`SandronesLibrary.lean`、
> Registry、`reference.bib`、生成索引、RADAR、ROADMAP 和 Playbook 等 Main 共有文件以最新 Main 版本为基线，
> 学科分支只保留 handoff 中的修改建议，不得恢复旧共有状态。同步完成后至少重跑本批目标模块
> 和临时聚合 `#check`。负责人在下一次 handoff 中记录所同步的 Main 提交号和采用的同步方式；
> Main 接收时必须核对该基线。若负责人基于旧 Main 继续开发，应先要求同步后再审，避免把可预防
> 的冲突和旧版共有文件清理转移给 Main。
>
> **6. 冲突处理原则**
>
> - 遇到自己学科文件的真实逻辑冲突，由该学科负责人解决。
> - 遇到共有文件冲突，不采用 `ours`/`theirs` 整体覆盖；先保留双方语义，再由生成器和审计器
>   重建派生字段。
> - 无法确认某段修改归属时停止写入，报告当前分支、文件、冲突双方意图，等待集成者裁决。
> - 每次最终交付必须说明：当前分支、提交号、修改范围、共有文件是否已更新、全库审计结果。

> **7. 学科负责人、子 Agent 与 main 的三级验收**
>
> - 子 Agent 的提交不是 main 的直接输入。子 Agent 先向所属学科负责人交付；学科负责人必须
>   审核数学陈述、定义依赖、公开签名、`sorry`、编译和叙述层，并把通过审核的成果收敛到一个
>   明确的学科分支或集成提交。main 不从多个互相重叠的子分支“拼答案”。
> - 学科负责人移交时必须提供 `docs/handoffs/<subject>-<batch>.md`，至少列出：源码与条目文件、
>   顶层 import、Registry id、ROADMAP 状态、RADAR API、Playbook 教训、已运行的验证命令，以及
>   明确未完成或仍在进行的边界。若共有文件由 main 维护，handoff 只写变更清单，不直接修改。
>   这是一份可审核初稿，不是要求学科负责人承担最终出版编辑。缺字段、六列表重排、四类归档、
>   八段格式、review 收口和共有文件同步由 main 在集成时完成；不得仅因此退回数学成果。
> - main 接收前必须检查 `git status --short`、`git worktree list`、分支尖端和提交差异。其他
>   worktree 中未跟踪或未提交文件一律视为正在进行的工作，不纳入、不删除、不移动，也不替该
>   Agent 擅自提交。
> - `git cherry`/祖先关系只能判断补丁身份，不能判断数学内容是否已经接收。若 main 先前集成过
>   早期简版，而学科分支后来完成定义转正或详细叙述，必须对学科文件做语义 diff；确认新版
>   完整取代旧版后再接收，不能因为“文件已存在”而跳过。
> - main 的验收顺序固定为：接收已审核的学科提交 → 按 handoff 更新共有文件 → 重生成目录
>   → 全库 build → 公理字段生成与复查 → audit 和 diff 检查 → 独立集成提交。
>   未通过学科负责人审核的分支只记录状态，
>   不提前进入 main。
> - **构建职责分层**：子 Agent 编译自己修改的模块；学科负责人编译全部本学科模块及其依赖闭包，
>   再用一个临时聚合文件同时导入本批全部模块并 `#check` 关键公开 API。学科负责人不重复运行
>   全库 `lake build`，也不把它作为学科移交的阻塞条件。main 完成 imports、Registry、ROADMAP、
>   RADAR 和生成文件集成后，只在最终集成阶段统一运行一次全库 `lake build`。这样减少多个
>   worktree 对同一 Mathlib 依赖树的重复构建，同时保留“局部闭包、跨模块组装、全库集成”三层门禁。
> - 若学科负责人为了诊断主动启动了全库构建，可以在局部闭包和聚合测试均已通过后终止；
>   已生成的 Lake 缓存可以保留。最终交付必须如实写明该全库构建未完成，不能把部分进度报告成
>   全库通过；最终的全库通过结论只能由 main 集成工作树上的完整命令给出。

> **8. 教材解释层是跨 Agent 的共同质量门**
>
> - “禁止挂靠 Mathlib”是指禁止**没有教材解释、语义核对和边界披露地静默挂靠**，不是禁止
>   复用 Mathlib。若成熟接口与教材概念语义一致，应优先把它作为正式公开承载；不得仅为拥有
>   一个本库名字而复制同构的结构、谓词、运算或连续性理论。
> - 新概念首次出现时，课程文档必须解释教材定义、Lean 中采用的正式承载、类型与 typeclass
>   假设、记号、关键展开／刻画，以及与教材表述的差异。源码应给出足以让读者操作该概念的
>   一手刻画或基本性质；这项要求不等于必须再写一个包装 `def`。
> - 只有 Mathlib 接口与课程语义不一致、量词边界不同、现有 API 缺失，或课程有意采用更弱／
>   更精确的定义时，才建立本库 `def`／`structure`，并提供方向与边界清楚的桥。
> - handoff 必须声明哪些 Mathlib 名称是语义一致的正式公开承载，哪些是本库定义的桥侧，哪些
>   只是私有证明后端。main 在 Registry/RADAR 中必须保留这种角色区别。
>
> **解释层不是“文档中提过一个名字”，而是可验收的语义链。** 学科负责人按
> `docs/roles/SUBJECT-MAINTAINER-ROLE.md` 建立概念清单，并同时交付：教材语义、Lean 正式承载、
> 展开／刻画或一手性质、复用／桥接关系、至少一个真实上层使用者和源码 Entry。若语义一致而
> 直接采用 Mathlib，课程文档必须把接口讲成人话；若语义不一致而自建，则桥必须明确差异。
>
> **公开签名逐项扫描。** 新增或修改的每个公开声明类型中，Mathlib 专用 structure、class、Prop、
> notation 和课程性运算都必须归类为：语义一致且已完成教材解释的正式公开承载、本库定义的
> 具名桥一侧、未泄漏的私有后端，或语义不明／越级泄漏。第 1 类是推荐复用，不是例外；第 4 类
> 默认拒收。“Mathlib 已有”不能替代解释，“本库必须自建”也不能替代语义判断。
>
> **机器可见的验收证据。** 聚合测试必须 `#check` 正式承载、展开／一手性质、必要的桥和上层
> 使用者；还要检查 Entry 声明映射，确保自建核心 `def`／`structure` 没有漏审、桥没有错挂相邻
> Entry、一个 Registry id 只对应一个 Lean 文件。审计器暂不支持某种声明命令时，必须记录为
> Main-side 门，不能用后续定理已通过公理审计来代替核心定义审计。
>
> **直接拒收情形**：课程文档没有解释核心概念；Lean 主定理暴露语义未核对、未分类或越级的
> Mathlib 概念；自建定义没有真实必要性或无人使用；桥没有方向或语义边界；同一 Entry 横跨多个
> Lean 文件；自建核心定义未进入公理审计；通过全局实例自动选择结构而 handoff 未披露。语义匹配
> 且解释充分的 Mathlib 正式承载不得仅因“不是本库定义”被拒收。
>
> 上述拒收针对源码中的数学与接口事实，不针对证据排版。若定义链、公开签名和验证事实可以从
> 已提交源码确定，而问题只是 handoff 没排成精确六列表、课程初稿未整理为八段、review 未收口、
> Registry/RADAR/ROADMAP 未同步或 Main 审计器尚未支持，Main 必须接收为 `accepted_main_docs`
> 并自行修复。只有必须新增或修改 Lean 定义、性质、桥、上层使用者、定理强度或证明时，才退回
> 学科负责人。

> **9. Main 负责人通知返工流程**
>
> 聊天窗口中的返工说明不是权威记录。main 判定一个学科批次暂不接收时，必须把即时通知写入
> **所有 Git worktree 之外**的共享 review inbox。默认位置是仓库父目录下：
>
> ```text
> ../review-inbox/<subject>/<subject>-<batch>-main-review.md
> ```
>
> 例如主仓库位于 `/workspace/sandrones-library` 时，ST2/ST3 通知写入
> `/workspace/review-inbox/settheory/settheory-st2-st3-main-review.md`。该目录不入库，Main 可在
> 学科负责人仍工作的同时写入，不接触目标 worktree 的 index、未跟踪文件或构建缓存。一次 review
> 只覆盖一个明确批次；同一批次继续在固定文件末尾追加 `Round 2`、`Round 3`。
>
> **通知与入库闭环分离**：外部 inbox 中的 review 是返工期间的权威通知，但不是最终仓库记录。
> 学科负责人恢复或继续工作时必须先读取对应 inbox 文件；返工完成后，把 Main 原意见与处理记录
> 一并写入本学科分支的 `docs/reviews/<subject>-<batch>-main-review.md` 并提交。Main 复验通过后，
> 该 Git 内 review 才随集成进入 main。inbox 文件不加入任何 worktree，也不由生成器处理。
>
> **并发门的新边界**：Main 写外部 inbox 无需等待学科负责人暂停；但仍必须先检查目标分支、
> `git status --short` 和提交尖端，以便把 `reviewed_commit` 与未提交范围写清。Main 不得因拥有
> inbox 写权限而进入忙碌的学科 worktree 修改源码、handoff、Git 内 review、未跟踪文件或 index。
>
> **开发权限不得与集成依赖门混为一谈。** Main 对连续课程路线使用三级权限，并在 ROADMAP 或
> review-inbox 中写明当前级别：
>
> 1. `research_open`：可以查 Mathlib、设计公开签名、在 `/tmp/sandrones-library/` 完成带 `sorry`
>    框架和消除证明责任；不得把成果写成 verified 或要求 Main 集成。
> 2. `development_open`：可以在学科 worktree 建立所有权明确的正式源码、Entry 文档和提交，运行
>    学科闭包并申请审核；若直接依赖尚未集成，handoff 必须写 `integration_waits_for`。
> 3. `integration_open`：直接依赖已经进入 Main，可以交付审核并在通过后集成。
>
> 一个后续窗口只要公开签名边界已经冻结、文件所有权不重叠，默认至少开放到
> `research_open`；Main 不得仅因前一小批尚在审核就让负责人停工。相邻窗口可以同时处于
> `development_open`，但每个提交必须能独立复验，且后窗不得复制或猜测尚未稳定的前窗 API。
> 真正冻结只保留给会改变数学语义、共享载体或跨学科接口的节点，并须明确写出解冻证据。
>
> 每轮 review 至少包含以下字段：
>
> ```markdown
> # Main review: <subject>-<batch>
>
> - branch: <学科分支>
> - reviewed_commit: <被审核提交；含未提交成果时写 commit 加 git status 摘要>
> - reviewer: main
> - verdict: needs_changes | blocked | accepted_main_docs | accepted
> - reviewed_at: YYYY-MM-DD
>
> ## 已通过
> ## 必须返工
> ## 可选择降级的接口
> ## 不得越过的边界
> ## 要求重跑的验证
> ## 学科负责人处理记录
> ```
>
> “必须返工”必须逐项给出证据位置（文件、声明名或文档 id）、期望结果和验收方法，不能只写
> “证明太薄”“文档不好”。若允许降级，必须明确需要同步修改的 Lean docstring、标题、summary、
> Registry 建议和 ROADMAP 完成度。若共有文件由 main 管理，通知中必须再次列明学科负责人不得
> 修改的共有文件。
> 纯 front matter、八段重排、handoff 字段、概念表／分类表排版、Git 内 review 收口、共有文件或
> Main-side 工具问题不得列入“必须返工”；应列入 `Main 集成整理`，verdict 使用
> `accepted_main_docs`，由 Main 在接收提交后完成。
>
> main 写完后，通过聊天或协作消息只发送一句短通知：
>
> ```text
> 请先阅读 <review-inbox绝对路径>/<subject>/<subject>-<batch>-main-review.md，
> 按其中 verdict 和 checklist 返工；该文件内容是本轮验收的权威版本。
> ```
>
> 学科负责人不得只依赖聊天摘要。完成返工后，在 Git 内 review 的“学科负责人处理记录”中逐项
> 填写 `resolved`、`declined with reason` 或 `still blocked`，列出修复提交和验证结果，并把该文件
> 与返工一起提交。复制 Main 意见时不得删除或改写，只能在处理记录中回应。
>
> main 复验时以 `reviewed_commit..返工提交` 做语义 diff，逐项核销。仍未通过就在同一文件追加
> 下一轮；通过后在 Git 内 review 追加 `verdict: accepted`、复验提交和命令结果，再随集成提交进入
> main。只有聊天回复、只有外部 inbox 通知、Git 内 review 仍未跟踪，或处理记录未提交，均不算
> 完成返工闭环。

> **10. 可切换角色的固定 ROLE 文件**
>
> - Main 负责人执行 `docs/roles/MAIN-ROLE.md`。
> - 学科负责人执行 `docs/roles/SUBJECT-MAINTAINER-ROLE.md`。
> - 已完成学科的定义转正、公开接口调整与下游迁移执行
>   `docs/roles/SUBJECT-MAINTENANCE-ROLE.md`；这类工作必须先做影响审计，再按兼容桥、下游迁移、
>   旧接口退役三阶段推进。
> - 用户只需指定角色；除无法从仓库判定的歧义外，不得要求用户填写租约、提交、文件清单、验证
>   命令或 handoff 表格。角色窗口应从 git、worktree、ROADMAP、handoff 和 review 自动发现状态。
> - 学科负责人被临时提拔为 main 时，先暂停学科开发、保存当前成果，再进入主 worktree 按 Main
>   ROLE 接管；main 任期结束后回到原学科 worktree，不能在两个角色下同时写共享状态。

> **10.1 Examples 是独立的跨学科巡视学科**
>
> Examples 负责人执行 `docs/roles/EXAMPLES-MAINTAINER-ROLE.md`，维护
> `docs/ROADMAP-examples.md`。它巡视已经进入 main 的教材定义、主定理和课程能力出口，为每个重要
> 知识点建立至少一个 Lean 验证的正例；有标准算法时给出完整计算，存在错误逆命题、易混概念或
> 不可省略假设时给出精确反例。
>
> 例子源码统一放在 `SandronesLibrary/Examples/**`，Entry 使用 `examples.<subject>.<topic>`。
> Examples 可以单向导入理论模块，任何理论模块不得反向导入 Examples。新理论提交缺少普通例子时，
> Main 原则上接收数学成果并把缺口排入 Examples 巡视；若例子本身是该课程出口或用于证明接口真实
> 可用，则理论与 Examples 作为两个独立提交共享同一课程门：理论负责人仍只交一般接口，Examples
> 负责人负责实例化；Examples 尚未完成只会阻止课程门关闭，不得据此要求理论负责人补写例子，也
> 不得打回已经数学验收合格的理论提交。Examples 不能自建一套重复理论，也不能用 Mathlib 现成对象绕过原学科
> 尚未完成的教材解释层或已经声明的语义边界；原学科若已把 Mathlib 接口解释并验收为正式承载，
> Examples 应直接复用。

> **10.2 常驻自然语言综合书稿《水仙十字的世界式》**
>
> - 本书执行 `docs/roles/WORLD-FORMULA-EDITOR-ROLE.md`，书稿根目录为 `docs/world-formula/`。它沿
>   Registry/Entry 的真实依赖路径综合全库知识，定位为大型数学参考书，而不是有完整习题体系的
>   授课教材。
> - 各章在适合教材闲谈的位置加入原创提瓦特人物情景，用来提出问题、暴露误解或连接观点；情景
>   必须服务数学、与证明边界分明，并遵守 `docs/world-formula/TONE-AND-SCENES.md`，不得复制
>   原作文本或伪造官方设定。
> - 书稿是 Lean 源码、verified Registry、Entry、合规出版来源和 ROADMAP 的**只读消费者**。
>   verified 事实、出版背景、research candidate 与 future plan 必须显式分栏；不得把计划写成成果，
>   也不得为了叙事顺畅要求原学科改定理或伪造桥。
> - 章节编辑只写 `docs/world-formula/` 和自己的 handoff；跨章目录、ROLE、ROADMAP、Playbook、
>   README/AGENTS 由 Main 维护。术语首次完整定义只允许一个权威位置，其他章节链接回指。
> - 纯文本没有编译器兜底。每批必须由非作者完成逐断言数学审核，再由另一名审阅者完成结构与
>   出版编辑审核；Main 最后核对事实截止 commit、状态、来源、链接和处理记录。详细协议见
>   `docs/world-formula/REVIEW-PROTOCOL.md`。
> - 审核严重度分为 R1 factual、R2 structural、R3 editorial。R1/R2 必须返工；只有 R3 时由主编
>   或 Main 直接修正，不把纯版式问题伪装成数学返工。

> **5 次试错法**：同一证明试错 ≥ 5 次 ⟹ 停止盲试，拆成子 todo（带 sorry 框架），逐个解决。

> **用途**：把"用 Lean 表达数学推理"的实战经验沉淀为可检索知识。
> 本库的 LLM 纳客在 Step 3（形式化）中遇到的每一个 tactic 困难，
> 都应该以「教训条目」的形式登记到这里——**经验在库内累积，而不是在每个新会话里从零踩坑**。
>
> **自我驯化（self-harness）铁律**：遇到 tactic 卡住时，
> **先去 mathlib 里看现成的证明是怎么用这个 tactic 的**——
> 看它使用**前**的目标状态、使用**后**的目标状态，用**自然语言语义**理解每一步在做什么，
> 再动手写。禁止低效的盲目尝试（"换个姿势再试一次"）。

---

## 目录（如何用本手册）

- **§0 工作流铁律**：遇到困难时的行动顺序（最该先读，含"做题先列 todo"铁律）。
- **§1 调试工具**：状态观察 + 编译器反问（`exact?`）+ 快速判据（No goals）+ 构建验证（lake 增量）。
- **§2 数学意图 ↔ tactic 映射**：**最常用**——想表达什么，就该用什么。含大坑（⋃ binder、if 递归、push Not）。
- **§3 公理纪律（Classical.choice 最小化）**：哪些 choice 是"数学必需"、哪些是"形式化噪声"，怎么判断。
- **§4 转正方法论**：mathlib 广泛形式 → 库当前阶段的教材陈述（库建设的核心工序）。
- **§5 实战教训日志**：一次性具体坑，按时间登记，附出处。
- **§6 从 mathlib 现成证明学 tactic**、**§7 self-harness 闭环**。
- **§8 Lean 验证轨迹语料（JSON）**：底层子 Agent 的每次验证尝试都必须留成机器可读语料
  （自然语言叙述、待证命题、尝试轨迹、编译器反馈），作为 LLM 训练数据。
- **§9 派工上下文包（JSON）**：轨迹的"观测"一半——派工前由脚本从权威源推导，负责人只填目标；
  包与轨迹用 `pack_id` 挂钩，`(观测, 动作, 反馈)` 才构成可训练样本。
- **§10 并行窗口派工规程**：简令由脚本从 pack 渲染（不许手写）、开窗前 Main 的四件事、
  负责人对子 Agent 的责任、研究窗与开发窗的区别、报告格式与三条不许。

---

## 0. 工作流铁律（Step 3 遇到困难时，按此顺序）

1. **读懂目标**：用自然语言把当前目标翻译成一句话（"我要证 X 属于某个并"、"我要把这个等式改成已展开的形式"）。先想清楚数学意图，再选 tactic。
2. **查 mathlib 现成证明**：
   - 用 grep 在 `.lake/packages/mathlib/Mathlib/` 里搜关键词（定理名/记号/人类可读的语义词）。
   - 用 `#check <名字>` 看定理的**精确类型签名**（参数顺序、隐式参数、返回类型）。
   - 找到一段用 `ext` / `rcases` / `rw` / `simpa` 等策略的现成证明，**观察它使用前后目标的变化**。
3. **用小实验验证理解**：在 `/tmp/opencode/*.lean` 写最小复现，确认"我以为的语义"确实成立，再把结论写回正式文件。
4. **做题先列 todo：一道定理 = 一个微项目，一次 edit 只喂一条引理**（由原 §3.11 提升）：
   - **任何含 3+ 个辅助引理再组装的证明（哪怕"看起来就一条定理"）**，动笔前必列子 todo，
     把辅助引理逐条单列（如：反函数严格单调、f(g y)=y、保序、子类型度量）。
   - 写大定理前先在文件里立下 `/- 引理清单 -/` 注释（含每个引理的类型签名），
     等于把"思维脚手架"固化下来，不用每轮重推。
   - **禁止一次性写超长证明块再编译**。每条辅助引理先在 `/tmp` 独立测试通过，
     再进主文件；主证明逐段组装、每段编译。
   - **正式库不接收带 `sorry` 的中间态**：所有框架和失败实验留在 `/tmp`；
     临时证明全部通过后，才将无 `sorry` 的完整文件纳入正式库。
   - 中途**严禁留 `sorry`**：敢留一个，下一个错误就离它十万八千里。
   - 每轮只动一个最小可验证单元（小引理 / 主定理的分支），跑 `lean` 无错即完成一项。
   - **命名先查是否撞 mathlib**（如 `inv_apply` 撞 `IsInvApply` 操作符），加独特前缀（`mono_inv_*`）。
   - **5 次试错硬规则**（紧集连续 ⟹ 一致连续复发后固化）：同一证明在 `/tmp` 或正式文件的
     编译试错 **≥ 5 次**（改了又编译的每次失败都算），立刻停止盲试，回头把证明拆成子 todo list，
     每个引理单独成块验证；子引理自身又试错 ≥ 5 次 ⟹ 再拆小，或接受 mathlib 现成结果
     （若该结果是教材定义而非可推导定理）。组装阶段的接口不匹配（choose_spec 层级、intro 顺序、
     三角不等式方向）也算进 5 次——到 5 次就暂停，用 `#check`/源码核对依赖引理的精确签名，不要继续猜。
5. **登记教训**：如果这次困难/解法值得保留，按 §5 格式追加到本 Playbook，并 commit。

> 一句话：**先理解语义，再写代码；写完代码，沉淀经验。**

---

## 1. 调试工具（状态观察 + 编译器反问 + 快速判据）

| 工具 | 作用 | 例子 |
|---|---|---|
| `#check <名>` | 看定理/定义的精确类型 | `#check Set.ext` → 显示参数与返回类型 |
| `#print <名>` | 看定义展开、定理证明体 | `#print Function.Injective` |
| `#find` / 源码 grep | 在 mathlib 里搜用法 | `grep -rn "div_lt_iff₀" .lake/packages/mathlib/Mathlib --include=*.lean` |
| `set_option pp.all true` | 显示所有隐式参数与类型（排错时） | 行首加一行再编译 |
| `set_option pp.universes true` | 显示类型宇宙 | 诊断多态不匹配时 |
| `#print axioms <名>` | 检查证明依赖了哪些公理 | 确认没有意外使用 `sorry`/`Classical` |
| `exact?` / `apply?` / `rw?` | **问编译器要候选**：不匹配时直接反问，常给可粘贴答案 | 见 §1.1 |
| 临时 `example` | 在 `/tmp/opencode/` 做最小复现 | 见 §2.1 |

### 1.1 `exact` 报类型不匹配时，先用 `exact?` / `apply?` / `rw?` 问编译器（由原 §3.17 提升）

- 症状：`exact <某引理/项>` 报 `Application type mismatch` 或 `expected to have type`，
  你手头这个项"看起来对"但 Lean 不认。多半是**参数顺序/隐式参数/函数 vs 值的结构**对不上，
  而不是缺证明——这类用肉眼看很费时。
- 对策：把该行换成 `exact?`（或 `apply?`、`rw?`），Lean 会在可用引理里搜索并给出
  **可直接粘贴的完整命令**（常带 `Try this: ...`）。它特别擅长发现：
  - 该用 `.mp`/`.mpr`、`Eq.symm` 的方向问题；
  - 需要先 `change`/`dsimp` 让类型 definitional 对齐；
  - 正确的引理名或参数写法（如 `IsCompact.image hK hf` 该给哪个 `Continuous`）。
- 与 §0 的顺序配合：先 `exact?` 拿到候选，再人工核对语义对不对，再粘贴——不要盲抄。
- 反例（浪费时间）：在 `exact` 上手动调参/加 `by`/拆解参数来回试，不如一次 `exact?`。
- 出处：第五章（Continuity 最值定理：`IsCompact.image` 需要全域 `Continuous f`，
  而 `ContinuousOn.restrict hf` 给的是子类型连续——`exact?` 会指向 `ContinuousOn.domRestrict`
  与正确的像-非空-存在极值组合）。

### 1.2 `No goals to be solved`：直接把多余的 tactic 删掉，别干别的（由原 §3.14 提升）

- 症状：某一行（常是 `exact …` / `rfl` / `nlinarith`）报 `error: No goals to be solved`。
- 语义：**goal 在上一行就已经被关掉了**，你这一行是多余的。前面某个 tactic（常见 `rw [dif_pos h]`/`rw [dif_neg h]`、`simp`、`omega`）
  已经把目标证明完，剩下的 tactic 找不到目标可证，于是报错。
- 正确做法：**删掉这一行多余的 tactic**，重新编译。一行即可解决。
- 反例（浪费时间的错误走法）：看到 `No goals to be solved` 就去怀疑定义、给谓词加 `@[irreducible]`、改 def、
  排查 rw 失配。结果引入连环新错（`intro h` 打不开 `¬∃`、重复声明、`Did not find dite`）。
  这全是"目标早已关闭"这一个简单事实引发的连锁误判。
- 铁律：报 `No goals to be solved` ⟹ 先删多余行；只有删完仍 `unsolved goals` 才回头找真正的证明缺口。
- 出处：第三章第五批（NIT→FC，halfbiseq_left_mono_step / right_antitone_step）。

### 1.3 `lake build` 的增量失误：改顶层 import 的子模块后，顶层 olean 可能不刷新（由原 §3.10 提升）

- 现象：`lake build` 显示成功，但外部测试文件 `import SandronesLibrary` 里
  `#check` / `#print axioms` **新加的定理报 unknown identifier**；旧定理却一切正常。
- 破局方法（三分校准）：
  1. 最小复现：单条 `#check <全限定名>` 单独验证，确认不是批量脚本造成。
  2. 对照：`#check` 旧定理（同命名空间）仍能解析 → 排除"命名空间写错/改名"。
  3. 隔离 olean：把 `#print axioms` **临时写进源码文件本身**编译 → 若成功，
     说明源文件内容与命名没问题，问题在**顶层模块的 olean 缓存的导入依赖过期**。
- 根治：删顶层缓存（`rm .lake/build/lib/lean/SandronesLibrary*.olean`）后 `lake build`，
  或直接 `lake build SandronesLibrary` 强制重编顶层；此后测试文件正常。
- 语义：lean 顶层 olean 含其 import 的依赖信息，lake 增量追踪对"源文件没变"
  的顶层常常跳过重建，导致体验 import 到旧依赖。**凡是改了被子模块 import 的源，
  都应强制重编顶层后再跑外部 `#check`/`#print axioms`。**
- 出处：第三章第四批（len analysis.sequence 四新定理），实验文件 /tmp/opencode/ax2.lean。

### 1.4 块注释里的数学斜线可能意外开启嵌套注释

- 症状：在 `/- ... -/` 文档注释中写连续文本 `0/1/-1` 后，Lean 报告注释未闭合，错误位置却
  可能远离这段数学说明。
- 原因：其中的字符序列 `/-` 会被词法分析器解释为另一个嵌套块注释的开始。
- 处理：改写为 `0、1、-1`，或加入不会形成 `/-` 的空格和分隔符。
- 出处：初等数论 N1.4（Legendre/Jacobi 符号说明）。

## 2. 常见"数学意图 ↔ tactic"映射

按数学意图分组。**这是最常用的部分：想表达什么，就该用什么。**

### 2.1 集合等式 / 函数等式 → `ext x`

- 数学意图：两个集合（或函数）相等。
- 语义：外延性——"逐元素核对"。
- 用法：`ext x` 后目标变成元素层命题。
- 反例：目标是**包含** `A ⊆ B` 时不用 `ext`，展开 `∀ x, x ∈ A → x ∈ B`（`Set.subset_def`）。
- 集合恒等式的完整演示套路：先 `ext`，再 `constructor`（双向），每边用 `rintro`/`rcases`
  拆合取与析取，元素层组装（见 §5.2 案例 `inter-distrib`）。

### 2.2 目标含存在量词 → 构造 witness

- 数学意图："存在 x 使得 P(x)"。
- 语义：你必须给出一个具体的 x，并证明它满足 P。
- 用法：
  - `use x`（给出 witness，目标变为证明 P(x)）
  - `refine ⟨x, ?_⟩`（等价写法）
  - `exact ⟨x, hx⟩`（如果一切就绪）
- **教训 §5.1**：当 `rcases`/`obtain` 无法从已有存在命题提取 witness 时，用 `.choose` + `.choose_spec`。

### 2.3 手头有存在命题，想取出里面的东西 → `rcases` / `obtain` / `rintro`

- 数学意图：由"存在 b，g b = c"得到具体的 b 和等式。
- 语义：析构一个 `∃` / `∧` / `∨` 结构。
- 用法：
  - `rcases hg c with ⟨b, hb⟩`
  - `obtain ⟨b, hb⟩ := hg c`
  - `rintro ⟨x, hx⟩`（目标也含存在/合取时）
- 注意：模式 `⟨..⟩` 按类型解构：`∃`→（witness, 证明）；`∧`→（两个证明）；`∨`→（分支）。

### 2.4 目标含合取（要证"且"）→ `constructor` 或 `refine ⟨?_, ?_⟩`

- 语义：拆成两个子目标，分别证明。
- 要证"或" → `left` / `right` / `exact Or.inl ...`。

### 2.5 已知含合取（手头有"且"）→ `rcases ... with ⟨h1, h2⟩`

- 语义：把 "x ∈ A ∩ B" 拆成 "x ∈ A" 和 "x ∈ B"。

### 2.6 已知含析取（手头有"或"）→ 分情况

- 语义：`P ∨ Q` 有两种来源，分别处理。
- 用法：`rcases h with hP | hQ`（两个 case），或用 `rintro (hP | hQ)`。

### 2.7 算术 / 序关系 / 线性组合 → 自动化策略

| 策略 | 场景 | 语义 |
|---|---|---|
| `omega` | 自然数/整数线性算术与序 | "这就是整数算术，交给决策过程" |
| `linarith` | 线性序域上的线性不等式组合 | "这些不等式是线性可导出的" |
| `ring_nf` / `ring` | 交换环上的多项式恒等式 | "展开并规约多项式" |
| `norm_num` | 数值计算 | "把 2*3 算成 6" |
| `positivity` | 证明表达式恒正 | 按结构递归地证明正值性 |

### 2.7.0 **铁律：有绝对值的 goal 不要用 `linarith`**（用户指定，最高优先）

- **规则**：只要目标或关键前提**含 `|·|` 绝对值记号**（如 `|x - y| ≤ q - p`、`|f a - f b| < ε`），
  **禁止直接 `linarith`**。即使看起来"展开后是线性的"。
- **原因**（实测）：`linarith` 对含绝对值的表达式即使经过 `rw [abs_le]` 展开，
  仍可能在减法组合目标上失败（`case left/right` 报 contradiction not found），
  而不是像预期那样"展开后就能线性化"。
- **替代（按顺序试）**：
  1. **先用 `abs_le.mp` / `abs_lt.mp` 把绝对值前提展开**成 `-c ≤ a ∧ a ≤ c`，再对**展开后的**目标 `linarith`。
  2. 展开后若仍失败（纯减法/区间端点组合），改用 **`nlinarith`**（多项式更强）或
     **显式 `calc` + `sub_le_sub_right`/`sub_le_sub_left`** 分段建立不等式再组合。
  3. 目标本身是绝对值不等式（要证 `|a| ≤ c`）：先 `rw [abs_le]` 得两个子目标
     （`a ≤ c`、`-c ≤ a`），每个**不再含 `|·|`**，此时才允许 linarith/nlinarith。
- **判定**：写 `linarith` 前先问："目标/前提里有没有 `|·|`？" 有 ⟹ 先展开或换策略。
- **出处**：黎曼积分"连续 ⟹ 可积"的区间宽度引理（C1）反复失败；此前一致连续证明的
  `hyb`、最终 `|f b - f a|` 界也踩过同坑。

### 2.7.1 `linarith`/`nlinarith` **不会**处理 `|·|` 绝对值项（反复踩坑，必须固化）

- **症状**：目标/前提里有 `|a| ≤ ε`、`|a - b| < ε` 等绝对值项，`linarith`/`nlinarith`
  报 "failed to find a contradiction"，即使线性关系显然成立。
- **诊断（语义）**：绝对值是非线性函数，决策过程**不展开**它。`nlinarith` 能做多项式但
  不能"知道" `|x| ≤ ε ⟹ x ≤ ε`——这是绝对值本身的刻画，不是线性事实。
- **解法**：先手动展开绝对值，再交给 linarith：
  - `|a| ≤ ε` ⟹ `-ε ≤ a ∧ a ≤ ε`，用 `(abs_le.mp h).1` / `(abs_le.mp h).2` 提取两个方向。
  - `|a| < ε` 同理 `(abs_lt.mp h)`。
  - 目标含 `|f b - f a| ≤ |f b - f x| + |f x - f a|` 这类三角：用 `abs_add_le`/`abs_add`
    先建立不等式，再 linarith。
  - 顺序反了的项：`|f x - f a|` 与 `|f a - f x|` 用 `abs_sub_comm` 对齐。
- **铁律**：目标/前提**含任何 `|·|`** 时，先 `#check` 列出要用的绝对值引理
  （`abs_le`/`abs_lt`/`abs_add_le`/`abs_sub_comm`），逐个展开对齐方向，**再** linarith。
  禁止直接对含 `|·|` 的式子 `linarith` 干等失败。
- **出处**：黎曼积分"连续 ⟹ 一致连续"（hyb 三角、最终 |f b - f a| 界）、
  "紧集连续 ⟹ 一致连续"（B1 像集有下界、B2 inf 逼近），多次重复。

### 2.7.2 `sSup`/`sInf` 用**条件完备**版本（`csSup`/`csInf`），不是 `CompleteLattice` 版

- **症状**：`le_sInf`/`sSup_le` 报 `synthInstanceFailed: CompleteSemilatticeInf ℝ`。
- **诊断**：ℝ 是 `ConditionallyCompleteLinearOrder`（有界才有 sup/inf），**不是**
  `CompleteLattice`。`sSup_le`/`le_sInf` 要求 CompleteSemilattice，ℝ 不满足。
- **解法**：用条件完备引理（需 `BddAbove`/`BddBelow` + `Nonempty` 前提）：
  `csSup_le`、`le_csInf`、`csSup_le_iff`、`le_csInf_iff`、`exists_lt_of_lt_csSup`。
  `sSup`/`sInf` 记号本身 ℝ 上就是 csSup/csInf（定义相同），但**引理名**要用 cs 前缀版。
- **出处**：黎曼积分振荡界引理 B2（inf 逼近）。



### 2.8 目标在句法上需要先改写 → `change` / `rw` / `simp` / `simpa`

- 数学意图：目标看起来是 A，但已知/定理给的是 B，A 与 B 是同一个东西的不同写法。
- 语义（重要）：
  - `change B`：直接告诉 Lean"把目标改成它的定义展开/可逆写法"。
  - `rw [h]`：**句法替换**——把目标里出现的 h 左边整体换成右边。找不到匹配就失败。
  - `simp [h, def_name]`：用等式 + 定义做规范化（重写 + 化简）。
  - `simpa [def_name] using h`：把 h 用定义规范化后，`exact` 到当前目标。
- **教训 §5.2**：`rw` 不做"定义展开"。目标是 `(g ∘ f) a = c` 时，
  `rw` 找不到 `g (f a)`——先 `simpa [Function.comp]` 或 `change g (f a) = c`。

### 2.9 双向蕴含（当且仅当）→ `constructor` 两半

- 语义：`P ↔ Q` = (P→Q) ∧ (Q→P)。`constructor` 后两个子目标。
- 用 `.mp` / `.mpr` 取一个方向的现成 iff。
- 例：`(div_lt_iff₀ hx).mp hn` —— 由 `a/c < b` 得到 `a < b*c`（c>0）。

### 2.10 函数复合 / 函数相等 → 先想"函数延拓"还是"逐点"

- 复合：`(g ∘ f) x` 就是 `g (f x)`（`Function.comp`）。
- 函数相等：`f = g` ↔ `∀ x, f x = g x`，用 `funext x`（函数外延性）。

### 2.11 `⋃ i ∈ t, U i`（t : Finset）会把绑定变量绑架成 `Set ℝ` —— 改用纯 ∃ 描述（由原 §3.12 提升）

- 现象：`x ∈ ⋃ i ∈ t, U i`（`t : Finset ι`）被反复解构时，`rcases` 给出的
  `i` 类型是 `Set ℝ`，目标是诡异的 `i ∈ Set.range fun i => ⋃ (_ : i ∈ t), U i`；
  `Finset.mem_union_left` 等全套 Finset 引理全部失配，跟类型死磕数轮。
- 根因：Lean 4.33 里 `⋃ binder ∈ s, f` 记法默认把 `s` 当 `Set` 解析，
  对 `Finset` 的 coercion 路径不稳定；`∈` 的 instance 在未知类型时容易拐错。
- 对策：**有限集合参与"覆盖/成员"描述时，一律写成纯 ∃ 记法**：
  `∃ t : Finset ι, ∀ x ∈ Set.Icc l r, ∃ i ∈ t, x ∈ U i`
  （= "存在有限 t 使每点都被 t 里某片盖住"）。∃/∀ 的 `∈` 记法很稳，
  `rcases` 直接给出 `hit : i ∈ t`（Finset 成员），配 `Finset.mem_union_left` 无摩擦。
- 推广：任何"big ∪/∩ 带 ∈ binder 且集合是 Finset"的命题，写完先想好解构路径。
- 补充（无 Finset 也会踩）：`rcases` 直接解构 `x ∈ ⋃ i, U i`（U : ι → Set ℝ，**无** ∈ binder）
  给出的 `i₀` 类型是 `Set ℝ`、`hxi₀ : (i₀ ∈ Set.range fun i => U i) ∧ x ∈ i₀`，
  后续 `hUo i₀` 立刻类型失配。对策：先 `Set.mem_iUnion.mp`（或 `(Set.mem_iUnion.mp h)`）
  拿到 `∃ i : ι, x ∈ U i` 再 `rcases`。`Set.mem_iUnion` 知道正确类型，绕过绑架。
- 出处：第三章第五批（analysis.completeness 等价环 NIT→FC，finite_cover_halves / 主定理）。

### 2.12 构造 `⋃ c ∈ s, t c` 的元素用 `Set.mem_biUnion`；无限子集的枚举用 `Set.Infinite.exists_gt`（由原 §3.16 提升）

- 构造 `n ∈ ⋃ c ∈ s, t c`（s : Set ι）时，别用 `rcases` 式嵌套 `⟨c, hc, ht⟩`（会把 c 绑成 `Set`，
  报 `expected Set ℕ`）。用 `Set.mem_biUnion`：`Set.mem_biUnion (hc : c ∈ s) (ht : n ∈ t c)`。
  例（鸽笼覆盖）：`Set.mem_biUnion ⟨n, rfl⟩ rfl : n ∈ ⋃ c ∈ Set.range u, {m | u m = c}`。
- `Set.Infinite.exists_gt (hs : s.Infinite) (a) : ∃ b ∈ s, a < b`——无限子集在任意 a 之后还有元素；
  配 `Nat.exists_strictMono_subsequence (h : ∀ N, ∃ n > N, P n)` 得到 `StrictMono φ ∧ ∀ n, P (φ n)`。
- `Set.Infinite s` 与 `¬ s.Finite` 是 definitional 相等：`h : ¬ s.Finite` 直接就是 `s.Infinite`，勿再 `not_not.mp`。
- 出处：第三章第五批（AccPt→Cauchy 的 `cauchySeq_tendsto_of_finite_range`）。

### 2.13 带 `if` 的递归 def：`by_cases` + `simp only` + `dif_pos/dif_neg`（由原 §3.13 提升）

- 场景：想证明某种 `def halfbiseq … | 0 => … | n+1 => let (l,r) := … in if _h : P l r then (l, m) else (m, r)` 的性质，
  需要在任意 `n+1` 处按 `if` 分两支。
- 失败模式：`by_cases h : P (halfbiseq … n).1 ((halfbiseq … n).1 + …)/2` 时，
  - 漏括号：`P X Y / 2` 被解析为 `(P X Y) / 2`（Prop 相除，报 `HDiv Prop ℕ`）。条件是 `P X ((X + Y) / 2)`，必须全括号。
  - `simp [halfbiseq, h]`：默认 simp 会把 `(l + r)/2` 归一成 `l * (1/2) + r * (1/2)`，
    使 if 条件的语法形与 `h` 对不上，`if` 化简成 `if True`（带 binder 的依赖 if，`if_true` 又配不上）。
- 正确套路：
  ```
  by_cases h : P X ((X + Y) / 2)        -- 条件与 def 内 if 逐字一致
  · simp only [halfbiseq]               -- 只展开 def，禁止额外归一
    rw [dif_pos h]                      -- 依赖 if 的真分支（h 即条件）
    ring / nlinarith …
  · simp only [halfbiseq]
    rw [dif_neg h]
    ring / nlinarith …
  ```
- 区分：`if c then a else b`（`ite`，c : Bool/Prop 非依赖）配 `if_pos/if_neg`；
  `if h : c then a else b`（`dite`，h 在分支可用）配 `dif_pos/dif_neg`。
- 出处：第三章第五批（NIT→FC，halfbiseq_length_step）。

### 2.14 两个小陷阱：`push_neg` 已弃用；`Type*` 在 `def X : Prop` 里会卡 universe（由原 §3.15 提升）

- `push_neg` 在 lean 4.33 已弃用，改用 `push Not`（`push Not at h` / `push Not`）。
  语义同 push_neg：把 `¬∀` 推成 `∃¬`、`¬∃` 推成 `∀¬`、`¬(P∧Q)` 推成 `P→¬Q`。
- `Type*` 陷阱：`def X : Prop := ∀ (ι : Type*) …` 会让 `Type*` 变成 X 的 universe 参数
  （`X.{u}`），调用 `h` 时传 `ι := ℝ`（ℝ : Type 0）无法 unify `u := 0`，报
  `ℝ has type Type but expected Type u_1`。凡"Prop 里显式量化的指标类型"直接写 `Type`
  （Sort 1，覆盖 ℝ/ℕ/普通类型）即可，别用 `Type*`。
- 出处：第三章第五批（NIT→FC 主定理；FC→AccPt 的 `accumulation_point_of_finite_cover`）。

### 2.15 隐式 binder 的分量 + 嵌套 `And` 匿名构造子：不要写裸 lambda（CA1 试点 4 次复现）

- 场景：目标是一个**由多个分量拼成的 `And`**，而分量本身用**隐式绑定**声明，例如本库的
  `IsSubspace K W = W.Nonempty ∧ (∀ ⦃u v⦄, u ∈ W → v ∈ W → u + v ∈ W) ∧ …`、
  `LeftIdealSet I = … ∧ (∀ ⦃x y⦄, x ∈ I → y ∈ I → x + y ∈ I) ∧ …`。
- 错误写法：把裸 lambda 直接塞进匿名构造子，如
  `exact ⟨h0, (fun hx hy => S.add_mem hx hy), …⟩`。
- 实际报错：`Application type mismatch: The argument hx has type R but is expected to have
  type ?m ∈ S`——Lean 把 `hx` 统一成了**隐式 binder 的第一个显式参数**（系数类型 `R`/`V`），
  而不是元素属于子集的那个前提。
- 根源：`And` 的匿名构造子不会把期望的函数类型传播进 lambda 的 binder 域，于是隐式 binder
  `∀ ⦃x⦄` 在 lambda 里退化成了普通显式参数。
- **修法**：不要在该位置写裸 lambda。先 `refine ⟨_, ?_, ?_⟩` 把分量开成独立 goal，
  再用 `intro x y hx hy` 在 **goal 上**引入 binder——此时隐式 binder 由目标本身给出，推断正确：

  ```lean
  refine ⟨⟨0, S.zero_mem⟩, ?_, ?_⟩
  · intro u hu v hv; exact S.add_mem hu hv
  · intro c v hv;   exact S.smul_mem c hv
  ```

- 出处：`commutative-algebra.module.definition` 的 L1 桥与 A2 桥（
  `traces/lean/commutative-algebra/ca1-mathlib-role-probe.jsonl` 第 5、7、10 次尝试，
  三次同一根因；第 6、11 次为修好后的 accepted 对照）。

## 3. 公理纪律（Classical.choice 最小化）（由原 §3.5–3.9 提升合并）

> **总原则**：遇到条目带 `Classical.choice`，先分清是"**数学必需**"还是"**形式化噪声**"——
> 只有噪声才值得改写。判别三连：
> 1. 是不是 `ℝ` 序结构本身？（是 ⟹ 结构性 choice，接受，见 §3.3）
> 2. 结论是否数学上等价于排中律/选择？（是 ⟹ 经典必需，接受，见 §3.2）
> 3. 是我引用了某条经典化的 mathlib 定理借道进来的吗？（是 ⟹ 换构造性证明路径，见 §3.1）

### 3.1 `rw [mathlib 定理]` 可能悄悄引入 `Classical.choice`（公理最小化）

- **症状**：`#print axioms` 显示定理依赖 `Classical.choice`，但教科书证明根本没用到选择公理。
- **诊断（语义）**：`rw [Set.compl_union]` 这类"引用 mathlib 现成定理"会把该定理**证明路径
  上的一切公理**带进本定理。mathlib 里不少看似平凡的引理是经典化的（尽管结论构造性可证）——
  choice 不是"这条定理需要"，而是"这条证明路径经过"。
- **解法**：换成不借道的构造性证明。集合恒等式用 §2.1 的 `ext x` + 逐元素 `Or`/`And`
  消解，往往就能构造性完成。
- **先判来源再动手**：`complement-inter` 的 `¬(P∧Q)→¬P∨¬Q` **数学上**等价于排中律，
  改写无效。口诀：**先分"数学必需"还是"形式化噪声"，噪声才值得改写。**
- **出处**：`settheory.set.operations.complement-union`（改写后 axioms = `[propext, Quot.sound]`）。

### 3.2 `ext` 后的"缺一个方向"往往是排中律缺口

- **症状**：`ext` 拆完双向，其中一个方向（常常是"否定之析取"或"析取之否定"）怎么都推不动，
  `rcases`/`constructor` 走到一半目标还原地踏步。
- **诊断（语义）**：目标形如 `¬P ∨ ¬Q`（从 `¬(P∧Q)` 来）——这在直觉主义逻辑里没有证明，
  因为要"决定 P 还是 ¬P"。它等价于排中律。不是 tactic 不对，是数学上不可证。
- **解法**：接受 `Classical.choice`（`by_cases h : P` 分路），并在叙述层注明"经典必需"；
  不要把时间耗在不可能的构造性路径上。
- **出处**：`settheory.set.operations.complement-inter`。

### 3.3 `ℝ` 的序结构实例本身带 `Classical.choice`（结构底线，不可削减）

- **症状**：连 `rfl`/`infer_instance` 的证明，`#print axioms` 都报告 `Classical.choice`；
  且是**类型里含 `ℝ` 的 `≤`/`<`** 时出现。
- **诊断（语义）**：`#print axioms` 会把定理类型里出现的 reducible 常量 delta 展开。
  mathlib 4.33 的 `ℝ` 序实例（`instLEReal` 等）**定义体**是经典构造的
  （构造顺序：`conditionallyCompleteLinearOrder` → `LinearOrder` 用 `by classical`）。
  于是 `a ≤ b ↔ a ≤ b := by rfl`（证明体就是 `Iff.rfl`，零公理）仍报告 choice。
- **对照实验**（决定"能否最小化"的关键判据）：
  ```
  t9  (a b : ℝ) : a ≤ b ↔ a ≤ b := by rfl   → [propext, Classical.choice, Quot.sound]
  t10 (a b : ℕ) : a ≤ b ↔ a ≤ b := by rfl   → []（零公理）
  t11 (s : Set ℚ) : BddAbove s ↔ ... := by rfl → []（零公理）
  ```
  只有 `ℝ` 中招，`ℕ`/`ℚ` 干净。
- **结论**：涉及 **ℝ 序性质**的条目，`Classical.choice` 是**结构必需**、无法削减——
  这不是形式化噪声，别浪费时间改写（除非重建整个 ℝ 的构造性实现）。
  公理最小化只适用于"同一结构上下文内避免借用额外经典引理"（§3.1 案例）。
- **出处**：`analysis.real.*`（第二章第一批，全部带 choice 均属此类）。

### 3.4 判断"能否削减 choice"的最小实验模板

- 目标：某 ℝ 序条目带 choice，想知道是否可削减。
- 步骤：写一个**无证明难度的极简对照**（如 `a ≤ b ↔ a ≤ b := by rfl`），
  `#print axioms`；若它已带 choice，则你的条目里的 choice 是结构性的，接受并注明。
- 语义：**先确认"地板"本身带不带公理，再决定要不要擦地板。**
- 出处：`analysis.real.*`。

### 3.5 `Setoid` 的 `≈` 与 `#print axioms` 盲区（诚实比零公理重要）

- 现象：`f ≈ f`（`CauSeq ℚ` 上）带 `Classical.choice`，即使证明体是纯 ε-δ 构造。
- 根源：`≈` 是 `CauSeq.equiv`（instance，reducible 展开）的 `Rel` 字段，
  展开会把**实例内置证明**（mathlib 的 `LimZero` 证明路径，用 classical）计入 axiom 集。
  这是"引用现成 Setoid 实例"的库开销，不是本条目新增的数学公理。
- 陷阱：把类型改写为结构投影 `CauSeq.equiv.Rel f f`，`#print axioms` 报**零公理**。
  **这是漏报，不是真零**——投影非 reducible，#print axioms 不再展开就停止报告。
  **禁用**：不能用投影改写来"伪装零公理"，违背公理透明的系统性求真。
  对照：同一证明体，`LimZero (f - f)` 与 `f ≈ f` 都带 choice；只有投影形式报零。
- 正确做法：诚实保留 ≈/LimZero 形式，在叙述层注明
  "choice 来源是 `CauSeq.equiv` 实例内部（mathlib 的 LimZero 证明），非本条目内容"。
- 出处：`analysis.real.construction-cauchy`（实验文件 /tmp/opencode/pb.lean）。

### 3.6 `#print axioms` 当 `sorryAx` 探针：编译失败留下的 `?_` 会伪装成"大部分通过"

- 现象（CA1 试点实测）：一个探针文件里前面几条 `example` 都通过、末尾一条因隐式 binder 报错，
  但文件里残留的 `?_` 洞被 Lean 当作 `sorry`，于是脚本末尾的
  `#print axioms <被审声明>` 打出
  `depends on axioms: [propext, sorryAx]`。
- 教训：**"编译输出里大部分是 ✔"不等于干净**。只要有一个 `?_` 没被填上，该声明就带 `sorryAx`，
  而 `sorryAx` 会顺着依赖传染给所有引用它的定理。
- 用法：把 `#print axioms <声明全名>` 当作**每个待交付声明的收尾探针**（尤其在
  `/tmp` 原型转正式文件、或一轮里改了多处 binder 之后）。出现 `sorryAx` 说明还有洞，
  与"编译通过"是两件独立的事——编译器可以一边报 error 一边让后续 `#print axioms` 给出结论。
- 注意与 §3.5 的分工：`#print axioms` 会**漏报**被非 reducible 投影挡住的实例开销（§3.5），
  但它对 `sorryAx` **不漏报**——两者是不同方向的盲区，不能互相替代。
- 出处：`commutative-algebra.module.definition` 探针第 7 次尝试
  （`traces/lean/commutative-algebra/ca1-mathlib-role-probe.jsonl`）。

## 4. 转正方法论（Promote to Textbook Form）：mathlib 广泛形式 → 库当前阶段的教材陈述（由原 §3.18 提升）

- **定义**："转正" = 一个**教材上的重要结果**，在 mathlib 里可能只以**很广泛/抽象的形式**存在
  （如 `Module.finrank`、`Submodule.span_le`、`IsCompact` 的某引理），但我们的库还没用
  **当前阶段的语言**把它作为正式词条写下来。转正就是把这种结果"用教材陈述 + 库记号 + 证明"立成词条。
- **为什么要转正**：
  1. 教材结果是学生要学的、可检索可调用的核心知识；mathlib 的广泛形式是"实现细节"。
  2. 检查某条目时，若其 `mathlib` 字段指向的抽象引理在教材里对应一个重要结论
     （而库没单独立条），就说明该转正。
  3. 防止"mathlib 有就算完"——库的价值是**教材层**的可读词条，不是 mathlib 名目清单。
- **判据（满足其一就该转正）**：
  - a) RADAR 里登记的 mathlib 名，其"人话"对应一个教材定理，但 registry 里没有对应词条。
  - b) 某词条的 summary 声称涵盖某教材结果（如"span 是最小子空间"），但代码里没真正实现该结论。
  - c) 某教材核心结论（如生成子空间最小性、秩-零度、可逆⟺det≠0、相似不变）仅以 mathlib 广泛形式存在。
- **转正流程（每个候选）**：
  1. **确认教材陈述**：翻参考书/讲义，写下该结果的教材语言（变量、前提、结论）。
  2. **定位 mathlib 抽象**：找出承载该结果的 mathlib 引理（RADAR 或 `#check`）。
  3. **用库当前阶段语言立条**：
     - 签名采用当前阶段已解释的教材概念；语义一致且已完成教材解释的 Mathlib 接口
       可以直接作为正式公开承载，不为改名而复制等价结构。
     - 对公开签名逐项完成四类扫描；语义不匹配或超出课程层级的结构不得静默泄漏，
       必须修改接口或取得 Main 明确批准。仅作私有后端的结构留在定义体或证明内部。
  4. **证明**：优先基础/教材办法（纯 det、纯 ε-N、纯集合论）；能绕开多项式环/环同态等
     更广泛结构就绕开（同源原则：保留当前阶段的域性质）。
  5. **注册 + 叙述层 + RADAR**：词条 id 用 `linear-algebra.*`/`analysis.*` 教材命名；
     叙述层写教材陈述，并按实际角色解释 Mathlib 名称是正式承载、桥侧接口还是私有证明后端。
  6. **验收**：`lake build`、`check_axioms --fix`、`audit.py` 全过。
- **反例（不算转正）**：直接包装 Mathlib 定理，却不核对教材语义、不解释公开承载、
  不给展开／刻画或一手性质与真实上层使用者。证明是否一行、名称是否来自 Mathlib，
  都不能单独决定是否完成转正；验收按本手册的教材解释层质量门执行。
- **定期动作**：每完成一批，回头扫已有条目的 `mathlib` 字段与 RADAR，
  找出"教材结果 vs 广泛形式"的缺口并转正。
- **出处**：线性代数批（`vector-space.span` 的最小性曾因桥接繁琐被删——正是转正缺口）。

### 4.1 瘦身方法论（Slimming）：能用本库推导的，就不要引用 mathlib

- **定义**："瘦身" = 把直接 `exact <mathlib 引理>` 立条的定理，改写成
  用**本库已有的教材层定理 + 基本逻辑/代数推导**完成证明。目标：减少对 mathlib 的
  直接依赖，让每条定理的证明在本库内部可见、可追踪。
- **为什么重要**：学术论文里的定理 mathlib 库里**没有**，到时全得自己写。
  瘦身是练兵——把"抄 mathlib"逐步换成"自己推"，培养论文定理的自证能力。
  库的价值是**可自证的教材推导**，不是 mathlib 名目清单。
- **判定三类**：
  1. **结构性可推导**（做瘦身）：证明只用本库已有定理 + 基本代数/逻辑（群消去律、
     共轭封闭、有限覆盖定义）。例：`normal_mem_comm`（从 `normal_conj_mem` 推）、
     `hom_map_one`（从 `map_mul` + f1·f1=f1 ⟹ f1=1）、`compact_singleton`（从有限覆盖定义）。
  2. **定义性/公理性**（保留）：数学地基本身 = mathlib 的定义字段/公理。例：
     `one_mem`/`ext`/`mem_ball`/`dist_*`/`isOpen_*`/`map_mul`（环同态）/`mul_eq_zero`（整环）。
     不存在"推导"，删了就没定义。
  3. **依赖 mathlib 内部结构**（保留，除非重建该理论）：引理基于 mathlib 的构造细节。
     例：Poly 的 `eval`/`degree`/`coeff`、LinearAlgebra 的 `Module`/`Matrix`、
     分析线的 ε-N（ℝ 度量结构）。瘦身 = 重建理论，超出"推导"范畴。
- **自底向上**：要瘦身顶层定理，先瘦身它依赖的底层（递推）。底层定义性条目保留，
  再往上替换"明显是组合推导"的。
- **低垂果实优先**：先清"证明体一行 `exact mathlib` 且结论能用本库推"的纯结构性条目。
  这类验证快、正反馈强。中层（normal_of_index_two、is_maximal_implies_is_prime）和
  深层（zorn、tychonoff、lagrange、同构定理、irreducible 系）是后续工程。
- **每批验收**：改完 `lake build` + `check_axioms --fix` + `audit.py` 全过，commit
  "瘦身批次N: <条目清单>"。RADAR 里某条记录的"谁在用"索引全部被本库条目替换后，
  即证明该 mathlib 条目已被完全解明。
- 出处：第一学期收尾瘦身（第一批 normal_bot/top/comm、hom_map_one/inv、compact_singleton）。

## 5. 实战教训日志（一次性具体坑，按时间登记，附出处）

> 登记格式：**症状 → 诊断（语义层面为什么）→ 解法 → 出处（哪个条目）**。
> 重要的通用教训已被提升到 §0/§1/§2/§3/§4；这里只留一次性、语境特定的坑。

### 5.1 `rcases`/`obtain` 无法从存在命题提取 witness

- **症状**：`rcases exists_nat_gt (y / x) with ⟨n, hn⟩` 后，目标**仍然是存在量词**（`∃ n, ...`），完全没消掉；`obtain` 同样失败。编译报 "Type mismatch ... expected `∃ n, ...`"。
- **诊断（语义）**：`rcases` 依赖对 `∃ n, ...` 结构的模式匹配。在 mathlib 4.33 的某个返回类型带隐式类型参数的存在命题上，析构没有生效。语义上等于"想从盒子里取东西，但盒子没打开"。
- **解法**：绕过模式匹配，直接取 witness：
  ```lean
  let n := (exists_nat_gt (y / x)).choose   -- 取那个存在的自然数
  use n
  exact (div_lt_iff₀ hx).mp (exists_nat_gt (y / x)).choose_spec
  ```
  `.choose` 提取 witness，`.choose_spec` 给出它满足的性质。语义直白："它存在，就把它挑出来用"。
- **出处**：`analysis.real.archimedean`。

### 5.2 `rw` 找不到复合记号的匹配

- **症状**：目标是 `(g ∘ f) a = c`，`rw [ha, hb]` 报 "Did not find an occurrence of the pattern"。
- **诊断（语义）**：`g ∘ f` 是 `Function.comp` 的**记号缩写**，`rw` 只做句法替换、不展开定义。语义上等于"你让我替换 'AB'，但文件里写的是 'A·B'（一个记号）"。`rw` 看不见未展开的定义。
- **解法**：先展开或用会展开的策略：
  ```lean
  exact ⟨a, by simpa [Function.comp] using (congrArg g ha).trans hb⟩
  -- 或更直白：
  change g (f a) = c          -- 把目标改写为展开后的写法
  rw [ha, hb]
  ```
- **语义理解**：`congrArg g ha` 给 `g (f a) = g b`（把等式 ha 两边同套 g），`.trans hb` 接上 `g b = c`，`simpa [Function.comp]` 用定义把 `(g∘f) a` 规约成 `g (f a)`。三步都是"自然语言一句话"的翻译。
- **出处**：`settheory.function.surj-comp`。

### 5.3 `div_lt_iff₀` 的方向（.mp vs .mpr）

- **症状**：初学容易把 `(div_lt_iff₀ hx)` 用在错误方向。
- **诊断（语义）**：`div_lt_iff₀ hc : (b / c < a) ↔ b < a * c`。`.mp` 取正向（除式 → 乘式），`.mpr` 取反向。它等价于"除以正数不改变序"，但**只对 c > 0** 成立（前提 `hc`）。
- **解法**：把前提（`hx : 0 < x`）作为参数传给定理，再取方向。
- **出处**：`analysis.real.archimedean`。

### 5.4 集合恒等式：先 `ext`，再分派逻辑

- **症状**：想直接"套用"集合层定理但手头只有 mathlib 的 `Set.inter_union_distrib_left` 名字对不上，或想演示证明过程。
- **诊断（语义）**：集合等式在语义上就是"逐元素的双向属于"，逻辑层（`∧`/`∨`）的分配律承担实质工作。集合层没有任何额外的结构。
- **解法**：`ext x` → `constructor`（双向）→ 每边用 `rintro`/`rcases` 拆合取与析取 → 元素层组装。见 `settheory.set.operations.inter-distrib` 的完整演示。
- **出处**：`settheory.set.operations.inter-distrib`。

### 5.5 公理审计器必须区分 `namespace` 与命名 `section`

- **症状**：源码中的定理可正常编译，但 `check_axioms.py` 在经过 `end Gradient` 一类
  命名 section 后，把后续定理打印成无命名空间的短名，并登记为 `<解析失败>`。
- **诊断（语义）**：Lean 的 `section` 只控制变量和作用域，不参与声明全名；旧审计器却把
  每个命名 `end` 都当作 namespace 结束，因而误弹出真正的外层 namespace。
- **解法**：解析时同时跟踪 namespace/section 两类作用域，构造声明全名时只拼接
  namespace。任何 `<解析失败>` 都不得当作合法公理结果入库，必须先修复定位接口再重跑。
- **附带教训**：增量审计全部跳过的早退分支也必须删除 `_sha` 等运行时字段，禁止临时
  状态泄漏到 registry 并制造全文件 diff。
- **出处**：`analysis.multivariable.coordinates` 登记与 `scripts/check_axioms.py`。

### 5.6 三角矩阵唯一性证明：先抽取交叉因子，再复用“乘积反推三角性”

- **症状**：证明正对角 QR 唯一性时，直接按列展开正交条件会同时产生有限和、列递推、
  符号规范和矩阵乘法结合律，证明接口迅速膨胀。
- **诊断**：两个分解 `Q₁R₁ = Q₂R₂` 的真正差异集中在交叉因子
  `S = Q₁ᵀQ₂`。它满足 `S R₂ = R₁` 且正交。若能从两个上三角因子反推出 `S`
  上三角，再从对角乘法反推出其对角为正，唯一性就化为一个独立的结构命题。
- **解法**：先证明通用引理：`S R₂ = R₁`、`R₁/R₂` 上三角且 `R₂` 对角非零
  蕴含 `S` 上三角。随后把同一引理应用于 `Sᵀ S = I`，得到 `Sᵀ` 也上三角；因此
  `S` 同时上下三角，正交性给出对角平方为一，正对角规范排除 `-1`，最终 `S = I`。
  这个路线避免显式构造上三角逆矩阵，也避免重复逐列归纳。
- **出处**：`linear-algebra.decomposition.qr`（正对角规范 QR 唯一性）。

### 5.7 优先把新分解归约到已经完成的规范分解

- **症状**：从 LDL 分解构造 Cholesky 因子后，若重新逐项证明下三角逆仍下三角，或重新展开两个 Cholesky 因子的唯一性，会重复处理有限和与三角矩阵消元。
- **诊断**：这些并不是新的坐标计算。LDL 的 `lowerInv` 已有单位下三角性质，其逆的三角性可在转置后复用“乘积反推上三角性”；两个 Cholesky 因子的交叉因子则正好给出同一矩阵的两个正对角 QR 分解。
- **解法**：先用 `N L = I` 转置为 `Lᵀ Nᵀ = I`，调用已有上三角因子引理得到 `L` 下三角；唯一性中构造 `S = L₁⁻¹L₂`，证明 `S` 正交且 `L₁ᵀ = S L₂ᵀ`，随后直接调用正对角 QR 唯一性。
- **出处**：`linear-algebra.decomposition.cholesky`。

### 5.8 有序标准形：先显式固定索引次序，再做 QR 正交化

- **症状**：Jordan 标准形只给出某个有限索引等价；若直接任意重编号到 `Fin n`，块内次序可能被打乱，因而不能推出重编号后的矩阵上三角。
- **诊断**：上三角性依赖索引次序，而普通 `Equiv` 只保存元素，不保存次序。依赖和索引还需要用 `Lex` 显式赋予块号优先、块内位置次之的全序。
- **解法**：先证明 Jordan 块对角矩阵在 `Lex (Σ i, Fin (length i + 1))` 上为上三角，再用到 `Fin n` 的 `OrderIso` 重编号。取得上三角相似形后，对换基矩阵作复 QR，并从 `T R = R B` 反推酉共轭矩阵 `T` 上三角。
- **出处**：`linear-algebra.decomposition.schur`（复 Schur 分解）。

### 5.9 实 Schur 递归：尾部基必须作为参数贯穿分块接口

- **症状**：抽取一或二维不变子空间后，首步适配基可直接使用正交补的标准基；但递归
  尾部会产生新的 Schur 基。若右下块引理只写死标准基，递归证书便无法组装成同一个
  显式块上三角矩阵。
- **诊断**：真正稳定的接口不是“标准基下的压缩矩阵”，而是“正交补上任意给定正交基
  下的压缩矩阵”。首块标准基与递归尾部基应当先拼接，再整体映射回原空间。
- **解法**：先在带 `sorry` 的上层框架中同时组装广义适配基、左下块为零、右下块等于
  压缩矩阵和最终递归定理；确认所有上层 `sorry` 已转移到这三个局部接口后再逐个证明。
  最终用嵌套和类型记录每个大小为一或二的首块，无需在递归中反复重编号到 `Fin n`。
- **出处**：`linear-algebra.decomposition.schur`（显式实 Schur 块上三角化）。

### 5.10 有限维线性代数接口：公开使用线性映射，连续性只留在实现层

- **症状**：为了复用 mathlib 的算子范数和伴随恒等式，容易把 `ContinuousLinearMap`
  直接写进 SVD 等线性代数定理的公开签名，使教材层陈述无端依赖泛函分析语言。
- **诊断**：有限维赋范空间上的线性映射自动连续；连续线性映射只是算子范数实现所需的
  技术表示，不是 SVD、特征值或矩阵分解的数学输入。
- **解法**：公开定义与定理统一接收 `LinearMap`，在定义体或证明内部通过
  `toContinuousLinearMap` 调用范数接口。证明正算子范数公式时，在有序正交特征基中逐坐标
  比较平方范数：最大特征向量给下界，特征值单调性和非负性给上界。这样既保留纯线性代数
  签名，也复用了可靠的底层范数实现。
- **出处**：`linear-algebra.decomposition.svd`（算子范数与第一奇异值）。

### 5.11 基分解求值失败：先显式消除强制转换，再调用有限和公式

- **症状**：目标中出现“连续线性映射的有限和转成线性映射后再作用于向量”，直接用
  `sum_apply`、`simp_rw` 会反复报告找不到匹配或没有进展。
- **诊断**：求值被藏在 `ContinuousLinearMap` 有限和、`.toLinearMap` 和函数强制转换三层
  表示之后；改换求和引理并不会改变目标的句法形状。
- **解法**：第一次匹配失败就查看完整目标，用 `change` 把右端显式改成连续线性映射之和
  直接作用于向量，再调用 `_root_.sum_apply`。涉及谱分解时还要让正因子和部分等距因子
  共享同一组规范右奇异基，不能把任意 SVD 证书中的基与规范特征基混用。
- **出处**：`linear-algebra.decomposition.polar`（正因子的秩一和表示与极分解组装）。

### 5.12 教材核心概念先核对语义：能复用 Mathlib 就解释清楚，不能复用才自建

- **症状**：负责人在“公开签名不得无解释挂靠 Mathlib”与“所有概念都不得复用 Mathlib”之间
  混淆：前者会留下看不懂的接口，后者则复制 `Continuous`、路径、同伦等成熟基础设施。
- **诊断**：质量门检查的是教材语义是否得到解释和验证，不是定义是否带本库前缀。语义一致时，
  新造同构包装只会增加转换、实例和维护负担；语义不一致时，静默复用又会偷换课程概念。
- **解法**：先写教材定义并逐项核对 Mathlib 接口的量词、数据、相等方式和 typeclass 假设。
  若一致，直接把成熟接口作为正式公开承载，在文档中解释并用展开／刻画定理展示如何使用；
  若不一致或 API 缺失，再建立本库谓词或结构并给出具名桥。公开定理可以直接使用已完成解释的
  Mathlib 接口，不应为了“去 Mathlib 化”复制整套理论。
- **出处**：拓扑中的 `Continuous`、`Homeomorph`、`Path` 等应在语义一致时复用；Sylow 条目只有
  在课程定义与 `IsPGroup`／`Sylow` 的打包方式或量词边界确有差异时才保留自建接口。

### 5.13 序数 API 先分清根命名空间、开放记号与附加模块

- **症状**：序数最小实验中，凭源码附近的写法猜出 `Ordinal.typeLT`、
  `Ordinal.lt_succ` 或只导入 `Veblen` 后调用 `Ordinal.natCast_mul_omega0`，会分别遇到
  unknown identifier；看似属于同一序数主题的定理也未必由同一模块导出。
- **诊断**：`typeLT` 是开放后的根记号而非 `Ordinal` 字段，通用后继接口位于 `Order`；
  有限序数乘 `ω` 的吸收律则定义在额外的 `Ordinal.Principal` 模块。源码中的短名依赖
  当前 namespace、`open` 和 import 闭包，不能直接反推全限定名。
- **解法**：先用最小文件分别 `#check` 候选全名；公开代码优先写稳定的全限定形式，
  如 `Ordinal.type (α := ℕ) (· < ·)`、`Order.lt_succ`，并按定理实际出处显式 import
  `Mathlib.SetTheory.Ordinal.Principal`。若定理已 deprecated，立即改用提示给出的新接口，
  如 `WellFoundedLT.induction`。
- **出处**：`settheory.ordinal.order-type`、`transfinite-induction`、`multiplication`。

### 5.14 不要把需要 defeq 展开的项用 `have`/`let` 绑定成局部定义

- **症状**：已经确认 `(F'.map f) z` 与 `pathHomotopySquare (F'.map f) z` 都和子类型的第二分量
  `(F' z).2` 定义等价，但把同伦先写成 `have hF' : gamma.Homotopic delta := ...` 之后，
  对 `hF'` 使用同样的项就报类型不匹配。
- **诊断**：`have`/`let` 引入的局部定义是**不透明**的绑定，`whnf`/`defeq` 不会穿过它展开；
  于是「项 A 与项 B 定义等价」在绑定之后不再对 elaborator 可见。直接写项时它会被就地展开，
  所以同一段代码在有无绑定时表现不同——这也是为什么三分对照（直接项 / 绑定项 / 显式展开）
  能把原因钉死，而不是继续猜 tactic。
- **解法**：把需要 defeq 的项**直接写在 `refine`/`exact` 的位置**，不要先 `have` 绑定；
  确实需要复用时，用 `show` 或 `change` 把目标显式改写成绑定前的形状，或给绑定加
  `@[reducible]`/`dsimp only` 级别的显式展开。
- **出处**：`complex-analysis.cauchy.homotopy`（E5 窗口，三分对照实验定位；
  trace 见 `traces/lean/complex-analysis/complex-analysis.cauchy.homotopy.jsonl` 的定位轮）。

## 6. 怎么从 mathlib 现成证明学到 tactic 用法

mathlib 的证明文件是**最好的教材**。读法：

1. **定位**：`grep -rn "<tactic名> " .lake/packages/mathlib/Mathlib/<相关目录> --include=*.lean`，
   或搜人类可读的语义词（如 `div_lt_iff₀`、`tendsto_nhds`）。
2. **读签名**：`#check <定理名>` —— 参数顺序、隐式参数、返回类型。这是"函数接口文档"。
3. **读使用前后状态**：找一段用该 tactic 的证明，尝试在头脑中重构：
   - 使用前目标是什么？自然语言怎么说？
   - 该 tactic 一步做了什么改变？
   - 用的参数从哪来？（常常来自上一步 `rcases`/`obtain` 提取的变量）
4. **复刻最小例子**：在 `/tmp/opencode/` 写一个 5 行的 `example`，复制结构，确认自己真懂，再放进正式条目。
5. **失败时**：把报错信息翻译成自然语言（"期望类型 vs 实际类型"就是"我要的东西和手头的东西对不上"），回到 §2 找映射，别瞎试。

## 7. self-harness 闭环（保证经验持续累积）

- 每次在 Step 3 解决一个新困难：**必须**在本 Playbook 登记（新教训按 §5 格式追加；
  若属于通用规律，直接补进 §2 映射表 / §3 公理纪律 / 相关顶级节）。
- 教训的质量标准：**诊断要写到"语义层面"**（为什么这样，而不是只记"这样能过"）。
  因为记"这样能过"只解决一次，记"语义是什么"能迁移到所有类似情形。
- 审计：`audit.py` 之外，人工 review 时检查"新条目是否引入了未登记的新 tactic 模式"。
- Playbook 本身也是库的一部分，随版本管理，随经验增长。

## 8. Lean 验证轨迹语料（JSON）：底层子 Agent 的强制留痕

### 8.1 为什么

`§5`/`§7` 记录的是**提炼后的教训**，而教训的原始过程——"我当时想证什么、为什么这样试、
编译器回了什么、下一步怎么改"——才是训练 LLM 做形式化证明最有价值的语料。本库的学科窗口
天然产出大量这类过程（原型 → 逐 `sorry` 消解 → 编译反馈），但过去只把结论留在 handoff。
从 2026-10-13 起，**过程本身也是交付物**。

### 8.2 谁写、什么时候写

- **写入者**：实际执行 Lean 验证的 Agent。底层子 Agent（含学科负责人亲自下场时）都要写；
  只读审计、纯文档工作的 Agent 不写。
- **写入时机**：**边做边写**——每次把 tactic 块交给编译器之后立刻追加一条记录。
  禁止事后凭记忆补写：事后重建的轨迹会被系统性美化（只记得成功的路径），
  作为训练语料是**有害**的。
- **诚实铁律**：`outcome` 必须等于编译器的真实结论。没跑过编译器不许写记录；
  不许只记录成功尝试而丢弃失败尝试——失败尝试正是语料的主要价值。

### 8.3 格式与位置

- 位置：`traces/lean/<subject>/<task-id>.jsonl`（`<task-id>` = Entry id，或原型阶段的工作项名，
  如 `topology-at2-c5e-e1-initsegmap`）。该目录属**学科自有**，随学科分支提交。
- 格式：**JSON Lines**——每行一个独立的 JSON 对象（一次尝试），追加写入。
  每行都必须能被 `json.loads` 单独解析；不要写成一个巨大的 JSON 数组（那样无法增量追加）。
- schema 版本号写在每条记录的 `schema` 字段里，当前为 `sandrones-lean-attempt/1`。

### 8.4 记录字段

必填字段：

| 字段 | 含义 |
|---|---|
| `schema` | 固定 `"sandrones-lean-attempt/1"` |
| `trace_id` | 同一证明任务的稳定标识（一个任务一个文件，值一致） |
| `attempt` | 本任务内从 1 开始的尝试序号 |
| `timestamp` | UTC ISO-8601，写入时刻 |
| `agent` | 写入者（子 Agent 标签或角色名） |
| `subject` | 学科前缀（与目录一致） |
| `narration` | **自然语言叙述**：这一轮想干什么、为什么这么想、上一轮学到了什么 |
| `goal` | **待证命题**：当前目标的 Lean pretty-print（类型/目标），不是自然语言意译 |
| `plan` | 本轮的证明计划（一句话：打算用哪条引理、怎么拆） |
| `attempt_code` | 本轮真正提交给编译器的 tactic 块 |
| `outcome` | `accepted` / `error` / `timeout` / `sorry_left` / `abandoned` |
| `compiler_feedback` | 编译器反馈数组，每项 `{"severity", "message", "line", "col"}` |
| `next_step` | 下一轮打算怎么改（写记录时就要给出，这是轨迹的"边") |

**侦察类尝试（`#check` / `#print` / `#synth`）怎么写 `goal`。** 这类轮次没有"待证命题"，
但它恰恰是轨迹里最便宜、信息量最大的一类样本，不要跳过。约定：

- `goal` 写**本轮真正提交给编译器的那串探针命令的规范化形式**（可以按 `#check` 分组用
  `/` 分隔），不要写成自然语言，也不要写成"想知道 X 是否存在"；
- `outcome` 按编译器结论给：全部探针成功 → `accepted`；有 `Unknown constant` /
  `Application type mismatch` 等 → `error`（**哪怕只有一条错**，见 §3.6）；
- `next_step` 写"由这批探针结论**决定了什么**"（换了哪个承载、放弃了哪个候选名），
  这是侦察轮最有训练价值的部分；
- 出处示例：`traces/lean/commutative-algebra/ca1-mathlib-role-probe.jsonl` 第 1–4 次尝试
  （`#print Module/Submodule/LinearMap` → 确认父结构；`#check` 候选桥名 → 五个名字不存在）。

选填字段：`entry_id`、`file`、`declaration`、`parent_attempt`（形成尝试树）、
`pack_id`（**派工上下文包的 join key**，见 §9；有 pack 的批次必填，否则轨迹无法与上下文配对）、
`hypotheses`（关键上下文）、`feedback_raw`（原始输出，**截断到 4000 字符**）、
`feedback_sha256`（完整输出的摘要，便于日后回溯）、`elapsed_ms`。
敏感信息（令牌、凭据、仓库外绝对路径）**一律不得写入**。

最小合法记录（一行）：

```json
{"schema":"sandrones-lean-attempt/1","trace_id":"analysis.stokes.domain-gluing","attempt":1,"timestamp":"2026-10-13T09:30:00Z","agent":"analysis-r1/worker-a","subject":"analysis","narration":"目标是把两片的边界积分相加，先用 integral_biUnion_finset 合并区域。","goal":"⊢ ∫ x in A ∪ B, f x = ∫ x in A, f x + ∫ x in B, f x","plan":"先证不交，再套 integral_biUnion_finset","attempt_code":"rw [integral_biUnion_finset]","outcome":"error","compiler_feedback":[{"severity":"error","message":"failed to synthesize Disjoint A B","line":42,"col":8}],"next_step":"把 Disjoint 作为显式假设加进签名"}
```

### 8.5 工具与检查

- 写入/校验：`python3 scripts/lean_trace.py append --file traces/lean/<subject>/<task-id>.jsonl --record <record.json>`
  （自动补 `schema`/`timestamp`/`attempt` 并校验字段），
  `python3 scripts/lean_trace.py check traces/lean/<subject>/`（校验全部记录），
  `python3 scripts/lean_trace.py summary --subject <subject>`（按 outcome 统计）。
- `check` 还会查**同一文件内 `attempt` 序号是否唯一**。两个 worker 并发 append 同一个 jsonl 时
  会各自从 1 开始编号，序号竞争让轨迹的先后关系失真——CA1 试点里 `ca1-verify` 因此另写了文件。
  正确做法是 §9.4 的 `--worker`：每个 worker 有各自的 `trace.path`，不必也不应抢同一个文件。
- 学科交付包（`scripts/subject_package.py`）会统计本批 trace：本批改动了 `SandronesLibrary/**/*.lean`
  却没有任何 trace 记录时，会在包中给出 `missing_lean_traces` **提示**（当前为软门，不单独否决策包）。
- handoff（AGENTS §7 第 6 条）必须写明本批 trace 的路径与记录数；没有试错过程的批次要显式写
  "本批无验证试错，无 trace"，而不是留空。

### 8.6 与 §5 教训的关系

§5 的每条教训都应能指回产生它的 trace（`traces/lean/<subject>/<task-id>.jsonl` 的第
`attempt` 条）。写教训时带上这个回指，语料与知识才连成一条链；只有结论没有过程的教训，
在 review 时按证据不足处理。

### 8.7 演进

当前按"软门"落地（统计 + 提示，不单独否决策包），先积累一轮真实轨迹。当至少一个学科批次
产出可用语料后，由 Main 复核质量（字段完整度、失败尝试占比、叙述是否为"语义层面"）并决定
是否转为硬门。语料的价值在于**真实**；一旦为了过门而编造轨迹，整套机制就失去意义。

## 9. 派工上下文包（`sandrones-context-pack/1`）：轨迹的"观测"一半

### 9.1 为什么需要它

§8 让尝试留痕，记下的是**动作与反馈**。但训练一个下层 Agent 需要的是
**(观测, 动作, 反馈)**——观测就是派工时它拿到的上下文。缺了这一半：

1. "这个任务需要什么上下文"不是良定义的函数：同一任务两次派工拿到不同输入，学不到可迁移的东西；
2. **失败无法归因**：连续五次 `error`，到底是"没给前置引理的精确签名"、"没给 §2.7.1 的绝对值
   铁律"，还是"证明真的难"？没有注入记录，这三种在 trace 里长得一模一样；
3. 负责人每轮重新推导本该预计算的信息（ROADMAP 门、冻结签名、所有权边界、Playbook 适用节），
   在上下文压力下掉的就是最后加载的那几路。

**pack 是让 trace 变成训练样本的 join key**：包写 `pack_id`，每条 trace 记录带同一个 `pack_id`，
于是"给了什么上下文 → 试了什么 → 编译器回了什么"连成一条完整样本。

### 9.2 谁生成、何时生成

- **学科负责人在派工前**生成：`python3 scripts/context_pack.py build ...`，
  提交到 `traces/packs/<pack_id>.json`，把 pack 作为子 Agent 的**开工输入**。
- 唯一由人手写的字段是 `task.goal_nl`；其余全部从权威源**推导**，不允许负责人改写。
- 子 Agent 的每条 trace（§8）必须带同一个 `pack_id`。没有 pack 的批次要在 handoff 写明原因。

### 9.3 字段与推导来源（指针优先）

| 包内字段 | 推导自 |
|---|---|
| `ownership.writable` / `readonly` | `AGENTS.md` §3 的所有权规则（机器可读投影） |
| `prerequisites.entries` | `index/registry.json` 的 `premises` 传递闭包（按层） |
| `prerequisites.mathlib` | `registry.mathlib` |
| `target.declarations_in_file` | 目标 Lean 文件扫描（签名摘录 + 是否含 `sorry`） |
| `frozen.declarations` / `may_not_change` | 原型文件里的 `sorry` 声明（§0 sorry 框架法的落地点）；改签名即升级 |
| `playbook.sections` | 目标形状关键词 → 锚点 + 行号（**指回去读，不复制正文**） |
| `budget.max_attempts_per_goal` / `escalate_when` | §0 的五次试错硬规则 + 升级条件 |
| `scope.in_scope` / `out_of_scope` | ROADMAP 批次表按 family 前缀匹配的同族条目。**`out_of_scope` 就是本批明确不做的那部分**——派工边界不再靠提示词手写 |
| `pack_id` | `<学科>-<批次>-<Entry id>`；加了 `--worker` 则追加 `-<worker>`。**是 join key，必须唯一** |
| `task.worker` | `--worker` 的短标签（同一 Entry 派多个子 Agent 时用来区分，见 §9.4） |
| `trace.path` / `trace.schema` | §8；路径同样带 `-<worker>` 后缀，保证与 `pack_id` 一一对应 |

包里存的是**路径、id、行号与哈希**，不复制权威源内容（`AGENTS.md` §6 的派生文件纪律）。
`pack_sha256` 的口径是**除 `generated_at` 外、并自排除 `pack_sha256` 本身**——自排除是必须的
（哈希不能覆盖自己），但很容易漏；CA1 试点里一次手工重算就按"只排除 `generated_at`"算错了一个 pack，
而当时 `check` 只查字段存在、不校验值，所以没被发现。现在 `check` 会**真校验**，
计算入口只有 `scripts/context_pack.py` 的 `pack_sha()` 一个，不要在别处重写这段逻辑。

### 9.4 命令

```bash
# 已登记条目
python3 scripts/context_pack.py build --subject <学科> --batch <批次> --entry <Entry id> \
    --role subject-maintainer --goal-nl "<一句话目标>" \
    --prototype /tmp/<原型>.lean --out traces/packs/<pack_id>.json

# 计划中的新条目（首次派工时就还没登记 Registry，走 --new-entry 计划模式）
python3 scripts/context_pack.py build --subject <学科> --batch <批次> --entry <新 Entry id> \
    --new-entry --lean-file <Subject>/<File>.lean \
    --premises <已登记的前提 id,逗号分隔> --mathlib <候选名,逗号分隔> \
    --role sub-agent --goal-nl "<一句话目标>" --out traces/packs/<pack_id>.json

python3 scripts/context_pack.py show  --pack traces/packs/<pack_id>.json
python3 scripts/context_pack.py check traces/packs/*.json
```

**同一 Entry 派多个子 Agent 时必须加 `--worker`。** `pack_id` 默认是
`<学科>-<批次>-<Entry id>`，`trace.path` 也由 Entry 唯一决定；一个批次只有一个 Entry 却要派
两个 worker 时，两个 pack 会共用同一个 `pack_id`，join key 不再唯一——按 `pack.trace.path`
收轨迹会漏掉另一个 worker 的全部记录（CA1 试点实测：漏掉 14 条）。给后续 worker 加短标签即可：

```bash
python3 scripts/context_pack.py build --subject <学科> --batch <批次> --entry <Entry id> \
    --role sub-agent --worker verify --goal-nl "<该 worker 的目标>" \
    --out traces/packs/<pack_id>-verify.json
```

`--worker` 会把 `-<worker>` 追加到 `pack_id` 与 `trace.path` 之后，并把标签写进 `task.worker`。
`check` 现在会**直接报错**重复的 `pack_id`，`subject_package.py` 也会在 `packs` 块给出
`duplicate_pack_ids` 与 `trace_path_mismatch`（后者指 pack 的 `trace.path` 指向的文件里
没有任何带本 pack `pack_id` 的记录——消费方顺着指针收轨迹就会**静默漏样本**，
CA1 试点实测漏掉 14 条）。

`check` 校验必填字段，并比对 `AGENTS.md` §3 的所有权表是否漂移；
`subject_package.py` 会核对 trace 里引用的 `pack_id` 是否有对应 pack 文件。

计划模式下 `prerequisites.mathlib` 是**未验证的候选提示**（`mathlib_status: unverified_hint`），
不是已经确认的承载；`target.nl_file` 仍按 id→叙述层路径规范自动推导
（`commutative-algebra.module.definition` → `docs/entries/commutative-algebra/module/definition.md`），
所以包在建条目之前就把路径规范固定下来了。

### 9.5 诚实的边界（已知未解决）

**指针优先与上下文预算是冲突的。** 一个 32K 上下文的子 Agent 读不完十几个前置文件，
所以包最终需要一层**内联预算**：按依赖深度与距离选出 top-K 片段内联进包，其余留指针。
这一步**故意没做**——K 与排序规则要靠"先有一批带 `pack_id` 的真实样本"用数据选，
而不是拍脑袋定参数（与 §8.7 "先积累一轮真实轨迹"是同一条思路）。
在此之前，pack 只是**指针包**：它规定了"该读什么"，不代表子 Agent 真的读完了。

## 10. 并行窗口派工规程（Wave E 起）

本节规定**跨学科的派工方法**：Main 如何开窗、窗口简令从哪来、负责人对子 Agent 负什么责。
学科范围与状态一律以 ROADMAP 为准，本节不复制课程内容。

### 10.1 简令必须由脚本渲染，不许手写

派工输入是 **pack**（§9），不是一份散文简令。手写简令必然与 pack 漂移，而且等于把
"负责人不得改写"的字段（所有权、前提闭包、冻结签名、批次边界、Playbook 必读节、预算、
trace 路径、派工坐标）重新抄成第二份事实源——这正是 §9 要消灭的东西。

```bash
# 1) 先建 pack（派工坐标也写进 pack 的 dispatch 块）
python3 scripts/context_pack.py build --subject <学科> --batch <批次> --entry <Entry id> \
    --role subject-maintainer --worktree <绝对路径> --branch <分支> --base <基线 commit> \
    --brief docs/dispatch/<窗口>.md --goal-nl "<一句话目标>" \
    --new-entry --lean-file <Subject>/<File>.lean \
    --premises <已登记前提> --mathlib <候选名> --out traces/packs/<pack_id>.json

# 2) 再由 pack 渲染简令（窗口特有的判断放 --note 片段）
python3 scripts/dispatch_brief.py --window <窗口> --pack traces/packs/<pack_id>.json \
    [--pack …] --note docs/dispatch/notes/<窗口>.md --out docs/dispatch/<窗口>.md
```

- 简令里**从 pack 推导的部分**与**手写残量（`--note`）**分开成节，便于日后审计漂移；
- 简令与 pack 不一致时**以 pack 为准**，并重新生成简令；
- `--note` 只写无法从权威源推导的判断（例如"这条的难点是强度，容易退化成换个名字的包装"），
  不重抄范围表、所有权、前置——那些已经在 pack 里。

### 10.2 开窗前 Main 要做的四件事

1. **建 worktree 并接线**：`git worktree add ../sandrones-library-<slug> -b codex/<slug> main`，
   再把 `.lake/packages` 软链到主工作树（否则每个 worktree 复制一份 packages）。
   **不要**复制 `.lake/build`；学科只做定向构建，磁盘靠增量省。
2. **每个计划 Entry 建一个 pack**，并 `context_pack.py check` 通过。
   目标 Entry 尚未登记 Registry 时用 `--new-entry` 计划模式（此时 `prerequisites.mathlib`
   是 `unverified_hint`，明示"提示不是结论"）。
3. **确认文件所有权不重叠**：同一学科同时只设一个负责人；一个负责人带 2–3 个子 Agent，
   每个子 Agent 只拥有一组 `.lean` 与对应 `docs/entries/<family>/`。
4. **写 `--note` 片段**（唯一手写残量），然后渲染简令、提交，再派工。

### 10.3 负责人对子 Agent 的责任

- 派工前为**每个**子 Agent 生成 pack，`--role sub-agent --worker <短标签>`；
  不加 `--worker` 会让两个 pack 共用 join key，按 `pack.trace.path` 收轨迹会静默漏记录。
- **子 Agent 的"完成"不是验收**：负责人必须亲自复跑编译、逐条读数学陈述、核对公开签名四类归属，
  并**独立复核**子 Agent 报告的关键事实。CA1 试点里负责人正是靠独立复核抓出一处 docstring 事实错误。
- handoff 里必须写清"我亲自验了什么、哪些是采信子 Agent 的"。

### 10.4 研究窗与开发窗的区别

- `development_open`：交付 Lean 源码 + Entry 叙述层 + 可集成的 Registry 建议，跑五组门 + 两条软门；
- `research_open`：**不产生可集成交付**。出口是签名冻结提案 + `/tmp` 原型 + 接口契约与诚实边界。
  原型允许 `sorry`，但每个 `sorry` 必须列条目说明在等什么；只有全部消除后才能称为无占位原型。
  研究窗**不写 `SandronesLibrary/`**，
  报告里要显式写「本窗无 Lean 交付，故无 `subject_package` 五门」。
- 权限转换（`research_open` → `development_open`）**只能由 Main** 在验收研究窗 handoff 后宣布。

### 10.5 窗口报告格式（自包含，Main 不回看过程）

```
1. 现场：worktree／分支／基线／HEAD／提交数／工作区是否干净／磁盘
2. 交付：Entry 列表 + Lean 文件与行数 + 声明数 + 公理画像
3. 验证：定向 build 真实结果、聚合 #check、占位扫描、声明↔Entry 映射、git diff --check
4. pack 与 trace：pack_id 清单 + trace 路径 + 按 outcome 分类的记录数 + check 输出
5. subject_package 原文（含 traces／packs 两行；研究窗写"无"）
6. 子 Agent 与负责人审核发现（含退回或修复了什么）
7. 诚实边界：没做什么、哪些只是桥／foundation、哪些结论强度弱于教材
8. 协议反馈：pack 不够用之处、trace 记不下的东西、字段缺什么
```

### 10.6 三条不许

- **不许**为了报告好看而掩盖失败：轨迹里的 `error` 是资产，不是污点（CA1 批失败占 47%）。
- **不许**把 foundation／bridge 说成教材定理已完成；做不到就诚实登记强度。
- **不许**越界：不碰 `scope.out_of_scope` 的条目、不碰其他窗口的目录、不碰 Main 共享文件。

### 10.7 已固化的踩坑（开窗前负责人先看这几条）

- **候选接口名先实测再写，且由机械门禁兜底**：CA1 批按记忆写 `Ideal.ofSubmodule`、
  `AddMonoidHom.toLinearMap` 这些**不存在**的名字，白烧多轮编译。Wave E 更严重：Main 手写的
  10 个窗口定义里 **42 个候选有 13 个不存在（31%）**——多数只是命名空间写错（`Kernel.rnDeriv`
  应为 `ProbabilityTheory.Kernel.rnDeriv`，`AbsolutelyContinuousOn` 应为
  `AbsolutelyContinuousOnInterval`），少数是整个概念在 Mathlib 里没有承载
  （`GenContFract.of_sqrt`、`MeasureTheory.maximalFunction`），而后者恰恰是窗口最该提前知道的
  边界。现在 `scripts/open_window.py` 开窗前强制 `#check` 全部候选，不通过就不许开窗（§10.2）。
  负责人开工第一步仍要自己 `#check` 候选名，并写成 trace（§8.4）。
- **窗口简令必须覆盖窗口内全部 pack**：Wave E 的 `dispatch_brief.py` 曾在 §2–§8 只取 `packs[0]`，
  于是 6 个 Entry 的窗口里，简令只列了 **1/6** 条 trace 路径，只给第一个 Entry 的 Mathlib 候选
  与冻结声明——负责人照着写会漏记录，收轨迹时才发现。多 Entry 窗口的简令必须逐 pack 渲染或取
  并集。简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成（§10.1）。
- **隐式 binder + 嵌套 `And` 的匿名构造子**：别写裸 lambda，用 `refine ⟨_, ?_, ?_⟩` + 在 goal 上
  `intro`（§2.15，CA1 批 4 次复现）。
- **`#print axioms` 当 `sorryAx` 探针**：编译"大部分 ✔"不等于干净（§3.6）；
  但它对非 reducible 投影会**漏报**，那是漏报不是真零，禁止用投影改写伪装零公理（§3.5）。

### 10.8 有限上下文的分层注入（OpenCode 200K 窗口）

> **同日运行变更**：免费接口限流后，用户要求恢复 DSH 官方 DeepSeek API。
> 以下小胶囊、唯一 pack、独立子会话、分层读取和约 80K checkpoint 继续适用；
> OpenCode 的 Task、免费模型锁定、200K／预留 80K 参数仅描述此前运行。
> DSH 用 `subagent`，显式指定官方 provider/model，隔离全局保存默认；
> 按实际 `request/context` 确认容量与路由，再配置自动压缩，禁止照抄另一宿主的阈值。
> 切换前必须停止旧写者并保存各 worktree 现场，恢复既有成果，不能重新初始化覆盖。

2026-10-16 用户指定以官方 OpenCode 承载免费 `deepseek-v4.1-flash-free`。该窗口按 200K
容量配置，不沿用旧 DSH 的 300K 压缩门；运行时预留 80K 给输出与压缩，启用自动压缩。
负责人、worker 与标题／摘要／压缩等维护 Agent 均锁定同一免费模型，不设付费 fallback。

上下文按以下层次加载，**pack 仍为权威，运行胶囊只是可重建的派生索引**：

1. 启动只给一个胶囊路径。负责人胶囊列当前窗口、权限、现场 HEAD／既有修改与 worker 指针；
   worker 胶囊只列单项目标、独立 worktree、唯一 pack／trace／checkpoint 指针和少量前提定位。
   worker 胶囊不超过 8KB，不包含父对话、完整 Registry、整个学科源码或历史 session。
2. pack 由 `context_pack.py` 生成、校验并在派工前提交，按 §9 保持唯一 join key。
   不手改 pack；附加摘录须标源文件、行号与哈希，截断签名仅用于定位，不能冒充完整冻结签名。
   胶囊文件也须按完整 `pack_id` 唯一命名，并逐一核对目标 Entry、worktree、pack 哈希与 trace；
   只用窗口号加 worker 标签会在不同 Entry 共用标签时覆盖胶囊，必须在派工前拒绝这种映射。
3. 必读规程仍须读取一次。ROADMAP 按当前权限节与学科章节定位，Playbook 后续按 pack 锚点回查；
   不重复注入已读全文。源码／前提每次只向下展开一层，优先最多三个相关文件；单次读取输出控制在
   8KB／160 行以内，长反馈落文件后引用摘要与指针。
4. 使用独立 Task 子会话，向子 Agent 传单项胶囊指针，不转发负责人历史。子会话默认 cwd 可能
   继承负责人：worker 每次 shell 必须先进入其指定 worktree，写入使用绝对路径。
5. 约 80K 上下文先写简短 checkpoint，保存已证结论、失败路径、下一最小目标、精确 API、
   commit、pack 与 trace 指针；压缩后由 checkpoint 和当前 pack 恢复，不重放长对话。

派工验收须核对实际父子会话、实际 provider/model、启动输入大小与费用回执，不能仅相信配置。
胶囊外层没有改变 §9.5 的事实：pack 本体仍是指针包，收到指针也不代表已读取或已完成证明。
