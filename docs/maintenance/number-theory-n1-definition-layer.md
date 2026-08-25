# N1 初等数论教材定义层维护 RFC

## 范围与现状

N1 的 11 个 Lean 模块、21 个 Entry、Registry、RADAR 和 ROADMAP 已进入 `main`，课程覆盖继续
保持 ✅。本维护窗口只处理最新 Playbook “教材定义层硬门”下的公开接口挂靠，不扩张到 N1+ 的
周期连分数、Pell 全体解或负 Pell。

只读影响扫描确认以下对象已经有本库定义并被上层使用：

- `PassesTrialDivision` 与 `primeTest`：有限试除与可执行素性判定；
- `LinearDiophantineSolvable`：二元一次不定方程可解性；
- `IsPythagoreanTriple`、`IsPrimitivePythagoreanTriple`：勾股数；
- `IsQuadraticResidue`、`IsQuadraticNonresidue`、`gaussUpperHalfCount`：二次剩余；
- `continuedFractionConvergent`、两个最佳逼近谓词和 `IsLegendreApproximation`：连分数；
- `PellSolution`、`IsFundamentalPellSolution`：Pell 坐标解。

## 发现的问题

| 课程概念 | 当前公开接口 | 问题 | 直接 N1 使用者 | 等级 |
|---|---|---|---|---|
| 同余 | `Nat.ModEq` notation | `Congruence.lean` 没有本库谓词，CRT 与 Fermat–Euler 直接暴露 Mathlib 同余 | `Congruence`、`FermatEuler` | M2 |
| Euler φ | `Nat.totient` | 约化剩余系大小与 Euler 定理直接以 Mathlib 函数陈述 | `FermatEuler` | M2 |
| 素因子指数 | `Nat.factorization` | 算术基本定理没有本库指数函数入口 | `PrimeFactorization` | M2 |
| 教材素数 | `Nat.Prime` | 已有等价的 `PassesTrialDivision`，但 Euclid 无穷定理仍只返回 Mathlib 素数 | `Primes` | M2 |
| 整数平方／非平方 | `IsSquare` | Pell 两个存在定理的公开前提没有坐标式教材定义 | `Pell` | M2 |
| Legendre/Jacobi 值 | `legendreSym`、`jacobiSym` | 二次剩余条目已有本库性质谓词，但若干互反律仍直接以 Mathlib 数值函数陈述 | `QuadraticResidues`、`QuadraticReciprocity` | M2 |

`ZMod n` 在二次剩余定义中承担有限剩余环的数据载体；`Real.convergent` 和 `Pell.Solution₁` 已被
隔离在本库定义或私有证明后端，分别归为公开定义的底层承载和未泄漏后端。抽象代数模块对 `ZMod`
及 `Nat.Prime` 的使用不是 N1 API 的下游迁移，归对应学科自行维护。

## 建议定义与等价桥

阶段 A 新增透明教材入口，不删除旧接口：

- `Congruent n a b := n ∣ b - a` 的自然数版本需要处理截断减法，不能直接采用；为保持与
  `Nat.ModEq` 完全等价，采用整数差整除或余数相等定义，并证明 `congruent_iff_modEq`。
- `EulerTotient n` 以 `0 ≤ a < n` 且与 `n` 互素的有限集合基数定义，再桥接 `Nat.totient`；若
  直接透明别名，则只算数据载体，不能完成教材定义门。
- `primeMultiplicity n p` 以最大幂次／有限支撑指数定义，并桥接 `Nat.factorization`；需先确认
  `n = 0` 的语义边界。
- `IsElementaryPrime := PassesTrialDivision` 不另造重复谓词；新增 Euclid 与无限性上层定理，结论
  使用 `PassesTrialDivision`。
- `IsIntegerSquare d := ∃ z : ℤ, z ^ 2 = d`，证明与 `IsSquare d` 的双向桥，再提供 Pell 存在定理
  的教材签名。
- `legendreValue`、`jacobiValue` 若只是透明别名只承担数值承载；互反律的课程主结论优先改写为
  `IsQuadraticResidue` 版本，数值等式保留为具名桥和计算接口。

所有新旧概念都可证明数学等价，因此属于 M2，不创建新 Entry id。

## 影响图

- N1 内部直接迁移顺序：`Congruence` → `FermatEuler`；`Primes` 独立；`Pell` 独立；
  `QuadraticResidues` → `QuadraticReciprocity`；`PrimeFactorization` 独立。
- 跨学科搜索没有发现模块 import N1 后调用这些声明；`SandronesLibrary.lean` 只做聚合导入。
- 21 篇 Entry、`docs/handoffs/number-theory-n1.md`、Registry `mathlib/axioms/proof_sha` 与 RADAR
  “谁在用”均受影响；前三类共享状态由 Main 在维护分支验收后更新。
- 没有 N1 全局 instance 或 simp attribute 自动把上述 Mathlib 概念注入下游。

## 迁移波次与回滚点

1. A1：同余与 Euler φ 新定义、双向桥和新上层定理；旧声明不动。
2. A2：教材素数、整数平方和 Pell 新上层定理；旧声明不动。
3. A3：素因子指数及 Legendre/Jacobi 数值接口；先冻结零值和符号边界。
4. B：课程文档改以新接口为主，旧接口标为兼容／桥；每个模块独立提交。
5. C：只有仓库与外部兼容策略允许时才弃用旧接口；本轮不删除任何旧声明。

每个阶段均可通过撤销对应提交回滚；旧 API 一直保留，因此阶段 A/B 不破坏外部调用者。

## 本轮诚实边界

A1 已完成 Stage A：`Congruent` 是余数相等定义，`EulerTotient` 是对 `Finset.range n` 中互素元素
的真实有限计数；二者都有到 Mathlib 的精确桥，并分别被运算闭包、CRT、单位群计数和 Euler
定理的教材签名实际使用。旧 `Nat.ModEq`／`Nat.totient` 定理完整保留。

A2 也已完成 Stage A：Euclid 构造与无限性直接以 `PassesTrialDivision` 陈述；整数平方由
`IsIntegerSquare` 的坐标定义表达，并用于正 Pell 解与基本解存在性的教材签名。

A3 已完成 Stage A：`primeMultiplicity` 是有界最大幂次定义，零输入约定为零；对素数底数和
非零自然数精确桥接 `Nat.factorization`，并由唯一分解的教材签名真实使用。

Legendre/Jacobi 经冻结后不新增数值别名：整数值只承担计算编码，已有二次剩余／非剩余定义、
具名分类桥和剩余版互反律构成教材定义链。新增透明别名不会讲清更多数学，只会制造平行接口。
A1–A3 均不声称替代 Mathlib 的完整接口。
