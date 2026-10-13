# F6.6b1 预解被积函数 handoff

- 分支：`codex/functional-analysis-f66b1`
- worktree：`/home/pisquare/czt/sandrones-library-functional-analysis`
- 权限：`main-f66-resolvent-integrand-development-open.md` / `development_open`
- Entry：`functional-analysis.functional-calculus.resolvent-integrand`
- 同步基线 Main：`a621303`（`docs(main): dispatch Wave D D1/D2/D5 subject maintainers`），worktree 自该提交净新开工
- 旧分支处置：按 ROADMAP D-3，`codex/functional-analysis-restart`、`codex/functional-analysis` 未合并、未删除、未作为基线
- 学科提交：本文件所在提交（见下方 `git log` 与最终报告）

## 1. 范围与成果

正式源码（新文件，未改动任何既有泛函模块）：

- `SandronesLibrary/FunctionalAnalysis/HolomorphicResolventIntegrand.lean`

课程文档初稿（新文件）：

- `docs/entries/functional-analysis/functional-calculus/resolvent-integrand.md`

公开声明（全部无 `sorry` / `admit` / `sorryAx` / `native_decide`）：

| 声明 | 内容 |
|---|---|
| `resolvent_sub_resolvent_same` | 第一预解恒等式：`resolvent a z - resolvent a w = (w - z) • (resolvent a z * resolvent a w)`（`z,w ∈ resolventSet ℂ a`） |
| `resolvent_mul_comm` | 同一元素两参数预解元乘法交换，无预解集假设 |
| `resolvent_sub_resolvent_same_mul_comm` | 第一预解恒等式的另一乘积次序形式 |
| `differentiableOn_resolvent` | `resolvent a` 在 `resolventSet ℂ a` 上复可微 |
| `differentiableAt_resolvent` | 预解集内逐点复可微 |
| `analyticOnNhd_resolvent` | `resolvent a` 在预解集上全纯（`AnalyticOnNhd ℂ`） |
| `continuousOn_resolvent` | `resolvent a` 在预解集上连续 |
| `resolventIntegrand` | Dunford 被积函数 `fun z ↦ f z • resolvent a z` |
| `differentiableOn_resolventIntegrand` | `DifferentiableOn ℂ f U →` 被积函数在共同有效开集 `U ∩ resolventSet ℂ a` 上复可微 |
| `continuousOn_resolventIntegrand` | 同上开集上连续 |
| `HolomorphicOnNhdSpectrum.resolventIntegrand_differentiableOn` | 从本库 `HolomorphicOnNhdSpectrum a f` 出发的复可微存在陈述 |
| `HolomorphicOnNhdSpectrum.resolventIntegrand_continuousOn` | 从 `HolomorphicOnNhdSpectrum a f` 出发的连续存在陈述 |
| `integrableOn_resolventIntegrand_compact` | 紧集 `K ⊆ U ∩ resolventSet ℂ a` 上 `IntegrableOn … K volume`（Mathlib Bochner 积分） |

## 2. 路线问题（ROADMAP §Wave D「每个学科 handoff 必须回答的路线问题」）

1. **本批打开或依赖哪个门。** 本批不新开门；它推进 ROADMAP Wave D D2 的 F6.6b1
   `development_open` 窗口：预解恒等式、预解集上全纯性、Dunford 被积函数。它不打开 F6.6b2
   （完整 Dunford 演算，仍 `research_open`），F6.6b2 需要复分析 D1 冻结的公共有限 cycle / 绕数 /
   Banach 值路径积分 carrier。
2. **公共定义由哪个文件拥有，哪些 Mathlib 名称只是私有桥或证明后端。** 本批唯一公共新定义
   `resolventIntegrand` 由 `SandronesLibrary/FunctionalAnalysis/HolomorphicResolventIntegrand.lean`
   拥有；`HolomorphicOnNhdSpectrum` 仍由已集成的 `HolomorphicNeighborhood.lean` 拥有，本批只消费。
   Mathlib 名称的角色：
   - 语义一致的正式承载（出现在公共签名）：`resolvent`、`resolventSet`、`spectrum`、
     `DifferentiableOn`、`AnalyticOnNhd`、`ContinuousOn`、`IsCompact`、`IntegrableOn`、`volume`、
     `Ring.inverse`（经 `resolvent_eq_ringInverse` 桥说明）。
   - 私有证明后端（不出现在公共签名）：`Ring.inverse_sub_inverse`、
     `Commute.ringInverse_ringInverse`、`Algebra.commute_algebraMap_left`、
     `spectrum.hasDerivAt_resolvent_const_left`、`spectrum.isOpen_resolventSet`、
     `DifferentiableOn.smul`、`DifferentiableOn.analyticOnNhd`、
     `ContinuousOn.integrableOn_compact`。
   - 没有本库特殊定义的桥侧接口，也没有超出课程层级的公开泄漏。
