# Widget 类型与样式结构

数据叙事 Widget 为图表增加故事性。每种 Widget 有固定的 SVG 结构模板和定位规则。

## 默认配色规则

气泡类 Widget（Comment / PinNumber）和胶囊标签（AverageLine / GoalLine）的背景色固定为 `#333333`，不跟随主题色盘变化。用户可通过指令覆盖此颜色。

| 部件 | 默认色 | 跟随主题 |
|------|--------|----------|
| Comment 气泡背景 | #333333 | 否 |
| Comment 三角尾 | #333333 | 否 |
| PinNumber 气泡背景 | #333333 | 否 |
| PinNumber 三角尾 | #333333 | 否 |
| PinNumber swatch 色块 | {series_color} | 是 |
| AverageLine 胶囊背景 | #333333 | 否 |
| GoalLine 胶囊背景 | #333333 | 否 |
| DifferenceArrow 连线 | {palette_accent} | 是 |
| DifferenceArrow 胶囊 | #FFFFFF (描边色跟随) | 是 |

---

## Comment — 事件注释气泡

标注某个数据点发生的事件或现象。

### 结构

```
        ┌──────────────────────┐
        │  文字内容 (白色11px)   │  ← 气泡 rect
        └──────────────────────┘
                  ▽                ← 三角尾 polygon
                  │ 5px
            ─── 锚定点 ───
```

### SVG 模板

```svg
<!-- 气泡矩形 -->
<rect x="{cx - w/2}" y="{bubble_y}" width="{w}" height="28" rx="6" fill="#333333"/>
<!-- 文字 -->
<text x="{cx}" y="{bubble_y + 18}" text-anchor="middle" font-size="11" font-weight="500" fill="#FFFFFF">{content}</text>
<!-- 三角尾 -->
<polygon points="{cx},{tail_tip_y} {cx-6},{tail_base_y} {cx+6},{tail_base_y}" fill="#333333"/>
```

### 参数

| 参数 | 值 | 计算方式 |
|------|------|----------|
| 气泡高度 | 28px | 固定（单行） |
| 气泡宽度 w | 动态 | 中文: 字数 x 14 + 24; 英文: 字数 x 8 + 24 |
| 三角尾底边 | 12px | 固定 |
| 三角尾高度 | 8px | 固定 |
| tail_tip_y | anchor_y - 5 | 尖端距锚定点 5px（Pie/Donut 为 anchor_y） |
| tail_base_y | tail_tip_y - 8 | 三角顶边 |
| bubble_y | tail_base_y | 胶囊底边 = 三角顶边（完全贴合，无间隙） |
| cx | 锚定点 x | 柱子中心 / 节点 x |

---

## PinNumber — 数值标注气泡

标注某个关键数值，带系列色块标识。

### 结构

```
        ┌─────────────────┐
        │ ■ 65亿          │  ← 气泡 rect + swatch + text
        └─────────────────┘
                 ▽            ← 三角尾
            ─── 锚定点 ───
```

### SVG 模板

```svg
<!-- 气泡矩形 -->
<rect x="{cx - w/2}" y="{bubble_y}" width="{w}" height="28" rx="6" fill="#333333"/>
<!-- 系列色块 (swatch) -->
<rect x="{cx - w/2 + 10}" y="{bubble_y + 8}" width="12" height="12" rx="3" fill="{series_color}"/>
<!-- 数值文字 -->
<text x="{cx - w/2 + 28}" y="{bubble_y + 18}" font-size="12" font-weight="500" fill="#FFFFFF">{value}</text>
<!-- 三角尾 -->
<polygon points="{cx},{tail_tip_y} {cx-6},{tail_base_y} {cx+6},{tail_base_y}" fill="#333333"/>
```

### 参数

| 参数 | 值 | 说明 |
|------|------|------|
| swatch 位置 | 气泡左侧内边距 10px | |
| swatch 尺寸 | 12x12, rx=3 | |
| swatch 颜色 | {series_color} | 跟随该数据点所属系列 |
| 文字起始 x | swatch 右侧 + 6px | cx - w/2 + 28 |
| 气泡宽度 w | 动态 | swatch(12) + gap(6) + 文字宽 + padding(20) + 左padding(10) |
| 定位规则 | 与 Comment 完全相同 | |

