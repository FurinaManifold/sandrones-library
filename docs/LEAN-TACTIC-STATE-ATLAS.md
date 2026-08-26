# Sandrone's Library Tactic 前后状态图谱

本文是 [`LEAN-TACTIC-REVIEW-GUIDE.md`](LEAN-TACTIC-REVIEW-GUIDE.md) 的实例册。它不再只解释
tactic 的一般含义，而是给出本库正式源码中的真实用法，以及该行执行前后的 Lean proof state。

## 读图约定

- `Γ` 表示仍在上下文中、但与当前行无关的类型参数和实例；它们没有被从真实证明中删除，只是省略显示。
- `⊢` 后是当前目标；`目标 1/2` 表示 tactic 产生了多个分支。
- “执行后：无目标”表示当前目标被关闭，不表示整个 theorem 一定已经结束；外层可能还有别的分支。
- 状态按源码 theorem 签名和相邻证明行复原；链接指向产生该状态的真实行。若同一 tactic 在不同形状下
  行为不同，会选最能显示其作用的库内用例。
- 本页所谓“每一个 tactic”，指主指南实际介绍的 tactic 和证明组合子；当前库没有用例的名称单列在
  “覆盖缺口”，绝不拿虚构示例冒充库内状态。

## 0. 进入证明状态的语法（它们本身不是 tactic）

主指南同时介绍了 `:=`、`by`、`=>`/`↦`。严格说它们不是改变已有 proof state 的 tactic，但人类读者
会在 tactic 周围不断遇到，因此也记录实际作用。

