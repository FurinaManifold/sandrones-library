# Handoff — analysis Wave R1（AN-MV 多元微积分收尾，批次 AN-MV-R1）

## 0. 现场事实

- 主工作树：`/home/pisquare/czt/sandrones-library`（`main`，**只读**）。开工时基线 `7dffe37`；
  窗口期间 Main 已前进（加载到的新 AGENTS 快照为 `7dcf8d0`）。本学科分支按任务指定的
  `7dffe37` 开叉，未 rebase（工作区只写学科目录，未触碰任何共享文件）。
- 本学科 worktree：`/home/pisquare/czt/sandrones-library-analysis-r1`。
- 分支：`codex/analysis-wave-r1`，基线 `7dffe37`。
- `.lake/packages` 软链到主工作树；未运行 `lake update` / `lake exe cache get`。
- 磁盘：开工 `df -h /` 可用约 16G；复制基线 `SandronesLibrary` olean 缓存约 120M 以加速定向构建。
  未运行全库 `lake build`。交付时（构建后）可用约 11G。

## 1. 提交（`7dffe37..HEAD`）

| commit | 内容 |
|---|---|
| `b9bd91e` | `feat(analysis): piecewise-smooth region gluing for Green/Gauss/Stokes (AN-MV item 4)` |
| `841caec` | `feat(analysis): mass, centroid and moment of inertia interface (AN-MV item 5)` |
| `acd8c6d` | `feat(analysis): coordinate expressions of differential forms (AN-MV item 1)` |
| 本 handoff | `docs/handoffs/analysis-wave-r1.md` |

## 2. 范围（ROADMAP §2 `AN-MV 多元微积分收尾 🚧` 的剩余出口）

| # | ROADMAP 条目 | 本批 |
|---|---|---|
| 1 | `analysis.forms.coordinate-expression` | ✅ 交付 |
| 4 | `analysis.stokes.domain-gluing` | ✅ 交付 |
| 5 | `analysis.coordinate-integrals.mass-center` | ✅ 交付 |
| 2 | `analysis.forms.leibniz` | ⛔ 未交付（见 §7） |
| 3 | `analysis.forms.poincare` | ⛔ 未交付（见 §7） |
| 6 | `analysis.multivariable.course-boundary` | ⛔ 未交付（见 §7） |

上游 `analysis.multivariable` 家族（E2 登记维护后 10 个模块）为本批稳定依赖；三个新模块
互相独立，均只 import 已提交的上游模块。

## 3. 交付文件

- `SandronesLibrary/Analysis/FormCoordinateExpression.lean`
- `docs/entries/analysis/forms/coordinate-expression.md`
- `SandronesLibrary/Analysis/StokesDomainGluing.lean`
- `docs/entries/analysis/stokes/domain-gluing.md`
- `SandronesLibrary/Analysis/MassCenter.lean`
- `docs/entries/analysis/coordinate-integrals/mass-center.md`

三个 Entry id 的叙述层路径均满足 `docs/entries/{id 点换斜杠}.md` 规范。

## 4. 子 Agent 与负责人验收

| Worker | 所有权 | 结果 |
|---|---|---|
| A `b791fe3f…` | FormCoordinateExpression + 其条目 | 交付；负责人复核并定向构建 |
| B `f75aa6a2…` | StokesDomainGluing + 其条目 | 交付；负责人复核，修正 2 处 `show`→`change` linter 警告 |
| C `087bdf86…` | MassCenter + 其条目 | 交付；负责人复核 |

负责人（唯一验收人）逐文件审查数学陈述、公开签名、Mathlib 角色、no-sorry、编译与叙述层。

## 5. 概念清单（教材语义 → Lean 正式承载 → 展开 → 首个真实使用者 → Entry）

