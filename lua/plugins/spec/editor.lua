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
      require('mini.bracketed').setup({
        -- Default suffix `c` steals `]c`/`[c`; those are diff next/prev change when `diff` on.
        comment = { suffix = 'm' },
      })
      require('mini.ai').setup()
      require('mini.comment').setup()
    end,
  }
}

