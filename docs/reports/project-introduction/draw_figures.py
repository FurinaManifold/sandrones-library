#!/usr/bin/env python3
"""Editable vector diagrams; PDF and screenshot exports are built separately."""
from html import escape
from pathlib import Path
import json

HERE = Path(__file__).resolve().parent
INK = "#1E3445"
BLUE = "#316C99"
TEAL = "#167D79"
RED = "#AE5547"
GRAY = "#697C8B"


class Figure:
    def __init__(self, height, title, description):
        self.height = height
        self.parts = [
            f'<svg xmlns="http://www.w3.org/2000/svg" width="1000" height="{height}" viewBox="0 0 1000 {height}" role="img">',
            f"<title>{escape(title)}</title><desc>{escape(description)}</desc>",
            '<defs><marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="context-stroke"/></marker></defs>',
            f'<rect width="1000" height="{height}" fill="white"/>',
        ]
        self.min_font = 100

    def text(self, x, y, content, size=22, color=INK, weight=400, anchor="start"):
        self.min_font = min(self.min_font, size)
        self.parts.append(
            f'<text x="{x}" y="{y}" font-family="Noto Sans CJK SC, sans-serif" font-size="{size}" font-weight="{weight}" fill="{color}" text-anchor="{anchor}">{escape(content)}</text>'
        )

    def rect(self, x, y, w, h, fill, stroke=GRAY, dash=False, radius=10):
        dashed = ' stroke-dasharray="8 5"' if dash else ""
        self.parts.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{radius}" fill="{fill}" stroke="{stroke}" stroke-width="1.6"{dashed}/>')

    def card(self, x, y, w, h, title, lines, color=BLUE, fill="#F1F6FA", dash=False, size=22):
        self.rect(x, y, w, h, fill, color, dash)
        self.parts.append(f'<path d="M{x+14} {y+13} V{y+h-13}" stroke="{color}" stroke-width="4"/>')
        self.text(x+27, y+32, title, size=23, color=color, weight=700)
        for i, line in enumerate(lines):
            self.text(x+27, y+64+i*29, line, size=size)

    def arrow(self, path, color=GRAY, dashed=False):
        dash = ' stroke-dasharray="7 5"' if dashed else ""
        # Explicit marker color is needed by CairoSVG, which lacks context-stroke support.
        self.parts.append(f'<path d="{path}" fill="none" stroke="{color}" stroke-width="2.3"{dash}/>' )
        # Draw a triangle at the last point; all final segments in these diagrams are axis aligned.
        nums = path.replace("M", " ").replace("L", " ").split()
        coords = [(float(nums[i]), float(nums[i+1])) for i in range(0, len(nums), 2)]
        (x0, y0), (x, y) = coords[-2:]
        if abs(x-x0) > abs(y-y0):
            sign = 1 if x>x0 else -1
            points = f"{x},{y} {x-10*sign},{y-5} {x-10*sign},{y+5}"
        else:
            sign = 1 if y>y0 else -1
            points = f"{x},{y} {x-5},{y-10*sign} {x+5},{y-10*sign}"
        self.parts.append(f'<polygon points="{points}" fill="{color}"/>')

    def save(self, name, description):
        (HERE / f"{name}.svg").write_text("\n".join(self.parts+["</svg>"])+"\n", encoding="utf-8")
        return {"stem": name, "description": description, "canvas_width_px": 1000,
                "canvas_height_px": self.height, "min_label_font_px": self.min_font,
                "report_width_mm": 168}


def theorem_contract():
    f = Figure(410, "著名定理的名称如何变成明确接口", "名称只作检索。通过来源、版本契约和审核建立可调用声明。Hahn–Banach 的三个具体声明分别保留。")
    f.text(22, 34, "名称索引 → 来源定位 → 版本契约 → 明确调用", size=27, weight=700)
    f.card(22, 62, 177, 130, "著名名称", ["Hahn–Banach", "发现定理家族"], size=20)
    f.card(235, 62, 208, 130, "定位具体来源", ["版本 · 原页", "恢复符号与假设"], size=20)
    f.card(479, 62, 245, 130, "冻结数学契约", ["对象 · 量词 · 边界", "Lean 类型 · 依赖"], color=TEAL, fill="#EDF7F4", size=20)
    f.card(760, 62, 218, 130, "验收后调用", ["具名声明与证据", "实际下游使用者"], color=TEAL, fill="#EDF7F4", size=20)
    for a, b in [(199, 235), (443, 479), (724, 760)]:
        f.arrow(f"M {a} 127 L {b} 127")
    f.text(22, 226, "仓库现有示例：一个 Entry，三个可区分的公开声明", size=23, weight=700)
    f.card(22, 248, 295, 93, "C1  实支配延拓", ["次线性控制 → 保持支配"], size=20)
    f.card(353, 248, 295, 93, "C2  实等范数延拓", ["连续线性泛函 → 等范数"], color=TEAL, fill="#EDF7F4", size=20)
    f.card(684, 248, 294, 93, "C3  实不增范数延拓", ["相同前提 → 范数不增"], color=TEAL, fill="#EDF7F4", size=20)
    f.arrow("M 500 341 L 500 365 L 831 365 L 831 341", color=TEAL)
    f.text(665, 396, "源码已证：C2 推出 C3", size=21, color=TEAL, anchor="middle")
    f.text(22, 378, "C1 与 C2 的互换", size=20, color=GRAY)
    f.text(22, 403, "需条件与桥，不能凭名字", size=20, color=GRAY)
    return f.save("theorem-contract", "现有 Hahn–Banach 接口及建议的版本契约方法")


