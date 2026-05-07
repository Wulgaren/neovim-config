return {
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'tpope/vim-fugitive' },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'karb94/neoscroll.nvim',
    enabled = false,
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
    'catppuccin/nvim',
    name = 'catppuccin',
  },
  {
    'mason-org/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUpdate', 'MasonLog' },
    opts = {
      registries = {
        'github:mason-org/mason-registry',
        'github:Crashdummyy/mason-registry',
      },
    },
  },
  {
    'seblyng/roslyn.nvim',
    ft = { 'cs', 'razor' },
    dependencies = { 'mason-org/mason.nvim' },
    config = function()
      require('roslyn').setup({
        extensions = {
          razor = { enabled = false },
        },
        broad_search = false,
        lock_target = true,
        -- choose_target receives *solution* paths (.sln / .slnx / .slnf), not .csproj
        choose_target = function(targets)
          for _, t in ipairs(targets) do
            local b = t:lower()
            if b:find('vario.web.app.sln', 1, true) or b:find('varioweb.app.sln', 1, true) then
              return t
            end
          end
          for _, t in ipairs(targets) do
            local b = t:lower()
            if b:find('varioweb', 1, true) and (vim.endswith(t, '.sln') or vim.endswith(t, '.slnx') or vim.endswith(t, '.slnf')) then
              if not b:find('test', 1, true) then
                return t
              end
            end
          end
          for _, t in ipairs(targets) do
            if not t:lower():find('test', 1, true) then
              return t
            end
          end
          return targets[1]
        end,
      })
    end,
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
