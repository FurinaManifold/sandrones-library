# Handoff：E3 跨学科登记完整性维护（Wave E）

## 0. 窗口与状态

- 角色：学科维护负责人（`docs/roles/SUBJECT-MAINTENANCE-ROLE.md`），权限 🚧；**不是 Main**。
- 分支：`codex/registry-integrity-maintenance`；worktree：`sandrones-library-registry-integrity`。
- 基线 Main：`52021fe`（派工提交）。**未同步新 Main，未 rebase**（本窗口不涉及）。
- RFC：`docs/maintenance/cross-subject-registry-integrity.md`（提交 `4212b93`，先于所有源码改动）。
- 跨学科授权：Main 授予三个互不重叠文件分片（见 §6）。本文件单列全部跨学科源码改动。
- 未运行全库 `lake build`；未运行生成器／`audit.py`／`check_axioms.py --all --fix`（Main 职责）。
- 未 push、未建 PR、未删 worktree。

### 提交与回滚边界

| 提交 | 内容 | 回滚边界 |
|---|---|---|
| `4212b93` | RFC（只读影响图 + 判定） | 删一个文件 |
| `89c6eac` | 分片 ① `RealAnalysis/Riemann.lean` 标记切分 + 两个实分析条目文档 | 2 处 docstring 标记行 + 文档段落 |
| `f2d5375` | 分片 ② `AbstractAlgebra/Poly.lean` 6 个标记改归 + `mathlib-compat.md` | 6 个 marker 文本 + 模块头 + 文档段落 |
| `ff1197b` | 分片 ③ `Topology/Closure.lean` 4 个标记 + orphan 文档 | 4 个 docstring 标记行 + 文档 front matter/段 |
| `<handoff>` | 本文件 | 删一个文件 |

### M 等级与阶段

| 分片 | 等级 | 理由 |
|---|---|---|
| ① `real-analysis.riemann.cont-integrable` | **M1** | 给已 `verified` 条目补回真实声明集合；无公开签名/证明变化；旧接口完整保留 |
| ② `abstract-algebra.poly.irreducible` 跨文件 | **M1** | 登记归属变化（6 个历史包装改归兼容条目）；无数学/签名变化 |
| ③ `Topology/Closure.lean` 登记 | **M1** | 为已存在并通过验收的内容新增 Entry 登记；无数学/签名变化 |
| ④ 基础设施判定 | **无源码变更** | 只写长期排除规则 |

**本轮无 M2/M3。** 迁移波次：波次 1（本窗口，登记修复）→ 波次 2（Main：Registry/RADAR/ROADMAP/生成器/全库 build）
→ 波次 3（后续窗口，可选：`Poly.lean` 近重复包装退役评估，单独提交）。

---

## 1. 每个分片的声明归属对照表

### 分片 ① `RealAnalysis/Riemann.lean`

| 声明 | 行（修改后） | 修改前归属 | 修改后归属 |
|---|---|---|---|
| `DarbouxPartition` | 36 | def | **def** |
| `lowerSum` / `upperSum` | 44 / 48 | def | **def** |
| `RiemannIntegrable` | 55 | def | **def** |
| `riemannIntegral` | 60 | def | **def** |
| `uniformPartition` | 65 | def | **def** |
| `uniformPartition_step` / `step_sum` / `uniform_x_mem` | 81 / 90 / 103 | def | **def** |
| `interval_width` | 125 | def | **def** |
| `b3_osc` | 139 | def（错误） | **cont-integrable** |
| `C2_subinterval` | 165 | def（错误） | **cont-integrable** |
| `continuous_on_riemannIntegrable_lt` | 187 | def（错误） | **cont-integrable** |
| `continuous_intervalIntegrable` | 292 | def（错误） | **cont-integrable** |
| `integral_indicator_const_Ioc` … `interval_le_sSup_lowerSum_add`（25 个机器声明） | 302–908 | def（错误） | **eq-lebesgue** |
| `riemannIntegral_eq_interval` | 913 | eq-lebesgue | **eq-lebesgue** |

现场 `map_entry_to_decl`（`scripts/check_axioms.py` 自带）修改后计数：
`def = 10`、`cont-integrable = 4`、`eq-lebesgue = 26`。修改前 `def = 39`、`cont-integrable = 缺失`、
`eq-lebesgue = 1`。