| 概念 | 教材语义 | Lean 正式承载 | 展开／一手性质 | Mathlib 角色 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|---|
| 坐标 1-形式 `dx_i` | 第 i 个坐标函数的微分；线性泛函 `v↦v_i` | `coordinateForm i`（由 `ContinuousAlternatingMap.ofSubsingletonLIE` 承载 `ContinuousLinearMap.proj i`） | `coordinateForm_apply` | `ContinuousAlternatingMap` 语义一致正式承载 | `oneForm_coordinate_expansion` | analysis.forms.coordinate-expression |
| 楔积 `dx_i∧dx_j` | shuffle 楔积的分量 | `coordinateTwoForm i j := formWedge (coordinateForm i) (coordinateForm j)` | `coordinateTwoForm_apply`（一般 1+1 楔积 `alternatingWedge_one_apply`） | 库内 `formWedge`／Mathlib `AlternatingMap.domCoprod` + `MultilinearMap.alternatization` 为正式后端 | `twoForm_coordinate_expansion_plane/space` | 同上 |
| 一般 1-形式／2/3-形式坐标展开 | 在标准基上写分量 | `Module.Basis.ext_alternating` 判定 | `oneForm_coordinate_expansion`、`twoForm_coordinate_expansion_{plane,space}` | `Pi.basisFun`、`Basis.ext_alternating` 语义一致 | 本 Entry 主定理 | 同上 |
| 体积形式 `dx₀∧dx₁∧dx₂` | 标准基取向的行列式 | `coordinateThreeForm`（`Basis.det` 的连续化，范数界 6） | `threeForm_coordinate_expansion_space`（`AlternatingMap.eq_smul_basis_det`） | `Module.Basis.det` 语义一致 | `threeForm_coordinate_expansion_space` | 同上 |
| 分段光滑区域 | 有限参数片 + 有向公共边/面抵消 | `PiecewiseSmoothRegion`（Prop 结构） | `PiecewiseSmoothRegion.toGreenFiniteDecomposition`、`twoPatchRegion_example` | 复用既有 `GreenFiniteDecomposition`/`orientedBoundaryValue`；本库新接口为桥 | `stokes_piecewiseSmoothRegion`、`green/gauss_piecewiseSmoothRegion`、`twoPatchRegion_stokes_example` | analysis.stokes.domain-gluing |
| 质量/一阶矩/重心/二阶矩/转动惯量 | 带密度区域上的重积分 | `mass`、`firstMoment`、`centroid`、`secondMoment`、`momentOfInertia` | `mass_one_eq_measureReal`、`momentOfInertia_expansion`、`momentOfInertia_parallel_axis` | Bochner/Lebesgue 集积分（`IntegrableOn`、`volume.real`）为语义一致正式承载 | `centroid_smul`、`momentOfInertia_parallel_axis` | analysis.coordinate-integrals.mass-center |
| 欧氏范数平方（桥） | 教材用欧氏距离 | `euclideanNormSq v = ∑ i, vᵢ²` | `euclideanNormSq_sub` | **桥**：`JordanEuc n = Fin n → ℝ` 默认带上确界范数而非欧氏范数，故显式引入 | `momentOfInertia` | 同上 |

### 公开签名四类扫描

1. **语义一致的正式公开承载**：`ContinuousAlternatingMap` / `AlternatingMap`（`DifferentialForm` 载体）、
   `ContinuousLinearMap.proj`、`Module.Basis.det`、`MeasureTheory` 集积分与 `IntegrableOn` / `volume.real`。
2. **本库桥**：`coordinateForm`/`coordinateTwoForm`/`coordinateThreeForm`（课程坐标载体，架在 Mathlib
   交替映射之上）；`PiecewiseSmoothRegion` + `toGreenFiniteDecomposition`（课程区域概念 → 既有分片测度数据）；
   `euclideanNormSq`（欧氏距离平方桥）；`mass`/`firstMoment`/`centroid`/`secondMoment`/`momentOfInertia`
   （课程积分量，架在集积分之上）。
3. **私有证明后端**：`twoPatchParameterDomain`、`twoPatchLocalIncidence`、`fin_two_three_classification`、
   `basis_det_norm_bound`。
4. **越级公开泄漏**：无。

## 6. 验证证据

- 逐模块定向构建（均 `rc=0`）：
  - `lake build SandronesLibrary.Analysis.FormCoordinateExpression`
  - `lake build SandronesLibrary.Analysis.StokesDomainGluing`
  - `lake build SandronesLibrary.Analysis.MassCenter`
  - 三个新文件均无 linter warning（B 的两处 `show` 已由负责人改为 `change`）。
- 联合聚合：`/tmp/analysis-r1/aggregate.lean`（同时 import 三个模块并 `#check` 正式承载、
  展开、桥与首个使用者）`rc=0`。
- 禁用占位：三个 `.lean` 文件均无 `sorry`/`admit`/`sorryAx`/`native_decide`。
- 公理（`#print axioms`，全部为标准结构集 `[propext, Classical.choice, Quot.sound]`，与 `ℝ` 序结构一致）：
  `alternatingWedge_one_apply`、`coordinateTwoForm_apply`、`oneForm_coordinate_expansion`、
  `twoForm_coordinate_expansion_plane`、`twoForm_coordinate_expansion_space`、
  `threeForm_coordinate_expansion_space`、`stokes_piecewiseSmoothRegion`、
  `stokes_closed_piecewiseSmoothRegion`、`green_piecewiseSmoothRegion`、`gauss_piecewiseSmoothRegion`、
  `stokes_twoPatch_sharedEdge`、`twoPatchRegion_stokes_example`、`mass_add`、
  `mass_one_eq_measureReal`、`centroid_smul`、`momentOfInertia_parallel_axis`。
