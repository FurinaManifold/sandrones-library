# Handoff：number-theory / 批次 `N2res`（研究窗：N2.4–N2.15 签名冻结提案）

- 学科：数论（number-theory）
- 批次：`N2res`（ROADMAP §11 N2 表第 4–15 行；开发权限 **`research_open`**）
- 分支：`codex/number-theory-algebraic-research`
- worktree：`/home/pisquare/czt/sandrones-library-nt-n2-research`
- 基线：`bc8d4feb59f639aa440d7719466297d918e9dd28`
- 窗口简令：`docs/dispatch/e4-nt-n2-research.md`（脚本从 pack 渲染）
- 窗口 pack：`traces/packs/number-theory-N2res-number-theory.algebraic.norm-trace.json`
- 交付状态：文档与语料已提交，**未 push**

> **本窗无 Lean 交付，故无 `subject_package` 五门**（Playbook §10.4）。本窗不写
> `SandronesLibrary/` 下任何正式文件、不改 Registry、不碰 N1+ 与 N3。

---

## 1. 范围与出口

按简令 §9 与 pack `task.goal_nl`：为 N2.4–N2.15 给出**签名冻结提案 + 无占位 `/tmp` 原型 +
接口契约 + 诚实边界**。起点是已集成的 N2.1–N2.3。

主要产物：`docs/maintenance/number-theory-n2-signature-freeze-rfc.md`（RFC，597 行）。

## 2. 交付清单

| 类型 | 路径 | 说明 |
|---|---|---|
| RFC | `docs/maintenance/number-theory-n2-signature-freeze-rfc.md` | 依赖链判定、逐条目强度表、N2.4–N2.12 签名冻结提案、N2.13–15 教材门判定、接口契约、诚实边界、协议反馈 |
| handoff | 本文件 | |
| trace | `traces/lean/number-theory/number-theory.algebraic.norm-trace.jsonl` | 负责人 21 条 |
| trace | `traces/lean/number-theory/number-theory.algebraic.dedekind-chain.jsonl` | 子 Agent `chain` 13 条 |
| trace | `traces/lean/number-theory/number-theory.algebraic.prime-decomposition-geom.jsonl` | 子 Agent `geom` 17 条 |
| trace | `traces/lean/number-theory/number-theory.algebraic.valuation-local.jsonl` | 子 Agent `local` 16 条 |
| pack | `traces/packs/number-theory-N2res-number-theory.algebraic.norm-trace.json` | 窗口 pack（Main 生成） |
| pack | `traces/packs/number-theory-N2res-number-theory.algebraic.dedekind-chain.json` | 子 Agent `chain` |
| pack | `traces/packs/number-theory-N2res-number-theory.algebraic.prime-decomposition-geom.json` | 子 Agent `geom` |
| pack | `traces/packs/number-theory-N2res-number-theory.algebraic.valuation-local.json` | 子 Agent `local` |
| 原型（/tmp，不提交） | `/tmp/sandrones-library/{normtrace,chain,geom,local}/*.lean` | 14 个原型，全部 exit 0、零 `sorry` |

**未写**：`SandronesLibrary/**`（0 文件）、`index/**`、`reference.bib`、`docs/entries/**`、
`docs/ROADMAP-*.md`、`docs/LEAN-PLAYBOOK.md`、`SandronesLibrary.lean`。

## 3. 验证（负责人亲自执行）

1. **原型复跑**：14 个原型逐个 `lake env lean <文件>`（在 worktree 根目录，`.lake/packages` 软链到
   主工作树）→ **全部 exit 0**；`grep -E '\bsorry\b|admit|native_decide'` 只命中
   `local/Valuation.lean` 第 8 行注释文字，**无真实占位**。
2. **公理画像**：`normtrace/AxiomProbe.lean` 对 N2.4 的 19 条声明跑 `#print axioms` →
   19/19 为 `[propext, Classical.choice, Quot.sound]`，**无 `sorryAx`**（本窗未做 choice 最小化）。
3. **trace 校验**：`python3 scripts/lean_trace.py check traces/lean/number-theory/` → 通过；
   `summary --subject number-theory` → 4 个任务、67 条尝试（accepted 28 / error 38 / sorry_left 1）。
4. **pack 校验**：`python3 scripts/context_pack.py check traces/packs/*.json` → 通过（6 个 pack）。
5. **`git diff --check`**：见 §5（提交前执行）。
6. **未做**：`lake build`（本窗禁止）、全库 `subject_package`（研究窗无五门）、Registry/audit
   （不改共享文件）。

## 4. 子 Agent 与负责人审核发现

派工前为每个子 Agent 生成 pack（`--role sub-agent --worker <标签>`），三条硬规程均遵守。
子 Agent 的"完成"不等于验收：**负责人逐个复跑原型、逐条复核关键 `#check` 事实**。

