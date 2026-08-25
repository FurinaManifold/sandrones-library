# 道路定义 foundation handoff

## 分支与范围

- 分支：`codex/topology-foundations`。
- 修改 `Foundation.lean`：补出由开集定义证明的常函数连续性。
- 新源码：`SandronesLibrary/Topology/Path.lean`。
- 新条目：`topology.homotopy.path-definition-foundation`。
- 本 review 批次接收顺序第二项：`07c8057`，前置为 `1bfe5fa`；基础结构批次已经 Main 验收。

## 公开定义与边界

- `Path τX a b` 携带 `UnitInterval → X`、本库连续性和两个端点等式。
- `Path.refl` 是常值道路；`Path.map` 是连续映射下的道路像；`Loop` 是同端点道路。
- foundation id 特意不占用完整 `topology.homotopy.path-loop`：逆道路、拼接及其定律尚未完成。

## 负责人审核

- 核心模块不 import `MathlibBridge`；应以负向编译测试确认 Mathlib `Path` 不可见。
- 检查 `Path.map` 的连续性来自本库 `Continuous.comp`，端点来自原道路字段。
- `Loop` 只是道路的教材特例，不引入另一套不兼容的函数结构。
- Main-side gate：当前 `scripts/check_axioms.py` 尚不识别 `structure`，所以 `structure Path` 本身仍
  等待 Main 扩展审计器后强制重审；不能把后续 `ext/refl/map` 的审计冒充结构审计。

## 教材概念清单

| 概念 | 本库教材定义 | 定义展开／一手性质 | Mathlib 桥 | 首个真实使用者 | 源码 Entry |
|---|---|---|---|---|---|
| 道路 | `structure Path` | 字段 `toFun/continuous/source/target`、`Path.ext` | 无 | `Path.refl`、`Path.map` | `topology.homotopy.path-definition-foundation` |
| 环路 | 透明 `def Loop := Path τX a a` | `loopRefl` | 无 | `loopRefl` | `topology.homotopy.path-definition-foundation` |

## 公开签名扫描与定义链

- 所有公开签名只使用本库 `TextbookTopology`、`Continuous`、`UnitInterval`、`Path/Loop` 及普通函数；
  Mathlib 专用拓扑名四类扫描结果为空，也没有申请第 4 类例外。
- 聚合链：`Path` → `Path.ext` → `Path.refl/map`；`Loop` → `loopRefl`。声明映射现在可识别
  `Loop/loopRefl`，但 `structure Path` 仍是明确的 Main-side gate。
- `a353558` 将透明 `abbrev Loop` 改为透明 `def Loop` 并增加 `loopRefl`，使环路的定义与真实
  使用者都进入 path definition Entry 映射。

## Main 共有文件建议

- 顶层 import 暂只建议加入 foundation id；不得将完整 T4 道路条目标为完成。
- Registry 登记 foundation，ROADMAP 保持 `topology.homotopy.path-loop` 施工中。

## 下一批

下一批证明单位区间反射 `t↦1-t` 在本库意义下连续并定义逆道路；随后建立分段连续粘合引理，才能
定义道路拼接及环路运算。
