# 图表元素规范

定义各类型图表的元素样式、显示规则和 Widget 兼容性。

## 支持图表类型

| 版本 | 类型 | 说明 |
|------|------|------|
| v1 | Column | 垂直柱状图（类目轴水平，数值轴垂直） |
| v1 | Column Stacked | 垂直堆叠柱状图（绝对值累加） |
| v1 | Column 100% Stacked | 垂直百分比堆叠柱状图（等高，显示占比） |
| v1 | Bar | 水平条形图（类目轴垂直，数值轴水平） |
| v1 | Bar Stacked | 水平堆叠条形图（绝对值累加） |
| v1 | Bar 100% Stacked | 水平百分比堆叠条形图（等长，显示占比） |
| v2 | Line | 折线图 |
| v2 | Pie | 饼图（实心圆） |
| v2 | Donut | 环形图（中空圆环，可含中心标签） |
| v2 | Combo | 柱线组合图 |

Column 与 Bar 的区别：
- **Column**: 类目轴 = X 轴（水平），数值轴 = Y 轴（垂直），柱子从底部向上生长
- **Bar**: 类目轴 = Y 轴（垂直），数值轴 = X 轴（水平），条形从左向右延伸

## Column 图表元素

### 网格线 (Grid)

水平网格线：
```svg
<line x1="{chart_x}" y1="{grid_y}" x2="{chart_x+chart_w}" y2="{grid_y}"
  stroke="#1a1a1a" stroke-width="0.5" stroke-opacity="0.09"/>
```

基线（0 轴）：
```svg
<line x1="{chart_x}" y1="{baseline_y}" x2="{chart_x+chart_w}" y2="{baseline_y}"
  stroke="#1a1a1a" stroke-width="1" stroke-opacity="0.15"/>
```

规则：
- 垂直网格线：默认不显示（Column 图表按 group 分隔，无需垂直线）
- 网格线数量：自动计算，数据 max 值等分 3~5 级
- 网格间距：`plot_height / grid_count`

### 柱子 (Bar)

```svg
<rect x="{bar_x}" y="{bar_top}" width="58" height="{bar_h}" rx="3" fill="{series_color}"/>
```

| 参数 | 值 | 说明 |
|------|------|------|
| 宽度 | 58px | 固定宽度 |
| 间隔 | 10px | 同 group 内系列间距 |
| 圆角 | rx=3 | |
| 颜色 | 主题色盘按系列顺序分配 | |
| Group 间距 | `chart_w / group_count` | 均分 |

Group 内柱子 x 坐标计算：
```
group_center = chart_x + (group_idx + 0.5) * group_width
bar_x = group_center - (series_count * 58 + (series_count - 1) * 10) / 2 + series_idx * (58 + 10)
```

### 数据标签 (Data Label)

```svg
<text x="{bar_cx}" y="{bar_top + 18}" text-anchor="middle"
  font-size="12" font-weight="500" fill="#FFFFFF">{value}</text>
```

显示规则：
- 位置：柱子内部顶端，距柱顶 18px
- 颜色：`#FFFFFF`（白色，确保在彩色柱子上可读）
- 当柱子高度 < 30px 时隐藏标签（避免溢出）
- 全局一致性：Data Label 要么全部显示，要么全部不显示，不允许部分显示
- 是否开启：默认开启，可根据叙事必要决定是否关闭
- Widget 不影响 Data Label 的显示：即使某柱子有 Comment/Sticker，Data Label 仍按全局规则显示
- 例外 — PinNumber：当某数据点使用 PinNumber 时，该数据点的 Data Label 隐藏（PinNumber 已包含数值，避免信息重复）

### 系列图例 (Legend)

```svg
<!-- 色块 -->
<rect x="{legend_x}" y="{legend_item_y}" width="12" height="12" rx="3" fill="{series_color}"/>
<!-- 文字 -->
<text x="{legend_x + 18}" y="{legend_item_y + 10}" font-size="11" font-weight="400" fill="#4d4d4d">{series_name}</text>
```

| 参数 | 值 |
|------|------|
| 位置 | 图表区右侧列顶部 |
| legend_x | chart_x + chart_w + 14 |
| 色块尺寸 | 12x12, rx=3 |
| 文字距色块 | 6px (legend_x + 18) |
| 行间距 | 20px |
| 排列 | 垂直堆叠 |

