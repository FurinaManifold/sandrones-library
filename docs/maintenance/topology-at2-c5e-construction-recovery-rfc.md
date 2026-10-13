# RFC：AT2-C5e 构造—恢复方向（covering 分类的 construction-to-recovery）

- 学科：拓扑学（Phase 4 T4 / AT2 覆盖空间）
- 窗口：Wave R1 `R-topology`，分支 `codex/topology-wave-r1`
- 基线：Main `49acfa0`（工作树 `/home/pisquare/czt/sandrones-library-topology-r1`）
- 条目候选：`topology.covering.subgroup-construction-recovery`
- 权限：`research_open`（依据 `docs/ROADMAP-LONGTERM.md` §Wave D D-3 与
  `../review-inbox/topology/main-at2-c5d-accepted-c5e-construction-recovery-research-open.md`）
- 本窗出口：**概念六列表 + 无占位原型 + `/tmp` 编译证据 + handoff**；不产生可集成交付

> 本 RFC 是研究窗接口冻结提案，**不是**正式源码或 Entry。正式 `SandronesLibrary/Topology/`
> 源码、`docs/entries/topology/` 条目与提交属于 `development_open` 下一窗。本文件不修改任何
> Main 共享文件。

---

## 1. 教材定位

教材：Hatcher, *Algebraic Topology*，第 1 章覆盖空间分类（命题 1.31–1.36 的构造方向）。

C5b–C5d 已集成：

- **C5b** `CoveringSubgroupPathClass x0 H`：从 `x0` 出发、终点可变的道路同伦类，按
  “起点前拼接 `H` 中环路”取轨道商（`CoveringSubgroupPathClassStandard.lean`）；
- **C5c** canonical chart topology、chart homeomorphism 与
  `coveringSubgroupProjection_isCoveringMap`（`CoveringSubgroupCanonicalChartStandard.lean`）；
- **C5d** `PointedCovering` 与 `recoveredSubgroup`（`CoveringSubgroupRecoveryStandard.lean`），
  其中 `recoveredSubgroup C = (FundamentalGroup.mapOfEq C.projection …).range`。

C5e 补上教材分类定理的**构造—恢复**一半：

> 给定子群 `H ≤ π₁(X, x₀)`，C5b 的道路类商在 C5c 的 chart 拓扑下是一个道路连通覆盖
> `subgroupPointedCovering H`，并且从该覆盖恢复出的子群恰为 `H`。

教材语言下这只是一句话；本库要求真实展开 `mapOfEq.range` 的两个包含方向，并说明右陪集／
左陪集约定如何产生 `H`。

假设边界（与 C5c 覆盖映射定理一致）：`[PathConnectedSpace X] [LocallyPathConnectedSpace X]
[SemilocallySimplyConnectedSpace X]`，`x₀ : X`，`H : Subgroup (FundamentalGroup X x0)`。

---

