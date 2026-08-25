# 分析教材定义层审计

本清单记录“源码已有定理，但教材核心概念尚未在本库讲清楚”的技术债。完成一项的标准不是
只给 Mathlib 名称加中文注释，而是：给出量词和对象都明确的教材定义，并说明它与 Mathlib
接口的准确关系。Mathlib 仍是正式定理接口和证明复用的主干，不以全库替换为目标。

## 修复原则

1. 极限、连续、导数、积分与级数等教材概念必须在首次出现处给出量词完整的本库定义。
2. `Tendsto`、`Continuous`、`HasDerivAt`、`HasSum` 等可以继续出现在公开定理签名中；定义条目
   需要另行展开其教材含义并给出桥。
3. 透明类型别名只有在明确承担“数据载体”角色时可以保留；数学性质仍须由本库谓词表达。
4. 修复顺序自底向上：数列极限与 Cauchy 性 → 函数极限与连续 → 级数 → 微分与多元分析。
5. 不以消除 Mathlib 名称、旧接口退役或使用计数归零作为验收标准。

## A1 数列、函数极限与连续性

- [x] 数列收敛：`SequenceConvergesTo` 给出实数列的 ε-N 定义，并以
  `sequenceConvergesTo_iff_tendsto` 桥接 `Tendsto u atTop (𝓝 l)`。
- [x] 数列收敛存在性：`SequenceConvergent` 定义为存在某个 `SequenceConvergesTo` 极限，桥接
  `∃ l, Tendsto u atTop (𝓝 l)`，并用于收敛列有界定理。
- [x] Cauchy 列：`SequenceIsCauchy` 给出双指标 ε-N 谓词并桥接 `CauchySeq`；完备性定理继续
  使用 Mathlib 接口。
- [x] 函数有限点极限：`FunctionConvergesToAt` 给出去心邻域 ε-δ 定义，并桥接
  `Tendsto f (𝓝[≠] a) (𝓝 L)`；现有极限定理继续使用 Mathlib 接口。
- [ ] 无穷远极限及无穷极限：分别建立量词定义，避免把不同趋向统一隐藏在 `Tendsto` 中。
- [x] 点连续、集上连续与集合上一致连续：`ContinuousAtTextbook`、`ContinuousOnTextbook`、
  `UniformContinuousOnTextbook` 给出教材量词，并分别桥接 `ContinuousAt`、`ContinuousOn` 和
  `UniformContinuousOn`；全域 `UniformContinuous` 的 ε-δ 展开沿用既有定理。

## A2 实数完备性与级数

- [ ] 单调有界原理、闭区间套和 Cauchy 完备性应在文档中明确引用 A1 的教材定义与桥；其公开
  命题继续返回 `Tendsto` 或接收 `CauchySeq` 是可接受的。
- [x] 自然顺序部分和、级数和与收敛：`SeriesHasSum`、`SeriesConvergent` 明确教材顺序；
  `HasSum` 总能推出前者，绝对可和时二者等价，不虚构无条件反向桥。
- [x] 绝对收敛：`SeriesAbsolutelyConvergent` 定义为绝对值级数按自然顺序收敛，并桥接
  `Summable (fun n => |f n|)`；条件收敛可由收敛且非绝对收敛组合表达。
- [x] 条件收敛：`SeriesConditionallyConvergent` 明确定义为 `SeriesConvergent` 且非
  `SeriesAbsolutelyConvergent`，并提供两个教材投影性质。
- [ ] 幂级数已具备 `HasSumAt`、`ConvergesAt`、`AbsolutelyConvergesAt` 等本库定义；待补充
  与一般级数定义层的一致桥。

## A3 一元微分与积分

- [x] 一元导数：`HasDerivativeAtTextbook` 给出去心差商极限定义并桥接 `HasDerivAt`；
  `DifferentiableAt` 和 `deriv` 继续作为正式派生接口。
- [ ] Riemann 一元积分已有本库分割、和与可积性定义；继续保持其为教材定义层，Mathlib
  积分只作为比较或后端。
- [ ] 微积分基本定理继续使用 Mathlib 连续/导数谓词；在相应定义条目完成后补充概念挂靠说明。

## A4 多元分析与几何

- [x] Fréchet 导数：`HasFrechetDerivativeAtTextbook` 给出线性主部的余项比值趋零定义，并桥接
  `HasFDerivAt`；连续线性映射继续作为全微分的数据载体。
- [x] `TotalDerivative`、`DifferentialForm`、`RiemannBox` 已逐项标明为透明数据载体；它们分别
  由 Fréchet 导数条件、形式场正则性条件、Riemann 可积性谓词补充性质，不能替代这些性质谓词。
- [x] 方向导数已有沿固定方向的一元去心差商定义，并桥接 `HasLineDerivAt`；同时仅证明
  Fréchet 可微蕴含方向可导，不误写一般不成立的反向命题。
- [x] `ParametrizedCurve`、`ParametrizedSurface` 已明确为参数域到欧氏空间的透明函数数据载体；
  连续、可微和正则性不由别名暗含，而由 `CurveRegular*`、`SurfaceRegular*` 等本库谓词表达。

## 当前已提交维护范围

当前分支已经补齐数列收敛、Cauchy 列、函数有限点极限、连续性、一元导数、自然顺序级数和
Fréchet 导数的教材定义及 Mathlib 对照。前三项属于 Main 初审窗口，后四项属于 Round 2 窗口；
审核返工只修正 Entry 归属、影响证据与接收清单，不改变这些数学定义。

现有主定理继续使用 `Tendsto`、`CauchySeq`、`Continuous*`、`HasDerivAt`、`HasSum`、`Summable`
和 `HasFDerivAt`。这些正式接口无需替换，使用计数也不是待清零指标。未勾选项目仍只是后续定义
说明候选，不属于当前 review 接收范围。
