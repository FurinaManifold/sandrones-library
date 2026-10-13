# RFC：跨学科登记完整性维护（Wave E / E3）

- 维护分支：`codex/registry-integrity-maintenance`
- worktree：`sandrones-library-registry-integrity`
- 基线 Main：`52021fe`（派工提交 `52021fe docs(main): dispatch Wave E registry integrity maintenance windows`）
- 角色：学科维护负责人（`docs/roles/SUBJECT-MAINTENANCE-ROLE.md`），权限 🚧
- 授权文件分片（Main 明确授予，互不重叠）：
  1. 实分析 `RealAnalysis/Riemann.lean`
  2. 抽象代数 `AbstractAlgebra/Poly.lean` + `AbstractAlgebra/PolynomialIrreducibility.lean`
  3. 拓扑 `Topology/Closure.lean` + `Topology/MathlibBridge.lean`
  - 只读判定对象：`SandronesLibrary/Basic.lean`
- 对应 ROADMAP：`docs/ROADMAP-LONGTERM.md` Wave E 表 E3 行 + D-4 第 4 项 (b)/(d)/(e) 的跨学科部分。
- 本 RFC 是**第一份交付**：先给只读影响图与声明归属判定，再动源码。

> 本 RFC 不修改任何 Main 共享文件。Registry `state`／`lean_file`／`premises`／`mathlib`、
> 根 import（`SandronesLibrary.lean`）、RADAR、ROADMAP 的更新建议全部写进
> `docs/handoffs/registry-integrity-maintenance-cross-subject.md`，由 Main 执行。

---

## 0. 结论速览

| 分片 | 对象 | 判定 | M 级 | 本轮动作 |
|---|---|---|---|---|
| ① | `real-analysis.riemann.cont-integrable` 标记缺失 | 定理真实存在、内容唯一 | M1 | 在 `Riemann.lean` 插入 2 个标记，把连续可积段与 eq-lebesgue 机器段切开 |
| ② | `abstract-algebra.poly.irreducible` 标记横跨两文件 | Registry `lean_file` 正确指向 `PolynomialIrreducibility.lean`；`Poly.lean` 6 处是迁移后残留的历史包装 | M1 | 把 `Poly.lean` 6 个标记改归 `abstract-algebra.poly.mathlib-compat`，不删声明 |
| ③ | `Topology/Closure.lean` 无标记 + orphan 文档 `topology.space.closure` | 内容唯一、有库内导入者，Mathlib 包装语义有效 | M1 | 在 `Closure.lean` 补 `topology.space.closure` 标记；文档保留待 Main 补 Registry 记录（并修 `provenance.ref`） |
| ④ | `Topology/MathlibBridge.lean`、`SandronesLibrary/Basic.lean` | **基础设施，长期豁免 Entry 标记** | 无源码变更（M0） | 只写规则进本 RFC 与 handoff |

**没有任何分片需要新 Entry id，因此本轮没有 M3 项。**

---

## 1. 缺陷验证（本负责人现场重跑，原文）

工具：现场 Python 脚本 `/tmp/verify_registry.py`，对 Registry `index/registry.json`、
源码 `SandronesLibrary/**/*.lean` 的 `> **Entry**: <id>` 标记、
`docs/entries/**/*.md` front matter 的 `id:` 做双向对账。现场结果：

