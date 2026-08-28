# F6.6 全纯函数演算接口调查与概念冻结表

- 调查基线：Main `cb64ce5`
- 权限：`research_open`
- 目标 Entry：`functional-analysis.functional-calculus.holomorphic`
- 教材：Bühler–Salamon, *Functional Analysis*, §5.2.4

## 教材页面核对

本调查直接查看 PDF 渲染页面，没有使用文本抽取：

- PDF 231／印刷 216：Definition 5.2.11。`U ⊆ ℂ` 必须开且包含 `σ(A)`；在
  `U \ σ(A)` 中选择绕谱的有限 cycle，以预解算子的 Dunford 积分定义 `f(A)`；
- PDF 232／印刷 217：Theorem 5.2.12 陈述 cycle 选择无关、和与积、与多项式求值一致、谱映射、
  复合以及分离谱集的投影；
- PDF 233--235／印刷 218--220：乘法使用两层 cycle 与预解恒等式，谱映射使用局部因子分解和倒数，
  复合又依赖已经证明的谱映射；
- PDF 236／印刷 221：指数、对数、逆与谱投影只是消费者，不应反过来充当函数演算定义。

教材的输入不是“仅在谱上的函数”，而是某个谱邻域上的全纯函数。邻域 `U` 是存在量词的一部分，
同一函数可在不同邻域表示；最终算子必须与 cycle 选择无关，也应只依赖谱附近的函数胚。

## Mathlib 现状

全库检索没有发现 Dunford 或一般 Banach 代数 holomorphic functional calculus 的成熟 carrier；没有
`holomorphicFunctionalCalculus`、Dunford integral 或对应谱映射／复合定理。现有能力分为三层：

1. 一般 Banach 代数谱：`spectrum ℂ a`、`resolventSet ℂ a`、`resolvent a z`，以及
   `spectrum.isOpen_resolventSet`；
2. 复分析与向量值积分：`DifferentiableOn ℂ f U`、Banach 值 Bochner／圆周积分、向量值 Cauchy
   公式；
3. C*-代数连续函数演算：`ContinuousFunctionalCalculus`、`cfcHom`、`cfc_map_spectrum`、
   `cfc_comp`。

第 3 层不能作为 F6.6 后端。它的函数定义在谱本身并只要求连续，主要用于满足指定谓词的 C*-代数
元素；F6.6 面向一般复 Banach 代数元素／Banach 空间有界算子，输入是在谱的开邻域上全纯的函数。
用 `cfc` 会错误地把一般 Banach 函数演算缩成正规 C*-元素的连续函数演算，并越过 F6.8 的冻结门。

Mathlib 的 `circleIntegral` 能积分 `ℂ → E` 的 Banach 值函数，但教材 Dunford cycle 是有限多个任意
光滑闭曲线并带绕数条件。当前没有一个现成公共结构同时记录 cycle、避开谱、对谱绕数为一、对
`ℂ \ U` 绕数为零，也没有现成定理直接给出这种 cycle 下 Dunford 积分的选择无关性。

## 概念冻结表

| 教材概念 | 建议 Mathlib-native 表达 | 当前边界 | 冻结建议 |
|---|---|---|---|
| 复 Banach 代数元素 | `a : A`，`[NormedRing A] [NormedAlgebra ℂ A] [CompleteSpace A]` | 谱 API 成熟 | 直接采用 |
| 算子实例 | `A = E →L[ℂ] E` | 已是完备复 Banach 代数 | 不另建算子 calculus |
| 谱邻域上的全纯函数 | `∃ U, IsOpen U ∧ spectrum ℂ a ⊆ U ∧ DifferentiableOn ℂ f U` | 可在 `/tmp` 通过类型检查 | 可先冻结谓词，不宣称已有 calculus |
| cycle | 有限族分片 `C¹` 闭路径，加避谱与 winding 条件 | 没有现成单一 carrier | foundation 缺口 |
| Dunford 积分 | cycle 上 `f z • resolvent a z` 的 Banach 值路径积分 | 单圆积分可表达；一般 cycle 与选择无关缺失 | 不可直接登记 verified Entry |
| 单位／恒等函数 | `1(a)=1`、`id(a)=a` | 应由积分和预解恒等式证明 | 正式 calculus 基础批 |
| 加法／乘法 | `eval (f+g)=...`、`eval (f*g)=...` | 乘法需要双 cycle 与 resolvent identity | 依赖 cycle foundation |
| 多项式一致性 | 与 `Polynomial.aeval a` 一致 | `aeval` 已成熟 | calculus 建成后的消费者 |
| 谱映射 | `spectrum ℂ (eval f) = f '' spectrum ℂ a` | 一般 Banach 全纯版本缺失；`cfc_map_spectrum` 不适用 | 必须真实证明 |
| 复合 | `eval (g ∘ f) a = eval g (eval f a)` | 需 `f(σ(a)) ⊆ V`，教材用谱映射保证良定义 | 谱映射之后独立批 |
| 谱投影 | 局部常值函数的 Dunford 值 | 教材消费者；F6.4/F6.5 明确另窗 | 继续冻结 |

## `/tmp` 签名验证

以下最小谓词在当前 checkout 中通过类型检查：

```lean
def HolomorphicOnNhdSpectrum (a : A) (f : ℂ → ℂ) : Prop :=
  ∃ U : Set ℂ, IsOpen U ∧ spectrum ℂ a ⊆ U ∧ DifferentiableOn ℂ f U
```

它只冻结函数的定义域量词，不定义 `f(a)`，也不解决不同邻域表示的等价关系。若未来需要把函数本身
打包，必须决定采用“函数加一个见证邻域”还是“谱附近 germ”；在 cycle 独立性证明之前不宜提前
建立大规模 quotient API。

## 与本库前置的关系

- F6.1--F6.3 已给复 Banach 代数、谱、预解集与谱非空紧致；它们满足代数侧前置；
- 复分析 C1 已给全纯定义与代数／复合规则；
- C2 已有圆周 Cauchy 公式和若干路径积分 foundation，但 ROADMAP 的一般同伦不变／任意 cycle
  路线仍未收口。教材所需的有限 cycle 绕数与选择无关性不能由单个圆周 Cauchy 公式替代；
- F6.4/F6.5 与 Dunford 定义无直接依赖；谱投影消费者必须留在后续窗口。

## 建议的开发拆窗

1. `foundation-neighborhood`：只冻结谱邻域全纯谓词、限制／扩大邻域规则和多项式正例；
2. `foundation-cycle`：与复分析 C2 共同冻结有限 cycle、winding 条件和 Banach 值路径积分；
3. `dunford-definition`：定义积分并证明 cycle／邻域选择无关、单位、恒等、加法；
4. `dunford-multiplicative`：用双 cycle 与预解恒等式证明乘法及多项式一致性；
5. `spectral-mapping`，随后才是 `composition`；
6. 谱投影继续单列，不包含在 F6.6 基础验收中。

在第 2 项没有稳定 carrier 前，不建议把 F6.6 直接提升为一个“完整函数演算”的正式源码窗口。
