# larkboard-graphy

[![Claude Skill](https://img.shields.io/badge/Claude-AI%20Skill-orange)](https://docs.anthropic.com)
[![Cursor Skill](https://img.shields.io/badge/Cursor-AI%20Skill-blue)](https://cursor.sh)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

> AI 驱动的飞书白板数据叙事 —— 不只是图表，而是叙事。

[English](./README.md)

## 什么是 larkboard-graphy？

**larkboard-graphy** 是一个 AI Agent Skill，能生成完全可编辑的飞书白板数据图表，内置数据叙事能力。它在原始数据与有说服力的视觉叙事之间架起桥梁。

### 设计思想

- **叙事优先** —— 每张图表都是一个故事。Widget（注释、趋势线、高亮）是一等公民，不是事后添加。Skill 在绘制任何元素前就分析数据并提出叙事策略。
- **可编辑，非静态** —— 与截图式图表工具不同，每个元素（形状、文字、连线）都以飞书白板原生对象落地。团队可以在生成后直接移动、缩放、改色、扩展。
- **约束驱动渲染** —— 基于反复验证的飞书 SVG 白板渲染器能力边界（仅原生形状、无渐变、无 foreignObject、有限 opacity 支持）。`RULES.md` 中的每条规则都经过实机验证。
- **三段式架构** —— 每张图表遵循统一布局：标题区（结论先行的标题）、图表区（数据 + Widget）、信息区（洞察叙事 + 来源）。确保每张图表讲述完整故事。

### 与传统图表的差异

| | 传统图表工具 | larkboard-graphy |
|--|-------------|------------------|
| 输出形式 | 静态图片 / iframe | 可编辑的原生白板形状 |
| 数据叙事 | 导出后手动标注 | AI 生成时就内置 Widget |
| 协作 | 只能查看或重新导出 | 团队直接在飞书上编辑 |
| 设计体系 | 通用默认样式 | Graphy 专属字体、间距、色彩系统 |

## 效果预览

| 分组柱状图 | 柱状图 + 趋势线 | 水平条形图 | 多系列折线图 |
|:--:|:--:|:--:|:--:|
| ![column-grouped](./assets/column-grouped.png) | ![column-trendline](./assets/column-trendline.png) | ![bar-horizontal](./assets/bar-horizontal.png) | ![line-multi-series](./assets/line-multi-series.png) |

| 环形图 + Widget | 堆叠柱状图 | 柱线组合图 | 百分比堆叠条形图 |
|:--:|:--:|:--:|:--:|
| ![donut-widgets](./assets/donut-widgets.png) | ![column-stacked](./assets/column-stacked.png) | ![combo-bar-line](./assets/combo-bar-line.png) | ![bar-100-stacked](./assets/bar-100-stacked.png) |

| 漏斗图 |
|:--:|
| ![funnel](./assets/funnel.png) |

## 支持图表类型

| 类型 | 说明 |
|------|------|
| Column | 垂直柱状图（分组） |
| Column Stacked | 垂直堆叠柱状图（绝对值） |
| Column 100% Stacked | 垂直百分比堆叠柱状图 |
| Bar | 水平条形图 |
| Bar Stacked | 水平堆叠条形图（绝对值） |
| Bar 100% Stacked | 水平百分比堆叠条形图 |
| Line | 折线图 |
| Pie | 饼图（实心圆） |
| Donut | 环形图（可含中心标签） |
| Combo | 柱线组合图 |
| Funnel | 漏斗图（单系列柱 + 连接斜面） |

## Widget 体系

Widget 是数据叙事层 —— 将普通图表转化为带有观点的叙事。

| Widget | 含义 | 使用场景 |
|--------|------|----------|
| **Comment** | 文字注释，解释数据背后的原因 | 标注因果关系、背景信息或定性洞察（如"新政策上线"） |
| **PinNumber** | 精确数值标注，强调关键指标 | 突出特定 KPI 或里程碑数字 |
| **Sticker** | Emoji 情感标记，传达情绪/趋势方向 | 一眼传达趋势感受（🚀 增长、⚠️ 警告） |
| **DifferenceArrow** | 数据对比箭头，量化差距 | 展示两个数据点之间的精确差值（如"+12亿差距"） |
| **AverageLine** | 均值参考线，横跨图表 | 建立对比基准线 |
| **GoalLine** | 目标参考线，标注目标/KPI | 标记业务目标或基准值 |
| **TrendLine** | 线性回归趋势线 | 揭示数据整体走向（当个别点噪声较大时） |
| **Highlight** | 聚焦高亮，非高亮元素弱化至 0.3 | 在复杂图表中聚焦注意力到特定柱子/分组/系列/折线 |
| **HighlightLabel** | 选择性数值标注 | Data Label 关闭时，仅在关键数据点显示数值 |

## 主题色盘

### Monochrome 单色渐变（9 套，每套 8 色）

<!-- 色值来源：graphy/src/components/AsideSetting/Design/PresetSection/config.ts -->

**blue**<br>
![#1e3a8a](https://readme-swatches.vercel.app/1e3a8a?style=round)![#1e40af](https://readme-swatches.vercel.app/1e40af?style=round)![#1d4ed8](https://readme-swatches.vercel.app/1d4ed8?style=round)![#2563eb](https://readme-swatches.vercel.app/2563eb?style=round)![#3b82f6](https://readme-swatches.vercel.app/3b82f6?style=round)![#60a5fa](https://readme-swatches.vercel.app/60a5fa?style=round)![#93c5fd](https://readme-swatches.vercel.app/93c5fd?style=round)![#bfdbfe](https://readme-swatches.vercel.app/bfdbfe?style=round)

**cyan**<br>
![#164e63](https://readme-swatches.vercel.app/164e63?style=round)![#155e75](https://readme-swatches.vercel.app/155e75?style=round)![#0e7490](https://readme-swatches.vercel.app/0e7490?style=round)![#0891b2](https://readme-swatches.vercel.app/0891b2?style=round)![#06b6d4](https://readme-swatches.vercel.app/06b6d4?style=round)![#22d3ee](https://readme-swatches.vercel.app/22d3ee?style=round)![#67e8f9](https://readme-swatches.vercel.app/67e8f9?style=round)![#a5f3fc](https://readme-swatches.vercel.app/a5f3fc?style=round)

**green**<br>
![#064e3b](https://readme-swatches.vercel.app/064e3b?style=round)![#065f46](https://readme-swatches.vercel.app/065f46?style=round)![#047857](https://readme-swatches.vercel.app/047857?style=round)![#059669](https://readme-swatches.vercel.app/059669?style=round)![#10b981](https://readme-swatches.vercel.app/10b981?style=round)![#34d399](https://readme-swatches.vercel.app/34d399?style=round)![#6ee7b7](https://readme-swatches.vercel.app/6ee7b7?style=round)![#a7f3d0](https://readme-swatches.vercel.app/a7f3d0?style=round)

**yellow**<br>
![#553b0c](https://readme-swatches.vercel.app/553b0c?style=round)![#6f4b08](https://readme-swatches.vercel.app/6f4b08?style=round)![#8d6300](https://readme-swatches.vercel.app/8d6300?style=round)![#bd8a00](https://readme-swatches.vercel.app/bd8a00?style=round)![#e5b400](https://readme-swatches.vercel.app/e5b400?style=round)![#ffc800](https://readme-swatches.vercel.app/ffc800?style=round)![#fbda2b](https://readme-swatches.vercel.app/fbda2b?style=round)![#feed72](https://readme-swatches.vercel.app/feed72?style=round)

**orange**<br>
![#7c2d12](https://readme-swatches.vercel.app/7c2d12?style=round)![#9a3412](https://readme-swatches.vercel.app/9a3412?style=round)![#c2410c](https://readme-swatches.vercel.app/c2410c?style=round)![#ea580c](https://readme-swatches.vercel.app/ea580c?style=round)![#f97316](https://readme-swatches.vercel.app/f97316?style=round)![#fb923c](https://readme-swatches.vercel.app/fb923c?style=round)![#fdba74](https://readme-swatches.vercel.app/fdba74?style=round)![#fed7aa](https://readme-swatches.vercel.app/fed7aa?style=round)

**red**<br>
![#7f1d1d](https://readme-swatches.vercel.app/7f1d1d?style=round)![#991b1b](https://readme-swatches.vercel.app/991b1b?style=round)![#b91c1c](https://readme-swatches.vercel.app/b91c1c?style=round)![#dc2626](https://readme-swatches.vercel.app/dc2626?style=round)![#ef4444](https://readme-swatches.vercel.app/ef4444?style=round)![#f87171](https://readme-swatches.vercel.app/f87171?style=round)![#fca5a5](https://readme-swatches.vercel.app/fca5a5?style=round)![#fecaca](https://readme-swatches.vercel.app/fecaca?style=round)

**pink**<br>
![#751a5e](https://readme-swatches.vercel.app/751a5e?style=round)![#8f1972](https://readme-swatches.vercel.app/8f1972?style=round)![#af1c8a](https://readme-swatches.vercel.app/af1c8a?style=round)![#d326a8](https://readme-swatches.vercel.app/d326a8?style=round)![#e845bf](https://readme-swatches.vercel.app/e845bf?style=round)![#f979d9](https://readme-swatches.vercel.app/f979d9?style=round)![#fcabe8](https://readme-swatches.vercel.app/fcabe8?style=round)![#fed0f3](https://readme-swatches.vercel.app/fed0f3?style=round)

**purple**<br>
![#4c1d95](https://readme-swatches.vercel.app/4c1d95?style=round)![#5b21b6](https://readme-swatches.vercel.app/5b21b6?style=round)![#6d28d9](https://readme-swatches.vercel.app/6d28d9?style=round)![#7c3aed](https://readme-swatches.vercel.app/7c3aed?style=round)![#8b5cf6](https://readme-swatches.vercel.app/8b5cf6?style=round)![#a78bfa](https://readme-swatches.vercel.app/a78bfa?style=round)![#c4b5fd](https://readme-swatches.vercel.app/c4b5fd?style=round)![#ddd6fe](https://readme-swatches.vercel.app/ddd6fe?style=round)

**grey**<br>
![#1c1917](https://readme-swatches.vercel.app/1c1917?style=round)![#292524](https://readme-swatches.vercel.app/292524?style=round)![#44403c](https://readme-swatches.vercel.app/44403c?style=round)![#57534e](https://readme-swatches.vercel.app/57534e?style=round)![#78716c](https://readme-swatches.vercel.app/78716c?style=round)![#a8a29e](https://readme-swatches.vercel.app/a8a29e?style=round)![#d6d3d1](https://readme-swatches.vercel.app/d6d3d1?style=round)![#e7e5e4](https://readme-swatches.vercel.app/e7e5e4?style=round)

### Colorful 多彩系列

**Pastel（柔和）**<br>
![#b2ddc9](https://readme-swatches.vercel.app/b2ddc9?style=round)![#b2a4ff](https://readme-swatches.vercel.app/b2a4ff?style=round)![#ffadad](https://readme-swatches.vercel.app/ffadad?style=round)![#a2d5e2](https://readme-swatches.vercel.app/a2d5e2?style=round)![#ffccd3](https://readme-swatches.vercel.app/ffccd3?style=round)![#aac4ff](https://readme-swatches.vercel.app/aac4ff?style=round)![#ffdeb4](https://readme-swatches.vercel.app/ffdeb4?style=round)![#dca8c7](https://readme-swatches.vercel.app/dca8c7?style=round)![#fdf7c3](https://readme-swatches.vercel.app/fdf7c3?style=round)

**Vivid（鲜艳）**<br>
![#b399fd](https://readme-swatches.vercel.app/b399fd?style=round)![#fc8497](https://readme-swatches.vercel.app/fc8497?style=round)![#fbbc30](https://readme-swatches.vercel.app/fbbc30?style=round)![#279eff](https://readme-swatches.vercel.app/279eff?style=round)![#e83562](https://readme-swatches.vercel.app/e83562?style=round)![#40f8ff](https://readme-swatches.vercel.app/40f8ff?style=round)![#f38650](https://readme-swatches.vercel.app/f38650?style=round)![#c82184](https://readme-swatches.vercel.app/c82184?style=round)![#31fcb4](https://readme-swatches.vercel.app/31fcb4?style=round)![#6d48d2](https://readme-swatches.vercel.app/6d48d2?style=round)

## 工作原理

```
┌─────────────────────────────────────────────────────────────────┐
│  1. 数据输入                                                     │
│     用户提供数据（表格 / JSON / 文本描述）                          │
│                          ↓                                      │
│  2. 图表类型选择                                                  │
│     Agent 根据数据特征推荐图表类型                                  │
│                          ↓                                      │
│  3. 主题色盘选择                                                  │
│     用户选择 Monochrome 或 Colorful 色盘                          │
│                          ↓                                      │
│  4. 叙事分析                                                     │
│     Agent 识别关键洞察，提出 Widget 方案                            │
│    （标注哪些数据点、高亮哪些区域、对比什么）                         │
│                          ↓                                      │
│  5. SVG 生成                                                     │
│     按飞书白板渲染规则构建完整 SVG                                  │
│    （仅原生形状，无渐变，无 foreignObject）                         │
│                          ↓                                      │
│  6. 校验                                                         │
│     whiteboard-cli --check 验证文字溢出、节点重叠                   │
│     检测到错误时自动修复（最多 3 轮）                                │
│                          ↓                                      │
│  7. 发布到飞书                                                    │
│     lark-cli 创建文档 → 写入 SVG 白板内容                          │
│     返回可分享的飞书文档链接                                        │
└─────────────────────────────────────────────────────────────────┘
```

生成的白板在飞书中**完全可编辑** —— 每个形状、文字、连线都可以手动移动、缩放或改色。

## 前置依赖

- **Node.js** >= 18
- **飞书 / Lark 账号** — 白板写入你自己的租户
- **`lark-cli`**（`@larksuite/cli`），已安装并认证：
  ```bash
  npm install -g @larksuite/cli
  lark-cli auth login --as user
  ```
- **`@larksuite/whiteboard-cli`** — 通过 npx 使用，自动下载无需安装

## 安装

**告诉你的 Agent**（Cursor、Claude Code 等）：

> "安装 **larkboard-graphy** skill，来自 `github.com/user/larkboard-graphy`。"

或手动安装（克隆到 Agent 的 skills 目录）：

```bash
# Cursor skills 目录
git clone https://github.com/user/larkboard-graphy \
  ~/.cursor/skills/larkboard-graphy

# 或 Claude Code skills 目录
git clone https://github.com/user/larkboard-graphy \
  ~/.claude/skills/larkboard-graphy
```

然后运行环境检查：

```bash
bash scripts/preflight.sh
```

## 快速开始

在 Cursor 中使用以下触发词唤起 Skill：

- `"生成飞书图表白板"`
- `"larkboard graphy"`
- `"数据图表白板"`
- `"graphy 白板"`
- `"飞书数据故事"`

交互流程：

1. **提供数据** — 粘贴表格、JSON 或用自然语言描述数据
2. **确认图表类型** — Agent 根据数据特征推荐
3. **选择主题** — 从 Monochrome 或 Colorful 色盘中选择
4. **审核叙事方案** — Agent 提出 Widget 策略及理由
5. **获取链接** — 返回完全可编辑的飞书白板 URL

### 使用示例

```
/larkboard-graphy 背景：2025年新能源车三巨头（比亚迪、理想、小米）季度营收对比，比亚迪全年领跑Q4达1280亿创新高，理想稳步增长，小米Q2入局后快速爬坡。数据：
季度	比亚迪(亿元)	理想(亿元)	小米(亿元)
Q1	980	450	0
Q2	1100	520	180
Q3	1180	580	350
Q4	1280	620	520
```

## Roadmap

- [ ] 瀑布图（Waterfall）支持
- [ ] 散点图 / 气泡图
- [ ] 水平时间轴图

## 协议

[MIT](./LICENSE)
