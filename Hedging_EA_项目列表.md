# Hedging_EA 项目列表

> 生成时间：2025-07-11
> 用途：管理商业版 Hedging_EA 与开源版 Fusion_HedgeMonitor_EA 的代码资源

---

## 📁 一、商业版 Hedging_EA 二进制文件

| 文件名 | 版本 | 平台 | 路径 | 说明 |
|--------|------|------|------|------|
| Hedging_EA_v6.6.2.ex5 | v6.6.2 | MT5 | `/workspace/Hedging_EA_v6.6.2.ex5` | 最新商业版二进制（需DLL授权） |
| Hedging_EA_v6.6.2.ex4 | v6.6.2 | MT4 | `/workspace/Hedging_EA_v6.6.2.ex4` | MT4平台对应版本 |
| Hedging_EA_v6.6.ex4 | v6.6 | MT4 | `/workspace/Hedging_EA_v6.6.ex4` | v6.6 MT4版本 |
| Hedging_EA_v6.6 - 副本.ex4 | v6.6 | MT4 | `/workspace/Hedging_EA_v6.6 - 副本.ex4` | v6.6 备份副本 |
| Hedging_EA_v6.4.1.ex5 | v6.4.1 | MT5 | `/workspace/Hedging_EA_v6.4.1.ex5` | v6.4.1 MT5版本 |
| Hedging_EA_v6.4.ex5 | v6.4 | MT5 | `/workspace/Hedging_EA_v6.4.ex5` | v6.4 MT5版本 |
| Hedging_EA_v6.4.ex4 | v6.4 | MT4 | `/workspace/Hedging_EA_v6.4.ex4` | v6.4 MT4版本 |
| Hedging_EA_v6.6.2_package.zip | v6.6.2 | - | `/workspace/MQL5_Codebase/文档资料/其他/Hedging_EA_v6.6.2_package.zip` | 完整打包文件 |

### 商业版依赖
- **WININET.dll**：授权验证、远程策略下发
- 提取自：`/tmp/hedging_extract/Hedging_EA_mt5v6.6.2/Experts/Hedging_EA_v6.6.2/WININET.dll`

---

## 📁 二、开源版 Fusion_HedgeMonitor_EA 源码

| 文件名 | 版本 | 行数 | 路径 | 说明 |
|--------|------|------|------|------|
| Fusion_HedgeMonitor_EA.mq5 | 主版本 | 2366 | `/workspace/MQL5_Codebase/EA交易策略/其他EA/Fusion_HedgeMonitor_EA.mq5` | 开源对冲监控EA完整版 |
| Fusion_HedgeMonitor_EA0001.mq5 | 变体1 | 2442 | `/workspace/MQL5_Codebase/EA交易策略/其他EA/Fusion_HedgeMonitor_EA0001.mq5` | PanelStyle=0 变体 |
| Fusion_HedgeMonitor_EA0002.mq5 | 变体2 | 2455 | `/workspace/MQL5_Codebase/EA交易策略/其他EA/Fusion_HedgeMonitor_EA0002.mq5` | 含品种排序功能 |

### 开源版核心模块
| 模块名称 | 功能描述 | 关键函数 |
|----------|----------|----------|
| 对冲引擎 | 盈利消耗型对冲、浮盈对冲 | `RunHedgeEngine()` |
| 浮亏监控 | 多品种浮亏阈值监控、自动关图 | `RunMonitorEngine()` |
| 协同机制 | 对冲与监控事件联动 | `ProcessSynergyEvents()` |
| 状态同步 | 对冲/监控状态双向同步 | `SyncHedgeStatus()` |
| UI面板 | 实时状态展示、手动操作 | `UpdateProfitLabels()` |

### 开源版核心数据结构
| 结构体 | 用途 | 关键字段 |
|--------|------|----------|
| `HedgeStatusData` | 对冲状态 | isActive, todayProfit, totalFloatingLoss, hedgeReady |
| `MonitorStatusData` | 监控状态 | totalSymbols, totalLoss, lockEnabled, closeCountToday |
| `SynergyEvent` | 协同事件 | eventType(1对冲完成/2监控触发/3手动操作), symbol, amount |

---

## 📁 三、相关工具与文档