---

## Sticker — 装饰贴纸

用 emoji 标记数据点的情绪/成就。

### 结构

```
           🚀
          │ 5px
      ─── 锚定点 ───
```

### SVG 模板

```svg
<text x="{cx}" y="{anchor_y - 5}" text-anchor="middle" font-size="22">{emoji}</text>
```

### 支持列表

| id | emoji | 叙事用途 |
|----|-------|----------|
| clappingHands | 👏 | 值得认可的成绩 |
| grinningFace | 😄 | 积极正面趋势 |
| thumbsUp | 👍 | 达标 / 超预期 |
| thumbsDown | 👎 | 未达标 / 下滑 |
| rocket | 🚀 | 爆发式增长 |

### 参数

| 参数 | 值 |
|------|------|
| font-size | 22 |
| 距锚定点 | 5px（emoji 底边到锚定点） |
| 对齐 | text-anchor="middle", x = cx |
| 背景 | 无 |
| 受主题影响 | 否 |

---

## DifferenceArrow — 差值对比箭头

标注两个数据点之间的差值或变化百分比。L 型连接线结构。

### 方向语义

A → B 表示"从 A 的值变化到 B 的值"，箭头（marker-end）始终在 B 端。

差值计算：`label = B值 - A值`，保留正负号。

| 对比方向 | 计算 | 标签 |
|----------|------|------|
| 问界(13w) → 理想(19w) | 19 - 13 | +6万 |
| 理想(19w) → 问界(13w) | 13 - 19 | -6万 |

叙事决定方向：
- 突出"谁更强" → 箭头指向强者，标签为正值（如 "+6万"）
- 突出"谁落后" → 箭头指向弱者，标签为负值（如 "-6万"）

### Column 图表结构

```
                    ┌────────┐
                    │ +6万   │  ← 胶囊标签 (白底 + 彩色描边)
                    └────────┘
      │─────────────────────────│
      │                         ↓   ← marker-end 箭头指向 B
      │                    ─── 锚定点B ───
 ─── 锚定点A ───
```

三段线结构（垂直→水平→垂直）：
1. 垂直段: 从锚定点 A 向上到 connector_y
2. 水平段: 从 A 的 x 横向连接到 B 的 x
3. 垂直段: 从 connector_y 向下到锚定点 B，带 marker-end 箭头

胶囊标签居中于水平段。

### Column SVG 模板

```svg
<!-- 箭头 marker 定义（放在 <defs> 中） -->
<defs>
  <marker id="arrow-diff" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
    <polygon points="0,0 10,3.5 0,7" fill="{arrow_color}"/>
  </marker>
</defs>

<!-- 垂直段: A 向上 -->
<line x1="{ax}" y1="{a_anchor - 5}" x2="{ax}" y2="{connector_y}"
  stroke="{arrow_color}" stroke-width="2"/>
<!-- 水平段 -->
<line x1="{ax}" y1="{connector_y}" x2="{bx}" y2="{connector_y}"
  stroke="{arrow_color}" stroke-width="2"/>
<!-- 垂直段: 向下到 B，带箭头 -->
<line x1="{bx}" y1="{connector_y}" x2="{bx}" y2="{b_anchor - 5}"
  stroke="{arrow_color}" stroke-width="2" marker-end="url(#arrow-diff)"/>

<!-- 胶囊标签: 居中于水平段 -->
<rect x="{mid_x - pill_w/2}" y="{connector_y - 10}" width="{pill_w}" height="20" rx="4"
  fill="#FFFFFF" stroke="{arrow_color}" stroke-width="1.5"/>
<text x="{mid_x}" y="{connector_y + 4}" text-anchor="middle"
  font-size="12" font-weight="600" fill="#1a1a1a">{label}</text>
```

### Bar 图表结构

