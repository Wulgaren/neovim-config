return {
  {
    'saghen/blink.cmp',
    version = '*',
    opts = {
      keymap = {
        preset = 'none',
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
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
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      snippets = { preset = 'default' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
  },
}