### 对冲相关EA
| 文件名 | 路径 | 说明 |
|--------|------|------|
| 当天盈利对冲浮亏单.mq4 | `/workspace/MQL5_Codebase/EA交易策略/对冲策略/` | 盈利对冲浮亏MT4版 |
| 安全分批对冲002.mq4 | `/workspace/MQL5_Codebase/EA交易策略/对冲策略/` | 分批对冲策略 |
| 方向突破倍投对冲EA.mq4 | `/workspace/MQL5_Codebase/EA交易策略/对冲策略/` | 突破+对冲组合 |

### 风控/监控工具
| 文件名 | 路径 | 说明 |
|--------|------|------|
| MT5浮亏风控统计平仓工具.mq5 | `/workspace/` | MT5浮亏监控平仓 |
| 浮亏监控关闭图表.mq5 | `/workspace/` | 浮亏触发关图MT5版 |
| 账户仓位多空仓位平衡风控.mq5 | `/workspace/` | 多空平衡风控 |

### 技术文档
| 文件名 | 路径 | 说明 |
|--------|------|------|
| hedging.md | `/workspace/MQL5_Codebase/文档资料/技术文档/hedging.md` | 对冲模块技术文档 |
| statistics.md | `/workspace/MQL5_Codebase/文档资料/技术文档/statistics.md` | 统计模块文档 |
| MQL5_Knowledge_Base.md | `/workspace/MQL5_Codebase/文档资料/技术文档/MQL5_Knowledge_Base.md` | MQL5知识库 |

---

## 📁 四、关联源码文件

| 文件名 | 路径 | 说明 |
|--------|------|------|
| EA_Trader.mq5 | `/workspace/EA_Trader.mq5` | 交易员EA（可能被Hedging_EA集成） |
| GoldenHorse_EA.mq5 | `/workspace/GoldenHorse_EA.mq5` | 金马EA（同类型产品参考） |
| 均线策略.mq5 | `/workspace/均线策略.mq5` | 均线策略基础模块 |

---

## 📊 五、版本功能对比

| 特性 | 商业版 Hedging_EA | 开源版 Fusion_HedgeMonitor_EA |
|------|-------------------|-------------------------------|
| 授权验证 | ✅ 需DLL授权 | ❌ 无授权限制 |
| 远程策略下发 | ✅ WININET.dll支持 | ❌ 本地配置 |
| 对冲模式 | 多模式（基础/半自动/浮盈/盈利消耗） | 浮盈对冲+盈利消耗 |
| 浮亏监控 | 增强版（含智能关单） | 基础版（关图+锁仓） |
| 协同机制 | 深度联动+状态机 | 事件队列式联动 |
| UI定制 | 多主题+拖拽 | 固定布局+3配色 |
| 多品种支持 | ✅ 原生支持 | ✅ 配置式支持 |
| 加密货币适配 | ✅ 周末模式优化 | ⚠️ 基础适配 |
| 日志系统 | 远程日志+本地持久化 | 本地Print输出 |
| 代码可修改 | ❌ 编译后二进制 | ✅ 开源可改 |

---

## 📝 六、代码上传区

> 将新上传的代码文件登记在此处

| 上传时间 | 文件名 | 版本 | 类型 | 来源 | 状态 |
|----------|--------|------|------|------|------|
| 2025-07-11 | - | - | - | - | - |

---

## 🗂️ 快速导航

```
/workspace/
├── Hedging_EA_项目列表.md          ← 本文件
├── Hedging_EA_v6.6.2.ex5           ← 商业版MT5
├── Hedging_EA_v6.6.2.ex4           ← 商业版MT4
├── EA_Trader.mq5                    ← 关联交易EA
└── MQL5_Codebase/
    ├── EA交易策略/
    │   ├── 其他EA/
    │   │   ├── Fusion_HedgeMonitor_EA.mq5      ← 开源主版本
    │   │   ├── Fusion_HedgeMonitor_EA0001.mq5  ← 开源变体1
    │   │   └── Fusion_HedgeMonitor_EA0002.mq5  ← 开源变体2
    │   └── 对冲策略/                            ← 对冲相关EA
    ├── 风控统计工具/                             ← 风控监控工具
    └── 文档资料/
        └── 技术文档/
            └── hedging.md                       ← 对冲技术文档
```

---

*注：上传新代码后请更新本列表的"代码上传区"和对应分类章节*