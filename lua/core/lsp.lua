local platform = require('core.platform')
local is_windows = platform.is_windows
local mason_bin = platform.join_path(vim.fn.stdpath('data'), 'mason', 'bin')
local lsp_bin = is_windows and platform.editor_lsp_bin_dir() or platform.bun_bin_dir()
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

vim.diagnostic.config({
  virtual_text = true,
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
      if bufnr and (not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr)) then
        return
      end
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