出处：[MatrixSVD.lean](../SandronesLibrary/LinearAlgebra/MatrixSVD.lean#L37)。

```text
定理头：theorem operatorNorm_nonneg (T : E →ₗ[𝕜] F) : 0 ≤ operatorNorm T := by
`:=` 前：Lean 已知待构造项的期望类型是 0 ≤ operatorNorm T
`by` 后首次显示：T : E →ₗ[𝕜] F
                  ⊢ 0 ≤ operatorNorm T
```

`:=` 把右侧证明赋给定理；`by` 让右侧以 tactic 模式构造。它们没有先后两个数学目标，而是创建首次
可交互的目标。匿名函数箭头的库内实例见
[RiemannCriterion.lean](../SandronesLibrary/RealAnalysis/RiemannCriterion.lean#L634)：

```text
表达式：let p : ℕ → Prop := fun i => Set.Icc ... ⊆ U
`fun i =>` / `fun i ↦` 前期望类型：ℕ → Prop
箭头后局部状态：i : ℕ ⊢ Prop（需给出关于 i 的命题表达式）
完成后得到函数：p : ℕ → Prop
```

箭头引入函数参数，与证明蕴含时的 `intro` 对应，但这里是在 term 中构造函数，并未启动 tactic。

## A. 证明结构与目标分解

### `intro`

出处：[MatrixSVD.lean](../SandronesLibrary/LinearAlgebra/MatrixSVD.lean#L49)。

```text
执行前：T : E →ₗ[𝕜] F
        ⊢ operatorNorm T = 0 → T = 0
执行 intro h 后：h : operatorNorm T = 0
                  ⊢ T = 0
```

它把蕴含式左边变成可使用的假设。若目标是 `∀ x, P x`，同一动作会固定任意 `x`，留下 `P x`。

### `rintro`

出处：[Primes.lean](../SandronesLibrary/NumberTheory/Elementary/Primes.lean#L109)。

```text
执行前：⊢ ¬ BddAbove {p : ℕ | p.Prime}
执行 rintro ⟨n, hn⟩ 后：n : ℕ
                         hn : ∀ ⦃a⦄, a.Prime → a ≤ n
                         ⊢ False
```

`rintro` 同时执行 `intro` 和模式拆包：假设“素数集合有上界”，并立刻把上界证书拆成 `n, hn`。

### `exact`

出处：[MatrixSVD.lean](../SandronesLibrary/LinearAlgebra/MatrixSVD.lean#L38)。

```text
执行前：T : E →ₗ[𝕜] F
        ⊢ 0 ≤ operatorNorm T
可用项：ContinuousLinearMap.opNorm_nonneg T.toContinuousLinearMap
        : 0 ≤ operatorNorm T
执行后：无目标
```

`exact` 交付类型恰好匹配目标的证明项，不产生新的数学义务。

### `apply`

出处：[Primes.lean](../SandronesLibrary/NumberTheory/Elementary/Primes.lean#L108)。

```text
执行前：⊢ Set.Infinite {p : ℕ | p.Prime}
引理：Set.infinite_of_not_bddAbove : ¬ BddAbove s → s.Infinite
执行后：⊢ ¬ BddAbove {p : ℕ | p.Prime}
```

`apply` 从引理结论倒推其前提。这里把“集合无限”化成“集合没有上界”。

### `refine`

出处：[Divisibility.lean](../SandronesLibrary/NumberTheory/Elementary/Divisibility.lean#L24)。

```text
执行前：m n : ℕ, hn : 0 < n
        ⊢ ∃ q r, m = q * n + r ∧ r < n
执行 refine ⟨m / n, m % n, ?_, Nat.mod_lt m hn⟩ 后：
        ⊢ m = m / n * n + m % n
```

作者已经选定商、余数并证明余数界，只把除法算法等式留作 `?_` 子目标；这比让 Lean 猜 witness 更透明。

### `constructor`

出处：[MatrixSVD.lean](../SandronesLibrary/LinearAlgebra/MatrixSVD.lean#L48)。

```text
执行前：⊢ operatorNorm T = 0 ↔ T = 0
执行后：目标 1：⊢ operatorNorm T = 0 → T = 0
        目标 2：⊢ T = 0 → operatorNorm T = 0
```

`↔` 的构造器有两个字段，因此产生正向和反向两个证明目标。

### `right`

出处：[PartialComputability.lean](../SandronesLibrary/SetTheory/PartialComputability.lean#L93)。

```text
执行前：hP : ¬ P input, hzero : ProgramOutput program input 0
        ⊢ (P input ∧ ProgramOutput program input 1) ∨
          (¬ P input ∧ ProgramOutput program input 0)
执行后：⊢ ¬ P input ∧ ProgramOutput program input 0
```

它选择析取的右支；选择哪一支本身就是证明的数学判断。

### `left`

出处：[PartialComputability.lean](../SandronesLibrary/SetTheory/PartialComputability.lean#L90)。

```text
执行前：hP : P input, hone : ProgramOutput program input 1
        ⊢ (P input ∧ ProgramOutput program input 1) ∨
          (¬ P input ∧ ProgramOutput program input 0)
执行 left 后：⊢ P input ∧ ProgramOutput program input 1
```

它选择同一析取的左支。紧接着 `refine ⟨hP, ?_⟩` 会填入命题证据，只留下输出唯一性的目标。

### `rcases`

出处：[Real.lean](../SandronesLibrary/Analysis/Real.lean#L156)。

```text
执行前：hfg : f ≈ g, ε : ℚ, hε : 0 < ε
        hfg (ε / 2) (half_pos hε) : ∃ i, ∀ j ≥ i, |f j - g j| < ε / 2
执行 rcases ... with ⟨i, hi⟩ 后：
        i : ℕ
        hi : ∀ j ≥ i, |f j - g j| < ε / 2
        ⊢ ∃ k, ∀ j ≥ k, |f j - h j| < ε
```

它把存在证书拆成见证 `i` 和性质 `hi`，原目标不变。

### `obtain`

出处：[Primes.lean](../SandronesLibrary/NumberTheory/Elementary/Primes.lean#L100)。

```text
执行前：n : ℕ
        euclid_prime_above n : ∃ p, n < p ∧ p.Prime ∧ p ∣ n! + 1
        ⊢ ∃ p, n < p ∧ PassesTrialDivision p ∧ p ∣ n! + 1
执行后：p : ℕ, hnp : n < p, hp : p.Prime, hpdiv : p ∣ n! + 1
        ⊢ ∃ p, n < p ∧ PassesTrialDivision p ∧ p ∣ n! + 1
```

`obtain` 是“取得一个证明并立即 `rcases`”的紧凑写法。

### `cases`

出处：[PolynomialDefinition.lean](../SandronesLibrary/AbstractAlgebra/PolynomialDefinition.lean#L63)。

```text
执行前：p : PolynomialSequence R
        ⊢ p = q
执行 cases p 后：pc : ℕ → R, pf : {n | pc n ≠ 0}.Finite
                  ⊢ PolynomialSequence.mk pc pf = q
```

它按结构唯一的构造器拆开 `p`，暴露系数函数和有限支撑证明；对多构造器类型则会产生多个分支。

### `by_cases`

出处：[MatrixSVD.lean](../SandronesLibrary/LinearAlgebra/MatrixSVD.lean#L223)。

```text
执行前：i j : Fin n
        ⊢ ⟪u i, u j⟫_𝕜 = if i = j then 1 else 0
执行 by_cases hij : i = j 后：
        目标 1：hij : i = j  ⊢ ⟪u i, u j⟫_𝕜 = if i = j then 1 else 0
        目标 2：hij : i ≠ j  ⊢ ⟪u i, u j⟫_𝕜 = if i = j then 1 else 0
```

它对一个可判定命题分类，并把肯定／否定证据分别加入两个分支。

### `by_contra`

出处：[Primes.lean](../SandronesLibrary/NumberTheory/Elementary/Primes.lean#L90)。

```text
执行前：hp : p.Prime, hpdiv : p ∣ n! + 1
        ⊢ n < p
执行 by_contra h 后：h : ¬ n < p
                      ⊢ False
```

目标被否定后放进上下文；后续从 `p ≤ n` 推出 `p ∣ n!`，最终与 `p ∤ 1` 矛盾。

### `exfalso`

出处：[VanKampenSurjectivity.lean](../SandronesLibrary/Topology/VanKampenSurjectivity.lean#L202)。

```text
执行前：j : Fin D.steps, hj : j.succ = 0
        ⊢ ∀ t, p t ∈ binaryOpenCoverPiece U V (D.label j)
执行后：j : Fin D.steps, hj : j.succ = 0
        ⊢ False
```

它把当前任意命题改成 `False`。这里 `j.succ = 0` 在自然数值上不可能，下一行取 `Fin.val` 后由
`omega` 推出矛盾，因此无需构造那个不可能分支中的逐点成员证明。

### `induction`

出处：[Jordan.lean](../SandronesLibrary/LinearAlgebra/Jordan.lean#L257)。

```text
执行前：m : ℕ, b : Fin (m + 1) → V, hb : IsJordanChain T μ b
        ⊢ LinearIndependent K b
执行 induction m with 后：
        zero 分支：b : Fin 1 → V, hb : IsJordanChain T μ b
                    ⊢ LinearIndependent K b
        succ 分支：m : ℕ
                   ih : ∀ b : Fin (m + 1) → V,
                     IsJordanChain T μ b → LinearIndependent K b
                   b : Fin (m + 2) → V, hb : IsJordanChain T μ b
                   ⊢ LinearIndependent K b
```

它把自然数命题拆成基例和递推例；`ih` 是递推分支新增、而不是原上下文已有的事实。

### `rfl`

出处：[TensorExterior.lean](../SandronesLibrary/LinearAlgebra/TensorExterior.lean#L54)。

```text
执行前：φ : DualSpace K V, v : V
        ⊢ dualPairing K φ v = φ v
定义展开后两边都是：φ v
执行后：无目标
```

`rfl` 关闭定义上相等的等式；数学内容在 `dualPairing` 的定义中，而非一次额外推导。

### `subst`

出处：[MatrixSVD.lean](../SandronesLibrary/LinearAlgebra/MatrixSVD.lean#L54)。

```text
执行前：T : E →ₗ[𝕜] F, h : T = 0
        ⊢ operatorNorm T = 0
执行 subst T 后：⊢ operatorNorm 0 = 0
```

它用等式把 `T` 全部替成零映射，并移除 `T` 与 `h`；随后目标由 `rfl` 关闭。

### `use`

出处：[Real.lean](../SandronesLibrary/Analysis/Real.lean#L47)。

```text
执行前：x y : ℝ, hx : 0 < x
        n := (exists_nat_gt (y / x)).choose
        ⊢ ∃ n : ℕ, y < n * x
执行 use n 后：⊢ y < (n : ℝ) * x
```

`use` 为存在量词提供见证；它近似 `refine ⟨n, ?_⟩`。

### `convert`

出处：[Trigonometric.lean](../SandronesLibrary/Analysis/Trigonometric.lean#L252)。

```text
执行前：h : cos (2 * (x / 2)) = 2 * cos (x / 2)^2 - 1
        ⊢ |cos (x / 2)| = sqrt ((1 + cos x) / 2)
主项：congrArg sqrt h
执行 convert ... using 1 后：产生若干“参数表达式相等”目标，
        例如 ⊢ 2 * (x / 2) = x 与平方根内部两种代数写法相等
```

`convert` 接受结论形状近似但不完全相同的证明，把差异显式变成等式子目标；该处随后用 `<;> ring` 全部正规化。

## B. 改写、化简和中间结构

### `rw`

出处：[MatrixSVD.lean](../SandronesLibrary/LinearAlgebra/MatrixSVD.lean#L65)。

```text
执行前：hcomp : (S.comp T).toContinuousLinearMap =
                 S.toContinuousLinearMap.comp T.toContinuousLinearMap
        ⊢ ‖(S.comp T).toContinuousLinearMap‖ ≤ ‖S‖ * ‖T‖
执行 rw [hcomp] 后：
        ⊢ ‖S.toContinuousLinearMap.comp T.toContinuousLinearMap‖ ≤ ‖S‖ * ‖T‖
```

指定等式按正向只改写匹配项；新目标正好成为 Mathlib 复合算子范数引理的结论。

### `change`

出处：[MatrixSVD.lean](../SandronesLibrary/LinearAlgebra/MatrixSVD.lean#L62)。

```text
执行前：⊢ operatorNorm (S.comp T) ≤ operatorNorm S * operatorNorm T
执行后：⊢ ‖(S.comp T).toContinuousLinearMap‖ ≤
          ‖S.toContinuousLinearMap‖ * ‖T.toContinuousLinearMap‖
```

两种写法按 `operatorNorm` 定义相同；`change` 没调用数学定理，只把承载层形状显露出来。

### `unfold`

出处：[PrimeFactorization.lean](../SandronesLibrary/NumberTheory/Elementary/PrimeFactorization.lean#L29)。

```text
执行前：⊢ primeMultiplicity p n = Nat.factorization n p
执行 unfold primeMultiplicity 后：
        ⊢ Nat.findGreatest (fun k => p ^ k ∣ n) n = Nat.factorization n p
```

它只展开点名的教材定义，让后续证明直接面对实现表达式。

### `dsimp`

出处：[MatrixPolar.lean](../SandronesLibrary/LinearAlgebra/MatrixPolar.lean#L171)。

```text
执行前：f、p、rankIndexSubtypeEquiv 是局部定义
        ⊢ 由这些局部名字组成的函数值等式
执行 dsimp [f, p, rankIndexSubtypeEquiv] 后：
        ⊢ 同一等式，但局部定义、投影和 β-redex 已展开
```

它做定义性规约，不调用一般 `[simp]` 定理；所以适合只想去掉局部包装而不扩大重写面的场合。

### `simp`

出处：[PolynomialDefinition.lean](../SandronesLibrary/AbstractAlgebra/PolynomialDefinition.lean#L56)。

```text
执行前：⊢ n ∈ coefficientSupport p ↔ coefficient p n ≠ 0
执行 simp [coefficientSupport, coefficient] 后：无目标
```

展开两个本库定义后，集合成员条件正是“系数非零”；`simp` 完成定义、集合构造器和逻辑的归一化。

### `simpa`

出处：[Real.lean](../SandronesLibrary/Analysis/Real.lean#L148)。

```text
执行前：hε : 0 < ε
        ⊢ |f j - f j| < ε
已有：hε : 0 < ε
执行 simpa [sub_eq_add_neg] using hε 后：无目标
```

它同时简化 `hε` 的类型和目标；左边化为 `0`，于是二者匹配。与 `simp` 不同，这里明确指出证据来源是 `hε`。

### `simp_rw`

出处：[MatrixPolar.lean](../SandronesLibrary/LinearAlgebra/MatrixPolar.lean#L143)。

```text
执行前：⊢ polarPartialIsometry T b (∑ j, c j • basis j) = rhs
执行 simp_rw [map_smul] 后：
        ⊢ ∑ j, c j • polarPartialIsometry T b (basis j) = rhs
```

它在求和及其 binder 内反复用线性映射保持数乘的规则，覆盖范围比一次普通 `rw` 更深。

### `nth_rw`

出处：[MatrixPolar.lean](../SandronesLibrary/LinearAlgebra/MatrixPolar.lean#L141)。

```text
执行前：⊢ polarPartialIsometry T b x = rankSum
等式：← (rightSingularBasis T).sum_repr x : x = ∑ j, ...
执行 nth_rw 1 [...] 后：
        ⊢ polarPartialIsometry T b (∑ j, ...) = rankSum
```

它只替换第一个匹配的 `x`，避免把右侧其他潜在出现也一并改写。

### `have`

出处：[MatrixSVD.lean](../SandronesLibrary/LinearAlgebra/MatrixSVD.lean#L63)。

```text
执行前：⊢ ‖(S.comp T).toContinuousLinearMap‖ ≤ ‖S‖ * ‖T‖
执行 have hcomp : A = B := by ... 后：
        hcomp : A = B
        ⊢ ‖(S.comp T).toContinuousLinearMap‖ ≤ ‖S‖ * ‖T‖
```

主目标暂时不变；Lean 先要求证明局部等式，完成后把它加入上下文供下一行 `rw` 使用。

### `let`

出处：[Primes.lean](../SandronesLibrary/NumberTheory/Elementary/Primes.lean#L84)。

```text
执行前：n : ℕ
        ⊢ ∃ p, n < p ∧ p.Prime ∧ p ∣ n! + 1
执行 let p := (n! + 1).minFac 后：
        p : ℕ := (n! + 1).minFac
        ⊢ ∃ p, n < p ∧ p.Prime ∧ p ∣ n! + 1
```

它只给候选素因子命名，主目标不变；局部定义可按需自动展开。

### `set`

出处：[RiemannRearrangement.lean](../SandronesLibrary/Analysis/Series/RiemannRearrangement.lean#L930)。

```text
执行前：hexists : ∃ k, ell ≤ rudinNBlock ... (k + 1)
        ⊢ 后续关于最小 k 的覆盖目标
执行 set k := Nat.find hexists with hkdef 后：
        k : ℕ
        hkdef : k = Nat.find hexists
        ⊢ 原目标（其中可使用 k）
```

与 `let` 相比，`set ... with` 额外保留具名等式，后面可以 `rw [hkdef]` 回到 `Nat.find` 的最小性接口。

### `show`

出处：[Diagonalization.lean](../SandronesLibrary/LinearAlgebra/Diagonalization.lean#L44)。

```text
执行前：⊢ 矩阵坐标中关于 T (B j) 的等式
内嵌 show 的目标：⊢ T (B j) = μ j • B j
执行 simpa [hB] using hμ j 后：该内嵌目标关闭，
随后 rw 使用所得等式改写外层目标
```

`show` 在这里明确指定希望 Lean 从特征向量假设中得到的类型，解决基底记号与原函数记号的定义性差异。

### `calc`

出处：[Real.lean](../SandronesLibrary/Analysis/Real.lean#L169)。

```text
执行前：⊢ |f k - h k| < ε
进入 calc 后依次产生：
  1. ⊢ |f k - h k| = |(f k - g k) + (g k - h k)|
  2. ⊢ |(f k - g k) + (g k - h k)| ≤ |f k - g k| + |g k - h k|
  3. ⊢ |f k - g k| + |g k - h k| < ε
三行关闭后：无目标
```

`calc` 固定了等式／不等式链的中间量和方向，每一行右侧证明只负责相邻两项。

## C. 外延性与等式操作

### `ext`

出处：[PolynomialDefinition.lean](../SandronesLibrary/AbstractAlgebra/PolynomialDefinition.lean#L119)。

```text
执行前：p : PolynomialSequence R
        ⊢ coefficientSupport p = (toMathlibPolynomial p).support
执行 ext n 后：n : ℕ
                ⊢ n ∈ coefficientSupport p ↔
                  n ∈ (toMathlibPolynomial p).support
```

集合相等被外延原则化成任意元素的成员关系等价。`ext` 选择的是目标类型登记的 `[ext]` 引理。

### `funext`

出处：[PolynomialDefinition.lean](../SandronesLibrary/AbstractAlgebra/PolynomialDefinition.lean#L68)。

```text
执行前：h : ∀ n, pc n = qc n
        ⊢ pc = qc
执行项 funext h 后：得到 pc = qc，当前 `have` 子目标关闭
```

这里 `funext` 以 term 形式使用：把逐点相等函数 `h` 提升为函数本身相等。

### `congr`

出处：[MatrixCholesky.lean](../SandronesLibrary/LinearAlgebra/MatrixCholesky.lean#L120)。

```text
执行前：⊢ Matrix.diagonal (fun i => sqrt (d i)) *
          Matrix.diagonal (fun i => sqrt (d i)) = Matrix.diagonal d
前一步已把两边化成同一个外层 Matrix.diagonal
执行 congr 1 后：⊢ (fun i => sqrt (d i)^2) = fun i => d i
```

`congr 1` 保留共同外层构造，把矩阵相等缩减到对角函数相等；下一行 `funext i` 再变成逐点目标。

### `congrArg`

出处：[Matrix.lean](../SandronesLibrary/LinearAlgebra/Matrix.lean#L80)。

```text
执行前：hii : A i i = -A i i
希望得到：A i i + A i i = -A i i + A i i
执行 congrArg (fun z ↦ z + A i i) hii 后：
        得到上述等式，当前 calc 行关闭
```

它在已知等式两边应用同一个函数；此处函数是“右边加上 `A i i`”。

## D. 算术与自动化 tactic

### `ring`

出处：[Matrix.lean](../SandronesLibrary/LinearAlgebra/Matrix.lean#L110)。

```text
执行前：K 为交换域，i j 固定
        ⊢ 2⁻¹ * (A i j - A j i) =
          -(2⁻¹ * (A j i - A i j))
执行 ring 后：无目标
```

目标已经是纯交换环多项式恒等式；`ring` 只做正规化，不使用矩阵对称性等额外数学事实。

### `ring_nf`

出处：[Real.lean](../SandronesLibrary/Analysis/Real.lean#L170)。

```text
执行前：⊢ |f k - h k| = |(f k - g k) + (g k - h k)|
执行 ring_nf 后：无目标
```

绝对值内部两边经环正规化相等；`abs` 被当作共同外层函数。这里 `ring_nf` 恰好关闭目标，在别处也可能
只把目标或假设改成正规形后留下新目标。

### `omega`

出处：[Jordan.lean](../SandronesLibrary/LinearAlgebra/Jordan.lean#L329)。

```text
执行前：j : Fin (m + 1)，所以 j.val < m + 1
        ⊢ j.val + 1 ≤ m + 1
执行 omega 后：无目标
```

`omega` 读取 `Fin` 自带的自然数上界，完成离散线性算术；这里没有处理任何线性代数内容。

### `linarith`

出处：[Real.lean](../SandronesLibrary/Analysis/Real.lean#L172)。

```text
执行前：h1 : |f k - g k| < ε / 2
        h2 : |g k - h k| < ε / 2
        ⊢ |f k - g k| + |g k - h k| < ε
执行 linarith 后：无目标
```

绝对值整体被当作两个原子变量；真正的分析步骤（三角不等式和两个半 ε 估计）已经在前面完成，
`linarith` 只把两条线性界相加。

### `nlinarith`

出处：[Completeness.lean](../SandronesLibrary/Analysis/Completeness.lean#L94)。

```text
执行前：ha : a n ≤ x, hx : x ≤ b n
        hay : a n ≤ y, hy : y ≤ b n
        ⊢ x - y ≤ b n - a n
执行 nlinarith 后：无目标
```

它将上下界组合成差的界。这个目标事实上是线性的；使用 `nlinarith` 仍能完成，但审阅者应知道此处
没有调用完备性或极限定理，只有有序环算术。

### `norm_num`

出处：[Primes.lean](../SandronesLibrary/NumberTheory/Elementary/Primes.lean#L68)。

```text
执行前：⊢ primeTest 97 = true
执行 norm_num [primeTest] 后：无目标
```

展开布尔测试后，它计算封闭数值命题并产生内核可核验的素性证明；没有符号变量或一般素数定理留待证明。

### `field_simp`

出处：[Matrix.lean](../SandronesLibrary/LinearAlgebra/Matrix.lean#L117)。

```text
执行前：⊢ 2⁻¹ * (A i j + A j i) +
          2⁻¹ * (A i j - A j i) = A i j
执行 field_simp 后：⊢ (A i j + A j i) + (A i j - A j i) = 2 * A i j
```

它清除了分母 `2`；`CharZero K` 使 `2 ≠ 0` 可解。新目标仍需下一行 `ring` 做多项式整理。

### `positivity`

出处：[TaylorSeries.lean](../SandronesLibrary/Analysis/TaylorSeries.lean#L93)。

```text
执行前：n : ℕ
        ⊢ 0 < ((n + 1).factorial : ℝ)
执行 positivity 后：无目标
```

它沿“阶乘为正、自然数强制转换保持正性”的结构传播正性；不会替代 Taylor 余项估计本身。

### `tauto`

出处：[RiemannCriterion.lean](../SandronesLibrary/RealAnalysis/RiemannCriterion.lean#L649)。

```text
执行前：p i : Prop
        ⊢ (p i ∨ ¬ p i) 与过滤集合并后的成员命题等价
执行 tauto 后：无目标
```

此前 `ext i; simp [p]` 已把有限集等式降成纯命题逻辑；`tauto` 只完成排中律层面的重言式。

### `decide`

出处：[CanonicalGoodsteinState.lean](../SandronesLibrary/SetTheory/CanonicalGoodsteinState.lean#L95)。

```text
执行前：hpositive : 0 < expression.eval (base + 1)
        ⊢ 0 < 1
执行 (by decide) 后：无目标
```

这是传给 `Nat.sub_lt` 的封闭可判定旁条件。`decide` 只计算 `0 < 1`，Goodstein 的严格下降仍由
`hpositive`、单调性和兼容性定理承担。

## E. 组合子、占位符和构造语法

### `<;>`

出处：[Trigonometric.lean](../SandronesLibrary/Analysis/Trigonometric.lean#L252)。

```text
执行前：⊢ |cos (x / 2)| = sqrt ((1 + cos x) / 2)
convert congrArg sqrt h using 1 产生目标 1、目标 2、……：均为实数环等式
执行 <;> ring 后：对 convert 产生的每个目标分别运行 ring；全部关闭
```

重点是广播范围：右侧 `ring` 不是只处理当前第一个目标，而是处理左侧 tactic 产生的全部目标。

### `;`

出处：[MatrixSVD.lean](../SandronesLibrary/LinearAlgebra/MatrixSVD.lean#L214)。

```text
执行前：⊢ ⟪(σ i : 𝕜) • v i, (σ j : 𝕜) • v j⟫_𝕜 =
          ((σ j : 𝕜) ^ 2) * if i = j then 1 else 0
执行 rw [inner_smul_right, hsq, hvinner] 后：目标被改写为只差数值强制转换的等式
执行 ; norm_cast 后：对 rw 留下的当前目标运行 norm_cast；该 calc 行关闭
```

`;` 把右侧 tactic 接到左侧产生的目标上；这个实例只有一个剩余目标。若左侧产生多个目标，Lean 的
semicolon 序列也会把右侧应用到全部目标，因此在分支语义上应像 `<;>` 一样谨慎阅读。

### `_`（推断占位符）

出处：[MatrixSVD.lean](../SandronesLibrary/LinearAlgebra/MatrixSVD.lean#L67)。

```text
执行前：⊢ ‖S.toContinuousLinearMap.comp T.toContinuousLinearMap‖ ≤ ‖S‖ * ‖T‖
证明项：ContinuousLinearMap.opNorm_comp_le _ _
elaboration：第一个 `_` 推断为 S.toContinuousLinearMap，
             第二个 `_` 推断为 T.toContinuousLinearMap
执行后：无目标
```

这里期望结论唯一确定两个映射；`_` 没有生成可见后续目标，而是在 elaboration 时被推断。

### `?_`（显式目标洞）

出处：[Divisibility.lean](../SandronesLibrary/NumberTheory/Elementary/Divisibility.lean#L24)。

```text
执行前：⊢ ∃ q r, m = q * n + r ∧ r < n
refine 中前三个已填字段：q := m / n，r := m % n，最后一项 := Nat.mod_lt m hn
`?_` 对应字段成为：⊢ m = m / n * n + m % n
```

与 `_` 不同，它故意把义务暴露为后续 proof state；正式文件编译成功说明该洞已经由后续行填满。

### `⟨...⟩`

出处：[Primes.lean](../SandronesLibrary/NumberTheory/Elementary/Primes.lean#L94)。

```text
执行前：p : ℕ, hnp : n < p, hp : p.Prime, hpdiv : p ∣ n! + 1
        ⊢ ∃ p, n < p ∧ p.Prime ∧ p ∣ n! + 1
执行 exact ⟨p, hnp, hp, hpdiv⟩ 后：无目标
```

尖括号按存在量词和嵌套合取的构造器顺序一次填完 witness 与三个证明字段。

## F. 当前库中的真实覆盖缺口

下列名称在主指南中有语义说明，但截至本次盘点没有正式 `SandronesLibrary/**/*.lean` 用例，因此不可能
诚实提供“库内实际使用时”的前后 state。它们不是待证明的 Lean 洞，而是文档实例覆盖缺口。

| 名称 | 当前源码状态 | 一般会造成的状态变化 |
|---|---|---|
| `specialize` | 无用例 | 把 `h : ∀ x, P x` 就地改成 `h : P a` |
| `suffices` | 无用例 | 暂以中间命题 `P` 为新目标，并在续块中证明 `P → 原目标` |
| `apply_fun` | 无用例 | 对等式两边应用函数，必要时产生单射性旁目标 |
| `aesop` | 无用例；这也符合本库偏好显式证明结构的现状 | 规则搜索可能关闭目标或产生搜索所得子目标 |

此外，`native_decide` 被本库规程禁止用于正式 Entry，所以本页不会制造一个正式源码实例。审阅者看到
上述缺口时，应理解为“尚无库内证据可展示”，而不是把主指南中的一般语义误报成已经采用的证明风格。

## G. 审阅时怎样使用本图谱

1. 在源码中把光标放到某一行之前，先自己预测“执行前”状态。
2. 对照本图谱判断该 tactic 是关闭、改写还是分裂目标。
3. 若编辑器显示的真实 state 与图谱中的最小状态不同，先看被省略的 `Γ`，再检查 Mathlib 版本是否改变
   了展开形状；不要仅凭变量名称判断。
4. 自动化关闭目标时，追问它的输入是否已经包含核心数学引理。`linarith` 的一行成功不等于它证明了
   三角不等式；上面的实数完备化例子清楚显示三角不等式在前一行显式提供。
5. 新 tactic 首次进入正式库后，学科负责人应在提交说明中给出前后 state；Main 再把一个代表性实例
   纳入本页，避免文档重新落后于源码。
