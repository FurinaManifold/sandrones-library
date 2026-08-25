#!/usr/bin/env python3
"""把 Registry 来源归并到经过出版物类型审核的统一书目。

本脚本只输出已出版书籍和已发表论文。若以后需要加入 arXiv 预印本，应在
reference.bib 中使用带 eprinttype={arXiv} 与 eprint 字段的 @misc 条目，并由
scripts/audit.py 的书目硬门复核。
"""

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "index" / "registry.json"
BIBLIOGRAPHY = ROOT / "reference.bib"

CATALOG = {
    "ahlfors-complex-analysis-1979": """@book{ahlfors-complex-analysis-1979,
  author = {Lars V. Ahlfors},
  title = {Complex Analysis},
  edition = {3},
  publisher = {McGraw--Hill},
  year = {1979}
}""",
    "atiyah-macdonald-commutative-algebra-1969": """@book{atiyah-macdonald-commutative-algebra-1969,
  author = {Michael F. Atiyah and Ian G. Macdonald},
  title = {Introduction to Commutative Algebra},
  publisher = {Addison--Wesley},
  year = {1969}
}""",
    "axler-linear-algebra-2015": """@book{axler-linear-algebra-2015,
  author = {Sheldon Axler},
  title = {Linear Algebra Done Right},
  edition = {3},
  publisher = {Springer},
  year = {2015}
}""",
    "buehler-salamon-functional-analysis-2018": """@book{buehler-salamon-functional-analysis-2018,
  author = {Theo Buehler and Dietmar A. Salamon},
  title = {Functional Analysis},
  series = {Graduate Studies in Mathematics},
  volume = {191},
  publisher = {American Mathematical Society},
  isbn = {978-1-4704-4190-6},
  year = {2018}
}""",
    "conway-functional-analysis-1990": """@book{conway-functional-analysis-1990,
  author = {John B. Conway},
  title = {A Course in Functional Analysis},
  edition = {2},
  publisher = {Springer},
  year = {1990}
}""",
    "conway-functions-complex-variable-1978": """@book{conway-functions-complex-variable-1978,
  author = {John B. Conway},
  title = {Functions of One Complex Variable I},
  edition = {2},
  publisher = {Springer},
  year = {1978}
}""",
    "conway-guy-book-of-numbers-1996": """@book{conway-guy-book-of-numbers-1996,
  author = {John H. Conway and Richard K. Guy},
  title = {The Book of Numbers},
  publisher = {Copernicus},
  year = {1996}
}""",
    "dummit-foote-abstract-algebra-2004": """@book{dummit-foote-abstract-algebra-2004,
  author = {David S. Dummit and Richard M. Foote},
  title = {Abstract Algebra},
  edition = {3},
  publisher = {John Wiley \\& Sons},
  year = {2004}
}""",
    "ecnu-mathematical-analysis-5": """@book{ecnu-mathematical-analysis-5,
  author = {{华东师范大学数学科学学院}},
  title = {数学分析},
  edition = {5},
  publisher = {高等教育出版社},
  isbn = {978-7-04-050694-5},
  year = {2019}
}""",
    "enderton-mathematical-logic-1972": """@book{enderton-mathematical-logic-1972,
  author = {Herbert B. Enderton},
  title = {A Mathematical Introduction to Logic},
  publisher = {Academic Press},
  year = {1972}
}""",
    "folland-real-analysis-1999": """@book{folland-real-analysis-1999,
  author = {Gerald B. Folland},
  title = {Real Analysis: Modern Techniques and Their Applications},
  edition = {2},
  publisher = {John Wiley \\& Sons},
  year = {1999}
}""",
    "goodstein-restricted-ordinal-1944": """@article{goodstein-restricted-ordinal-1944,
  author = {R. L. Goodstein},
  title = {On the Restricted Ordinal Theorem},
  journal = {Journal of Symbolic Logic},
  volume = {9},
  number = {2},
  pages = {33--41},
  doi = {10.2307/2268019},
  year = {1944}
}""",
    "graham-rothschild-spencer-ramsey-1990": """@book{graham-rothschild-spencer-ramsey-1990,
  author = {Ronald L. Graham and Bruce L. Rothschild and Joel H. Spencer},
  title = {Ramsey Theory},
  edition = {2},
  publisher = {John Wiley \\& Sons},
  year = {1990}
}""",
    "hardy-wright-number-theory-2008": """@book{hardy-wright-number-theory-2008,
  author = {G. H. Hardy and E. M. Wright},
  title = {An Introduction to the Theory of Numbers},
  edition = {6},
  publisher = {Oxford University Press},
  year = {2008}
}""",
    "hatcher-algebraic-topology-2002": """@book{hatcher-algebraic-topology-2002,
  author = {Allen Hatcher},
  title = {Algebraic Topology},
  publisher = {Cambridge University Press},
  year = {2002}
}""",
    "horn-johnson-matrix-analysis-2013": """@book{horn-johnson-matrix-analysis-2013,
  author = {Roger A. Horn and Charles R. Johnson},
  title = {Matrix Analysis},
  edition = {2},
  publisher = {Cambridge University Press},
  year = {2013}
}""",
    "ireland-rosen-number-theory-1990": """@book{ireland-rosen-number-theory-1990,
  author = {Kenneth Ireland and Michael Rosen},
  title = {A Classical Introduction to Modern Number Theory},
  edition = {2},
  publisher = {Springer},
  year = {1990}
}""",
    "jech-set-theory-2003": """@book{jech-set-theory-2003,
  author = {Thomas Jech},
  title = {Set Theory},
  edition = {3},
  publisher = {Springer},
  year = {2003}
}""",
    "kirby-paris-independence-1982": """@article{kirby-paris-independence-1982,
  author = {Laurie Kirby and Jeff Paris},
  title = {Accessible Independence Results for Peano Arithmetic},
  journal = {Bulletin of the London Mathematical Society},
  volume = {14},
  number = {4},
  pages = {285--293},
  doi = {10.1112/blms/14.4.285},
  year = {1982}
}""",
    "knuth-coping-finiteness-1976": """@article{knuth-coping-finiteness-1976,
  author = {Donald E. Knuth},
  title = {Mathematics and Computer Science: Coping with Finiteness},
  journal = {Science},
  volume = {194},
  number = {4271},
  pages = {1235--1242},
  doi = {10.1126/science.194.4271.1235},
  year = {1976}
}""",
    "mcd-salamon-symplectic-topology-2017": """@book{mcd-salamon-symplectic-topology-2017,
  author = {Dusa McDuff and Dietmar Salamon},
  title = {Introduction to Symplectic Topology},
  edition = {3},
  publisher = {Oxford University Press},
  year = {2017}
}""",
    "munkres-topology-2000": """@book{munkres-topology-2000,
  author = {James R. Munkres},
  title = {Topology},
  edition = {2},
  publisher = {Prentice Hall},
  year = {2000}
}""",
    "odifreddi-classical-recursion-1989": """@book{odifreddi-classical-recursion-1989,
  author = {Piergiorgio Odifreddi},
  title = {Classical Recursion Theory},
  publisher = {North-Holland},
  year = {1989}
}""",
    "pohlers-proof-theory-1989": """@book{pohlers-proof-theory-1989,
  author = {Wolfram Pohlers},
  title = {Proof Theory: An Introduction},
  publisher = {Springer},
  year = {1989}
}""",
    "rado-non-computable-functions-1962": """@article{rado-non-computable-functions-1962,
  author = {Tibor Rado},
  title = {On Non-Computable Functions},
  journal = {Bell System Technical Journal},
  volume = {41},
  number = {3},
  pages = {877--884},
  doi = {10.1002/j.1538-7305.1962.tb00480.x},
  year = {1962}
}""",
    "rudin-principles-1976": """@book{rudin-principles-1976,
  author = {Walter Rudin},
  title = {Principles of Mathematical Analysis},
  edition = {3},
  publisher = {McGraw--Hill},
  year = {1976}
}""",
    "spivak-calculus-manifolds-1965": """@book{spivak-calculus-manifolds-1965,
  author = {Michael Spivak},
  title = {Calculus on Manifolds},
  publisher = {W. A. Benjamin},
  year = {1965}
}""",
    "tao-measure-theory-2011": """@book{tao-measure-theory-2011,
  author = {Terence Tao},
  title = {An Introduction to Measure Theory},
  publisher = {American Mathematical Society},
  year = {2011}
}""",
    "wainer-ordinal-recursive-1970": """@article{wainer-ordinal-recursive-1970,
  author = {S. S. Wainer},
  title = {A Classification of the Ordinal Recursive Functions},
  journal = {Archiv fuer mathematische Logik und Grundlagenforschung},
  volume = {13},
  number = {3--4},
  pages = {136--153},
  doi = {10.1007/BF01973619},
  year = {1970}
}""",
}


