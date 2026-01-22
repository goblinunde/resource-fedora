-- =========================================================
-- 自定义快捷键 (Custom Keymaps Configuration)
-- =========================================================
-- 功能说明 (Description):
--   自定义快捷键映射，增强开发体验
--   Custom keymaps to enhance development experience
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- =========================================================

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ---------------------------------------------------------
-- Leader 键设置 (Leader key setting)
-- ---------------------------------------------------------
-- 💡 Leader key 已在 LazyVim 中设置为空格 (Leader key is space in LazyVim)
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"  -- LaTeX 等文件类型的 local leader

-- ---------------------------------------------------------
-- 通用编辑快捷键 (General Editing Keymaps)
-- ---------------------------------------------------------
-- 💡 保存文件 (Save file)
keymap.set("n", "<C-s>", "<cmd>w<cr>", vim.tbl_extend("force", opts, { desc = "Save file" }))
keymap.set("i", "<C-s>", "<cmd>w<cr><esc>", vim.tbl_extend("force", opts, { desc = "Save file and exit insert" }))
keymap.set("v", "<C-s>", "<cmd>w<cr>", vim.tbl_extend("force", opts, { desc = "Save file" }))

-- 💡 另存为 (Save as)
keymap.set("n", "<leader>fs", function()
  local new_name = vim.fn.input("Save as: ", vim.fn.expand("%"), "file")
  if new_name ~= "" and new_name ~= vim.fn.expand("%") then
    vim.cmd("saveas " .. new_name)
  end
end, vim.tbl_extend("force", opts, { desc = "Save As" }))

-- 💡 全选 (Select all)
keymap.set("n", "<C-a>", "ggVG", vim.tbl_extend("force", opts, { desc = "Select all" }))

-- 💡 复制粘贴撤销 (Copy, Paste, Undo, Redo)
-- 使用系统剪贴板 (Use system clipboard)
keymap.set({ "n", "v" }, "<C-c>", '"+y', vim.tbl_extend("force", opts, { desc = "Copy to clipboard" }))
keymap.set({ "n", "v" }, "<C-x>", '"+d', vim.tbl_extend("force", opts, { desc = "Cut to clipboard" }))
keymap.set({ "n", "i" }, "<C-v>", '"+p', vim.tbl_extend("force", opts, { desc = "Paste from clipboard" }))
keymap.set("v", "<C-v>", '"+p', vim.tbl_extend("force", opts, { desc = "Paste from clipboard" }))

-- 💡 撤销和重做 (Undo and Redo)
keymap.set("n", "<C-z>", "u", vim.tbl_extend("force", opts, { desc = "Undo" }))
keymap.set("i", "<C-z>", "<C-o>u", vim.tbl_extend("force", opts, { desc = "Undo" }))
keymap.set("n", "<C-y>", "<C-r>", vim.tbl_extend("force", opts, { desc = "Redo" }))
keymap.set("i", "<C-y>", "<C-o><C-r>", vim.tbl_extend("force", opts, { desc = "Redo" }))

-- 💡 Visual 模式下保持选中 (Keep selection after indent)
keymap.set("v", "<", "<gv", vim.tbl_extend("force", opts, { desc = "Indent left" }))
keymap.set("v", ">", ">gv", vim.tbl_extend("force", opts, { desc = "Indent right" }))

-- 💡 移动选中的行 (Move selected lines)
keymap.set("v", "J", ":m '>+1<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move line down" }))
keymap.set("v", "K", ":m '<-2<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move line up" }))

-- 💡 更好的上下移动 (Better up/down movement)
keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- 💡 窗口导航 (Window navigation)
keymap.set("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Go to left window" }))
keymap.set("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Go to lower window" }))
keymap.set("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Go to upper window" }))
keymap.set("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Go to right window" }))

-- 💡 缓冲区导航 (Buffer navigation)
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", vim.tbl_extend("force", opts, { desc = "Prev buffer" }))
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", vim.tbl_extend("force", opts, { desc = "Next buffer" }))
keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", vim.tbl_extend("force", opts, { desc = "Delete buffer" }))
keymap.set("n", "<leader>bD", "<cmd>%bd|e#<cr>", vim.tbl_extend("force", opts, { desc = "Delete all buffers except current" }))