当图表含 AverageLine / GoalLine 时，图例列下方追加：
```svg
<!-- 虚线示例 -->
<line x1="{legend_x}" y1="{ref_legend_y+6}" x2="{legend_x+12}" y2="{ref_legend_y+6}"
  stroke="{line_color}" stroke-width="1" stroke-dasharray="2 2"/>
<!-- 说明文字 -->
<text x="{legend_x + 18}" y="{ref_legend_y + 10}" font-size="10" fill="#808080">{label}</text>
```

### X 轴标签

```svg
<text x="{group_center}" y="{baseline_y + 22}" text-anchor="middle"
  font-size="14" font-weight="600" fill="#1a1a1a">{category}</text>
```

规则：
- 位置：基线下方 22px
- 对齐：每个 group 水平居中
- 长文本处理：超过 6 字符时可旋转 45 度或截断加省略号

### Y 轴标签

```svg
<text x="{chart_x - 12}" y="{grid_y + 4}" text-anchor="end"
  font-size="11" font-weight="400" fill="#808080">{tick_value}</text>
```

规则：
- 位置：图表左侧外 12px
- 对齐：`text-anchor="end"`，与网格线垂直居中（+4px 补偿）
- 单位标注：如需在 Y 轴最上方标注单位，用独立 `<text>` 元素

## Stacked 图表元素

堆叠图将同一类目的多系列值纵向（Column）或横向（Bar）累加，而非并排放置。

### 通用堆叠规则

| 参数 | 值 | 说明 |
|------|------|------|
| 段间距 | 0px | 各段紧密相连，无间隔 |
| 圆角 | 仅最顶段/最右段 rx=3 | 其余段 rx=0 |
| 数据标签阈值 | Column: 段高 < 25px 隐藏; Bar: 段宽 < 40px 隐藏 | |
| 总量标签 | 仅普通 Stacked 可选 | 100% Stacked 不需要（总量无意义） |
| Widget 锚定点 | 堆叠整体的顶部中心（Column）或右端中心（Bar） | |

### Column Stacked

垂直堆叠柱，柱高 = 各段绝对值累加。

```svg
<!-- 底段（无圆角） -->
<rect x="{bar_x}" y="{seg_y}" width="{bar_w}" height="{seg_h}" fill="{color_0}"/>
<!-- 中间段（无圆角） -->
<rect x="{bar_x}" y="{seg_y}" width="{bar_w}" height="{seg_h}" fill="{color_1}"/>
<!-- 顶段（有圆角） -->
<rect x="{bar_x}" y="{seg_y}" width="{bar_w}" height="{seg_h}" rx="3" fill="{color_2}"/>
```

| 参数 | 值 | 说明 |
|------|------|------|
| 柱宽 bar_w | 80px | 比并排柱更宽（无需横向排列多系列） |
| Y 轴刻度 | 绝对值 | max = 所有类目总量中的最大值 |
| 网格线 | 与 Column 相同 | |
| X 轴标签 | 与 Column 相同 | |

堆叠计算：
```python
for ci in range(num_categories):
    y_cursor = baseline_y
    cat_total = sum(values[si][ci] for si in range(num_series))
    for si in range(num_series):
        seg_h = int(round(values[si][ci] / max_total * plot_height))
        seg_y = y_cursor - seg_h
        draw_rect(bar_x, seg_y, bar_w, seg_h, colors[si])
        y_cursor = seg_y
```

总量标签（可选）：
```svg
<text x="{bar_cx}" y="{stack_top - 10}" text-anchor="middle"
  font-size="12" font-weight="600" fill="#1a1a1a">{total}</text>
```

### Column 100% Stacked

垂直堆叠柱，所有柱等高（= plot_height），各段按占比分配。

| 参数 | 值 | 说明 |
|------|------|------|
| 柱宽 bar_w | 80px | |
| Y 轴刻度 | 0%, 25%, 50%, 75%, 100% | 固定 5 级 |
| 柱高 | 全部等于 plot_height | |
| 数据标签 | 显示百分比（如 "69%"） | 段内居中 |

堆叠计算：
```python
for ci in range(num_categories):
    cat_total = sum(values[si][ci] for si in range(num_series))
    y_cursor = baseline_y
    for si in range(num_series):
        pct = values[si][ci] / cat_total
        seg_h = int(round(pct * plot_height))
        seg_y = y_cursor - seg_h
        draw_rect(bar_x, seg_y, bar_w, seg_h, colors[si])
        y_cursor = seg_y
```

