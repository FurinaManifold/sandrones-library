/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Analysis.TaylorIntegralRemainder
import Mathlib.Analysis.SpecialFunctions.Stirling

/-!
# Wallis 乘积与 Stirling 公式

本文件把阶乘渐近理论整理成数学分析教材可直接调用的接口。逻辑上分为三层：

1. `wallis_product` 给出 Wallis 乘积趋于 `π/2`，它在经典证明中负责确定
   Stirling 常数；
2. `factorial_isEquivalent_stirling` 给出完整渐近公式
   `n! ~ √(2πn) (n/e)ⁿ`；
3. 后两个定理给出对每个自然数都有效的定量下界及其对数形式，而不只是
   “充分大的 `n`”上的渐近估计。

Mathlib 已经沿经典 Wallis 路线完成了底层证明。本模块不重复内部数列估计，而是
固定本库的教材命名、公式写法和前后知识点接口。
-/

namespace SandronesLibrary.Analysis.Stirling

open Filter Finset Asymptotics
open scoped Topology

/-- **Wallis 乘积公式**：前 `k` 个相邻偶数与奇数比值对的乘积趋于 `π/2`。

每个因子写成
`(2i+2)/(2i+1) · (2i+2)/(2i+3)`；这正是从 `i=0` 开始的
`(2·4·…·2k)² / ((1·3·…·(2k-1))(3·5·…·(2k+1)))`。

> **Entry**: analysis.asymptotic.stirling
-/
theorem wallis_product :
    Tendsto
      (fun k : ℕ => ∏ i ∈ range k,
        ((2 : ℝ) * i + 2) / (2 * i + 1) * ((2 * i + 2) / (2 * i + 3)))
      atTop (𝓝 (Real.pi / 2)) := by
  exact Real.tendsto_prod_pi_div_two

/-- **Stirling 公式**：阶乘与 `√(2πn)(n/e)ⁿ` 渐近等价。

这里的 `~[atTop]` 表示两侧之比趋于 `1`。因此该陈述既确定主增长阶，也确定
常数因子 `√(2π)`，比单纯的对数等价更强。
-/
theorem factorial_isEquivalent_stirling :
    (fun n : ℕ => (n.factorial : ℝ)) ~[atTop]
      (fun n => Real.sqrt (2 * n * Real.pi) * (n / Real.exp 1) ^ n) := by
  exact _root_.Stirling.factorial_isEquivalent_stirling

/-- Stirling 主项还是阶乘的全局下界；该不等式对所有 `n : ℕ` 成立，包括 `n=0`。 -/
theorem stirling_lower_bound (n : ℕ) :
    Real.sqrt (2 * Real.pi * n) * (n / Real.exp 1) ^ n ≤ n.factorial := by
  exact _root_.Stirling.le_factorial_stirling n

/-- Stirling 下界的对数形式。`n ≠ 0` 排除了 `log 0` 并允许展开各个对数项：

`n log n - n + (log n)/2 + (log(2π))/2 ≤ log(n!)`。
-/
theorem log_factorial_stirling_lower {n : ℕ} (hn : n ≠ 0) :
    n * Real.log n - n + Real.log n / 2 + Real.log (2 * Real.pi) / 2 ≤
      Real.log n.factorial := by
  exact _root_.Stirling.le_log_factorial_stirling hn

end SandronesLibrary.Analysis.Stirling