3. **子 Agent 的所有权、提交、退回问题。** 见 §6。
4. **联合导入测试与关键 `#check`。** 见 §4。
5. **下一批可稳定依赖的公开 API。** 见 §7。
6. **建议 Main 更新的 imports / Registry / RADAR / ROADMAP 与诚实边界。** 见 §8 与 §9。

## 3. 概念清单（教材语义 / 正式承载 / 展开 / Mathlib 角色 / 使用者 / Entry）

| 概念 | 教材语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 预解集 | `z·1-a` 可逆的 `z` | Mathlib `resolventSet ℂ a` | `spectrum.mem_resolventSet_iff`；本库 `mem_resolventSet_iff_isUnit` | 语义一致，直接复用 | `resolvent_sub_resolvent_same` | `functional-analysis.spectrum.definition`（既有） |
| 预解算子 `R(z,a)` | `(z·1-a)⁻¹` | Mathlib `resolvent a z` | `resolvent_eq_ringInverse`、`spectrum.resolvent_eq` | 语义一致；`Ring.inverse` 在集外约定为零 | `differentiableOn_resolvent` | 本条 + `functional-analysis.spectrum.definition` |
| 第一预解恒等式 | `R(z)-R(w)=(w-z)R(z)R(w)` | 本库 `resolvent_sub_resolvent_same` | 陈述本体；由 `Ring.inverse_sub_inverse` 证明 | 本库新增，Mathlib 仅有第二恒等式 `spectrum.resolvent_sub_resolvent` | `resolvent_sub_resolvent_same_mul_comm` | 本条 |
| 预解元交换性 | 同元素不同点预解元可交换 | 本库 `resolvent_mul_comm` | 等式本体 | 由 `Commute.ringInverse_ringInverse` 证明；Mathlib 无此陈述 | `resolvent_sub_resolvent_same_mul_comm` | 本条 |
| 复可微／全纯 | 开集上复可微即全纯 | `DifferentiableOn ℂ`、`AnalyticOnNhd ℂ` | `DifferentiableOn.analyticOnNhd` | 语义一致，直接复用 | `analyticOnNhd_resolvent` | 本条 |
| Dunford 被积函数 | `z ↦ f z • R(z,a)` | 本库 `resolventIntegrand` | 定义本体（`f • resolvent a`） | 只组装标量函数与预解映射；不新建积分结构 | `differentiableOn_resolventIntegrand` | 本条 |
| 谱邻域全纯输入 | `∃ U 开, spectrum ⊆ U, f 在 U 全纯` | 本库 `HolomorphicOnNhdSpectrum` | 定义量词展开 | 既有条目，直接消费 | `HolomorphicOnNhdSpectrum.resolventIntegrand_differentiableOn` | `functional-analysis.functional-calculus.holomorphic-neighborhood`（既有） |
| 紧集 Bochner 可积 | 连续 + 紧 + 局部有限测度 ⇒ 可积 | Mathlib `IntegrableOn` | `ContinuousOn.integrableOn_compact` | 语义一致，直接复用 | 未来 F6.6b2 沿紧路径积分 | 本条 |

## 4. 定义链组装测试

临时聚合文件 `/tmp/f66b1-aggregate.lean`（非交付）同时 `import
SandronesLibrary.FunctionalAnalysis.HolomorphicResolventIntegrand`，并 `#check`：

- 正式承载：`resolventIntegrand`、`resolvent`、`resolventSet`、`HolomorphicOnNhdSpectrum`；
- 展开／刻画：`resolvent_sub_resolvent_same`、`resolvent_mul_comm`、
  `resolvent_sub_resolvent_same_mul_comm`、既有 `resolvent_eq_ringInverse`；
- 必要桥：`differentiableOn_resolvent`、`differentiableAt_resolvent`、`analyticOnNhd_resolvent`、
  `continuousOn_resolvent`、`differentiableOn_resolventIntegrand`、`continuousOn_resolventIntegrand`、
  `HolomorphicOnNhdSpectrum.resolventIntegrand_differentiableOn`、`.resolventIntegrand_continuousOn`；
- 上层使用者：`integrableOn_resolventIntegrand_compact`。

结果：全部 `#check` 通过，`lake env lean /tmp/f66b1-aggregate.lean` 退出码 0。`#print axioms`
对全部 12 个定理声明输出 `[propext, Classical.choice, Quot.sound]`（无 `sorryAx`）；模块共 13 个
公开声明（12 个定理 + `def resolventIntegrand`）。

