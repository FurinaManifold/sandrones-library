# Examples 巡视 — Wave R1 handoff

- **学科**：Examples（跨学科计算例巡视，`docs/roles/EXAMPLES-MAINTAINER-ROLE.md`）
- **分支**：`codex/examples-wave-r1`
- **worktree**：`/home/pisquare/czt/sandrones-library-examples-r1`（`.lake/packages` 符号链接到主 worktree）
- **基线**：`7dffe37`（Main `fix(main): subject package must check id -> narrative path convention`）
- **角色权限**：`development_open`（R-examples 窗口，ROADMAP Wave R）
- **提交**：
  - `735b26b1ecdff40b5f32da6b4aa91aec8ffdcfc8` examples(real-analysis): concrete RA-F2 measure-derivative examples
  - `12c8d617860c0f493e37ec74c37db8c771d701bc` examples(probability): concrete Pr3.5 CLT instantiation on Gaussian product space
  - `9d2d83ae76af010c412c9bcad951fa6870223c3d` examples(topology): closure/interior/frontier computations for Wave E entry topology.space.closure
- **未 push**。

## 1. 范围

本轮对**近期刚集成**的三条理论线补 Examples 正例／计算例／反例：

| 覆盖的原理论 Entry | 新 Examples Entry | Lean 源码 | 叙述层 |
|---|---|---|---|
| `real-analysis.measure-derivative.{absolute-continuity,mutually-singular,lebesgue-decomposition,radon-nikodym}`（RA-F2，Wave R1） | `examples.real-analysis.measure-derivative` | `SandronesLibrary/Examples/MeasureDerivative.lean` | `docs/entries/examples/real-analysis/measure-derivative.md` |
| `probability.clt.central-limit-theorem`（Pr3.5，Wave R1）、`probability.characteristic-function.levy-continuity` | `examples.probability.clt` | `SandronesLibrary/Examples/CentralLimit.lean` | `docs/entries/examples/probability/clt.md` |
| `topology.space.closure`（Wave E3 新登记条目） | `examples.topology.spaces` | `SandronesLibrary/Examples/TopologySpaces.lean` | `docs/entries/examples/topology/spaces.md` |

改动文件（相对基线）：
`SandronesLibrary/Examples/{MeasureDerivative,CentralLimit,TopologySpaces}.lean`、
`SandronesLibrary/Examples/README.md`、
`docs/entries/examples/{real-analysis/measure-derivative,probability/clt,topology/spaces}.md`。

## 2. 覆盖合同逐项对照

### 2.1 `examples.real-analysis.measure-derivative`

- 命名对象：`twoVolume := volume.withDensity (fun _ ↦ 2)`。
- 正例／计算：`twoVolume ≪ volume`、`twoVolume.rnDeriv volume =ᵐ 2`、`twoVolume [0,1] = 2`；
  `gaussianReal 0 1 ≪ volume`、`(gaussianReal 0 1).rnDeriv volume =ᵐ gaussianPDF 0 1`。
- 反例（精确反驳）：`¬ (dirac 0 ≪ volume)`——取零测集 `{0}`，`volume {0} = 0` 而 `dirac 0 {0} = 1`。
- 分解具体化：`(dirac 0).singularPart volume = dirac 0`、`(dirac 0).rnDeriv volume =ᵐ 0`，
  并重写主等式 `dirac 0 = dirac 0 + volume.withDensity 0`。
- 教材语义：Folland §3.2 的“密度”“互奇异”“分解”；正式承载即 Mathlib
  `Measure.AbsolutelyContinuous` / `MutuallySingular` / `rnDeriv` / `singularPart`（原学科已验收）。

### 2.2 `examples.probability.clt`

- 命名对象：`gaussianSpace := Measure.infinitePi (fun _ ↦ gaussianReal 0 1)`、坐标 `coordinate k`。
- 定义展开与性质：`coordinate_law`（边缘分布）、`coordinate_iIndepFun`、`coordinate_identDistrib`、
  `coordinate_memLp_two`、`coordinate_integral`（=0）、`coordinate_variance`（=1）。
