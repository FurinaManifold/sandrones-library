# number-theory / N1plus 学科 handoff

> 窗口：E3 `number-theory / N1plus`（`docs/dispatch/e3-nt-n1plus.md`）
> worktree：`/home/pisquare/czt/sandrones-library-nt-n1plus`｜分支 `codex/number-theory-elementary-plus`
> 基线 `bc8d4fe`｜角色 `subject-maintainer`

## 1. 现场

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-nt-n1plus` |
| 分支 | `codex/number-theory-elementary-plus` |
| 基线 | `bc8d4feb59f639aa440d7719466297d918e9dd28` |
| HEAD | 见 §5 subject_package 原文首行 |
| 提交数 | 见 §5 |
| 工作区 | 交付前 `git status --short` 为空（见 §5 cleanliness） |
| 同步 Main | 未同步（本窗基线即 Main 派工时的 `bc8d4fe`；未 push、未 rebase） |

## 2. 交付

范围：本窗 4 条 Entry（`docs/dispatch/e3-nt-n1plus.md` §1 的范围表）。

<!-- 交付表：Entry / Lean 文件 / 行数 / 声明数 / 公理画像 / 强度 -->

## 3. 验证

<!-- 定向 build、聚合 #check、占位扫描、声明↔Entry 映射、git diff --check -->

## 4. pack 与 trace

<!-- pack_id 清单、trace 路径、outcome 分布、lean_trace check 输出 -->

## 5. subject_package 原文

```
（交付前粘贴 python3 scripts/subject_package.py --worktree <本 worktree> --base bc8d4fe --subject number-theory 的原文，含 traces／packs 两行）
```

## 6. 子 Agent 与负责人审核发现

<!-- 三个子 Agent 的分工、我亲自复验了什么、采信了什么、退回/修复了什么 -->

## 7. 诚实边界

<!-- 哪些只是 foundation／bridge、哪些结论强度弱于教材、没做什么 -->

## 8. 协议反馈

<!-- pack 不够用之处、trace 记不下的东西、字段缺什么 -->

## 附：共享文件更新建议（只建议，不改）

- `SandronesLibrary.lean`：在本窗 4 个模块交付后按依赖顺序追加
  `import SandronesLibrary.NumberTheory.Elementary.ConvergentBest`、
  `...SqrtPeriodicCF`、`...PellCFBridge`、`...PellAllPositive`（当前根模块只到
  `Elementary.Pell`，见 `SandronesLibrary.lean` 第 19 行）。
- `index/registry.json`：追加本窗 4 条 Entry 记录（建议见 §9）。
- `reference.bib`：无需新增，4 条都用已存在的 `hardy-wright-number-theory-2008`。
- `docs/ROADMAP-LONGTERM.md` §11 N1+ 表：按实际交付强度更新第 1–4 行的状态与「剩余边界」；
  第 5 行 `negative-pell` 本窗未做，保持未开始。

## 附：Registry 建议（Main 侧合并后跑 `check_axioms.py --all --fix` 生成 `axioms`／`proof_sha`／`dependedOnBy`）

`number-theory.elementary.pell-all-positive`（本条目已由负责人亲自交付并复验）：

```json
{
  "id": "number-theory.elementary.pell-all-positive",
  "kind": "theorem",
  "state": "verified",
  "title": "正 Pell 方程全体正解的分类",
  "summary": "每个坐标非负的正解都是基本解的 Brahmagupta 幂，反之基本解的幂都是正解",
  "premises": [
    "number-theory.elementary.pell-equation",
    "number-theory.elementary.pell-composition",
    "number-theory.elementary.pell-positive-existence",
    "number-theory.elementary.pell-fundamental-solution"
  ],
  "mathlib": [
    "Pell.Solution₁",
    "Pell.Solution₁.mk",
    "Pell.Solution₁.ext",
    "Pell.Solution₁.x_mul",
    "Pell.Solution₁.y_mul",
    "Pell.Solution₁.x_pow_pos",
    "Pell.Solution₁.y_pow_succ_pos",
    "Pell.IsFundamental",
    "Pell.IsFundamental.eq_pow_of_nonneg",
    "Pell.IsFundamental.subsingleton"
  ],
  "provenance": { "source_type": "book", "ref": "hardy-wright-number-theory-2008" },
  "lean_file": "NumberTheory/Elementary/PellAllPositive.lean",
  "nl_file": "docs/entries/number-theory/elementary/pell-all-positive.md",
  "added_by": "codex-nt-n1plus",
  "added_at": "2026-10-14T00:00:00Z"
}
```

`axioms`（负责人用 `#print axioms` 实测，非生成器）：`["Classical.choice", "Quot.sound", "propext"]`。

<!-- 其余 3 条 Entry 的 Registry 建议：待子 Agent 回报后补 -->
