# 图表架构规范

Graphy 风格的三段式图表布局标准。所有生成的飞书白板图表均遵循此架构。

## 整体布局

```
┌─────────────────────────────────────────────────────────────┐
│ ■ Border（14px 双矩形叠加）                                    │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │  [标题区 ~12%]                                          │ │
│ │  主标题 28px/900 + 副标题 24px/400                       │ │
│ │─────────────────────────────────────────────────────────│ │
│ │  [图表区 ~65%]                                          │ │
│ │  Y轴 | Chart Plot + Widgets | 图例列                     │ │
│ │─────────────────────────────────────────────────────────│ │
│ │  [信息区 ~18%]                                          │ │
│ │  Insight 标题 + 正文 + Source                            │ │
│ └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Canvas 参数

| 参数 | 值 |
|------|------|
| 总尺寸 | 1700 x 1080 |
| viewBox | `"0 0 1700 1080"` |
| 背景色 | `#FFFFFF` |

## Border 实现

采用双矩形叠加技术（飞书不支持 14px stroke-width 的可靠渲染）：

```svg
<!-- 外层: 主色填充矩形 -->
<rect x="10" y="10" width="1680" height="1060" rx="16" fill="{border_color}"/>
<!-- 内层: 白色填充矩形 -->
<rect x="24" y="24" width="1652" height="1032" rx="10" fill="#FFFFFF"/>
```

| 参数 | 值 | 说明 |
|------|------|------|
| outer_margin | 10px | 外矩形距 canvas 边缘 |
| border_thickness | 14px | 外层与内层的差值 |
| outer rx | 16 | 外矩形圆角 |
| inner rx | 10 | 内矩形圆角 |
| border_color | 取自 THEMES.md `--border-solid-{hue}` | 跟随主题 |

关键坐标：
- 外矩形: `x=10, y=10, w=1680, h=1060`
- 内矩形: `x=24, y=24, w=1652, h=1032`

## 内容区域

内容区 = 内矩形内缩 24px padding：

| 参数 | 计算 | 值 |
|------|------|------|
| content_x | 24 + 24 | 48 |
| content_y | 24 + 24 | 48 |
| content_w | 1652 - 48 | 1604 |
| content_h | 1032 - 48 | 984 |
| content_right | 48 + 1604 | 1652 |
| content_bottom | 48 + 984 | 1032 |

## 布局策略：两端锚定 + 中间撑满

关键原则：四边留白必须均等为 24px。采用"顶部和底部固定高度，图表区撑满中间"的计算方式，避免空间堆积在底部。

```
content_y (48)
  ├── 标题区 (title_h = 实际内容高度，紧凑)
  ├── 图表区 (撑满中间所有剩余空间)
  └── 信息区 (从 content_bottom 向上倒排)
content_bottom (1032)
```

## 标题区（顶部锚定）

从 content_y 开始，高度由内容决定（紧凑排列）。

| 参数 | 计算 | 值 |
|------|------|------|
| title_y | content_y + 28 | 76（主标题基线） |
| subtitle_y | title_y + 36 | 112（副标题基线） |
| title_area_bottom | subtitle_y + 16 | 128（标题区结束） |

主标题规则：
- 一句话核心结论（非原始数据）
- 关键数字用 `fill="#7c3aed"` 高亮
- 其余文字用 `fill="#1a1a1a"`
- 需拆分为多个 `<text>` 元素实现内联变色

副标题规则：
- 补充说明（时间范围、数据来源等）
- 单色 `fill="#4d4d4d"`

## 信息区（底部锚定）

从 content_bottom 向上倒排，高度由内容决定。

| 参数 | 计算 | 说明 |
|------|------|------|
| source_y | content_bottom - 8 | Source 基线（距底边 24px 内的底部） |
| body_y | source_y - 28 | Insight 正文基线 |
| insight_title_y | body_y - 30 | Insight 标题基线 |
| info_area_top | insight_title_y - 24 | 信息区顶部（含间距） |

内容结构（从下往上倒排）：
1. Source 来源标注（最底部）
2. Insight 正文（Source 上方 28px）
3. Insight 标题（正文上方 30px）

### Insight 富文本渲染规则

Insight 区域支持通过 `<tspan>` 实现富文本样式，用于强化数据叙事效果：

| 元素类型 | 渲染方式 | 示例 |
|----------|----------|------|
| 核心结论（关键短语） | `font-weight="700"` 加粗 | "订阅服务**贡献近半营收**" |
| 重点数据（数字/百分比） | `fill="{theme_accent}"` 主题强调色 | "<tspan fill="#7c3aed">49%</tspan>" |
| 结论 + 数据组合 | 加粗 + 强调色叠加 | `font-weight="700" fill="{theme_accent}"` |

**SVG 模板：**