- 上层使用／计算：`clt_gaussianCoordinates` 把六个假设逐项喂给
  `probability.clt.central-limit-theorem`，得到弱收敛；`clt_gaussianCoordinates_charFun`
  经 Lévy 接口读回特征函数极限 `exp (-t²/2)`。
- 反例／辨析：方差为零的常数序列不能代入 `σ > 0`，由 `degenerateVariance_centeredSum_tendsto`
  单独处理；ROADMAP E9P.8 要求的“特征函数逐点收敛本身不足以保证弱收敛”**本轮未构造 Lean 反例**
  （见 §5 边界）。

### 2.3 `examples.topology.spaces`

- 计算例：`closure (Ioo 0 1) = Icc 0 1`、`interior (Icc 0 1) = Ioo 0 1`、
  `frontier (Ioo 0 1) = {0,1}`。
- 反例：`closure (Ioo 0 1) ≠ Ioo 0 1`（开集不必闭）、`interior (Icc 0 1) ≠ Icc 0 1`（闭集不必开），
  均给出满足一边、不满足另一边的具体元素（`1` / `0`）。

## 3. 公开签名四类扫描

- **语义一致的正式公开承载（直接复用，不另造包装）**：
  `MeasureTheory.Measure.AbsolutelyContinuous`＋`≪`、`MutuallySingular`＋`⟂ₘ`、
  `Measure.rnDeriv`、`Measure.singularPart`、`Measure.withDensity`、
  `Measure.infinitePi`、`ProbabilityTheory.IdentDistrib`、`ProbabilityTheory.iIndepFun`、
  `closure`／`interior`／`frontier`。全部已是原学科验收的公开承载。
- **本库定义的桥一侧**：无。本批不新增任何 `def`／`structure`（仅新增 `twoVolume`、
  `gaussianSpace`、`coordinate` 三个例子对象命名定义，非概念定义）。
- **私有证明后端**：`memLp_map_measure_iff`、`integral_map`、`variance_map`、
  `lintegral_const`（`setLIntegral_const`）等只出现在证明体内，未作为公开前提／结论。
- **越级泄漏**：未发现。新增公开定理的类型只出现上述正式承载与初等等式。

## 4. 验证证据（现场命令与结果）

```bash
# 依赖闭包（首次，含 Mathlib 已有缓存）
lake build SandronesLibrary.RealAnalysis.MeasureDerivativeRadonNikodym \
           SandronesLibrary.Probability.CLTCenteredStandardized
# → Build completed successfully (8712 jobs)

# 逐模块定向构建
lake build SandronesLibrary.Examples.MeasureDerivative   # ✔ (8708 jobs)
lake build SandronesLibrary.Examples.CentralLimit        # ✔ (3230 jobs)
lake build SandronesLibrary.Examples.TopologySpaces      # ✔ (8708 jobs)

# 聚合 #check（临时文件 /tmp/sandrones-examples-check.lean，不入库）
lake env lean /tmp/sandrones-examples-check.lean
# → 27 条 #check 全部解析成功，无 error：
#   对象定义 → 基本性质 → 目标实例 → 计算／反例链完整（twoVolume…dirac_zero_lebesgueDecomposition、
#   coordinate_law…clt_gaussianCoordinates_charFun、closure_Ioo_zero_one…interior_Icc_ne_self）。

# 禁用占位扫描
grep -rnE '\b(sorry|admit|sorryAx|native_decide)\b' <三个新 Lean 文件>   # → none
git diff --check                                                         # → clean
df -h /                                                                  # 构建前后可用均 ≈ 15G（硬门 ≥3G）
```

- 未运行 `lake update` / `lake exe cache get`；未运行全库 `lake build`（Main 职责）。
- 未修改任何 Main 共享文件；`index/registry.json`、`SandronesLibrary.lean`、`reference.bib`、
  `docs/ROADMAP-examples.md` 等均未触碰。
- 学科包：见 §6。

