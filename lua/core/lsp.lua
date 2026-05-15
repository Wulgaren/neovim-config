local platform = require('core.platform')
local is_windows = platform.is_windows
local mason_bin = platform.join_path(vim.fn.stdpath('data'), 'mason', 'bin')
local lsp_bin = is_windows and platform.editor_lsp_bin_dir()
local tailwind_markers = { 'tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.ts', 'package.json', '.git' }

local function join_path(...)
  return platform.join_path(...)
end

local function command_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

local function first_available_command(candidates)
  for _, candidate in ipairs(candidates) do
    if command_exists(candidate[1]) then
      return candidate
    end
  end
  return nil
end

local function root_dir(bufnr, markers)
  local path = vim.api.nvim_buf_get_name(bufnr)
  return vim.fs.root(path, markers) or vim.fn.getcwd()
end

local function start_lsp(bufnr, name, cmd, markers, opts)
  if not cmd or not command_exists(cmd[1]) then
    return
  end
  local config = vim.tbl_deep_extend('force', {
    name = name,
    cmd = cmd,
    root_dir = root_dir(bufnr, markers),
  }, opts or {})
  vim.lsp.start(config)
end

local function html_lsp_cmd()
  if is_windows then
    return first_available_command({
      { mason_bin .. '\\html-lsp.cmd' },
      { lsp_bin .. '\\html-lsp.cmd' },
      { mason_bin .. '\\vscode-html-language-server.cmd', '--stdio' },
      { lsp_bin .. '\\vscode-html-language-server.cmd', '--stdio' },
    })
  end
  return first_available_command({
    { join_path(mason_bin, 'html-lsp'), '--stdio' },
    { join_path(mason_bin, 'vscode-html-language-server'), '--stdio' },
    { join_path(lsp_bin, 'vscode-html-language-server'), '--stdio' },
    { 'vscode-html-language-server', '--stdio' },
  })
end

local function css_lsp_cmd()
  if is_windows then
    return first_available_command({
      { mason_bin .. '\\css-lsp.cmd' },
      { lsp_bin .. '\\css-lsp.cmd' },
      { mason_bin .. '\\vscode-css-language-server.cmd', '--stdio' },
      { lsp_bin .. '\\vscode-css-language-server.cmd', '--stdio' },
    })
  end
  return first_available_command({
    { join_path(mason_bin, 'css-lsp'), '--stdio' },
    { join_path(mason_bin, 'vscode-css-language-server'), '--stdio' },
    { join_path(lsp_bin, 'vscode-css-language-server'), '--stdio' },
    { 'vscode-css-language-server', '--stdio' },
  })
end

local function tailwind_lsp_cmd()
  if is_windows then
    return first_available_command({
      { mason_bin .. '\\tailwindcss-language-server.cmd', '--stdio' },
      { lsp_bin .. '\\tailwind-lsp.cmd' },
      { lsp_bin .. '\\tailwindcss-language-server.cmd', '--stdio' },
    })
  end
  return first_available_command({
    { join_path(mason_bin, 'tailwindcss-language-server'), '--stdio' },
    { join_path(lsp_bin, 'tailwindcss-language-server'), '--stdio' },
    { 'tailwindcss-language-server', '--stdio' },
  })
end

local function ts_lsp_cmd()
  if is_windows then
    return first_available_command({
      { mason_bin .. '\\typescript-language-server.cmd', '--stdio' },
      { platform.appdata_dir() .. '\\npm\\typescript-language-server.cmd', '--stdio' },
      { lsp_bin .. '\\typescript-language-server.cmd', '--stdio' },
    })
  end
  return first_available_command({
    { join_path(mason_bin, 'typescript-language-server'), '--stdio' },
    { join_path(lsp_bin, 'typescript-language-server'), '--stdio' },
    { 'typescript-language-server', '--stdio' },
  })
end

local function lua_lsp_cmd()
  if is_windows then
    return first_available_command({
      { mason_bin .. '\\lua-language-server.exe' },
      { lsp_bin .. '\\lua-language-server.exe' },
      { 'lua-language-server.exe' },
      { 'lua-language-server' },
    })
  end
  return first_available_command({
    { join_path(mason_bin, 'lua-language-server') },
    { join_path(lsp_bin, 'lua-language-server') },
    { 'lua-language-server' },
  })
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = false })
    end, opts)
  end,
})

local diag_severity = vim.diagnostic.severity

-- Nerd Font / Font Awesome PUA glyphs (terminal must use a patched font).
local function d_icon(codepoint)
  return vim.fn.nr2char(codepoint)
end

vim.diagnostic.config({
  -- Full message on CursorHold via open_float; keep EOL text short so lines stay readable.
  virtual_text = {
    spacing = 2,
    source = 'if_many',
    prefix = ' ',
    format = function(diagnostic)
      local msg = diagnostic.message:gsub('%s*\n%s*', ' '):gsub('%s+', ' ')
      local max_len = 72
      if #msg > max_len then
        return msg:sub(1, max_len - 1) .. '…'
      end
      return msg
    end,
  },
  -- 0.12+ uses extmark sign_text; sign_define() does not apply to these diagnostics.
  signs = {
    text = {
      [diag_severity.ERROR] = d_icon(0xf057),
      [diag_severity.WARN] = d_icon(0xf071),
      [diag_severity.INFO] = d_icon(0xf05a),
      [diag_severity.HINT] = d_icon(0xf7b5),
    },
  },
  underline = true,
  severity_sort = true,
  float = { border = 'rounded' },
})

