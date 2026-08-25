# N1 教材定义层维护 handoff

- RFC：`docs/maintenance/number-theory-n1-definition-layer.md`
- 影响等级：M2（新旧语义可证明等价，采用双轨兼容）
- 当前阶段：A1、A2 Stage A 已实现；A3 待办
- 维护分支：`codex/number-theory-maintenance`

## 已确认

- 21 个 Entry 和 11 个 Lean 模块已经在 main；课程覆盖状态不回退。
- 已有本库定义覆盖试除、Diophantine、勾股数、二次剩余性质、连分数近似和 Pell 坐标解。
- 待迁移概念为同余、Euler φ、素因子指数、Euclid 定理结论中的素数、Pell 非平方前提及
  Legendre/Jacobi 数值互反接口。
- 没有发现跨学科模块调用 N1 公开声明；抽象代数自身对 `ZMod`、`Nat.Prime` 的使用不属于 N1
  下游。

## A1 已交付

- `Congruent n a b := a % n = b % n`，桥为 `congruent_iff_modEq`。
- `EulerTotient n` 是小于 `n` 且与 `n` 互素的自然数的有限计数，桥为
  `eulerTotient_eq_natTotient`。
- 真实使用者：`congruent_add_mul_pow`、`chinese_remainder_exists_congruent`、
  `reduced_residue_card_eulerTotient`、`euler_theorem_congruent`。
- 原 `modEq_*`、`chinese_remainder_exists`、`reduced_residue_card`、`euler_theorem` 及 Fermat
  定理均保留，作为兼容接口。

## 公开签名扫描

- `ZMod`：同余到剩余环相等、CRT 环同构及单位群计数的数据载体，属于已解释的底层承载。
- `Nat.ModEq`、`Nat.totient`：只保留在具名桥及旧兼容定理中；A1 新主定理使用本库定义。
- `Nat.Coprime`、`Nat.Prime`：基础算术性质；本批没有把它们新增为待讲解的对象，Fermat 兼容定理
  的素数入口将在 A2 的教材素数结论中处理。
- 未新增全局 instance、simp attribute 或未经批准的公开 Mathlib 例外。

## A2 已交付

- 复用 `PassesTrialDivision`，新增 `euclid_trialDivision_above` 与
  `infinitely_many_trialDivision_primes`；`Nat.Prime` 版本完整保留。
- `IsIntegerSquare d := ∃ z : ℤ, z ^ 2 = d`，桥为 `isIntegerSquare_iff_isSquare`。
- 两个 Pell 教材存在性签名使用 `¬IsIntegerSquare d`；原 `¬IsSquare d` 签名完整保留。
- `Pell.Solution₁` 仍只出现在证明体；没有扩张到负 Pell 或连分数分类。

## 验证记录

- 模块闭包：`lake build` 同时构建 `Congruence`、`FermatEuler`，1938 jobs 通过。
- 临时聚合：同时导入两模块并 `#check` 两个定义、两个桥和四个真实使用者，通过后已删除。
- Entry 映射：同余 5、CRT 3、totient 4、Fermat–Euler 4 个声明，均归入唯一源码文件。
- 四个 Entry 的 `scripts/audit.py` 与 `scripts/check_axioms.py` 均通过；公理集合与 Registry 一致。
- 正式源码占位扫描与 `git diff --check` 通过。
- A2 模块闭包：同时构建 `Primes`、`Pell`，1887 jobs 通过。
- A2 临时聚合：`#check` 试除定义与桥、两个 Euclid 使用者、整数平方定义与桥、两个 Pell
  使用者，通过后已删除。
- A2 Entry 映射：prime-tests 7、infinite-primes 4、pell-positive-existence 5、
  pell-fundamental-solution 2；四个 Entry 的结构与公理审计均通过。

## 下一门

进入 A3 前先冻结 `primeMultiplicity` 在 `n = 0` 时的语义，以及 Legendre/Jacobi 数值接口的
值域和符号边界；仍采用双轨兼容，不删除旧 API。
