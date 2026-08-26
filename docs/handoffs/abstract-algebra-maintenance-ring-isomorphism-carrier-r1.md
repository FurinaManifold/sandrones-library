# 抽象代数环同构载体维护 R1 交接

## 批次与文件

- Main 基线：`55ffaa5`（R1 开放裁决已进入 Main）。
- 分支：`codex/abstract-algebra-ring-carrier`。
- RFC：`docs/maintenance/abstract-algebra-ring-isomorphism-carrier.md`，M2。
- 本批只修改：
  - `SandronesLibrary/AbstractAlgebra/RingIsomorphismTheorems.lean`；
  - `docs/entries/abstract-algebra/ring/iso-theorems.md`；
  - 本 handoff。
- `RingCRT.lean`、理想／子环／商环／局部化、Examples 与共享文件均未修改。

## 新旧接口与证明所有权

正式承载为 Mathlib `RingEquiv`（`R ≃+* S`）。本批新增公开无损桥：

- `RingIsomorphism.toRingEquiv`；
- `RingIsomorphism.ofRingEquiv`；
- `RingIsomorphism.toRingEquiv_ofRingEquiv`；
- `RingIsomorphism.ofRingEquiv_toRingEquiv`。

两个往返等式都成立，因此旧结构与正式承载没有数学语义差异。三个正式核心及公式为：

- `ringFirstEquiv`、`ringFirstEquiv_projection`；
- `ringSecondEquiv`、`ringSecondEquiv_projection`；
- `ringThirdEquiv`、`ringThirdEquiv_projection_projection`。

现有 `ringFirstIsomorphism`、`ringSecondIsomorphism`、`ringThirdIsomorphism` 和三个旧
代表元公式名称、参数与返回类型均保留，只由 `RingIsomorphism.ofRingEquiv` 或正式公式薄包装。
现有 `ringIsomorphismTrans`、`ringHomRangeIsomorphismOfSurjective`、
`quotientRingIsomorphismOfEqualIdeals` 也保留公开签名，但证明改由正式 `RingEquiv` 组合或
private 正式 helper 所有。没有第二条旧载体证明链。

## 概念清单

| 概念 | 教材语义 | Lean 正式承载 | 展开／刻画 | 复用／桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|---|
| 环同构 | 存在保持环运算的互逆双射 | `RingEquiv` | `Equiv` 加 `map_add`、`map_mul` | 与教材语义一致，直接复用 | `ringFirstEquiv` | `abstract-algebra.ring.iso-theorems` |
| 旧环同构载体 | 双向 `RingHomomorphism` 的互逆普通函数 | `RingIsomorphism`，仅兼容 | 六个字段 | `toRingEquiv`／`ofRingEquiv` 双向且往返为恒等 | 三个旧 `...Isomorphism` wrapper | 同上 |
| 第一同构 | `R/ker f ≅ im f` | `ringFirstEquiv` | `ringFirstEquiv_projection` | 显式商环与像仍由本库承载 | `ringSecondEquiv` | 同上 |
| 第二同构 | `A/(A∩I) ≅ (A+I)/I` | `ringSecondEquiv` | `ringSecondEquiv_projection` | 复合正式第一同构与 private 正式 helper | 旧兼容 wrapper | 同上 |
| 第三同构 | `(R/I)/(J/I) ≅ R/J` | `ringThirdEquiv` | `ringThirdEquiv_projection_projection` | 正式 `RingEquiv` 直接拥有原构造证明 | 旧兼容 wrapper | 同上 |

`RingHomomorphism` 仍是普通函数上的教材展开谓词，不是本次要删除的平行打包载体。
`quotientRingSet` 仍是本库显式商构造；采用 `RingEquiv` 不会将它替换成 Mathlib 商对象。

## 公开签名扫描

- `RingEquiv`：语义一致且已在 Entry 解释的正式公开承载。
- `RingIsomorphism`：本库历史兼容桥侧；不再作为新证明所有者。
- `RingHomomorphism`、`TwoSidedIdealCarrier`、`SubringCarrier`、`quotientRingSet`：既有
  本库接口，本批签名不迁移。
- `Module`、`Submodule`、Mathlib `Ideal.Quotient`：没有进入本批公开签名。
- private helper：`ringHomRangeEquivOfSurjective`、
  `quotientRingEquivOfEqualIdeals` 及其代表元公式，不扩大公开面。

## 验证

1. 将 worktree 中断下载留下的坏 `.lake` 完整移至 `/tmp/ring-carrier-bad-lake-r1` 备份，
   再按共享缓存策略连接 Main 已验收 `.lake`；`lake build
   SandronesLibrary.AbstractAlgebra.RingIsomorphismTheorems` 真实通过（8708 jobs）。
2. `lake build SandronesLibrary.AbstractAlgebra.RingCRT` 真实通过（8709 jobs），证明唯一
   跨文件旧接口消费者仍兼容。
3. 修改后的目标源码也曾独立直编译通过；生成临时目标 olean 后，以完整
   `/tmp/r1overlay` 覆盖旧目标 olean，`RingCRT.lean` 源码再次独立编译通过。
4. `/tmp/sandrones-library/RingIsomorphismCarrierR1Audit.lean` 同时 `#check`：
   - 四个桥／往返结果；
   - 三个正式核心与三个正式公式；
   - 三个旧核心、三个旧公式及三个旧 helper。
5. 同一聚合审计的公理输出：两个往返结果为 `[propext, Quot.sound]`；三个正式代表元公式为
   `[propext, Classical.choice, Quot.sound]`，没有 `sorryAx`。
6. `python3 scripts/audit.py abstract-algebra.ring.iso-theorems` 通过。
7. Entry 映射器将本文件 55 个公开声明唯一映射到
   `abstract-algebra.ring.iso-theorems`；新增正式核心与桥均未漏审或错挂相邻 Entry。
8. 本批没有新增任何 global instance；桥、正式核心、公式和 compatibility wrapper 都是
   普通公开声明，正式组装 helper 保持 private。

## 后续边界

R2 仍由 Main 控制，只迁移 `RingCRT.lean` 的两个同构结果及 CRT Entry。R3 未开放，不添加
deprecation，也不删除旧结构。只读后续实验另已证明 `TwoSidedIdealCarrier` 与 Mathlib
`TwoSidedIdeal` 双向往返，但它需要独立 RFC 和 Main 权限，绝不属于本 R1 提交。
