-- =========================================================
-- Python 开发环境配置 (Python Development Configuration)
-- =========================================================
-- 功能说明 (Description):
--   完整的 Python 开发工具链，遵循用户全局规则
--   Complete Python toolchain following user's global rules
--   - AMD ROCm 环境支持 (AMD ROCm environment support)
--   - uv 包管理器 (uv package manager)
--   - Type Hints 强制 (Type hints enforcement)
-- =========================================================

local lang_config = require("config.languages")

-- 💡 检查 Python 是否启用 (Check if Python is enabled)
if not lang_config.is_enabled("python") then
  return {}
end

return {
  -- ---------------------------------------------------------
  -- Python LSP: Basedpyright (高性能类型检查)
  -- Python LSP: Basedpyright - High-performance type checker
  -- ---------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          -- 💡 Python LSP 配置 (Python LSP configuration)
          settings = {
            basedpyright = {
              -- 类型检查模式 (Type checking mode)
              typeCheckingMode = "standard", -- off, basic, standard, strict
              
              -- 💡 启用类型提示和补全 (Enable type hints and completion)
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                
                -- 类型存根路径 (Type stubs path)
                stubPath = "typings",
                
                -- 诊断严格程度 (Diagnostic severity)
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "warning",
                  reportUnusedVariable = "warning",
                  reportUndefinedVariable = "error",
                  reportMissingTypeStubs = "none", -- 💡 忽略缺失的类型存根警告
                },
              },
            },
          },
        },
        
        -- 💡 Ruff LSP: 超快的 Python linter 和 formatter
        -- Ruff LSP: Ultra-fast Python linter and formatter
        ruff_lsp = {
          on_attach = function(client, bufnr)
            -- 💡 禁用 ruff 的 hover，使用 basedpyright 的
            -- Disable ruff hover in favor of basedpyright
            client.server_capabilities.hoverProvider = false
          end,
          init_options = {
            settings = {
              -- 💡 Ruff 配置 (Ruff configuration)
              args = {
                "--line-length=88", -- PEP 8 推荐行长 (PEP 8 recommended line length)
                "--select=E,F,W,I", -- 启用规则: 错误、pyflakes、警告、导入 (Enable rules)
              },
            },
          },
        },
      },
      
      -- 💡 自动安装 LSP servers (Auto-install LSP servers)
      setup = {
        basedpyright = function(_, opts)
          require("lspconfig").basedpyright.setup(opts)
        end,
        ruff_lsp = function(_, opts)
          require("lspconfig").ruff_lsp.setup(opts)
        end,
      },
    },
  },

  -- ---------------------------------------------------------
  -- Python 虚拟环境支持
  -- Python virtual environment support
  -- ---------------------------------------------------------
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = {
      -- 💡 自动检测虚拟环境 (Auto-detect virtual environments)
      name = {
        "venv",
        ".venv",
        "env",
        ".env",
      },
      -- 💡 与 uv 包管理器兼容 (Compatible with uv package manager)
      auto_refresh = true,
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    },
  },

  -- ---------------------------------------------------------
  -- Python 调试器: nvim-dap-python
  -- Python debugger: nvim-dap-python
  -- ---------------------------------------------------------
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      -- 💡 配置 debugpy 路径 (Configure debugpy path)
      -- 优先使用虚拟环境中的 debugpy (Prefer debugpy from virtual env)
      local path = require("mason-registry").get_package("debugpy"):get_install_path()
      require("dap-python").setup(path .. "/venv/bin/python")
      
      -- 💡 自定义调试配置 (Custom debug configurations)
      table.insert(require("dap").configurations.python, {
        type = "python",
        request = "launch",
        name = "Launch file with arguments",
        program = "${file}",
        args = function()
          -- 💡 动态输入命令行参数 (Dynamic command-line arguments)
          local args_string = vim.fn.input("Arguments: ")
          return vim.split(args_string, " ")
        end,
        console = "integratedTerminal",
      })
    end,
    keys = {
      { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method" },
      { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class" },
    },
  },

  -- ---------------------------------------------------------
  -- Tree-sitter: Python 语法高亮
  -- Tree-sitter: Python syntax highlighting
  -- ---------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "python", "ninja", "rst" })
      end
    end,
  },

  -- ---------------------------------------------------------
  -- Python 代码片段
  -- Python code snippets
  -- ---------------------------------------------------------
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
    opts = function(_, opts)
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      
      -- 💡 Python 专用代码片段 (Python-specific snippets)
      ls.add_snippets("python", {
        -- PyTorch device selection (遵循用户规则: AMD ROCm)
        s("device", {
          t('device = torch.device("cuda" if torch.cuda.is_available() else "cpu")'),
          t({ "", "# 💡 Note: On Fedora AMD GPU, utilize ROCm for acceleration" }),
        }),
        
        -- Type hints function template
        s("deft", {
          t("def "),
          i(1, "function_name"),
          t("("),
          i(2, "arg: type"),
          t(") -> "),
          i(3, "ReturnType"),
          t({ ":", "    " }),
          i(0),
        }),
        
        -- Main guard
        s("main", {
          t({ 'if __name__ == "__main__":', "    " }),
          i(0),
        }),
      })
      
      return opts
    end,
  },

  -- ---------------------------------------------------------
  -- Mason: 确保 Python 工具已安装
  -- Mason: Ensure Python tools are installed
  -- ---------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "basedpyright",  -- Python LSP
        "ruff-lsp",      -- Ruff LSP
        "debugpy",       -- Python debugger
      })
    end,
  },

  -- ---------------------------------------------------------
  -- LazyVim Python Extra: 集成 LazyVim 的 Python 支持
  -- LazyVim Python Extra: Integrate LazyVim's Python support
  -- ---------------------------------------------------------
  {
    "LazyVim/LazyVim",
    opts = {
      -- 💡 自动导入 LazyVim 的 Python extras
      -- Auto-import LazyVim's Python extras
    },
  },
}
