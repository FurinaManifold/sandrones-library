# ST3 Googology、递归与增长层级：集成交接清单

- 分支：`codex/settheory-ordinal`
- 首批提交：`bcf79d5`
- 本轮扩展提交：`ff1179f`
- Conway/Goodstein/Hydra 提交：`92ae43e`
- 局部下降与无界停机关系提交：`b58ba5a`
- 无借位下降、Hydra 赋值与经典最大值提交：`c95de8b`
- 首个借位、复制下降与有限候选稳定提交：`d0cbf78`
- 平方借位、兄弟森林与可计算性定义门提交：`3ece959`
- 有限幂借位、父内兄弟与部分可计算性提交：`3d138d3`
- 遗传指数借位、任意深最右脊柱与条件式对角论证提交：`9f562d4`
- 具体配对编码与认证 Hydra 轨迹终止提交：见本批学科提交

本文件供集成 Codex 使用。当前批次包含：

- `SandronesLibrary/SetTheory/Googology.lean`
- `SandronesLibrary/SetTheory/GoogologyNotation.lean`
- `SandronesLibrary/SetTheory/GoogologyComputability.lean`
- `SandronesLibrary/SetTheory/GrowthHierarchy.lean`
- `SandronesLibrary/SetTheory/ConwayRecursion.lean`
- `SandronesLibrary/SetTheory/Goodstein.lean`
- `SandronesLibrary/SetTheory/Hydra.lean`
- `SandronesLibrary/SetTheory/GoodsteinDescent.lean`
- `SandronesLibrary/SetTheory/HydraMeasure.lean`
- `SandronesLibrary/SetTheory/BusyBeaver.lean`
- `SandronesLibrary/SetTheory/GoodsteinNoBorrow.lean`
- `SandronesLibrary/SetTheory/HydraOrdinalAssignment.lean`
- `SandronesLibrary/SetTheory/BusyBeaverExistence.lean`
- `SandronesLibrary/SetTheory/GoodsteinBorrow.lean`
- `SandronesLibrary/SetTheory/HydraOneLevelDescent.lean`
- `SandronesLibrary/SetTheory/BusyBeaverConvergence.lean`
- `SandronesLibrary/SetTheory/GoodsteinHigherBorrow.lean`
- `SandronesLibrary/SetTheory/HydraSiblingDescent.lean`
- `SandronesLibrary/SetTheory/ComputabilityFoundations.lean`
- `SandronesLibrary/SetTheory/GoodsteinFinitePowerBorrow.lean`
- `SandronesLibrary/SetTheory/HydraParentSiblingDescent.lean`
- `SandronesLibrary/SetTheory/PartialComputability.lean`
- `SandronesLibrary/SetTheory/GoodsteinHereditaryExponentBorrow.lean`
- `SandronesLibrary/SetTheory/HydraRightmostSpineDescent.lean`
- `SandronesLibrary/SetTheory/ComputabilityDiagonal.lean`
- `SandronesLibrary/SetTheory/ConcretePairingCode.lean`
- `SandronesLibrary/SetTheory/HydraCertifiedPlayTermination.lean`
- `docs/entries/settheory/googology/*.md`
- `docs/entries/settheory/computability/*.md`

## 顶层导入

```lean
import SandronesLibrary.SetTheory.Googology
import SandronesLibrary.SetTheory.GoogologyNotation
import SandronesLibrary.SetTheory.GoogologyComputability
import SandronesLibrary.SetTheory.GrowthHierarchy
import SandronesLibrary.SetTheory.ConwayRecursion
import SandronesLibrary.SetTheory.Goodstein
import SandronesLibrary.SetTheory.Hydra
import SandronesLibrary.SetTheory.GoodsteinDescent
import SandronesLibrary.SetTheory.HydraMeasure
import SandronesLibrary.SetTheory.BusyBeaver
import SandronesLibrary.SetTheory.GoodsteinNoBorrow
import SandronesLibrary.SetTheory.HydraOrdinalAssignment
import SandronesLibrary.SetTheory.BusyBeaverExistence
import SandronesLibrary.SetTheory.GoodsteinBorrow
import SandronesLibrary.SetTheory.HydraOneLevelDescent
import SandronesLibrary.SetTheory.BusyBeaverConvergence
import SandronesLibrary.SetTheory.GoodsteinHigherBorrow
import SandronesLibrary.SetTheory.HydraSiblingDescent
import SandronesLibrary.SetTheory.ComputabilityFoundations
import SandronesLibrary.SetTheory.GoodsteinFinitePowerBorrow
import SandronesLibrary.SetTheory.HydraParentSiblingDescent
import SandronesLibrary.SetTheory.PartialComputability
import SandronesLibrary.SetTheory.GoodsteinHereditaryExponentBorrow
import SandronesLibrary.SetTheory.HydraRightmostSpineDescent
import SandronesLibrary.SetTheory.ComputabilityDiagonal
import SandronesLibrary.SetTheory.ConcretePairingCode
import SandronesLibrary.SetTheory.HydraCertifiedPlayTermination
```