def reference_for(entry_id: str) -> str:
    if entry_id.startswith("functional-analysis."):
        return "buehler-salamon-functional-analysis-2018"
    if entry_id.startswith("real-analysis."):
        return "folland-real-analysis-1999"
    if entry_id.startswith("complex-analysis."):
        return "ahlfors-complex-analysis-1979"
    if entry_id.startswith("topology.homotopy.") or entry_id.startswith("topology.fundamental-group."):
        return "hatcher-algebraic-topology-2002"
    if entry_id.startswith("topology."):
        return "munkres-topology-2000"
    if entry_id.startswith("abstract-algebra.ring.localization"):
        return "atiyah-macdonald-commutative-algebra-1969"
    if entry_id.startswith("abstract-algebra."):
        return "dummit-foote-abstract-algebra-2004"
    if entry_id.startswith("number-theory."):
        if any(word in entry_id for word in ("continued-fraction", "pell", "quadratic-reciprocity")):
            return "ireland-rosen-number-theory-1990"
        return "hardy-wright-number-theory-2008"
    if entry_id.startswith("linear-algebra.symplectic") or entry_id == "linear-algebra.matrix.symplectic":
        return "mcd-salamon-symplectic-topology-2017"
    if entry_id.startswith("linear-algebra.matrix.") or entry_id.startswith("linear-algebra.decomposition."):
        return "horn-johnson-matrix-analysis-2013"
    if entry_id.startswith("linear-algebra."):
        return "axler-linear-algebra-2015"
    if entry_id.startswith("settheory.googology.goodstein"):
        return "goodstein-restricted-ordinal-1944"
    if entry_id.startswith("settheory.googology.hydra") or entry_id == "settheory.googology.hereditary-base":
        return "kirby-paris-independence-1982"
    if entry_id.startswith("settheory.googology.busy-beaver") or entry_id == "settheory.googology.binary-machine":
        return "rado-non-computable-functions-1962"
    if any(word in entry_id for word in ("fast-growing", "hardy-hierarchy", "fundamental-sequence")):
        return "wainer-ordinal-recursive-1970"
    if entry_id == "settheory.googology.knuth-arrow":
        return "knuth-coping-finiteness-1976"
    if entry_id.startswith("settheory.googology.conway"):
        return "conway-guy-book-of-numbers-1996"
    if entry_id == "settheory.googology.graham-number":
        return "graham-rothschild-spencer-ramsey-1990"
    if entry_id.startswith("settheory.computability") or entry_id.startswith("settheory.googology.primitive"):
        return "odifreddi-classical-recursion-1989"
    if entry_id.startswith("settheory.googology") or entry_id == "settheory.ordinal.epsilon-zero":
        return "pohlers-proof-theory-1989"
    if entry_id.startswith("settheory."):
        return "jech-set-theory-2003"
    if entry_id.startswith("analysis.multivariable."):
        return "spivak-calculus-manifolds-1965"
    if entry_id.startswith("analysis."):
        return "ecnu-mathematical-analysis-5"
    if entry_id.startswith("examples."):
        # Examples 取其学科对应的已出版主参考书；当前 Registry 尚无正式 Examples Entry，
        # 保留显式兜底以便未来扩展时不会生成 @misc。
        return "rudin-principles-1976"
    raise RuntimeError(f"尚未为 Entry 选择合规出版来源: {entry_id}")


