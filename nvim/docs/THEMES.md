# 主题配置指南 (Theme Configuration Guide)

本文档介绍 LazyVim 配置中可用的所有主题及其切换方法。

---

## 🎨 可用主题列表 (Available Themes)

### 1. Catppuccin (默认) - 优雅柔和色调

**风格**: 柔和、优雅、现代
**变种**: `latte` (浅色), `frappe`, `macchiato`, `mocha` (深色)
**特色**: 柔和的配色、出色的可读性

```vim
:colorscheme catppuccin
```

### 2. Tokyonight - 东京夜晚

**风格**: 鲜艳、对比度高
**变种**: `night`, `storm`, `moon`, `day`
**特色**: 霓虹色彩、现代感强

```vim
:colorscheme tokyonight
```

### 3. Gruvbox - 复古暖色调

**风格**: 复古、温暖、护眼
**变种**: `hard`, `medium`, `soft`
**特色**: 经典配色、长时间使用舒适

```vim
:colorscheme gruvbox
```

### 4. Kanagawa - 日式水墨风格

**风格**: 优雅、平静、东方美学
**变种**: `wave`, `dragon`, `lotus`
**特色**: 受日本传统绘画启发

```vim
:colorscheme kanagawa
```

### 5. Rose Pine - 玫瑰松木

**风格**: 柔和、低对比度
**变种**: `main`, `moon`, `dawn`
**特色**: 护眼、减少眼睛疲劳

```vim
:colorscheme rose-pine
```

### 6. Nightfox - 夜狐家族

**风格**: 多样化、现代
**变种**: `nightfox`, `dayfox`, `dawnfox`, `duskfox`, `nordfox`, `terafox`, `carbonfox`
**特色**: 丰富的变种选择

```vim
:colorscheme nightfox
:colorscheme nordfox  " 北欧风格
:colorscheme carbonfox  " 碳黑风格
```

### 7. Dracula - 德古拉

**风格**: 黑暗、高对比度
**特色**: 经典黑暗主题、色彩鲜明

```vim
:colorscheme dracula
```

### 8. Nord - 北欧冷色调

**风格**: 冷色系、极简
**特色**: 北欧设计美学、冰蓝色系

```vim
:colorscheme nord
```

### 9. Onedark - Atom 经典

**风格**: 平衡、专业
**变种**: `dark`, `darker`, `cool`, `deep`, `warm`, `warmer`
**特色**: Atom 编辑器经典主题

```vim
:colorscheme onedark
```

### 10. Everforest - 森林主题

**风格**: 自然、舒适、绿色系
**变种**: `hard`, `medium`, `soft`
**特色**: 受森林启发、护眼

```vim
:colorscheme everforest
```

### 11. Solarized - 经典科学配色

**风格**: 科学设计、精确对比
**变种**: `light`, `dark`
**特色**: 基于色彩理论设计

```vim
:colorscheme solarized
```

### 12. Monokai Pro - Sublime 经典

**风格**: 鲜艳、经典
**变种**: `pro`, `classic`, `octagon`, `machine`, `ristretto`, `spectrum`
**特色**: Sublime Text 经典主题

```vim
:colorscheme monokai-pro
```

---

## 🔧 切换主题方法

### 方法 1: 临时切换 (当前会话)

```vim
:colorscheme <主题名>
```

### 方法 2: 永久设置 (修改配置)

编辑 `lua/plugins/colorscheme.lua`:

```lua
{
  "LazyVim/LazyVim",
  opts = {
    colorscheme = "gruvbox",  -- 改为你喜欢的主题
  },
}
```

### 方法 3: 使用 Telescope 选择器

```vim
:Telescope colorscheme
```

可以实时预览并选择主题！

---

## 🎯 主题推荐场景

### 长时间编程 (护眼优先)

- **Gruvbox** (warm contrast)
- **Rose Pine** (低对比度)
- **Everforest** (护眼绿)

### 现代化界面

- **Tokyonight** (霓虹风)
- **Catppuccin** (优雅柔和)
- **Nightfox** (多样化)

### 极简主义

- **Nord** (北欧极简)
- **Kanagawa** (日式简约)

### 经典风格

- **Dracula** (经典黑暗)
- **Solarized** (科学配色)
- **Monokai Pro** (Sublime 经典)

---

## ⚙️ 主题自定义

### 启用透明背景

编辑对应主题配置：

```lua
{
  "catppuccin/nvim",
  opts = {
    transparent_background = true,  -- 设为 true
  },
}
```

### 调整对比度 (以 Everforest 为例)

```lua
{
  "neanias/everforest-nvim",
  opts = {
    background = "hard",  -- hard, medium, soft
  },
}
```

### 自定义斜体和粗体

```lua
{
  "onedark.nvim",
  opts = {
    code_style = {
      comments = "italic",        -- 注释斜体
      keywords = "bold",          -- 关键字粗体
      functions = "bold,italic",  -- 函数粗体+斜体
    },
  },
}
```

---

## 📊 主题对比表

| 主题 | 风格 | 对比度 | 护眼 | 现代感 |
|------|------|--------|------|--------|
| Catppuccin | 柔和 | 中 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Tokyonight | 鲜艳 | 高 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Gruvbox | 复古 | 中 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Kanagawa | 典雅 | 低-中 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Rose Pine | 柔和 | 低 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Nord | 冷色 | 中 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Dracula | 黑暗 | 高 | ⭐⭐ | ⭐⭐⭐⭐ |
| Everforest | 自然 | 中 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Solarized | 科学 | 中 | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Monokai Pro | 经典 | 高 | ⭐⭐⭐ | ⭐⭐⭐⭐ |

---

## 💡 快速试用

在 Neovim 中执行以下命令快速切换主题：

```vim
" 切换到 Gruvbox 暖色调
:colorscheme gruvbox

" 切换到 Tokyonight 夜晚
:colorscheme tokyonight-night

" 切换到 Kanagawa 水墨
:colorscheme kanagawa

" 切换到 Rose Pine 月亮
:colorscheme rose-pine-moon

" 使用 Telescope 浏览所有主题
:Telescope colorscheme
```

---

**最后更新**: 2026-01-20  
**支持的主题数**: 12 种
