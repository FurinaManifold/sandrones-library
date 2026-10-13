# Handoff：拓扑学 Wave R1（AT2-C5e 构造—恢复方向，`research_open`）

- 学科：拓扑学
- 分支：`codex/topology-wave-r1`
- worktree：`/home/pisquare/czt/sandrones-library-topology-r1`
- 基线：Main `49acfa0`（`docs(main): Wave R parallel subject windows with resource discipline`）
- 条目候选：`topology.covering.subgroup-construction-recovery`
- 权限：`research_open`（`docs/ROADMAP-LONGTERM.md` §Wave D D-3 与
  `../review-inbox/topology/main-at2-c5d-accepted-c5e-construction-recovery-research-open.md`）
- 日期：2026-10-13

---

## 1. 范围

本窗是 Wave R1 `R-topology` 的 `research_open` 出口：冻结 C5e 的设计与公开签名，
给出概念六列表、Mathlib 角色分类、依赖列表、`/tmp` 原型与真实编译证据。
**不产生可集成交付**：不写正式 `SandronesLibrary/Topology/` 源码、不写 Entry、不触碰
Registry / RADAR / ROADMAP / `SandronesLibrary.lean`。

范围严格止于 construction-to-recovery 方向：

1. C5c 的 `CoveringSubgroupPathClass x0 H` 在 canonical chart 拓扑下道路连通；
2. 以常道路类给出 canonical lift point，并把 C5c cover 打包为 C5d `PointedCovering`；
3. `recoveredSubgroup (subgroupPointedCovering H) = H`。

**不做**：任意 pointed covering → C5c 构造 cover 的反向等价、共轭模去、unpointed 分类、
universal cover（冻结的 C5f–C5g）。

## 2. 提交与本窗文件

| # | 提交 | 内容 |
|---|---|---|
| 1 | `RFC + 概念六列表` | `docs/maintenance/topology-at2-c5e-construction-recovery-rfc.md`（新增） |
| 2 | `handoff` | `docs/handoffs/topology-wave-r1.md`（本文件，新增） |

实际提交（本 worktree 现场）：

| # | commit | 内容 |
|---|---|---|
| 1 | `030605b` | `docs(topology): AT2-C5e construction-recovery RFC (research_open)` |
| 2 | `01c7675` | `docs(topology): Wave R1 handoff for AT2-C5e research window` |

（记录本 handoff 现场输出的提交为 HEAD，其自身哈希见 §4 的 `git log`。）

本窗不修改任何 Main 共享文件，也不修改 `SandronesLibrary/Topology/`、`docs/entries/topology/`。

## 3. 验证命令与真实输出

### 3.1 依赖闭包定向构建（本 worktree）

```bash
cd /home/pisquare/czt/sandrones-library-topology-r1
lake build SandronesLibrary.Topology.CoveringSubgroupCanonicalChartStandard \
           SandronesLibrary.Topology.CoveringSubgroupRecoveryStandard
# ✔ [1830/1830] Build completed successfully (1830 jobs).
```

（Mathlib olean 经 `.lake/packages` 符号链接复用主工作树；未运行 `lake update` /
`lake exe cache get`。）

### 3.2 `/tmp` 研究原型编译

```bash
lake env lean /tmp/sandrones-library/C5eResearch.lean
# exit=0
# C5eResearch.lean:65:4: warning: declaration uses `sorry`
# C5eResearch.lean:103:8: warning: declaration uses `sorry`
# C5eResearch.lean:123:8: warning: declaration uses `sorry`
```

3 个 `sorry` 恰为 §6 的 E1/E2/E3；其余定义与端点引理**无占位**。

### 3.3 学科验收包自检

```bash
python3 scripts/subject_package.py \
    --worktree /home/pisquare/czt/sandrones-library-topology-r1 \
    --base 49acfa0 --subject topology
```

现场输出（交付提交后重跑，见 §4）：

```text
学科验收包 topology  (codex/topology-wave-r1 @ 01c767530)
  基线 49acfa0｜提交 2｜改动文件 2
  ✅ cleanliness
  ✅ ownership
  ✅ semantics
  ✅ proof
  ✅ coverage
  verdict: pass
```