def update_front_matter(path: Path, citation_key: str) -> None:
    text = path.read_text(encoding="utf-8")
    parts = text.split("---", 2)
    if len(parts) != 3:
        raise RuntimeError(f"缺少 YAML front matter: {path}")
    front = parts[1]
    if re.search(r"(?m)^\s*ref\s*:", front):
        front = re.sub(r'(?m)^(\s*ref\s*:\s*).+$', rf'\1"{citation_key}"', front)
    elif re.search(r"(?m)^provenance:\s*\{", front):
        # 旧资料的 ref 经常是含逗号的完整书名，不能用“读到第一个逗号”为止的
        # 正则，否则会把书名尾部留成非法 YAML。现有格式中 ref 始终是行内映射
        # 的最后一个字段，因此整体替换到右花括号。
        front = re.sub(
            r'(?m)^(provenance:\s*\{[^\n]*?ref:\s*).*(\}\s*)$',
            rf'\1"{citation_key}"\2',
            front,
        )
    else:
        # 一部分早期课程文档没有 provenance 字段；中央来源仍由 Registry 强制维护。
        # 文档格式补齐由 Main 的常规规范化流程处理，不阻塞书目去污。
        return
    path.write_text("---".join((parts[0], front, parts[2])), encoding="utf-8")


def main() -> None:
    records = json.loads(REGISTRY.read_text(encoding="utf-8"))
    used: set[str] = set()
    for record in records:
        key = reference_for(record["id"])
        if key not in CATALOG:
            raise RuntimeError(f"目录缺 citation key: {key}")
        record.setdefault("provenance", {})["ref"] = key
        used.add(key)
        nl_file = record.get("nl_file")
        if nl_file:
            update_front_matter(ROOT / nl_file, key)

    header = (
        "% Sandrone's Library 统一参考文献库\n"
        "% 只收录已出版书籍、已发表论文，或带 arXiv 编号的论文预印本。\n"
        "% Registry 与 Entry 文档只保存 citation key；章节定位写在教材正文，不新建 @misc。\n\n"
    )
    BIBLIOGRAPHY.write_text(
        header + "\n\n".join(CATALOG[key] for key in sorted(used)) + "\n",
        encoding="utf-8",
    )
    REGISTRY.write_text(json.dumps(records, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"已将 {len(records)} 个 Entry 归并到 {len(used)} 条合规出版来源。")


if __name__ == "__main__":
    main()
