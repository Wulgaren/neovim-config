local catppuccin_ok, catppuccin = pcall(require, 'catppuccin')
if catppuccin_ok then
  catppuccin.setup({
    flavour = 'frappe',
    transparent_background = true,
  })
  vim.cmd('colorscheme catppuccin')
else
  vim.cmd('colorscheme default')
end

local function apply_terminal_highlights()
  local set = vim.api.nvim_set_hl
  local groups = {
    Normal = { fg = '#eef1ff', bg = 'NONE' },
    NormalNC = { fg = '#e6eafd', bg = 'NONE' },
    NormalFloat = { fg = '#f2f4ff', bg = 'NONE' },
    FloatBorder = { fg = '#d8ddf7', bg = 'NONE' },
    SignColumn = { bg = 'NONE' },
    LineNr = { fg = '#cfd5f2', bg = 'NONE' },
    CursorLine = { bg = 'NONE' },
    CursorLineNr = { fg = '#f1f3ff', bg = 'NONE', bold = true },
    Identifier = { fg = '#e9edff' },
    Function = { fg = '#8caaee', bold = true },
    Type = { fg = '#e5c890' },
    Statement = { fg = '#ca9ee6' },
    Keyword = { fg = '#ca9ee6' },
    Conditional = { fg = '#ca9ee6' },
    Repeat = { fg = '#ca9ee6' },
    String = { fg = '#a6d189' },
    Character = { fg = '#a6d189' },
    Constant = { fg = '#ef9f76' },
    Number = { fg = '#ef9f76' },
    Boolean = { fg = '#ef9f76' },
    PreProc = { fg = '#e78284' },
    Special = { fg = '#81c8be' },
    Delimiter = { fg = '#d9def8' },
    Pmenu = { fg = '#eef1ff', bg = 'NONE' },
    PmenuSel = { fg = '#232634', bg = '#99d1db', bold = true },
    MatchParen = { fg = '#232634', bg = '#e5c890', bold = true },
    Search = { fg = '#232634', bg = '#e5c890', bold = true },
    IncSearch = { fg = '#232634', bg = '#ca9ee6', bold = true },
    DiagnosticError = { fg = '#e78284', bold = true },
    DiagnosticWarn = { fg = '#e5c890', bold = true },
    DiagnosticInfo = { fg = '#8caaee' },
    DiagnosticHint = { fg = '#81c8be' },
    ['@variable'] = { fg = '#e9edff' },
    ['@variable.builtin'] = { fg = '#ca9ee6', bold = true },
    ['@variable.parameter'] = { fg = '#dfe4fb', italic = true },
    ['@property'] = { fg = '#81c8be' },
    ['@field'] = { fg = '#81c8be' },
    ['@function'] = { fg = '#8caaee', bold = true },
    ['@function.method'] = { fg = '#8caaee', bold = true },
    ['@type'] = { fg = '#e5c890' },
    ['@type.builtin'] = { fg = '#e5c890', bold = true },
    ['@keyword'] = { fg = '#ca9ee6' },
    ['@string'] = { fg = '#a6d189' },
    ['@number'] = { fg = '#ef9f76' },
    ['@constant'] = { fg = '#ef9f76' },
    ['@operator'] = { fg = '#d8ddf7' },
  }

  for group, spec in pairs(groups) do
    set(0, group, spec)
  end
end

apply_terminal_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = apply_terminal_highlights,
})
