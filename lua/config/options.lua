local has_autocomplete_opt = pcall(vim.api.nvim_get_option_info2, 'autocomplete', {})

vim.opt.background = 'light'
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

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})
