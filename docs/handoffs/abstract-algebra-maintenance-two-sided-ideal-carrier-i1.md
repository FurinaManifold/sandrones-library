# 抽象代数双边理想载体维护 I1 交接

## 范围

本批只修改 `RingIsomorphismTheorems.lean`、既有 iso-theorems Entry 与本 handoff；不触碰
I2 第三同构输入迁移、I3 子环／第二同构迁移、CRT、Registry、ROADMAP 或 Examples。

## 正式核心与兼容层

- `TwoSidedIdealCarrier.toTwoSidedIdeal`、`ofTwoSidedIdeal` 给出双向桥；carrier 等式和两个
  round trip 均已证明。
- `ringHomKernel`、`idealComap`、`idealMapOfSurjective` 保留旧公开签名，但分别由
  `TwoSidedIdeal.ker`、`TwoSidedIdeal.comap`、`TwoSidedIdeal.map` 承担正式所有权。
- private `idealMapDirect_toTwoSidedIdeal` 显式证明满射直接像等于正式 `map` 的 span。
- `quotientIdealOrderIso` 是正式核心：两端均为正式双边理想，正、逆向真实调用
  `map`、`comap`。
- `QuotientIdealOrderEquivalence` 的双向 `OrderIso` 桥和 round trip 已建立；旧
  `quotientIdealCorrespondence` 只由正式核心经 carrier 保序同构转换而来。
- `TwoSidedIdealSet` 和集合级成员公式继续承担教材展开。

## 预审前验证

- 修改后源码从 Main 的 Lake 环境直接编译通过，零错误、零 `sorry`、零 linter warning。
- `/tmp/sandrones-library/TwoSidedIdealI1Audit.lean` 已通过 overlay 聚合测试，同时 `#check`
  全部新增桥、正式核心、旧结构桥及旧 `quotientIdealCorrespondence`。
- 唯一跨文件直接消费者 `RingCRT.lean` 已在同一修改后 olean overlay 上源码编译通过。
- 公理审计：carrier 两个 round trip、map 桥、旧结构两个 round trip 只依赖
  `[propext, Quot.sound]`；`quotientIdealOrderIso` 依赖
  `[propext, Classical.choice, Quot.sound]`，没有 `sorryAx`。
- `python3 scripts/audit.py abstract-algebra.ring.iso-theorems` 通过，`git diff --check` 通过。
- 学科负责人按最新 Playbook 不重复运行全库 build；Main 预审通过后再完成本批目标闭包并提交，
  全库 build 留给 Main 集成门。