## Registry

首批登记：

1. `settheory.googology.primitive-recursion`（`definition`）
2. `settheory.googology.hyperoperation`（`definition`）
3. `settheory.googology.ackermann`（`definition`）
4. `settheory.googology.knuth-arrow`（`definition`）
5. `settheory.googology.graham-number`（`definition`）
6. `settheory.googology.hereditary-base`（`definition`）
7. `settheory.googology.goodstein-step`（`definition`）
8. `settheory.googology.conway-chain`（`definition`）
9. `settheory.googology.tree-function`（`definition`）
10. `settheory.googology.fundamental-sequence-system`（`definition`）
11. `settheory.googology.hardy-hierarchy`（`definition`）
12. `settheory.googology.fast-growing-hierarchy`（`definition`）
13. `settheory.googology.binary-machine`（`definition`）
14. `settheory.googology.machine-execution`（`definition`）
15. `settheory.googology.bounded-halting`（`definition`）
16. `settheory.googology.busy-beaver-candidate`（`definition`）
17. `settheory.googology.conway-recursion`（`definition`）
18. `settheory.googology.goodstein-certified-state`（`definition`）
19. `settheory.googology.goodstein-reencoding`（`definition`）
20. `settheory.googology.goodstein-sequence`（`definition`）
21. `settheory.googology.goodstein-ordinal-measure`（`definition`）
22. `settheory.googology.hydra-game-step`（`definition`）
23. `settheory.googology.goodstein-positive-digit-descent`（`theorem`）
24. `settheory.googology.hydra-root-cut-measure`（`theorem`）
25. `settheory.googology.unbounded-halting-relation`（`definition`）
26. `settheory.googology.busy-beaver-value-relation`（`definition`）
27. `settheory.googology.goodstein-positive-tail-no-borrow`（`theorem`）
28. `settheory.googology.hydra-ordinal-assignment`（`theorem`）
29. `settheory.googology.busy-beaver-existence`（`theorem`）
30. `settheory.googology.goodstein-base-power-one-borrow`（`theorem`）
31. `settheory.googology.hydra-one-level-descent`（`theorem`）
32. `settheory.googology.busy-beaver-convergence`（`theorem`）
33. `settheory.googology.goodstein-base-power-two-borrow`（`theorem`）
34. `settheory.googology.hydra-sibling-descent`（`theorem`）
35. `settheory.computability.nat-computable`（`definition`）
36. `settheory.computability.machine-decidable`（`definition`）
37. `settheory.googology.goodstein-finite-power-borrow`（`theorem`）
38. `settheory.googology.hydra-parent-sibling-descent`（`theorem`）
39. `settheory.computability.partial-nat-computable`（`definition`）
40. `settheory.computability.universal-interpreter-spec`（`definition`）
41. `settheory.googology.goodstein-hereditary-base-exponent-borrow`（`theorem`）
42. `settheory.googology.hydra-rightmost-spine-descent`（`theorem`）
43. `settheory.computability.pairing-code`（`definition`）
44. `settheory.computability.executable-universal-spec`（`definition`）
45. `settheory.computability.conditional-diagonal`（`theorem`）
46. `settheory.computability.concrete-pairing-code`（`definition`）
47. `settheory.googology.hydra-certified-play-termination`（`theorem`）

## 定义边界

