# 快捷键快速参考 (Quick Keybindings Reference)

## 📝 常用编辑快捷键 (Common Editing Shortcuts)

### 文件操作 (File Operations)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `Ctrl + s` | 保存文件 | Save file |
| `<leader>fs` | 另存为 | Save As |
| `<leader>qq` | 退出所有 | Quit all |

### 复制粘贴 (Copy & Paste)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `Ctrl + c` | 复制到剪贴板 | Copy to clipboard |
| `Ctrl + x` | 剪切到剪贴板 | Cut to clipboard |
| `Ctrl + v` | 从剪贴板粘贴 | Paste from clipboard |
| `Ctrl + a` | 全选 | Select all |

### 撤销重做 (Undo & Redo)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `Ctrl + z` | 撤销 | Undo |
| `Ctrl + y` | 重做 | Redo |

### Visual 模式 (Visual Mode)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<` | 向左缩进（保持选中）| Indent left (keep selection) |
| `>` | 向右缩进（保持选中）| Indent right (keep selection) |
| `J` | 向下移动选中行 | Move selected lines down |
| `K` | 向上移动选中行 | Move selected lines up |

### 窗口导航 (Window Navigation)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `Ctrl + h` | 移到左窗口 | Go to left window |
| `Ctrl + j` | 移到下窗口 | Go to lower window |
| `Ctrl + k` | 移到上窗口 | Go to upper window |
| `Ctrl + l` | 移到右窗口 | Go to right window |

### 缓冲区导航 (Buffer Navigation)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `Shift + h` | 上一个缓冲区 | Previous buffer |
| `Shift + l` | 下一个缓冲区 | Next buffer |
| `<leader>bd` | 删除缓冲区 | Delete buffer |
| `<leader>bD` | 删除其他缓冲区 | Delete all buffers except current |

---

## 🐍 Python 开发 (Python Development)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>pv` | 选择虚拟环境 | Select VirtualEnv |
| `<leader>pt` | 调试测试方法 | Debug test method |
| `<leader>pc` | 调试测试类 | Debug test class |

---

## 🦀 Rust 开发 (Rust Development)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>rr` | Rust 可运行项 | Rust runnables |
| `<leader>rd` | Rust 可调试项 | Rust debuggables |
| `<leader>cR` | Rust 代码操作 | Rust code action |

---

## 📝 LaTeX 编写 (LaTeX Writing)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>ll` | 编译 LaTeX | Compile LaTeX |
| `<leader>lv` | 查看 PDF | View PDF |
| `<leader>lc` | 清理辅助文件 | Clean auxiliary files |
| `<leader>lt` | 打开目录 | Open TOC |
| `<leader>ls` | 停止编译 | Stop compilation |

---

## 📄 Markdown 编辑 (Markdown Editing)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>mp` | 切换预览 | Toggle Markdown preview |
| `<leader>mg` | 终端预览 | Glow terminal preview |
| `<leader>mt` | 表格模式 | Toggle table mode |
| `<leader>mT` | 生成目录 | Generate TOC |

---

## 🎨 主题切换 (Theme Switching)

| 命令 | 功能 | Description |
|------|------|-------------|
| `:colorscheme catppuccin` | 切换到 Catppuccin 主题 | Switch to Catppuccin theme |
| `:colorscheme tokyonight` | 切换到 Tokyonight 主题 | Switch to Tokyonight theme |
| `:set background=dark` | 切换到深色模式 | Switch to dark mode |
| `:set background=light` | 切换到浅色模式 | Switch to light mode |

### Catppuccin 风格切换 (Catppuccin Flavors)

在配置文件中修改 `lua/plugins/colorscheme.lua` 的 `flavour` 选项：

```lua
flavour = "mocha",  -- mocha (深夜), frappe (柔和深色), macchiato (中深色), latte (浅色)
```

或使用命令临时切换：

```vim
:Catppuccin mocha      " 深夜风格
:Catppuccin frappe     " 柔和深色
:Catppuccin macchiato  " 中深色
:Catppuccin latte      " 浅色风格
```

---

## 🐛 调试 (Debugging)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>db` | 切换断点 | Toggle breakpoint |
| `<leader>dB` | 条件断点 | Conditional breakpoint |
| `<leader>dc` | 继续执行 | Continue |
| `<leader>di` | 步入 | Step into |
| `<leader>do` | 步过 | Step over |
| `<leader>dO` | 步出 | Step out |
| `<leader>dt` | 终止调试 | Terminate |
| `<leader>du` | 切换 DAP UI | Toggle DAP UI |

---

## 💡 提示 (Tips)

- **Leader 键**: 默认为 `Space` (空格键)
- **系统剪贴板**: Ctrl+C/X/V 使用系统剪贴板，可以在 Neovim 和其他应用间复制粘贴
- **Visual 模式**: 选中文本后可以用 `<` 和 `>` 缩进，并保持选中状态
- **移动行**: Visual 模式下选中多行，用 `J` 和 `K` 上下移动

---

**注意**: 更多快捷键请查看完整文档 `README.md` 或在 Neovim 中按 `<leader>` 查看 which-key 提示
