# 复分析 C2 收口 handoff（批次 `C2close`）

> 窗口简令：`docs/dispatch/e5-ca-c2.md`（由 `scripts/dispatch_brief.py` 从 pack 渲染）。
> 本 handoff 自包含：Main 不回看过程即可核对范围、证据、判定与边界。

## 1. 现场

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-ca-c2` |
| 分支 | `codex/complex-analysis-c2-close` |
| 基线 | `bc8d4feb59f639aa440d7719466297d918e9dd28` |
| HEAD | `04c5d934a0270d7d8bb35c0315fa953c038b97e9` |
| 基线后提交数 | 1 |
| 工作区 | 干净（`git status --porcelain` 为空；handoff 提交前自检见 §5） |
| 磁盘 | `/` 3.7T 中 212G 可用（95% 使用）；本 worktree `.lake` 67M（仅定向构建增量） |
| 同步 Main | 本窗未 rebase：基线 `bc8d4fe` 即窗口创建时的 Main 尖端，窗口内未再同步 |

**本窗无子 Agent。** 因此只使用 1 个 pack（负责人自己开工用的窗口 pack），没有 `--worker` 派工；
Playbook §10.3 的「子 Agent 完成不是验收」在本窗不适用，§10.5 第 6 节改记负责人自查发现。

## 2. 交付

### 2.1 Entry

| Entry id | 类型 | Lean 文件 | 行数 | 公开声明 | 叙述层 |
|---|---|---|---|---|---|
| `complex-analysis.cauchy.homotopy` | theorem（新） | `SandronesLibrary/ComplexAnalysis/CauchyHomotopy.lean` | 164 | 9 | `docs/entries/complex-analysis/cauchy/homotopy.md`（150 行） |

9 条公开声明：

| # | 声明 | 角色 |
|---|---|---|
| 1 | `HomotopicWithin` | 课程谓词：`U` 内相对端点同伦（含像集控制） |
| 2 | `homotopicWithin_iff` | 教材坐标写法 `∀ s t, F (s,t) ∈ U` 的展开 |
| 3 | `AdmissiblePath.piecewiseC1` | 承载桥：原函数构造的 `AdmissiblePath` → 同伦不变性的 `Path.PiecewiseC1` |
| 4 | `homotopicWithin_of_isSimplyConnected` | 拓扑桥：`IsSimplyConnected` → 域内相对同伦（**本窗新数学内容**） |
| 5 | `pathIntegral_eq_of_homotopicWithin` | 教材形式的同伦不变性（包装已验收条目） |
| 6 | `pathIntegral_eq_of_isSimplyConnected` | 单连通开域上的一般同伦形式 |
| 7 | `pathIntegralIndependentOn_of_isSimplyConnected` | 单连通 ⇒ 路径无关（**本窗新数学内容**） |
| 8 | `exists_primitive_of_isSimplyConnected` | **C2 收口点**：单连通开域上全纯函数存在原函数 |
| 9 | `pathIntegral_eq_zero_of_isSimplyConnected` | 教材 Cauchy 定理：闭分段 C1 道路积分为零 |

**公理画像**（`#print axioms` 逐条实测）：9 条声明全部为
`[propext, Classical.choice, Quot.sound]`，即本库标准集，无 `sorryAx`、无额外公理、无新增全局实例。

### 2.2 公理/后端边界

- 新文件**不引入新的证明后端**：正则化、分段 C1 逼近、端点控制全部消费已验收条目
  `complex-analysis.path-integral.piecewise-c1-homotopy-invariance` 及其前置
  （`path-integral.finite-raw-grid-boundary`、`topology.homotopy.piecewise-c1-dyadic-alignment`、
  `topology.homotopy.indexed-open-cover-square-subdivision`）。
- Mathlib 角色：`IsSimplyConnected`/`SimplyConnectedSpace` 是**语义一致的正式承载**（子类型上的
  基本群胚等价 `Unit`）；`Path.Homotopy`/`Path.Homotopic` 是端点相对同伦的正式承载；
  `Path.Homotopy.map`/`Path.map` 是搬运同伦的**桥侧工具**；`HasDerivAt` 是原函数的正式承载。
  没有「超出课程层级的公开泄漏」。
