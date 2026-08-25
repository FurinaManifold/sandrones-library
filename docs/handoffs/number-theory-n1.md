# N1 初等数论：集成交接清单

本文件记录 N1 初等数论的最终集成和维护证据。N1.1–N1.5 已全部进入 `main`；当前共有
11 个 Lean 模块、21 个 Registry 条目和 21 篇课程文档。原 staging 分支只保留历史来源，
不再是验收依据。

## 顶层导入

`SandronesLibrary.lean` 的数论区已经包含：

```lean
import SandronesLibrary.NumberTheory.Elementary.Primes
import SandronesLibrary.NumberTheory.Elementary.LinearDiophantine
import SandronesLibrary.NumberTheory.Elementary.PythagoreanTriples
import SandronesLibrary.NumberTheory.Elementary.QuadraticResidues
import SandronesLibrary.NumberTheory.Elementary.QuadraticReciprocity
import SandronesLibrary.NumberTheory.Elementary.ContinuedFractions
import SandronesLibrary.NumberTheory.Elementary.Pell
```

## Registry

除 N1.1–N1.2 的六条基础记录外，以下 15 个条目也已登记对应 Lean 模块和叙述文件；`kind`、
标题、summary、premises、mathlib 和 provenance 与各 `.md` front matter 一致：

1. `number-theory.elementary.prime-tests` → `NumberTheory/Elementary/Primes.lean`
2. `number-theory.elementary.infinite-primes` → `NumberTheory/Elementary/Primes.lean`
3. `number-theory.elementary.linear-diophantine` → `NumberTheory/Elementary/LinearDiophantine.lean`
4. `number-theory.elementary.pythagorean-triples` → `NumberTheory/Elementary/PythagoreanTriples.lean`
5. `number-theory.elementary.quadratic-residues` → `NumberTheory/Elementary/QuadraticResidues.lean`
6. `number-theory.elementary.quadratic-reciprocity` → `NumberTheory/Elementary/QuadraticReciprocity.lean`
7. `number-theory.elementary.continued-fraction-convergent` → `NumberTheory/Elementary/ContinuedFractions.lean`
8. `number-theory.elementary.continued-fraction-recursion` → `NumberTheory/Elementary/ContinuedFractions.lean`
9. `number-theory.elementary.best-rational-approximation` → `NumberTheory/Elementary/ContinuedFractions.lean`
10. `number-theory.elementary.finite-best-approximation` → `NumberTheory/Elementary/ContinuedFractions.lean`
11. `number-theory.elementary.legendre-criterion` → `NumberTheory/Elementary/ContinuedFractions.lean`
12. `number-theory.elementary.pell-equation` → `NumberTheory/Elementary/Pell.lean`
13. `number-theory.elementary.pell-composition` → `NumberTheory/Elementary/Pell.lean`
14. `number-theory.elementary.pell-positive-existence` → `NumberTheory/Elementary/Pell.lean`
15. `number-theory.elementary.pell-fundamental-solution` → `NumberTheory/Elementary/Pell.lean`

Main 使用 `check_axioms.py --full` 逐条复验，并用 `--fix` 回写实际 `axioms` 与 `proof_sha`；
`dependedOnBy` 保留 front matter 的课程依赖链。

## ROADMAP

将 Phase 10 的 N1 标记为完成，并保留下列诚实边界：

- 当前 Mathlib 尚无“每个简单连分数收敛子都是本库定义下的最佳逼近”接口；本库只登记
  最佳逼近定义、有限候选最优元和 Legendre 的充分判据。
- 当前 Mathlib 的 Pell 文件尚未完成 `√d` 连分数桥和负 Pell 方程；本库只转正正 Pell
  方程、Brahmagupta 合成、正解与基本解存在。
- `PellSolution` 坐标接口尚未转正全体解由基本解幂生成的分类。

## RADAR

### 素数、Diophantine 与勾股数

- `Nat.prime_def_le_sqrt`
- `Nat.not_prime_iff_exists_dvd_lt`
- `Nat.minFac_prime`
- `Nat.minFac_dvd`
- `Nat.Prime.dvd_factorial`
- `Set.infinite_of_not_bddAbove`
- `Int.gcd_eq_gcd_ab`
- `Int.gcd_dvd_left`
- `Int.gcd_dvd_right`
- `PythagoreanTriple.coprime_classification'`
- `PythagoreanTriple.classification`

### 二次剩余与互反律

- `isSquare_iff_exists_sq`
- `legendreSym.eq_one_iff`
- `legendreSym.eq_neg_one_iff`
- `ZMod.euler_criterion`
- `ZMod.gauss_lemma`
- `neg_one_pow_eq_one_iff_even`
- `neg_one_pow_eq_neg_one_iff_odd`
- `jacobiSym.legendreSym.to_jacobiSym`
- `jacobiSym.mul_left`
- `jacobiSym.eq_one_or_neg_one`
- `jacobiSym.at_two`
- `χ₈`
- `legendreSym.quadratic_reciprocity`
- `legendreSym.sq_one`
- `prime_ne_zero`
- `neg_one_pow_div_two_of_one_mod_four`
- `neg_one_pow_div_two_of_three_mod_four`
- `legendreSym.eq_zero_iff`
- `jacobiSym.quadratic_reciprocity`

### 连分数与 Pell 方程

- `Real.convergent`
- `Real.convergent_zero`
- `Real.convergent_succ`
- `Finset.exists_min_image`
- `Real.exists_rat_eq_convergent`
- `Pell.Solution₁.exists_pos_of_not_isSquare`
- `Pell.Solution₁.prop`
- `Pell.IsFundamental`
- `Pell.IsFundamental.exists_of_not_isSquare`
- `Pell.Solution₁.mk`
- `Pell.Solution₁.x_mk`

## Playbook 教训候选

Lean 块注释中的连续文本 `0/1/-1` 含有字符序列 `/-`，会被解析为嵌套块注释的开始。
数学说明应改写为 `0、1、-1`，或在这些符号之间加入不会形成 `/-` 的分隔符。

## 主协调审计结果

- 四个学科分支均使用独立 worktree、分支和物理 `.lake`；共有文件只由 main 管理者修改。
- 所有大模块先在 `/tmp` 建完整 `sorry` 骨架，随后逐条清零；正式源无
  `sorry`、`admit`、`sorryAx` 或 `native_decide`。
- 21 个 N1 Entry id 在 Lean docstring 与 21 篇课程文档之间一一对应。
- 21 篇文档均实质包含动机、直觉、自然语言陈述、Lean 对照、thinking trace、
  自然语言与 Lean 映射、依赖和应用/陷阱。
- 所有 11 个 Lean 模块有统一许可头；学科提交未越过数论文件所有权边界。
- staging 上 11 模块联合导入通过；N1.3、N1.4、N1.5 的独立 targeted build 均通过。

## Main 最终统一验收

```bash
python3 scripts/gen_entries_index.py
python3 scripts/check_axioms.py --all --fix
python3 scripts/audit.py
lake build
```

2026-08-25 的维护复验确认：21 个 id 在 Registry、Lean Entry 映射和课程文档之间一一对应，
每个 id 只映射一个 Lean 文件；11 个模块联合构建通过。公理全量复验发现
`number-theory.elementary.pell-equation` 的 Registry 漏记 `propext`，已由 Main 回写。
RADAR 同步补齐 `Int.fract`、Gauss 奇偶桥和二次互反律模四辅助引理。三处宽泛
`Mathlib.Tactic` import 已收窄为实际需要的 tactic／代数模块。