`primitiveRecursion`、`hyperOperation` 与 `ackermann` 均为本库自行给出的可执行递归定义。
`Nat.hyperoperation`、`Nat.ack` 只作为 mathlib 对照 API，不得在集成时把公开定义改成薄包装。
`knuthArrow` 显式通过本库 `hyperOperation` 定义；`grahamNumber` 显式通过 64 个有限阶段定义。
遗传基语法把指数递归保留为同一表达式类型，Goodstein 单步只建立换底再减一；尚未登记完整
Goodstein 序列或终止性定理。

`ConwayChain` 建立任意有限正整数链语法，但公开总求值目前仅覆盖一项、两项短链；一般长链递归
尚未完成。TREE 子包建立有限标号根树、拓扑嵌入、坏序列和 `IsTREEValue` 最大值关系，但没有
证明最大值存在，也没有伪造一个无证明的总函数或 `TREE(3)` 比较。

`FundamentalSystem` 将零、后继、极限和基本列作为显式数据，`Legal` 只保证局部下降。
`hardyApprox` 与 `fastGrowingApprox` 是带燃料的可执行近似；尚未构造覆盖 `ε₀` 的正规记号、
证明基本列单调／共尾或得到无燃料全域层级。

Busy Beaver 子包自行定义二符号有限状态机、有限步执行和 `HaltsWithin`。公开
`busyBeaverCandidate n fuel` 只穷举 `n+1` 状态机器的有限燃料结果，不是经典无时间界 Busy
Beaver 函数。

`ConwayArrowTerm.eval` 已用“链长、末项、倒数第二项”的字典序实现一般有限链递归，并公开标准
基础、消去与递推方程。带证书 Goodstein 状态将数值、合法遗传表达式和求值等式绑定；重编码
单步、序列谓词与 `ω` 替换序数度量已经建立，但由于表达式尚非唯一正规形，还没有借位下降桥。
Hydra 子包固定一种有限有序树、零编号阶段且复制 `stage+1` 份砍头后父树的明确变体，只建立
可执行单步及例子。

本轮进一步把三条容易越界的路线切成诚实的局部接口。`PositiveDigitNormalForm` 只处理
`0 < k < base` 的单数字正规形：换底减一后显式重编码为 `digit (k-1)`，并证明有限序数度量
严格下降；它不处理幂、和、乘积或借位。`Hydra.ordinalMeasure` 把节点数嵌入有限序数，证明
任意成功的根旁叶头删除严格下降；深层复制步骤不受该度量控制。`EventuallyHalts` 与
`HasHaltingOnesScore` 用存在某个有限运行步数表达无时间界停机，`IsBusyBeaverValue` 则只是一
个“支配全部停机输出且被取得”的最大值关系；本批证明其唯一性以及与有限燃料候选的条件式桥，
没有断言该关系对每个状态数都存在见证。

下一小批把三条线各推进一步。`PositiveTailNoBorrowForm` 允许任意合法复合前缀加一个正数字末项，
证明只修改末项的显式重编码及序数下降；零末项借位仍未覆盖。Hydra 的 `hydraOrdinal` 与
`forestOrdinal` 只用本库 `ordinalAdd`、`ordinalPow` 建立有序树赋值，证明最右根头删除下降，
并把有限复制转成 `ordinalRepeat`，但尚未得到所有深层 `Step` 的下降不等式。Busy Beaver 存在性
模块直接复用上一批 `EventuallyHalts`、`HasHaltingOnesScore` 和 `IsBusyBeaverValue`，由有限机器
全集取最大值，证明每个状态数都有经典最大值，并在此后才定义 `noncomputable` 总函数；没有建立
第二套同义关系，也没有证明不可计算性。

本轮再推进三个可验证台阶。`BasePowerOneTailBorrowForm` 覆盖复合头部加 `B¹` 的首个真实借位形：
升底减一后把 `(base+1)¹-1` 明确重编码成新底数下的数字 `base`，并证明 `ω` 度量由无限末项降为
有限末项；任意指数与连锁借位仍未覆盖。`OneLevelReplicatedCut` 是路径 `[0,0]` 的真实阶段相关
Hydra 步骤，砍去独头后复制 `stage+1` 个空父节点；有限份较低 `ω` 幂仍低于下一幂，因此结构
赋值严格下降，但没有推广到任意树形。Busy Beaver 有限候选被证明关于燃料单调、始终受经典值
控制，并在某个仅存在而不可由本证明算出的阈值后永久稳定为经典值；没有提供停机判定算法。

