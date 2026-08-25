# 抽象代数 A2 PID/UFD 交接

## 接收窗口

- 分支 `codex/abstract-algebra`；只 cherry-pick 本 handoff 所在提交。
- 源码 `SandronesLibrary/AbstractAlgebra/RingPIDUFD.lean`。
- Entry `abstract-algebra.ring.pid-ufd`；八段文档位于对应 ring 目录。

## 教材定义层六列表

| 概念 | 本库定义 | 展开／一手性质 | Mathlib 桥／后端 | 首个使用者 | Entry |
|---|---|---|---|---|---|
| 主理想 | `PrincipalIdealSet` | `zeroIdeal_principal` | 无公开桥 | PID 公理 | `abstract-algebra.ring.pid-ufd` |
| PID | `PrincipalIdealDomainAxioms` | 每个双边理想集合主生成 | 局部构造 `IsPrincipalIdealRing` | PID⇒UFD | 同上 |
| 原子分解 | `AtomicFactorizationAxiom` | 单位乘有限不可约因子积 | `WfDvdMonoid.exists_factors` 仅证明体 | UFD 公理 | 同上 |
| UFD | `UniqueFactorizationDomainAxioms` | 整环、原子性、不可约⇒素 | `UniqueFactorizationMonoid` 仅局部后端 | Euclidean⇒UFD | 同上 |

## 验证与边界

- 构建 `RingPIDUFD`：8709 jobs 通过。
- 聚合 `#check` 覆盖 8 个定义与主定理；Entry 唯一映射 8 个声明，公理探测全部可解析。
- 定义链覆盖主理想 → PID → 原子分解/UFD → 两个蕴含及合成。
- 公开主签名只使用本库定义；`Ideal`、`IsPrincipalIdealRing`、
  `UniqueFactorizationMonoid` 属第三类私有后端；第四类例外为空。
- 无占位、`Module`、`Submodule`、全局实例或不诚实反向命题。
- Main 建议加入顶层 import，Registry premises 为 divisibility 与 euclidean，ROADMAP 勾选 A2.7。
- 下一批不可依赖 UFD⇒PID；可以稳定依赖 Euclidean⇒PID⇒UFD 与有限不可约分解存在。