-- ---------------------------------------------------------
-- Python 开发快捷键 (Python Development Keymaps)
-- ---------------------------------------------------------
-- 💡 Python 虚拟环境选择 (Python virtual environment selection)
keymap.set("n", "<leader>pv", "<cmd>VenvSelect<cr>", vim.tbl_extend("force", opts, { desc = "Select Python VirtualEnv" }))

-- 💡 Python 调试快捷键 (Python debugging keymaps)
keymap.set("n", "<leader>pt", function()
  require("dap-python").test_method()
end, vim.tbl_extend("force", opts, { desc = "Debug Python Test Method" }))

keymap.set("n", "<leader>pc", function()
  require("dap-python").test_class()
end, vim.tbl_extend("force", opts, { desc = "Debug Python Test Class" }))

-- ---------------------------------------------------------
-- Rust 开发快捷键 (Rust Development Keymaps)
-- ---------------------------------------------------------
-- 💡 Rust 快捷键在 rust.lua 中已定义 (Rust keymaps defined in rust.lua)
-- 这里添加额外的便捷快捷键 (Additional convenience keymaps)
keymap.set("n", "<leader>rr", "<cmd>RustRunnables<cr>", vim.tbl_extend("force", opts, { desc = "Rust Runnables" }))
keymap.set("n", "<leader>rd", "<cmd>RustDebuggables<cr>", vim.tbl_extend("force", opts, { desc = "Rust Debuggables" }))

-- ---------------------------------------------------------
-- C/C++ 开发快捷键 (C/C++ Development Keymaps)
-- ---------------------------------------------------------
-- 💡 注意: C/C++ 快捷键由 quick-c 插件提供
-- Note: C/C++ keymaps provided by quick-c plugin
-- 插件配置文件: lua/plugins/quickc.lua

-- 💡 快速构建 (<leader>cqb) - 在 quickc.lua 中定义
-- 💡 运行程序 (<leader>cqr) - 在 quickc.lua 中定义
-- 💡 构建并运行 (<leader>cqR) - 在 quickc.lua 中定义
-- 💡 调试程序 (<leader>cqD) - 在 quickc.lua 中定义
-- 💡 Make 目标 (<leader>cqM) - 在 quickc.lua 中定义
-- 💡 CMake 配置 (<leader>cqc) - 在 quickc.lua 中定义

-- ---------------------------------------------------------
-- Git 工作流快捷键 (Git Workflow Keymaps)
-- ---------------------------------------------------------
-- 💡 注意: Git 快捷键由 git.lua 插件提供
-- Note: Git keymaps provided by git.lua plugins
-- 插件配置文件: lua/plugins/git.lua

-- 💡 LazyGit (<leader>gg) - 在 git.lua 中定义
-- 💡 Git Status (<leader>gs) - 在 git.lua 中定义
-- 💡 Git Diff (<leader>gd) - 在 git.lua 中定义
-- 💡 Git Blame (<leader>gb) - 在 git.lua 中定义
-- 💡 Stage Hunk (<leader>hs) - 在 git.lua 中定义
-- 💡 Next Hunk (]h) - 在 git.lua 中定义

-- ---------------------------------------------------------
-- Markdown 编写快捷键 (Markdown Writing Keymaps)
-- ---------------------------------------------------------
-- 💡 切换 Markdown 渲染 (Toggle Markdown rendering)
-- (已在 markdown.lua 中定义为 <leader>mr)

-- 💡 Markdown 预览 (Markdown preview in browser)
-- (已在 markdown.lua 中定义为 <leader>mp)

-- 💡 Glow 终端预览 (Glow terminal preview)
-- (已在 markdown.lua 中定义为 <leader>mg)

-- 💡 生成 TOC (Generate table of contents)
-- (已在 markdown.lua 中定义为 <leader>mT)

-- 💡 表格模式切换 (Toggle table mode)
-- (已在 markdown.lua 中定义为 <leader>mt)

