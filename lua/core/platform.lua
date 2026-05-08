local M = {}

M.is_windows = vim.loop.os_uname().sysname == 'Windows_NT'
M.path_sep = package.config:sub(1, 1)

function M.join_path(...)
  return table.concat({ ... }, M.path_sep)
end

function M.home_dir()
  return vim.env.HOME or vim.env.USERPROFILE or vim.fn.expand('~')
end

function M.appdata_dir()
  return vim.env.APPDATA or ''
end

function M.bun_bin_dir()
  -- Used as default location for LSP binaries installed via Bun.
  return M.join_path(M.home_dir(), '.bun', 'bin')
end

function M.editor_lsp_bin_dir()
  -- Windows: custom install path for language servers.
  return M.appdata_dir() .. '\\editor-lsp\\bin'
end

return M