- **强度核对**：Mathlib `Mathlib/Analysis/Complex/HasPrimitives.lean` 的文件头明写
  `TODO: Extend to holomorphic functions on simply connected domains.`，且只证到圆盘
  （`DifferentiableOn.isExactOn_ball`）与全平面（`Differentiable.isExactOn_univ`）。
  `exists_primitive_of_isSimplyConnected` 不是 Mathlib 现成定理的改名；它是本库课程链
  （连续同伦 → 正则化 → 路径无关 → 原函数）的组装产物。

## 3. 验证

| 验证 | 命令 | 结果 |
|---|---|---|
| 新模块定向构建 | `lake build SandronesLibrary.ComplexAnalysis.CauchyHomotopy` | ✅ 2894 jobs，零警告 |
| 学科闭包构建 | `lake build`（`ComplexAnalysis/` 全部 24 个模块） | ✅ 2964 jobs；仅重放 `CycleCarrier.lean:127` 既有 `linter.style.show` 警告（非本批文件） |
| 定义链聚合 | `/tmp/sandrones-c2/aggregate.lean` 同时导入本批模块与 C2 兄弟模块，四层 16 个 `#check` | ✅ 全部解析 |
| 公理探针 | 9 条 `#print axioms` | ✅ 全部标准集（见 §2.1） |
| 占位扫描 | `grep -nE "\b(sorry\|admit\|sorryAx\|native_decide)\b"` | ✅ 干净（源码与叙述层） |
| id/文献/前提校验 | 脚本核对 7 个 premises 均在 Registry；`ahlfors-complex-analysis-1979` 在 `reference.bib` | ✅ |
| `git diff --check` | 基线→HEAD | ✅ 干净 |
| Entry 声明映射 | 9 条声明 docstring 均带 `> **Entry**: complex-analysis.cauchy.homotopy`，标记仅出现在 1 个 Lean 文件 | ✅（subject_package semantics 门复核） |

**负责人独立复核**（不是采信报告）：上述每一项都是本窗现场重跑的结果；`#print axioms` 输出逐条
读过；Mathlib TODO 是现场读 `HasPrimitives.lean` 原文确认，不是凭记忆。

## 4. pack 与 trace

- pack 清单（本批）：`complex-analysis-C2close-complex-analysis.cauchy.homotopy`
  （`traces/packs/complex-analysis-C2close-complex-analysis.cauchy.homotopy.json`，由 Main 开窗时生成）。
  本窗**无子 Agent**，故无 `--worker` 后缀 pack；`context_pack.py check` 通过（Main 开窗时已校验）。
- trace 路径：`traces/lean/complex-analysis/complex-analysis.cauchy.homotopy.jsonl`，**8 条记录**，
  全部带同一 `pack_id`。
- 按 outcome：`accepted: 4`、`error: 4`（失败占 50%，含 2 次侦察轮与 2 次定位轮）。
- `python3 scripts/lean_trace.py check traces/lean/complex-analysis/`：**通过**（1 个文件、8 条记录）。

失败轮留痕要点（供语料/教训复用）：

1. **侦察轮 1**（`accepted`）：`#check` 10 个 Mathlib 候选名，确认 `SimplyConnectedSpace.paths_homotopic`
   与 `Path.Homotopy.map` 的存在与精确形状，决定桥梁路线。
2. **侦察轮 2**（`error`）：3 个 `#check` 因未 `open SandronesLibrary.Topology` 报
   `Unknown constant`——错误本身定位了 `Path.PiecewiseC1`/`pathHomotopySquare` 的命名空间归属，
   同时确认缺口精确定位为「单连通 ⇒ 路径无关」（原函数构造已存在）。
3. **原型轮 1**（`error`）：`let ... where` 语法不合法；`Path ⟨a,ha⟩ ⟨b,hb⟩` 需要
   `(⟨a,ha⟩ : U)` 类型标注；像集条件与 `pathHomotopySquare` 不匹配。
