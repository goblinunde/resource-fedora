-- =========================================================
-- 调试器配置 (Debug Adapter Protocol Configuration)
-- =========================================================
-- 功能说明 (Description):
--   DAP 调试器配置，支持 Python 和 Rust
--   DAP debugger configuration for Python and Rust
-- =========================================================

return {
  -- ---------------------------------------------------------
  -- nvim-dap: 核心调试适配器
  -- nvim-dap: Core debug adapter
  -- ---------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- 💡 DAP UI: 美化的调试界面
      -- DAP UI: Polished debug interface
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dap = require("dap")
          local dapui = require("dapui")
          
          -- 💡 配置 DAP UI (Configure DAP UI)
          dapui.setup({
            layouts = {
              {
                elements = {
                  { id = "scopes", size = 0.25 },
                  { id = "breakpoints", size = 0.25 },
                  { id = "stacks", size = 0.25 },
                  { id = "watches", size = 0.25 },
                },
                size = 40,
                position = "left",
              },
              {
                elements = {
                  { id = "repl", size = 0.5 },
                  { id = "console", size = 0.5 },
                },
                size = 10,
                position = "bottom",
              },
            },
            -- 💡 浮窗配置 (Floating window configuration)
            floating = {
              border = "rounded",
              mappings = {
                close = { "q", "<Esc>" },
              },
            },
          })
          
          -- 💡 自动打开/关闭 UI (Auto-open/close UI)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      
      -- 💡 虚拟文本: 在代码中显示变量值
      -- Virtual text: Show variable values in code
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          enabled = true,
          enabled_commands = true,
          highlight_changed_variables = true,
          highlight_new_as_changed = false,
          show_stop_reason = true,
          commented = false,
        },
      },
      
      -- 💡 Mason DAP: 自动安装调试器
      -- Mason DAP: Auto-install debuggers
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason-org/mason.nvim" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          automatic_installation = true,
          ensure_installed = {
            "python",    -- 💡 Python debugger (debugpy)
            "codelldb",  -- 💡 Rust debugger (LLDB)
          },
          handlers = {},
        },
      },
    },
    
    keys = {
      -- 💡 调试快捷键 (Debug keybindings)
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function() 
        require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end, desc = "Conditional Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    },
    
    config = function()
      -- 💡 DAP 图标配置 (DAP icon configuration)
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
      
      -- 💡 应用深青色主题到 DAP UI (Apply deep teal theme to DAP UI)
      local c = require("utils.colors")
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = c.colors.semantic.error })
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = c.colors.semantic.warning })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = c.colors.semantic.success })
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = c.colors.primary_mute })
    end,
  },
}
