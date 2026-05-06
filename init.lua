vim.g.mapleader = ' '

local data_path = vim.fn.stdpath('data')
local path_sep = package.config:sub(1, 1)
local lazypath = table.concat({ data_path, 'lazy', 'lazy.nvim' }, path_sep)

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup(require('plugins'), {
  checker = { enabled = false },
  rocks = { enabled = false },
})

require('config.options')
require('config.keymaps')
require('config.telescope')
require('config.lsp')
require('config.colors')
