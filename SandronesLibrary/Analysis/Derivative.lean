/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

open Filter Topology
open scoped Filter Topology

/-!
# Analysis / Derivative —— 导数基础条目（第六章）

本文件当前条目（引理清单，§0 铁律4：一次一条，逐条编译）：

* **analysis.derivative.definition**（导数定义）。
* **analysis.derivative.unique**（导数唯一）。
* **analysis.derivative.const**（常数/恒等函数的导数）。
* **analysis.derivative.add**（和/差的导数）。
* **analysis.derivative.mul**（积的导数，Leibniz）。
* **analysis.derivative.div**（商的导数，分母非零）。
* **analysis.derivative.const-mul**（常数数乘的导数）。
* **analysis.derivative.chain-rule**（链式法则）。
* ~~**analysis.derivative.inverse-function**（反函数求导）~~：留待专门批次（mathlib 单变量需自构造反函数+链式，较繁）。
-/

namespace SandronesLibrary

namespace Analysis.Derivative

/-- 导数定义：`HasDerivAt f f' x` 说明 f 在 x 处可导且导数为 f'；
  `deriv f x` 是导数算子（数学分析教材的差商极限定义，mathlib 已内建）。
  导数唯一：同一函数同一点的两个导数必相等。 
> **Entry**: analysis.derivative.unique
-/
lemma deriv_unique_real {f : ℝ → ℝ} {x : ℝ} {a b : ℝ}
    (ha : HasDerivAt f a x) (hb : HasDerivAt f b x) : a = b :=
  HasDerivAt.unique ha hb

/-- 常数函数导数 = 0。 
> **Entry**: analysis.derivative.const
-/
lemma deriv_const_real (c : ℝ) (x : ℝ) : deriv (fun _ : ℝ => c) x = 0 :=
  deriv_const x c

/-- 恒等函数导数 = 1。 
> **Entry**: analysis.derivative.const
-/
lemma deriv_identity_real (x : ℝ) : deriv (id : ℝ → ℝ) x = 1 :=
  deriv_id x

/-- 线性函数 a·x + b 的导数 = a。 
> **Entry**: analysis.derivative.const
-/
lemma deriv_linear_real (a b : ℝ) : deriv (fun x : ℝ => a * x + b) = fun _ => a := by
  funext x
  simp [deriv_add_const]

/-- 和/差导数：deriv (f ± g) = deriv f ± deriv g。 
> **Entry**: analysis.derivative.add
-/
lemma deriv_add_sub_real {f g : ℝ → ℝ} {x : ℝ}
    (hf : DifferentiableAt ℝ f x) (hg : DifferentiableAt ℝ g x) :
    deriv (f + g) x = deriv f x + deriv g x :=
  deriv_add hf hg

/-- 积的导数（Leibniz）：(fg)' = f'g + fg'。 
> **Entry**: analysis.derivative.mul
-/
lemma deriv_mul_real {f g : ℝ → ℝ} {x : ℝ}
    (hf : DifferentiableAt ℝ f x) (hg : DifferentiableAt ℝ g x) :
    deriv (f * g) x = deriv f x * g x + f x * deriv g x :=
  deriv_mul hf hg

/-- 商导数：deriv (f/g) = (f'g - fg')/g²（g x ≠ 0）。 
> **Entry**: analysis.derivative.div
-/
lemma deriv_div_real {f g : ℝ → ℝ} {x : ℝ} (hgx : g x ≠ 0)
    (hf : DifferentiableAt ℝ f x) (hg : DifferentiableAt ℝ g x) :
    deriv (f / g) x = (deriv f x * g x - f x * deriv g x) / (g x ^ 2) :=
  deriv_div hf hg hgx

/-- 常数数乘导数：deriv (c·f) = c·deriv f。 
> **Entry**: analysis.derivative.const-mul
-/
lemma deriv_const_mul_real {f : ℝ → ℝ} {x : ℝ} (c : ℝ)
    (hf : DifferentiableAt ℝ f x) : deriv (fun y => c * f y) x = c * deriv f x :=
  deriv_const_mul c hf

/-- 链式法则：deriv (g ∘ f) x = deriv g (f x) · deriv f x。 
> **Entry**: analysis.derivative.chain-rule
-/
lemma deriv_chain_rule_real {f : ℝ → ℝ} {g : ℝ → ℝ} {x : ℝ}
    (hf : DifferentiableAt ℝ f x) (hg : DifferentiableAt ℝ g (f x)) :
    deriv (fun y => g (f y)) x = deriv g (f x) * deriv f x :=
  deriv_comp x hg hf

end Analysis.Derivative

end SandronesLibrary