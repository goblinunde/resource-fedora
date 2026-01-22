-- =========================================================
-- 终端和 Tmux 集成配置 (Terminal & Tmux Integration)
-- =========================================================
-- 功能说明 (Description):
--   浮动终端和 tmux 无缝导航支持
--   Floating terminal and seamless tmux navigation
-- =========================================================

return {
  -- =========================================================
  -- Toggleterm: 强大的浮动终端插件
  -- =========================================================
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      -- 💡 终端大小和布局 (Terminal size and layout)
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      
      -- 打开方式 (Opening method)
      open_mapping = [[<C-\>]], -- Ctrl+\ 打开终端
      
      -- 隐藏行号 (Hide line numbers)
      hide_numbers = true,
      
      -- 阴影 (Shade)
      shade_terminals = true,
      shading_factor = 2,
      
      -- 启动 shell (Start insert mode)
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      
      -- 持久化大小 (Persist size)
      persist_size = true,
      persist_mode = true,
      
      -- 方向 (Direction)
      direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
      
      -- 关闭确认 (Close on exit)
      close_on_exit = true,
      
      -- Shell (使用默认 shell)
      shell = vim.o.shell,
      
      -- 自动滚动 (Auto scroll)
      auto_scroll = true,
      
      -- 浮动窗口配置 (Float configuration)
      float_opts = {
        border = "curved", -- 'single' | 'double' | 'shadow' | 'curved'
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
      
      -- 窗口配置 (Winbar)
      winbar = {
        enabled = false,
      },
    },
    
    config = function(_, opts)
      require("toggleterm").setup(opts)
      
      -- 💡 自定义终端实例 (Custom terminal instances)
      local Terminal = require("toggleterm.terminal").Terminal
      
      -- Lazygit 终端
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "curved",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })
      
      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end
      
      -- Python REPL
      local python = Terminal:new({
        cmd = "python",
        direction = "float",
        close_on_exit = false,
      })
      
      function _PYTHON_TOGGLE()
        python:toggle()
      end
      
      -- Node REPL
      local node = Terminal:new({
        cmd = "node",
        direction = "float",
        close_on_exit = false,
      })
      
      function _NODE_TOGGLE()
        node:toggle()
      end
      
      -- htop 系统监控
      local htop = Terminal:new({
        cmd = "htop",
        direction = "float",
        close_on_exit = true,
      })
      
      function _HTOP_TOGGLE()
        htop:toggle()
      end
      
      -- 💡 终端模式快捷键 (Terminal mode keymaps)
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end
      
      -- 自动应用终端快捷键
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end,
    
    keys = {
      -- 通用终端
      { "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Float Terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle Horizontal Terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Toggle Vertical Terminal" },
      
      -- 专用终端
      { "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", desc = "Toggle Lazygit" },
      { "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", desc = "Toggle Python REPL" },
      { "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", desc = "Toggle Node REPL" },
      { "<leader>tH", "<cmd>lua _HTOP_TOGGLE()<cr>", desc = "Toggle Htop" },
      
      -- 发送命令到终端
      { "<leader>ts", "<cmd>ToggleTermSendCurrentLine<cr>", desc = "Send Line to Terminal", mode = "n" },
      { "<leader>ts", "<cmd>ToggleTermSendVisualSelection<cr>", desc = "Send Selection to Terminal", mode = "x" },
    },
  },

  -- =========================================================
  -- Tmux Navigator: 无缝 Neovim ↔ Tmux 导航
  -- =========================================================
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate Left (Tmux)" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate Down (Tmux)" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate Up (Tmux)" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate Right (Tmux)" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Navigate Previous (Tmux)" },
    },
    init = function()
      -- 💡 禁用默认快捷键映射 (Disable default mappings)
      vim.g.tmux_navigator_no_mappings = 1
      
      -- 保存时禁用导航 (Disable when zoomed)
      vim.g.tmux_navigator_save_on_switch = 2
      
      -- 禁用换行 (Disable wrap around)
      vim.g.tmux_navigator_disable_when_zoomed = 1
    end,
  },

  -- =========================================================
  -- Better Terminal (可选替代方案)
  -- =========================================================
  {
    "rebelot/terminal.nvim",
    enabled = false, -- 禁用，使用 toggleterm
    config = function()
      require("terminal").setup()
    end,
  },
}