-- ---------------------------------------------------------
-- LaTeX 编写快捷键 (LaTeX Writing Keymaps)
-- ---------------------------------------------------------
-- 💡 注意: VimTeX 的主要快捷键使用 localleader (\)
-- Note: Main VimTeX keymaps use localleader (\)

-- 💡 快速编译 LaTeX (Quick compile LaTeX)
keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<cr>", vim.tbl_extend("force", opts, { desc = "LaTeX Compile" }))

-- 💡 查看 PDF (View PDF)
keymap.set("n", "<leader>lv", "<cmd>VimtexView<cr>", vim.tbl_extend("force", opts, { desc = "LaTeX View PDF" }))

-- 💡 清理辅助文件 (Clean auxiliary files)
keymap.set("n", "<leader>lc", "<cmd>VimtexClean<cr>", vim.tbl_extend("force", opts, { desc = "LaTeX Clean" }))

-- 💡 打开目录 (Open TOC)
keymap.set("n", "<leader>lt", "<cmd>VimtexTocOpen<cr>", vim.tbl_extend("force", opts, { desc = "LaTeX TOC" }))

-- 💡 停止编译 (Stop compilation)
keymap.set("n", "<leader>ls", "<cmd>VimtexStop<cr>", vim.tbl_extend("force", opts, { desc = "LaTeX Stop" }))

-- ---------------------------------------------------------
-- PDF 查看快捷键 (PDF Viewing Keymaps)
-- ---------------------------------------------------------
-- 💡 注意: PDF 查看功能由 PDFview 插件提供
-- Note: PDF viewing functionality provided by PDFview plugin
-- 插件配置文件: lua/plugins/pdfview.lua

-- 💡 打开 PDF (<leader>po) - 在 pdfview.lua 中定义
-- 💡 下一页 (<leader>pn, <leader>jj) - 在 pdfview.lua 中定义  
-- 💡 上一页 (<leader>pp, <leader>kk) - 在 pdfview.lua 中定义

-- ---------------------------------------------------------
-- LSP 快捷键增强 (LSP Keymap Enhancement)
-- ---------------------------------------------------------
-- 💡 格式化代码 (Format code) - 已在 formatting.lua 中定义
-- keymap.set({ "n", "v" }, "<leader>cf", function()
--   require("conform").format({ async = true, lsp_fallback = true })
-- end, vim.tbl_extend("force", opts, { desc = "Format" }))

-- 💡 代码操作 (Code action)
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))

-- 💡 重命名符号 (Rename symbol)
keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))

-- ---------------------------------------------------------
-- 终端快捷键 (Terminal Keymaps)
-- ---------------------------------------------------------
-- 💡 打开浮动终端 (Open floating terminal)
keymap.set("n", "<leader>ft", function()
  LazyVim.terminal()
end, vim.tbl_extend("force", opts, { desc = "Terminal (cwd)" }))

-- 💡 终端模式下的 ESC (ESC in terminal mode)
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", vim.tbl_extend("force", opts, { desc = "Exit terminal mode" }))

-- ---------------------------------------------------------
-- 其他便捷快捷键 (Other Convenient Keymaps)
-- ---------------------------------------------------------
-- 💡 切换软换行 (Toggle soft wrap)
keymap.set("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
  if vim.wo.wrap then
    print("✅ 软换行已启用 (Soft wrap enabled)")
  else
    print("❌ 软换行已禁用 (Soft wrap disabled)")
  end
end, vim.tbl_extend("force", opts, { desc = "Toggle wrap" }))

-- 💡 清除搜索高亮 (Clear search highlight)
keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", vim.tbl_extend("force", opts, { desc = "Clear search highlight" }))

-- 💡 快速退出 (Quick quit)
keymap.set("n", "<leader>qq", "<cmd>qa<cr>", vim.tbl_extend("force", opts, { desc = "Quit all" }))

-- ---------------------------------------------------------
-- Yazi 文件管理器 (Yazi File Manager)
-- ---------------------------------------------------------
-- 💡 注意: Yazi 文件管理器由 yazi.nvim 插件提供
-- Note: Yazi file manager functionality provided by yazi.nvim plugin
-- 插件配置文件: lua/plugins/yazi.lua