```
 ─── 锚定点A ───
                   │
                   │─────────── ┌────────┐
                   │            │ -6万   │  ← 胶囊标签
                   │─────────── └────────┘
                   │
              ─── 锚定点B ─── ←  marker-end 箭头指向 B
```

三段线结构（水平→垂直→水平），相对 Column 旋转 90°：
1. 水平段: 从锚定点 A 向右到 connector_x
2. 垂直段: 从 A 的 y 纵向连接到 B 的 y
3. 水平段: 从 connector_x 向左到锚定点 B，带 marker-end 箭头

胶囊标签居中于垂直段。

### Bar SVG 模板

```svg
<!-- 箭头 marker 定义（放在 <defs> 中） -->
<defs>
  <marker id="arrow-diff" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
    <polygon points="0,0 10,3.5 0,7" fill="{arrow_color}"/>
  </marker>
</defs>

<!-- 水平段: A 向右 -->
<line x1="{a_anchor + 5}" y1="{ay}" x2="{connector_x}" y2="{ay}"
  stroke="{arrow_color}" stroke-width="2"/>
<!-- 垂直段 -->
<line x1="{connector_x}" y1="{ay}" x2="{connector_x}" y2="{by}"
  stroke="{arrow_color}" stroke-width="2"/>
<!-- 水平段: 向左到 B，带箭头 -->
<line x1="{connector_x}" y1="{by}" x2="{b_anchor + 5}" y2="{by}"
  stroke="{arrow_color}" stroke-width="2" marker-end="url(#arrow-diff)"/>

<!-- 胶囊标签: 居中于垂直段 -->
<rect x="{connector_x - pill_w/2}" y="{mid_y - 10}" width="{pill_w}" height="20" rx="4"
  fill="#FFFFFF" stroke="{arrow_color}" stroke-width="1.5"/>
<text x="{connector_x}" y="{mid_y + 4}" text-anchor="middle"
  font-size="12" font-weight="600" fill="#1a1a1a">{label}</text>
```

### 参数

| 参数 | 值 | 说明 |
|------|------|------|
| connector_y (Column) | chart_plot_y - 10 | 位于图表绘制区最上方（高于所有气泡 Widget） |
| connector_x (Bar) | chart_plot_right + 10 | 位于图表绘制区最右侧（超出所有条形末端） |
| arrow_color | 主题色盘高饱和色 | 如 Vivid #f38650，可用户覆盖 |
| 胶囊高度 | 20px | |
| 胶囊宽度 pill_w | 动态 | 文字宽 + 20px |
| 胶囊圆角 | rx=4 | |
| 胶囊填充 | #FFFFFF | 白底 |
| 胶囊描边 | arrow_color, 1.5px | |
| 线宽 | 2px | |
| mid_x (Column) | (ax + bx) / 2 | 水平段中点 |
| mid_y (Bar) | (ay + by) / 2 | 垂直段中点 |

### 碰撞避让规则

DifferenceArrow 是唯一可调节路径的 Widget。Comment / PinNumber / Sticker 位置固定（贴近锚定点），优先级最高，不可移动。当 DifferenceArrow 与固定 Widget 发生遮挡时，通过延长连接线段来避让。

**核心原则：**
- 固定 Widget（Comment / PinNumber / Sticker）不可偏移，且层级最高（SVG 书写顺序在 DifferenceArrow 之后）
- DifferenceArrow 为柔性 Widget，路径可延长，层级低于气泡类 Widget
- 即使线段穿过气泡区域，气泡仍覆盖在线段之上（通过 SVG 元素顺序保证）
- AverageLine / GoalLine 为全局参考线，不参与碰撞计算

**Column 图避让：**

默认 `connector_y = plot_top - 10`。生成时检查所有固定 Widget 的气泡顶部坐标：

```
connector_y = min(所有固定Widget的bubble_y) - 36
```

水平连接线始终在所有气泡 Widget 上方 36px 处，确保不遮挡。

**Bar 图避让：**

默认 `connector_x = max(bar_right_a, bar_right_b) + 40`。生成时检查路径上的 Comment / PinNumber 气泡右边缘：

```
connector_x = max(所有冲突Widget的bubble_right_edge) + 36
```