```text
======================================================================
REGISTRY vs SOURCE MARKER VERIFICATION (rerun by E3 lead)
======================================================================
registry entries: 575  unique ids: 575
lean files with >=1 marker: 328 / 356
distinct marker ids in source: 574  marker occurrences: 1592

--- A. ids in Registry but NO source marker ---
count=2
  linear-algebra.vector-space.dimension  state=verified  lean_file=LinearAlgebra/VectorSpace.lean
  real-analysis.riemann.cont-integrable  state=verified  lean_file=RealAnalysis/Riemann.lean

--- B. ids with source marker but NOT in Registry ---
count=1
  analysis.derivative.definition  files=['SandronesLibrary/Analysis/Derivative.lean']

--- C. same id in MULTIPLE lean files (AGENTS 6 violation) ---
count=2
  abstract-algebra.poly.irreducible
      SandronesLibrary/AbstractAlgebra/Poly.lean:62
      SandronesLibrary/AbstractAlgebra/Poly.lean:69
      SandronesLibrary/AbstractAlgebra/Poly.lean:76
      SandronesLibrary/AbstractAlgebra/Poly.lean:83
      SandronesLibrary/AbstractAlgebra/Poly.lean:90
      SandronesLibrary/AbstractAlgebra/Poly.lean:97
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:21
      ...（PolynomialIrreducibility.lean 共 17 处标记，对应 16 个声明）
  linear-algebra.matrix.normal
      SandronesLibrary/LinearAlgebra/NormalMatrix.lean:16
      SandronesLibrary/LinearAlgebra/NormalSpectral.lean:16

--- D. lean files with NO marker (count) ---
count=28
  ...（22 实质模块 + 4 Examples + Basic.lean + Topology/MathlibBridge.lean；
      其中本窗口相关的是 SandronesLibrary/Topology/Closure.lean）

--- E. docs/entries/**/*.md declared id: not in Registry ---
doc files with id: 590  orphan docs: 15
  ...
  topology.space.closure   <- docs/entries/topology/space/closure.md

--- G. registry lean_file missing or lack the marker ---
  NO MARKER IN lean_file linear-algebra.vector-space.dimension lean_file=LinearAlgebra/VectorSpace.lean
  NO MARKER IN lean_file real-analysis.riemann.cont-integrable lean_file=RealAnalysis/Riemann.lean
```

与 D-4 第 4 项的差异（本窗口需要知道的）：

- `abstract-algebra.poly.irreducible` 不是“2 处”，而是 `Poly.lean` **6 处**（`:62,69,76,83,90,97`）
  加 `PolynomialIrreducibility.lean` **17 处标记**（对应 16 个声明）。D-4 原文只举了 `:62,69`。
- `Topology/Closure.lean` 在 D-4 (d) 的“无标记模块”清单内，且 `docs/entries/topology/space/closure.md`
  在 (d) 的 orphan 文档清单内。
- `Basic.lean`、`Topology/MathlibBridge.lean` 在 D-4 (d) 中被点名“2 个是基础设施”。

### 1.1 `map_entry_to_decl`（`check_axioms.py` 的“最近前置标记”）现场读数

用 `scripts/check_axioms.py` 自带的 `map_entry_to_decl` 现场求出归属（修改前）：

```text
==== SandronesLibrary/RealAnalysis/Riemann.lean
  real-analysis.riemann.def: [DarbouxPartition, lowerSum, upperSum, RiemannIntegrable,
    riemannIntegral, uniformPartition, uniformPartition_step, step_sum, uniform_x_mem,
    interval_width, b3_osc, C2_subinterval,
    continuous_on_riemannIntegrable_lt, continuous_intervalIntegrable,
    integral_indicator_const_Ioc ... interval_le_sSup_lowerSum_add]   ← 39 个声明
  real-analysis.riemann.eq-lebesgue: [riemannIntegral_eq_interval]

==== SandronesLibrary/AbstractAlgebra/Poly.lean
  abstract-algebra.poly.irreducible: [irreducible_mul_iff, irreducible_X_sub_C, irreducible_X,
    irreducible_of_degree_eq_one, modByMonic_eq_zero_iff_dvd, degree_modByMonic_lt]
  abstract-algebra.poly.mathlib-compat: [poly_ext, is_root_iff_eval_eq_zero,
    dvd_X_sub_C_iff_isRoot, poly_is_domain_of_is_domain, poly_isUnit_iff,
    mem_roots_iff_isRoot, root_mul_iff]
  abstract-algebra.poly.roots-card: [card_roots_le_degree]

==== SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean
  abstract-algebra.poly.irreducible: [irreducible_factor_isUnit, irreducible_X_sub_C,
    irreducible_X, field_irreducible_of_degree_eq_one, primitive_iff_constant_dvd_isUnit,
    monic_isPrimitive, primitive_mul, primitive_iff_content_eq_one,
    eq_C_content_mul_primPart, content_mul, integer_gauss_irreducible_iff_rational_irreducible,
    integer_rational_root_num_dvd_constant, integer_rational_root_den_dvd_leading,
    monic_rational_root_is_integer, irreducible_of_isEisensteinAt,
    integer_prime_eisenstein_irreducible]   ← 16 个声明
```

