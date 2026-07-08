$base = "C:\Users\哈哈哈\AppData\Roaming\MetaQuotes\Terminal\D2C55B9C6D8F14C9A9E9511CD286BD7F\MQL5"
$panel = Get-Content "$base\Include\GroupOrderGridPanel.mqh" -Encoding UTF8
$engine = Get-Content "$base\Include\GroupOrderEngine.mqh" -Encoding UTF8

$mainPath = "$base\Experts\分组下订单.mq5"
if (-not (Test-Path $mainPath)) { $mainPath = "$base\Experts\分组下单面板.mq5" }
$main = Get-Content $mainPath -Encoding UTF8

# panel: skip header/guard (lines 0-6), skip trailing #endif
$panelBody = $panel[7..($panel.Length-2)]

# engine: skip header/guard/include (lines 0-9), skip trailing #endif
$engineBody = $engine[10..($engine.Length-2)]

# main: from first input group, without includes
$mainStart = 0
for ($i = 0; $i -lt $main.Length; $i++) {
  if ($main[$i] -match '^input group') { $mainStart = $i; break }
}
$mainBody = $main[$mainStart..($main.Length-1)]

$header = @(
'//+------------------------------------------------------------------+'
,'//|                                                       分组.mq5 |'
,'//|  单文件版：面板+引擎+主程序合一，请只编译本文件                      |'
,'//+------------------------------------------------------------------+'
,'#property copyright "Group Order Panel"'
,'#property version   "3.00"'
,'#property description "20组按序开仓(1→2→…)；奇偶点数±；金额止盈止损整组全平"'
,''
,'#include <Trade\Trade.mqh>'
,''
)

$out = $header + $panelBody + '' + $engineBody + '' + $mainBody
$outPath = "$base\Experts\分组.mq5"
$out | Set-Content -Path $outPath -Encoding UTF8
Write-Host "Done:" $out.Count "lines ->" $outPath

# unified include (panel + engine)
$includeHeader = @(
'//+------------------------------------------------------------------+'
,'//|                                                   GroupOrder.mqh |'
,'//|  分组下单：面板 UI + 交易引擎（合并版）                              |'
,'//+------------------------------------------------------------------+'
,'#ifndef GROUP_ORDER_MQH'
,'#define GROUP_ORDER_MQH'
,''
,'#include <Trade\Trade.mqh>'
,''
)
$includeFooter = @('', '#endif')
$includeOut = $includeHeader + $panelBody + '' + $engineBody + $includeFooter
$includePath = "$base\Include\GroupOrder.mqh"
$includeOut | Set-Content -Path $includePath -Encoding UTF8
Write-Host "Include:" $includeOut.Count "lines ->" $includePath