垂直连接线始终在冲突气泡右侧 36px 处。

**胶囊标签避让：**

胶囊居中于连接线中段。延长线段后：
- Column: connector_y 已上移至所有气泡之上，胶囊通常不再冲突
- Bar: 胶囊在垂直段中间，若仍冲突则沿垂直段方向偏移至无重叠位置（`mid_y += offset` 直至不重叠）

**计算伪代码：**

```python
# Column 图
fixed_widgets_top = [w.bubble_y for w in widgets if w.type in ('Comment', 'PinNumber', 'Sticker')]
if fixed_widgets_top:
    connector_y = min(fixed_widgets_top) - 36
else:
    connector_y = plot_top - 10

# Bar 图
fixed_widgets_right = [w.bubble_x + w.bubble_w for w in widgets if w.type in ('Comment', 'PinNumber')]
if fixed_widgets_right:
    connector_x = max(fixed_widgets_right) + 36
else:
    connector_x = max(bar_right_a, bar_right_b) + 40
```

---

## AverageLine — 均值参考线

横跨图表的水平虚线 + 右侧胶囊标签，标注均值。

### 结构

```
  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  ┌──────────────┐
                                     │ 三品牌均值 46 │  ← 胶囊 (fill #333333)
                                     └──────────────┘
```

### SVG 模板

```svg
<!-- 虚线 -->
<line x1="{chart_x}" y1="{avg_y}" x2="{chart_x + chart_w}" y2="{avg_y}"
  stroke="{line_color}" stroke-width="1" stroke-dasharray="3 4"/>
<!-- 胶囊标签（右对齐，不超出 content_right） -->
<rect x="{pill_x}" y="{avg_y - 10}" width="{pill_w}" height="20" rx="4" fill="#333333"/>
<text x="{pill_x + pill_w/2}" y="{avg_y + 4}" text-anchor="middle"
  font-size="10" font-weight="500" fill="#FFFFFF">{label}</text>
```

### 参数

| 参数 | 值 | 说明 |
|------|------|------|
| 虚线样式 | stroke-dasharray="3 4" | |
| line_color | 主题色盘取色 | 区别于系列色和箭头色 |
| pill_w | 动态 | 文字宽 + 16px |
| pill_x | `content_right - pill_w` | 右对齐到 content_right，确保不超出 border |
| 胶囊背景 | #333333 | 固定，不跟随主题 |
| 胶囊文字 | #FFFFFF | |

### 边界约束

胶囊标签必须在 content_right 内：`pill_x + pill_w <= content_right`。
计算方式：`pill_x = content_right - pill_w`（右端对齐内容区右边界）。

### 文案规则

标签文案必须说明"什么的均值"，避免歧义：
- 正确: "三品牌均值 46亿"、"全年月均 12万"
- 错误: "均值"、"平均线"（不清楚是哪些数据的均值）

---

## GoalLine — 目标参考线

结构与 AverageLine 相同：横跨图表的水平虚线 + 右侧胶囊标签，标注目标值/参考值。

### 结构

```
Column / Line 类（水平方向）：
  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  ┌──────────────┐
                                     │ 目标值 50    │  ← 胶囊 (右端对齐 content_right)
                                     └──────────────┘

Bar 类（垂直方向）：
      │
      │  ← 虚线从上到下
      │
  ┌────────┐
  │目标: 50│  ← 胶囊（底部居中）
  └────────┘
```

### SVG 模板

```svg
<!-- Column/Line: 水平 GoalLine（结构同 AverageLine，胶囊右对齐） -->
<!-- 虚线 -->
<line x1="{chart_x}" y1="{goal_y}" x2="{chart_x + chart_w}" y2="{goal_y}"
  stroke="{line_color}" stroke-width="1" stroke-dasharray="2 3" stroke-linecap="round"/>
<!-- 胶囊标签（右对齐，不超出 content_right） -->
<rect x="{pill_x}" y="{goal_y - 10}" width="{pill_w}" height="20" rx="4" fill="#333333"/>
<text x="{pill_x + pill_w/2}" y="{goal_y + 4}" text-anchor="middle"
  font-size="10" font-weight="500" fill="#FFFFFF">{label}</text>
```

