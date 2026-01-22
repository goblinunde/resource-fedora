-- =========================================================
-- 自动命令配置 (Autocmds Configuration)
-- =========================================================
-- 功能说明 (Description):
--   自定义自动命令，增强编辑器行为
--   Custom autocmds to enhance editor behavior
-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- =========================================================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ---------------------------------------------------------
-- 文件类型特定设置 (Filetype-specific Settings)
-- ---------------------------------------------------------

-- 💡 恢复光标位置 (Restore cursor position)
-- 打开文件时恢复到上次编辑的位置
-- Restore cursor to last edit position when opening files
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Restore cursor position",
})

-- 💡 高亮复制的文本 (Highlight yanked text)
augroup("HighlightYank", { clear = true })
autocmd("TextYankPost", {
  group = "HighlightYank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  desc = "Highlight yanked text",
})

-- 💡 自动保存时去除行尾空格 (Remove trailing whitespace on save)
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  callback = function()
    -- 💡 排除某些文件类型 (Exclude certain filetypes)
    local exclude_ft = { "markdown", "diff" }
    if not vim.tbl_contains(exclude_ft, vim.bo.filetype) then
      local save_cursor = vim.fn.getpos(".")
      vim.cmd([[%s/\s\+$//e]])
      vim.fn.setpos(".", save_cursor)
    end
  end,
  desc = "Remove trailing whitespace on save",
})

-- 💡 大文件优化 (Large file optimization)
-- 禁用某些功能以提高性能 (Disable features for better performance)
augroup("LargeFile", { clear = true })
autocmd("BufReadPre", {
  group = "LargeFile",
  pattern = "*",
  callback = function()
    local max_filesize = 1024 * 1024 -- 1MB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > max_filesize then
      vim.opt_local.syntax = "off"         -- 💡 禁用语法高亮 (Disable syntax)
      vim.opt_local.swapfile = false       -- 💡 禁用交换文件 (Disable swapfile)
      vim.opt_local.undofile = false       -- 💡 禁用撤销文件 (Disable undofile)
      vim.opt_local.loadplugins = false    -- 💡 禁用插件 (Disable plugins)
      vim.cmd("syntax clear")
    end
  end,
  desc = "Optimize large file handling",
})

-- ---------------------------------------------------------
-- 终端设置 (Terminal Settings)
-- ---------------------------------------------------------

-- 💡 终端模式自动进入插入模式 (Auto enter insert mode in terminal)
augroup("TerminalSettings", { clear = true })
autocmd("TermOpen", {
  group = "TerminalSettings",
  pattern = "*",
  callback = function()
    vim.opt_local.number = false         -- 💡 禁用行号 (Disable line numbers)
    vim.opt_local.relativenumber = false -- 💡 禁用相对行号 (Disable relative numbers)
    vim.opt_local.signcolumn = "no"      -- 💡 禁用符号列 (Disable sign column)
    vim.cmd("startinsert")               -- 💡 自动进入插入模式 (Auto insert mode)
  end,
  desc = "Terminal settings",
})

-- 💡 退出终端时自动关闭缓冲区 (Auto close terminal buffer on exit)
autocmd("TermClose", {
  group = "TerminalSettings",
  pattern = "*",
  callback = function()
    if vim.v.event.status == 0 then
      vim.cmd("bdelete!")
    end
  end,
  desc = "Auto close terminal buffer",
})

-- ---------------------------------------------------------
-- 窗口和缓冲区管理 (Window and Buffer Management)
-- ---------------------------------------------------------

-- 💡 自动调整窗口大小 (Auto resize windows)
augroup("ResizeWindows", { clear = true })
autocmd("VimResized", {
  group = "ResizeWindows",
  pattern = "*",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
  desc = "Auto resize windows on terminal resize",
})

-- 💡 关闭某些文件类型时使用 q (Close certain filetypes with q)
augroup("CloseWithQ", { clear = true })
autocmd("FileType", {
  group = "CloseWithQ",
  pattern = {
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "startuptime",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Close certain filetypes with q",
})

-- ---------------------------------------------------------
-- 编辑增强 (Editing Enhancements)
-- ---------------------------------------------------------

-- 💡 自动创建目录 (Auto create directories)
-- 保存文件时自动创建不存在的目录
-- Auto create non-existent directories when saving files
augroup("AutoCreateDir", { clear = true })
autocmd("BufWritePre", {
  group = "AutoCreateDir",
  pattern = "*",
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto create directories on save",
})

-- 💡 检测文件变更 (Detect file changes)
augroup("CheckFileChanges", { clear = true })
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = "CheckFileChanges",
  command = "checktime",
  desc = "Check if file changed outside of Neovim",
})

-- ---------------------------------------------------------
-- Python 专用自动命令 (Python-specific Autocmds)
-- ---------------------------------------------------------

-- 💡 Python 文件保存时自动格式化导入 (Auto format imports on save)
augroup("PythonSettings", { clear = true })
autocmd("BufWritePre", {
  group = "PythonSettings",
  pattern = "*.py",
  callback = function()
    -- 💡 确保在保存前格式化 (Ensure formatting before save)
    -- conform.nvim 会自动处理，这里可以添加额外的检查
  end,
  desc = "Python file save settings",
})

-- ---------------------------------------------------------
-- Rust 专用自动命令 (Rust-specific Autocmds)
-- ---------------------------------------------------------

-- 💡 Rust 文件保存时自动运行 clippy (Auto run clippy on save)
augroup("RustSettings", { clear = true })
autocmd("BufWritePost", {
  group = "RustSettings",
  pattern = "*.rs",
  callback = function()
    -- 💡 rust-analyzer 会自动运行 clippy
    -- rust-analyzer will auto run clippy
  end,
  desc = "Rust file save settings",
})

-- ---------------------------------------------------------
-- LaTeX 专用自动命令 (LaTeX-specific Autocmds)
-- ---------------------------------------------------------

-- 💡 LaTeX 文件保存时自动编译 (Auto compile on save)
augroup("LaTeXSettings", { clear = true })
autocmd("BufWritePost", {
  group = "LaTeXSettings",
  pattern = "*.tex",
  callback = function()
    -- 💡 VimTeX 会自动处理编译 (VimTeX handles compilation)
    -- 这里可以添加额外的后处理 (Additional post-processing can be added here)
  end,
  desc = "LaTeX file save settings",
})

-- ---------------------------------------------------------
-- PDF 查看专用自动命令 (PDF Viewing-specific Autocmds)
-- ---------------------------------------------------------

-- 💡 PDF 文件自动打开 (Auto open PDF files with PDFview)
-- 注意: PDF 自动命令在 lua/plugins/pdfview.lua 中定义
-- Note: PDF autocmds are defined in lua/plugins/pdfview.lua
-- 功能: 打开 *.pdf 文件时自动使用 PDFview 插件查看
-- Feature: Automatically use PDFview plugin when opening *.pdf files

-- ---------------------------------------------------------
-- UI 增强 (UI Enhancements)
-- ---------------------------------------------------------

-- 💡 光标行高亮仅在当前窗口 (Cursorline only in current window)
augroup("CursorLine", { clear = true })
autocmd({ "InsertLeave", "WinEnter" }, {
  group = "CursorLine",
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "neo-tree" then
      vim.opt_local.cursorline = true
    end
  end,
  desc = "Enable cursorline in current window",
})

autocmd({ "InsertEnter", "WinLeave" }, {
  group = "CursorLine",
  pattern = "*",
  callback = function()
    vim.opt_local.cursorline = false
  end,
  desc = "Disable cursorline in other windows",
})