第五小批把平方借位完整算清：对 `base ≥ 3` 的 `head+B²`，升底后的 `q²-1` 重编码为
`q·base+base`，序数末项从 `ω²` 降到 `ω·base+base`。Hydra 下降允许根保留任意有序左兄弟森林，
但复制父分支必须位于最右端；这一顺序条件正是避免右侧序数和吸收差异所必需。可计算性定义门
用 `NatProgram` 封装现有有限状态机，冻结一元输入、有限解释器、总函数计算与谓词判定规格，并
证明判定器等价于计算零一特征函数；当前没有停机不可判定或 Busy Beaver 不可计算性定理。

第六小批不再枚举固定幂，而用 `finitePowerBorrowExpansion base k` 递归展开
`(base+1)^k-1`；对 `0<k<base` 的数字指数统一证明合法重编码、求值正确与 `ω` 度量下降，指数
本身需要遗传展开的情形仍未覆盖。Hydra 进一步允许复制父节点内部保留任意左兄弟森林，同时根部
也保留任意左兄弟；双层最右条件保证路径替换和序数比较闭合。部分可计算性用单值输入输出关系
表达发散，证明总可计算函数和谓词判定嵌入；`UniversalNatInterpreter` 仅是编码、逐燃料求值和
精确模拟的抽象规格，本批没有构造其实例，更没有声称现有机器已经具有可计算自解释器。

本批只建立递归与增长的起点，尚未宣称形式化 Ackermann 非原始递归、Goodstein 终止、PA
不可证性或 Busy Beaver 不可计算性。这些结论需要后续编码与支配定理。

第七小批首次让底数真正进入 Goodstein 指数子树：参数族 `head+B^(B¹)` 升底后成为
`head+q^q`，再用上一批有限幂展开重编码 `q^q-1`，并由 `E_q<ω^q<ω^ω` 得到严格下降；它仍不
覆盖任意遗传指数。Hydra 的双层局部复制下降可沿任意有限最右祖先链提升，复制仍只发生在头的
祖父层，高层只替换最右分支；非最右路径及所有步骤终止尚未覆盖。可计算性线新增自然数配对、
可执行通用解释器规格与对角翻转编译闭包，在这些结构参数被显式给定时证明自应用停机谓词不可由
程序判定。当前没有构造这些结构的实例，核心矛盾也不使用 `runner_spec`，因此该结论不能改写为
现有机器模型的无条件停机不可判定，更没有推出 Busy Beaver 不可计算。

第八小批关闭配对规格的实例门：`natPairingCode` 以 Mathlib 的显式 `Nat.pair`/`Nat.unpair` 为
计算与证明后端，给出本库 `PairingCode` 的实际值及恢复、单射接口；这仍不等于已经用 `NatProgram`
实现配对，更没有构造通用 runner 或翻转编译器。Hydra 线把每一步均携带最右脊柱证书的轨迹定义为
`CertifiedInfinitePlay`，由每步序数下降和序数良基性证明该类型为空；结论只排除认证子关系上的
无限轨迹，不保证任意 Hydra 状态可继续、不提供步数界，也不是所有 `Hydra.Step` 的终止定理。

## RADAR

- `Nat.rec`
- `Nat.hyperoperation`
- `Nat.ack`
- `Fin`
- `Finset`
- `Finset.sup`

## 子 Agent 所有权与负责人审核

- `st3_notation`：`GoogologyNotation.lean`、Conway/TREE 两篇文档。负责人接受受限求值和关系式
  TREE 定义，要求 handoff 保留一般长链求值及 TREE 最大值存在性的边界。负责人复编译时发现
  子 Agent 漏报的 flexible-`simp` linter 警告，已退回为限定 rewrite 集并复验至零警告。
- `st3_growth`：`GrowthHierarchy.lean`、基本列/Hardy/快速增长三篇文档。负责人接受带燃料近似，
  不允许将其描述成 `ε₀` 上经典全域层级。