## 2. 概念六列表（本批核心概念 + 冻结公开签名）

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／一手刻画 | Mathlib 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|---|
| canonical lift point | 覆盖在 `x₀` 上方与 `H` 对应的选定点，即常环路的轨道 | 本库 `basePointClass : CoveringSubgroupPathClass x0 H` | `basePointClass = Quotient.mk ⟨x₀, Quotient.refl x₀⟩` | C5b 商载体的元素；`Quotient.mk` 为正式构造，无新 Mathlib 概念 | `initSegMap_zero`；`subgroupPointedCovering.point` | `topology.covering.subgroup-construction-recovery` |
| 前段道路 `γ ↾ [0,t]` | 把 `γ` 截断到 `[0,t]` 得到从 `x₀` 到 `γ t` 的道路 | 本库 `segClass` / `initSegMap : C(unitInterval, E)` | `initSegMap γ t = mk ⟨γ t, segClass γ t⟩`；投影为 `γ` | Mathlib `Path.truncateOfLE`、`Path.truncate` 为**私有证明后端**；`Path.Homotopic.Quotient.cast` 处理端点 | `subgroupPointedCovering.pathConnected` | 同上 |
| 总空间道路连通 | 覆盖的总空间以 `[γ ↾ [0,t]]` 连接每个点到 canonical lift point | 本库 `pathConnectedSpace_coveringSubgroupPathClass : PathConnectedSpace E` | 每个 `q` 由 `Quotient.inductionOn` 取代表道路后经 `initSegMap` 连接 | `PathConnectedSpace`、`Joined` 为语义一致的正式承载；`Path.mk` 组装 | 打包为 `PointedCovering` | 同上 |
| pointed covering 打包 | 覆盖映射 + 选定点 | 复用 C5d `PointedCovering X x₀`（**不新建结构**） | `subgroupPointedCovering H`：`Total := E`、拓扑取 C5c `coveringSubgroupTopology`、`isCoveringMap` 取 C5c 定理 | C5d 结构为正式承载；本批不重造 carrier | `recoveredSubgroup (subgroupPointedCovering H)` | 同上 |
| 恢复子群 | `π₁` 的像子群 `p_*π₁(E, e₀)` | 复用 C5d `recoveredSubgroup : Subgroup (FundamentalGroup X x0)`（**不新建定义**） | `(FundamentalGroup.mapOfEq …).range`；本批证明它等于 `H` | `FundamentalGroup.mapOfEq_apply`、`Set.range` 为正式承载 | 恢复定理本身 | 同上 |
| 提升唯一性 | 覆盖映射下同一道路、同一初值的两个连续提升相等 | Mathlib `IsCoveringMap.eq_of_comp_eq`（**语义一致的正式公开承载**） | `PreconnectedSpace I` + 复合投影相同 + 初值相同 ⟹ 提升相等 | 直接复用，不重写 | 恢复定理 `⊆` 方向 | 同上 |

### 公开签名四类扫描

1. **语义一致的正式公开承载（推荐复用）**：Mathlib `IsCoveringMap.eq_of_comp_eq`、
   `PathConnectedSpace`、`FundamentalGroup.mapOfEq_apply`；C5b `CoveringSubgroupPathClass`、
   C5c `coveringSubgroupTopology` / `coveringSubgroupProjection_isCoveringMap`；
   C5d `PointedCovering` / `recoveredSubgroup`。
2. **本库特殊定义的桥侧接口**：无新增桥。`recoveredSubgroup` 的定义在 C5d 已冻结。
3. **私有证明后端（不进入教材公开面）**：`Path.truncateOfLE`、`Path.truncate_zero_zero`、
   `Path.truncate_zero_one`、`Path.Homotopic.Quotient.cast(_cast/_rfl_rfl/mk_cast)`、
   C5c 的 `SmallNeighborhood` / `chartTo` / `chartInvDiscrete` / `chartToDiscrete` 及其私有引理。
   这些只在连续性证明内部使用，不作为课程概念公开。
4. **超出课程层级的公开泄漏**：无。

---

## 3. 冻结的公开签名（提案）

来源文件（拟）：`SandronesLibrary/Topology/CoveringSubgroupConstructionStandard.lean`
（新文件，不动 C5b/C5c/C5d 已集成文件）。

```lean
-- 唯一新公开 def
def basePointClass : CoveringSubgroupPathClass x0 H

-- 唯一新公开 def（总空间路径候选）
def initSegMap {y : X} (γ : Path x0 y) : C(unitInterval, CoveringSubgroupPathClass x0 H)

-- 端点等式
theorem initSegMap_zero (γ : Path x0 y) : initSegMap γ 0 = basePointClass
theorem initSegMap_one  (γ : Path x0 y) : initSegMap γ 1 = Quotient.mk (pathClassOf γ)

-- 总空间道路连通
theorem pathConnectedSpace_coveringSubgroupPathClass :
    @PathConnectedSpace E (CoveringSubgroupCanonicalChart.coveringSubgroupTopology H)

-- 打包与恢复
def subgroupPointedCovering : PointedCovering X x0
theorem recoveredSubgroup_subgroupPointedCovering :
    PointedCovering.recoveredSubgroup (subgroupPointedCovering H) = H
```

