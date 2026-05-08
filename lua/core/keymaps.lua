vim.keymap.set('n', '<C-s>', '<cmd>write<CR>', { silent = true })
vim.keymap.set('i', '<C-s>', '<Esc><cmd>write<CR>a', { silent = true })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>', { silent = true })
vim.keymap.set('n', 'Q', '<Nop>', { desc = 'Disable Ex mode (Q)' })

vim.keymap.set('n', '<leader>sr', ':%s///g<Left><Left><Left>', { desc = 'Find and replace in buffer' })
vim.keymap.set('x', '<leader>sr', ':s///g<Left><Left><Left>', { desc = 'Find and replace in selection' })
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste without yanking replaced text' })
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d", { desc = 'Delete without yanking replaced text' })

local function write_or_prompt_and_quit()
  -- Mirror Vim's ZZ flow, but handle unnamed buffers by prompting for filename.
  if vim.fn.expand('%') == '' then
    local name = vim.fn.input('Save as: ', '', 'file')
    if name == '' then
      return
    end
    vim.cmd('write ' .. vim.fn.fnameescape(name))
  else
    vim.cmd('write')
  end
  -- Plain :quit errors (E37) if another buffer is still modified; confirm gives prompt.
  vim.cmd('confirm quit')
end

vim.api.nvim_create_user_command('WQ', write_or_prompt_and_quit, {})
vim.keymap.set('n', 'ZZ', write_or_prompt_and_quit, { silent = true })

-- Centering cursor
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true })
vim.keymap.set('n', '<C-f>', '<C-f>zz', { silent = true })
vim.keymap.set('n', '<C-b>', '<C-b>zz', { silent = true })

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set({ 'n', 'x', 'o' }, 'zk', function()
  require('flash').jump()
end, { desc = 'Flash jump' })

-- Move lines quickly
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.api.nvim_create_user_command('MyTips', function()
  local path = vim.fs.joinpath(vim.fn.stdpath('config'), 'nvim_tips.md')
  if vim.fn.filereadable(path) == 0 then
    vim.notify('MyTips: file not found: ' .. path, vim.log.levels.ERROR)
    return
  end
  vim.cmd('belowright split ' .. vim.fn.fnameescape(path))
end, { desc = 'Open nvim_tips.md below current window' })

-- Git (vim-fugitive)
vim.keymap.set('n', '<leader>gs', '<cmd>Git<CR>', { silent = true, desc = 'Git status (Fugitive)' })
vim.keymap.set('n', '<leader>gd', '<cmd>Gdiffsplit<CR>', { silent = true, desc = 'Git diff split (Fugitive)' })
vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<CR>', { silent = true, desc = 'Git blame (Fugitive)' })
vim.keymap.set('n', '<leader>gl', '<cmd>Git log -- %<CR>', { silent = true, desc = 'Git log current file (Fugitive)' })
vim.keymap.set('n', '<leader>gB', function()
  local line = vim.fn.line('.')
  vim.cmd(('Git blame -L %d,%d -- %%'):format(line, line))
end, { silent = true, desc = 'Git blame current line (Fugitive)' })
vim.keymap.set('n', '<leader>gL', function()
  local line = vim.fn.line('.')
  vim.cmd(('Git log -L %d,%d:%%'):format(line, line))
end, { silent = true, desc = 'Git log current line (Fugitive)' })

-- reindent paragraph without losing spot
vim.keymap.set("n", "=ap", "ma=ap'a")