**切分理由**：`cont-integrable` 恰好取 4 个“连续可积”内容（振荡界 B3/C2 + 两个主定理；
Registry 与条目文档均写明“振荡界”，且 `b3_osc`/`C2_subinterval` 全库唯一使用者就是
`continuous_on_riemannIntegrable_lt`）。`interval_width` 与 `uniformPartition` 家族是定义层基础，留 `def`。
`:306`–`:913` 是 `riemannIntegral_eq_interval`（`:919`）的“达布和=阶梯积分+夹逼”证明后端，
与 `eq-lebesgue` 的 Registry summary/mathlib 列表一一对应，故在其前恢复 `eq-lebesgue` 标记，
而不是再放 `def`（避免把机器误并进定义条目）。新增标记行：`:137`（cont-integrable）、`:300`（eq-lebesgue）。

### 分片 ② `AbstractAlgebra/Poly.lean` + `PolynomialIrreducibility.lean`

| 声明 | 所在文件 | 修改前 Entry | 修改后 Entry |
|---|---|---|---|
| `poly_ext`、`is_root_iff_eval_eq_zero`、`dvd_X_sub_C_iff_isRoot`、`poly_is_domain_of_is_domain`、`poly_isUnit_iff`、`mem_roots_iff_isRoot`、`root_mul_iff` | `Poly.lean` | mathlib-compat | **mathlib-compat** |
| `irreducible_mul_iff`、`irreducible_X_sub_C`、`irreducible_X`、`irreducible_of_degree_eq_one`、`modByMonic_eq_zero_iff_dvd`、`degree_modByMonic_lt` | `Poly.lean` | **irreducible（跨文件违规）** | **mathlib-compat** |
| `card_roots_le_degree` | `Poly.lean` | roots-card | **roots-card** |
| `irreducible_factor_isUnit`、`irreducible_X_sub_C`、`irreducible_X`、`field_irreducible_of_degree_eq_one`、`primitive_iff_constant_dvd_isUnit`、`monic_isPrimitive`、`primitive_mul`、`primitive_iff_content_eq_one`、`eq_C_content_mul_primPart`、`content_mul`、`integer_gauss_irreducible_iff_rational_irreducible`、`integer_rational_root_num_dvd_constant`、`integer_rational_root_den_dvd_leading`、`monic_rational_root_is_integer`、`irreducible_of_isEisensteinAt`、`integer_prime_eisenstein_irreducible`（16 个声明） | `PolynomialIrreducibility.lean` | irreducible | **irreducible（不动，17 处标记）** |

现场 `map_entry_to_decl` 修改后：`Poly.lean` → `mathlib-compat = 13`、`roots-card = 1`，
**不再出现 irreducible**；`PolynomialIrreducibility.lean` → `irreducible = 16`。
`Poly.lean` 中 `> **Entry**: abstract-algebra.poly.irreducible` 已为 0 处。

**判定理由**：Registry `lean_file` 与迁移 handoff
（`docs/handoffs/abstract-algebra-a3-polynomial-irreducibility.md:33-34`）都要求规范条目留在
`PolynomialIrreducibility.lean`；`Poly.lean` 6 个声明是历史包装，且库内真实使用为 0
（唯一命中是 `Polynomial.degree_modByMonic_lt` 这类 Mathlib 限定名）。按 handoff 指示改归兼容
Entry，不另立 id（无新数学，另立会制造重复 Entry）；不删声明（退役需阶段 C 四条，留后续窗口）。
`Poly.lean` 模块头 bullet list 同步改写，并注明规范条目在 `PolynomialIrreducibility.lean`。

### 分片 ③ `Topology/Closure.lean`

