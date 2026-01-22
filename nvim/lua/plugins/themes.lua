-- =========================================================
-- 主题切换器 (Theme Switcher)
-- =========================================================
-- 功能说明 (Description):
--   多主题切换系统，支持快速切换不同配色方案
--   Multi-theme switching system for quick colorscheme changes
-- =========================================================

return {
  -- ---------------------------------------------------------
  -- Tokyonight 主题 (备选主题 1)
  -- Tokyonight Theme (Alternative 1)
  -- ---------------------------------------------------------
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 900,
    opts = {
      style = "night", -- night, storm, day, moon
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help", "neo-tree", "terminal" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = true,
    },
  },

  -- ---------------------------------------------------------
  -- Kanagawa 主题 (备选主题 2 - 日式风格)
  -- Kanagawa Theme (Alternative 2 - Japanese style)
  -- ---------------------------------------------------------
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 900,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
    },
  },

  -- ---------------------------------------------------------
  -- Gruvbox 主题 (备选主题 3 - 复古风格)
  -- Gruvbox Theme (Alternative 3 - Retro style)
  -- ---------------------------------------------------------
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 900,
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "hard", -- hard, medium, soft
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
  },

  -- ---------------------------------------------------------
  -- Nord 主题 (备选主题 4 - 北欧风格)
  -- Nord Theme (Alternative 4 - Nordic style)
  -- ---------------------------------------------------------
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 900,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = true
    end,
  },

  -- ---------------------------------------------------------
  -- 主题切换工具
  -- Theme Switcher Utility
  -- ---------------------------------------------------------
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      -- 💡 添加主题切换快捷键组 (Add theme switching keymap group)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, {
        "<leader>u",
        group = "UI",
      })
      table.insert(opts.spec, {
        "<leader>ut",
        group = "Theme",
      })
    end,
  },

  -- ---------------------------------------------------------
  -- 主题切换快捷键配置
  -- Theme Switching Keymaps Configuration
  -- ---------------------------------------------------------
  {
    "LazyVim/LazyVim",
    opts = function()
      -- 💡 定义主题切换函数 (Define theme switching functions)
      local function set_colorscheme(name)
        vim.cmd.colorscheme(name)
        local c = require("utils.colors")
        -- 💡 重新应用自定义颜色 (Re-apply custom colors)
        vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = c.colors.semantic.error })
        vim.api.nvim_set_hl(0, "DapStopped", { fg = c.colors.semantic.success })
        vim.notify("Switched to " .. name, vim.log.levels.INFO)
      end

      -- 💡 定义可用主题列表 (Define available themes)
      local themes = {
        { name = "catppuccin", display = "Catppuccin (深青色学术风格)" },
        { name = "tokyonight", display = "Tokyonight (东京之夜)" },
        { name = "kanagawa", display = "Kanagawa (日式风格)" },
        { name = "gruvbox", display = "Gruvbox (复古风格)" },
        { name = "nord", display = "Nord (北欧风格)" },
      }

      -- 💡 主题选择器函数 (Theme picker function)
      local function theme_picker()
        vim.ui.select(themes, {
          prompt = "Select Theme (选择主题): ",
          format_item = function(item)
            return item.display
          end,
        }, function(choice)
          if choice then
            set_colorscheme(choice.name)
          end
        end)
      end

      -- 💡 循环切换主题函数 (Cycle through themes)
      local current_theme_index = 1
      local function cycle_theme()
        current_theme_index = current_theme_index % #themes + 1
        local theme = themes[current_theme_index]
        set_colorscheme(theme.name)
      end

      -- 💡 注册快捷键 (Register keymaps)
      vim.keymap.set("n", "<leader>ut", theme_picker, { desc = "Select Theme (选择主题)" })
      vim.keymap.set("n", "<leader>uT", cycle_theme, { desc = "Cycle Theme (循环切换主题)" })
      
      -- 💡 快捷键切换到特定主题 (Quick switch to specific themes)
      vim.keymap.set("n", "<leader>ut1", function() set_colorscheme("catppuccin") end, { desc = "Catppuccin" })
      vim.keymap.set("n", "<leader>ut2", function() set_colorscheme("tokyonight") end, { desc = "Tokyonight" })
      vim.keymap.set("n", "<leader>ut3", function() set_colorscheme("kanagawa") end, { desc = "Kanagawa" })
      vim.keymap.set("n", "<leader>ut4", function() set_colorscheme("gruvbox") end, { desc = "Gruvbox" })
      vim.keymap.set("n", "<leader>ut5", function() set_colorscheme("nord") end, { desc = "Nord" })
    end,
  },
}