### Bar Stacked

水平堆叠条，条长 = 各段绝对值累加。

```svg
<!-- 左段（无圆角） -->
<rect x="{seg_x}" y="{bar_y}" width="{seg_w}" height="{bar_h}" fill="{color_0}"/>
<!-- 中间段 -->
<rect x="{seg_x}" y="{bar_y}" width="{seg_w}" height="{bar_h}" fill="{color_1}"/>
<!-- 右段（右侧圆角） -->
<rect x="{seg_x}" y="{bar_y}" width="{seg_w}" height="{bar_h}" rx="3" fill="{color_2}"/>
```

| 参数 | 值 | 说明 |
|------|------|------|
| 条高 bar_h | 40px | |
| 类目间距 | 16px | 各条之间的垂直间距 |
| X 轴刻度 | 绝对值 | max = 所有类目总量中的最大值 |
| Y 轴标签 | 类目名称，左对齐 | |

堆叠计算：
```python
for ci in range(num_categories):
    x_cursor = chart_x
    for si in range(num_series):
        seg_w = int(round(values[si][ci] / max_total * chart_w))
        draw_rect(x_cursor, bar_y, seg_w, bar_h, colors[si])
        x_cursor += seg_w
```

### Bar 100% Stacked

水平堆叠条，所有条等长（= chart_w），各段按占比分配。

| 参数 | 值 | 说明 |
|------|------|------|
| 条高 bar_h | 40px | |
| 类目间距 | 16px | |
| X 轴刻度 | 0%, 25%, 50%, 75%, 100% | 固定 5 级 |
| 条长 | 全部等于 chart_w | |
| 数据标签 | 显示百分比（如 "71%"） | 段内居中 |

堆叠计算：
```python
for ci in range(num_categories):
    cat_total = sum(values[si][ci] for si in range(num_series))
    x_cursor = chart_x
    for si in range(num_series):
        pct = values[si][ci] / cat_total
        seg_w = int(round(pct * chart_w))
        draw_rect(x_cursor, bar_y, seg_w, bar_h, colors[si])
        x_cursor += seg_w
```

### Stacked Widget 兼容

| Widget | Stacked | 100% Stacked |
|--------|---------|--------------|
| Comment | Y（锚定堆叠顶/右端） | Y |
| PinNumber | Y | Y（显示百分比或绝对值均可） |
| Sticker | Y | Y |
| DifferenceArrow | Y（连接不同类目的堆叠顶/右端） | Y（连接不同类目） |
| AverageLine | Y | -（百分比堆叠无均值意义） |
| GoalLine | Y | - |
| Highlight | Y（bar/group/series） | Y（bar/group/series） |

## Widget 兼容规则

不同图表类型支持的 Widget 不同：

| Widget | Column/Bar | Line (v2) | Pie (v2) | Donut (v2) | Combo (v2) |
|--------|:----------:|:----------:|:--------:|:----------:|:----------:|
| Comment | Y | Y | Y | Y | Y |
| PinNumber | Y | Y | Y | Y | Y |
| Sticker | Y | Y | Y | Y | Y |
| DifferenceArrow | Y | Y | - | - | Y |
| AverageLine | Y | Y | - | - | Y (仅轴类) |
| GoalLine | Y | Y | - | - | Y (仅轴类) |
| TrendLine | Y | Y | - | - | Y (仅轴类) |
| Highlight | Y (含 Stacked) | Y | - | - | Y |
| HighlightLabel | Y | Y | Y | Y | Y |

### 各类型特殊规则

**Column**：
- Widget 锚定点 = 柱子顶部中心 (bar_cx, bar_top)
- DifferenceArrow 连接两根柱子的顶部，三段结构为 垂直→水平→垂直
- TrendLine：基于各柱顶坐标计算线性回归，虚线 z-index 在柱体之上、气泡之下；存在 TrendLine 时柱体需设 `fill-opacity="0.3"` 弱化（详见 WIDGETS.md TrendLine 使用规则）
- Highlight：支持 bar/group/series 三种模式，非高亮柱体 `fill-opacity="0.3"`（与 TrendLine 互斥）

