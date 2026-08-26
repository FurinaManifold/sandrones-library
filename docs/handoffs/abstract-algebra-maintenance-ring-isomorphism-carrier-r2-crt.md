# 抽象代数环同构载体维护 R2：CRT 交接

## 批次与范围

- Main 开发基线：`2c67e3c`（R1 已在 Main 集成为 `590c47c`）。
- 分支：`codex/abstract-algebra-ring-r2`。
- R2 只修改：
  - `SandronesLibrary/AbstractAlgebra/RingCRT.lean`；
  - `docs/entries/abstract-algebra/ring/crt.md`；
  - 本 handoff。
- 理想、商环、R3 旧接口处置、Examples 与共享文件均未修改。

## 正式核心与兼容层

新增四个正式公开声明：

- `chineseRemainderEquiv`；
- `chineseRemainderEquiv_projection`；
- `finiteChineseRemainderEquiv`；
- `finiteChineseRemainderEquiv_projection`。

两个 `RingEquiv` 核心直接拥有原 CRT 的单射、满射、选择逆映射和正向保持加乘证明。旧
`chineseRemainderIsomorphism`、`finiteChineseRemainderIsomorphism` 及两个旧代表元公式的
名称、参数、返回类型均保留，只经 `RingIsomorphism.ofRingEquiv` 或正式公式薄包装。原来为旧
逆函数再次证明 `RingHomomorphism` 的两段代码已删除，没有第二条证明链。

正式公开承载为 A2.3 已解释并验收的 `RingEquiv`。`TwoSidedIdealSet`、`quotientRingSet`、
`RingHomomorphism` 仍是既有教材层；Mathlib `Ideal` 仍只在有限族满射证明体中使用。
本批没有新增 global instance。

## 验证

1. 修改源码跨目录直接编译通过。
2. 首次把整个 Main `.lake` 链接进 worktree 虽显示 build success，但聚合导入仍得到旧 CRT
   olean；该结果被主动判为无效，没有写入最终证据。
3. 随后建立 worktree 自有 `.lake/build`，仅共享 Main 的 dependency packages，真实运行：

   ```text
   lake build SandronesLibrary.AbstractAlgebra.RingCRT
   ```

   8709 jobs 通过；日志明确重建本库 `Ring`、`RingQuotient`、
   `RingIsomorphismTheorems` 与修改后的 `RingCRT`。
4. `/tmp/sandrones-library/RingCRTR2Audit.lean` 同时 `#check` 四个新声明与四个旧兼容声明，
   证明导入的是 R2 新 olean。
5. 四个新旧代表元公式的公理均为
   `[propext, Classical.choice, Quot.sound]`，没有 `sorryAx`。
6. `python3 scripts/audit.py abstract-algebra.ring.crt` 通过。
7. Entry 映射器将本模块 26 个公开声明唯一映射到 `abstract-algebra.ring.crt`，其中新旧
   八个同构声明均被覆盖。
8. 正式源码无 `sorry`、`admit`、`sorryAx`、`native_decide`；`git diff --check` 通过。

## 后续门

R2 完成后，环同构载体在仓内的两个真实 CRT 下游已迁移。R3 仍未开放：不 deprecate、不删除
`RingIsomorphism` 或旧 CRT API。双边理想 I1 是另一份 M2 RFC，不能由本提交推断已获 Lean 权限。
