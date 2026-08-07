local M = {}

-- ── Git branches ────────────────────────────────────────────────────────────

local function sanitize_branch(name)
	return vim.trim(name or ""):gsub("%s+", "_")
end

local function git_branch_names()
	local lines = vim.fn.systemlist({ "git", "branch", "-a", "--format=%(refname:short)" })
	if vim.v.shell_error ~= 0 then
		return {}
	end

	local seen = {}
	local branches = {}
	for _, ref in ipairs(lines) do
		local name = ref:gsub("^remotes/origin/", ""):gsub("^origin/", "")
		if name ~= "" and name ~= "HEAD" and not seen[name] then
			seen[name] = true
			branches[#branches + 1] = name
		end
	end
	table.sort(branches)
	return branches
end

---Cmdline: :GitSwitch {name} — checkout; else checkout -b (spaces → _).
function M.git_switch(name)
	local branch = sanitize_branch(name)
	if branch == "" then
		vim.notify("Git: empty branch name", vim.log.levels.WARN)
		return
	end

	vim.fn.system({ "git", "checkout", branch })
	if vim.v.shell_error == 0 then
		return
	end

	local err = vim.fn.system({ "git", "checkout", "-b", branch })
	if vim.v.shell_error ~= 0 then
		vim.notify(vim.trim(err), vim.log.levels.ERROR)
	else
		vim.notify("Created and switched to: " .. branch, vim.log.levels.INFO)
	end
end

vim.api.nvim_create_user_command("GitSwitch", function(opts)
	M.git_switch(opts.args)
end, {
	nargs = 1,
	complete = function(arglead)
		local branches = git_branch_names()
		if arglead == "" then
			return branches
		end
		return vim.fn.matchfuzzy(branches, arglead)
	end,
})

-- ── Keymaps ─────────────────────────────────────────────────────────────────

vim.keymap.set("n", "<C-h>", "<cmd>marks<CR>", { silent = true, desc = "List marks (:marks)" })
vim.keymap.set("n", "<C-j>", ":b ", { silent = false, desc = "Buffer (:b)" })
vim.keymap.set("n", "<leader>b", ":b ", { silent = false, desc = "Buffer (:b)" })
vim.keymap.set("n", "<leader>fs", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP client attached", vim.log.levels.WARN)
		return
	end
	vim.lsp.buf.document_symbol({
		on_list = function(options)
			vim.fn.setloclist(0, {}, " ", options)
			vim.cmd("lopen")
		end,
	})
end, { silent = true, desc = "LSP document symbols → loclist" })
vim.keymap.set("n", "<leader>gc", ":GitSwitch ", { silent = false, desc = "Git switch/create branch" })

return M
