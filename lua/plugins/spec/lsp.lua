return {
    {
        'mason-org/mason.nvim',
        cmd = { 'Mason', 'MasonInstall', 'MasonUpdate', 'MasonLog' },
        opts = {
            registries = {
                'github:mason-org/mason-registry',
                'github:Crashdummyy/mason-registry',
            },
        },
    },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      -- Install LSP servers used by core/lsp.lua.
      ensure_installed = {
        'bash-language-server',
        'css-lsp',
        'html-lsp',
        'json-lsp',
        'lua-language-server',
        'python-lsp-server',
        'roslyn',
        'tailwindcss-language-server',
        'taplo',
        'typescript-language-server',
        'yaml-language-server',
      },
      run_on_start = true,
      start_delay = 3000,
      auto_update = false,
    },
  },
    {
        'seblyng/roslyn.nvim',
        ft = { 'cs', 'razor' },
        dependencies = { 'mason-org/mason.nvim' },
        config = function()
            require('roslyn').setup({
                extensions = {
                    razor = { enabled = false },
                },
                broad_search = false,
                lock_target = true,
                -- choose_target receives *solution* paths (.sln / .slnx / .slnf), not .csproj
                choose_target = function(targets)
                    for _, t in ipairs(targets) do
                        local b = t:lower()
                        if (vim.endswith(t, '.sln') or vim.endswith(t, '.slnx') or vim.endswith(t, '.slnf')) then
                            if not b:find('test', 1, true) then
                                return t
                            end
                        end
                    end
                    for _, t in ipairs(targets) do
                        if not t:lower():find('test', 1, true) then
                            return t
                        end
                    end
                    return targets[1]
                end,
            })
        end,
    },
}