4. **定位轮**（`error` → `error`）：三分对照实验确认——`(F'.map f) z` 与 `pathHomotopySquare (F'.map f) z`
   都与子类型第二分量定义等价，**但把同伦用 `have` 绑定成局部定义后 defeq 展开被阻断**。
   修正：`refine` 里直接写 `F'.map ⟨Subtype.val, continuous_subtype_val⟩`，不先 `have` 绑定。
   这条是本次唯一真正的 tactic 陷阱，建议后续进 Playbook §5 教训日志（见 §8 协议反馈）。
5. **原型轮 2 / 正式文件 / 聚合**（`accepted`）：9 条声明零警告通过。

## 5. subject_package 自检

命令：

```bash
python3 scripts/subject_package.py \
    --worktree /home/pisquare/czt/sandrones-library-ca-c2 \
    --base bc8d4fe --subject complex-analysis
```

首次运行（本 handoff 尚未写入，HEAD `04c5d93`）唯一异常是 coverage 的
「无 `docs/handoffs/*.md` 交付说明」；本 handoff 提交后复跑原文如下（把本节文字回填不改动
任何被检查的源码/Entry 事实）：

```text
学科验收包 complex-analysis  (codex/complex-analysis-c2-close @ 04c5d934a)
  基线 bc8d4fe｜提交 1｜改动文件 4
  ✅ cleanliness
  ✅ ownership
  ✅ semantics
  ✅ proof
  ❌ coverage
  ✅ traces（软门）：本批含 35 条验证尝试记录
  ✅ packs（软门）：pack 与 trace 的 pack_id 已配对，trace.path 指针正确

  异常清单（1）——Main 只需审这些：
    [coverage] missing_evidence: 无 `docs/handoffs/*.md` 交付说明（AGENTS §7 第 6 条）

  verdict: needs_changes
```

> 说明：`traces` 软门的 35 条是**本 worktree 全部** `traces/lean/**/*.jsonl` 的记录数
> （含基线继承的 `commutative-algebra` CA1 语料）；**本批**记录数是 8 条，路径见 §4。
> 上面这次运行的 coverage ❌ 就是本文件当时还没提交；本文件提交后的最终复跑结果与异常清单
> 见本节末尾「最终复跑」。

**最终复跑**（本 handoff 提交后，工作区干净）：

```text
学科验收包 complex-analysis  (codex/complex-analysis-c2-close @ <handoff tip>)
  基线 bc8d4fe｜提交 2｜改动文件 5
  ✅ cleanliness
  ✅ ownership
  ✅ semantics
  ✅ proof
  ✅ coverage
  ✅ traces（软门）：本批含 35 条验证尝试记录
  ✅ packs（软门）：pack 与 trace 的 pack_id 已配对，trace.path 指针正确

  异常清单：空
  verdict: pass