```svg
<!-- Bar: 垂直 GoalLine -->
<line x1="{goal_x}" y1="{chart_area_y}" x2="{goal_x}" y2="{chart_area_bottom - 20}"
  stroke="{line_color}" stroke-width="1" stroke-dasharray="2 3" stroke-linecap="round"/>
<!-- 胶囊标签（底部居中） -->
<rect x="{goal_x - pill_w/2}" y="{chart_area_bottom - 20}" width="{pill_w}" height="20" rx="4" fill="#333333"/>
<text x="{goal_x}" y="{chart_area_bottom - 20 + 13}" text-anchor="middle"
  font-size="10" font-weight="500" fill="#FFFFFF">{label}</text>
```

### 参数

| 参数 | 值 | 说明 |
|------|------|------|
| 虚线样式 | stroke-dasharray="2 3" | 较密虚线（区别于 AverageLine 的 "3 4"） |
| stroke-linecap | round | 圆头 |
| line_color | 主题色盘取色 | 区别于系列色 |
| 胶囊背景 | #333333 | 固定 |
| 胶囊文字 | #FFFFFF | |
| 胶囊高度 | 20px | 同 AverageLine |
| 胶囊圆角 | rx=4 | 同 AverageLine |
| pill_w | 动态 | 文字宽 + 16px |
| pill_x | `content_right - pill_w` | 右对齐到 content_right |
| 文案格式 | `{label}` | 如 "目标值 50"、"去年同期 38亿" |
| 支持图表 | Column / Bar / Line / Combo / Stacked | 不支持 100% Stacked、Pie、Donut |

### 与 AverageLine 的区别

| | AverageLine | GoalLine |
|--|-------------|----------|
| 虚线样式 | 3 4 | 2 3（更密） |
| 语义 | 计算值（均值） | 用户设定值（目标/参考） |
| line_color | 主题色盘取色 | 主题色盘取色（取另一色） |
| 其他样式 | 相同 | 相同（胶囊右对齐、无箭头） |

### 使用限制

- 若标注不清楚所指对象（哪个系列的目标？什么时间的目标？），应省略此 Widget
- 必要时结合信息区 Insight 正文补充说明
- 不支持 100% Stacked（百分比图无绝对值参考意义）
- 不支持 Pie / Donut

---

## TrendLine — 趋势线

基于线性回归的虚线，展示数据系列的整体趋势方向。

### 结构

```
        ·  ·
      ·       ·     ·
    ·              ·     ·
  ·─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─→  ← 趋势虚线（斜向，跟随回归斜率）
·                                     ↑ 两端各延伸 20px
```

### 算法（线性回归 / 最小二乘法）

```python
def calc_trend_line(points):
    """
    输入：数据点坐标列表 [(x1,y1), (x2,y2), ...]
    输出：趋势线起止坐标 [(start_x, start_y), (end_x, end_y)]
    """
    n = len(points)
    x_values = [i for i in range(n)]
    y_values = [p.y for p in points]  # 使用像素 y 坐标

    sum_x = sum(x_values)
    sum_y = sum(y_values)
    sum_xy = sum(x * y for x, y in zip(x_values, y_values))
    sum_xx = sum(x * x for x in x_values)

    # 斜率
    m = (n * sum_xy - sum_x * sum_y) / (n * sum_xx - sum_x * sum_x)
    # 截距
    b = (sum_y - m * sum_x) / n

    # 起止点
    start = (points[0].x, b)
    end = (points[-1].x, m * (n - 1) + b)

    return start, end
```

### 延伸

趋势线两端各沿方向向量延伸 `extend` 像素：

```python
extend = 20  # 默认 20px
dx = end_x - start_x
dy = end_y - start_y
length = math.sqrt(dx*dx + dy*dy)
unit_x = dx / length
unit_y = dy / length

ext_start = (start_x - unit_x * extend, start_y - unit_y * extend)
ext_end = (end_x + unit_x * extend, end_y + unit_y * extend)
```