**Bar（水平条形图）**：
- 类目轴 = Y 轴（垂直），数值轴 = X 轴（水平）
- Widget 锚定点 = 条形右端中心 (bar_right, bar_cy)
- 气泡 Widget 显示在条形右侧（三角尾水平指向左方）
- DifferenceArrow 连接两根条形的右端，三段结构为 水平→垂直→水平
- AverageLine / GoalLine 为垂直虚线（从上到下），胶囊标签放在图表顶部
- TrendLine 不支持 Bar 类（水平方向的线性回归视觉不直观）
- Highlight：支持 bar/group/series 三种模式，非高亮条形 `fill-opacity="0.3"`（与 TrendLine 互斥）

**Line (v2)**：
- Widget 锚定点 = 折线数据节点 (node_x, node_y)
- 气泡三角尾指向节点而非柱顶
- 连线方式：逐段 `<line>`（不使用 polyline/path，飞书渲染存在偏移）
- 节点样式：空心圆（`fill="#FFFFFF" stroke="{series_color}" stroke-width="2" r="5"`）
- 面积填充：`<polygon>` 沿曲线+基线闭合，`fill="{series_color}" fill-opacity="0.03"`
- 不支持 smooth line（平滑曲线），仅直线连接
- 所有坐标（line 端点、circle 圆心、polygon 顶点）必须使用同一组整数坐标
- TrendLine：基于各系列节点坐标计算线性回归，虚线两端延伸 20px，z-index 低于数据节点；存在 TrendLine 时线段需设 `stroke-opacity="0.3"`、节点设 `opacity="0.3"` 弱化（详见 WIDGETS.md TrendLine 使用规则）
- Highlight：point 模式 → 目标节点空心圆变实心圆 + 显示 Data Label，无弱化；line 模式 → 非高亮系列 `stroke-opacity="0.3"` + 节点 `opacity="0.3"`（与 TrendLine 互斥）
- DifferenceArrow 限制：
  - **禁止在同一 X 轴位置（同一类目）的不同系列之间使用 DifferenceArrow**
  - 原因：Line 图的多系列在同一 X 位置仅有 Y 轴方向的偏移，垂直段过短且视觉上无法清晰表达对比关系
  - 允许的用法：同一系列不同类目之间的对比（如 Q2→Q4 的同系列趋势变化）
  - 跨系列对比应通过 Comment/Insight 文字表达，而非 DifferenceArrow

**Pie (v2)**：
- 无坐标轴，不支持 DifferenceArrow / AverageLine / GoalLine / TrendLine
- Widget 锚定点 = 扇区外弧中点
- Comment / PinNumber 以引导线连接扇区

## Pie 图表元素

### 扇区 (Sector)

采用 `<polygon>` 逐点近似弧线（飞书 `<path>` arc 渲染不可靠）：

```svg
<polygon points="{cx},{cy} {arc_point_1} {arc_point_2} ... {arc_point_n}" fill="{sector_color}"/>
```

弧线采样密度：每 1° 一个采样点，确保视觉平滑。

| 参数 | 值 | 说明 |
|------|------|------|
| 绘制方式 | polygon 逐点近似 | 不使用 path arc，避免渲染偏移 |
| 采样密度 | 1 point/degree | 保证弧线平滑 |
| 起始角度 | -90°（12 点钟方向） | 最大扇区从顶部开始 |
| 旋转方向 | 顺时针 | 角度递增 |

### 扇区间隔

扇区之间通过白色描边线模拟间隔（polygon 本身无 gap）：

```svg
<line x1="{cx}" y1="{cy}" x2="{edge_x}" y2="{edge_y}" stroke="#FFFFFF" stroke-width="4"/>
```

| 参数 | 值 |
|------|------|
| 间隔方式 | 白色 `<line>` 覆盖在扇区边界上 |
| 描边宽度 | 4px |
| 颜色 | #FFFFFF |
| 绘制时机 | 所有扇区绘制完成后，再绘制分隔线 |

### 饼图定位

```
pie_cx = content_x + content_w / 2 - 100   (左移为标签留空间)
pie_cy = chart_area_y + chart_area_h / 2    (图表区垂直居中)
pie_r  = min(chart_area_h / 2 - 80, 260)   (留出标签区域)
```

| 参数 | 计算 | 说明 |
|------|------|------|
| pie_cx | content_center_x - 100 | 饼图中心略偏左，为右侧标签/Widget 留空 |
| pie_cy | chart_area 垂直中心 | |
| pie_r | min(可用高度/2 - 80, 260) | 上下预留 80px 给标签引导线 |