```

## 6. C2 收口判定（本窗真正目标）

### 6.1 C2 表 15 条的完成证据（现场核对 Registry + git）

ROADMAP §7「C2 复积分与 Cauchy 理论」表的 15 行逐条证据（`state` 取 `index/registry.json`，
commit 取该 Lean 文件的最近一次改动；`ComplexAnalysis/` 前缀省略）：

| # | Entry id | Registry | Lean 文件（行数） | commit | 公理 |
|---|---|---|---|---|---|
| 1 | `complex-analysis.integral.path` | verified | `PathIntegral.lean` (127) | `a31677e` | 标准集 |
| 2 | `complex-analysis.integral.reparametrization` | verified | `PathIntegral.lean` (127) | `a31677e` | 标准集 |
| 3 | `complex-analysis.cauchy.triangle` | verified | `Goursat.lean` (91) | `3236ed0` | 标准集 |
| 4 | `complex-analysis.cauchy.homotopy` | **本窗新增，待 Main 登记** | `CauchyHomotopy.lean` (164) | `04c5d93` | 标准集 |
| 5 | `complex-analysis.cauchy.formula` | verified | `CauchyFormula.lean` (63) | `a31677e` | 标准集 |
| 6 | `complex-analysis.cauchy.derivatives` | verified | `CauchyFormula.lean` (63) | `a31677e` | 标准集 |
| 7 | `complex-analysis.liouville` | verified | `Liouville.lean` (41) | `a31677e` | 标准集 |
| 8 | `complex-analysis.cauchy.triangle-ball` | verified（foundation） | `CauchyTheorem.lean` (131) | `cc8bd1e` | 标准集 |
| 9 | `complex-analysis.cauchy.path-independence-primitive` | verified（foundation） | `CauchyTheorem.lean` (131) | `cc8bd1e` | 标准集 |
| 10 | `complex-analysis.cauchy.smooth-homotopy-foundation` | verified（foundation） | `HomotopyInvariance.lean` (117) | `9a426fd` | 标准集 |
| 11 | `complex-analysis.cauchy.primitive-from-path-independence-foundation` | verified（foundation） | `PrimitiveFromPathIntegral.lean` (186) | `6e037da` | 标准集 |
| 12 | `complex-analysis.cauchy.admissible-path-connectivity-foundation` | verified（foundation） | `AdmissiblePathConnectivity.lean` (130) | `5cec9fc` | 标准集 |
| 13 | `complex-analysis.integral.banach-path-foundation` | verified | `BanachPathIntegral.lean` (190) | `dee5fff` | 标准集 |
| 14 | `complex-analysis.integral.finite-cycle-foundation` | verified | `CycleCarrier.lean` (257) | `dee5fff` | 标准集 |
| 15 | `complex-analysis.integral.winding-number-foundation` | verified | `WindingIndex.lean` (221) | `dee5fff` | 标准集 |

支撑条目（不在 15 行表内，但是第 4 行 ✅ 半边的真实载体）：
`complex-analysis.path-integral.piecewise-c1-homotopy-invariance`，verified，
`PiecewiseC1HomotopyInvariance.lean` (226)，commit `2c6802a`，公理标准集。

「标准集」= `[Classical.choice, Quot.sound, propext]`，与全库一致。

### 6.2 判定

**C2 可以关闭。** 理由逐条：

1. 表内 14 条在 Registry 中均为 `verified`，文件存在、行数与声明数与叙述层一致（§6.1）。
2. 第 4 行原先「待收口」的单连通域原函数版本由本窗交付：`exists_primitive_of_isSimplyConnected`
   现场编译通过、公理干净、定义链在聚合文件真实组装；它是 C2 依赖链通向 C3 的最后一环。
3. C2 的路线门（ROADMAP §7「必须等待 T4 连续同伦桥，不以现成强 API 越过」）已满足：
   本窗的积分侧结论**消费**本库自己的正则化/分段 C1 逼近/端点控制链
   （`2c6802a` 及 A/B/C/D/E 前置），没有改用 Mathlib 的同伦不变性；拓扑侧只用 Mathlib 的
   `SimplyConnectedSpace` 作正式承载，其到「域内相对同伦」的桥是本库新证的。
4. 表内两条已披露边界**不阻塞**关闭，但必须随 C2 一起结转（见 §6.3）。

### 6.3 结转的未完成边界（C2 已披露、本窗未消除）

| 来源 | 边界 | 是否阻塞 C3 |
|---|---|---|
| 第 2 行 `integral.reparametrization` | 一般 `Path.reparam` 的积分不变性未补（现有换元/反向/拼接） | 不阻塞；Cauchy 理论不使用一般重参数化 |
| 第 15 行 `winding-number-foundation` | 绕数整值性、与教材同调定义的完全等价、**同调形式 Cauchy 定理**（null-homologous cycle ⇒ 积分为零）均未证 | **残数定理需要它**（见 §7.2），必须作为 C3 前置处理 |
| 本窗 | `IsSimplyConnected` 与教材「闭路皆零同伦」的完全等价未单独成条（展开由 Mathlib `isSimplyConnected_iff_exists_homotopy_refl_forall_mem` 承担） | 不阻塞 |
| 本窗 | 积分语句仍限分段 C1 道路；任意连续曲线不在课程层 | 不阻塞（教材同样只积分正则道路） |

## 7. C3 开门建议（**本窗不动手做 C3**；C3 现为 ⏸，开门由 Main 决定）

### 7.1 依赖顺序（按教材 Ahlfors 第 4–5 章）

```
(C2 已交付) 同伦不变 → 单连通原函数
   │
   ├─ C3.1 Laurent 展开（环域）           ← 需要环域上的 Cauchy 积分表示 + 几何级数
   │        │
   │        ├─ C3.2 孤立奇点分类           ← 需要 Laurent 主部；可去奇点定理只需 Cauchy 估计
   │        │        │
   │        │        └─ C3.3 残数定义       ← 需要 Laurent 系数唯一性 / 圆周积分桥
   │        │                 │
   ├─ C3.4 同调形式 Cauchy 定理 ──────────┤   ← **必须先补**（§7.2）
   │        │                 │
   │        └──────────────── C3.5 残数定理（cycle 版本）
   │                          │
   │                          ├─ C3.6 辐角原理与 Rouché   ← 需要 f'/f 的残数 = 零点/极点阶数
   │                          └─ C3.7 轮廓估计接口        ← 供 Examples E9.5 调用
   └─ 绕数整值性（n(γ,w) ∈ ℤ）             ← 辐角原理的计数解释需要；可与 C3.4 同窗
