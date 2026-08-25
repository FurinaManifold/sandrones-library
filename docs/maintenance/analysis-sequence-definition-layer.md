# 分析维护 RFC：数列收敛教材定义层

## 现状与问题

`SandronesLibrary/Analysis/Sequence.lean` 的 `analysis.sequence.definition` 目前只有定理
`tendsto_iff_epsilon_N`。公开说明把 `Tendsto u atTop (𝓝 l)` 直接称为“数列收敛的定义”，
课程文档也把 Mathlib 滤子表达放在自然语言映射的主位。本库因此缺少一个明确展示教材量词的
定义。极限唯一、有界、夹逼、子列、完备性和极限运算继续使用 `Tendsto` 本身不是问题。

问题仅在定义条目的教学表达没有分清“教材定义”和“Mathlib 正式接口”，不是要替换后者。

## 建议定义与语义桥

新增：

```lean
def SequenceConvergesTo (u : ℕ → ℝ) (l : ℝ) : Prop :=
  ∀ ε > 0, ∃ N : ℕ, ∀ n ≥ N, |u n - l| < ε
```

并证明：

```lean
SequenceConvergesTo u l ↔ Tendsto u atTop (𝓝 l)
```

等价桥可由 `Metric.tendsto_atTop` 与 `Real.dist_eq` 完整证明，因此新旧概念数学语义相同。
本轮保留原 `tendsto_iff_epsilon_N` 名称和签名，外部调用不受影响。

## 影响图

- 定义文件：`SandronesLibrary/Analysis/Sequence.lean`；同文件中极限唯一、有界、夹逼、单调收敛、
  子列、Bolzano–Weierstrass、Cauchy 准则、liminf/limsup 与极限运算直接使用 `Tendsto`。
- 同学科上层：`FuncLimit.lean`、`Series.lean`、`Completeness.lean`、`PowerSeries.lean`、
  `Series/CauchyProduct.lean`、`Series/RiemannRearrangement.lean`。
- 文档：`docs/entries/analysis/sequence/` 下定义、唯一性、有界性、夹逼、子列、单调收敛、
  Bolzano–Weierstrass、liminf/limsup 与极限运算条目。
- Registry/ROADMAP：Entry id `analysis.sequence.definition` 已登记为完成；其下游 premises 包含
  `analysis.sequence.unique`、`.bounded`、`.squeeze`、`.subsequence` 和各极限运算条目。
- 隐式机制：新定义是普通 `Prop`，不新增 notation、instance 或 simp 属性，不改变 typeclass 搜索。
- 导入闭包：`Sequence.lean` 继续只依赖现有 `Mathlib` 总导入；本轮不改变任何下游 import。

## 等级与维护步骤

本项定为 M1：新增教材定义及等价桥，既有 Mathlib 接口完整保留，且没有公开签名迁移计划。

1. 新增 `SequenceConvergesTo`、教材展开定理和双向等价桥；旧 API 全部保留。
2. 在课程文档中明确教材定义与 Mathlib 接口各自角色。
3. 由 Main 同步 Registry、RADAR、ROADMAP 对“定义已讲清”的状态描述。
4. 后续定理可以按表达清晰度选择 `SequenceConvergesTo` 或 `Tendsto`，不要求机械改写。

回滚点为 `a9d90a5`。本定义层提交可单独回滚，不影响任何既有声明。

## 本轮不处理

本轮不新增 Cauchy 列、函数极限、连续性或级数定义，不改既有主定理签名，不修改
`SandronesLibrary.lean`、Registry、RADAR、ROADMAP 或 Playbook，也不计划让全库脱离 `Tendsto`。
