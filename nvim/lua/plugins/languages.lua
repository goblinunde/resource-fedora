-- =========================================================
-- 多语言开发支持配置 (Multi-Language Development Support)
-- =========================================================
-- 功能说明 (Description):
--   基于语言配置中心的多语言完整支持
--   Complete multi-language support integrated with language config center
--   每个语言包含: LSP + 格式化 + 调试（如果适用）
--   Each language includes: LSP + Formatting + Debugging (if applicable)
-- =========================================================

local lang_config = require("config.languages")

return {
  -- =========================================================
  -- Go 语言完整支持 (Go Language Full Support)
  -- =========================================================
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    enabled = function()
      return lang_config.is_enabled("go")
    end,
    ft = { "go", "gomod", "gowork", "gotmpl" },
    build = ':lua require("go.install").update_all_sync()',
    config = function()
      require("go").setup({
        -- 💡 Go LSP 配置 (Go LSP configuration)
        lsp_cfg = {
          settings = {
            gopls = {
              -- 启用所有分析 (Enable all analyses)
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true, -- 使用 gofumpt 格式化
            },
          },
        },
        -- 💡 自动格式化 (Auto-format)
        lsp_gofumpt = true,
        lsp_on_attach = true,
        -- 💡 调试配置 (Debug configuration)
        dap_debug = true,
        dap_debug_gui = true,
      })
    end,
  },

  -- =========================================================
  -- TypeScript/JavaScript 完整支持 (TypeScript/JavaScript Full Support)
  -- =========================================================
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    enabled = function()
      return lang_config.is_enabled("typescript") or lang_config.is_enabled("javascript")
    end,
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      -- 💡 TypeScript LSP 配置 (TypeScript LSP configuration)
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  -- =========================================================
  -- Java 完整支持 (Java Language Full Support)
  -- =========================================================
  {
    "nvim-java/nvim-java",
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      {
        "mason-org/mason.nvim",
        opts = {
          registries = {
            "github:nvim-java/mason-registry",
            "github:mason-org/mason-registry",
          },
        },
      },
    },
    enabled = function()
      return lang_config.is_enabled("java")
    end,
    ft = { "java" },
    config = function()
      require("java").setup({
        -- 💡 Java LSP 配置 (Java LSP configuration)
        jdk = {
          auto_install = false, -- 不自动安装 JDK
        },
      })
    end,
  },

  -- =========================================================
  -- Bash/Shell 脚本支持 (Bash/Shell Script Support)
  -- =========================================================
  {
    "neovim/nvim-lspconfig",
    enabled = function()
      return lang_config.is_enabled("bash")
    end,
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.bashls = {
        -- 💡 Bash LSP 配置 (Bash LSP configuration)
        filetypes = { "sh", "bash", "zsh" },
      }
      return opts
    end,
  },

  -- =========================================================
  -- Ruby 语言支持 (Ruby Language Support)
  -- =========================================================
  {
    "neovim/nvim-lspconfig",
    enabled = function()
      return lang_config.is_enabled("ruby")
    end,
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.solargraph = {
        -- 💡 Ruby LSP 配置 (Ruby LSP configuration)
        settings = {
          solargraph = {
            diagnostics = true,
            formatting = true,
          },
        },
      }
      return opts
    end,
  },

  -- =========================================================
  -- Zig 语言支持 (Zig Language Support)
  -- =========================================================
  {
    "ziglang/zig.vim",
    enabled = function()
      return lang_config.is_enabled("zig")
    end,
    ft = { "zig" },
  },
  {
    "neovim/nvim-lspconfig",
    enabled = function()
      return lang_config.is_enabled("zig")
    end,
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.zls = {
        -- 💡 Zig LSP 配置 (Zig LSP configuration)
        settings = {
          zls = {
            enable_autofix = true,
            enable_snippets = true,
            warn_style = true,
          },
        },
      }
      return opts
    end,
  },

  -- =========================================================
  -- Julia 语言支持 (Julia Language Support)
  -- =========================================================
  {
    "JuliaEditorSupport/julia-vim",
    enabled = function()
      return lang_config.is_enabled("julia")
    end,
    ft = { "julia" },
  },
  {
    "neovim/nvim-lspconfig",
    enabled = function()
      return lang_config.is_enabled("julia")
    end,
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.julials = {
        -- 💡 Julia LSP 配置 (Julia LSP configuration)
        settings = {
          julia = {
            format = {
              indent = 4,
            },
          },
        },
      }
      return opts
    end,
  },

  -- =========================================================
  -- Fish Shell 支持 (Fish Shell Support)
  -- =========================================================
  {
    "dag/vim-fish",
    enabled = function()
      return lang_config.is_enabled("fish")
    end,
    ft = { "fish" },
  },

  -- =========================================================
  -- Nushell 支持 (Nushell Support)
  -- =========================================================
  {
    "LhKipp/nvim-nu",
    enabled = function()
      return lang_config.is_enabled("nushell")
    end,
    ft = { "nu" },
    build = ":TSInstall nu",
  },

  -- =========================================================
  -- Tree-sitter 多语言语法高亮 (Tree-sitter Multi-Language Syntax Highlighting)
  -- =========================================================
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      
      -- 💡 根据配置启用语言 parser (Enable parsers based on config)
      local parsers = {}
      
      if lang_config.is_enabled("go") then
        vim.list_extend(parsers, { "go", "gomod", "gowork", "gotmpl" })
      end
      
      if lang_config.is_enabled("typescript") or lang_config.is_enabled("javascript") then
        vim.list_extend(parsers, { "typescript", "tsx", "javascript", "jsdoc" })
      end
      
      if lang_config.is_enabled("java") then
        table.insert(parsers, "java")
      end
      
      if lang_config.is_enabled("bash") or lang_config.is_enabled("zsh") then
        table.insert(parsers, "bash")
      end
      
      if lang_config.is_enabled("ruby") then
        table.insert(parsers, "ruby")
      end
      
      if lang_config.is_enabled("zig") then
        table.insert(parsers, "zig")
      end
      
      if lang_config.is_enabled("julia") then
        table.insert(parsers, "julia")
      end
      
      if lang_config.is_enabled("fish") then
        table.insert(parsers, "fish")
      end
      
      if lang_config.is_enabled("nushell") then
        table.insert(parsers, "nu")
      end
      
      -- 通用 parsers (Universal parsers)
      vim.list_extend(parsers, { "json", "yaml", "toml", "xml", "vim", "lua", "regex" })
      
      vim.list_extend(opts.ensure_installed, parsers)
      return opts
    end,
  },

  -- =========================================================
  -- Mason 自动安装工具 (Mason Auto-Install Tools)
  -- =========================================================
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      
      -- 💡 根据配置安装 LSP/工具 (Install LSP/tools based on config)
      if lang_config.is_enabled("go") then
        vim.list_extend(opts.ensure_installed, {
          "gopls",        -- Go LSP
          "goimports",    -- Go imports formatter
          "gofumpt",      -- Go strict formatter
          "delve",        -- Go debugger
        })
      end
      
      if lang_config.is_enabled("typescript") or lang_config.is_enabled("javascript") then
        vim.list_extend(opts.ensure_installed, {
          "typescript-language-server", -- TS/JS LSP
          "prettier",                    -- Code formatter
          "eslint_d",                    -- Fast ESLint
        })
      end
      
      if lang_config.is_enabled("java") then
        vim.list_extend(opts.ensure_installed, {
          "jdtls",                -- Java LSP
          "java-debug-adapter",   -- Java debugger
          "java-test",            -- Java test runner
        })
      end
      
      if lang_config.is_enabled("bash") or lang_config.is_enabled("zsh") then
        vim.list_extend(opts.ensure_installed, {
          "bash-language-server", -- Bash LSP
          "shfmt",                -- Shell formatter
          "shellcheck",           -- Shell linter
        })
      end
      
      if lang_config.is_enabled("ruby") then
        vim.list_extend(opts.ensure_installed, {
          "solargraph",  -- Ruby LSP
          "rubocop",     -- Ruby linter/formatter
        })
      end
      
      if lang_config.is_enabled("zig") then
        vim.list_extend(opts.ensure_installed, {
          "zls",  -- Zig LSP
        })
      end
      
      if lang_config.is_enabled("julia") then
        vim.list_extend(opts.ensure_installed, {
          "julia-lsp",  -- Julia LSP
        })
      end
      
      return opts
    end,
  },

  -- =========================================================
  -- Conform.nvim 格式化配置 (Conform.nvim Formatting Configuration)
  -- =========================================================
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      
      -- 💡 根据配置添加格式化工具 (Add formatters based on config)
      if lang_config.is_enabled("go") then
        opts.formatters_by_ft.go = { "goimports", "gofumpt" }
      end
      
      if lang_config.is_enabled("typescript") or lang_config.is_enabled("javascript") then
        opts.formatters_by_ft.typescript = { "prettier" }
        opts.formatters_by_ft.typescriptreact = { "prettier" }
        opts.formatters_by_ft.javascript = { "prettier" }
        opts.formatters_by_ft.javascriptreact = { "prettier" }
      end
      
      if lang_config.is_enabled("java") then
        opts.formatters_by_ft.java = { "google-java-format" }
      end
      
      if lang_config.is_enabled("bash") or lang_config.is_enabled("zsh") then
        opts.formatters_by_ft.sh = { "shfmt" }
        opts.formatters_by_ft.bash = { "shfmt" }
        opts.formatters_by_ft.zsh = { "shfmt" }
      end
      
      if lang_config.is_enabled("ruby") then
        opts.formatters_by_ft.ruby = { "rubocop" }
      end
      
      if lang_config.is_enabled("zig") then
        opts.formatters_by_ft.zig = { "zigfmt" }
      end
      
      if lang_config.is_enabled("julia") then
        opts.formatters_by_ft.julia = { "juliaformatter" }
      end
      
      if lang_config.is_enabled("fish") then
        opts.formatters_by_ft.fish = { "fish_indent" }
      end
      
      return opts
    end,
  },
}