### 标签引导线 (Leader Line)

每个扇区的标签通过两段折线连接：

```svg
<!-- 径向段：从饼边缘向外 -->
<line x1="{leader_start_x}" y1="{leader_start_y}" x2="{elbow_x}" y2="{elbow_y}" stroke="#808080" stroke-width="1"/>
<!-- 水平段：折弯后水平延伸 -->
<line x1="{elbow_x}" y1="{elbow_y}" x2="{tail_end_x}" y2="{elbow_y}" stroke="#808080" stroke-width="1"/>
```

| 参数 | 值 | 说明 |
|------|------|------|
| leader_start_r | pie_r + 8 | 引导线起点距圆心距离（略超出饼边缘） |
| label_r | pie_r + 50 | 折弯点（elbow）距圆心距离 |
| 水平尾长度 | 30px | 折弯后水平延伸长度 |
| 方向 | elbow 在 pie_cx 右侧 → 向右延伸；左侧 → 向左延伸 |
| 颜色 | #808080 | |
| 线宽 | 1px | |

引导线方向判定：
```
tail_dir = 1 if elbow_x > pie_cx else -1
tail_end_x = elbow_x + tail_dir * 30
```

### 标签文字

```svg
<text x="{text_x}" y="{elbow_y + 4}" text-anchor="{anchor}" font-size="13" font-weight="500" fill="#4d4d4d">{name} {value}%</text>
```

| 参数 | 值 |
|------|------|
| text_x | tail_end_x + 6（右侧）或 tail_end_x - 6（左侧） |
| text-anchor | "start"（右侧）/ "end"（左侧） |
| font-size | 13 |
| font-weight | 500 |
| fill | #4d4d4d |
| 内容 | "{品牌名} {百分比}%" |

### Widget 锚定与引导线

Pie 图的 Widget 共享引导线结构，Widget 气泡放置在水平尾末端：

- **PinNumber / Comment**：气泡 x = tail_end_x + 6（右侧）或 tail_end_x - bubble_w - 6（左侧）
- **Sticker**：emoji 放在 tail_end_x 偏移处
- 品牌名 + 百分比标注在 Widget 气泡下方（y + 42）

有 Widget 的扇区不再显示普通标签文字，Widget 本身承载信息。

### 小扇区标签避让

当相邻小扇区的标签 y 坐标过近（< 24px）时，需偏移避免重叠：

```python
if abs(label_y[i] - label_y[i-1]) < 24:
    label_y[i] = label_y[i-1] + 24  # 向下偏移
```

建议：扇区数量 ≤ 8 个。超过 8 个时将小扇区合并为"其他"。

**Donut (v2)**：
- 与 Pie 完全相同的 Widget 兼容规则
- 无坐标轴，不支持 DifferenceArrow / AverageLine / GoalLine
- Widget 锚定点 = 扇区外弧中点
- Comment / PinNumber 以引导线连接扇区
- 中心标签为可选元素

## Donut 图表元素

### 与 Pie 的区别

Donut（环形图）是 Pie 的变体，核心差异为中心挖空形成圆环，可在中心区域放置汇总信息。

| 属性 | Pie | Donut |
|------|-----|-------|
| 形状 | 实心圆 | 圆环（中空） |
| 扇区起点 | 圆心 (cx, cy) | 内弧 (inner_r) |
| 中心区域 | 无 | 可放置汇总标签 |
| Widget 兼容 | 同 | 同 |
| 引导线/标签 | 同 | 同 |

### 扇区 (Ring Segment)

采用 `<path>` 的 SVG arc 命令绘制环形段（平滑弧线，无锯齿）：

```svg
<path d="M {ox1},{oy1} A {outer_r},{outer_r} 0 {large_arc} 1 {ox2},{oy2}
         L {ix1},{iy1} A {inner_r},{inner_r} 0 {large_arc} 0 {ix2},{iy2} Z"
      fill="{sector_color}"/>
```