两条结论：

1. `real-analysis.riemann.cont-integrable` 在 `Riemann.lean` 的映射里**完全不存在**，
   而它的 2 个定理（`:185`、`:290`）连同 eq-lebesgue 的整段机器共 **39 个声明**
   被并到 `real-analysis.riemann.def` 名下。`check_axioms.py --full` 对该 Entry
   走 `[SKIP] ... lean 文件未关联到带 **Entry** 标记的定理`（`check_axioms.py:224`），
   即它长期不参与公理审计——这正是 D-4 说的“两条长期 SKIP”之一。
2. `abstract-algebra.poly.irreducible` 在 `Poly.lean` 里确实映射出 6 个声明，
   但 `check_axioms.py` 只按 Registry 的 `lean_file`（`PolynomialIrreducibility.lean`）
   探测，所以这 6 个声明反而**既不被本 Entry 审计、也不属于任何被审计 Entry**；
   同时 `gen_entry_rankings.py:103` 的 `rglob` 按字典序先扫到 `Poly.lean`
   （`Poly.lean` < `PolynomialIrreducibility.lean`），把本 Entry 的“主声明”
   误认成 `irreducible_mul_iff`。这就是 D-4 (f) 观察到的排名歧义来源之一。

---

## 2. 只读影响图

### 2.1 分片 ① `real-analysis.riemann.cont-integrable`（`RealAnalysis/Riemann.lean`）

- **当前公开接口**（源码位置）：
  - `SandronesLibrary.RealAnalysis.Riemann.b3_osc`（`:137`）
  - `SandronesLibrary.RealAnalysis.Riemann.C2_subinterval`（`:163`）
  - `SandronesLibrary.RealAnalysis.Riemann.continuous_on_riemannIntegrable_lt`（`:185`）
  - `SandronesLibrary.RealAnalysis.Riemann.continuous_intervalIntegrable`（`:290`）
- **角色分类**：4 个都是**本库自建证明**（`RiemannIntegrable`、`sSup/sInf`、一致连续），
  不是 Mathlib 薄包装；`RiemannIntegrable`／`DarbouxPartition` 来自本库 `riemann.def`。
- **直接引用者**：
  - `continuous_on_riemannIntegrable_lt`：`RealAnalysis/RiemannAlgebra.lean:32`；
    `Riemann.lean:879`（`interval_le_sSup_lowerSum_add`，eq-lebesgue 机器段内部）。
  - `continuous_intervalIntegrable`：`RiemannAlgebra.lean:48,49,60,61,89,114`。
  - `b3_osc`：仅 `Riemann.lean:179`（`C2_subinterval` 内部）。
  - `C2_subinterval`：仅 `Riemann.lean:244`（`continuous_on_riemannIntegrable_lt` 内部）。
  - 库内无其他文件引用这 4 个名字。
- **imports 闭包 / 下游**：`SandronesLibrary.RealAnalysis.Riemann` 被
  `RealAnalysis/RiemannAlgebra.lean`、`RealAnalysis/RiemannCriterion.lean` 与根
  `SandronesLibrary.lean:173` 导入；`RiemannIntegralBridge.lean` 经 `RiemannCriterion` 间接依赖。
  定向构建需覆盖 `Riemann`、`RiemannAlgebra`、`RiemannCriterion`、`RiemannIntegralBridge`。
- **premises／dependedOnBy**：
  - `cont-integrable.premises = [riemann.def, analysis.continuity.uniform-compact,
    analysis.continuity.uniform]`；`dependedOnBy = [riemann.algebra, riemann.eq-lebesgue,
    riemann.lebesgue-criterion]`。
  - `riemann.def.dependedOnBy = [riemann.cont-integrable, riemann.eq-lebesgue,
    riemann.eq-lebesgue-general, riemann.lebesgue-criterion]`。
  - 修复只改“声明→Entry”映射，不改 `premises` 图，因此 `dependedOnBy` 不变。
- **RADAR 谁在用**：`docs/MATHLIB-RADAR.md:1845-1850`
  「黎曼积分自建全套（… `continuous_on_riemannIntegrable_lt`）——谁在用：`real-analysis.riemann.cont-integrable`」。
