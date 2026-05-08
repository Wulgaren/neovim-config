local has_autocomplete_opt = pcall(vim.api.nvim_get_option_info2, 'autocomplete', {})
local telescope_ok, telescope = pcall(require, 'telescope')
local telescope_builtin = telescope_ok and require('telescope.builtin') or nil
local telescope_themes = telescope_ok and require('telescope.themes') or nil
local telescope_sorters = telescope_ok and require('telescope.sorters') or nil

if not telescope_ok then
  return
end

local TELESCOPE_RG_EXCLUDE_GLOBS = {
  '!.git',
  '!**/.git/**',
  '!**/node_modules/**',
  '!**/dist/**',
  '!**/build/**',
  '!**/.cache/**',
  '!**/bin/**',
  '!**/obj/**',
  '!**/*.min.*',
  '!**/*.d.ts',
  '!**/*.g.cs',
  '!**/wwwroot/lib/**',
  '!**/*syncfusion*',
  '!**/jquery*.js',
  '!**/jquery*.map',
  '!**/bootstrap*.js',
  '!**/bootstrap*.css',
  '!**/bootstrap*.map',
}

local function telescope_rg_glob_cli_args()
  local args = {}
  for _, g in ipairs(TELESCOPE_RG_EXCLUDE_GLOBS) do
    table.insert(args, '-g')
    table.insert(args, g)
  end
  return args
end

local function space_insensitive_fzy_sorter()
  local base = telescope_sorters.get_fzy_sorter()
  return telescope_sorters.Sorter:new({
    discard = true,
    scoring_function = function(_, prompt, line, ...)
      -- Treat spaces in prompt as optional so "my file" matches "myfile".
      local collapsed = (prompt or ''):gsub('%s+', '')
      if collapsed == '' then
        return 1
      end
      return base.scoring_function(_, collapsed, line, ...)
    end,
    highlighter = function(_, prompt, display)
      local collapsed = (prompt or ''):gsub('%s+', '')
      if collapsed == '' then
        return {}
      end
      return base.highlighter(_, collapsed, display)
    end,
  })
end

telescope.setup({
  defaults = {
    prompt_prefix = '  ',
    selection_caret = '  ',
    sorting_strategy = 'ascending',
    wrap_results = true,
    file_sorter = space_insensitive_fzy_sorter,
    generic_sorter = space_insensitive_fzy_sorter,
    layout_config = {
      prompt_position = 'top',
    },
    mappings = {
      i = {
        ['<Esc>'] = require('telescope.actions').close,
      },
    },
  },
  pickers = {
    live_grep = {
      additional_args = function()
        local args = { '-i' }
        vim.list_extend(args, telescope_rg_glob_cli_args())
        return args
      end,
    },
  },
})

local function telescope_files()
  local find_cmd = { 'rg', '--files', '--hidden' }
  vim.list_extend(find_cmd, telescope_rg_glob_cli_args())
  telescope_builtin.find_files(telescope_themes.get_dropdown({
    previewer = false,
    hidden = true,
    cwd = vim.fn.getcwd(),
    find_command = find_cmd,
  }))
end

local LIVE_GREP_OPTS = {
  cwd = vim.fn.getcwd(),
  layout_strategy = 'vertical',
  layout_config = {
    height = 0.9,
    prompt_position = 'bottom',
    preview_height = 0.42,
  },
}

local function telescope_live_grep_opts(extra)
  local opts = vim.deepcopy(LIVE_GREP_OPTS)
  opts.cwd = vim.fn.getcwd()
  if extra then
    for k, v in pairs(extra) do
      opts[k] = v
    end
  end
  return opts
end

-- Telescope prompt is a buffer line; newlines in default_text break nvim_buf_set_lines.
local function prompt_safe_text(raw)
  local s = raw or ''
  s = s:gsub('[\n\r\v\f]+', ' ')
  s = s:gsub('%s+', ' ')
  return s:match('^%s*(.-)%s*$') or ''
end

local function telescope_live_grep()
  telescope_builtin.live_grep(telescope_live_grep_opts({
    default_text = prompt_safe_text(vim.fn.getreg('+')),
  }))
end

local telescope_autocmd_group = vim.api.nvim_create_augroup('config-telescope-autocmds', { clear = true })

vim.keymap.set('n', '<C-p>', telescope_files, { silent = true, desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope_live_grep, { silent = true, desc = 'Telescope live grep (clipboard → prompt)' })
vim.keymap.set('x', '<leader>fg', function()
  vim.cmd([[noautocmd silent normal! gv"zy]])
  telescope_builtin.live_grep(telescope_live_grep_opts({ default_text = prompt_safe_text(vim.fn.getreg('z')) }))
end, { silent = true, desc = 'Telescope live grep (selection → prompt)' })
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { silent = true, desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fs', telescope_builtin.lsp_document_symbols, { silent = true, desc = 'Telescope LSP document symbols' })

vim.api.nvim_create_autocmd('FileType', {
  group = telescope_autocmd_group,
  pattern = 'TelescopePrompt',
  callback = function()
    if has_autocomplete_opt then
      vim.opt_local.autocomplete = false
    end
  end,
})

vim.api.nvim_create_autocmd('User', {
  group = telescope_autocmd_group,
  pattern = 'TelescopePreviewerLoaded',
  callback = function()
    -- Preview buffers can contain long lines; keep soft wrapping enabled.
    vim.wo.wrap = true
    vim.wo.linebreak = true
  end,
})

