# larkboard-graphy

生成符合 Graphy 设计体系的飞书白板数据图表，支持数据叙事 Widget 与主题色盘。

## 触发词

- "生成飞书图表白板"
- "larkboard graphy"
- "数据图表白板"
- "graphy 白板"
- "飞书数据故事"

## 前置条件

运行 `scripts/preflight.sh` 检查：
- `lark-cli` 已安装且已登录（`lark-cli auth login --as user`）
- `npx -y @larksuite/whiteboard-cli --version` 可用
- Node.js >= 18

## 对话流程

### Step 1: 理解数据

用户提供数据源（表格 / JSON / 文本描述），可能附带图表类型偏好。

Agent 解析数据后，展示确认信息（使用 AskQuestion）：

```
已识别数据：
- 类目轴：Q1, Q2, Q3, Q4
- 数值轴：营收（亿元）
- 系列：4 个（比亚迪、理想、问界、小米）
- 推荐图表类型：Column（分组柱状图）

确认图表类型？
1. Column（分组柱状图）
2. Bar（条形图，水平方向）
3. Line（折线图）
4. Pie（饼图）
5. Donut（环形图）
6. Column Stacked（堆叠柱状图）
7. Column 100% Stacked（百分比堆叠柱状图）
8. Bar Stacked（堆叠条形图）
9. Bar 100% Stacked（百分比堆叠条形图）
10. Combo（柱线组合图）
```

规则：
- Agent 根据数据特征推荐默认图表类型：
  - 多系列对比 → Column
  - 排名类 → Bar
  - 趋势/时间序列 → Line
  - 单一整体的构成（≤8 项） → Pie
  - 单一整体的构成 + 需强调总量或核心指标 → Donut
  - 部分-整体 + 时间变化 + 关注总量 → Column Stacked
  - 部分-整体 + 时间变化 + 关注占比 → Column 100% Stacked
  - 部分-整体 + 排名 + 关注总量 → Bar Stacked
  - 部分-整体 + 排名 + 关注占比 → Bar 100% Stacked
  - 双指标（量+率）组合 → Combo
- 用户可选择其他类型
- 不要添加自定义的"其他"选项（系统已内置 other 入口，用户可直接输入）

### Step 2: 选择主题（主动询问）

Agent 根据数据特征推荐 3 个主题选项（使用 AskQuestion）：

```
请选择图表主题色盘：
1. blue 单色系（渐变蓝色）
2. purple 单色系（渐变紫色）
3. Vivid 多彩（适合多系列对比）
```

规则：
- 不要添加自定义的"其他"选项（系统已内置 other 入口，用户可直接输入色系名称如 orange、Pastel）
- 推荐策略：单系列 → Monochrome；多系列 → Colorful
- 用户输入自由文本时按色系名匹配（见 THEMES.md）

### Step 3: 叙事分析（需用户确认）

Agent 自动分析数据并提出叙事建议：

1. 识别关键数据点（最大值 / 最小值 / 异常值）
2. 识别趋势（增长 / 下降 / 转折点）
3. 识别对比关系（系列间差异、同比环比）
4. 推荐 Widget 方案

展示格式：
```
叙事分析：
- 核心结论：霸王茶姬全年同比+44%登顶
- Widget 方案：
  · Q2 霸王茶姬 → 🚀 Sticker（爆发式增长）
  · Q4 古茗 → Comment "同比+57%，增速最快"
  · 霸王茶姬 vs 喜茶 → DifferenceArrow "+12亿"
  · 三品牌均值 → AverageLine "三品牌均值 46亿"
- 标题建议：霸王茶姬全年同比+44%登顶

请确认或修改叙事方案：
```

**不使用 AskQuestion**（因为该工具要求最少 2 个选项，而此步骤只需一个确认入口）。直接在文本末尾提示用户回复：

```
回复"确认"开始生成，或直接输入修改意见。
```

用户可以：
- 直接确认（回复"确认"/"ok"/"可以"等肯定词）
- 直接输入修改意见：
  - 修改 Widget 选择（如"Q2 用 Comment 替代 Sticker"）
  - 补充叙事文案（如"标题改为：古茗增速最快反超喜茶"）
  - 调整强调重点（如"重点突出古茗的增长"）

### Step 4: 生成图表

用户确认后执行：
1. 按 DESIGN.md 架构生成完整 SVG（三段式布局）
2. 应用 CHARTS.md 中的图表元素规范
3. 叠加 WIDGETS.md 中确认的 Widget
4. 应用 THEMES.md 中选定的色盘

### Step 5: 渲染校验

```bash
npx -y @larksuite/whiteboard-cli -i chart.svg -f svg --check
npx -y @larksuite/whiteboard-cli -i chart.svg -o chart.png -f svg
```

- 检查 text-overflow / node-overlap 错误
- 如有错误自动修复后重新检查（最多 3 轮）
- Border 双矩形的 node-overlap 警告为预期行为，可忽略

### Step 6: 写入飞书并输出链接

```bash
# 创建文档 + 白板 block
lark-cli docs +create --api-version v2 \
  --content '<title>{标题}</title><whiteboard type="blank"></whiteboard>' --as user

# SVG → OpenAPI JSON → 写入白板
npx -y @larksuite/whiteboard-cli -i chart.svg --to openapi --format json -f svg -o chart.json
lark-cli whiteboard +update --whiteboard-token {token} \
  --source @chart.json --input_format raw --idempotent-token {uuid} --overwrite --as user
```

**必须输出链接：** 完成写入后，将飞书文档 URL（从 `docs +create` 返回的 `url` 字段）作为最终结果输出给用户。格式：

```
飞书画板已生成：https://xxx.feishu.cn/docx/xxxxx
```

若为更新已有白板，同样输出对应的文档链接。

## 参考文档

- [RULES.md](./RULES.md) — 飞书白板 SVG 渲染硬限制
- [DESIGN.md](./DESIGN.md) — 三段式布局架构规范
- [CHARTS.md](./CHARTS.md) — 图表元素定义与 Widget 兼容规则
- [WIDGETS.md](./WIDGETS.md) — Widget 类型与 SVG 实现模板
- [THEMES.md](./THEMES.md) — 主题色盘系统
