-- =========================================================
-- Tree-sitter 配置 (Tree-sitter Configuration)
-- =========================================================
-- 功能说明 (Description):
--   Tree-sitter 语法高亮增强配置
--   Enhanced syntax highlighting with Tree-sitter
-- =========================================================

return {
  -- ---------------------------------------------------------
  -- Tree-sitter 核心配置
  -- Tree-sitter core configuration
  -- ---------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      -- 💡 确保安装的语言解析器 (Ensure installed language parsers)
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",      -- 💡 Python support
        "rust",        -- 💡 Rust support
        "latex",       -- 💡 LaTeX support
        "bibtex",      -- 💡 BibTeX support
        "toml",
        "yaml",
        "vim",
        "vimdoc",
        "query",
        "regex",
      },
      
      -- 💡 同步安装 (Synchronous installation)
      sync_install = false,
      
      -- 💡 自动安装缺失的解析器 (Auto-install missing parsers)
      auto_install = true,
      
      -- 💡 高亮配置 (Highlighting configuration)
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        -- 💡 禁用某些文件类型的 Tree-sitter 高亮
        -- Disable Tree-sitter highlighting for certain filetypes
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      
      -- 💡 增量选择 (Incremental selection)
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      
      -- 💡 缩进 (Indentation)
      indent = {
        enable = true,
        -- 💡 某些语言的缩进不太准确，可以禁用
        -- Disable for certain languages with poor indentation support
        disable = { "yaml", "python" },
      },
      
      -- 💡 文本对象 (Text objects)
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- 💡 函数相关 (Function-related)
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            -- 💡 类相关 (Class-related)
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            -- 💡 条件相关 (Conditional-related)
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            -- 💡 循环相关 (Loop-related)
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },
      },
    },
    -- 💡 不需要 config 函数，LazyVim 会自动处理 (No config function needed, LazyVim handles it)
  },

  -- ---------------------------------------------------------
  -- Tree-sitter Context: 显示当前代码上下文
  -- Tree-sitter Context: Show current code context
  -- ---------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      -- 💡 最大显示行数 (Maximum lines to show)
      max_lines = 3,
      -- 💡 最小窗口高度 (Minimum window height)
      min_window_height = 20,
      -- 💡 模式: 'cursor' 或 'topline'
      mode = "cursor",
    },
  },
}