| 子 Agent | 覆盖 | 结论 | 负责人独立复核了什么 |
|---|---|---|---|
| `chain` | N2.6–N2.9 | N2.6 `course-strength`（可组装）；N2.7 `course-strength`（定义层）；N2.8 **桥已真证**；N2.9 混合（有限性只能 foundation/bridge） | 复跑 5 个文件；复核 `IsDedekindDomain` 实例源码路线（`IntegralClosure.lean:220` 走 going-up）；复核 `Ring.HasFiniteQuotients` 范数路线；确认 `ideal_factorization_frozen_signature` 真证 |
| `geom` | N2.10–N2.12 | 三条 `course-strength`（N2.12 同形陈述是 `bridge`） | 复跑 3 个文件；复核 deprecated import、`Fintype (primesOver)` 需 `p.IsMaximal`、`∃!` vs `≃*`、凸体定理与非分歧判据的精确签名、`regulator` 的 import 闭包 |
| `local` | N2.13–N2.15 | 三条全 `blocked`（教材门），附门后草案 | 复跑 3 个文件；复核 `IsNonarchimedeanLocalField` 全库零实例、`Padic` 是 `CauSeq.Completion` 构造、`IsDiscreteValuationRing ℤ_[p]`／`CompactSpace ℤ_[p]`／`CompleteSpace ℚ_[p]`、ROADMAP 行 1453/1451/1455–1456 原文 |

**负责人修正/退回**：

1. 去信要求 `chain` 整改 trace 义务（发现 11:07–12:06 约 16 轮编译未实时留痕）；该 worker 改用
   「编译 + 立即 append」脚本，并在 FINDINGS 里披露缺口、**未事后重建**。
2. 发现 `local` worker 报告的一处**事实性偏差**（`CompactSpace ℤ_[p]` 在我最初的 import 组合下
   合成失败）：复核后确认是该 worker 的 import 路径不同，其结论成立，我的首轮探针缺 import。
   该偏差记入负责人 trace（第 20 条）。
3. 修正 `chain` 对 N2.6 的表述精度：`DimensionLEOne.of_isIntegral` 是 **going-up** 路线，
   教材**范数论证**对应 `Ring.HasFiniteQuotients` 路线——两条都写进 RFC §4.3。
4. 修正 RFC 初稿的依赖图：N2.10 的真正前置是 N2.3+N2.6（不是 N2.8）；N2.9 有限性是 N2.11 的
   下游（编号顺序 ≠ 依赖顺序）。
5. 未采信任何"原型零 sorry"的自述：14 个文件全部由负责人复跑。

## 5. 现场与提交

（提交后由本文件的最后一次 amend/后续提交固定；见 `git log --oneline`。）

| 项 | 值 |
|---|---|
| 分支 | `codex/number-theory-algebraic-research` |
| 基线 | `bc8d4fe` |
| HEAD | 见 §5 末尾 commit 列表 |
| 提交数 | 1（本窗成果单一提交） |
| 工作区 | 干净（`git status --short` 无输出） |
| `git diff --check` | 通过 |

## 6. 共享文件更新建议（Main 侧，本窗不改）

1. `docs/ROADMAP-LONGTERM.md` §11：N2.4–N2.12 的权限可由 `research_open` 转 `development_open`
   的条件建议按 RFC §2 的批次 A/B/C 分批宣布；N2.13–N2.15 维持 `research_open`（教材门未解除）。
2. `docs/LEAN-PLAYBOOK.md` §8.5／§2／§5：建议收录 RFC §8 的协议反馈第 8–10 条（module `public`
   陷阱、`∃!` β-redex、`rw [← finprod]` 的 motive 问题、「编译+立即 append」脚本模式）。
3. `scripts/context_pack.py`：建议支持研究窗 `--covers`，并对 `prerequisites.mathlib` 做存在性预检。
4. `reference.bib`：若要让 N2.13–N2.15 解锁，需 Main 指定局部域／p-进专题教材（现有 73 条不含）。

## 7. 诚实边界

1. **本窗无 Lean 交付**：14 个原型全在 `/tmp`，仓库内没有一行 `SandronesLibrary/` 代码；
   **没有 `subject_package` 五门**（研究窗不适用）。
2. **原型 ≠ 可集成**：只跑 `lake env lean` 单文件，**未跑 `lake build`**，未做 Entry 文档、
   Registry 登记、narrative 层与依赖闭包构建。
3. **哪些是转述**：N2.4 的嵌入公式、N2.5 的 `discr_ne_zero`、N2.12 的秩公式等属「Mathlib 定理
   加教材包装」；RFC §7 已逐条列出，Entry 文档不得声称是本库贡献。
4. **哪些证明链未复现**：迹形式／对偶基 Noetherian、going-up、`absNorm` 数商环、**Minkowski
   格点／凸体定理**、`Ideal.uniqueFactorizationMonoid` 构造——共 5 条。
5. **N2.13–N2.15 不得开工**：教材门（ROADMAP 行 1453 等）未解除；Mathlib 有 `Padic` 不等于
   课程已备。
6. **未验证项**：`disc ≡ 0,1 (mod 4)`、`𝓞_K^×` 的 `±1` 判据、类数计算、Ireland–Rosen 章节号。

## 8. 协议反馈（摘要，全文见 RFC §8）

1. pack 的 `scope.in_scope`（单 Entry）与 `goal_nl`（覆盖 N2.4–N2.15）自相矛盾；
2. `prerequisites.mathlib` 是未验证提示，`LocalField` 这个错名让子 Agent 白烧一轮；
3. trace `outcome` 粒度太粗（22 条探针 1 条失败即 `error`）；
4. `lean_trace.py` 的 `check`（位置参数）与 `summary`（`--subject/--root`）接口不一致；
5. trace 就地更正缺少 `amended` 字段；
6. 「边做边写」需要可观测强制点（原型 mtime 晚于最后 trace 应报软警告）；
7. 研究窗缺一个 `--research` 只读自检（trace 计数 + pack_id 闭合 + 原型 `sorry` 扫描）。
