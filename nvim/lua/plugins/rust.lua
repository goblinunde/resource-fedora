-- =========================================================
-- Rust 开发环境配置 (Rust Development Configuration)
-- =========================================================
-- 功能说明 (Description):
--   完整的 Rust 开发工具链，遵循用户全局规则
--   Complete Rust toolchain following user's global rules
--   - 严格内存安全 (Strict memory safety)
--   - 零拷贝哲学 (Zero-copy philosophy)
--   - Result<T, E> 错误处理 (Result<T, E> error handling)
-- =========================================================

local lang_config = require("config.languages")

-- 💡 检查 Rust 是否启用 (Check if Rust is enabled)
if not lang_config.is_enabled("rust") then
  return {}
end

return {
  -- ---------------------------------------------------------
  -- Rust LSP: rust-analyzer (官方 Rust 语言服务器)
  -- Rust LSP: rust-analyzer - Official Rust language server
  -- ---------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          -- 💡 Rust LSP 配置 (Rust LSP configuration)
          settings = {
            ["rust-analyzer"] = {
              -- Cargo 配置 (Cargo configuration)
              cargo = {
                allFeatures = true, -- 💡 启用所有特性 (Enable all features)
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              
              -- 💡 Procmacro 支持 (Procmacro support)
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
              
              -- 检查配置 (Check configuration)
              checkOnSave = {
                command = "clippy", -- 💡 保存时运行 clippy (Run clippy on save)
                extraArgs = {
                  "--",
                  "--no-deps", -- 仅检查项目代码，不检查依赖 (Only check project code)
                  "-W", "clippy::all",
                  "-W", "clippy::pedantic",
                  "-W", "clippy::nursery",
                },
              },
              
              -- 💡 Inlay hints: 显示类型提示 (Inlay hints: show type annotations)
              inlayHints = {
                bindingModeHints = {
                  enable = true,
                },
                chainingHints = {
                  enable = true,
                },
                closingBraceHints = {
                  enable = true,
                  minLines = 25,
                },
                closureReturnTypeHints = {
                  enable = "always",
                },
                lifetimeElisionHints = {
                  enable = "always", -- 💡 总是显示生命周期提示 (Always show lifetime hints)
                  useParameterNames = true,
                },
                parameterHints = {
                  enable = true,
                },
                typeHints = {
                  enable = true,
                  hideClosureInitialization = false,
                  hideNamedConstructor = false,
                },
              },
              
              -- 💡 诊断配置 (Diagnostic configuration)
              diagnostics = {
                enable = true,
                experimental = {
                  enable = true,
                },
                -- 强调内存安全问题 (Emphasize memory safety issues)
                disabled = {},
                enableExperimental = true,
              },
            },
          },
        },
      },
    },
  },

  -- ---------------------------------------------------------
  -- Rust 工具增强: rustaceanvim (替代 rust-tools)
  -- Rust tooling enhancement: rustaceanvim
  -- ---------------------------------------------------------
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    opts = {
      -- 💡 Server 配置 (Server configuration)
      server = {
        on_attach = function(client, bufnr)
          -- 💡 自定义 Rust 快捷键 (Custom Rust keybindings)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr })
          
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust debuggables", buffer = bufnr })
        end,
        default_settings = {
          -- 💡 使用上面定义的 rust-analyzer 配置
          -- Use rust-analyzer settings defined above
          ["rust-analyzer"] = {},
        },
      },
      
      -- 💡 DAP 配置 (DAP configuration)
      dap = {
        adapter = {
          type = "executable",
          command = "lldb-vscode",
          name = "rt_lldb",
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
  },

  -- ---------------------------------------------------------
  -- Crates.nvim: Cargo.toml 依赖管理
  -- Crates.nvim: Cargo.toml dependency management
  -- ---------------------------------------------------------
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      -- 💡 自动补全配置 (Autocompletion configuration)
      src = {
        cmp = {
          enabled = true,
        },
      },
      
      -- 💡 null-ls 集成 (null-ls integration)
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
      
      -- 💡 弹出窗口配置 (Popup configuration)
      popup = {
        autofocus = true,
        border = "rounded",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- ---------------------------------------------------------
  -- Tree-sitter: Rust 语法高亮
  -- Tree-sitter: Rust syntax highlighting
  -- ---------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "rust", "toml", "ron" })
      end
    end,
  },

  -- ---------------------------------------------------------
  -- Rust 代码片段
  -- Rust code snippets
  -- ---------------------------------------------------------
  {
    "L3MON4D3/LuaSnip",
    opts = function(_, opts)
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      
      -- 💡 Rust 专用代码片段 (Rust-specific snippets)
      ls.add_snippets("rust", {
        -- Result<T, E> error handling pattern
        s("result", {
          t("fn "),
          i(1, "function_name"),
          t("("),
          i(2, "args"),
          t(") -> Result<"),
          i(3, "T"),
          t(", "),
          i(4, "E"),
          t({ "> {", "    " }),
          i(0),
          t({ "", "}" }),
        }),
        
        -- Option pattern matching
        s("match_opt", {
          t({ "match ", "" }),
          i(1, "option_var"),
          t({ " {", "    Some(" }),
          i(2, "val"),
          t({ ") => {", "        " }),
          i(3),
          t({ "", "    }," }),
          t({ "", "    None => {", "        " }),
          i(4),
          t({ "", "    }," }),
          t({ "", "}" }),
        }),
        
        -- Derive common traits
        s("derive", {
          t("#[derive("),
          i(1, "Debug, Clone"),
          t({ ")]", "" }),
          i(0),
        }),
        
        -- 💡 注释强调 "The Why" (Comment emphasizing "The Why")
        s("why", {
          t("// 💡 "),
          i(0, "Explain the rationale here"),
        }),
      })
      
      return opts
    end,
  },

  -- ---------------------------------------------------------
  -- Mason: 确保 Rust 工具已安装
  -- Mason: Ensure Rust tools are installed
  -- ---------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "rust-analyzer",  -- Rust LSP
        "codelldb",       -- Rust debugger (LLDB)
      })
    end,
  },

  -- ---------------------------------------------------------
  -- Formatting: rustfmt
  -- Formatting: rustfmt - Official Rust formatter
  -- ---------------------------------------------------------
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
      formatters = {
        rustfmt = {
          -- 💡 Rustfmt 配置 (Rustfmt configuration)
          command = "rustfmt",
          args = { "--edition", "2021" }, -- 使用 Rust 2021 edition
        },
      },
    },
  },
}