Entry 声明映射：用 `scripts/check_axioms.py` 的 `map_entry_to_decl`（等价工具调用）读取本文件，
唯一 Entry id `functional-analysis.functional-calculus.resolvent-integrand` 关联全部 13 个公开声明
（含 `def resolventIntegrand`，`DECL_RE` 识别 `noncomputable def`）。见 §7 关于审计器盲区的说明。

## 5. 验证命令与结果（原文）

- `git branch --show-current` → `codex/functional-analysis-f66b1`
- 基线 `git log --oneline -3` → `a621303 docs(main): dispatch Wave D D1/D2/D5 subject maintainers` /
  `0b2ae8c docs(main): record verified snapshot at 46ea736` / `46ea736 …`
- `lake build SandronesLibrary.FunctionalAnalysis.HolomorphicResolventIntegrand`
  → `Build completed successfully (2902 jobs).`（含该模块依赖闭包；不是全库 build）
- 构建前后 `df -h /`：可用空间均约 11–12G，未低于 3G 阈值。
- `git diff --check` → 干净。
- 禁用占位扫描（`grep -nE "sorry|admit|sorryAx|native_decide"`）→ 无匹配。
- 越界概念扫描 → `cycle`／`绕数`／`f(a)` 等只在文档注释的“明确排除”句中，公开签名与证明体均无。

## 6. 子 Agent 所有权与负责人复核

本窗授权派生 2–3 个文件所有权不重叠的子 Agent（depth 2）。按单写者资源约束，所有 `lake` 与
`git add/commit` 由负责人串行执行；子 Agent 不跑构建、不写 git。

| 子 Agent | 所有权 | 产物／提交 | 负责人复核结果 |
|---|---|---|---|
| API 先例审计（depth 2，research，只读） | 无 worktree 文件；`/tmp` 报告 | 未提交 | 结论被采纳：确认 Mathlib 无第一预解恒等式与两参数交换性；核实 `Ring.inverse_sub_inverse`、`Commute.ringInverse_ringInverse`、`spectrum.hasDerivAt_resolvent_const_left`、`DifferentiableOn.analyticOnNhd`、`ContinuousOn.integrableOn_compact` 的精确签名；复核第一恒等式符号 `(w - z)` 与乘积次序正确。 |
| Entry 课程文档（depth 2） | `docs/entries/functional-analysis/functional-calculus/resolvent-integrand.md` 唯一文件 | 未单独提交，随负责人整体提交 | 已逐段复核数学陈述、前提、定义链与边界；数学正确，未退回。负责人作了两处编辑：`kind: theorem → definition`（模块含公共 `def resolventIntegrand`，与既有 `*-neighborhood` 一致），并把 `mathlib` 名单补全为公共签名中出现过的载体（`DifferentiableOn`、`AnalyticOnNhd`、`ContinuousOn`、`IsCompact`、`volume`）。 |
| 对抗性数学复核（depth 2，只读） | 无 worktree 文件；`/tmp/f66b1-referee-report.md` | 未提交 | 裁决 `SOUND / accept`：13 个公开声明全部数学成立，第一恒等式符号与次序正确、`resolvent_mul_comm` 的无条件性成立、`integrableOn_resolventIntegrand_compact` 无多余或过强前提；确认无 Mathlib 重复、无禁用概念泄漏、无越级公开接口、无占位符。未发现需要退回的问题。唯一“易碎”提示为两处 `rfl` 依赖 `resolvent` 当前定义体（若 Mathlib 改定义体才需动，陈述本身不变），已记入 §9。 |

负责人本人完成了：模块实现、串行编译、聚合 `#check`、公理 probe、声明映射、禁用概念扫描、
`git diff --check`、最终 commit。

## 7. 下一批可稳定依赖与不可依赖的 API

**可以稳定依赖：**

- `resolvent_sub_resolvent_same`、`resolvent_mul_comm`、`resolvent_sub_resolvent_same_mul_comm`
  （预解代数层，签名与 Mathlib `spectrum.resolvent_sub_resolvent` 的约定相容）；
- `resolventIntegrand` 及其 `differentiableOn_resolventIntegrand` / `continuousOn_resolventIntegrand`；
- `HolomorphicOnNhdSpectrum.resolventIntegrand_differentiableOn` / `.resolventIntegrand_continuousOn`；
- `integrableOn_resolventIntegrand_compact`（沿紧集／紧路径像积分的可积性前提）；
- `differentiableOn_resolvent`、`analyticOnNhd_resolvent`、`continuousOn_resolvent`。

**不可依赖（未完成）：**