- `git diff --check`：干净；`git status --short` 交付后干净。
- 学科验收包：见 §8 末尾（`subject_package.py` 结果）。
- 未运行全库 `lake build`（由 Main 在集成阶段执行）。

## 7. 公开 import / Registry / ROADMAP / RADAR 更新建议（Main 维护，学科未改）

- **顶层 import**（`SandronesLibrary.lean`，按字母序插入）：
  ```
  import SandronesLibrary.Analysis.FormCoordinateExpression
  import SandronesLibrary.Analysis.MassCenter
  import SandronesLibrary.Analysis.StokesDomainGluing
  ```
- **Registry 建议条目**（`index/registry.json`，字段示例；`proof_sha`/`axioms`/`dependedOnBy` 由生成器产出）：
  - `id: analysis.forms.coordinate-expression`，`kind: theorem`，`state: verified`，
    `title: 欧氏空间上微分形式的坐标表达式`，`premises: [analysis.multivariable.differential-forms]`，
    `provenance.ref: spivak-calculus-manifolds-1965`，
    `lean_file: Analysis/FormCoordinateExpression.lean`，
    `nl_file: docs/entries/analysis/forms/coordinate-expression.md`。
  - `id: analysis.stokes.domain-gluing`，`kind: theorem`，`state: verified`，
    `premises: [analysis.multivariable.green-gauss-stokes, analysis.multivariable.second-kind-integrals]`，
    `provenance.ref: spivak-calculus-manifolds-1965`，
    `lean_file: Analysis/StokesDomainGluing.lean`，
    `nl_file: docs/entries/analysis/stokes/domain-gluing.md`。
  - `id: analysis.coordinate-integrals.mass-center`，`kind: theorem`，`state: verified`，
    `premises: [analysis.multivariable.coordinate-integrals, analysis.multivariable.change-variables]`，
    `provenance.ref: ecnu-mathematical-analysis-5`，
    `lean_file: Analysis/MassCenter.lean`，
    `nl_file: docs/entries/analysis/coordinate-integrals/mass-center.md`。
- **ROADMAP**：`AN-MV` 表内 #1/#4/#5 可标 ✅；#2（Leibniz）、#3（Poincaré）、#6（course-boundary）仍为未完成。
- **RADAR**：可登记 `AlternatingMap.domCoprod`、`MultilinearMap.domCoprod_alternization_eq`、
  `Module.Basis.ext_alternating`、`AlternatingMap.eq_smul_basis_det`、`MeasureTheory.setIntegral_union` 等
  作为正式承载，并注明角色（正式承载，非本库自建）。

## 8. 学科验收包自检

- 命令：`python3 scripts/subject_package.py --worktree /home/pisquare/czt/sandrones-library-analysis-r1 --base 7dffe37 --subject analysis`
- 结果：**verdict: pass**（五组门 cleanliness / ownership / semantics / proof / coverage 全 pass，异常清单空）。
  详见会话记录；包文件不写入 `docs/subject-packages/`（Main 侧台账）。

## 9. 未完成边界（诚实声明）

- **未交付 AN-MV #2 `analysis.forms.leibniz`**：外微分对楔积的分次 Leibniz 需要 `domCoprod` 与
  `extDeriv_apply` 的 shuffle 组合学，本窗口未开展。
- **未交付 AN-MV #3 `analysis.forms.poincare`**：星形域上的 Poincaré 引理需要同伦算子与形式沿路径的积分，
  本窗口未开展。
- **未交付 AN-MV #6 `analysis.multivariable.course-boundary`**：作为分析 II 覆盖范围与 de Rham 边界的
  综合出口，本窗口未开展。
- **坐标展开的覆盖边界**：一般 `n` 只证 1-形式展开；2-形式仅 `ℝ²`/`ℝ³`；3-形式仅 `ℝ³` 且 `k = n`；
  未涉及 `k ≥ 4`、一般维数 `k`-形式展开，也未涉及外微分或积分公式。
- **Stokes 拼接为代数接口层**：局部 Green/Gauss/Stokes 公式以假设 `hlocal` 输入；参数域固定为
  `ℝ × ℝ`；三维 Gauss 直接接收 `GaussFiniteDecomposition`；一般光滑流形、图册细化与单位分解不在覆盖范围。
- **转动惯量**：经典平行轴定理（取重心向量时交叉项消去）未证；已交付 `momentOfInertia_expansion` 与
  `momentOfInertia_parallel_axis` 的诚实展开形式。重心为全函数，`mass = 0` 时除零取 0。
- 未运行全库 `lake build`；本批结论只到“三模块 + 依赖闭包 + 联合聚合 `#check`”。