```svg
<!-- Insight 标题：整体加粗，关键数据用主题色 -->
<text x="{content_x}" y="{insight_title_y}" font-size="24" font-weight="700" fill="#1a1a1a">
  订阅为核心引擎，广告为<tspan fill="{theme_accent}">第二增长极</tspan>
</text>

<!-- Insight 正文：普通文字 + 加粗结论 + 彩色数据 -->
<text x="{content_x}" y="{body_y}" font-size="18" font-weight="400" fill="#4d4d4d">
  订阅服务<tspan font-weight="700">贡献</tspan><tspan font-weight="700" fill="{theme_accent}">49%</tspan><tspan font-weight="700">营收</tspan>，广告收入占比<tspan fill="{theme_accent}">22%</tspan>成为第二大来源。
</text>
```

**使用原则：**
- `theme_accent`：取自当前主题色盘的主色（如 Vivid → `#7c3aed`、Warm → `#f38650`）
- 加粗范围：仅标记核心结论短语（≤ 8 字），避免大段加粗
- 彩色标记：仅用于关键数字（金额、百分比、增长率等），每句不超过 2 处
- Insight 标题本身已是 weight 700，其中可对数据部分叠加主题色
- 不使用下划线、斜体等其他样式

## 图表区（中间撑满）

图表区占据标题区和信息区之间的全部剩余空间。

| 参数 | 计算 | 说明 |
|------|------|------|
| chart_area_y | title_area_bottom + 16 | 标题区下方 16px 间距 |
| chart_area_bottom | info_area_top - 16 | 信息区上方 16px 间距 |
| chart_area_h | chart_area_bottom - chart_area_y | 动态计算，撑满剩余 |

水平方向：

| 参数 | 计算 | 说明 |
|------|------|------|
| y_axis_space | 56px | Y 轴标签预留宽度 |
| chart_x | content_x + y_axis_space | 104 |
| legend_col_w | 按实际内容计算 | 最长图例文字宽 + swatch(12) + gap(6) + 右余量(8) |
| chart_w | content_right - chart_x - legend_col_w - 14 | 图表填满到图例列左侧 |
| legend_x | content_right - legend_col_w | 图例列右对齐到 content_right |

图例列宽度计算规则：
- 计算所有图例文字中最长的一条：`max_text_w = max(字数) * 11`
- `legend_col_w = 12(swatch) + 6(gap) + max_text_w + 8(右余量)`
- 典型值：2 字中文 → 50px；4 字中文 → 72px；6 字中文 → 94px

图表绘制区域 (plot area)：
- 左边界: chart_x
- 右边界: chart_x + chart_w
- 上边界: chart_area_y + 60 (为 Widget 预留 ~60px)
- 下边界: chart_area_bottom - 36 (X 轴标签空间)

## 字体层级

| 元素 | font-size | font-weight | fill |
|------|-----------|-------------|------|
| 主标题 | 28 | 900 | #1a1a1a（数字用 #7c3aed） |
| 副标题 | 24 | 400 | #4d4d4d |
| X 轴标签 | 14 | 600 | #1a1a1a |
| Y 轴刻度 | 11 | 400 | #808080 |
| 柱内数据标签 | 12 | 500 | #FFFFFF |
| 图例文字 | 11 | 400 | #4d4d4d |
| Insight 标题 | 24 | 700 | #1a1a1a |
| Insight 正文 | 18 | 400 | #4d4d4d |
| Source | 14 | 400 | #808080 |

## SVG 元素书写顺序

从底到顶（后写的在上层）：

1. 背景白色 rect（如需要）
2. Border 外矩形
3. Border 内矩形
4. 网格线（水平线 + 基线）
5. 柱子 / 折线等图表主体
6. 数据标签（柱内文字）
7. X 轴标签、Y 轴标签
8. AverageLine / GoalLine 虚线
9. Widget: DifferenceArrow（线段 + 胶囊）
10. Widget: Comment / PinNumber / Sticker（最高层级，覆盖 DifferenceArrow 线段）
11. 标题区文字
12. 信息区文字
13. 图例

层级原则：气泡类 Widget（Comment / PinNumber / Sticker）层级最高，始终显示在 DifferenceArrow 线段之上。

## 间距速查

| 间距项 | 值 |
|--------|------|
| Border 到 canvas 边缘 | 10px |
| Border 厚度 | 14px |
| 四边 padding（border 内缘到内容） | 24px（必须四边等距） |
| 主标题 → 副标题 | 36px |
| 标题区 → 图表区间距 | 16px |
| 图表区顶部 Widget 预留 | 60px |
| X 轴标签距基线 | 22px |
| 图例行间距 | 20px |
| 图表区 → 信息区间距 | 16px |
| Insight 标题 → 正文 | 30px |
| 正文 → Source | 28px |
| 图例列到 content_right | 0px（右对齐） |
