local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'
local path_sep = package.config:sub(1, 1)
local home = vim.env.HOME or vim.env.USERPROFILE or vim.fn.expand('~')
local appdata = vim.env.APPDATA or ''
local lsp_bin = is_windows and (appdata .. '\\editor-lsp\\bin') or (home .. '/.bun/bin')

local function join_path(...)
  return table.concat({ ... }, path_sep)
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

local function csharp_root_dir(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  local start = vim.fs.dirname(path)
  if not start then
    return vim.fn.getcwd()
  end

  if vim.fn.glob(join_path(start, '*.sln')) ~= '' or vim.fn.glob(join_path(start, '*.csproj')) ~= '' or vim.fn.isdirectory(join_path(start, '.git')) == 1 then
    return start
  end

  for dir in vim.fs.parents(start) do
    if vim.fn.glob(join_path(dir, '*.sln')) ~= '' or vim.fn.glob(join_path(dir, '*.csproj')) ~= '' or vim.fn.isdirectory(join_path(dir, '.git')) == 1 then
      return dir
    end
  end

  return vim.fn.getcwd()
end

local function start_lsp(bufnr, name, cmd, markers)
  if not cmd or not command_exists(cmd[1]) then
    return
  end
  vim.lsp.start({
    name = name,
    cmd = cmd,
    root_dir = root_dir(bufnr, markers),
  })
end

local function html_lsp_cmd()
  if is_windows then
    return first_available_command({
      { lsp_bin .. '\\html-lsp.cmd' },
      { lsp_bin .. '\\vscode-html-language-server.cmd', '--stdio' },
    })
  end
  return first_available_command({
    { join_path(lsp_bin, 'vscode-html-language-server'), '--stdio' },
    { 'vscode-html-language-server', '--stdio' },
  })
end

local function css_lsp_cmd()
  if is_windows then
    return first_available_command({
      { lsp_bin .. '\\css-lsp.cmd' },
      { lsp_bin .. '\\vscode-css-language-server.cmd', '--stdio' },
    })
  end
  return first_available_command({
    { join_path(lsp_bin, 'vscode-css-language-server'), '--stdio' },
    { 'vscode-css-language-server', '--stdio' },
  })
end

local function tailwind_lsp_cmd()
  if is_windows then
    return first_available_command({
      { lsp_bin .. '\\tailwind-lsp.cmd' },
      { lsp_bin .. '\\tailwindcss-language-server.cmd', '--stdio' },
    })
  end
  return first_available_command({
    { join_path(lsp_bin, 'tailwindcss-language-server'), '--stdio' },
    { 'tailwindcss-language-server', '--stdio' },
  })
end

local function ts_lsp_cmd()
  if is_windows then
    return first_available_command({
      { appdata .. '\\npm\\typescript-language-server.cmd', '--stdio' },
      { lsp_bin .. '\\typescript-language-server.cmd', '--stdio' },
    })
  end
  return first_available_command({
    { join_path(lsp_bin, 'typescript-language-server'), '--stdio' },
    { 'typescript-language-server', '--stdio' },
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
  local diagnostic_open_float = vim.diagnostic.open_float
  vim.diagnostic.open_float = function(opts)
    local win = diagnostic_open_float(opts)
    if win and win ~= 0 and vim.api.nvim_win_is_valid(win) then
      vim.wo[win].wrap = true
      vim.wo[win].linebreak = true
    end
    return win
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'html' },
  callback = function(args)
    start_lsp(args.buf, 'html', html_lsp_cmd(), { 'package.json', '.git' })
    start_lsp(args.buf, 'tailwindcss', tailwind_lsp_cmd(), { 'tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.ts', 'package.json', '.git' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'css' },
  callback = function(args)
    start_lsp(args.buf, 'cssls', css_lsp_cmd(), { 'package.json', '.git' })
    start_lsp(args.buf, 'tailwindcss', tailwind_lsp_cmd(), { 'tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.ts', 'package.json', '.git' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  callback = function(args)
    start_lsp(args.buf, 'ts_ls', ts_lsp_cmd(), { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' })
    start_lsp(args.buf, 'tailwindcss', tailwind_lsp_cmd(), { 'tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.ts', 'package.json', '.git' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'cs' },
  callback = function(args)
    local csharp_ls = is_windows and (home .. '\\.dotnet\\tools\\csharp-ls.exe') or join_path(home, '.dotnet', 'tools', 'csharp-ls')
    if not command_exists(csharp_ls) then
      return
    end
    vim.lsp.start({
      name = 'csharp_ls',
      cmd = { csharp_ls },
      root_dir = csharp_root_dir(args.buf),
    })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python' },
  callback = function(args)
    start_lsp(args.buf, 'pylsp', { 'pylsp' }, { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'bash', 'zsh' },
  callback = function(args)
    start_lsp(args.buf, 'bashls', { 'bash-language-server', 'start' }, { '.git' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'toml' },
  callback = function(args)
    start_lsp(args.buf, 'taplo', { 'taplo', 'lsp', 'stdio' }, { '.git' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'yaml' },
  callback = function(args)
    start_lsp(args.buf, 'yamlls', { 'yaml-language-server', '--stdio' }, { '.git' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc' },
  callback = function(args)
    local json_cmd = is_windows
      and first_available_command({
        { lsp_bin .. '\\vscode-json-language-server.cmd', '--stdio' },
      })
      or first_available_command({
        { join_path(lsp_bin, 'vscode-json-language-server'), '--stdio' },
        { 'vscode-json-language-server', '--stdio' },
      })
    start_lsp(args.buf, 'jsonls', json_cmd, { 'package.json', '.git' })
  end,
})
