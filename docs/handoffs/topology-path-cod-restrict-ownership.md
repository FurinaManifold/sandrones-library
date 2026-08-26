# Topology infrastructure handoff：道路余域限制归位

## 范围与权限

- Main 基线：`22c062d`。
- 权限来源：`review-inbox/topology/main-679dc3f-infrastructure-and-r3a-open.md`。
- 本批把既有 `pathCodRestrict` 从 VK2 移到中性模块，并新增 Main 明确允许的一手计算引理
  `pathCodRestrict_coe`；没有第二道路承载、alias 或复制实现。

## 文件与所有权变化

- 新增 `SandronesLibrary/Topology/PathCodRestrict.lean`，唯一拥有构造和 coercion 规则。
- `VanKampenSurjectivity.lean` 删除原定义并 import 中性模块；其他内容不变。
- 新增 Entry `topology.homotopy.path-cod-restrict`。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接消费者 |
|---|---|---|
| `pathCodRestrict` | 将值域包含于 `S` 的环境道路提升为 subtype `S` 中道路 | VK2 `basedPieceLoop`、VK3b-01 单格提升、VK3b-02/03 候选 |
| `pathCodRestrict_coe` | 强制转换回 ambient space 后逐点等于原道路 | VK3b 候选中的逐点道路识别；中性重写接口 |

两项都有跨模块用途，保持公开。定义只要求 `[TopologicalSpace X]`，不带开性、覆盖或基本群参数。

## Mathlib 复用与证明说明

固定 Mathlib 源码中没有 `Path` 的同用途余域限制构造；现有 cod-restrict 接口属于其他映射结构，不能
替代带 source/target 字段的 `Path`。本定义以 `p.continuous.subtype_mk` 证明连续性，端点字段由
subtype 外延和原道路 source/target 得到；`pathCodRestrict_coe` 为 `rfl`，不使用自动化。

## 验证

- 同时构建 `PathCodRestrict`、VK2、VK3a 和当前 VK3b-01：1749 jobs 通过。
- 研究 aggregate 在正式 import 路径下通过，检查中性构造、coercion、VK2 `basedPieceLoop` 与满射
  出口，以及 VK3b-01 单格边界出口。
- 两项声明的 `#print axioms` 均只有 `propext`、`Classical.choice`、`Quot.sound`。
- Entry 映射精确包含 `pathCodRestrict` 与 `pathCodRestrict_coe`。
- 全库声明搜索确认 `pathCodRestrict` 只有中性模块中的一个定义；VK2 只保留调用点。
- `git diff --check` 与禁用项扫描通过。

本批是三个独立 ownership move 中第二项；不包含 corrected-loop 移动、VK3b 新数学内容或 T4-R3a。