do
  local default_publish = vim.lsp.handlers['textDocument/publishDiagnostics']
  vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
    if result and result.uri then
      local bufnr = vim.uri_to_bufnr(result.uri)
      if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
        return
      end
    end
    return default_publish(err, result, ctx, config)
  end

  local default_pull = vim.lsp.handlers['textDocument/diagnostic']
  if default_pull then
    vim.lsp.handlers['textDocument/diagnostic'] = function(err, result, ctx, config)
      local bufnr = ctx and ctx.bufnr
      if not bufnr then
        return
      end
      bufnr = vim._resolve_bufnr(bufnr)
      if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
        return
      end
      -- Drop stale responses; avoids bufstate nil crash in vim.lsp.diagnostic.on_diagnostic (Nvim 0.12).
      if vim.tbl_isempty(vim.lsp.get_clients({ bufnr = bufnr, method = 'textDocument/diagnostic' })) then
        return
      end
      vim.lsp.diagnostic._enable(bufnr)
      return default_pull(err, result, ctx, config)
    end
  end
end

local lsp_autocmd_group = vim.api.nvim_create_augroup('config-lsp-autocmds', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = lsp_autocmd_group,
  pattern = { 'html' },
  callback = function(args)
    start_lsp(args.buf, 'html', html_lsp_cmd(), { 'package.json', '.git' })
    start_lsp(args.buf, 'tailwindcss', tailwind_lsp_cmd(), tailwind_markers)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = lsp_autocmd_group,
  pattern = { 'css' },
  callback = function(args)
    start_lsp(args.buf, 'cssls', css_lsp_cmd(), { 'package.json', '.git' })
    start_lsp(args.buf, 'tailwindcss', tailwind_lsp_cmd(), tailwind_markers)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = lsp_autocmd_group,
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  callback = function(args)
    start_lsp(args.buf, 'ts_ls', ts_lsp_cmd(), { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' })
    start_lsp(args.buf, 'tailwindcss', tailwind_lsp_cmd(), tailwind_markers)
  end,
})

-- C# LSP handled by roslyn.nvim plugin (see lua/plugins/init.lua).
-- Legacy csharp-ls autocmd removed in favor of roslyn_ls.

vim.api.nvim_create_autocmd('FileType', {
  group = lsp_autocmd_group,
  pattern = { 'python' },
  callback = function(args)
    start_lsp(
      args.buf,
      'pylsp',
      first_available_command({
        { join_path(mason_bin, 'pylsp') },
        { 'pylsp' },
      }),
      { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' }
    )
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = lsp_autocmd_group,
  pattern = { 'sh', 'bash', 'zsh' },
  callback = function(args)
    local cmd = first_available_command({
      { join_path(mason_bin, 'bash-language-server'), 'start' },
      { 'bash-language-server', 'start' },
    })
    start_lsp(args.buf, 'bashls', cmd, { '.git' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = lsp_autocmd_group,
  pattern = { 'toml' },
  callback = function(args)
    local cmd = first_available_command({
      { join_path(mason_bin, 'taplo'), 'lsp', 'stdio' },
      { 'taplo', 'lsp', 'stdio' },
    })
    start_lsp(args.buf, 'taplo', cmd, { '.git' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = lsp_autocmd_group,
  pattern = { 'yaml' },
  callback = function(args)
    local cmd = first_available_command({
      { join_path(mason_bin, 'yaml-language-server'), '--stdio' },
      { 'yaml-language-server', '--stdio' },
    })
    start_lsp(args.buf, 'yamlls', cmd, { '.git' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = lsp_autocmd_group,
  pattern = { 'json', 'jsonc' },
  callback = function(args)
    local json_cmd = is_windows
      and first_available_command({
        { mason_bin .. '\\json-lsp.cmd', '--stdio' },
        { lsp_bin .. '\\vscode-json-language-server.cmd', '--stdio' },
      })
      or first_available_command({
        { join_path(mason_bin, 'json-lsp'), '--stdio' },
        { join_path(lsp_bin, 'vscode-json-language-server'), '--stdio' },
        { 'vscode-json-language-server', '--stdio' },
      })
    start_lsp(args.buf, 'jsonls', json_cmd, { 'package.json', '.git' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = lsp_autocmd_group,
  pattern = { 'lua' },
  callback = function(args)
    start_lsp(args.buf, 'lua_ls', lua_lsp_cmd(), { '.luarc.json', '.luarc.jsonc', '.git' }, {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            checkThirdParty = false,
            library = vim.api.nvim_get_runtime_file('', true),
          },
        },
      },
    })
  end,
})

-- CursorHold: full diagnostic float at cursor (no LSP required if another source sets diagnostics).
vim.api.nvim_create_autocmd('CursorHold', {
  group = lsp_autocmd_group,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.tbl_isempty(vim.diagnostic.get(bufnr, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })) then
      return
    end
    vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor' })
  end,
})

-- Optional: other plugins that use :sign with DiagnosticSign* names.
for type, cp in pairs({
  Error = 0xf057,
  Warn = 0xf071,
  Hint = 0xf7b5,
  Info = 0xf05a,
}) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = d_icon(cp), texthl = hl, numhl = '' })
end
