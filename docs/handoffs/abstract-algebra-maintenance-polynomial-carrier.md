# 抽象代数多项式承载迁移交接

## 维护范围

- RFC：`docs/maintenance/abstract-algebra-polynomial-carrier.md`。
- 等级：M2，当前完成阶段 A 与 A3.2 的阶段 B。
- 正式承载：Mathlib `Polynomial R`。
- 兼容承载：`PolynomialSequence R`，完整保留。

## 概念清单

| 概念 | 教材语义 | 正式承载 | 展开／性质 | 兼容关系 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 多项式 | 有限支撑系数序列 | `Polynomial R` | `coeff`、`support`、`ext` | 与 `PolynomialSequence` 双向互逆 | 首一除法 | `abstract-algebra.poly.def` |
| 次数 | 最高非零项；零为 `⊥` | `Polynomial.degree` | `degree_modByMonic_lt` | `degree_eq_mathlib_degree` | 余式界 | `abstract-algebra.poly.division` |
| 首一 | 最高次系数为一 | `Polynomial.Monic` | `Monic.def` | 旧 `Monic` 有 iff 桥 | 首一除法 | 同上 |
| 首一商余 | `p=dq+r`、`deg r<deg d` | `divByMonic`、`modByMonic` | 恒等式、次数界、唯一性 | 旧商余定义经双向桥 | gcd 前置 | 同上 |
| 域上商余 | 非零除式的 Euclidean 除法 | `/`、`%` | 恒等式、度量下降 | 旧 `polynomialQuotient/Remainder` 保留 | A2 Euclidean 算法 | 同上 |

## 公开签名分类

- 正式公开承载：`Polynomial`、`Polynomial.Monic`、`divByMonic`、`modByMonic`、`/`、`%`；
  均与教材语义一致并在课程文档解释。
- 本库课程层：`EuclideanDomainAxioms`、`GreatestCommonDivisor`、`euclideanGCD`；来自 A2。
- 兼容桥侧：`PolynomialSequence` 及 `toMathlibPolynomial`/`fromMathlibPolynomial`。
- 私有后端：正式承载接口直接使用 Mathlib 的已验证除法定理，没有额外公开技术结构。
- 未发现 `Module`、`Submodule`、`Algebra` 等越级公开泄漏。

## Main review R1 处理

- 已同步包含 `8d5d823` Playbook 澄清的最新本地 Main。
- 已提交公开使用者、Mathlib 对应接口和迁移签名的影响 RFC。
- 已把课程文档改为 `Polynomial` 正式承载，并解释有限支撑系数语义。
- A3.2 增加正式承载接口；旧接口未删除或改名。
- A3.3/A3.4 冻结，未把临时草稿写入仓库。

## Main 集成事项

- 按新角色更新 Registry 中 `poly.def`、`poly.mathlib-compat` 与 `poly.division` 的说明和唯一文件归属。
- 更新 ROADMAP/RADAR，记录 `Polynomial` 是解释完毕的正式承载，而非私有后端。
- 顶层 import、生成索引、公理审计、audit 与全库 build 由 Main 执行。

## 退役边界

当前仓库除定义模块与除法兼容层外没有 `PolynomialSequence` 使用者，但外部 API 兼容性尚未判断。
因此不执行阶段 C；默认长期保留旧类型和薄兼容接口。A3.3 只有在 Main 接收本迁移方案后才能开工。