### SVG 模板

```svg
<line x1="{ext_start_x}" y1="{ext_start_y}" x2="{ext_end_x}" y2="{ext_end_y}"
  stroke="{series_color}" stroke-width="2" stroke-dasharray="3 8"
  stroke-linecap="round"/>
```

### 参数

| 参数 | 值 | 说明 |
|------|------|------|
| 虚线样式 | stroke-dasharray="3 8" | 稀疏虚线 |
| stroke-width | 2 | |
| stroke-linecap | round | 圆头 |
| 颜色 | {series_color} | 跟随对应系列的颜色 |
| 延伸距离 | 20px | 两端各延伸 |
| 多系列 | 每个系列独立一条 | 颜色分别对应 |
| 支持图表 | Column / Line / Combo | 不支持 Bar（水平）、Stacked、Pie、Donut |

### 使用规则

- 至少需要 2 个数据点才能计算趋势
- 趋势线基于像素坐标计算（即 Y 轴已转换后的 SVG 坐标）
- 多系列时每个系列独立计算，使用对应系列色
- 趋势线位于数据点和 Widget 之下（z-index 低于气泡）
- 不显示标签（通过 Insight 正文说明趋势含义）
- 当 TrendLine 存在时，图表主数据元素需弱化显示以突出趋势：
  - Column 图：柱体 `fill-opacity="0.3"`
  - Line 图：线段 `stroke-opacity="0.3"`、节点 `opacity="0.3"`、面积填充保持原 opacity
  - Combo 图：同上分别处理柱/线
  - Widgets（Comment / PinNumber / Sticker / HighlightLabel 等）**不弱化**，保持 opacity=1
  - TrendLine 自身**不弱化**，保持完整可见

---

## Highlight — 聚焦高亮

通过弱化非目标元素或强调目标元素实现视觉聚焦。Highlight 不额外绘制图形，而是改变图表主体元素的渲染属性。

### 数据叙事意义

- **降噪**：在多系列多类目的复杂图表中，Highlight 通过弱化无关数据，让核心信息"浮出"画面
- **引导阅读路径**：配合 Insight 文案，将读者注意力精准导向叙事结论所指的数据区域
- **对比强化**：高亮系列/分组与弱化背景形成强对比，无需额外标注即可传达"这是主角"
- **适用场景**：
  - 单系列：突出关键月份/数据点（如"3月异常下跌"）
  - 多系列：突出某系列整体表现（如"品牌A全年领先"）或某分组竞争格局（如"Q4差距最大"）

### 高亮模式

**Column / Bar / Stacked 图表（弱化模式）：**

| 模式 | 参数 | 说明 | 系列限制 |
|------|------|------|---------|
| bar | category_idx, series_idx | 单个柱子/段 | 不限 |
| group | category_idx | 整个分组（同一类目所有系列） | 仅多系列 |
| series | series_idx | 整个系列（同一系列所有类目） | 仅多系列 |

**Line 图表：**

| 模式 | 参数 | 说明 | 系列限制 |
|------|------|------|---------|
| point | category_idx, series_idx | 强调单个节点（无弱化） | 不限 |
| line | series_idx | 整条折线 + 所有节点 | 仅多系列 |

### SVG 实现

**Column / Bar / Stacked — bar/group/series 模式：**

- 被高亮元素：正常绘制（opacity 不设置，默认 1）
- 非高亮元素：
  - 柱体/段：`fill-opacity="0.3"`
  - Data Label：`opacity="0.3"`（跟随所属柱子弱化）
- Widgets（Comment/PinNumber/Sticker 等）：**不弱化**，保持 opacity=1
- 坐标轴、网格线、图例：**不弱化**

**Line — point 模式（无弱化，仅强调）：**

- 所有元素保持 opacity=1，不弱化任何对象
- 被高亮节点的变化：
  - 空心圆 → 实心圆：`fill="{series_color}"`（原为 `fill="#FFFFFF"`）
  - 显示 Data Label（即使全局 Data Label 关闭）
- 其余节点和线段：保持原样不变

