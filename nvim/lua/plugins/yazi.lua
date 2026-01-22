-- =========================================================
-- Yazi 文件管理器配置 (Yazi File Manager Configuration)
-- =========================================================
-- 功能说明 (Description):
--   在 Neovim 中集成现代化的终端文件管理器 Yazi
--   Integrate modern terminal file manager Yazi into Neovim
-- 插件地址: https://github.com/mikavilpas/yazi.nvim
-- =========================================================

return {
  "mikavilpas/yazi.nvim",
  version = "*", -- 💡 使用最新稳定版本 (Use latest stable version)
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    -- 💡 在当前文件位置打开 Yazi (Open yazi at current file)
    {
      "<leader>fy",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open Yazi at current file",
    },
    -- 💡 在当前工作目录打开 Yazi (Open yazi in cwd)
    {
      "<leader>fY",
      "<cmd>Yazi cwd<cr>",
      desc = "Open Yazi in nvim's working directory",
    },
    -- 💡 恢复上一次的 Yazi 会话 (Resume last yazi session)
    {
      "<leader>yr",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  },
  ---@type YaziConfig
  opts = {
    -- 💡 是否用 Yazi 替代 netrw (Replace netrw with yazi)
    open_for_directories = false,

    -- 💡 浮动窗口缩放因子 (Floating window scaling factor)
    -- 1 = 100%, 0.9 = 90%
    floating_window_scaling_factor = 0.9,

    -- 💡 浮动窗口透明度 (Window transparency, 0-100)
    yazi_floating_window_winblend = 0,

    -- 💡 浮动窗口边框样式 (Border style)
    yazi_floating_window_border = "rounded",

    -- 💡 快捷键配置 (Keymaps configuration)
    keymaps = {
      show_help = "<f1>", -- 显示帮助
      open_file_in_vertical_split = "<c-v>", -- 垂直分割打开
      open_file_in_horizontal_split = "<c-x>", -- 水平分割打开
      open_file_in_tab = "<c-t>", -- 新标签打开
      grep_in_directory = "<c-s>", -- 在目录中搜索 (需要 Telescope)
      replace_in_directory = "<c-g>", -- 在目录中替换 (需要 grug-far)
      cycle_open_buffers = "<tab>", -- 循环打开的 buffer
      copy_relative_path_to_selected_files = "<c-y>", -- 复制相对路径
      send_to_quickfix_list = "<c-q>", -- 发送到 quickfix
      change_working_directory = "<c-\\>", -- 改变工作目录
    },

    -- 💡 高亮同目录的 buffer (Highlight buffers in same directory)
    highlight_hovered_buffers_in_same_directory = true,

    -- 💡 日志级别 (Log level) - 默认关闭
    log_level = vim.log.levels.OFF,
  },
  config = function(_, opts)
    require("yazi").setup(opts)

    -- 💡 提示信息 (Notification)
    vim.notify("✅ Yazi 文件管理器已加载 | Modern file manager ready", vim.log.levels.INFO)
  end,
}