绘制逻辑：
```python
import math

sa_rad = math.radians(start_angle)
ea_rad = math.radians(end_angle)
sweep = end_angle - start_angle
large_arc = 1 if sweep > 180 else 0

# 外弧起止点
ox1 = cx + outer_r * math.cos(sa_rad)
oy1 = cy + outer_r * math.sin(sa_rad)
ox2 = cx + outer_r * math.cos(ea_rad)
oy2 = cy + outer_r * math.sin(ea_rad)

# 内弧起止点（反向连接）
ix1 = cx + inner_r * math.cos(ea_rad)
iy1 = cy + inner_r * math.sin(ea_rad)
ix2 = cx + inner_r * math.cos(sa_rad)
iy2 = cy + inner_r * math.sin(sa_rad)

path = f'M {ox1},{oy1} A {outer_r},{outer_r} 0 {large_arc} 1 {ox2},{oy2} L {ix1},{iy1} A {inner_r},{inner_r} 0 {large_arc} 0 {ix2},{iy2} Z'
```

| 参数 | 值 | 说明 |
|------|------|------|
| 绘制方式 | `<path>` arc 命令 | 使用 SVG A 命令绘制真弧线，避免 polygon 采点锯齿 |
| 起始角度 | -90°（12 点钟方向） | 最大扇区从顶部开始 |
| 旋转方向 | 顺时针 | sweep-flag = 1 |
| large_arc | sweep > 180° ? 1 : 0 | SVG arc large-arc-flag |
| outer_r | 与 pie_r 相同 | 外半径 |
| inner_r | outer_r * 0.55 | 内半径（环宽占 45%） |

### 扇区间隔

与 Pie 相同，使用白色描边线模拟间隔：

```svg
<!-- 外弧边界线 -->
<line x1="{cx + inner_r * cos(θ)}" y1="{cy + inner_r * sin(θ)}"
      x2="{cx + outer_r * cos(θ)}" y2="{cy + outer_r * sin(θ)}"
      stroke="#FFFFFF" stroke-width="4"/>
```

注意：Donut 的分隔线从内弧到外弧（而非从圆心到外弧）。

### 环形图定位

与 Pie 完全相同：

```
pie_cx = content_x + content_w / 2 - 100
pie_cy = chart_area_y + chart_area_h / 2
outer_r = min(chart_area_h / 2 - 80, 260)
inner_r = int(outer_r * 0.55)
```

### 中心标签（可选）

Donut 中心区域可放置汇总信息（总量、关键指标等）：

```svg
<!-- 主数值 -->
<text x="{cx}" y="{cy - 8}" text-anchor="middle"
  font-size="28" font-weight="900" fill="#1a1a1a">{total_value}</text>
<!-- 说明文字 -->
<text x="{cx}" y="{cy + 18}" text-anchor="middle"
  font-size="14" font-weight="400" fill="#808080">{description}</text>
```

| 参数 | 值 | 说明 |
|------|------|------|
| 主数值 font-size | 28 | 加粗突出 |
| 说明文字 font-size | 14 | 辅助说明 |
| 位置 | 圆环中心 (cx, cy) | 垂直居中分两行 |
| 内容 | 用户指定或 Agent 推荐 | 如 "总计 1.2亿"、"Top1 占比" |

中心标签使用规则：
- 默认推荐显示总量或核心比例
- 用户明确不需要时可省略
- 文字必须在 inner_r 范围内不溢出：单行宽度 ≤ inner_r * 1.4

### 标签引导线 / 标签文字 / Widget 锚定

与 Pie 完全相同（参见 Pie 图表元素章节）：
- 引导线从外弧边缘起始（leader_start_r = outer_r + 8）
- 标签文字放在引导线尾端
- Widget 锚定点为扇区外弧中点

### SVG 绘制顺序（层级规则）

Donut / Pie 图的 SVG 元素必须按以下顺序书写（后写的覆盖先写的）：

```
1. 背景边框（border rect + white rect）
2. 扇区/环段（<path> 或 <polygon>）
3. 白色分隔线
4. 中心标签（Donut）
5. 引导线（leader lines）
6. 标签文字（name + pct）
7. **Widget（Comment / PinNumber / Sticker）** ← 最高层级
8. 标题 / 副标题 / Insight 区域
```

**关键规则**：Widget 必须在引导线和标签文字之后绘制，确保气泡不被线条遮挡。引导线可穿过 Widget 区域，但 Widget 视觉上始终覆盖在线条之上。

### 小扇区标签避让

与 Pie 相同规则。建议扇区数量 ≤ 8。

