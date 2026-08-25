# Main review：A3.8 可分性与正规性的根论刻画

- branch: `codex/abstract-algebra`
- reviewed_commit: `71febbb`
- integrated_commit: `97ae48b`
- reviewer: `main`
- verdict: `accepted`
- reviewed_at: 2026-08-25

## 验收结论

提交保持 A3.8 第一批显式 `FieldEmbedding` 定义不变，在独立模块中完成可分多项式的扩域根重数
上界、分裂非零多项式的可分性充要条件，以及正规扩张的“不可约多项式有一个根便完全分裂”
刻画。零多项式边界有显式前提，正规性逆向确实经过最小多项式的不可约性和整除泛性质，没有把
Mathlib 的隐式 `Algebra` 后端泄露到公开签名。

目标模块构建通过；三条公开定理的 Entry 映射与公理审计通过，公理仅为 `propext`、
`Classical.choice`、`Quot.sound`。共享定义审计表冲突由 Main 合并，未打回源码。

## 后续权限

- A3.9a Galois 定义层：`integration_open`；
- A3.9b 基本定理：`development_open`，集成等待 A3.9a 签名冻结。
