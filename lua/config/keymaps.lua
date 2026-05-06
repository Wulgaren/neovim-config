vim.keymap.set('n', '<C-s>', '<cmd>write<CR>', { silent = true })
vim.keymap.set('i', '<C-s>', '<Esc><cmd>write<CR>a', { silent = true })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>', { silent = true })

vim.keymap.set('n', '<leader>sr', ':%s///g<Left><Left><Left>', { desc = 'Find and replace in buffer' })
vim.keymap.set('x', '<leader>sr', ':s///g<Left><Left><Left>', { desc = 'Find and replace in selection' })

local function write_or_prompt_and_quit()
  if vim.fn.expand('%') == '' then
    local name = vim.fn.input('Save as: ', '', 'file')
    if name == '' then
      return
    end
    vim.cmd('write ' .. vim.fn.fnameescape(name))
  else
    vim.cmd('write')
  end
  vim.cmd('quit')
end

vim.api.nvim_create_user_command('WQ', write_or_prompt_and_quit, {})
vim.keymap.set('n', 'ZZ', write_or_prompt_and_quit, { silent = true })

vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true })
vim.keymap.set('n', '<C-f>', '<C-f>zz', { silent = true })
vim.keymap.set('n', '<C-b>', '<C-b>zz', { silent = true })
