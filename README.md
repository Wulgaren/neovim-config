# Neovim config

Native-first Neovim 0.12+ config with a small plugin set managed by `vim.pack`:

- **Mason** — language servers in `stdpath('data')/mason` (install by hand via `:Mason`)
- **NeoCodeium** — Windsurf AI ghost text
- **vim-fugitive** — Git

Lockfile: `nvim-pack-lock.json` (tracked). Update plugins with `:lua vim.pack.update()`.

Everything else is native: LSP (`vim.lsp.enable`), find/grep, netrw, statusline, pickers (`vim.ui.select`), builtin catppuccin + readability overrides.

See `nvim_tips.md` (`:MyTips`) for keymaps.
