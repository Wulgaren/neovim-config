vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup(require("plugins"), {
  checker = { enabled = false },
  rocks = { enabled = false },
})

require("options")
require("lsp")
require("colorscheme")
require("netrw")
require("statusline")
require("find")
require("grep")
require("pickers")
require("autocommands")
require("diagnostics")
require("keymaps")
