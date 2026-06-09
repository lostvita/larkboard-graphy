# larkboard-graphy

[![Claude Skill](https://img.shields.io/badge/Claude-AI%20Skill-orange)](https://docs.anthropic.com)
[![Cursor Skill](https://img.shields.io/badge/Cursor-AI%20Skill-blue)](https://cursor.sh)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

> AI-powered data storytelling on Feishu/Lark whiteboards — not just charts, but narratives.

[中文文档](./README.zh-CN.md)

## What is larkboard-graphy?

**larkboard-graphy** is an AI agent skill that generates fully editable Feishu whiteboard charts with built-in data storytelling capabilities. It bridges the gap between raw data and compelling visual narratives.

### Design Philosophy

- **Data Storytelling First** — Every chart is a story. Widgets (annotations, trend lines, highlights) are first-class citizens, not afterthoughts. The skill analyzes your data and proposes a narrative strategy before drawing a single pixel.
- **Editable, Not Static** — Unlike screenshot-based chart tools, every element (shape, text, connector) lands as a native Feishu whiteboard object. Your team can move, resize, recolor, and extend the chart after generation.
- **Constraint-Driven Rendering** — Built on hard-won knowledge of what Feishu's SVG whiteboard renderer can and cannot do (native shapes only, no gradients, no foreignObject, limited opacity support). Every rule in `RULES.md` was verified on-board.
- **Three-Section Architecture** — Each chart follows a consistent layout: Title (conclusion-first headline), Chart Area (data + widgets), and Info Area (insight narrative + source). This structure ensures every chart tells a complete story.

### How It Differs from Traditional Charts

| | Traditional Chart Tools | larkboard-graphy |
|--|------------------------|------------------|
| Output | Static image / iframe | Editable native whiteboard shapes |
| Storytelling | Manual annotation after export | AI-proposed widgets baked into generation |
| Collaboration | View-only or re-export | Team can directly edit on Feishu |
| Design System | Generic defaults | Graphy-specific typography, spacing, color system |

## Preview

<!-- TODO: Add demo screenshots -->
| Column + Highlight | Line + TrendLine | Donut + Widgets |
|:--:|:--:|:--:|
| ![column](https://via.placeholder.com/300x180?text=Column+Highlight) | ![line](https://via.placeholder.com/300x180?text=Line+TrendLine) | ![donut](https://via.placeholder.com/300x180?text=Donut+Widgets) |

## Supported Chart Types

| Type | Description |
|------|-------------|
| Column | Vertical bar chart (grouped) |
| Column Stacked | Stacked vertical bars (absolute) |
| Column 100% Stacked | Stacked vertical bars (percentage) |
| Bar | Horizontal bar chart |
| Bar Stacked | Stacked horizontal bars (absolute) |
| Bar 100% Stacked | Stacked horizontal bars (percentage) |
| Line | Line chart with data nodes |
| Pie | Pie chart (solid) |
| Donut | Ring chart with optional center label |
| Combo | Column + Line combination |

## Widgets

Widgets are the data storytelling layer — they transform a plain chart into a narrative.

| Widget | Purpose | When to Use |
|--------|---------|-------------|
| **Comment** | Text annotation explaining the "why" behind data | Highlight causality, context, or qualitative insight (e.g., "New policy launched") |
| **PinNumber** | Precise value callout on a data point | Emphasize a specific KPI or milestone number |
| **Sticker** | Emoji emotion marker | Convey sentiment or trend direction at a glance (🚀 growth, ⚠️ warning) |
| **DifferenceArrow** | Quantified gap between two data points | Show exact delta between values (e.g., "+12B gap") |
| **AverageLine** | Mean reference line across the chart | Establish a baseline for comparison |
| **GoalLine** | Target/KPI reference line | Mark business goals or benchmarks |
| **TrendLine** | Linear regression trend line | Reveal overall direction when individual points are noisy |
| **Highlight** | Focus dimming — non-highlighted elements fade to 0.3 | Draw attention to a specific bar, group, series, or line |
| **HighlightLabel** | Selective value label on individual points | Show values only on key data points when global labels are off |

## Color Themes

### Monochrome (9 palettes, 8 shades each)

<!-- Color swatches from graphy/src/components/AsideSetting/Design/PresetSection/config.ts -->

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

### Colorful

**Pastel**<br>
![#b2ddc9](https://readme-swatches.vercel.app/b2ddc9?style=round)![#b2a4ff](https://readme-swatches.vercel.app/b2a4ff?style=round)![#ffadad](https://readme-swatches.vercel.app/ffadad?style=round)![#a2d5e2](https://readme-swatches.vercel.app/a2d5e2?style=round)![#ffccd3](https://readme-swatches.vercel.app/ffccd3?style=round)![#aac4ff](https://readme-swatches.vercel.app/aac4ff?style=round)![#ffdeb4](https://readme-swatches.vercel.app/ffdeb4?style=round)![#dca8c7](https://readme-swatches.vercel.app/dca8c7?style=round)![#fdf7c3](https://readme-swatches.vercel.app/fdf7c3?style=round)

**Vivid**<br>
![#b399fd](https://readme-swatches.vercel.app/b399fd?style=round)![#fc8497](https://readme-swatches.vercel.app/fc8497?style=round)![#fbbc30](https://readme-swatches.vercel.app/fbbc30?style=round)![#279eff](https://readme-swatches.vercel.app/279eff?style=round)![#e83562](https://readme-swatches.vercel.app/e83562?style=round)![#40f8ff](https://readme-swatches.vercel.app/40f8ff?style=round)![#f38650](https://readme-swatches.vercel.app/f38650?style=round)![#c82184](https://readme-swatches.vercel.app/c82184?style=round)![#31fcb4](https://readme-swatches.vercel.app/31fcb4?style=round)![#6d48d2](https://readme-swatches.vercel.app/6d48d2?style=round)

## How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│  1. DATA INPUT                                                  │
│     User provides data (table / JSON / text description)        │
│                          ↓                                      │
│  2. CHART TYPE SELECTION                                        │
│     Agent recommends chart type based on data characteristics   │
│                          ↓                                      │
│  3. THEME SELECTION                                             │
│     User picks a color palette (Monochrome or Colorful)         │
│                          ↓                                      │
│  4. NARRATIVE ANALYSIS                                          │
│     Agent identifies key insights and proposes Widget strategy  │
│     (which data points to annotate, highlight, or compare)      │
│                          ↓                                      │
│  5. SVG GENERATION                                              │
│     Builds complete SVG following Feishu whiteboard rendering    │
│     rules (native shapes only, no gradients, no foreignObject)  │
│                          ↓                                      │
│  6. VALIDATION                                                  │
│     whiteboard-cli --check verifies text overflow, overlap      │
│     Auto-fix up to 3 rounds if errors detected                  │
│                          ↓                                      │
│  7. PUBLISH TO FEISHU                                           │
│     lark-cli creates doc → writes SVG as whiteboard content     │
│     Returns shareable Feishu document URL                       │
└─────────────────────────────────────────────────────────────────┘
```

The generated whiteboard is **fully editable** in Feishu — every shape, text, and connector can be moved, resized, or recolored by hand.

## Prerequisites

- **Node.js** >= 18
- **A Feishu / Lark account** — whiteboards are written into your own tenant
- **`lark-cli`** (`@larksuite/cli`), installed and authenticated:
  ```bash
  npm install -g @larksuite/cli
  lark-cli auth login --as user
  ```
- **`@larksuite/whiteboard-cli`** — used via npx, downloads automatically

## Install

**Tell your agent** (Cursor, Claude Code, etc.):

> "Install the **larkboard-graphy** skill from `github.com/user/larkboard-graphy`."

Or install manually (clone into your agent's skills folder):

```bash
# Cursor skills directory
git clone https://github.com/user/larkboard-graphy \
  ~/.cursor/skills/larkboard-graphy

# Or Claude Code skills directory
git clone https://github.com/user/larkboard-graphy \
  ~/.claude/skills/larkboard-graphy
```

Then run the bundled environment check:

```bash
bash scripts/preflight.sh
```

## Quick Start

Trigger the skill with any of these phrases:

- `"larkboard graphy"`
- `"generate a Feishu chart whiteboard"`
- `"data storytelling whiteboard"`
- `"graphy whiteboard"`
- `"生成飞书图表白板"`
- `"数据图表白板"`
- `"飞书数据故事"`

Then follow the interactive flow:

1. **Provide data** — paste a table, JSON, or describe your data in plain text
2. **Confirm chart type** — agent recommends one based on data characteristics
3. **Pick a theme** — choose from Monochrome or Colorful palettes
4. **Review narrative** — agent proposes which widgets to add and why
5. **Get your link** — a fully editable Feishu whiteboard URL is returned

## Roadmap

- [ ] Waterfall chart support
- [ ] Scatter / Bubble chart
- [ ] Horizontal timeline chart
- [ ] Multi-board linked dashboards
- [ ] Animation / transition effects (if Feishu supports)
- [ ] Auto-refresh from live data sources
- [ ] Export to PNG / PDF alongside whiteboard

## License

[MIT](./LICENSE)
