return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local parser_dir = vim.fn.stdpath('data') .. '/site'
      require('nvim-treesitter').setup({
        install_dir = parser_dir,
      })

      require('nvim-treesitter').install({
        'bash',
        'c_sharp',
        'css',
        'html',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'toml',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      })
    end,
  },
}