基线（未提交时）唯一异常为 `coverage: 无 docs/handoffs/*.md`，本文件提交后消除。

### 3.4 磁盘

构建前后 `df -h /`：可用从 8.6G 起，构建后 16G（未触发停止线）。
本 worktree `.lake/build` 约 24M（Mathlib olean 走符号链接复用）。

## 4. 交付时现场记录（`git log` / `subject_package`）

本 handoff 的记录提交为交付分支 HEAD；重复现场命令：

```bash
git -C /home/pisquare/czt/sandrones-library-topology-r1 log --oneline 49acfa0..HEAD
python3 scripts/subject_package.py --worktree \
    /home/pisquare/czt/sandrones-library-topology-r1 --base 49acfa0 --subject topology --json
```

## 5. `/tmp` 原型全文（内联，供下一窗直接迁移）

```lean
import SandronesLibrary.Topology.CoveringSubgroupCanonicalChartStandard
import SandronesLibrary.Topology.CoveringSubgroupRecoveryStandard

open Set
namespace SandronesLibrary.Topology

noncomputable section
universe u

variable {X : Type u} [TopologicalSpace X]
variable (x0 : X)
variable (H : Subgroup (FundamentalGroup X x0))

/-- 常道路类给出的 canonical lift point。 -/
def basePointClass : CoveringSubgroupPathClass x0 H :=
  Quotient.mk _ ({ endpoint := x0, path := Path.Homotopic.Quotient.refl x0 } :
    CoveringSubgroupBasedPath x0)

/-- 端点命题相等时 `BasedPath` 结构可安全换端点：用 `Quotient` 的 cast 形式陈述，
避免 Lean 依赖重写。 -/
theorem mk_eq_of_target_eq' {y₁ y₂ : X} (h : y₁ = y₂)
    (p : Path.Homotopic.Quotient x0 y₁) (q : Path.Homotopic.Quotient x0 y₂)
    (hp : p.cast rfl h.symm = q) :
    (Quotient.mk _ (⟨y₁, p⟩ : CoveringSubgroupBasedPath x0) : CoveringSubgroupPathClass x0 H)
      = Quotient.mk _ (⟨y₂, q⟩ : CoveringSubgroupBasedPath x0) := by
  cases h
  simp only [Path.Homotopic.Quotient.cast_rfl_rfl] at hp
  cases hp
  rfl

/-- 具体道路给出的 based path 结构。 -/
def pathClassOf {y : X} (γ : Path x0 y) : CoveringSubgroupBasedPath x0 :=
  { endpoint := y, path := Path.Homotopic.Quotient.mk γ }

/-- `γ` 在时刻 `t` 的前段 `γ ↾ [0,t]` 的道路同伦类，端点取 `γ t`。 -/
def segClass {y : X} (γ : Path x0 y) (t : unitInterval) :
    Path.Homotopic.Quotient x0 (γ t) :=
  (Path.Homotopic.Quotient.mk
      (γ.truncateOfLE (t₀ := (0 : ℝ)) (t₁ := (t : ℝ)) t.2.1)).cast
    (Path.extend_zero γ).symm (Path.extend_apply γ t.2).symm

variable [PathConnectedSpace X]

local notation "E" => CoveringSubgroupPathClass x0 H
local instance : TopologicalSpace E :=
  CoveringSubgroupCanonicalChart.coveringSubgroupTopology (x0 := x0) H

/-- `t ↦ [γ ↾ [0,t]]` 作为进入总空间的连续映射候选。 -/
def initSegMap {y : X} (γ : Path x0 y) : C(unitInterval, E) where
  toFun t := Quotient.mk _ ({ endpoint := γ t, path := segClass x0 γ t } :
    CoveringSubgroupBasedPath x0)
  continuous_toFun := by
    -- 未完成：canonical chart 下的局部常值论证（见 handoff）。
    sorry

/-- 投影把 `initSegMap γ` 送回 `γ`。 -/
theorem projection_initSegMap {y : X} (γ : Path x0 y) (t : unitInterval) :
    CoveringSubgroupPathClass.projection H (initSegMap x0 H γ t) = γ t := rfl

/-- 前段映射在 `t = 0` 处落在 canonical lift point；本窗已真实证明。 -/
theorem initSegMap_zero {y : X} (γ : Path x0 y) :
    initSegMap x0 H γ 0 = basePointClass x0 H := by
  refine mk_eq_of_target_eq' x0 H (Path.source γ) (segClass x0 γ 0)
    (Path.Homotopic.Quotient.refl x0) ?_
  simp only [segClass]
  rw [Path.truncateOfLE]
  simp only [Path.Homotopic.Quotient.mk_cast, Path.Homotopic.Quotient.cast_cast]
  rw [show γ.truncate (0 : ℝ) ((0 : unitInterval) : ℝ) = γ.truncate 0 0 from rfl]
  rw [Path.truncate_zero_zero]
  simp only [Path.Homotopic.Quotient.mk_cast, Path.Homotopic.Quotient.mk_refl,
    Path.Homotopic.Quotient.cast_cast, Path.Homotopic.Quotient.cast_rfl_rfl]

/-- 前段映射在 `t = 1` 处落在整条道路的类；本窗已真实证明。 -/
theorem initSegMap_one {y : X} (γ : Path x0 y) :
    initSegMap x0 H γ 1 = Quotient.mk _ (pathClassOf x0 γ) := by
  refine mk_eq_of_target_eq' x0 H (Path.target γ) (segClass x0 γ 1)
    (Path.Homotopic.Quotient.mk γ) ?_
  simp only [segClass]
  rw [Path.truncateOfLE]
  simp only [Path.Homotopic.Quotient.mk_cast, Path.Homotopic.Quotient.cast_cast]
  rw [show γ.truncate (0 : ℝ) ((1 : unitInterval) : ℝ) = γ.truncate 0 1 from rfl]
  rw [Path.truncate_zero_one]
  simp only [Path.Homotopic.Quotient.mk_cast, Path.Homotopic.Quotient.cast_cast,
    Path.Homotopic.Quotient.cast_rfl_rfl]

/-- canonical 总空间的 `H`-道路类商在 chart 拓扑下道路连通。 -/
theorem pathConnectedSpace_coveringSubgroupPathClass
    [LocallyPathConnectedSpace X] [SemilocallySimplyConnectedSpace X] :
    @PathConnectedSpace E
      (CoveringSubgroupCanonicalChart.coveringSubgroupTopology (x0 := x0) H) := by
  -- 未完成：C5c cover 的总空间道路连通。
  sorry

/-- 把 C5c 的 cover 打包成 C5d 的 pointed covering。 -/
def subgroupPointedCovering [LocallyPathConnectedSpace X]
    [SemilocallySimplyConnectedSpace X] : PointedCovering X x0 where
  Total := E
  topology := CoveringSubgroupCanonicalChart.coveringSubgroupTopology (x0 := x0) H
  pathConnected := pathConnectedSpace_coveringSubgroupPathClass x0 H
  projection := CoveringSubgroupPathClass.projection H
  isCoveringMap :=
    CoveringSubgroupCanonicalChart.coveringSubgroupProjection_isCoveringMap (x0 := x0) H
  point := basePointClass x0 H
  projection_point := rfl

/-- 构造—恢复互逆：C5c 构造的 cover 恰好恢复原子群 `H`。 -/
theorem recoveredSubgroup_subgroupPointedCovering
    [LocallyPathConnectedSpace X] [SemilocallySimplyConnectedSpace X] :
    PointedCovering.recoveredSubgroup (subgroupPointedCovering x0 H) = H := by
  -- 未完成：展开 `mapOfEq.range` 两个包含方向（见 handoff）。
  sorry

end
end SandronesLibrary.Topology
```

