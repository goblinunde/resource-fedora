-- =========================================================
-- Neovim 选项配置 (Neovim Options Configuration)
-- =========================================================
-- 功能说明 (Description):
--   自定义 Neovim 选项，遵循用户全局规则
--   Custom Neovim options following user's global rules
-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- =========================================================

local opt = vim.opt

-- ---------------------------------------------------------
-- 字体配置 (Font Configuration)
-- ---------------------------------------------------------
-- 💡 使用 0xProto Nerd Font Mono (遵循用户规则)
-- Use 0xProto Nerd Font Mono (Following user rules)
opt.guifont = "0xProto Nerd Font Mono:h12"

-- ---------------------------------------------------------
-- 编辑器行为 (Editor Behavior)
-- ---------------------------------------------------------
-- 💡 启用相对行号 (Enable relative line numbers)
opt.relativenumber = true
opt.number = true

-- 💡 Tab 和缩进设置 (Tab and indentation settings)
opt.tabstop = 4        -- 显示 tab 为 4 个空格 (Display tab as 4 spaces)
opt.shiftwidth = 4     -- 缩进宽度 (Indentation width)
opt.expandtab = true   -- 使用空格代替 tab (Use spaces instead of tabs)
opt.smartindent = true -- 智能缩进 (Smart indentation)

-- 💡 搜索设置 (Search settings)
opt.ignorecase = true  -- 搜索忽略大小写 (Ignore case in search)
opt.smartcase = true   -- 智能大小写搜索 (Smart case search)

-- 💡 外观设置 (Appearance settings)
opt.termguicolors = true  -- 启用真彩色 (Enable true colors)
opt.cursorline = true     -- 高亮当前行 (Highlight current line)
opt.signcolumn = "yes"    -- 总是显示符号列 (Always show sign column)

-- 💡 智能软换行设置 (Smart soft wrapping)
opt.wrap = true           -- 启用自动换行 (Enable line wrapping)
opt.linebreak = true      -- 在单词边界换行，而非字符中间 (Break at word boundaries)
opt.breakindent = true    -- 保持换行后的缩进 (Preserve indentation on wrapped lines)
opt.showbreak = "↪ "      -- 换行标记 (Mark wrapped lines with this symbol)

-- 💡 滚动设置 (Scrolling settings)
opt.scrolloff = 8         -- 光标上下保留8行 (Keep 8 lines above/below cursor)
opt.sidescrolloff = 8     -- 光标左右保留8列 (Keep 8 columns left/right of cursor)

-- 💡 分割窗口 (Split windows)
opt.splitbelow = true     -- 水平分割在下方 (Horizontal splits below)
opt.splitright = true     -- 垂直分割在右侧 (Vertical splits to the right)

-- 💡 文件编码 (File encoding)
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- ---------------------------------------------------------
-- Python 专用配置 (Python-specific Configuration)
-- ---------------------------------------------------------
-- 💡 Python3 provider 路径 (Python3 provider path)
-- 优先使用虚拟环境中的 Python (Prefer Python from virtual environment)
vim.g.python3_host_prog = vim.fn.exepath("python3") or "/usr/bin/python3"

-- 💡 Python 缩进: 4 个空格 (Python indentation: 4 spaces)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- ---------------------------------------------------------
-- LaTeX 专用配置 (LaTeX-specific Configuration)
-- ---------------------------------------------------------
-- 💡 LaTeX 编辑器设置 (LaTeX editor settings)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "latex" },
  callback = function()
    vim.opt_local.wrap = true           -- 💡 LaTeX 启用自动换行 (Enable wrapping for LaTeX)
    vim.opt_local.linebreak = true      -- 在单词边界换行 (Break at word boundaries)
    vim.opt_local.spell = true          -- 启用拼写检查 (Enable spell checking)
    vim.opt_local.spelllang = "en_us"   -- 英文拼写检查 (English spell checking)
    vim.opt_local.conceallevel = 2      -- 💡 启用 conceal 隐藏 LaTeX 命令 (Enable conceal)
  end,
})

-- ---------------------------------------------------------
-- Rust 专用配置 (Rust-specific Configuration)
-- ---------------------------------------------------------
-- 💡 Rust 缩进: 4 个空格 (Rust indentation: 4 spaces)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    -- 💡 启用 inlay hints (Enable inlay hints)
    vim.lsp.inlay_hint.enable(true)
  end,
})

-- ---------------------------------------------------------
-- 性能优化 (Performance Optimization)
-- ---------------------------------------------------------
-- 💡 更新时间 (Update time)
opt.updatetime = 200      -- 更快的 CursorHold 事件 (Faster CursorHold events)
opt.timeoutlen = 300      -- 快捷键超时时间 (Keymap timeout)

-- 💡 撤销文件 (Undo file)
opt.undofile = true
opt.undolevels = 10000
