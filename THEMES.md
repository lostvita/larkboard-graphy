# 主题色盘系统

色盘分为两层：Framework 层（固定）和 Chart 层（用户可选）。

## Framework 层（不随主题变化）

用于布局框架、文字、网格线等固定元素。

| Token | 值 | 用途 |
|-------|------|------|
| --bg-canvas | #FFFFFF | 画布 / 内矩形填充 |
| --text-primary | #1a1a1a | 主标题、X 轴标签 |
| --text-secondary | #4d4d4d | 副标题、Insight 正文、图例文字 |
| --text-tertiary | #808080 | Y 轴刻度、Source |
| --color-primary | #7c3aed | 标题区关键数字高亮 |
| --icon-primary | #333333 | Widget 气泡/胶囊默认背景 |
| --grid-line | #1a1a1a, opacity 0.09 | 网格线 |
| --grid-baseline | #1a1a1a, opacity 0.15 | 基线 |

## Chart 层（用户选择）

### Monochrome — 单色渐变系列

9 套色盘，每套 8 个从深到浅的梯度色：

#### blue
```
#1e3a8a  #1e40af  #1d4ed8  #2563eb  #3b82f6  #60a5fa  #93c5fd  #bfdbfe
```

#### cyan
```
#164e63  #155e75  #0e7490  #0891b2  #06b6d4  #22d3ee  #67e8f9  #a5f3fc
```

#### green
```
#064e3b  #065f46  #047857  #059669  #10b981  #34d399  #6ee7b7  #a7f3d0
```

#### yellow
```
#553b0c  #6f4b08  #8d6300  #bd8a00  #e5b400  #ffc800  #fbda2b  #feed72
```

#### orange
```
#7c2d12  #9a3412  #c2410c  #ea580c  #f97316  #fb923c  #fdba74  #fed7aa
```

#### red
```
#7f1d1d  #991b1b  #b91c1c  #dc2626  #ef4444  #f87171  #fca5a5  #fecaca
```

#### pink
```
#751a5e  #8f1972  #af1c8a  #d326a8  #e845bf  #f979d9  #fcabe8  #fed0f3
```

#### purple
```
#4c1d95  #5b21b6  #6d28d9  #7c3aed  #8b5cf6  #a78bfa  #c4b5fd  #ddd6fe
```

#### grey
```
#1c1917  #292524  #44403c  #57534e  #78716c  #a8a29e  #d6d3d1  #e7e5e4
```

### Colorful — 多彩系列

#### Pastel（柔和）
```
#b2ddc9  #b2a4ff  #ffadad  #a2d5e2  #ffccd3  #aac4ff  #ffdeb4  #dca8c7  #fdf7c3
```

#### Vivid（鲜艳）
```
#b399fd  #fc8497  #fbbc30  #279eff  #e83562  #40f8ff  #f38650  #c82184  #31fcb4  #6d48d2
```

## Border 颜色映射

飞书 SVG 不支持 rgba，以下为各色系 border 的近似 hex 值（原 rgba 50% 透明度混合白色后的结果）：

| 色系 | 原始 rgba | 近似 hex（用于 SVG） |
|------|-----------|---------------------|
| blue | rgba(59, 130, 246, 0.5) | #9dc1fb |
| cyan | rgba(6, 182, 212, 0.5) | #83dbed |
| green | rgba(16, 185, 129, 0.5) | #88dcc0 |
| yellow | rgba(229, 180, 0, 0.5) | #f2da80 |
| orange | rgba(249, 115, 22, 0.5) | #fcb98b |
| red | rgba(239, 68, 68, 0.5) | #f7a2a2 |
| pink | rgba(232, 69, 191, 0.5) | #f4a2df |
| purple | rgba(139, 92, 246, 0.5) | #c5aefb |
| grey | rgba(120, 113, 108, 0.5) | #bcb8b6 |

Colorful 色盘的 border 默认使用 purple（#c5aefb）。

## 色彩分配策略

### 系列颜色

从选定色盘取前 N 个色（N = 数据系列数）：

- **Monochrome**: 取梯度色中等间距的 N 个色
  - 1 系列: 取 index 3（中偏深）
  - 2 系列: 取 index 1, 4
  - 3 系列: 取 index 1, 3, 5
  - 4 系列: 取 index 0, 2, 4, 6
  - 5+ 系列: 均匀取样

- **Colorful**: 按顺序取前 N 个色
  - Pastel: #b2ddc9, #b2a4ff, #ffadad, ...
  - Vivid: #b399fd, #fc8497, #fbbc30, ...

### Widget 颜色

| Widget | 颜色来源 |
|--------|----------|
| Comment / PinNumber 气泡 | 固定 #333333 |
| PinNumber swatch | 跟随系列色 |
| DifferenceArrow 连线 + 箭头 | 色盘中段高饱和色（如 Vivid: #f38650） |
| DifferenceArrow 胶囊描边 | 同连线色 |
| AverageLine 虚线 | 色盘中未被系列占用的色 |
| GoalLine 虚线 | 色盘中另一未用色 |
| AverageLine / GoalLine 胶囊 | 固定 #333333 |
| HighlightLabel 文字 | 跟随系列色 |
| Sticker | 无色（emoji 原色） |

### 推荐策略

Agent 根据数据推荐主题时的选择逻辑：

| 条件 | 推荐 |
|------|------|
| 单系列 | Monochrome（推荐 blue / purple / green） |
| 2~3 系列 | Monochrome 或 Colorful Pastel |
| 4+ 系列 | Colorful Vivid |
| 用户指定色系 | 直接使用对应色盘 |
