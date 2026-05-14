return {
  {
    'saghen/blink.cmp',
    version = '*',
    opts = {
      keymap = {
        preset = 'none',
        --- Neo suggestion + blink inactive: accept **line**; otherwise blink accept / Vim newline fallback.
        ['<CR>'] = {
          function()
            local ok, neo = pcall(require, 'neocodeium')
            local blink_ok, blink = pcall(require, 'blink.cmp')
            if ok and neo.visible() and blink_ok and not blink.is_visible() then
              neo.accept_line()
              return true
            end
          end,
          'accept',
          'fallback',
        },
        --- When NeoCodeium ghost text visible: Tab accepts one word first; otherwise blink/snippet/tab.
        ['<Tab>'] = {
          function()
            local ok, neo = pcall(require, 'neocodeium')
            if ok and neo.visible() then
              neo.accept_word()
              return true
            end
          end,
          'select_next',
          'snippet_forward',
          'fallback',
        },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        --- Toggle completion menu (<C-space> unreliable in many terminals).
        ['<C-e>'] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.hide()
            end
            return cmp.show()
          end,
        },
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        --- NeoCodeium shows ghost text while typing; only auto-open blink menu outside insert default mode.
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= 'default'
          end,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      snippets = { preset = 'default' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
  },
  {
    'monkoose/neocodeium',
    event = 'VeryLazy',
    dependencies = { 'saghen/blink.cmp' },
    opts = function()
      local blink = require('blink.cmp')
      return {
        filter = function()
          return not blink.is_visible()
        end,
        filetypes = {
          TelescopePrompt = false,
        },
      }
    end,
    config = function(_, opts)
      local neocodeium = require('neocodeium')
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
          neocodeium.clear()
        end,
      })
      neocodeium.setup(opts)
      vim.keymap.set('n', '<leader>ko', '<cmd>NeoCodeium toggle<CR>', {
        silent = true,
        desc = 'NeoCodeium toggle (no bang; use :NeoCodeium! toggle to halt server)',
      })
      vim.keymap.set('i', '<M-f>', neocodeium.accept, { silent = true, desc = 'NeoCodeium: accept' })
      --- `<Tab>` accepts word via blink chain when neo visible; keep Alt+w as explicit duplicate.
      vim.keymap.set('i', '<M-w>', neocodeium.accept_word, { silent = true, desc = 'NeoCodeium: accept word (Tab when visible)' })
      vim.keymap.set('i', '<M-l>', neocodeium.accept_line, { silent = true, desc = 'NeoCodeium: accept line' })
    end,
  },
}