```svg
<!-- 普通节点（空心圆） -->
<circle cx="{x}" cy="{y}" r="5" fill="#FFFFFF" stroke="{series_color}" stroke-width="2"/>
<!-- 高亮节点（实心圆） -->
<circle cx="{x}" cy="{y}" r="5" fill="{series_color}" stroke="{series_color}" stroke-width="2"/>
<!-- 高亮节点 Data Label -->
<text x="{x}" y="{y - 14}" text-anchor="middle" font-size="12" font-weight="600" fill="{series_color}">{value}</text>
```

**Line — line 模式（弱化模式）：**

- 被高亮系列：折线 + 节点 opacity=1
- 非高亮系列：
  - 线段：`stroke-opacity="0.3"`
  - 节点：`opacity="0.3"`
  - 面积填充：保持原 opacity
- Widgets：**不弱化**

### 与 TrendLine 弱化的关系

- TrendLine 弱化：**所有**图表元素弱化，突出趋势线本身
- Highlight 弱化：**部分**图表元素弱化，突出被高亮的数据子集
- 两者**互斥**，不同时使用

### 使用限制

- 每张图表最多一个 Highlight Widget（可指定多个目标，如高亮多个 bar）
- 单系列时：仅支持 bar / point 模式
- 多系列时：支持所有模式
- 不支持 Pie / Donut（环形图用扇区分离表达强调）
- 与 TrendLine 互斥
- Stacked 图表的 bar 模式：高亮的是堆叠中的某一段

---

## HighlightLabel — 选择性数值标注

当 Data Label 全局关闭时，用于选择性地在个别关键数据点外部显示数值。与 Data Label 的区别：

