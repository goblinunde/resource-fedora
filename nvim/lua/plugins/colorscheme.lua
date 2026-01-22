-- =========================================================
-- 主题配置 (Colorscheme Configuration)
-- =========================================================
-- 功能说明 (Description):
--   丰富的主题选择，涵盖多种风格
--   Rich theme selection covering various styles
-- =========================================================

return {
  -- =========================================================
  -- 主题 1: Catppuccin (优雅柔和色调)
  -- =========================================================
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mason = true,
        telescope = { enabled = true },
        which_key = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
          },
        },
      },
    },
  },

  -- =========================================================
  -- 主题 2: Tokyonight (东京夜晚主题)
  -- =========================================================
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- storm, moon, night, day
      transparent = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
    },
  },

  -- =========================================================
  -- 主题 3: Gruvbox (复古暖色调)
  -- =========================================================
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      contrast = "hard", -- "hard", "medium", "soft"
      transparent_mode = false,
      italic = {
        strings = false,
        comments = true,
        operators = false,
        folds = true,
      },
    },
  },

  -- =========================================================
  -- 主题 4: Kanagawa (日式水墨风格)
  -- =========================================================
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      transparent = false,
      theme = "wave", -- wave, dragon, lotus
    },
  },

  -- =========================================================
  -- 主题 5: Rose Pine (玫瑰松木主题)
  -- =========================================================
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "moon", -- auto, main, moon, dawn
      dark_variant = "moon",
      disable_background = false,
      disable_float_background = false,
      disable_italics = false,
    },
  },

  -- =========================================================
  -- 主题 6: Nightfox (夜狐主题家族)
  -- =========================================================
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
      },
    },
  },

  -- =========================================================
  -- 主题 7: Dracula (德古拉主题)
  -- =========================================================
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_bg = false,
      italic_comment = true,
      show_end_of_buffer = true,
    },
  },

  -- =========================================================
  -- 主题 8: Nord (北欧冷色调)
  -- =========================================================
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true
      vim.g.nord_bold = true
    end,
  },

  -- =========================================================
  -- 主题 9: Onedark (Atom 经典主题)
  -- =========================================================
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "dark", -- dark, darker, cool, deep, warm, warmer
      transparent = false,
      code_style = {
        comments = "italic",
        keywords = "bold",
        functions = "none",
        strings = "none",
        variables = "none",
      },
    },
  },

  -- =========================================================
  -- 主题 10: Everforest (森林主题)
  -- =========================================================
  {
    "neanias/everforest-nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").setup({
        background = "hard", -- hard, medium, soft
        italics = true,
        disable_italic_comments = false,
        transparent_background_level = 0,
      })
    end,
  },

  -- =========================================================
  -- 主题 11: Solarized (经典科学配色)
  -- =========================================================
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      styles = {
        comments = { italic = true },
        functions = { bold = true },
        variables = {},
      },
    },
  },

  -- =========================================================
  -- 主题 12: Monokai Pro (Sublime Text 经典)
  -- =========================================================
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = false,
      terminal_colors = true,
      filter = "pro", -- classic, octagon, pro, machine, ristretto, spectrum
    },
  },

  -- =========================================================
  -- LazyVim 主题选择器
  -- =========================================================
  {
    "LazyVim/LazyVim",
    opts = {
      -- 💡 默认主题：可以在这里更改
      -- Default theme: change here to switch themes
      -- 可选: catppuccin, tokyonight, gruvbox, kanagawa, rose-pine, 
      --       nightfox, dracula, nord, onedark, everforest, solarized, monokai-pro
      colorscheme = "catppuccin",
    },
  },
}
