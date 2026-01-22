# 终端和 Tmux 集成指南

本文档介绍 LazyVim 的终端功能和 Tmux 集成使用方法。

---

## 🖥️ 终端功能 (Toggleterm)

### 基本使用

#### 打开终端的三种方式

1. **浮动终端** (推荐)

```vim
<leader>tt  " 打开/关闭浮动终端
Ctrl+\      " 快速切换浮动终端
```

1. **水平分割终端**

```vim
<leader>th  " 在下方打开终端
```

1. **垂直分割终端**

```vim
<leader>tv  " 在右侧打开终端
```

---

### 专用终端

#### LazyGit (Git 可视化工具)

```vim
<leader>tg  " 打开 LazyGit
```

在 LazyGit 中按 `?` 查看帮助

#### Python REPL

```vim
<leader>tp  " 打开 Python 交互式环境
```

#### Node.js REPL

```vim
<leader>tn  " 打开 Node.js 交互式环境
```

#### Htop (系统监控)

```vim
<leader>tH  " 打开 htop 系统监控
```

---

### 终端模式快捷键

在终端模式下的快捷键：

| 快捷键 | 功能 |
|--------|------|
| `<Esc>` | 退出终端模式到普通模式 |
| `jk` | 快速退出终端模式 |
| `<C-h>` | 跳转到左侧窗口 |
| `<C-j>` | 跳转到下方窗口 |
| `<C-k>` | 跳转到上方窗口 |
| `<C-l>` | 跳转到右侧窗口 |

---

### 发送代码到终端

#### 发送当前行

```vim
<leader>ts  " Normal 模式：发送当前行到终端执行
```

#### 发送选中代码

```vim
<leader>ts  " Visual 模式：发送选中的代码到终端
```

**使用场景**:

- 在编辑 Python 脚本时，选中几行代码发送到 Python REPL 测试
- 在编辑 JavaScript 时，发送代码片段到 Node REPL

---

### 终端命令

| 命令 | 功能 |
|------|------|
| `:ToggleTerm` | 打开/关闭终端 |
| `:TermExec cmd="ls"` | 在终端执行命令 |
| `:ToggleTermSendCurrentLine` | 发送当前行 |
| `:ToggleTermSendVisualSelection` | 发送选中内容 |

---

## 🔀 Tmux 集成 (vim-tmux-navigator)

### 什么是 Tmux Navigator?

无缝在 Neovim 窗口和 Tmux 面板之间导航，使用相同的快捷键 `<C-h/j/k/l>`。

### Tmux 配置要求

在你的 `~/.tmux.conf` 中添加以下配置：

```bash
# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

bind-key -n 'C-\\' if-shell "$is_vim" 'send-keys C-\\\\'  'select-pane -l'

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
bind-key -T copy-mode-vi 'C-\\' select-pane -l
```

### 导航快捷键

| 快捷键 | 功能 |
|--------|------|
| `<C-h>` | 向左导航 (Neovim 窗口 ↔ Tmux 面板) |
| `<C-j>` | 向下导航 |
| `<C-k>` | 向上导航 |
| `<C-l>` | 向右导航 |
| `<C-\\>` | 返回上一个面板 |

### 使用示例

1. **在 Tmux 中使用 Neovim**:
   - 打开 Tmux
   - 创建多个面板 (`Ctrl+b %` 垂直分割, `Ctrl+b "` 水平分割)
   - 在一个面板中打开 Neovim
   - 使用 `<C-h/j/k/l>` 在 Neovim 分屏和 Tmux 面板之间无缝切换

2. **典型工作流**:
   - 左侧: Neovim 编辑代码
   - 右上: 终端运行程序
   - 右下: Htop 监控系统
   - 使用 `<C-h/j/k/l>` 快速切换

---

## 🎯 实用场景

### 场景 1: Python 开发

```vim
" 1. 打开 Python 文件
:e script.py

" 2. 打开 Python REPL
<leader>tp

" 3. 写一些代码后选中发送到 REPL 测试
:visual mode -> select code -> <leader>ts
```

### 场景 2: Git 工作流

```vim
" 1. 编辑代码
:e myfile.py

" 2. 打开 LazyGit 查看变更
<leader>tg

" 3. 在 LazyGit 中暂存、提交
" 按 ? 查看 LazyGit 快捷键
```

### 场景 3: 多任务监控

```vim
" 1. 垂直分割打开终端运行服务器
<leader>tv
> npm run dev

" 2. 水平分割打开 Htop 监控
<leader>tH

" 3. 主窗口继续编辑代码
<C-h>  " 返回编辑器
```

---

## ⚙️ 自定义配置

### 修改浮动终端大小

编辑 `lua/plugins/terminal.lua`:

```lua
opts = {
  size = function(term)
    if term.direction == "horizontal" then
      return 20  -- 修改水平终端高度
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.5  -- 修改垂直终端宽度
    end
  end,
}
```

### 添加自定义终端

在 `lua/plugins/terminal.lua` 中添加:

```lua
-- Julia REPL
local julia = Terminal:new({
  cmd = "julia",
  direction = "float",
  close_on_exit = false,
})

function _JULIA_TOGGLE()
  julia:toggle()
end

-- 在 keys 中添加快捷键
{ "<leader>tj", "<cmd>lua _JULIA_TOGGLE()<cr>", desc = "Toggle Julia REPL" },
```

---

## 💡 最佳实践

1. **使用浮动终端执行快速命令**
   - `<leader>tt` 快速打开
   - 执行命令后 `<Esc>` 或 `jk` 退出

2. **使用分割终端做长期任务**
   - `<leader>tv` 开启服务器
   - `<C-h>` 切回编辑器继续工作

3. **使用 LazyGit 管理 Git**
   - `<leader>tg` 打开 LazyGit
   - 比命令行 Git 更直观

4. **Tmux + Neovim 组合**
   - Tmux 管理会话
   - Neovim 内部分屏
   - 无缝导航两者

---

## 🔧 故障排除

### 问题: Tmux 导航不工作

**解决方案**:

1. 检查 `~/.tmux.conf` 是否添加了配置
2. 重新加载 Tmux 配置: `tmux source-file ~/.tmux.conf`
3. 确认 Tmux 版本 >= 2.0

### 问题: 终端中文显示乱码

**解决方案**:

```vim
" 在 init.lua 或 options.lua 中添加
vim.opt.encoding = "utf-8"
```

### 问题: LazyGit 未安装

**解决方案**:

```bash
# Fedora 43
sudo dnf install lazygit
```

---

**最后更新**: 2026-01-20
