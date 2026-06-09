# 飞书白板 SVG 渲染规则

飞书白板的 SVG 渲染引擎有严格限制。违反以下规则会导致元素被渲染为静态图片（不可编辑）或显示异常。

## 硬限制

### 仅支持原生 SVG 形状

可用元素：
- `<rect>` — 矩形/圆角矩形
- `<circle>` — 圆形
- `<ellipse>` — 椭圆
- `<line>` — 直线
- `<polyline>` — 折线
- `<polygon>` — 多边形
- `<text>` — 文本（单行，不支持 `<tspan>` 换行）
- `<path>` — 路径（仅简单路径，复杂路径可能降级为图片）

禁用元素：
- `<foreignObject>` — 完全不支持
- `<use>` / `<symbol>` — 不支持引用复用
- `<clipPath>` / `<mask>` — 不支持裁剪遮罩
- `<filter>` — 不支持滤镜
- `<image>` — 会被转为静态图片节点（丢失可编辑性）

### 颜色与填充

- 仅支持 6 位 hex 色值：`fill="#7c3aed"`
- 不支持 `rgba()`、`hsl()`、CSS 变量
- 不支持 `<linearGradient>` / `<radialGradient>`
- `opacity` 属性：`stroke-opacity` 可用于网格线等场景；`fill-opacity` 在 polygon 上实测可用（如折线面积 `fill-opacity="0.03"`），但数值需实测验证
- 需要半透明效果时：优先使用 `fill-opacity`（0.03~0.12 范围实测有效），备选方案为接近白色的浅灰 hex 色模拟

### 路径与折线渲染偏移

- `<polyline>` 和 `<path>`（含贝塞尔曲线）在飞书白板渲染时存在坐标偏移，折点/曲线不经过指定坐标
- **折线图必须使用逐段 `<line>` 替代 `<polyline>`**，每段 line 的端点坐标与 circle 节点坐标完全一致
- 不支持 smooth line（平滑曲线），仅支持直线连接
- 所有坐标使用整数（`int(round(...))`）避免浮点精度问题

### 文本规则

- 每个 `<text>` 元素仅支持单行
- 不支持 `<tspan>` 多行文本
- 多行文字需拆分为多个独立 `<text>` 元素（手动计算 y 偏移）
- `text-anchor`: 支持 `start` / `middle` / `end`
- `font-weight`: 支持数值（400/500/600/700/900）
- `font-size`: 使用纯数字不带单位（如 `font-size="14"` 而非 `font-size="14px"`）
- 文字颜色用 `fill` 属性，不是 `color`
- 中文字体：无需指定 font-family，飞书有默认中文字体

### 箭头实现

飞书白板中箭头必须通过 `marker-end` 实现：

```svg
<defs>
  <marker id="arrow" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
    <polygon points="0,0 10,3.5 0,7" fill="{color}"/>
  </marker>
</defs>
<line x1="..." y1="..." x2="..." y2="..." stroke="{color}" marker-end="url(#arrow)"/>
```

- 不要用 `<polygon>` 手绘箭头三角（会丢失方向语义）
- `marker-end` 的颜色需与 `stroke` 一致

### 描边规则

- `stroke-width`: 支持小数（如 `0.5`）
- `stroke-dasharray`: 支持（如 `"3 4"` 用于虚线）
- `stroke-linecap` / `stroke-linejoin`: 支持
- 不支持 `stroke-dashoffset` 动画

### 尺寸与坐标

- SVG viewBox 与 canvas 尺寸需一致（如 `viewBox="0 0 1700 1080"` 对应 `width="1700" height="1080"`）
- 所有坐标使用绝对值（不支持相对单位 em/rem/%）
- `transform`: 仅 `rotate()` 可用于文本旋转，`scale()` / `translate()` 不可靠

### 层叠顺序

- 飞书白板按 SVG 文档顺序渲染（后出现的元素在上层）
- 无 `z-index` 支持
- 需要层叠效果时通过元素书写顺序控制

## 经验规则

### 文本溢出检测

使用 `whiteboard-cli --check` 检查 `text-overflow` 警告：
- 中文字符宽度约为 `font-size` 值（如 14px 字号，每字约 14px 宽）
- 英文/数字宽度约为 `font-size * 0.6`
- 预留 padding 时按 `字数 * 字宽 + 24px` 计算容器宽度

### 元素重叠

- `node-overlap` 警告表示两个元素视觉重叠
- Border 双矩形叠加是预期行为，此警告可忽略
- Widget 之间、Widget 与数据标签之间的重叠需修复

### SVG 文件编码

- 必须使用 UTF-8 编码保存 SVG 文件
- Python 写入时显式指定 `open(..., encoding='utf-8')`
- 中文内容不做任何转义（不用 `&#x` 实体）

### whiteboard-cli 常用命令

```bash
# 渲染为 PNG 预览
npx -y @larksuite/whiteboard-cli -i chart.svg -o chart.png -f svg

# 检查溢出/重叠
npx -y @larksuite/whiteboard-cli -i chart.svg -f svg --check

# 转为 OpenAPI JSON（用于写入飞书）
npx -y @larksuite/whiteboard-cli -i chart.svg --to openapi --format json -f svg
```