**Combo (v2)**：
- 柱线组合图，支持双 Y 轴（左轴=柱系列，右轴=线系列）
- AverageLine / GoalLine 仅作用于有 Y 轴的系列（柱或线）
- DifferenceArrow 可跨柱/线系列对比，也可同系列跨类目对比
- 柱系列遵循 Column 规则；线系列遵循 Line 规则（逐段 `<line>`、空心圆节点、整数坐标）

## Combo 图表元素

### 双 Y 轴

Combo 图拥有左右两条 Y 轴：

| 轴 | 位置 | 对应系列 | 说明 |
|----|------|----------|------|
| 左 Y 轴 | chart_x 左侧 | Column 柱系列 | 与 Column 规则相同 |
| 右 Y 轴 | chart_x + chart_w 右侧 | Line 线系列 | 镜像放置 |

右 Y 轴标签：
```svg
<text x="{chart_x + chart_w + 12}" y="{grid_y + 4}" text-anchor="start"
  font-size="11" font-weight="400" fill="#808080">{tick_value}%</text>
```

### 网格线

仅根据左 Y 轴绘制水平网格线（避免双轴网格混乱）：
```svg
<line x1="{chart_x}" y1="{grid_y}" x2="{chart_x + chart_w}" y2="{grid_y}"
  stroke="#1a1a1a" stroke-width="0.5" stroke-opacity="0.09"/>
```

### 柱系列

与 Column 图规则完全相同：
- 柱宽：单系列时可加宽至 80~100px（无需同 group 内排列多系列）
- 柱子 x 坐标：居中于各类目
- 数据标签：柱内顶部白色文字
- Y 轴映射：使用左 Y 轴的 val_to_y

```
bar_w = 100  (单柱系列时推荐加宽)
bar_x = group_center - bar_w / 2
```

### 线系列

遵循 Line 图渲染规则：
- 逐段 `<line>` 连接节点（不使用 polyline/path）
- 节点：空心圆 `fill="#FFFFFF" stroke="{line_color}" stroke-width="2" r="5"`
- 面积填充：`<polygon>` + `fill-opacity="0.03"`（可选）
- 所有坐标使用整数
- Y 轴映射：使用右 Y 轴的 val_to_y_right

```python
def val_to_y_right(v):
    return int(round(plot_bottom - (v / right_max) * plot_height))
```

### 数据标签

柱系列和线系列各自独立的数据标签：
- 柱系列：柱内顶部，白色，font-size=12
- 线系列：节点上方，系列色，font-size=11

### 图例

图例需区分柱和线的视觉表达：
```svg
<!-- 柱系列图例：色块 -->
<rect x="{legend_x}" y="{ly}" width="12" height="12" rx="3" fill="{bar_color}"/>
<text x="{legend_x + 18}" y="{ly + 10}" ...>{bar_series_name}</text>

<!-- 线系列图例：短横线 + 圆点 -->
<line x1="{legend_x}" y1="{ly + 6}" x2="{legend_x + 12}" y2="{ly + 6}"
  stroke="{line_color}" stroke-width="2"/>
<circle cx="{legend_x + 6}" cy="{ly + 6}" r="3" fill="#FFFFFF" stroke="{line_color}" stroke-width="1.5"/>
<text x="{legend_x + 18}" y="{ly + 10}" ...>{line_series_name}</text>
```

### Widget 兼容

| Widget | 柱系列 | 线系列 |
|--------|--------|--------|
| Comment | 锚定柱顶 | 锚定节点 |
| PinNumber | 锚定柱顶 | 锚定节点 |
| Sticker | 锚定柱顶 | 锚定节点 |
| DifferenceArrow | 柱顶间连接 | 节点间连接，可跨柱/线 |
| AverageLine | 左Y轴计算 | 右Y轴计算 |

DifferenceArrow 跨系列规则：
- 允许柱顶 → 同类目线节点的对比（垂直段很短时用 Comment 替代）
- 允许同系列不同类目的对比（如 Q1柱 → Q4柱）
- connector_y 碰撞避让规则与 Column 一致

### 通用约束

- 同一数据点仅允许一个 Widget（Comment / PinNumber / Sticker 互斥）
- 所有图表类型均遵守此互斥规则
- Data Label 与 Widget 独立：Widget 不影响 Data Label 的全局显示/隐藏
- 例外：PinNumber 所在的数据点不显示 Data Label（PinNumber 已承载数值信息，重复显示冗余）
