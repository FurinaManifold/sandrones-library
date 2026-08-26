# 抽象代数双边理想载体维护 RFC 交接

## 提交范围

- Main 基线：`2c67e3c`。
- 分支：`codex/abstract-algebra-ideal-rfc`。
- 维护等级：M2，当前仅 `research_open`。
- 正式 RFC：`docs/maintenance/abstract-algebra-two-sided-ideal-carrier.md`。
- 本批只包含 RFC 与本 handoff；没有修改 Lean、Entry、CRT、Registry、RADAR、ROADMAP、
  Examples 或其他共享文件。

## 已核实的数学边界

- `TwoSidedIdealCarrier ↔ TwoSidedIdeal` 双向且两个结构往返为恒等；重复的是打包载体。
- `TwoSidedIdealSet` 是逐项教材判据，继续保留。
- 旧 kernel/comap 与正式操作精确一致。
- 满射 direct image 与正式 `TwoSidedIdeal.map` 相等，但必须经过 span 两向包含证明。
- `QuotientIdealOrderEquivalence ↔ OrderIso` 双向且往返为恒等。
- `SubringCarrier ↔ Subring` 也已实验确认，但只属于未来 I3。

## 验证证据

Main 与学科维护侧均运行：

```text
lake env lean /tmp/sandrones-library/TwoSidedIdealCarrierFramework.lean
lake env lean /tmp/sandrones-library/QuotientIdealOrderEquivFramework.lean
lake env lean /tmp/sandrones-library/SubringCarrierFramework.lean
```

三个命令均 exit code 0、无输出；三个文件均无 `sorry`、`admit`、`sorryAx`、
`native_decide`。RFC 的影响计数由全库 `rg` 核实：42 次 Lean 引用全部在
`RingIsomorphismTheorems.lean`，CRT 没有直接引用。

## 后续权限门

- I1：正式 `TwoSidedIdeal` kernel/map/comap 与 quotient-ideal `OrderIso`；等待 Main
  `development_open`。
- I2：第三同构正式输入；依赖 I1 进入 Main。
- I3：正式 `Subring` 与第二同构输入；依赖 I1/I2 和单独子环审核。

各波独立提交、独立回滚。旧接口默认保留 compatibility wrapper；R3 式删除或 deprecation
均未开放。