- `st3_busy_beaver`：`GoogologyComputability.lean`、机器/执行/限定停机/候选最大值四篇文档。
  负责人确认状态数采用 `n+1` 约定，并要求始终称为限定步数候选值。
- `st3_conway_full`：`ConwayRecursion.lean` 与一般递归文档。负责人复编译发现终止性证明一度仍有
  未解目标并退回；修复后确认标准规则 `X→1→Y=X`、一般递推与 `2→2→2=4` 回归测试。文档
  初交付又违反八段模板，已再次退回重构。
- `st3_goodstein`：`Goodstein.lean` 与四篇证书/重编码/序列/度量文档。负责人接受证书式接口，
  不允许将尚缺正规化与下降桥的序列称为已经终止。
- `st3_hydra`：`Hydra.lean` 与单步文档。负责人接受明确变体的单步定义，补齐了子 Agent 遗漏的
  库版权头；联合 Lake 构建又发现 `chop_single_head` 依赖宽松自动隐式，已补成显式
  `(stage : Nat)` 并同步文档。保留无终止证明的边界。
- `st3_goodstein_descent`：`GoodsteinDescent.lean` 与单数字下降文档。负责人核对其公开前提确实
  只覆盖带证书的非零数字，保留一般借位、一般下降和终止性均未完成的边界；并把 Entry 块修正为
  可被审计工具识别的 Lean docstring。无独立子提交，审核后收敛于学科提交 `b58ba5a`。
- `st3_hydra_measure`：`HydraMeasure.lean` 与根旁砍头度量文档。负责人核对成功的 `[i]` 路径只
  能删除根的叶孩子，节点数下降证明没有暗中覆盖复制分支；保留完整游戏终止性边界。无独立
  子提交，审核后收敛于学科提交 `b58ba5a`。
- `st3_busy_unbounded`：`BusyBeaver.lean` 与无界停机、最大值关系两篇文档。负责人接受关系式
  API，明确拒绝在最大值存在性尚未证明时引入总函数；并把两处 Entry 块修正为 Lean docstring。
  无独立子提交，审核后收敛于学科提交 `b58ba5a`。
- `st3_goodstein`（续批）：`GoodsteinNoBorrow.lean` 与一篇文档。负责人核对任意复合前缀只需
  合法性证书，严格下降确由正末项避免借位；不接受把该子类描述成一般 Goodstein 下降。
- `st3_hydra`（续批）：`HydraOrdinalAssignment.lean` 与一篇文档。负责人核对赋值公开公式调用
  本库序数加法/幂，且下降结论只针对最右根头；有限复制等式只是后续接口，不是全步下降。
- `st3_busy_beaver`（续批）：`BusyBeaverExistence.lean` 与一篇文档。初稿重复定义无界停机、输出
  和最大值关系，负责人退回；返工后改为直接复用 `BusyBeaver.lean` 的唯一公开定义链，并删除重复
  Entry。三个续批子包均无独立子提交，审核后收敛于学科提交 `c95de8b`。
- `st3_goodstein`（第三批）：`GoodsteinBorrow.lean` 与一篇文档。负责人核对新底数中的数字
  `base` 正是 `(base+1)^1-1`，并确认序数端只用已定义的本库加法、乘法和幂公开接口。
- `st3_hydra`（第三批）：`HydraOneLevelDescent.lean` 与一篇文档。负责人核对该关系确由
  `chop stage` 的 `[0,0]` 路径产生，而非只比较两棵无关树；结论仍限定于唯一父枝、唯一头。
- `st3_busy_beaver`（第三批）：`BusyBeaverConvergence.lean` 与一篇文档。负责人核对阈值来自
  经典冠军的某个停机时刻，定理只给存在性，没有把最终稳定误述为可判定的停止准则。三个第三批
  子包均无独立子提交，审核后收敛于学科提交 `d0cbf78`。
- `st3_goodstein`（第四批）：`GoodsteinHigherBorrow.lean` 与一篇文档。负责人核对
  `q²-1=q·base+base` 的自然数展开和 `ω·base+base<ω²` 的序数比较，并保留底数二指数编码边界。
- `st3_hydra`（第四批）：`HydraSiblingDescent.lean` 与一篇文档。负责人核对路径
  `[siblings.length,0]` 的执行结果和共同左森林前缀保持严格比较；右兄弟情形仍明确排除。
