return {
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'karb94/neoscroll.nvim',
    config = function()
      local neoscroll = require('neoscroll')

      neoscroll.setup({})

      -- Smooth trackpad/mouse wheel scroll (not part of neoscroll default mappings).
      local modes = { 'n', 'v', 'x' }
      vim.keymap.set(modes, '<ScrollWheelUp>', function()
        neoscroll.scroll(-0.35, { move_cursor = false, duration = 25, easing = 'quadratic' })
      end, { silent = true })
      vim.keymap.set(modes, '<ScrollWheelDown>', function()
        neoscroll.scroll(0.35, { move_cursor = false, duration = 25, easing = 'quadratic' })
      end, { silent = true })
    end,
  },
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
  {
    'saghen/blink.cmp',
    version = '*',
    opts = {
      keymap = {
        preset = 'none',
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      snippets = { preset = 'default' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
  },
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({})
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
  },
  {
    dir = '/Users/natios/Documents/Coding/ai-neovim',
    enabled = false,
    config = function()
      require('ollama_inline').setup({
        model = 'qwen2.5-coder:7b',
        keymap = {
          accept = '<C-l>',
          clear = '<C-]>',
          trigger = '<C-\\>',
        },
      })
    end,
  },
}