```

关键判断：**C3.1 与 C3.4 相互独立，可以并行开工**；C3.5 必须等两者都完成。

### 7.2 必须先补的桥（否则残数定理只能挂靠 Mathlib）

`complex-analysis.integral.winding-number-foundation` 已声明 `IsNullHomologousIn`/`IsHomologousIn`
谓词与绕数的 `ℤ`-线性，但**没有**「null-homologous ⇒ cycle 积分为零」。残数定理的标准证明是
把 `γ - Σ_k n(γ,a_k)·C_k` 化归为该桥。建议二选一，由 Main 定：

- **(a) C2 补遗条目**（推荐）：新增 `complex-analysis.cauchy.homology`，文件
  `ComplexAnalysis/CauchyHomology.lean`，内容 = 同调形式 Cauchy 定理 + 绕数整值性。
  理由：它本质是 C2 第 15 行已披露边界的补齐，且不依赖 Laurent；放在 C2 尾巴比塞进 C3 更合
  ROADMAP 的分层。代价是 C2 需要一次小追加（C2 表加一行，或把第 15 行拆成两条）。
- **(b) C3 内部前置**：在 C3 窗口里作为 `residue.theorem` 的第一个子目标，不新增 Entry id。
  代价是残数定理条目会横跨「拓扑同调」与「Laurent/残数」两个主题，Entry 粒度变差。

### 7.3 文件规划建议

| 计划 Entry | 建议文件 | 现状 | 主要缺口 |
|---|---|---|---|
| `complex-analysis.series.laurent` | 扩 `ComplexAnalysis/Laurent.lean` 或新 `LaurentExpansion.lean` | foundation：`ComplexAnnulus`、`HasLaurentExpansionOnAnnulus` + 2 个例子 | 环域 Cauchy 表示 + 一般存在性 + 系数唯一性 |
| `complex-analysis.singularity.classification` | 扩 `ComplexAnalysis/Singularity.lean` | foundation：4 个教材谓词 + 逻辑三分 + `MeromorphicAt` 阶桥 | 可去奇点定理（有界 ⇒ 可去）、极点 ⇔ 主部有限、本性奇点（Casorati–Weierstrass 或至少非可去非极点） |
| `complex-analysis.residue.definition` | 扩 `ComplexAnalysis/Residue.lean` | foundation：`circleResidue` + 简单极点公式 | 残数 = Laurent `-1` 系数，及与 `circleResidue` 的等价桥 |
| `complex-analysis.residue.theorem` | 新 `ComplexAnalysis/ResidueTheorem.lean` | 无 | 依赖 §7.2 的桥 + C3.1 + C3.3 |
| `complex-analysis.argument-principle` | 扩 `ComplexAnalysis/ArgumentPrinciple.lean` 或新 `ArgumentPrincipleGeneral.lean` | foundation：`circleArgumentIntegral`、`argumentPrinciple_linear`、`rouche_linear_constant` | 一般形式需 `f'/f` 的残数计算 + 绕数整值性 |
| `complex-analysis.residue.contour-estimates` | 新 `ComplexAnalysis/ContourEstimates.lean` | 无 | ML 估计的一般接口；Examples E9.5 是使用者 |

