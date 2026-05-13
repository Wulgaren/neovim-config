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
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.pairs').setup()
      require('mini.surround').setup()
      require('mini.bracketed').setup({
        comment = { suffix = '' }, -- disabled (empty suffix = no maps; avoids stealing `[c`/`]c`)
      })
      require('mini.ai').setup()
      require('mini.comment').setup()
    end,
  }
}