| 声明（23 个） | 修改前 | 修改后 |
|---|---|---|
| Interior：`interior_eq_sUnion_open_subsets`、`isOpen_interior'`、`interior_subset_self`、`subset_interior_of_isOpen`、`mem_interior_iff_open_neighborhood`、`interior_eq_self_iff_isOpen`、`interior_mono'` | 无标记 | **topology.space.closure** |
| Closure：`closure_eq_sInter_closed_supersets`、`subset_closure_self`、`isClosed_closure'`、`closure_subset_of_isClosed`、`closure_eq_self_iff_isClosed`、`closure_mono'`、`closure_union'`、`mem_closure_iff_open_neighborhood_meets` | 无标记 | **topology.space.closure** |
| Duality：`closure_eq_compl_interior_compl'`、`interior_compl'` | 无标记 | **topology.space.closure** |
| Frontier：`frontier_eq_closure_sdiff_interior`、`frontier_eq_two_closures`、`isClosed_frontier'`、`frontier_compl'`、`closure_eq_interior_union_frontier'`、`closure_eq_self_union_frontier'` | 无标记 | **topology.space.closure** |

现场 `map_entry_to_decl`：`topology.space.closure = 23`，0 未覆盖。
新增标记行：`:27`、`:59`、`:93`、`:106`（每 section 首个声明的 docstring 内）。

**判定理由**：内容唯一 → 补 Entry 登记（不退役）：`Topology/Space.lean` 无任何
`interior/closure/frontier` 声明；根 `SandronesLibrary.lean:148` 与
`Analysis/JordanRegion.lean:7` 都 import 本模块；`docs/MATHLIB-RADAR.md:2241-2245` 已把
“谁在用 `interior`/`mem_closure_iff`”记作 `topology.space.closure`。orphan 文档内容与模块一一对应，
保留并随本次登记补 Registry（不删）。

### 判定 ④ 基础设施

`SandronesLibrary/Basic.lean`（26 行，唯一声明是匿名 `example … := by omega`，
仅被根 import）与 `SandronesLibrary/Topology/MathlibBridge.lean`（41 行，
`toMathlib`／`isOpen_toMathlib`／`continuous_iff_mathlib`，模块头自称唯一允许的
“textbook topology → Mathlib topology”实现桥，唯一导入者 `Topology/MathlibCompatibility.lean`）
均**不首次引入任何教材核心概念** ⇒ **基础设施，长期豁免 Entry 标记**。长期规则见 RFC §2.4：
显式路径白名单（不做名字模式匹配）＋内容约束（仅脚手架/冒烟/实例安装桥/notation）＋
`Examples/**` 在 Examples 开工前整体豁免＋增删需 Main RFC。基本判定由子 Agent B 独立复核，一致。

---

## 2. Main 需要更新的共有文件清单

### 2.1 `index/registry.json`

1. `real-analysis.riemann.cont-integrable`
   - `lean_file` / `premises` / `state`：**不变**（`RealAnalysis/Riemann.lean`）。
   - `axioms`：**必须重生成**。现场 `#print axioms` 显示 4 个声明并集为
     `[propext, Classical.choice, Quot.sound]`，而现登记为 `['propext','Quot.sound']`
     （缺 `Classical.choice`）。`check_axioms.py --all --fix` 会产生 `[DIFF]` 并回写。
   - `proof_sha`：文件已改，必须重生成。
2. `real-analysis.riemann.def`
   - `lean_file` / `axioms`：现场探针显示仍为 `[propext, Classical.choice, Quot.sound]`，
     与现状一致；`proof_sha` 需重生成。
3. `real-analysis.riemann.eq-lebesgue`：`proof_sha` 需重生成；`axioms` 不变。
4. `abstract-algebra.poly.irreducible`
   - `lean_file = AbstractAlgebra/PolynomialIrreducibility.lean`：**不变、正确**。
   - **`mathlib` 列表已过期**：现列的是 `Poly.lean` 旧包装的后端
     `[Irreducible.isUnit_or_isUnit, Polynomial.irreducible_X_sub_C, Polynomial.irreducible_X,
     Polynomial.irreducible_of_degree_eq_one, Polynomial.modByMonic_eq_zero_iff_dvd,
     Polynomial.degree_modByMonic_lt]`。应改为规范文件的真实后端
     （`Polynomial.isPrimitive_iff_isUnit_of_C_dvd`、`Polynomial.irreducible_X_sub_C`、
     `Polynomial.irreducible_X`、`Polynomial.irreducible_of_degree_eq_one`、
     `Polynomial.isPrimitive_iff_content_eq_one`、`Polynomial.eq_C_content_mul_primPart`、
     `Polynomial.content_mul`、`Polynomial.IsPrimitive.Int.irreducible_iff_irreducible_map_cast`、
     `num_dvd_of_is_root`、`den_dvd_of_is_root`、`Polynomial.IsEisensteinAt.irreducible` 等，
     以源码为准）。`proof_sha` 不变（文件未改）。