- **别名／间接暴露**：本库没有给这些定理起别名；`open SandronesLibrary.Analysis.Continuity`
  只影响一致连续名称，不改变归属。无 notation／simp 属性涉及。

### 2.2 分片 ② `abstract-algebra.poly.irreducible`（两文件）

- **Registry 权威归属**：`lean_file = AbstractAlgebra/PolynomialIrreducibility.lean`，
  `nl_file = docs/entries/abstract-algebra/poly/irreducible.md`。迁移 handoff
  `docs/handoffs/abstract-algebra-a3-polynomial-irreducibility.md:33-34` 已明确要求
  「旧 `Poly.lean` 中同 Entry 的历史包装应由 Main 改归兼容 Entry，避免跨文件 Entry」。
- **`Poly.lean` 那 6 个声明的实际内容**（现场核对 `Poly.lean:64,71,78,85,92,99`）：
  | 声明 | 数学内容 | 与谁重复 |
  |---|---|---|
  | `irreducible_mul_iff` | 任意 `Monoid M` 上不可约元的分解判据 | 规范版 `irreducible_factor_isUnit`（`Polynomial R`）的更一般形状 |
  | `irreducible_X_sub_C` | `X - C a` 不可约 | 规范版同名定理 |
  | `irreducible_X` | `X` 不可约 | 规范版同名定理 |
  | `irreducible_of_degree_eq_one` | 域上次数 1 不可约 | 规范版 `field_irreducible_of_degree_eq_one` |
  | `modByMonic_eq_zero_iff_dvd` | 首一除法余式为零 ↔ 整除 | `division` 的 `mathlib_monic_remainder_eq_zero_iff_dvd` |
  | `degree_modByMonic_lt` | 余式次数 < 除式次数 | `division` 的 `mathlib_monic_remainder_degree_lt` |
- **库内使用计数**：6 个名字在 `Poly.lean` 之外的**真实库内使用为 0**
  （`PolynomialIrreducibility.lean`／`PolynomialDivision.lean` 里的同名匹配是
  `Polynomial.irreducible_X` 这类 Mathlib 限定名，不是本库声明）。
- **角色分类**：4 个是**本库对 Mathlib 不可约判据的薄包装**，2 个是**薄除法包装**；
  均无新数学，属于 A3.1/A3.3 迁移后的历史兼容层。
- **直接影响**：改标记后 `gen_entry_rankings.py` 对本 Entry 的“主声明”将从
  `Poly.lean:irreducible_mul_iff` 变为 `PolynomialIrreducibility.lean:irreducible_factor_isUnit`，
  与 Registry `lean_file` 一致；`mathlib-compat` 进入 `check_axioms.py` 的探测集合
  （它当前 `lean_file = Poly.lean`，探测 7 个声明，改后 13 个）。
- **premises／dependedOnBy**：两文件均不因此改动；`poly.factorization` 对
  `poly.irreducible` 的 `dependedOnBy` 不变。
- **RADAR**：`docs/MATHLIB-RADAR.md:1468` 的 GaussLemma「谁在用：`abstract-algebra.poly.irreducible`」
  仍然成立（Gauss/Eisenstein 在规范文件里）。
- **文档**：`docs/entries/abstract-algebra/poly/mathlib-compat.md` 的“陈述（Lean 对照）”
  当前只列 7 个声明，需补上改归的 6 个；`irreducible.md` 保持描述规范文件内容，不改。

### 2.3 分片 ③ `Topology/Closure.lean` + orphan `topology.space.closure`

- **内容清单**（23 个公开定理，全是 Mathlib `interior`/`closure`/`frontier` 的命名包装）：
  - Interior：`interior_eq_sUnion_open_subsets`、`isOpen_interior'`、`interior_subset_self`、
    `subset_interior_of_isOpen`、`mem_interior_iff_open_neighborhood`、
    `interior_eq_self_iff_isOpen`、`interior_mono'`
  - Closure：`closure_eq_sInter_closed_supersets`、`subset_closure_self`、`isClosed_closure'`、
    `closure_subset_of_isClosed`、`closure_eq_self_iff_isClosed`、`closure_mono'`、
    `closure_union'`、`mem_closure_iff_open_neighborhood_meets`
  - Duality：`closure_eq_compl_interior_compl'`、`interior_compl'`
  - Frontier：`frontier_eq_closure_sdiff_interior`、`frontier_eq_two_closures`、
    `isClosed_frontier'`、`frontier_compl'`、`closure_eq_interior_union_frontier'`、
    `closure_eq_self_union_frontier'`
