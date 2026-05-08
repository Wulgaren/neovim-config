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

local function srgb_to_linear(c)
  if c <= 0.04045 then
    return c / 12.92
  end
  return ((c + 0.055) / 1.055) ^ 2.4
end

local function relative_luminance(rgb24)
  -- Neovim runs LuaJIT by default; use `bit` ops (no `>>` / `&`).
  local bit = _G.bit or require('bit')
  local r = bit.band(bit.rshift(rgb24, 16), 0xFF) / 255
  local g = bit.band(bit.rshift(rgb24, 8), 0xFF) / 255
  local b = bit.band(rgb24, 0xFF) / 255
  r, g, b = srgb_to_linear(r), srgb_to_linear(g), srgb_to_linear(b)
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

local function terminal_is_light()
  -- If terminal/bg is known (not transparent), use it. Otherwise fall back to &background.
  local ok, normal = pcall(vim.api.nvim_get_hl, 0, { name = 'Normal', link = false })
  if ok and type(normal) == 'table' and type(normal.bg) == 'number' then
    return relative_luminance(normal.bg) >= 0.6
  end
  return vim.o.background == 'light'
end

local function apply_terminal_highlights()
  local set = vim.api.nvim_set_hl
  local is_light = terminal_is_light()

  -- Dark terminal: keep current bright-on-transparent palette.
  local dark_groups = {
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

  -- Light terminal: invert to dark-on-transparent palette.
  local light_groups = {
    Normal = { fg = '#1f2230', bg = 'NONE' },
    NormalNC = { fg = '#2a2f45', bg = 'NONE' },
    NormalFloat = { fg = '#1f2230', bg = 'NONE' },
    FloatBorder = { fg = '#4a526e', bg = 'NONE' },
    SignColumn = { bg = 'NONE' },
    LineNr = { fg = '#5a627a', bg = 'NONE' },
    CursorLine = { bg = 'NONE' },
    CursorLineNr = { fg = '#1f2230', bg = 'NONE', bold = true },
    Identifier = { fg = '#1f2230' },
    Function = { fg = '#2f5fb3', bold = true },
    Type = { fg = '#8a6b07' },
    Statement = { fg = '#6b2aa6' },
    Keyword = { fg = '#6b2aa6' },
    Conditional = { fg = '#6b2aa6' },
    Repeat = { fg = '#6b2aa6' },
    String = { fg = '#2b6b2d' },
    Character = { fg = '#2b6b2d' },
    Constant = { fg = '#a54b1e' },
    Number = { fg = '#a54b1e' },
    Boolean = { fg = '#a54b1e' },
    PreProc = { fg = '#b3262e' },
    Special = { fg = '#0f6f64' },
    Delimiter = { fg = '#3b4259' },
    Pmenu = { fg = '#1f2230', bg = 'NONE' },
    PmenuSel = { fg = '#f7f8ff', bg = '#2f5fb3', bold = true },
    MatchParen = { fg = '#f7f8ff', bg = '#8a6b07', bold = true },
    Search = { fg = '#f7f8ff', bg = '#8a6b07', bold = true },
    IncSearch = { fg = '#f7f8ff', bg = '#6b2aa6', bold = true },
    DiagnosticError = { fg = '#b3262e', bold = true },
    DiagnosticWarn = { fg = '#8a6b07', bold = true },
    DiagnosticInfo = { fg = '#2f5fb3' },
    DiagnosticHint = { fg = '#0f6f64' },
    ['@variable'] = { fg = '#1f2230' },
    ['@variable.builtin'] = { fg = '#6b2aa6', bold = true },
    ['@variable.parameter'] = { fg = '#2a2f45', italic = true },
    ['@property'] = { fg = '#0f6f64' },
    ['@field'] = { fg = '#0f6f64' },
    ['@function'] = { fg = '#2f5fb3', bold = true },
    ['@function.method'] = { fg = '#2f5fb3', bold = true },
    ['@type'] = { fg = '#8a6b07' },
    ['@type.builtin'] = { fg = '#8a6b07', bold = true },
    ['@keyword'] = { fg = '#6b2aa6' },
    ['@string'] = { fg = '#2b6b2d' },
    ['@number'] = { fg = '#a54b1e' },
    ['@constant'] = { fg = '#a54b1e' },
    ['@operator'] = { fg = '#3b4259' },
  }

  local groups = is_light and light_groups or dark_groups

  for group, spec in pairs(groups) do
    set(0, group, spec)
  end
end

apply_terminal_highlights()

local colors_autocmd_group = vim.api.nvim_create_augroup('config-colors-autocmds', { clear = true })

vim.api.nvim_create_autocmd('ColorScheme', {
  group = colors_autocmd_group,
  callback = apply_terminal_highlights,
})