5. `abstract-algebra.poly.mathlib-compat`
   - `lean_file = AbstractAlgebra/Poly.lean`、`state`：不变；`axioms` 现场探针并集仍为
     `[Classical.choice, Quot.sound, propext]`（`irreducible_mul_iff` 无公理），不变；
     `proof_sha` 需重生成（文件已改）。
   - **`mathlib` 列表建议补** `[Irreducible.isUnit_or_isUnit, Polynomial.irreducible_X_sub_C,
     Polynomial.irreducible_X, Polynomial.irreducible_of_degree_eq_one,
     Polynomial.modByMonic_eq_zero_iff_dvd, Polynomial.degree_modByMonic_lt]`（6 个改归包装的后端）。
6. **新增记录 `topology.space.closure`**（当前只有文档、无 Registry）：建议字段
   - `id: topology.space.closure`
   - `kind: theorem`（现文档写 `theorem-family`，请 Main 按现有取值规范化）
   - `state: verified`、`title: 内部、闭包与边界`
   - `family: topology.space`、`variant: textbook`
   - `premises: [topology.space.def, topology.space.neighborhood]`
   - `mathlib: [interior, closure, frontier, mem_closure_iff, closure_union,
     closure_eq_iff_isClosed, interior_eq_iff_isOpen, closure_eq_compl_interior_compl,
     frontier_eq_closure_inter_closure, closure_eq_interior_union_frontier,
     closure_eq_self_union_frontier]`（以源码实际引用为准）
   - `lean_file: Topology/Closure.lean`
   - `nl_file: docs/entries/topology/space/closure.md`
   - `provenance: {source_type: book, ref: munkres-topology-2000}`
   - `axioms`: 现场探针并集 `[propext, Classical.choice, Quot.sound]`（请由 `--fix` 生成）
   - `proof_sha` 由 `check_axioms.py --all --fix` 生成。
7. 派生文件：`index/rankings.json`、`docs/entries/README.md`、`docs/entries/RANKINGS.md`
   全部重生成。注意 `abstract-algebra.poly.irreducible` 的排名“主声明”将由
   `Poly.lean:irreducible_mul_iff` 变为 `PolynomialIrreducibility.lean:irreducible_factor_isUnit`
   （D-4 (f) 提到的排名歧义随之消除）；新增 `topology.space.closure`。

### 2.2 其他共有文件

- `SandronesLibrary.lean`：**无需改动**（`Topology.Closure` 已在 `:148` import；
  `Poly`、`PolynomialIrreducibility` 已在根 import）。
- `docs/MATHLIB-RADAR.md`：**无需改动**（`:2244` 已把 `topology.space.closure` 记为使用者）。
- `docs/ROADMAP-LONGTERM.md`：Main 更新 Wave E E3 行、D-4 (b)（已由本窗口修复）、
  D-4 (d)/(e) 跨学科部分（`physics` 无；拓扑 `Closure.lean` 已登记、`abstract-algebra.poly.irreducible`
  跨文件已拆开）。注意 E1 的 `linear-algebra.*` 与本窗口无关，不得据此标记完成。
- `reference.bib`：**无需改动**（`munkres-topology-2000` 已存在，`:151`）。

---

## 3. 验证结果（现场，原文摘要）

1. **分支/基线**：`codex/registry-integrity-maintenance`，基线 `52021fe`，开工时 `git status --short` 为空。
2. **缺陷重跑（Python 双向对账）**：修改后
   - A（Registry id 无源码标记）：仅剩 `linear-algebra.vector-space.dimension`（E1），
     `real-analysis.riemann.cont-integrable` 已消除；
   - B（源码标记无 Registry）：`analysis.derivative.definition`（E2）＋新增的
     `topology.space.closure`（预期，待 Main 建记录）；
   - C（同 id 跨文件）：仅剩 `linear-algebra.matrix.normal`（E1），
     `abstract-algebra.poly.irreducible` 已消除；
   - D（无标记 .lean 文件）：28 → 27（`Topology/Closure.lean` 已登记）。
