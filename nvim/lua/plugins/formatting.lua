-- =========================================================
-- 格式化配置 (Formatting Configuration)
-- =========================================================
-- 功能说明 (Description):
--   统一的代码格式化工具配置
--   Unified code formatting configuration
-- =========================================================

return {
  -- ---------------------------------------------------------
  -- Conform.nvim: 现代化格式化框架
  -- Conform.nvim: Modern formatting framework
  -- ---------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      -- 💡 按文件类型指定格式化工具 (Formatters by filetype)
      formatters_by_ft = {
        -- Python: 使用 ruff (遵循用户规则)
        python = { "ruff_format", "ruff_organize_imports" },
        
        -- Rust: 使用 rustfmt
        rust = { "rustfmt" },
        
        -- LaTeX: 使用 latexindent
        tex = { "latexindent" },
        latex = { "latexindent" },
        
        -- Lua: 使用 stylua
        lua = { "stylua" },
        
        -- Web 开发
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        
        -- Shell scripts
        sh = { "shfmt" },
        bash = { "shfmt" },
        
        -- TOML
        toml = { "taplo" },
      },
      
      -- 💡 格式化工具配置 (Formatter configurations)
      formatters = {
        -- Ruff format
        ruff_format = {
          command = "ruff",
          args = {
            "format",
            "--force-exclude",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
        },
        
        -- Ruff organize imports
        ruff_organize_imports = {
          command = "ruff",
          args = {
            "check",
            "--select",
            "I",
            "--fix",
            "--force-exclude",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
        },
        
        -- Rustfmt
        rustfmt = {
          command = "rustfmt",
          args = { "--edition", "2021" },
        },
        
        -- Latexindent
        latexindent = {
          command = "latexindent",
          args = { "-" },
        },
        
        -- Stylua
        stylua = {
          -- 💡 使用项目根目录的 stylua.toml 配置
          -- Use stylua.toml from project root
          prepend_args = { "--search-parent-directories" },
        },
        
        -- Shfmt
        shfmt = {
          prepend_args = { "-i", "2", "-ci" }, -- 💡 2空格缩进，case缩进
        },
      },
      
      -- 💡 保存时自动格式化 (Format on save)
      format_on_save = function(bufnr)
        -- 💡 禁用某些文件类型的自动格式化
        -- Disable auto-format for certain filetypes
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        
        return {
          timeout_ms = 500,
          lsp_fallback = true, -- 💡 如果没有格式化工具，回退到 LSP
        }
      end,
      
      -- 💡 格式化后的通知 (Notification after formatting)
      notify_on_error = true,
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },

  -- ---------------------------------------------------------
  -- Mason: 确保格式化工具已安装
  -- Mason: Ensure formatters are installed
  -- ---------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "stylua",        -- Lua formatter
        "prettier",      -- Web formatter
        "shfmt",         -- Shell formatter
        "taplo",         -- TOML formatter
        "latexindent",   -- LaTeX formatter
      })
      -- 💡 注意: ruff 和 rustfmt 通过语言工具链安装，不需要在这里添加
    end,
  },
}
