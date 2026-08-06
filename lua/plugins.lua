return {
  {
    'mason-org/mason.nvim',
    lazy = false,
    cmd = { 'Mason', 'MasonInstall', 'MasonUpdate', 'MasonLog' },
    opts = {
      registries = {
        'github:mason-org/mason-registry',
        'github:Crashdummyy/mason-registry',
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mason_bin = vim.fn.stdpath('data') .. '/mason/bin'
      vim.env.PATH = mason_bin .. ':' .. vim.env.PATH
    end,
  },
  {
    'monkoose/neocodeium',
    event = 'VeryLazy',
    opts = {
      filetypes = {
        TelescopePrompt = false,
      },
    },
    config = function(_, opts)
      local neocodeium = require('neocodeium')
      neocodeium.setup(opts)
      vim.keymap.set('n', '<leader>ko', '<cmd>NeoCodeium toggle<CR>', {
        silent = true,
        desc = 'NeoCodeium toggle (no bang; use :NeoCodeium! toggle to halt server)',
      })
      --- Full suggestion accept (`accept`, not word). `<M-Tab>` = Alt+Tab; OS may capture it before Neovim.
      vim.keymap.set('i', '<M-Tab>', neocodeium.accept, { silent = true, desc = 'NeoCodeium: accept all' })
      vim.keymap.set('i', '<M-w>', neocodeium.accept_word, { silent = true, desc = 'NeoCodeium: accept word' })
      vim.keymap.set('i', '<M-l>', neocodeium.accept_line, { silent = true, desc = 'NeoCodeium: accept line' })
      vim.keymap.set('i', '<Tab>', function()
        if neocodeium.visible() then
          neocodeium.accept_word()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', true)
        end
      end, { silent = true, desc = 'NeoCodeium: accept word, else insert Tab' })
    end,
  },
  { 'tpope/vim-fugitive' },
}