3. **`map_entry_to_decl` 现场复核**：Riemann.lean → def 10 / cont-integrable 4 / eq-lebesgue 26；
   Poly.lean → mathlib-compat 13 / roots-card 1；Closure.lean → topology.space.closure 23；
   PolynomialIrreducibility.lean → irreducible 16。
4. **定向编译**（修改模块 + 依赖闭包，非全库）：
   - `lake build SandronesLibrary.RealAnalysis.Riemann SandronesLibrary.RealAnalysis.RiemannAlgebra
     SandronesLibrary.RealAnalysis.RiemannCriterion SandronesLibrary.RealAnalysis.RiemannIntegralBridge`
     → `Build completed successfully (8712 jobs)`，仅重放既有 linter warnings。
   - `lake build SandronesLibrary.AbstractAlgebra.Poly SandronesLibrary.AbstractAlgebra.PolynomialIrreducibility
     SandronesLibrary.AbstractAlgebra.PolynomialFactorization SandronesLibrary.Topology.Closure
     SandronesLibrary.Analysis.JordanRegion SandronesLibrary.Topology.MathlibCompatibility`
     → `Build completed successfully (8731 jobs)`，仅重放既有 linter warnings。
5. **聚合 `#check`**（`/tmp/e3_checks.lean`，覆盖三片“承载→展开→桥→使用者”＋判定④）：
   `lake env lean` 退出码 0，无 error。关键签名现场打印通过
   （`continuous_on_riemannIntegrable_lt`、`continuous_intervalIntegrable`、
   `riemannIntegral_eq_interval`、`irreducible_factor_isUnit`、`integer_prime_eisenstein_irreducible`、
   6 个改归的 `Poly` 包装、`mem_closure_iff_open_neighborhood_meets`、
   `SandronesLibrary.Analysis.Multivariable.IsJordanMeasurable`、
   `TextbookTopology.toMathlib/continuous_iff_mathlib`）。
6. **公理探针**（`#print axioms`，为 Main 回写提供依据）：
   `cont-integrable` 4 个声明并集 `[propext, Classical.choice, Quot.sound]`（现登记缺 `Classical.choice`）；
   `riemann.def` 边界声明仍 `[propext, Classical.choice, Quot.sound]`；
   `Poly` 改归包装 `irreducible_mul_iff` 无公理、其余 `[propext, Classical.choice, Quot.sound]`；
   `Closure` 的 `interior_eq_sUnion_open_subsets`/`frontier_eq_closure_sdiff_interior` 无公理，
   `mem_closure_iff_open_neighborhood_meets` `[propext, Classical.choice, Quot.sound]`。
7. **占位符扫描**：修改的 3 个 `.lean` 文件及全 `SandronesLibrary/` 均无
   `sorry`/`admit`/`sorryAx`/`native_decide`。
8. **`git diff --check`**：干净（exit 0）。
9. **磁盘**：构建前后 `df -h /` 均约 `11G` 可用（> 3G 阈值），未跑 `lake update`/`cache get`。

---

## 4. 子 Agent 清单与退回记录

| 子 Agent | 所有权（仅写） | 交付 | 负责人核实结果 |
|---|---|---|---|
| A（depth 2，`6e7183ec`） | `SandronesLibrary/AbstractAlgebra/Poly.lean`、`docs/entries/abstract-algebra/poly/mathlib-compat.md` | `f2d5375`（由负责人串联提交） | **通过**。现场确认 6 个 marker 改归、`Poly.lean` 中 irreducible marker = 0、`mathlib-compat` 映射 13 个声明、`PolynomialIrreducibility.lean` 未改（16 声明/17 标记）。 |
| B（depth 2，`e8aee1ab`） | `SandronesLibrary/Topology/Closure.lean`、`docs/entries/topology/space/closure.md` | `ff1197b`（由负责人串联提交） | **通过（并纠正了负责人的计数错误）**。现场确认 4 个 marker、23/23 声明覆盖、orphan 文档 ref 改为 `munkres-topology-2000`、`MathlibBridge.lean`/`Basic.lean` 未被触碰。 |

**退回/纠正记录**：

