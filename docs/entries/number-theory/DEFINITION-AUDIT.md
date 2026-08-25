# N1 初等数论定义挂靠审计

本表只审计课程核心概念是否有可展开的教材定义、到 Mathlib 的精确桥及至少一个真实使用者；
目标不是复制 Mathlib 的完整接口。迁移采用 M2 双轨兼容，旧签名暂不删除。

| 波次 | 概念 | 教材定义 | 精确桥 | 真实使用者 | 状态 |
|---|---|---|---|---|---|
| A1 | 同余 | `Congruent` | `congruent_iff_modEq` | 运算闭包、CRT | ✅ |
| A1 | Euler φ | `EulerTotient` | `eulerTotient_eq_natTotient` | 单位群计数、Euler 定理 | ✅ |
| A2 | 教材素数结论 | 复用 `PassesTrialDivision` | `prime_iff_passesTrialDivision` | Euclid 构造、无限性 | ✅ |
| A2 | 整数平方／非平方 | `IsIntegerSquare` | `isIntegerSquare_iff_isSquare` | 两个 Pell 存在定理 | ✅ |
| A3 | 素因子指数 | `primeMultiplicity`（拟） | 到 `Nat.factorization` | 算术基本定理 | 待冻结零值 |
| A3 | Legendre/Jacobi 值 | 数值承载待定 | 到 Mathlib 符号函数 | 二次互反律 | 待冻结符号边界 |

## A1 边界检查

- `Congruent` 展开为余数相等，包含模数为零的语义；并非 `Nat.ModEq` 的别名。
- `EulerTotient` 展开为 `Finset.range n` 上互素元素的基数；并非 `Nat.totient` 的别名。
- 桥之后复用 Mathlib 的已验证运算、CRT、单位群和幂定理，不重建其完整 API。
- 原有 Mathlib 签名仍可使用，因此本波次没有破坏性迁移。

## A2 边界检查

- 不新增与 `PassesTrialDivision` 重复的素数谓词；Euclid 教材结论直接使用已有试除定义。
- `IsIntegerSquare` 展开为整数见证及坐标平方等式，而非 `IsSquare` 的别名。
- `Nat.Prime` 与 `IsSquare` 只留在桥、兼容签名或证明后端；Pell 的二次环结构未泄漏到新主签名。