## 5. 未完成边界（诚实披露）

1. **`examples.probability.clt` 的反例边界未 Lean 化**。E9P.8 记录的“特征函数逐点收敛本身
   不足以保证弱收敛（Lévy 定理必须用过连续性点或紧性条件）”本轮只在叙述层辨析，未构造
   Lean 反例——构造一个逐点收敛但极限在零点不连续的特征函数序列需要较重的测度逃逸构造，
   按 ROLE「不制造伪反例」暂缓。
2. **Wave E 新登记条目未全部覆盖**。本批只实例化了 `topology.space.closure` 一条；Wave E
   其余新登记条目（如 `real-analysis.riemann.cont-integrable`、`analysis.derivative.definition`、
   `linear-algebra.vector-space.dimension` 等）仍 `missing`，建议排入下一轮巡视。
3. **E0.2–E0.4 存量转正仍未做**。既有 `CoordinateIntegrals`／`SphericalMoments`／
   `GreenRegions`／`GaussStokes` 四个模块仍是 `partial`（无 Examples Entry 与课程文档），
   本批未处理。
4. **Registry／RADAR／ROADMAP 未更新**（Main 共享文件，按规程由 Main 处理）；新增 Entry 的
   `axioms`／`proof_sha`／`dependedOnBy` 由 Main 注册后跑 `check_axioms.py --all --fix` 生成。
5. 本批未对 `SandronesLibrary.lean` 增加顶层 import（Main 共享文件）。

## 6. 学科包自检

见本次交付提交后的现场运行结果（`python3 scripts/subject_package.py --worktree
/home/pisquare/czt/sandrones-library-examples-r1 --base 7dffe37 --subject examples`）；
异常清单与 verdict 以现场输出为准，若有异常逐条见本节补充。

（注：`--base 7dffe37` 下 `docs/handoffs/examples-wave-r1.md` 必须已提交，coverage 门才通过。）

## 7. 给 Main 的共享文件更新建议

1. **`index/registry.json`** 新增三条（id / family / kind / nl_file / lean_file / premises / mathlib / provenance）：
   - `examples.real-analysis.measure-derivative`，family `examples.real-analysis.measure-derivative`，
     kind `example`，premises 为四条 `real-analysis.measure-derivative.*`，
     provenance `folland-real-analysis-1999`；
   - `examples.probability.clt`，family `examples.probability.clt`，kind `example`，
     premises `probability.clt.central-limit-theorem`、`probability.characteristic-function.levy-continuity`，
     provenance `kallenberg-modern-probability-2021`；
   - `examples.topology.spaces`，family `examples.topology.spaces`，kind `example`，
     premises `topology.space.closure`，provenance `munkres-topology-2000`。
   注意这是本库**首批 `examples.*` Registry 条目**，此前 Registry 无 examples 前缀记录。
2. **`SandronesLibrary.lean`** 增加三条 import：
   `SandronesLibrary.Examples.MeasureDerivative`、`.CentralLimit`、`.TopologySpaces`
   （与既有四个 Examples 模块并列，见 `SandronesLibrary.lean:355-358`）。
3. **`docs/ROADMAP-examples.md`**（Main 共享，本分支未改）覆盖台账建议：
   - E8.6 `examples.real-analysis.signed-rn` 的备注“RA-F2 未开”应更新为 RA-F2 已集成，
     且测度导数例子已在 `examples.real-analysis.measure-derivative` 落地；
   - E9P.8 的“开工门 Pr3.5 ✅”之外，登记 Examples 状态由 `missing` → `partial`（正例已到，
     反例边界见 §5.1）；
   - E7.1 的 `examples.topology.spaces` 补登本批 closure/interior/frontier 计算例；
   - 本批未新增 `docs/ROADMAP-examples.md` 项目行（该文件为 Main 共享，只给建议）。
4. 注册后按 AGENTS §6 重跑生成器与 `check_axioms.py --all --fix`（新增 examples 条目的公理字段
   目前未生成），并执行一次全库 `lake build`。