- `st3_busy_beaver`（第四批）：`ComputabilityFoundations.lean` 与两篇新 `settheory.computability`
  文档。负责人核对输入、输出和总停机量词均直接连接现有 `BinaryMachine`/`runSteps`，没有把
  Lean 的 `DecidablePred` 冒充机器判定性。三个第四批子包均无独立子提交，审核后收敛于学科提交
  `3ece959`。
- `st3_goodstein`（第五批）：`GoodsteinFinitePowerBorrow.lean` 与一篇文档。负责人核对递归式
  `q^(k+1)-1=q^k·base+(q^k-1)` 同时驱动自然数求值和 Cantor 型序数上界，不是新增固定算例。
- `st3_hydra`（第五批）：`HydraParentSiblingDescent.lean` 与一篇文档。负责人核对路径
  `[rootSiblings.length,parentSiblings.length]`、复制结果和双层最右顺序边界。
- `st3_busy_beaver`（第五批）：`PartialComputability.lean` 与两篇文档。负责人核对部分函数图像
  的单值性由确定执行证明；通用解释器结构无 inhabitant，也没有被文档描述成已经实现。三个第五批
  子包均无独立子提交，审核后收敛于学科提交 `3d138d3`。
- `st3_goodstein`（第六批）：`GoodsteinHereditaryExponentBorrow.lean` 与一篇文档。负责人首次
  独立构建时发现序数幂改写尚未暴露目标指数且有未使用 `simp` 参数，退回修复；复验确认参数族
  `head+B^(B¹)` 的新底数指数确为 `q`，下降链为 `E_q<ω^q<ω^ω`，且文档没有外推到任意遗传指数。
- `st3_hydra`（第六批）：`HydraRightmostSpineDescent.lean` 与一篇文档。负责人首次独立构建发现
  无进展 `simp`，并退回依赖存在见证定义形状的 `pathEq := rfl` 写法；返工后改为显式底部路径、
  局部 `chop` 计算和递归提升，复验确认只覆盖逐层最右的有限证书。
- `st3_busy_beaver`（第六批）：`ComputabilityDiagonal.lean` 与三篇文档。负责人核对配对与通用机均
  是本库公开规格，`DiagonalFlipClosure` 仍是待构造参数；又要求文档明确核心对角矛盾没有使用
  `runner_spec`，不得把条件定理过报成现有机器的无条件停机不可判定或 Busy Beaver 不可计算。
- `st3_busy_beaver`（第七批）：`ConcretePairingCode.lean` 与一篇文档。负责人核对 `Nat.pair` 与
  `Nat.unpair` 只作 Mathlib 计算／证明后端，公开对象确为本库 `PairingCode` 实例；接受“显式自然数
  函数”意义的可计算性，但保留尚未由本库 `NatProgram` 实现的边界。
- `st3_hydra`（第七批）：`HydraCertifiedPlayTermination.lean` 与一篇文档。负责人核对无限轨迹
  自身携带每一步证书，序数良基性只排除该受限关系的下降链；不接受将其描述成所有 Hydra 游戏
  终止或可计算步数界。
- `st3_goodstein`（第七批探索）：未形成正式文件。负责人接受其结构性阻塞报告：对 `k>1`，
  `B^(B^k)` 升底后的有限幂展开会出现不小于新底数的指数数字，现有合法性接口无法闭合；在建立
  任意自然数的遗传正规编码器前不伪造推广定理。

各子包文件所有权互不重叠；子 Agent 未修改 handoff、review 或共有文件。负责人亲自审查公开
签名、标题强度、定义链和诚实边界后再统一组装。

## 下游依赖门