- **与已登记条目重复度**：`Topology/Space.lean` 不含任何 `interior/closure/frontier` 声明
  （现场 grep 为空），Registry 现有 13 个 `topology.space.*` 条目无一覆盖本模块；
  23 个名字全库唯一。
- **库内导入者计数**：`grep -rl "import SandronesLibrary.Topology.Closure"` = 2 个：
  `SandronesLibrary.lean:148`（根 import，参与全库构建）与
  `Analysis/JordanRegion.lean:7`。JordanRegion 使用 Mathlib 的 `frontier`/`closure`/`interior`
  （`:28,41-59`），未引用本模块的包装名。
- **结论证据**：内容唯一 + 被根 import 与 JordanRegion 依赖 + 无任何替代模块 ⇒
  **“内容唯一 → 补 Entry 登记”**，不满足退役条件（ROLE 阶段 C 第 1 条“旧 API 使用计数为零”
  在“导入者计数为零”的意义下也不成立：根 import 与 JordanRegion 都在用）。
- **orphan 文档**：`docs/entries/topology/space/closure.md` 的正文与本模块一一对应，
  **应随本次登记补 Registry 记录**，不得删除。其 front matter 有两个 Main 需修的问题：
  - `provenance.ref` 写成中文自由文本 `"点集拓扑：内部、闭包与边界"`，不是 `reference.bib` key；
    AGENTS §6 要求只存 key。建议改为现成 key `munkres-topology-2000`
    （`reference.bib:151`，正文已有章节定位）。
  - `kind: theorem-family` 与 Registry 现有 `kind` 取值需要 Main 确认规范化。
- **RADAR**：`docs/MATHLIB-RADAR.md:2241-2245` 已把「`interior` / `mem_closure_iff`」的
  “谁在用”记作 `topology.space.closure`——登记该 Entry 正好与 RADAR 现有记录一致。

### 2.4 判定 ④ 基础设施：`Topology/MathlibBridge.lean`、`SandronesLibrary/Basic.lean`

- `Basic.lean`（26 行）：只 `import Mathlib`、开 `namespace SandronesLibrary`、
  一个 `example (n m : Nat)` 冒烟测试；**没有任何数学声明**。被根 `SandronesLibrary.lean:1`
  导入。判定：基础设施。
- `Topology/MathlibBridge.lean`（41 行）：模块头自称
  “the only permitted dependency direction: a Sandrone textbook topology may be installed
  locally as a Mathlib topology. Core textbook modules must not import this file.”
  声明 3 个：`toMathlib`（实例安装桥）、`@[simp] isOpen_toMathlib`、`continuous_iff_mathlib`。
  唯一库内导入者是 `Topology/MathlibCompatibility.lean`（已登记的
  `topology.foundation.mathlib-compatibility` 条目）。判定：基础设施 / 实现桥。
- **长期排除规则（建议 Main 落到 AGENTS 或 Main 侧清单）**：
  1. 维护一份**显式路径白名单**（不做文件名模式匹配，因为 `MathlibCompatibility.lean`
     是已登记条目、名字里同样有 “Mathlib”），初始内容仅：
     `SandronesLibrary/Basic.lean`、`SandronesLibrary/Topology/MathlibBridge.lean`。
  2. 白名单文件的允许内容：命名空间/文件脚手架、冒烟 `example`、
     为其他模块安装 typeclass/instance 的桥、notation；**不得首次引入任何学科的教材核心概念**。
  3. 白名单之外、又无 `**Entry**` 标记的 `.lean` 文件一律视为登记缺陷；
     `Examples/**` 在 Examples 学科开工前整体豁免（D-4 (d) 的 4 个文件），开工后重新审计。
  4. 增删白名单条目需要 Main 的一次 RFC + 集成提交；白名单是登记完整性审计的输入，
     不是“人工记忆”。