-- 💡 打开 Yazi (<leader>fy) - 在 yazi.lua 中定义
-- 💡 在工作目录打开 (<leader>fY) - 在 yazi.lua 中定义
-- 💡 恢复会话 (<leader>yr) - 在 yazi.lua 中定义

-- ---------------------------------------------------------
-- 文件预览功能 (File Preview Functionality)
-- ---------------------------------------------------------
-- 💡 文件预览核心函数 (Core file preview functions)
local FilePreview = {}

--- 预览当前文件 (Preview current file)
function FilePreview.preview_file()
  local file = vim.fn.expand("%:p")
  
  if vim.fn.filereadable(file) == 0 then
    vim.notify("❌ 文件不存在或无法读取", vim.log.levels.ERROR)
    return
  end

  local ext = vim.fn.fnamemodify(file, ":e"):lower()
  
  -- 支持的预览格式
  local preview_exts = {
    pdf = true, png = true, jpg = true, jpeg = true, gif = true, svg = true,
    webp = true, bmp = true, mp4 = true, mkv = true, avi = true, mov = true,
    mp3 = true, wav = true, flac = true, ogg = true, docx = true, xlsx = true,
    pptx = true, odt = true, ods = true, odp = true,
  }

  if not preview_exts[ext] and ext ~= "" then
    vim.notify("ℹ️  文件类型 '" .. ext .. "' 可能不支持预览", vim.log.levels.INFO)
  end

  vim.fn.jobstart({ "xdg-open", file }, {
    detach = true,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("✅ 已打开: " .. vim.fn.fnamemodify(file, ":t"), vim.log.levels.INFO)
      else
        vim.notify("❌ 无法打开文件", vim.log.levels.ERROR)
      end
    end,
  })
end

--- 在文件管理器中打开 (Open in file manager)
function FilePreview.open_in_file_manager()
  local file = vim.fn.expand("%:p")
  
  if vim.fn.filereadable(file) == 0 then
    vim.notify("❌ 文件不存在", vim.log.levels.ERROR)
    return
  end

  local dir = vim.fn.fnamemodify(file, ":h")
  
  vim.fn.jobstart({ "xdg-open", dir }, {
    detach = true,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("📂 已打开文件夹: " .. vim.fn.fnamemodify(dir, ":t"), vim.log.levels.INFO)
      end
    end,
  })
end

--- 用指定程序打开 (Open with specific program)
function FilePreview.open_with(program)
  local file = vim.fn.expand("%:p")
  
  if vim.fn.filereadable(file) == 0 then
    vim.notify("❌ 文件不存在", vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart({ program, file }, {
    detach = true,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("✅ 已用 " .. program .. " 打开", vim.log.levels.INFO)
      else
        vim.notify("❌ 无法用 " .. program .. " 打开", vim.log.levels.ERROR)
      end
    end,
  })
end

-- 💡 文件预览快捷键 (File preview keymaps)
keymap.set("n", "<leader>fp", FilePreview.preview_file, vim.tbl_extend("force", opts, { desc = "Preview File" }))
keymap.set("n", "<leader>fo", FilePreview.open_in_file_manager, vim.tbl_extend("force", opts, { desc = "Open in File Manager" }))
keymap.set("n", "<leader>fx", FilePreview.preview_file, vim.tbl_extend("force", opts, { desc = "Open with Default" }))

-- 💡 用特定程序打开 (Open with specific programs)
keymap.set("n", "<leader>fpe", function() FilePreview.open_with("evince") end, vim.tbl_extend("force", opts, { desc = "Open with Evince" }))
keymap.set("n", "<leader>fpz", function() FilePreview.open_with("zathura") end, vim.tbl_extend("force", opts, { desc = "Open with Zathura" }))
keymap.set("n", "<leader>fpi", function() FilePreview.open_with("eog") end, vim.tbl_extend("force", opts, { desc = "Open with EOG" }))
keymap.set("n", "<leader>fpv", function() FilePreview.open_with("mpv") end, vim.tbl_extend("force", opts, { desc = "Open with MPV" }))
