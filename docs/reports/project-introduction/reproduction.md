# 复现与审计附件

正文以数学解释和工作方法为主。这里保存执行规程、事实截止点及审计发现，供复现者查阅。

# 9　验收流水线：从局部证明到 Main 与论文报告

仓库的责任分层可以直接用于论文批次。以下命令来自当前规程；模块构建、公理记录、语义审核和论文覆盖各自保留证据，不能互相替代。[S2–S3、S9–S10]

**子 Agent 门。** 在自己的 worktree 编译最小修改模块；在隔离临时文件内查询新增公开声明、公理和必要实例。扫描 `sorry/admit/sorryAx/native_decide` 与额外公理。文本搜索只是辅助，仍需核对正式声明和真实依赖。通过后提交自己的文件与局部验证记录。

**学科负责人门。** 复查每个核心概念的定义—刻画—桥—使用者链；编译批次全部模块及依赖闭包。临时聚合文件联合导入并 `#check` 关键声明，必要时增加实际调用，检查实例冲突与组合兼容性。确认独立语义审核的问题已经处理，并写成一个 handoff。负责人不运行全库 `lake build`。

**Main 门（现行规程）。** 核对基线、提交、所有权与语义 diff；接收数学合格提交，再整理共享文档、imports、Registry、文献和 Examples 需求。未来分层架构改变常规审核的执行位置，但最终发布仍必须保留以下门。按 AGENTS 顺序运行：

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

公理探测依赖已构建的导入模块；学科闭包与 Main 的必要定向重建应确保探测对应当前源码。默认公理检查会增量跳过匹配指纹的文件，不能报告为全部声明刚刚重新探测。需要独立全量复验时使用 `--full`，具体范围由验收计划记录。最终完整 `lake build` 只由 Main 在共享集成完成后执行。

## 验证收据与最终验收包

每次命令保存执行目录、提交、Lean 与依赖版本、命令参数、开始结束时间、退出码、日志哈希、被检查声明和范围。区分进程失败、查询解析失败、警告与合格结果；任何“跳过”都需要说明原因，不能替代通过。保留实际 linter warnings，不把要求写成当前已经“零警告”。

最终包包括：论文版本与范围清单、逐声明对齐记录、Lean 源码提交、关键公开类型、证明路线、依赖和公理报告、局部与 Main 构建收据、语义审核闭环、覆盖表、复现指令和未完成边界。Main 提交后的下一批必须同步最新 Main，再重跑受影响接口。

统一 verdict 为 `accepted`、`accepted_main_docs`、`needs_changes`、`blocked`。`accepted_main_docs` 只表示数学通过、Main 规范整理尚未完成；它既不意味着论文所有声明都完成，也不意味着最终 Main 集成已经完成。论文覆盖结论必须另外绑定具体范围与最终提交。

# 10　现场发现、实施顺序与证据索引

项目已有可复用资产与规程；关键增量是**版本契约、语义对齐、分层审核和自动发布**。接口约定需要专家判断，扩容需要审核能力与队列数据；都不能仅靠增加证明 Agent 解决。

## 本次现场取得的证据与局限

`audit.py` 对 565 条记录检查通过。源码显示它主要检查 id、路径、文件存在、部分 front matter、BibTeX 字段、依赖 DAG 和反向缓存；**没有实现一般自然语言—Lean 语义判定、完整签名等价检查或实际证明依赖提取**。例如 ε–N 条目文档的 `kind` 为 `definition`、`mathlib` 为两个名字，Registry 则为 `theorem`、空列表，此差异没有阻止审计通过。它说明字段核验有缺口，不说明该条 Lean 桥证明错误。[S7、S10]

565 条记录中，563 条 `proof_sha` 与关联源文件当前短指纹匹配；另两条为 `linear-algebra.vector-space.dimension`、`real-analysis.riemann.cont-integrable`。未匹配应触发定向检查，不能直接判断数学真伪。本次强制复验了 ε–N Entry 的公理，另对桥和使用者进行了接口探测；没有重新运行全库验收，也没有修订既有条目。

