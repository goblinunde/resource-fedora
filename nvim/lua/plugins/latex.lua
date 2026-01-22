-- =========================================================
-- LaTeX 学术写作环境配置 (LaTeX Academic Writing Configuration)
-- =========================================================
-- 功能说明 (Description):
--   完整的 LaTeX 学术写作工具链，遵循用户全局规则
--   Complete LaTeX academic writing toolchain following user's global rules
--   - IEEE/APS 期刊格式 (IEEE/APS journal formatting)
--   - Physics/PINNs 数学符号 (Physics/PINNs mathematical notation)
--   - PDE 专用片段 (PDE-specific snippets)
-- =========================================================

return {
  -- ---------------------------------------------------------
  -- LaTeX LSP: Texlab (功能强大的 LaTeX 语言服务器)
  -- LaTeX LSP: Texlab - Powerful LaTeX language server
  -- ---------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          -- 💡 Texlab LSP 配置 (Texlab LSP configuration)
          settings = {
            texlab = {
              -- 构建配置 (Build configuration)
              build = {
                executable = "latexmk", -- 💡 使用 latexmk 自动编译 (Use latexmk for auto-compilation)
                args = {
                  "-pdf",              -- 生成 PDF (Generate PDF)
                  "-interaction=nonstopmode",
                  "-synctex=1",        -- 💡 启用 SyncTeX 同步 (Enable SyncTeX sync)
                  "-pvc",              -- 持续预览模式 (Continuous preview mode)
                  "%f",
                },
                onSave = true,         -- 💡 保存时自动编译 (Auto-compile on save)
                forwardSearchAfter = true,
              },
              
              -- 💡 正向搜索配置: Zathura PDF 查看器 (Forward search: Zathura PDF viewer)
              forwardSearch = {
                executable = "zathura",
                args = { "--synctex-forward", "%l:1:%f", "%p" },
              },
              
              -- Chktex 语法检查 (Chktex linting)
              chktex = {
                onOpenAndSave = true,
                onEdit = false,
              },
              
              -- 诊断延迟 (Diagnostic delay)
              diagnosticsDelay = 300,
              
              -- 💡 启用符号折叠 (Enable symbol folding)
              formatterLineLength = 80,
            },
          },
        },
      },
    },
  },

  -- ---------------------------------------------------------
  -- VimTeX: 强大的 LaTeX 插件
  -- VimTeX: Powerful LaTeX plugin
  -- ---------------------------------------------------------
  {
    "lervag/vimtex",
    ft = { "tex", "latex" },
    config = function()
      -- 💡 VimTeX 全局配置 (VimTeX global configuration)
      vim.g.vimtex_view_method = "zathura"  -- PDF 查看器 (PDF viewer)
      vim.g.vimtex_compiler_method = "latexmk"
      
      -- 💡 Latexmk 编译器配置 (Latexmk compiler configuration)
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "build",  -- 💡 编译输出到 build 目录 (Build output to build dir)
        options = {
          "-pdf",
          "-shell-escape",    -- 💡 允许外部命令 (Allow external commands)
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
      
      -- 💡 语法高亮配置 (Syntax highlighting configuration)
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_syntax_conceal_disable = 0  -- 启用 conceal (Enable conceal)
      
      -- 💡 Quick fix 窗口自动打开 (Auto-open quickfix window)
      vim.g.vimtex_quickfix_mode = 2
      vim.g.vimtex_quickfix_open_on_warning = 0
      
      -- 💡 禁用某些警告 (Disable certain warnings)
      vim.g.vimtex_quickfix_ignore_filters = {
        "Underfull",
        "Overfull",
        "specifier changed to",
      }
      
      -- 💡 Fold 配置 (Folding configuration)
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_fold_manual = 0
      vim.g.vimtex_fold_types = {
        sections = {
          parse_levels = 1,
        },
      }
      
      -- 💡 格式化 (Formatting)
      vim.g.vimtex_format_enabled = 1
      
      -- 💡 自定义快捷键 (Custom keybindings)
      -- <localleader> 默认为 '\'
      vim.keymap.set("n", "<localleader>ll", "<cmd>VimtexCompile<CR>", { desc = "Toggle LaTeX compilation" })
      vim.keymap.set("n", "<localleader>lv", "<cmd>VimtexView<CR>", { desc = "View PDF" })
      vim.keymap.set("n", "<localleader>lc", "<cmd>VimtexClean<CR>", { desc = "Clean auxiliary files" })
      vim.keymap.set("n", "<localleader>lt", "<cmd>VimtexTocOpen<CR>", { desc = "Open TOC" })
    end,
  },

  -- ---------------------------------------------------------
  -- Tree-sitter: LaTeX 语法高亮
  -- Tree-sitter: LaTeX syntax highlighting
  -- ---------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "latex", "bibtex" })
      end
    end,
  },

  -- ---------------------------------------------------------
  -- LaTeX 代码片段 (遵循用户规则: physics, siunitx)
  -- LaTeX snippets (Following user rules: physics, siunitx)
  -- ---------------------------------------------------------
  {
    "L3MON4D3/LuaSnip",
    opts = function(_, opts)
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      
      -- 💡 LaTeX 专用代码片段 (LaTeX-specific snippets)
      ls.add_snippets("tex", {
        -- Document template with physics package
        s("template", {
          t({ "\\documentclass{article}", "" }),
          t({ "\\usepackage{physics}     % 💡 Operators: \\pdv, \\dv, \\grad", "" }),
          t({ "\\usepackage{siunitx}     % 💡 Units: \\SI{}{}, \\num{}", "" }),
          t({ "\\usepackage{amsmath}", "" }),
          t({ "\\usepackage{cleveref}   % 💡 智能引用 (Intelligent references)", "" }),
          t({ "", "" }),
          t({ "\\title{" }),
          i(1, "Title"),
          t({ "}", "" }),
          t({ "\\author{" }),
          i(2, "Author"),
          t({ "}", "" }),
          t({ "\\date{\\today}", "", "" }),
          t({ "\\begin{document}", "" }),
          t({ "\\maketitle", "", "" }),
          i(0),
          t({ "", "" }),
          t({ "\\end{document}" }),
        }),
        
        -- 💡 PDE: Heat equation (热方程)
        s("heat", {
          t("\\pdv{u}{t} = \\alpha \\laplacian u"),
        }),
        
        -- 💡 PDE: Wave equation (波动方程)
        s("wave", {
          t("\\pdv[2]{u}{t} = c^2 \\laplacian u"),
        }),
        
        -- 💡 Domain notation: Ω and ∂Ω
        s("domain", {
          t("\\Omega \\subseteq \\mathbb{R}^{"),
          i(1, "d"),
          t("}, \\quad \\partial\\Omega"),
        }),
        
        -- 💡 Physics package: partial derivative
        s("pdv", {
          t("\\pdv{"),
          i(1, "f"),
          t("}{"),
          i(2, "x"),
          t("}"),
        }),
        
        -- 💡 SI units
        s("si", {
          t("\\SI{"),
          i(1, "value"),
          t("}{"),
          i(2, "unit"),
          t("}"),
        }),
        
        -- Figure environment
        s("fig", {
          t({ "\\begin{figure}[htbp]", "" }),
          t({ "  \\centering", "" }),
          t({ "  \\includegraphics[width=0.8\\textwidth]{" }),
          i(1, "path/to/image"),
          t({ "}", "" }),
          t({ "  \\caption{" }),
          i(2, "Caption"),
          t({ "}", "" }),
          t({ "  \\label{fig:" }),
          i(3, "label"),
          t({ "}", "" }),
          t({ "\\end{figure}" }),
        }),
        
        -- Equation environment
        s("eq", {
          t({ "\\begin{equation}", "" }),
          t({ "  \\label{eq:" }),
          i(1, "label"),
          t({ "}", "" }),
          t({ "  " }),
          i(2, "equation"),
          t({ "", "\\end{equation}" }),
        }),
        
        -- 💡 Academic reference with cleveref
        s("ref", {
          t("\\cref{"),
          i(1, "label"),
          t("}"),
        }),
      })
      
      return opts
    end,
  },

  -- ---------------------------------------------------------
  -- Mason: 确保 LaTeX 工具已安装
  -- Mason: Ensure LaTeX tools are installed
  -- ---------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "texlab",        -- LaTeX LSP
        "latexindent",   -- LaTeX formatter
      })
    end,
  },

  -- ---------------------------------------------------------
  -- Formatting: latexindent
  -- Formatting: latexindent - LaTeX code formatter
  -- ---------------------------------------------------------
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        tex = { "latexindent" },
        latex = { "latexindent" },
      },
    },
  },
}
