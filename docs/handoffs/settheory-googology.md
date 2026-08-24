# ST3 Googology、递归与增长层级：集成交接清单

- 分支：`codex/settheory-ordinal`
- 首批提交：`bcf79d5`
- 本轮扩展提交：`ff1179f`
- Conway/Goodstein/Hydra 提交：`92ae43e`
- 局部下降与无界停机关系提交：`b58ba5a`
- 无借位下降、Hydra 赋值与经典最大值提交：`c95de8b`

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
- `docs/entries/settheory/googology/*.md`

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

本批只建立递归与增长的起点，尚未宣称形式化 Ackermann 非原始递归、Goodstein 终止、PA
不可证性或 Busy Beaver 不可计算性。这些结论需要后续编码与支配定理。

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

不可依赖：Ackermann 非原始递归、Conway 递归的增长比较、TREE 最大值存在或 `TREE(3)` 大小、
`ε₀` 全域 Hardy/快速增长层级及支配比较、完整 Goodstein/Hydra 终止与 PA 不可证性，以及经典
Busy Beaver 不可计算性。因此当前仍不得将完整 ST3 标记为完成。

## 合并后验收

```bash
python3 scripts/gen_entries_index.py
python3 scripts/check_axioms.py --all --fix
python3 scripts/audit.py
lake build
```