- 负责人 RFC 初稿把 `Closure.lean` 的公开定理数写成 **21**，子 Agent B 报告实际为 **23**
  （Interior 7 + Closure 8 + Duality 2 + Frontier 6）。负责人现场重数确认 23 正确，
  已回改 RFC §2.3/§5 与结论表，并采用 B 的 23 个声明清单。**采纳，非退回。**
- 负责人给子 Agent A 的验证预期“`grep -c mathlib-compat` = 9（3 既有 + 6 改）”前提有误，
  实际为 13（12 个 marker 行 + 1 处模块头提及；改动前为 7）。A 主动指出并给出正确构成，
  现场复核一致。**负责人修正自己的检查预期，A 的改动通过。**
- 负责人 RFC 初稿写 `PolynomialIrreducibility.lean` 有 16 处标记，实际 **17 处标记 / 16 个声明**，
  已回改 RFC。

子 Agent 均未运行 git 写或 `lake`，未触碰 Main 共享文件，未删文件。

---

## 5. 诚实边界与未完成项

1. **未运行全库 `lake build`**；只做了 4 个模块级定向构建与依赖闭包构建。全库构建、
   生成器、`check_axioms.py --all`、`audit.py` 由 Main 在合并后执行。
2. **`topology.space.closure` 目前仍未进 Registry**——这是本窗口按权限边界有意留给 Main 的
   （维护人不得改 Registry）。在 Main 建记录前，它仍是“有文档/有标记、无 Registry”的过渡状态，
   RFC 的缺陷清单不因本窗口而把该项标为完全闭环。
3. **`abstract-algebra.poly.mathlib-compat` 现在覆盖 13 个声明**（含 4 个不可约近重复 + 2 个除法近重复）。
   负责人选择按迁移 handoff 改归兼容条目以避免跨文件；至于是否要更细的拆分或后续退役，
   属 Main/抽象代数窗口的政策决定，本轮不做。
4. **`Poly.lean` 近重复声明的退役**未做：需满足 ROLE 阶段 C 四条（下游计数为零、下游验收、
   Main 全库 build、回滚点），本轮不删任何声明。
5. **`abstract-algebra.poly.irreducible` 的 Registry `mathlib` 列表是过期的**（列的是旧 Poly 包装后端）；
   本窗口只写建议，未改 Registry。请 Main 在语义合并时按规范文件校正，否则该条目的
   “Mathlib 后端”继续误导读者。
6. `cont-integrable` 的登记 `axioms` 在 Main 重生成后会从 `[propext, Quot.sound]` 变为
   `[propext, Classical.choice, Quot.sound]`，这是**登记修正**不是数学变化（证明体未动）。
7. E1（`linear-algebra.*`）与 E2（`analysis.*`）缺陷未处理；RFC/对账输出里它们仍然出现，
   属其他窗口职责。
8. 本窗口未同步新 Main、未 rebase；若 Main 已发布新集成提交，合并前请按 AGENTS §9 处理
   （本分支为个人维护分支、未 push，可直接 `git rebase main`）。

## 6. 跨学科修改单列（Main 授权写者留痕）

| 学科 | 文件 | 改动性质 |
|---|---|---|
| 实分析 | `SandronesLibrary/RealAnalysis/Riemann.lean` | 2 处 Entry 标记插入（`:137` cont-integrable、`:300` eq-lebesgue） |
| 实分析 | `docs/entries/real-analysis/riemann/cont-integrable.md`、`eq-lebesgue.md` | 追加“Lean 声明集合”段落 |
| 抽象代数 | `SandronesLibrary/AbstractAlgebra/Poly.lean` | 6 处 Entry 标记改归 + 模块头 bullet 改写 |
| 抽象代数 | `docs/entries/abstract-algebra/poly/mathlib-compat.md` | 追加改归声明说明 |
| 拓扑 | `SandronesLibrary/Topology/Closure.lean` | 4 处 Entry 标记插入 |
| 拓扑 | `docs/entries/topology/space/closure.md` | `provenance.ref` 修正 + 追加 23 声明清单 |

未改动 `AbstractAlgebra/PolynomialIrreducibility.lean`、`Topology/MathlibBridge.lean`、
`SandronesLibrary/Basic.lean` 及任何 Main 共享文件。
