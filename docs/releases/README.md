# 候选批次发布回执台账

本目录保存由 `python3 scripts/release_gate.py` 产出的**发布回执** JSON
（schema `sandrones-release-receipt/1`）。每份回执记录：候选（main 工作树）分支与
commit、被核对学科包、按 AGENTS §6 顺序执行的每一步 rc/耗时/输出尾部、派生文件清单、
异常清单与总体 verdict。

回执是"**这一次候选**"的证据：目标分支一旦前进（基线变化）必须重新排队重跑，不得沿用。
协议见 [`docs/SUBJECT-PACKAGE-PROTOCOL.md`](../SUBJECT-PACKAGE-PROTOCOL.md)。
本目录属 Main 共享文件。