---

## 3. 分片 ① 详细判定与切分

### 3.1 “连续可积”条目的确切声明集合

本负责人判定 `real-analysis.riemann.cont-integrable` **恰好包含 4 个声明**：

| 声明 | 行 | 归属理由 |
|---|---|---|
| `b3_osc` | 137 | 振荡界（源码标注 “B3”）：全库唯一使用者是 `continuous_on_riemannIntegrable_lt`；Registry `cont-integrable.summary` 明写“振荡界完全自证” |
| `C2_subinterval` | 163 | 子区间振荡界（源码标注 “C2”）：全库唯一使用者同上；是 `b3_osc` 到子区间版的教材组装 |
| `continuous_on_riemannIntegrable_lt` | 185 | 主定理（D-4 (b) 点名） |
| `continuous_intervalIntegrable` | 290 | Lebesgue 区间可积版本（D-4 (b) 点名），是主定理的 `IntervalIntegrable` 出口 |

**留在 `real-analysis.riemann.def` 的**：`DarbouxPartition`、`lowerSum`、`upperSum`、
`RiemannIntegrable`、`riemannIntegral`、`uniformPartition`、`uniformPartition_step`、
`step_sum`、`uniform_x_mem`、`interval_width`。理由：这些是定义与定义的结构性质
（Registry `def.summary` 明列“均匀分划”）；`interval_width` 是通用区间宽度引理，
被 `C2_subinterval` 跨条目使用，属 `def` 层基础（跨 Entry 引用不违反“一个 id 一个文件”）。

### 3.2 切分与“恢复后续归属”

在 `Riemann.lean` 插入两个标记：

1. 在 `b3_osc` 的 docstring 内（`:135` 之后）插入
   `> **Entry**: real-analysis.riemann.cont-integrable`。
2. 在 `integral_indicator_const_Ioc` 的 docstring 内（`:296` 之后）插入
   `> **Entry**: real-analysis.riemann.eq-lebesgue`。

为什么第 2 个标记是 `eq-lebesgue` 而不是再放一个 `riemann.def`：

- `:296`–`:902` 整段是靠 `continuous_on_riemannIntegrable_lt` ＋
  `darboux_lower_le_interval`／`darboux_upper_ge_interval`／`interval_le_sSup_lowerSum_add`
  给 `riemannIntegral_eq_interval`（`:909`，Entry `eq-lebesgue`）做“达布和=阶梯积分＋夹逼”
  的证明后端；现场核对 `riemannIntegral_eq_interval` 的函数体确实调用
  `riemannIntegral_le_interval`（`:914`）与 `interval_le_sSup_lowerSum_add`（`:921`）。
- `eq-lebesgue` 的 Registry `summary` 是
  “达布和=阶梯积分+夹逼，全自证”，`mathlib = [integral_indicator, integral_mono,
  integrableOn_const, lintegral]`——与该段机器一一对应。
- 若改放 `riemann.def`，会把“指标函数积分/阶梯积分/夹逼”误并进“黎曼积分定义”，
  正是本任务警告的“把整段机器算错条目”。因此恢复标记取 `eq-lebesgue`。

两种归属都自洽：`cont-integrable` 段只含连续可积内容；`eq-lebesgue` 段只含其证明后端；
`riemann.def` 只剩定义层。`eq-lebesgue` 原有 `:907` 标记保留，起“主定理前再确认”作用。

### 3.3 语义与等级

- 不改变任何公开签名、证明体、名字或 `premises`；只改声明→Entry 的登记映射。
- `old_iff_new` 无需证（无数学变化）；本项**不是 M2/M3**。
- 等级 **M1**：给一条已 `verified` 的 Entry 补回它的真实声明集合（登记/审计层面变化），
  旧接口完整保留。可回滚点=单个 docstring 标记插入。

---

## 4. 分片 ② 详细判定与切分

- 判定：Registry `lean_file` 正确；`PolynomialIrreducibility.lean` 的 16 个声明（17 处标记）
  是该 Entry 的正式内容，**保留其 17 处标记不动**。
