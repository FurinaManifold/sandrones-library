# 抽象代数 Galois Mathlib 后端可见性裁决

## Main 结论

- 基线：`main@dac7c1a`；
- 影响等级：M0 文档边界校正，不启动公开接口迁移；
- 裁决：保留 `finiteGalois_mathlibBackend` 作为**有意公开的具名桥**；
- 状态：已闭环，不开放 internal-backend refactor，也不安排 deprecation 或 breaking change。

## 事实与分类

`finiteGalois_mathlibBackend` 从本库教材谓词 `FiniteFieldExtension e`、
`GaloisExtension e` 出发，返回 Mathlib 证明后端所需的
`Nonempty (FiniteDimensional K L)` 与 `Nonempty (IsGalois K L)`。它有三个真实的
证明体消费者：正规性模块两处、restriction 模块一处；这些消费者的课程级公开
结论均不泄漏后端类。

因此该 theorem 按 Playbook 的公开签名四类扫描归为“本库教材承载与 Mathlib 正式
后端之间的共享桥”，而不是课程概念、私有证明后端泄漏或重复载体。把它改为私有
会迫使三个消费者复制相同的实例构造；为隐藏名称另造 wrapper 结构也只会制造新的
平行承载。

`fieldAutomorphismOver_mathlibAlgEquiv_mulEquiv` 是另一个保留乘法结构且有真实群论
消费者的具名桥，不因本次审计而迁移。

## 文档修正与边界

对应 Entry 原先声称 `FiniteDimensional`、`IsGalois` 只出现于私有桥或证明体，与
公开签名不符；该说法由 Main 直接修正。此次没有数学或接口问题，不打回学科负责人。

本裁决不允许后续课程定理任意把 `Module` 层接口当作教材陈述。新增公开后端桥仍须
同时证明：本库教材输入明确、Mathlib 输出语义一致、存在跨文件真实消费者、文档披露
角色和边界，且课程级结论不靠该桥冒充教材定义链。