其余辅助（`mk_eq_of_target_eq'`、`pathClassOf`、`segClass`）建议保持 `private` 或
`namespace` 内部，避免公开面膨胀。

---

## 4. 依赖与 Mathlib 列表

**库内依赖（Entry）**

- `topology.covering.subgroup-path-class-standard`（C5b，orbits carrier）
- `topology.covering.semilocally-simply-connected-standard`（C5a，假设类）
- `topology.covering.subgroup-canonical-chart-standard`（C5c，chart 拓扑与覆盖映射）
- `topology.covering.pointed-recovered-subgroup`（C5d，`PointedCovering`/`recoveredSubgroup`）

**Lean import（提案）**

```lean
import SandronesLibrary.Topology.CoveringSubgroupCanonicalChartStandard
import SandronesLibrary.Topology.CoveringSubgroupRecoveryStandard
```

**Mathlib 名称（按角色）**

- 正式承载：`PathConnectedSpace`、`Joined`、`Path`、`C(I, X)`、
  `IsCoveringMap.eq_of_comp_eq`、`FundamentalGroup.mapOfEq_apply`、`Set.range`。
- 私有后端：`Path.truncate`、`Path.truncateOfLE`、`Path.truncate_zero_zero`、
  `Path.truncate_zero_one`、`Path.extend_zero`、`Path.extend_one`、`Path.extend_apply`、
  `Path.cast`、`Path.Homotopic.Quotient.cast` / `cast_cast` / `cast_rfl_rfl` / `mk_cast`、
  `Quotient.out` / `Quotient.out_eq`。

---

## 5. `/tmp` 原型与编译证据

原型（**未进入正式库**）：`/tmp/sandrones-library/C5eResearch.lean`。

已验证命令与真实输出：

```bash
cd /home/pisquare/czt/sandrones-library-topology-r1
lake env lean /tmp/sandrones-library/C5eResearch.lean
# exit=0
# /tmp/sandrones-library/C5eResearch.lean:65:4: warning: declaration uses `sorry`
# /tmp/sandrones-library/C5eResearch.lean:103:8: warning: declaration uses `sorry`
# /tmp/sandrones-library/C5eResearch.lean:123:8: warning: declaration uses `sorry`
```

即：全部定义与 **端点等式** 已真实证明（`mk_eq_of_target_eq'`、`initSegMap_zero`、
`initSegMap_one` 无占位）；剩余 3 个 `sorry` 恰为下述未完成边界。

原型全文见 `docs/handoffs/topology-wave-r1.md` §5 内联版本。

---

## 6. 证明路线与未完成义务

### 6.1 已闭合

- **端点传输引理 `mk_eq_of_target_eq'`**：把“结构端点命题相等”化归为 `Quotient` 的
  `cast` 等式，回避 Lean 依赖重写；这是 C5e 全部端点书写的公共前提。
- **`initSegMap_zero` / `initSegMap_one`**：用 `Path.truncate_zero_zero` /
  `Path.truncate_zero_one` + `Path.Homotopic.Quotient.cast_cast` / `cast_rfl_rfl` 消去
  端点 cast。

### 6.2 未完成（3 项，逐项可独立验收）

**(E1) `initSegMap` 的连续性。**
目标是 `Continuous (initSegMap γ)`。路线：