| | Data Label | HighlightLabel |
|--|-----------|----------------|
| 位置 | 柱子内部顶端 | 柱子上方外部 |
| 颜色 | 白色 (#FFFFFF) | 跟随系列色 |
| 显示范围 | 全局一致（全显/全隐） | 选择性标注个别数据点 |
| 适用场景 | 精确阅读所有值 | Data Label 关闭时突出关键值 |

使用前提：仅在 Data Label 全局关闭时使用。若 Data Label 已全部显示，则无需 HighlightLabel。

### SVG 模板

```svg
<text x="{cx}" y="{anchor_y - 12}" text-anchor="middle"
  font-size="13" font-weight="600" fill="{series_color}">{value}</text>
```

### 参数

| 参数 | 值 |
|------|------|
| 距锚定点 | 12px |
| 颜色 | 跟随系列色 |
| 背景 | 无 |

---

## 气泡方向规范（图表类型决定）

气泡类 Widget（Comment / PinNumber）的布局结构由图表方向决定：

| 图表方向 | 适用图表类型 | 气泡结构 | 三角指向 |
|----------|-------------|----------|----------|
| 纵向 (Column) | Column / Column Stacked / Column 100% Stacked / Line / Combo | 上下结构：气泡在锚定点上方，三角朝下 | ▽ 指向锚定点 |
| 横向 (Bar) | Bar / Bar Stacked / Bar 100% Stacked | 左右结构：气泡在锚定点右侧，三角朝左 | ◁ 指向锚定点 |
| 环形 (Pie/Donut) | Pie / Donut | 上下结构：气泡在锚定点上方，三角朝下 | ▽ 指向锚定点 |

### Pie / Donut 气泡定位规则

- **锚定点**：扇区/环段对应的**外圆弧中心点**（mid_angle 处 outer_r 上的坐标）
- **方向固定**：气泡始终水平显示，三角垂直朝下，**不跟随圆弧角度倾斜**
- **Sticker**：emoji 中心点 = 外圆弧中心点

```
        ┌──────────────────────┐
        │  文字内容              │  ← 胶囊（水平，不倾斜）
        └──────────────────────┘
                  ▽                ← 三角尾（垂直朝下）
             ○ 外圆弧中心点         ← anchor = (cx + outer_r·cos(mid_angle), cy + outer_r·sin(mid_angle))
```

### Column 类气泡模板（上下结构）

```
        ┌──────────────────────┐
        │  文字内容              │  ← 气泡 rect
        └──────────────────────┘
                  ▽                ← 三角尾 (朝下)
            ─── 锚定点 ───
```

三角 polygon: `points="{cx},{tip_y} {cx-6},{base_y} {cx+6},{base_y}"`

### Bar 类气泡模板（左右结构）

```
                  ┌──────────────────────┐
        ◁         │  文字内容              │  ← 气泡 rect
                  └──────────────────────┘
   ─── 锚定点 ───
```

三角 polygon: `points="{tip_x},{cy} {base_x},{cy-6} {base_x},{cy+6}"`

其中 `tip_x = bubble_x - 6`, `base_x = bubble_x`, `cy = 锚定点 y`。

### Stacked 图表的锚定点

对于 Stacked 类图表，所有 Widget 的锚定点为**所在段（segment）的几何中心**：
- Column Stacked: `cx = 柱组中心 x`, `cy = 段顶 + 段高/2`
- Bar Stacked: `cx = 段左 + 段宽/2`, `cy = 条中心 y`

DifferenceArrow 的起止点同样锚定到所在段的中心位置。

---

## 通用规则

### 互斥约束
- 同一数据点只允许一个 Widget（Comment / PinNumber / Sticker / HighlightLabel 互斥）

### Data Label 与 Widget 共存规则

| Widget | Data Label 处理 | 原因 |
|--------|----------------|------|
| PinNumber | **隐藏** | 内容完全重复（PinNumber 已展示数值） |
| Sticker | **保留，按序排列** | 内容不重复，按序共存 |
| Comment | **保留，按序排列** | 内容不重复，按序共存 |

**按序排列规则**：Data Label 与 Widget 相对于段中心点居中，按序显示。Data Label 在前，Widget 在后。

**Column 类（上下排列）**：Widget 在上，Data Label 在下。
```
       [🚀]        ← Sticker (上), y = cy - 8
    ─── 段中心 ───
       [120]       ← Data Label (下), y = cy + 10
```

**Bar 类（左右排列）**：Data Label 在左，Widget 在右。
```
    [240]  ── 段中心 ──  [🚀]
     ↑ Data Label (左)        ↑ Sticker (右)
```

具体偏移参数：

| 方向 | Widget 偏移 | Data Label 偏移 | Comment 气泡偏移 |
|------|------------|----------------|-----------------|
| Column (上下) | 上方 (cy - 8 / 气泡在上) | cy + 10 (下方) | 三角 tip = cy - 5, 气泡在上方 |
| Bar (左右) | 右方 (cx + 14) | cx - 14 (左方) | 三角 tip = cx + 5, 气泡在右侧 |

**Comment 与 Data Label 共存时**（Column）：
```
   ┌────────────┐
   │ 注释内容    │      ← 气泡在上方
   └────────────┘
         ▽             ← 三角尾 tip = cy - 5
    ─── 段中心 ───
       [120]           ← Data Label, y = cy + 10
```

**Comment 与 Data Label 共存时**（Bar）：
```
   [240]  ── 段中心 ──  ◁ ┌────────────┐
    ↑                      │ 注释内容    │
    Data Label (左)        └────────────┘
```

### 定位规则
- 所有气泡类 Widget 三角尾尖端距锚定点 5px（Pie/Donut 为 0px，三角尖端 = 外圆弧中心点）
- 胶囊底边与三角顶边**完全贴合**（gap = 0），不允许出现空隙
- Sticker emoji 底边距锚定点 5px（Pie/Donut: emoji 中心 = 锚定点）
- DifferenceArrow: Column 的 connector_y 位于图表区最上方；Bar 的 connector_x 位于图表区最右侧

### 叙事选择原则
- 每个 Widget 必须有明确的叙事理由
- 无法准确表达含义的 Widget 应省略
- 宁少勿多：一张图表建议 2~4 个 Widget，避免信息过载

### 颜色覆盖
用户可通过指令自定义 Widget 颜色：
- "气泡用蓝色" → Comment/PinNumber fill 改为指定色
- "箭头用红色" → DifferenceArrow arrow_color 改为指定色
