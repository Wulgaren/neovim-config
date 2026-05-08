local has_autocomplete_opt = pcall(vim.api.nvim_get_option_info2, 'autocomplete', {})

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }
vim.opt.pumheight = 12
if has_autocomplete_opt then
  vim.opt.autocomplete = false
end

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.incsearch = true

local options_autocmd_group = vim.api.nvim_create_augroup('config-options-autocmds', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = options_autocmd_group,
  pattern = 'qf',
  callback = function()
    -- Quickfix entries can be long; wrap instead of forcing horizontal scroll.
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = options_autocmd_group,
  callback = function()
    vim.highlight.on_yank()
  end,
})