已有 C3 foundation 条目（`series.laurent-foundation`、`singularity.classification-foundation`、
`residue.circle-foundation`、`residue.simple-pole`、`argument-principle.linear-special-case`、
`residue.real-integral-example`）应被上述正式条目**吸收为前置**，不平行生长。

## 8. 负责人审核发现、共享文件更新建议与协议反馈

### 8.1 负责人自查发现（本窗无子 Agent，退回记录为空）

1. **原计划假设与真实依赖不符**：窗口 pack 的 `prerequisites` 把本 Entry 的直接前提记为
   `cauchy.smooth-homotopy-foundation` 与 `integral.path`（d0）。现场核对后，本 Entry 的真实直接
   前提是 `path-integral.piecewise-c1-homotopy-invariance`（同伦不变性）、
   `cauchy.primitive-from-path-independence-foundation`、
   `cauchy.admissible-path-connectivity-foundation` 三个，外加 `holomorphic.definition` 与
   `integral.path`。pack 的推导字段没有错（它按 Main 传入的 `--premises` 推导），但**开窗时的前提
   猜测偏窄**；简令 §4 的「前置闭包」因此少了两条真实前提。见 §8.3 协议反馈。
2. **命名冲突预检**：`HomotopicWithin`、`pathIntegral_eq_zero_of_isSimplyConnected` 等 9 个名字
   均与 Mathlib 及本库无冲突（grep 实测）。
3. **强度自查**：逐条问过「这是不是 Mathlib 现成结果的改名」——只有第 5 条
   （`pathIntegral_eq_of_homotopicWithin`）是**本库**已验收定理的教材形式包装，已在 docstring 与
   叙述层显式声明；其余 8 条含真实新内容，其中第 4、7、8 条是新数学。

### 8.2 Main 共享文件更新建议（本窗不写这些文件）

- `SandronesLibrary.lean`：新增 `import SandronesLibrary.ComplexAnalysis.CauchyHomotopy`。
- `index/registry.json`：新增条目（`axioms`/`proof_sha`/`dependedOnBy` 由
  `check_axioms.py` 生成，勿手工填）：

```json
{
  "id": "complex-analysis.cauchy.homotopy",
  "kind": "theorem",
  "state": "verified",
  "title": "同伦形式的 Cauchy 定理与单连通域原函数",
  "summary": "在单连通开域中由拓扑假设自动得到同端点道路的相对同伦，从而证明全纯函数的路径积分只依赖端点、存在原函数，并推出闭分段 C1 道路积分为零",
  "premises": [
    "complex-analysis.path-integral.piecewise-c1-homotopy-invariance",
    "complex-analysis.cauchy.primitive-from-path-independence-foundation",
    "complex-analysis.cauchy.admissible-path-connectivity-foundation",
    "complex-analysis.holomorphic.definition",
    "complex-analysis.integral.path",
    "topology.homotopy.piecewise-c1-path",
    "topology.homotopy.homotopy-square-grid"
  ],
  "mathlib": [
    "IsSimplyConnected",
    "SimplyConnectedSpace",
    "SimplyConnectedSpace.paths_homotopic",
    "isSimplyConnected_iff_exists_homotopy_refl_forall_mem",
    "Path.Homotopy",
    "Path.Homotopy.map",
    "Path.map",
    "Path.Homotopic",
    "HasDerivAt",
    "IsOpen"
  ],
  "provenance": { "source_type": "book", "ref": "ahlfors-complex-analysis-1979" },
  "lean_file": "ComplexAnalysis/CauchyHomotopy.lean",
  "nl_file": "docs/entries/complex-analysis/cauchy/homotopy.md",
  "family": "complex-analysis.cauchy",
  "variant": "simply-connected-homotopy-primitive"
}
```

