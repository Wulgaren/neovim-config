return {
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
}

