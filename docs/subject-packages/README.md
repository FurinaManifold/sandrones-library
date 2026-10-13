# 学科验收包台账

本目录保存由 `python3 scripts/subject_package.py` 产出的**学科验收包** JSON
（schema `sandrones-subject-package/1`）。每个包记录一个学科窗口相对其基线的提交、
改动文件、五组门（清洁／所有权／语义／证明／覆盖）结果与**异常清单**。

Main 接收交付时**只审异常清单**与跨学科接口，不逐份重读；协议见
[`docs/SUBJECT-PACKAGE-PROTOCOL.md`](../SUBJECT-PACKAGE-PROTOCOL.md)。
本目录属 Main 共享文件，学科只提供事实，不直接写这里。