> 注：本代码块与 `/tmp/sandrones-library/C5eResearch.lean` 逐行一致（含
> `local notation "E"` / `local instance : TopologicalSpace E`），是本窗编译证据的权威版本；
> `sorry` 三处对应 §8 的 E1/E2/E3。

## 6. 子 Agent 所有权与退回记录

本窗**未派子 Agent**。理由：

- C5e 是单一证明链（连续性 → 道路连通 → 恢复），文件所有权无法切出两个互不重叠、
  可独立编译的 `.lean` 分片；强行切分会制造跨 Agent 的接口依赖，违反单写者 `.lake/build`；
- `research_open` 出口只要求冻结签名与原型，规模未到必须并行的程度。

故无子 Agent 提交、无退回记录。`docs/maintenance/` 与 `docs/handoffs/` 两个文件由负责人
本人撰写与验收。

## 7. Main 需更新的共享文件清单（仅建议，本窗不直接修改）

若 Main 决定接受本窗为完整 `research_open` 出口并转 `development_open`，需在共享文件侧：

1. `docs/ROADMAP-LONGTERM.md` T4 表：`AT2-C5e` 行由 `research_open` 更新为
   `development_open`（或保留 `research_open` 并注明“原型未 sorry-free，E1–E3 待闭合”）；
   §Wave D D-3 同步。