- 任何有限 cycle、绕数、cycle／路径积分、Dunford 值 `f(a)`、选择无关性、代数同态、谱映射、
  复合、谱投影、连续函数演算：本批均未定义。公共 Banach 值路径积分 carrier 归复分析 D1；
  其正式签名进入 Main 前，F6.6b2 不得开工。
- 本批没有定义“沿 cycle 积分”的引理；`integrableOn_resolventIntegrand_compact` 只给出可积性前提。
- 审计器盲区：`check_axioms.py` 的 `map_entry_to_decl` 已把 `noncomputable def resolventIntegrand`
  正确关联（本项目 `DECL_RE` 支持 `noncomputable def`），但该函数对 `inductive`／`opaque` 等声明
  类型支持不足；本批无此类声明，故不存在漏审定义。若 Main 集成时新增此类声明需另行处理。

## 8. 登记与共享文件修改建议（Main 执行；本 worktree 未改动）

建议 Registry 条目：

```json
{
  "id": "functional-analysis.functional-calculus.resolvent-integrand",
  "kind": "definition",
  "state": "verified",
  "title": "预解恒等式与 Dunford 被积函数",
  "summary": "复 Banach 代数上第一预解恒等式、预解映射在预解集上的全纯性与 Dunford 被积函数的复可微／连续／紧集可积性",
  "premises": [
    "functional-analysis.functional-calculus.holomorphic-neighborhood",
    "functional-analysis.spectrum.definition"
  ],
  "mathlib": [
    "resolvent", "resolventSet", "spectrum", "Ring.inverse",
    "Ring.inverse_sub_inverse", "Commute.ringInverse_ringInverse",
    "Algebra.commute_algebraMap_left", "spectrum.hasDerivAt_resolvent_const_left",
    "spectrum.isOpen_resolventSet", "DifferentiableOn", "AnalyticOnNhd",
    "DifferentiableOn.smul", "DifferentiableOn.analyticOnNhd", "ContinuousOn",
    "IsCompact", "IntegrableOn", "volume", "ContinuousOn.integrableOn_compact"
  ],
  "provenance": {"source_type": "book", "ref": "buehler-salamon-functional-analysis-2018"},
  "lean_file": "FunctionalAnalysis/HolomorphicResolventIntegrand.lean",
  "nl_file": "docs/entries/functional-analysis/functional-calculus/resolvent-integrand.md"
}
```

- 顶层 import 建议：在 `SandronesLibrary.lean` 增加
  `import SandronesLibrary.FunctionalAnalysis.HolomorphicResolventIntegrand`。
- ROADMAP：把 F6.6 表中 `6b1` 的 `development_open` 推进为 `verified`（仅在 Main 集成后），
  并在 §Wave D D2 行记录本批交付；F6.6b2 仍 `research_open`。
- RADAR：建议登记 `resolvent` 的第一恒等式补全、Banach 值 `AnalyticOnNhd` 与
  `ContinuousOn.integrableOn_compact` 三个可复用的 Mathlib 后端。
- `premises` 仅列库内 Entry；Mathlib 名称只进 `mathlib`；`provenance.ref` 只用 `reference.bib`
  已存在的 `buehler-salamon-functional-analysis-2018`；未新增 BibTeX。

## 9. 诚实边界与未完成项

- 本批**只**交付 F6.6b1 的解析部分；完整 Dunford 演算仍未完成。
- `integration_waits_for`：后续 F6.6b2 的“沿 cycle 积分”依赖复分析 D1 尚未集成的公共有限 cycle /
  绕数 / Banach 值路径积分 carrier；本批自身不依赖它，故本批无 `integration_waits_for` 阻塞，
  但下一窗口有。
- 本批未改动任何已集成泛函／复分析模块，未运行全库 `lake build`，未 push／建 PR／删 worktree。
- 构建为“本模块 + 依赖闭包”的 2902 jobs，不代表全库通过。
- 已披露的实现细节（非数学问题）：`resolvent_sub_resolvent_same` 的 `calc` 用两处 `rfl` 展开
  `resolvent` 到 `(algebraMap ℂ A z - a)⁻¹ʳ`。这只依赖 Mathlib `resolvent` 当前的定义体；
  若 Mathlib 改变定义体，需改用 `Ring.inverse`/`spectrum.resolvent_eq` 桥重写，但定理陈述不变。
- 对抗性复核确认 `HolomorphicOnNhdSpectrum.resolventIntegrand_differentiableOn` 的
  `DifferentiableOn` 分支对任意见证 `U` 都成立（较浅），且未在陈述中额外断言
  `U ∩ resolventSet ℂ a` 的开性（该开性为真但下游不需要）；本批保留该陈述强度不夸大。