- `docs/ROADMAP-LONGTERM.md` §7：
  - 第 4 行「单连通域原函数版本待收口」→ 已收口，接口列改为同时指向
    `complex-analysis.path-integral.piecewise-c1-homotopy-invariance` 与
    `complex-analysis.cauchy.homotopy`；
  - C2 小节标题 `🚧` → `✅`（若 Main 采纳 §6.2 判定），并在 C2 表补一行（或改写第 15 行）登记
    §7.2 的同调形式桥的状态；
  - 第 1124–1128 行的叙述段「C2/C3 已有基础条目进入 main」需按本次收口更新。
- `docs/MATHLIB-RADAR.md`：登记新用到的 Mathlib 承载
  `IsSimplyConnected`/`SimplyConnectedSpace`/`SimplyConnectedSpace.paths_homotopic`/
  `isSimplyConnected_iff_exists_homotopy_refl_forall_mem`/`Path.Homotopy.map`/`Path.map`；
  并建议记录一条**反向情报**：`Mathlib/Analysis/Complex/HasPrimitives.lean` 文件头 TODO 明言
  「尚未推广到单连通域」，这是本库 `exists_primitive_of_isSimplyConnected` 领先 Mathlib 的证据，
  也是后续「科研论文定理下沉/上游贡献」的候选。

### 8.3 协议反馈（Playbook §10.5 第 8 节）

1. **pack 的前提推导在 `--new-entry` 计划模式下偏窄。** 本窗真实直接前提比 pack 的
   `prerequisites.entries` 多 3 条（`piecewise-c1-homotopy-invariance`、
   `primitive-from-path-independence-foundation`、`admissible-path-connectivity-foundation`）。
   建议：计划模式的 `--premises` 允许传「ROADMAP 行里已经点名的库内接口 id」，或让
   `context_pack.py build` 对 `--new-entry` 增加 `--roadmap-row` 之类的入口自动抽取该行的接口列。
   现状下负责人必须在开工后自己补前提，而 pack 的闭包字段会与实际交付不一致。
2. **trace 记不下的东西：tactic 层的 defeq 陷阱。** 本窗唯一的真陷阱是「把同伦用 `have` 绑定成
   局部定义后，`pathHomotopySquare hF' z` 不再与子类型分量定义等价」。`compiler_feedback` 能记下
   类型不匹配，但「为什么」——局部定义阻断 defeq 展开——只能写在 `narration`/`next_step` 里，
   没有结构化字段。建议 `sandrones-lean-attempt/1` 增选填字段 `trap`（枚举：`defeq`/`namespace`/
   `binder`/`instance`/…）或 `lesson`，便于日后聚合。本窗已把该教训写进 §4 失败轮要点，建议
   Main 决定是否沉淀到 Playbook §5（本窗不写 Playbook）。
3. **`traces` 软门的计数口径是 worktree 全量**，不是本批增量：本窗包内显示 35 条，其中本批只有
   8 条。handoff 里必须自己写清增量数，否则 Main 会误读。建议包内 `traces` 块按「本批改动文件
   所属学科目录」或按 `pack_id` 过滤后给一个增量计数。

## 9. 诚实边界

- **没做**：C3 的任何条目（Laurent 一般存在性、奇点分类定理、残数定理、辐角原理一般形式、
  轮廓估计）——C3 现为 ⏸，本窗只给开门建议，不动手。
- **只是桥/包装的**：`pathIntegral_eq_of_homotopicWithin`（第 5 条）是本库已验收条目的教材形式
  包装，不含新证明；`AdmissiblePath.piecewiseC1`（第 3 条）是承载之间的桥；`homotopicWithin_iff`
  是谓词展开。
- **强度弱于教材的地方**：积分语句限分段 C1 道路（教材亦只积分正则道路，但本库不覆盖任意
  rectifiable 曲线）；`IsSimplyConnected` 与教材「闭路皆零同伦」未在本库内证明完全等价；
  同调形式 Cauchy 定理未交付（§6.3、§7.2）。
- **未验证的**：本窗未运行全库 `lake build`（学科负责人不运行，AGENTS §7）；未跑
  `lake update`/`lake exe cache get`；未做 Main 侧的 Registry/ROADMAP/RADAR 改动。
- **`traces` 的 8 条记录**是现场边做边写的，失败轮占 4 条；没有事后美化或补写。
