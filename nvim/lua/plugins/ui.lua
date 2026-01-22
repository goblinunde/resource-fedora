-- =========================================================
-- UI 增强配置 (UI Enhancement Configuration)
-- =========================================================
-- 功能说明 (Description):
--   基于 resource.css 的 UI 组件美化
--   UI components styling based on resource.css aesthetic
-- =========================================================

return {
  -- ---------------------------------------------------------
  -- Statusline: Lualine (优雅的状态栏)
  -- Statusline: Lualine - Elegant statusline
  -- ---------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local c = require("utils.colors")
      local theme_colors = c.get_theme_colors()
      
      -- 💡 自定义深青色主题 (Custom deep teal theme)
      local custom_theme = {
        normal = {
          a = { bg = c.colors.primary, fg = theme_colors.bg, gui = "bold" },
          b = { bg = theme_colors.bg_soft, fg = theme_colors.fg },
          c = { bg = theme_colors.bg_mute, fg = theme_colors.fg_dim },
        },
        insert = {
          a = { bg = c.colors.semantic.success, fg = theme_colors.bg, gui = "bold" },
        },
        visual = {
          a = { bg = c.colors.semantic.warning, fg = theme_colors.bg, gui = "bold" },
        },
        replace = {
          a = { bg = c.colors.semantic.error, fg = theme_colors.bg, gui = "bold" },
        },
        command = {
          a = { bg = c.colors.semantic.info, fg = theme_colors.bg, gui = "bold" },
        },
        inactive = {
          a = { bg = theme_colors.bg_mute, fg = theme_colors.fg_dim },
          b = { bg = theme_colors.bg_mute, fg = theme_colors.fg_dim },
          c = { bg = theme_colors.bg_mute, fg = theme_colors.fg_dim },
        },
      }
      
      return {
        options = {
          theme = custom_theme,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true, -- 💡 全局状态栏 (Global statusline)
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            { "filename", path = 1 }, -- 💡 显示相对路径 (Show relative path)
          },
          lualine_x = {
            { "diagnostics", sources = { "nvim_lsp" } },
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },

  -- ---------------------------------------------------------
  -- Bufferline: 标签页美化
  -- Bufferline: Elegant buffer tabs
  -- ---------------------------------------------------------
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    },
    opts = function()
      local c = require("utils.colors")
      local theme_colors = c.get_theme_colors()
      
      return {
        options = {
          mode = "buffers", -- 💡 显示缓冲区而非标签页 (Show buffers not tabs)
          separator_style = "slant", -- slant, thick, thin
          always_show_bufferline = false,
          diagnostics = "nvim_lsp",
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
        highlights = {
          -- 💡 自定义深青色高亮 (Custom deep teal highlights)
          fill = {
            bg = theme_colors.bg,
          },
          background = {
            bg = theme_colors.bg_mute,
            fg = theme_colors.fg_dim,
          },
          buffer_selected = {
            bg = c.colors.primary,
            fg = theme_colors.bg,
            bold = true,
            italic = false,
          },
          buffer_visible = {
            bg = theme_colors.bg_soft,
            fg = theme_colors.fg,
          },
        },
      }
    end,
  },

  -- ---------------------------------------------------------
  -- Indent Blankline: 缩进线
  -- Indent guides with subtle styling
  -- ---------------------------------------------------------
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = function()
      local c = require("utils.colors")
      
      return {
        indent = {
          char = "│", -- 💡 细线字符 (Thin line character)
          tab_char = "│",
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
          highlight = { "Function", "Label" },
        },
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "lazy",
            "mason",
          },
        },
      }
    end,
  },

  -- ---------------------------------------------------------
  -- Notify: 优雅的通知系统
  -- Elegant notification system
  -- ---------------------------------------------------------
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      -- 💡 通知样式配置 (Notification styling)
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      stages = "fade_in_slide_out", -- 💡 淡入滑出动画 (Fade in slide out animation)
      render = "default", -- default, minimal, simple
    },
    config = function(_, opts)
      require("notify").setup(opts)
      -- 💡 设置为默认通知处理器 (Set as default notify handler)
      vim.notify = require("notify")
    end,
  },

  -- ---------------------------------------------------------
  -- Noice: 现代化命令行 UI
  -- Modern UI for messages, cmdline and popupmenu
  -- ---------------------------------------------------------
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- 💡 Lsp 进度美化 (LSP progress styling)
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- 💡 预设配置 (Presets configuration)
      presets = {
        bottom_search = true, -- 底部搜索栏 (Bottom search bar)
        command_palette = true, -- 命令面板风格 (Command palette style)
        long_message_to_split = true, -- 长消息分屏显示 (Long messages to split)
        inc_rename = false, -- 增量重命名输入框 (Incremental rename input)
        lsp_doc_border = true, -- LSP 文档边框 (LSP doc borders)
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },

  -- ---------------------------------------------------------
  -- Dashboard: 启动页面
  -- Dashboard: Start screen
  -- ---------------------------------------------------------
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local logo = [[
        ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
        ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
        ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
        ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
        ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
        ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
                  🌊 山水·数理 | Shan-shui Logic 🌊
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          center = {
            {
              action = "Telescope find_files",
              desc = " Find file",
              icon = " ",
              key = "f",
            },
            {
              action = "ene | startinsert",
              desc = " New file",
              icon = " ",
              key = "n",
            },
            {
              action = "Telescope oldfiles",
              desc = " Recent files",
              icon = " ",
              key = "r",
            },
            {
              action = "Telescope live_grep",
              desc = " Find text",
              icon = " ",
              key = "g",
            },
            {
              action = "Lazy",
              desc = " Lazy",
              icon = "󰒲 ",
              key = "l",
            },
            {
              action = "qa",
              desc = " Quit",
              icon = " ",
              key = "q",
            },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      return opts
    end,
  },

  -- ---------------------------------------------------------
  -- Which-key: 快捷键提示
  -- Which-key: Keybinding hints
  -- ---------------------------------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- 💡 使用新版 API (v3.x) - Use new API (v3.x)
      preset = "modern", -- classic, modern, helix
      -- 💡 窗口配置 (Window configuration)
      win = {
        border = "rounded", -- 圆角边框 (Rounded borders)
        padding = { 1, 2 }, -- top/bottom, left/right
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      -- 💡 延迟显示时间 (Delay before showing which-key)
      delay = 500, -- ms
    },
  },
}