1. 固定 `t₀`，取 `U := SmallNeighborhood (γ t₀)`（C5c `exists_smallNeighborhood`）。
2. `V := γ ⁻¹' U.carrier` 是 `I` 中开邻域；取 `t₀` 的区间邻域 `J` 使 `γ '' J ⊆ U.carrier`。
3. 在 `V` 上，`initSegMap γ = chartInvDiscrete U ∘ g`，其中
   `g t = chartToDiscrete U ⟨initSegMap γ t, _⟩`，故只需 `g` 连续。
4. `g` 的第一坐标 `= ⟨γ t, _⟩`（C5c `chartTo_fst`）连续；第二坐标
   `fiberCoord t = mk (segClass γ t trans localPathClass (γ t)⁻¹)` 需证在 `J` 上**常值**：
   对 `t ∈ J`，`γ ↾ [t₀,t]` 落在 `U` 内，C5c
   `SmallNeighborhood.localPathClass_trans_localSegmentClass` 给出
   `localPathClass (γ t₀) trans [γ ↾ [t₀,t]] = localPathClass (γ t)`，代入并用
   `trans_assoc` / `trans_symm` / `trans_refl` 即得 `fiberCoord t = fiberCoord t₀`。
5. 需要的辅助引理：前段分裂
   `segClass γ t = (segClass γ t₀).trans (class of γ ↾ [t₀,t])`（Mathlib 无现成
   `truncate_trans`，需自证），以及 `LocalSegmentClass` 与子类型限制道路的衔接。
6. 结论经 `continuous_chartInvDiscrete`（C5c）组装。

**(E2) `pathConnectedSpace_coveringSubgroupPathClass`。**
路线 A（推荐，最短）：取 `q : E`，`Quotient.inductionOn` 取代表 `a`，令
`γ := Quotient.out a.path`，用 `Path.mk (initSegMap γ) (initSegMap_zero γ) (initSegMap_one γ)`
并 `Path.cast` 校正到 `mk a`；再对任意两点经 `basePointClass` 拼接（`Path.symm` / `trans`）。
依赖 (E1)。
路线 B（备选）：`PathConnectedSpace.of_locallyPathConnectedSpace` + `ConnectedSpace E`；
需另证 E 局部道路连通（由 chart 图册）与连通（由道路类商的传递性），代价更高。

**(E3) `recoveredSubgroup_subgroupPointedCovering : … = H`。**
用 `FundamentalGroup.mapOfEq_apply`（其中 `projection_point := rfl`，故 `cast` 退化为恒等）
把 `range` 化为 `{ p.map projection : p }`，再双向包含：

- `⊆`：`p` 是 `e₀` 处环路在 `E` 中的类；其投影 `β := p.map projection` 是 `x₀` 处环路。
  `p` 的连续提升与 `initSegMap (out β)` 有相同的投影和初值，由
  `IsCoveringMap.eq_of_comp_eq`（`I` 预连通）二者相等；比较 `t = 1` 端点得
  `mk ⟨x₀, β⟩ = basePointClass`，即 `β` 与常环路 `H`-相关，故 `β ∈ H`。
- `⊇`：`h ∈ H` 时取 `ℓ := initSegMap (h.1)`（端点 `mk ⟨x₀, h.1⟩ = basePointClass`，
  因 `h ∈ H` 使其为环路），则 `ℓ.map projection = h.1`，故 `h ∈ range`。

---

## 7. 诚实边界（不得写成已完成）

- 本窗**不产生可集成交付**：无正式源码、无 Entry、Registry / RADAR / `SandronesLibrary.lean`
  均不改动；`topology.covering.subgroup-construction-recovery` 仍是候选 id。
- 原型含 3 个 `sorry`，**不是无占位原型**；E1–E3 未闭合，故不满足转 `development_open`
  的全部条件。
- 未触及：任意 pointed covering → C5c 构造 cover 的反向等价、共轭模去、unpointed 分类、
  universal cover（属冻结的 C5f–C5g）。
- 本窗未声明 `recoveredSubgroup` 与教材“同调／分类双射”的完全等价，只声明恢复等式。
