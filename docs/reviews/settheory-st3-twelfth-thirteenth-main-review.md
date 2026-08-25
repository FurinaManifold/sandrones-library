# ST3 第十二、十三批 Main 复核

- 学科提交：`70d05dd`、`00c5893`、`7222e57`、`f36bc8e`、`5a6f90e`
- Main 集成映射：`17e3189`、`37ff420`、`eef747b`、`311e7b8`、`7078add`
- 当前结论：`accepted_main_docs`

## 结论

三项数学内容通过：`B^(B^k)` 借位给出了合法性、数值规格和严格序数下降；规范 Goodstein 状态
明确把一般下降隔离为 `CanonicalBaseChangeOmegaCompatible` 前提，没有越界宣称；固定机器代码停机
条目只在正确统一界下给出命题等价，没有冒充可执行通用停机判定器。

旧复核曾因 Entry 标记只放在文件末尾、Registry 映射缺失和同步要求判为 `needs_changes`。依照现行
Main ROLE，这些属于共享文档、映射与集成职责，不再退回学科负责人。Main 已把 Entry 标记前移到
首个公开声明，使同一条目的结构、定义与定理全部进入映射；同时将英文源码说明改为中文教材说明，
登记聚合导入、Registry、Mathlib Radar、长期路线图和 Examples 巡视点。

## 边界

- `canonicalGoodsteinStep_omega_lt_of_compatible` 仍是条件式定理；一般换底重编码保持
  `omegaValue` 尚未集成。
- `codeHaltsByFuel` 的有限观察只有在另给正确统一停机界时才判定最终停机。
- 本批不证明完整 Goodstein 终止、PA 独立性、停机不可判定或 Busy Beaver 不可计算性。
