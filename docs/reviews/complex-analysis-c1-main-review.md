# Main review: complex-analysis-c1

- branch: `codex/complex-analysis`
- reviewed_commit: `2b554a9a3545b7c2c4a42b9362626b70177b6f0c`
- reviewer: main
- verdict: `needs_changes`
- reviewed_at: 2026-08-24

## 已通过

1. 四个 C1 模块分别及联合构建通过：`Holomorphic`、`CauchyRiemann`、`PowerSeries`、
   `Elementary`，共 2503 个构建任务。
2. 临时聚合文件同时导入四模块并成功 `#check` 差商桥、开集上的全纯桥、CR 必要/充分方向、
   幂级数圆内全纯与逐项求导、局部对数全纯及指数右逆。
3. 定义层方向合格：`ComplexDifferentiableAtTextbook` 是去心邻域差商极限，
   `HolomorphicOnTextbook` 是逐点全邻域复可微；Mathlib 的 Fréchet 导数、形式幂级数和初等函数
   定理只作为显式桥或证明后端。
4. CR 充分性保留 `DifferentiableAt ℝ f z`，没有把不可微处 `fderiv` 的默认值误当充分条件；
   `HolomorphicOnTextbook ↔ DifferentiableOn` 的反向桥保留开集假设。
5. `python3 scripts/audit.py` 通过 285 个条目；在刷新基线 `Group` 构建缓存后，
   `python3 scripts/check_axioms.py --all` 通过。正式源码未发现禁用占位证明。

## 必须返工

### R1. 两篇课程文档不是精确八段模板

- `docs/entries/complex-analysis/holomorphic/elementary.md`
- `docs/entries/complex-analysis/holomorphic/power-series.md`

二者除 Playbook 规定的八个一级标题外，还各有一个额外的 `# 定义`，实际均为九段。学科 handoff
却声明“六篇文档均实质包含精确八段模板”，该验收结论与文件不一致。

验收方法：把 `# 定义` 中的实质内容语义合并到“陈述（自然语言）”“陈述（Lean 对照）”或
“自然语言 ↔ Lean 映射”，删除额外一级段；不得简单丢弃定义解释。两篇最终都必须只包含并按顺序
包含以下八个一级标题：

1. `# 动机`
2. `# 直觉`
3. `# 陈述（自然语言）`
4. `# 陈述（Lean 对照）`
5. `# 思维脉络（thinking trace）`
6. `# 自然语言 ↔ Lean 映射`
7. `# 依赖（人话版）`
8. `# 应用与陷阱`

### R2. 同步修正 handoff 的验证记录

`docs/handoffs/complex-analysis-c1.md` 当前把本批文档描述成已经通过精确八段验收。完成 R1 后，
请把记录改为真实的返工后检查结果，并列出本 review 的处理状态与修复提交。

### R3. 提交 review 处理闭环

保留本文件全部 Main 意见，在“学科负责人处理记录”中逐项填写 `resolved`、
`declined with reason` 或 `still blocked`，把 review、两篇文档和 handoff 修订一同提交。

## 可选择降级的接口

本轮没有要求降低 Lean 数学结论强度；问题只在叙述模板和 handoff 验证记录。若负责人在复核时
发现自然语言强于定理，应同步降低文档，而不是扩张本批源码范围。

## 不得越过的边界

- 当前分支尖端 `530a862` 的 `PathIntegral`、`CauchyFormula`、`Liouville` 及 C2 文档不在本次
  C1 review 范围；不得把 C2 成果写入 C1 处理记录或 handoff。
- 不修改 main 共有 `SandronesLibrary.lean`、Registry、自动索引、RADAR、ROADMAP 或 Playbook。
- 不把 C1 局部构建描述为 main 全库构建。

## 要求重跑的验证

```bash
lake build SandronesLibrary.ComplexAnalysis.Holomorphic \
  SandronesLibrary.ComplexAnalysis.CauchyRiemann \
  SandronesLibrary.ComplexAnalysis.PowerSeries \
  SandronesLibrary.ComplexAnalysis.Elementary
lake env lean /tmp/sandrones-complex-c1-main-review.lean
python3 scripts/audit.py
python3 scripts/check_axioms.py --all
git diff --check
git status --short
```

另需自动核对六篇 C1 文档的八个精确一级标题、顺序和段落非空。

## 学科负责人处理记录

- R1：`resolved`。删除 `elementary.md`、`power-series.md` 的额外 `# 定义` 一级标题，将两处定义
  解释分别并入“陈述（自然语言）”与“陈述（Lean 对照）”；六篇 C1 文档的精确标题、顺序和
  非空性已重新自动核对。
- R2：`resolved`。`docs/handoffs/complex-analysis-c1.md` 已改为记录 Main 发现的问题和返工后的
  实际检查结果，不再把返工前状态描述为已通过。
- R3：`resolved`。本 review 原意见完整保留；本文件、两篇文档与 handoff 修订由同一个返工提交
  交付。修复提交为包含本处理记录的当前提交（见 `codex/complex-analysis` 分支 `git log`）。
- 数学接口：无降级、无扩张；C2 文件未纳入或修改。

## Main 复验结论

- rechecked_commit: `cce0c385b31651eb4f6994496c3526228bfcb0cd`
- verdict: `accepted`
- rechecked_at: 2026-08-24
- 复验结果：四个 C1 模块联合构建通过；六个 Entry 的源码、文档与定义层一致；两篇返工文档均已恢复为精确八段模板；正式源码无禁用占位证明，`git diff --check` 通过。
- 接收边界：本结论只接受 C1 提交 `2b554a9` 与 C1 闭环提交 `cce0c38` 中属于 C1 的文件；不包含提交 `530a862` 的 C2 内容。