可以稳定依赖：本库超运算与 Ackermann 计算方程、Knuth/Graham、遗传表达式与 Goodstein 单步、
一般有限 Conway 链求值、TREE 有限对象及最大值关系、带燃料增长层级、限定步数机器执行与候选
最大值、带证书 Goodstein 状态／重编码／序列／序数度量，以及当前明确版本的 Hydra 单步。
本轮新增的稳定接口仅包括：正单数字 Goodstein 状态的一步重编码与序数下降、根旁 Hydra 叶头
删除的有限序数下降、无时间界停机/输出分数关系，以及 Busy Beaver 最大值关系成立时对有限候选
的上界、命中和唯一性结论。
续批新增的稳定接口包括：正末项复合 Goodstein 表达式的无借位下降；Hydra 结构性序数赋值、最右
根头下降与复制森林的重复和公式；每个状态数的 Busy Beaver 最大值存在，以及随后定义的经典
`noncomputable` 总函数规格。
第三批新增的稳定接口包括：`head+B¹` 的显式一次借位下降；一层真实 Hydra 阶段复制步骤及有限份
`ω^level` 低于 `ω^(level+1)` 的接口；有限燃料 Busy Beaver 候选的单调性、经典上界与最终稳定。
第五批新增的稳定接口包括：`head+B²` 的显式平方借位下降；最右复制分支保留任意左兄弟森林时的
真实 Hydra 单步下降；一元输入机器程序、自然数函数可计算性、谓词机器判定性和特征函数规格。
第六批新增的稳定接口包括：有限数字指数的统一 Goodstein 借位展开；根部和复制父内同时保留左兄弟
森林时的真实 Hydra 下降；部分自然数函数图像、总函数/判定器桥，以及通用解释器的抽象模拟规格。
第七批新增的稳定接口包括：嵌套指数恰为 `B¹` 时的 Goodstein 借位下降；任意有限最右祖先链上的
真实 Hydra 步骤与序数下降；自然数配对、可执行通用解释器及翻转编译闭包的规格，以及在后两者作为
显式参数时的自应用对角矛盾。后者是条件接口，不提供任何结构实例。
第八批新增的稳定接口包括：具体 `PairingCode` 实例及其恢复、单射规格；每一步都属于认证最右脊柱
子关系时，不存在自然数长度的无限 Hydra 轨迹。不可据此依赖 `NatProgram` 配对实现、通用解释器
实例、一般 Hydra 终止或可计算步数上界。

不可依赖：Ackermann 非原始递归、Conway 递归的增长比较、TREE 最大值存在或 `TREE(3)` 大小、
`ε₀` 全域 Hardy/快速增长层级及支配比较、完整 Goodstein/Hydra 终止与 PA 不可证性，以及经典
Busy Beaver 不可计算性。因此当前仍不得将完整 ST3 标记为完成。

## 本批学科验证

- 三个新增模块分别构建通过：773、1049、1039 个任务，零警告。
- 集合论 27 个模块及依赖闭包联合构建通过，共 1082 个任务；未运行全库 `lake build`。
- `/tmp/sandrones-settheory-aggregate.lean` 同时导入本批及既有集合论模块，并 `#check` 五个新增
  Entry 的关键公开 API：通过。
- 五篇新增文档的精确八段模板、Lean Entry id 与文档 id 均为 5/5；禁用占位符与占位文字零命中；
  `git diff --check` 通过。

本批公开教材定义是 `BaseExponentOneNormalForm`、`HereditaryBaseExponentTailBorrowForm`、
`RightmostSpineReplicatedCut`、`PairingCode`、`ExecutableUniversalInterpreter`、`SelfHalts` 与
`DiagonalFlipClosure`。Mathlib 的 `Order.IsNormal.strictMono`、`Ordinal.natCast_lt_omega0` 仅作
证明后端；原生 `Ordinal` 运算只经本库既有 `ordinalAdd`、`ordinalMul`、`ordinalPow` 定义桥使用。

收到外部 review inbox 通知后，负责人按 `4616ec7..新尖端` 重新划定验收范围：该范围共新增五个
模块、七个 Entry 与七篇文档。加入具体配对和认证轨迹模块后，集合论 29 个模块及依赖闭包联合
构建通过，共 1084 个任务；聚合文件同时导入并 `#check` 七个 Entry 的关键 API。七篇文档的精确
八段、Entry 对照、禁用占位扫描与 `git diff --check` 均通过。Goodstein 的 `B^(B^k)` 探索因缺少
任意自然数的遗传正规编码器而停止，没有产生或登记正式文件。

## 合并后验收

```bash
python3 scripts/gen_entries_index.py
python3 scripts/check_axioms.py --all --fix
python3 scripts/audit.py
lake build
```