2. `docs/MATHLIB-RADAR.md`：为 `IsCoveringMap.eq_of_comp_eq`（提升唯一性）补“谁在用”段落，
   使用者为本批恢复定理；`Path.truncateOfLE` 等私有后端可不登记。
3. `reference.bib`：无新增来源需求；教材键沿用 `hatcher-algebraic-topology-2002`。
4. Registry / `SandronesLibrary.lean` / `docs/entries/README.md` / RANKINGS：本窗无正式源码
   与 Entry，**不新增**任何条目；等 `development_open` 窗交付后再由 Main 重建。
5. 若 Main 判定本窗“仍不足以转 `development_open`”，只需在
   `../review-inbox/topology/` 写明仍需 E1–E3；学科负责人据以继续返工，不需 Main 改源码。

## 8. 未完成边界（诚实记录）

1. **原型含 3 个占位**，因此**不是** review-inbox 要求的“无占位原型”：
   - **E1** `initSegMap` 连续性：canonical chart 下的纤维坐标局部常值论证未闭合；
     关键待证引理是前段分裂 `segClass γ t = (segClass γ t₀).trans (class of γ ↾ [t₀,t])`
     （Mathlib 无 `truncate_trans`），其后代入 C5c
     `SmallNeighborhood.localPathClass_trans_localSegmentClass` 即可。
   - **E2** 总空间道路连通：依赖 E1；骨架（用 `Path.mk` + 端点等式连接 `basePointClass`）
     已在原型中定下。
   - **E3** `recoveredSubgroup … = H`：两个包含方向的证明路线已写清，但未在 Lean 中展开；
     `⊆` 方向依赖 `IsCoveringMap.eq_of_comp_eq` 的提升唯一性。
2. 未声明与教材“同调／分类双射”的完全等价；未构造 unpointed / universal cover；未做反向
   恢复—构造方向。
3. 本窗为 `research_open`，**不产生可集成交付**；`topology.covering.subgroup-construction-recovery`
   仍是候选 id，Registry / Radar / ROADMAP 未登记。
4. 未运行全库 `lake build`（学科不承担；`development_open` 后由 Main 在集成阶段统一运行）。
5. `docs/subject-packages/` 与 `docs/releases/` 是 Main 侧台账，学科未写；本窗不生成学科包 JSON
   文件，只运行 `subject_package.py` 自检。

## 9. 下一窗可依赖 / 不可依赖的 API

- **可稳定依赖**：C5b `CoveringSubgroupPathClass` / `orbitSetoid` / `projection`；
  C5c `coveringSubgroupTopology` / `chartInvDiscrete` / `continuous_chartInvDiscrete` /
  `coveringSubgroupProjection_isCoveringMap` / `SmallNeighborhood.localPathClass_trans_localSegmentClass`；
  C5d `PointedCovering` / `recoveredSubgroup`。
- **不可依赖（尚未冻结）**：`initSegMap` 的连续性、`pathConnectedSpace_coveringSubgroupPathClass`、
  `subgroupPointedCovering`、`recoveredSubgroup_subgroupPointedCovering`——它们仍是 `sorry`
  占位，下一窗须重证或沿用前先重新编译。
