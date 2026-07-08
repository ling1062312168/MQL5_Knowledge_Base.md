import re
import pathlib

base = pathlib.Path(r"C:\Users\哈哈哈\AppData\Roaming\MetaQuotes\Terminal\D2C55B9C6D8F14C9A9E9511CD286BD7F\MQL5")
panel = (base / "Include/GroupOrderGridPanel.mqh").read_text(encoding="utf-8")
engine = (base / "Include/GroupOrderEngine.mqh").read_text(encoding="utf-8")
main = (base / "Experts/分组.mq5").read_text(encoding="utf-8")

panel = re.sub(r"^.*?#define GROUP_ORDER_GRID_PANEL_MQH\s*\n", "", panel, flags=re.S)
panel = re.sub(r"\n#endif\s*$", "", panel)

engine = re.sub(r"^.*?#define GROUP_ORDER_ENGINE_MQH\s*\n", "", engine, flags=re.S)
engine = re.sub(r"#include <GroupOrderGridPanel\.mqh>\s*\n", "", engine)
engine = re.sub(r"\n#endif\s*$", "", engine)

main = re.sub(r"#include <GroupOrderGridPanel\.mqh>\s*\n", "", main)
main = re.sub(r"#include <GroupOrderEngine\.mqh>\s*\n", "", main)
main = re.sub(r"^.*?#property description[^\n]*\n", "", main, count=1, flags=re.S)

header = """//+------------------------------------------------------------------+
//|                                                       分组.mq5 |
//|  单文件版：面板+引擎+主程序合一，请只编译本文件                      |
//+------------------------------------------------------------------+
#property copyright "Group Order Panel"
#property version   "3.00"
#property description "20组按序开仓(1→2→…)；奇偶点数±；金额止盈止损整组全平"

#include <Trade\\Trade.mqh>

"""

final = header + panel.strip() + "\n\n" + engine.strip() + "\n\n" + main.strip() + "\n"
final = final.replace('Print("分组EA v2.01', 'Print("分组EA v3.00')

out = base / "Experts/分组.mq5"
out.write_text(final, encoding="utf-8")
print("written", out)
print("lines", final.count("\n") + 1)
