# Markdown 预览与主题切换指南

## 📄 Markdown 预览功能

### 1️⃣ Neovim 内置渲染 (最快速) ⭐

**快捷键**: `<leader>mr` (默认 leader 是 `Space`，即 `空格 + m + r`)

**功能特性**:

- ✅ **即时渲染**：无需外部程序,直接在 Neovim 内显示
- ✅ **精美样式**：
  - 标题使用不同颜色和图标 (󰲡 󰲣 󰲥)
  - 代码块带背景高亮
  - 列表使用符号 (●、○、◆、◇)
  - 复选框图标化 (󰄱 ✓)
  - 引用块带左侧边栏
  - 链接和图片带图标 (󰌹 󰥶)
- ✅ **表格美化**：使用 Unicode 边框字符
- ✅ **零延迟**：编辑即可见效果
- ✅ **深青主题**：配色与编辑器主题一致

**使用步骤**:

```bash
1. 打开任意 .md 文件
2. 按 Space + m + r 切换渲染
3. 立即看到渲染效果
4. 再按一次关闭渲染,显示原始 Markdown
```

**效果预览**:

原始 Markdown:

```
# 标题一
## 标题二
- [ ] 待办事项
- [x] 已完成
```

渲染后显示:

```
󰲡 标题一 (深青色加粗)
󰲣 标题二 (青色加粗)
● 󰄱 待办事项
● 󰱒 已完成
```

### 2️⃣ 浏览器预览 (功能最全)

**快捷键**: `<leader>mp` (默认 leader 是 `Space`，即 `空格 + m + p`)

**功能特性**:

- ✅ 实时预览：编辑时自动刷新
- ✅ 同步滚动：编辑器与预览同步
- ✅ 深色主题：配置为深色主题，适合夜间使用
- ✅ 支持 Mermaid 图表、LaTeX 数学公式等

**使用步骤**:

```bash
1. 打开任意 .md 文件
2. 按 Space + m + p
3. 浏览器自动打开预览页面
4. 编辑文件时预览自动刷新
5. 关闭 Neovim 缓冲区时预览自动关闭
```

### 3️⃣ 终端预览 (轻量级)

**快捷键**: `<leader>mg` (即 `空格 + m + g`)

**使用场景**:

- 快速查看格式效果，无需打开浏览器
- SSH 远程环境
- 轻量级预览需求

**前提条件**:

```bash
# 需要先安装 glow
sudo dnf install glow  # Fedora
```

---

## 📝 Markdown 增强编辑

### 表格编辑模式

**快捷键**: `<leader>mt` (即 `空格 + m + t`)

**功能**: 自动格式化 Markdown 表格

**使用示例**:

```markdown
# 启用表格模式后，输入以下内容会自动格式化：
|Name|Age
|John|25

# 自动变成：
| Name | Age |
|------|-----|
| John | 25  |
```

### 生成目录 (TOC)

**快捷键**: `<leader>mT` (即 `空格 + m + Shift+t`)

**功能**: 根据标题自动生成 GitHub 风格的目录

**使用示例**:

```markdown
<!-- 在文档顶部按 Space+m+T，自动生成： -->

<!-- TOC -->
- [标题一](#标题一)
  - [子标题](#子标题)
- [标题二](#标题二)
<!-- /TOC -->
```

### 智能列表

**自动功能**:

- ✅ 按 Enter 自动创建新列表项
- ✅ 智能缩进
- ✅ 复选框自动补全

**示例**:

```markdown
- [ ] 任务一
- [x] 任务二  ← 按 Enter 会自动创建新的 - [ ]
  - [ ] 子任务  ← 自动缩进
```

---

## 🎨 主题切换完整指南

### 方法 1: 切换主题

在 Neovim 命令模式下输入：

```vim
:colorscheme catppuccin   " 切换到 Catppuccin 主题
:colorscheme tokyonight   " 切换到 Tokyonight 主题
```

### 方法 2: Catppuccin 风格切换

Catppuccin 有 4 种风格可选：

| 风格 | 描述 | 适用场景 |
|------|------|---------|
| `mocha` | 深夜风格（最深） | 夜间编码，护眼 |
| `macchiato` | 中深色 | 全天候使用 |
| `frappe` | 柔和深色 | 白天使用 |
| `latte` | 浅色风格 | 明亮环境 |

**临时切换**（命令模式）：

```vim
:Catppuccin mocha
:Catppuccin frappe
:Catppuccin macchiato
:Catppuccin latte
```

**永久切换**（修改配置文件）：

编辑 `lua/plugins/colorscheme.lua` 第 21 行：

```lua
flavour = "mocha",  -- 改为 frappe, macchiato, latte 等
```

### 方法 3: 明暗模式切换

```vim
:set background=dark   " 切换到深色模式
:set background=light  " 切换到浅色模式
```

### 方法 4: 创建快捷键（可选）

在 `lua/config/keymaps.lua` 中添加：

```lua
-- 主题快速切换
vim.keymap.set("n", "<leader>td", "<cmd>set background=dark<cr>", { desc = "Dark mode" })
vim.keymap.set("n", "<leader>tl", "<cmd>set background=light<cr>", { desc = "Light mode" })
vim.keymap.set("n", "<leader>tm", "<cmd>Catppuccin mocha<cr>", { desc = "Mocha theme" })
vim.keymap.set("n", "<leader>tf", "<cmd>Catppuccin frappe<cr>", { desc = "Frappe theme" })
```

---

## 🚀 快速测试

### 测试 Markdown 预览

1. 创建测试文件：

```bash
nvim ~/test.md
```

1. 添加内容：

```markdown
# 测试标题

## 代码块
```python
def hello():
    print("Hello, World!")
\`\`\`

## 表格
| 名字 | 年龄 |
|------|------|
| 张三 | 25   |

## 数学公式
$$E = mc^2$$
```

1. 按 `Space + m + p` 预览

### 测试主题切换

在 Neovim 命令模式下依次尝试：

```vim
:Catppuccin mocha
:Catppuccin latte
:set background=dark
:set background=light
```

---

## 📌 常见问题

### Q: Markdown 预览无法打开浏览器？

**A**: 首次使用需要构建插件，重启 Neovim 并运行：

```vim
:Lazy sync
:checkhealth markdown-preview
```

### Q: Glow 命令找不到？

**A**: 需要安装 glow：

```bash
sudo dnf install glow
```

### Q: 想要永久修改主题风格？

**A**: 编辑 `lua/plugins/colorscheme.lua`，修改 `flavour` 配置项。

### Q: 如何查看所有可用主题？

**A**: 在命令模式输入 `:colorscheme` 然后按 Tab 键自动补全。

---

## 🎯 推荐配置

根据你的使用环境，推荐以下配置：

**夜间编码**:

```lua
flavour = "mocha"         -- 深夜风格
background = "dark"       -- 深色背景
```

**全天候使用**:

```lua
flavour = "macchiato"     -- 中深色
background = "dark"       -- 深色背景
```

**明亮环境**:

```lua
flavour = "latte"         -- 浅色风格
background = "light"      -- 浅色背景
```

---

**提示**: 所有配置修改后需要重启 Neovim 或运行 `:source %` 使其生效。
