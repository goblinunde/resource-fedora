-- =========================================================
-- Quick-c C/C++ 构建工具配置 (Quick-c C/C++ Build Tool Configuration)
-- =========================================================
-- 功能说明 (Description):
--   快速构建、运行和调试 C/C++ 项目，支持 Make 和 CMake
--   Quick build, run, and debug C/C++ projects with Make and CMake support
-- 插件地址: https://github.com/AuroBreeze/quick-c
-- =========================================================

local lang_config = require("config.languages")

-- 💡 检查 C/C++ 是否启用 (Check if C/C++ is enabled)
if not lang_config.is_enabled("c") and not lang_config.is_enabled("cpp") then
  return {}
end

return {
  "AuroBreeze/quick-c",
  lazy = true,
  event = "VeryLazy",
  -- 💡 文件类型触发 (Trigger on C/C++ files)
  ft = { "c", "cpp" },
  -- 💡 快捷键定义 (Keybindings)
  keys = {
    { "<leader>cqb", desc = "Quick-c: Build current file" },
    { "<leader>cqr", desc = "Quick-c: Run last build" },
    { "<leader>cqR", desc = "Quick-c: Build & Run" },
    { "<leader>cqD", desc = "Quick-c: Debug with DAP" },
    { "<leader>cqM", desc = "Quick-c: Make targets (Telescope)" },
    { "<leader>cqS", desc = "Quick-c: Select sources (Telescope)" },
    { "<leader>cqf", desc = "Quick-c: Open quickfix (Telescope)" },
    { "<leader>cqL", desc = "Quick-c: Build logs (Telescope)" },
    { "<leader>cqC", desc = "Quick-c: CMake targets (Telescope)" },
    { "<leader>cqB", desc = "Quick-c: CMake build" },
    { "<leader>cqc", desc = "Quick-c: CMake configure" },
    { "<leader>cqx", desc = "Quick-c: Stop current task" },
    { "<leader>cqt", desc = "Quick-c: Retry last task" },
  },
  -- 💡 命令触发 (Command triggers)
  cmd = {
    "QuickCBuild",
    "QuickCRun",
    "QuickCBR",
    "QuickCDebug",
    "QuickCMake",
    "QuickCMakeRun",
    "QuickCMakeCmd",
    "QuickCCMake",
    "QuickCCMakeRun",
    "QuickCCMakeConfigure",
    "QuickCCompileDB",
    "QuickCCompileDBGen",
    "QuickCCompileDBUse",
    "QuickCQuickfix",
    "QuickCCheck",
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    -- 💡 调试支持 (Debugging support)
    { "mfussenegger/nvim-dap", optional = true },
    { "jay-babu/mason-nvim-dap.nvim", optional = true },
  },
  config = function()
    require("quick-c").setup({
      -- 💡 默认配置 (Default configuration)
      -- 输出目录：默认在源文件同目录
      -- Output directory: same as source file by default
      output_dir = nil, -- nil = 使用源文件目录

      -- 💡 编译器自动检测优先级 (Compiler detection priority)
      -- Windows: gcc -> cl -> clang
      -- Linux/macOS: gcc -> clang
      compiler_preference = nil, -- nil = 自动检测

      -- 💡 终端集成 (Terminal integration)
      -- 优先使用 betterTerm（如果安装）
      use_betterterm = true,

      -- 💡 CMake 配置 (CMake configuration)
      cmake = {
        output = {
          open = true, -- 自动打开输出面板
          height = 10, -- 输出面板高度
        },
        view = "both", -- both/quickfix/terminal
      },
    })

    -- 💡 提示信息 (Notification)
    vim.notify("✅ Quick-c C/C++ 构建工具已加载", vim.log.levels.INFO)
  end,
}