现行硬门要求占位草稿隔离到 `/tmp`，数学审核不能被结构审计替代。`check_axioms.py` 使用固定临时 probe 路径；并行前须隔离或串行。旧 SCHEMA 的家族自动选变体设计不代表已经实现，更不能按调用次数选择语义接口。

## 建议按四个可验收增量实施

1. **接口与论文试点。** 选同名多版本定理和已解锁论文候选，冻结 3–6 项声明；完成来源、契约、关系证据与语义审核，分歧有记录。
2. **证据与控制器。** 严格核对条目字段，导出实际类型；实现 DAG、隔离 worktree／probe、所有权和失效传播。无日志、缺声明或版本错配必须失败。
3. **分层集成试点。** 先 RFC 明确学科审核责任与 Main 例外边界，再实现验收包 schema、共享状态单写者与候选合并队列；验证失效、冲突和失败拆包能闭环。
4. **分级负载演练。** 以同一冻结范围测试 10／30／100 worker，记录资源、审核积压、等待与覆盖；稳定后再试 300 worker。若专家审核饱和，先补审核与契约复用能力。本次没有实施或测量该架构。


## 证据索引

**仓库文件（均以 `b2cd090` 为事实截止点）。**

- **S1–S3：** `README.md`；`AGENTS.md`；`docs/LEAN-PLAYBOOK.md`。
- **S4–S6：** `docs/INGESTION_PROTOCOL.md`；`docs/ROADMAP-LONGTERM.md` §1、§15.3；`docs/SCHEMA.md`。
- **S7：** `SandronesLibrary/Analysis/Sequence.lean` 第 35–99 行与对应 Entry 文档。
- **S9：** `docs/roles/MAIN-ROLE.md`、`SUBJECT-MAINTAINER-ROLE.md`、`SUBJECT-MAINTENANCE-ROLE.md`。
- **S10–S11：** `scripts/audit.py`、`check_axioms.py`、`update_dependency_graph.py`；`SandronesLibrary/LinearAlgebra/MatrixSVD.lean` 与 SVD Entry 文档。人类证明审阅另见 `docs/LEAN-TACTIC-REVIEW-GUIDE.md` 及 `LEAN-TACTIC-STATE-ATLAS.md`。
- **S12：** `SandronesLibrary/FunctionalAnalysis/HahnBanach.lean` 与 `docs/entries/functional-analysis/hahn-banach/extension.md`。三种声明及等范数到不增范数的推论以源码为准。
- **S13–S15：** `docs/DESIGN.md`；`docs/LEAN-TACTIC-REVIEW-GUIDE.md` 与 `docs/LEAN-TACTIC-STATE-ATLAS.md`；`docs/MATHLIB-RADAR.md`、`docs/entries/README.md` 与 `scripts/gen_entries_index.py`。

**外部一手资料（2026-10-10 检索）。**

- **E1–E3：** Lean 官方 [The Type System](https://lean-lang.org/doc/reference/latest/The-Type-System/)、[Tactics](https://lean-lang.org/theorem_proving_in_lean4/Tactics/)、[Axioms and Computation](https://lean-lang.org/theorem_proving_in_lean4/Axioms-and-Computation/)。用于说明证明项、策略和公理边界。
- **E4：** Eckart & Young (1936), *Psychometrika* 1(3):211–218，[出版者条目](https://www.cambridge.org/core/journals/psychometrika/article/approximation-of-one-matrix-by-another-of-lower-rank/B29672E1EDD0FA1B7611D4DFAFC321B3)，DOI 10.1007/BF02288367。仅核验书目信息与摘要，未将其视为原文全文审核。
- **E5–E6：** Mathlib 社区 [Contributing to mathlib](https://leanprover-community.github.io/contribute/index.html)，支持专家分散审核和独立依赖仓库的实践参考；GitHub 官方 [Managing a merge queue](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue)，支持基于最新目标分支的候选组检查。本文的扩展架构是设计推导，非这些来源的性能结论。
- **E7：** [Loogle 源码与使用说明](https://github.com/nomeata/loogle)及[查询语法](https://github.com/nomeata/loogle/blob/master/blurb.html)，支持按名称、常量、类型模式及结论形状搜索的工具参考。检索服务的多视图融合、定理卡片和评价流程为本文计划。