def workflow():
    f = Figure(396, "论文形式化双线验收工作流", "冻结范围与契约后分别进行语义对应和形式证明审核，两门通过再验收覆盖并发布，失败回到相关契约或证明任务。")
    f.text(22, 34, "论文形式化：语义对应与形式证明双线核验", size=27, weight=700)
    f.card(22, 127, 156, 137, "论文输入", ["版本与原页", "范围清单", "声明与上下文"], size=20)
    f.card(213, 127, 188, 137, "契约冻结", ["定义 · 量词", "假设 · 结论", "签名 · DAG"], color=BLUE, size=20)
    f.card(444, 69, 221, 103, "A  语义对应", ["非作者回译与挑战", "原文 ↔ 公开类型"], color=TEAL, fill="#EDF7F4", size=20)
    f.card(444, 220, 221, 103, "B  形式证明", ["定义与桥 → 引理", "编译 · 公理 · 使用"], color=BLUE, size=20)
    f.card(718, 127, 260, 137, "C  覆盖与发布", ["A + B 双门通过", "主定理与责任闭环", "发布提交 · 限定报告"], color=TEAL, fill="#EDF7F4", size=20)
    f.arrow("M 178 195 L 213 195")
    f.arrow("M 401 171 L 420 171 L 420 119 L 444 119")
    f.arrow("M 401 224 L 420 224 L 420 272 L 444 272")
    f.arrow("M 665 119 L 690 119 L 690 172 L 718 172", color=TEAL)
    f.arrow("M 665 272 L 690 272 L 690 224 L 718 224", color=BLUE)
    f.arrow("M 555 69 L 555 48 L 306 48 L 306 127", color=RED, dashed=True)
    f.text(768, 79, "语义偏差：重开契约", color=RED, size=20, anchor="middle")
    f.arrow("M 849 264 L 849 349 L 555 349 L 555 323", color=RED, dashed=True)
    f.text(747, 381, "覆盖缺口／证明失败：继续派工与复验", color=RED, size=20, anchor="middle")
    f.text(22, 354, "实线：产物与验收", color=GRAY, size=20)
    f.text(22, 381, "虚线：返工与失效传播", color=RED, size=20)
    return f.save("workflow", "建议的论文级语义、证明与覆盖三门闭环")


def scale():
    f = Figure(562, "数百 Agent 的分层审核与发布架构", "上层控制接口与调度，下层证明工作由小组负责，再由学科队列验收并经单写者发布。三百仅指证明 worker，审核和计算资源另计。")
    f.text(22, 34, "未来架构：数学审核分层，最终发布保持单写者", size=27, weight=700)
    f.rect(22, 57, 956, 73, "#F3F5F7", GRAY, dash=True)
    f.text(42, 87, "控制平面：定理契约目录 · 论文账本 · DAG／所有权 · 队列与证据索引", size=22, weight=700)
    f.text(42, 116, "接口先冻结；审核积压触发背压；签名变化传播失效", size=21, color=GRAY)
    f.rect(22, 178, 279, 260, "#F1F6FA", BLUE)
    f.text(42, 213, "100 个证明小组", size=24, color=BLUE, weight=700)
    for y, tag in [(233, "小组 01"), (325, "小组 100")]:
        f.rect(42, y, 239, 69, "white", BLUE)
        f.text(57, y+27, tag+"：3 worker", size=21, color=BLUE, weight=700)
        f.text(57, y+54, "负责人 · 非作者审核", size=20)
    f.text(162, 322, "···", size=24, anchor="middle", color=GRAY)
    f.text(42, 426, "独立 worktree／分支／构建", size=20)
    f.card(351, 178, 262, 260, "10 条学科集成队列", ["每条汇总 10 个小组", "数学与语义亲自验收", "闭包构建 · 联合导入", "接口差异 · 增量建议", "输出已提交验收包"], color=TEAL, fill="#EDF7F4", size=20)
    f.card(663, 178, 315, 130, "自动合并与发布列车", ["唯一写者生成共享状态", "精确候选 CI · 失败拆包", "公理／audit／全库构建"], color=BLUE, size=20)
    f.card(663, 347, 315, 91, "Main 治理与发布", ["跨学科 API · 例外 · 最终提交"], color=TEAL, fill="#EDF7F4", size=20)
    f.arrow("M 301 297 L 351 297", color=BLUE)
    f.arrow("M 613 245 L 663 245", color=TEAL)
    f.arrow("M 821 308 L 821 347", color=BLUE)
    for x in (162, 482, 821):
        f.arrow(f"M {x} 130 L {x} 178", dashed=True)
    f.arrow("M 821 438 L 821 466 L 482 466 L 482 438", color=RED, dashed=True)
    f.text(653, 496, "跨学科接口反馈／返工", size=20, color=RED, anchor="middle")
    f.text(22, 494, "现行基础：每负责人管理 2–3 worker", size=20, color=GRAY)
    f.text(22, 523, "扩展示例：100 × 3 = 300 证明 worker；负责人／审核者／CI 另计", size=21, weight=700)
    f.text(22, 550, "实线：验收包上行；虚线：控制与反馈。按审核容量与队列等待分级扩容。", size=20, color=GRAY)
    return f.save("scale-architecture", "建议的 300 证明 worker 分组、学科集成与单写者发布架构")


def main():
    manifest = {"generator": "draw_figures.py", "figures": [theorem_contract(), workflow(), scale()]}
    (HERE / "figure-manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
    print("Generated 3 editable workflow SVGs")


if __name__ == "__main__":
    main()
