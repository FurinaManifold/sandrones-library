# 道路逆向与拼接 A1 handoff

## 范围与基线

- 分支：`codex/topology-foundations`；开工后按新通知以 `git merge main` 同步集成提交
  `0418f7f`，合并提交为 `2bc2285`。
- Main `topology-real-path-a1-main-review.md` 明确放行本小批。
- 只迁移 `Path.symm` 与 `Path.trans`；A2/A3、同伦商、基本群、道路单位律和结合律全部冻结。

## 概念链

| 教材概念 | Mathlib 正式承载 | 展开／一手性质 | legacy compatibility | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 逆道路 | `Path.symm` | `path_symm_apply` | `Path.toMathlib_symm` | `Path.trans_symm` | `topology.homotopy.path-reversal-foundation` |
| 双重反向 | `Path.symm_symm` | `path_symm_symm` | 旧 `Path.symm_symm` 冻结 | 道路代数 | 同上 |
| 道路拼接 | `Path.trans` | 两条左右半区取值定理 | `Path.toMathlib_trans` | `Joined.trans` | `topology.homotopy.path-concatenation-foundation` |

## 数学边界

逆道路的双重反向是严格道路等式，因为区间反射两次严格恢复参数。拼接采用固定二倍速参数化，故
与常值道路的单位律、三条道路的结合律通常不是严格函数等式；这些结论只能在重新参数化或道路同伦
层处理。本批没有声明任何单位律、结合律、逆律或商上的群运算。

两条 compatibility 定理通过道路外延证明旧转换与 `symm/trans` 交换。它们是旧下游退出通道，
不是从 Mathlib 返回旧层级的新课程入口。

## Entry 与验证

- reversal Entry 映射 5 条：前 2 条正式接口，后 3 条 legacy。
- concatenation Entry 映射 11 条：前 2 条正式接口，后 9 条 legacy。
- compatibility Entry 增至 23 条迁移声明。
- 三篇相关 Entry 文档均精确八段；原 id 原地迁移。
- 完整旧拓扑闭包至 `PathReparameterization` 加 `PathConnected`、compatibility 构建通过，1587 jobs。
- 同步 `0418f7f` 后重跑同一 1587-job 闭包与聚合审计，结果不变。
- 聚合 `#check` 覆盖 4 条正式接口、2 条操作桥及 Mathlib `Path.symm/trans/trans_symm`；六项
  `#print axioms` 均为 `propext`、`Classical.choice`、`Quot.sound`。
- 三个 Entry audit、禁用占位与冲突标记扫描、`git diff --check` 均通过。
