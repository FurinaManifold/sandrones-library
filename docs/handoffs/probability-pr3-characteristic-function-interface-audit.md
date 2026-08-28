# Pr3 特征函数接口与分布唯一性审计

## 权限与结论

- 调查时 gate：`research_open`；Main 复验后已提升为 `development_open`。
- 本批只在 `/tmp/CharacteristicFunctionAudit.lean` 调查实值／向量值 carrier、基本性质、独立和乘积
公式与分布唯一性；没有新增正式模块、Entry 或 verified 声明。
- 临时文件完整证明实值随机变量特征函数在零点取一、连续性、独立和乘积公式及“同分布 iff 特征
函数相等”；无错误、warning 或 `sorry`。

建议首批把实值随机变量 `X : Ω → ℝ` 的特征函数正式承载为其分布测度的 Mathlib 特征函数

```lean
charFun (μ.map X) : ℝ → ℂ
```

而不另建 `CharacteristicFunction` 结构或重复定义积分。这个 carrier 自动与分布相等、卷积、独立
和与后续 Lévy／CLT 接口组装。

## 概念冻结建议

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | 拟定 Entry |
|---|---|---|---|---|---|---|
| 实值特征函数 | `φ_X(t)=E exp(i t X)` | `charFun (μ.map X) t` | `charFun_apply_real` 加 map-integral 语义 | 直接复用分布测度 carrier | 零点与连续性 | `probability.characteristic-function` |
| 零点归一化 | 概率测度总质量为一 | `charFun ... 0 = 1` | `charFun_zero` + map univ | 无矩条件 | 基本性质 | 同上 |
| 连续性 | `t ↦ φ_X(t)` 连续 | `continuous_charFun` | 有限测度即可 | 无矩条件；不要误加 Lp | 极限定理前置 | 同上 |
| 独立和公式 | 独立时 `φ_{X+Y}=φ_X φ_Y` | `IndepFun.charFun_map_fun_add_eq_mul` | 函数乘法逐点 | 直接消费 `IndepFun` | 有限独立和 | 同上 |
| 分布决定特征函数 | 同分布 iff 特征函数相同 | `IdentDistrib` 与 `Measure.ext_of_charFun` | map measure equality | 实值空间满足唯一性所需拓扑条件 | 分布唯一性 | 同上 |
| 向量值特征函数 | `E exp(i⟨X,t⟩)` | inner-product `charFun` | `charFun_apply` | 首批只披露，不进实值签名 | 后续多元 CLT | 同上／后续 |
| Banach 值特征泛函 | 对连续线性泛函 `L` 取 `E exp(iLX)` | `charFunDual` | `charFunDual_apply` | 需要 StrongDual，不进入首批 | Banach 推广 | 后续 |

## 实值 carrier 与积分语义

Mathlib 的 `charFun μ t` 对内积空间测度定义为

```lean
∫ x, Complex.exp (⟪x,t⟫ * I) ∂μ
```

在 `ℝ` 上，`charFun_apply_real` 化为 `∫ x, exp (t*x*I) ∂μ`。对随机变量，使用推前测度
`μ.map X`；在 `AEMeasurable X μ` 下，推前积分就是 `E exp(i t X)`。正式 Entry 应说明这一步，但不
需要复制定义。

建议基本展开签名直接以 `charFun (μ.map X)` 为主；若提供具名“随机变量积分展开”，必须显式保留
`AEMeasurable X μ`，不能依赖 `Measure.map` 对不可测函数的退化行为。

## 已验证的建议签名

零点与连续性：

```lean
theorem realCharFun_zero
    [IsProbabilityMeasure μ] (hX : AEMeasurable X μ) :
    charFun (μ.map X) 0 = 1

theorem realCharFun_continuous
    [IsProbabilityMeasure μ] (_hX : AEMeasurable X μ) :
    Continuous (charFun (μ.map X))
```

连续性本身只依赖推前测度有限，故证明不消费 `hX`；课程签名仍建议保留它，以保证该推前确实是
随机变量分布而不是不可测 map 的退化值。

独立和：

```lean
theorem realCharFun_independent_add
    (hX : AEMeasurable X μ) (hY : AEMeasurable Y μ)
    (hXY : X ⟂ᵢ[μ] Y) :
    charFun (μ.map (fun ω ↦ X ω + Y ω)) =
      charFun (μ.map X) * charFun (μ.map Y)
```

这里右端是函数逐点乘法。Mathlib 先把独立和的分布识别为卷积，再用 `charFun_conv`；正式条目可
直接复用该完整链。

## 同分布与反向唯一性

在两个概率空间上的实值随机变量满足：

```lean
theorem identDistrib_iff_realCharFun_eq
    (hX : AEMeasurable X μ) (hY : AEMeasurable Y ν) :
    IdentDistrib X Y μ ν ↔ charFun (μ.map X) = charFun (ν.map Y)
```

正向只是 `IdentDistrib.map_eq` 下的函数同余。反向使用 `Measure.ext_of_charFun` 证明两个推前概率测度
相等，再与两边 a.e. 可测性组装 `IdentDistrib`。

`Measure.ext_of_charFun` 的一般向量版本要求值域是完备、第二可数的实内积空间，两个测度有限。实数
自动满足这些拓扑条件，推前概率测度自动有限。不能把这个唯一性定理未经条件披露推广到任意拓扑
向量空间。

## 基本性质范围

- `charFun_zero`：零点值等于测度总质量；概率分布时为一。
- `norm_charFun_le_one`：概率特征函数模不超过一。
- `charFun_neg`：`φ(-t)=conj(φ(t))`。
- `continuous_charFun`：有限测度特征函数连续，不要求任何矩存在。
- `charFun_map_mul`、`charFun_map_add_const`：缩放和平移公式可作为首批基本消费者。
- `IndepFun.charFun_map_fun_add_eq_mul`：独立和乘积公式；`iIndepFun` 还有有限和乘积版本。

正式开发建议选择上述实值基本性质、独立和公式与唯一性等价，不必一次公开所有向量 API。

## 向量值边界

Mathlib `charFun` 对实内积空间使用 `⟨x,t⟩`。一般 Banach 空间没有内积参数，应使用
`charFunDual μ L`，其中 `L : StrongDual ℝ E`。Hilbert 情形可由 Riesz 对偶在二者之间转换。

首批概率教材接口优先实值，不把 `InnerProductSpace`、`StrongDual`、`PiLp` 等类型类泄漏进基本
定理。多元实向量和 Banach 值版本在后续推广中分别冻结。

## 与 CLT 的边界

Mathlib 已有特征函数的矩导数／Taylor 展开以及 Lévy 连续性定理，这些是 CLT 的后续工具。本批只
建立定义、基本性质、独立和与分布唯一性；不调用 `CentralLimitTheorem`，不把高阶矩 Taylor 公式或
特征函数逐点极限写成 CLT 已完成。

## 后续门建议

Main 已接受实值 `charFun (μ.map X)` carrier 与唯一性边界，并将
`probability.characteristic-function` 转为 `development_open`。正式文件建议为
`SandronesLibrary/Probability/CharacteristicFunction.lean`。CLT 继续冻结，待本条目验收后再单独
调查 Lévy 连续性与归一化和接口。
