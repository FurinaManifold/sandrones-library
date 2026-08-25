# 标准实线、单位区间与道路 A1 handoff

## 批次与同步

- 分支：`codex/topology-foundations`。
- 开工前以 `git merge main` 同步 Main `bdc17a6`，合并提交 `287c5fe`。
- 范围是 A1 的标准实拓扑／单位区间 → Mathlib `Path` 数据 → 常值与连续像入口。
- 逆道路与拼接 Entry 留给下一小批；A2/A3 同伦、道路同伦和基本群仍锁定。

## 概念链

| 教材概念 | Mathlib 正式承载 | 展开／一手性质 | legacy compatibility | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 实数开集 | 标准 `TopologicalSpace ℝ` | `real_isOpen_iff_abs` | `toMathlib_realLine` | 单位区间 | `topology.foundation.real-line` |
| 闭单位区间 | `unitInterval`／`Set.Icc 0 1` | `unitInterval_eq_Icc` | `toMathlib_unitInterval` | `Path` | 同上 |
| 道路数据 | Mathlib `Path x y` | `nonempty_path_iff_exists_continuous` | `Path.toMathlib/fromMathlib` 及往返 | `Joined` | `topology.homotopy.path-definition-foundation` |
| 常值道路 | `Path.refl` | 文档解释端点与常值函数 | 旧 `Path.refl` 冻结 | `Joined.refl` | 同上 |
| 道路连续像 | `Path.map` | Mathlib 根 `Continuous` | 旧 `Path.map` 冻结 | `Joined.map` | 同上 |

## 接口与边界

三条新教材接口直接使用标准实拓扑、根 `unitInterval`、根 `Path` 和根 `Continuous`。六条新增兼容
声明只证明旧实线／区间拓扑的规范性以及旧／新道路的无损转换。没有 notation、全局 instance 或
从 Mathlib 绕回旧道路的新课程使用者。

本批不迁移 `Path.symm/trans`，也不触碰任何 homotopy quotient。严格道路相等和道路同伦的边界已
在课程文档中明确；结合律／单位律不得作为严格函数等式偷渡。

## Entry 与验证

- `topology.foundation.real-line` 映射 27 条：前 2 条正式接口，后 25 条 legacy。
- `topology.homotopy.path-definition-foundation` 映射 9 条：首条正式接口，后 8 条 legacy。
- `topology.foundation.mathlib-compatibility` 增至 21 条迁移声明。
- 三篇 Entry 文档均精确八段并原地迁移，不建立第二套 carrier Entry。
- 完整旧拓扑闭包至 `PathReparameterization`，连同 `PathConnected`、`MathlibCompatibility` 构建
  通过，1587 jobs。
- 聚合文件检查正式接口、六条桥、`Path.refl/map` 和 `Joined` 上层使用者；七项 `#print axioms`
  均为 `propext`、`Classical.choice`、`Quot.sound`，来自 Mathlib 既有拓扑／道路承载。
- 拓扑目录仍有 19 个文件、242 次 `TextbookTopology` 词法出现；`Path` 词法为 12 个文件、111 次，
  新增出现来自正式接口和显式桥，并不表示旧下游已经减少。跨学科旧接口直接使用者仍为 0。
- Registry、RADAR、ROADMAP、Examples 与公理指纹由 Main 集成时更新。
