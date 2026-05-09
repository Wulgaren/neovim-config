return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    -- Not `ft = markdown`: first buffer can open before attach runs; VeryLazy is cheap.
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
  },
  { 'tpope/vim-fugitive' },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.pairs').setup()
      require('mini.surround').setup()
      require('mini.bracketed').setup()
      require('mini.ai').setup()
      require('mini.comment').setup()
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
      })

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'Harpoon: add file' })

      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Harpoon: menu' })

      for i = 1, 4 do
        vim.keymap.set('n', '<leader>' .. i, function()
          harpoon:list():select(i)
        end, { desc = 'Harpoon: file ' .. i })
      end

      vim.keymap.set('n', '<leader>hp', function()
        harpoon:list():prev()
      end, { desc = 'Harpoon: previous' })

      vim.keymap.set('n', '<leader>hn', function()
        harpoon:list():next()
      end, { desc = 'Harpoon: next' })
    end,
  },
}