- `Poly.lean` 的 6 个标记：按 A3.3 handoff 的明确指示**改归兼容 Entry**
  `abstract-algebra.poly.mathlib-compat`（把 id 文本改成该 id，不删标记、不删声明）。
  这样：一个 id 只落一个文件；6 个声明重新进入审计（归入 compat 条目）；
  `mathlib-compat.md` 需补列它们。
- 不另立新 id：这 6 个声明没有新数学，4 个与规范不可约条目近重复、2 个与 `division`
  条目近重复；另立 id 会制造重复 Entry，违反“不得为减少工作量把不同概念登记成同一 Entry”
  的镜像原则。重复声明的**退役**留给后续窗口（需 `division`／抽象代数负责人按其阶段 C 处理），
  本轮只做零风险的登记归属修复。
- 等级 **M1**：登记归属变化，公开签名与数学不变；`mathlib-compat` 的文档/Registry 元数据
  由 Main 更新。可回滚点=单个 marker 文本替换。

---

## 5. 分片 ③ 详细判定与切分

- 判定：**补 Entry 登记**（不申请退役）。
- 在 `Closure.lean` 每个 declaration 段前补 `> **Entry**: topology.space.closure` 标记
  （或按 `map_entry_to_decl` 的“最近前置”语义，在文件头部/每段 docstring 内放置标记，
  使 23 个声明全部落到该 id；现场实现采用逐段 marker，避免整文件只有一个标记时
  `gen_entry_rankings.py` 的 `ENTRY_DECL_RE` 过度贪婪解析）。
- orphan 文档 `docs/entries/topology/space/closure.md`：保留，随本次登记补 Registry；
  Main 需修 `provenance.ref` → `munkres-topology-2000`（或学科确认的合规 key）。
- 等级 **M1**：新增一个 Entry 登记（内容已存在且已通过既有验收），不改数学/签名。

---

## 6. 迁移波次、回滚与删除条件

本轮是**单阶段登记修复**（不是 M2 三阶段迁移）：

1. 波次 1（本提交）：`Riemann.lean` 标记切分、`Poly.lean` 标记改归、`Closure.lean` 补标记、
   对应 `docs/entries/**` 文档补声明清单。
2. 波次 2（Main）：更新 Registry／RADAR／ROADMAP／根 import，跑生成器＋公理审计＋audit＋全库 build。
3. 波次 3（后续窗口，可选）：对 `Poly.lean` 6 个近重复声明做退役评估
   （需下游计数为零＋Main 全库 build＋单独提交）。**本轮不做。**

回滚：本窗口改动均为 `> **Entry**:` 标记行与条目文档，`git revert` 单个提交即可；
不触碰证明体，任何回滚都不会改变 Lean 语义。

---

## 7. 本轮不处理

- E1 的 `linear-algebra.vector-space.dimension` 与 `linear-algebra.matrix.normal`（线性代数窗口）。
- E2 的 `analysis.derivative.definition` 与 10 个 Analysis 无标记模块／9 个 orphan 文档。
- D-4 (d) 其余 21 个无标记实质模块与 14 个其他 orphan 文档。
- `Poly.lean` 近重复声明的删除、`Closure.lean` 包装名的下游改用（JordanRegion 目前用 Mathlib 原语）。
- 任何 Main 共享文件。

---

## 8. 验收计划

1. 修改模块单独编译：`lake build SandronesLibrary.RealAnalysis.Riemann`、
   `SandronesLibrary.AbstractAlgebra.Poly`、`SandronesLibrary.AbstractAlgebra.PolynomialIrreducibility`、
   `SandronesLibrary.Topology.Closure`。
2. 依赖闭包：上述模块 import 闭包；重点定向构建 `RiemannAlgebra`、`RiemannCriterion`、
   `RiemannIntegralBridge`、`Analysis.JordanRegion`、`Topology.MathlibCompatibility`。
3. 聚合 `#check` 覆盖“承载→展开→桥→使用者”（见 handoff 的验证记录）。
4. Entry／文档 id／角色一致性：重跑 `/tmp/verify_registry.py` 双向差集。
5. `sorry`/`admit`/`sorryAx`/`native_decide` 扫描。
6. `git diff --check` 与工作树清洁。

不运行全库 `lake build`（Main 职责）。
