local M = {}

-- ── Marks ───────────────────────────────────────────────────────────────────

local function useful_mark_name(mark)
	-- getmarklist uses "'a"; keep alphanumeric marks only.
	local name = mark:gsub("^'", "")
	return name:match("^[%w]$") and name or nil
end

local function collect_marks()
	local seen = {}
	local items = {}

	local function add(m, scope)
		local name = useful_mark_name(m.mark)
		if not name or seen[name] then
			return
		end
		seen[name] = true
		local pos = m.pos or {}
		local lnum = pos[2] or 0
		local col = pos[3] or 0
		local file = m.file or ""
		if file == "" and pos[1] and pos[1] > 0 then
			file = vim.api.nvim_buf_get_name(pos[1])
		end
		local display = string.format("%s  %4d:%-3d  %s  [%s]", name, lnum, col, file ~= "" and file or "[No Name]", scope)
		items[#items + 1] = {
			name = name,
			lnum = lnum,
			col = col,
			file = file,
			display = display,
		}
	end

	for _, m in ipairs(vim.fn.getmarklist(vim.api.nvim_get_current_buf())) do
		add(m, "buf")
	end
	for _, m in ipairs(vim.fn.getmarklist()) do
		add(m, "global")
	end

	table.sort(items, function(a, b)
		return a.name < b.name
	end)
	return items
end

function M.marks()
	local items = collect_marks()
	if #items == 0 then
		vim.notify("No marks", vim.log.levels.INFO)
		return
	end

	vim.ui.select(items, {
		prompt = "Marks",
		format_item = function(item)
			return item.display
		end,
	}, function(choice)
		if not choice then
			return
		end
		if choice.file ~= "" then
			local cur = vim.api.nvim_buf_get_name(0)
			if choice.file ~= cur then
				vim.cmd("edit " .. vim.fn.fnameescape(choice.file))
			end
		end
		local lnum = math.max(choice.lnum, 1)
		local col = math.max(choice.col - 1, 0)
		local line_count = vim.api.nvim_buf_line_count(0)
		if lnum > line_count then
			lnum = line_count
		end
		pcall(vim.api.nvim_win_set_cursor, 0, { lnum, col })
	end)
end

-- ── Buffers ─────────────────────────────────────────────────────────────────

function M.buffers()
	local items = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[bufnr].buflisted then
			local name = vim.api.nvim_buf_get_name(bufnr)
			if name == "" then
				name = "[No Name]"
			else
				name = vim.fn.fnamemodify(name, ":~:.")
			end
			local modified = vim.bo[bufnr].modified and " [+]" or ""
			local current = bufnr == vim.api.nvim_get_current_buf() and " *" or ""
			items[#items + 1] = {
				bufnr = bufnr,
				display = string.format("%d  %s%s%s", bufnr, name, modified, current),
			}
		end
	end

	if #items == 0 then
		vim.notify("No buffers", vim.log.levels.INFO)
		return
	end

	vim.ui.select(items, {
		prompt = "Buffers",
		format_item = function(item)
			return item.display
		end,
	}, function(choice)
		if choice then
			vim.api.nvim_set_current_buf(choice.bufnr)
		end
	end)
end

-- ── Document symbols ────────────────────────────────────────────────────────

function M.document_symbols()
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
end

-- ── Git branches ────────────────────────────────────────────────────────────

local function git_worktree()
	if vim.fn.exists("*FugitiveGitDir") == 1 then
		local fugitive_dir = vim.fn.FugitiveGitDir()
		if fugitive_dir ~= "" then
			return vim.fn.fnamemodify(fugitive_dir, ":h")
		end
	end
	local wt = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })[1]
	if vim.v.shell_error == 0 and wt and wt ~= "" then
		return wt
	end
	return nil
end

local function normalize_branch_ref(ref)
	return ref:gsub("^remotes/origin/", ""):gsub("^origin/", "")
end

local function branch_name_from_prompt(prompt)
	return vim.trim(prompt or ""):gsub("%s+", "_")
end

local function local_branch_exists(worktree, branch)
	vim.fn.system({ "git", "-C", worktree, "show-ref", "--verify", "--quiet", "refs/heads/" .. branch })
	return vim.v.shell_error == 0
end

local function remote_branch_exists(worktree, branch)
	vim.fn.system({ "git", "-C", worktree, "show-ref", "--verify", "--quiet", "refs/remotes/origin/" .. branch })
	return vim.v.shell_error == 0
end

local function branch_has_upstream(worktree)
	vim.fn.system({ "git", "-C", worktree, "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}" })
	return vim.v.shell_error == 0
end

local function ensure_upstream(worktree, branch)
	if not remote_branch_exists(worktree, branch) or branch_has_upstream(worktree) then
		return
	end

	local err = vim.fn.system({
		"git",
		"-C",
		worktree,
		"branch",
		"--set-upstream-to=origin/" .. branch,
		branch,
	})
	if vim.v.shell_error ~= 0 then
		vim.notify("Git: failed to set upstream: " .. vim.trim(err), vim.log.levels.WARN)
	end
end

local function switch_to_branch(worktree, branch)
	if local_branch_exists(worktree, branch) then
		local err = vim.fn.system({ "git", "-C", worktree, "switch", branch })
		if vim.v.shell_error ~= 0 then
			return "Git: failed to switch branch: " .. vim.trim(err)
		end
		ensure_upstream(worktree, branch)
		return nil
	end

	if remote_branch_exists(worktree, branch) then
		local err = vim.fn.system({ "git", "-C", worktree, "switch", "--track", "origin/" .. branch })
		if vim.v.shell_error ~= 0 then
			return "Git: failed to track remote branch: " .. vim.trim(err)
		end
		return nil
	end

	return "Git: branch not found locally or on origin: " .. branch
end

local function git_branch_names(worktree)
	local lines = vim.fn.systemlist({
		"git",
		"-C",
		worktree,
		"branch",
		"-a",
		"--format=%(refname:short)",
	})
	if vim.v.shell_error ~= 0 then
		return nil
	end

	local seen = {}
	local branches = {}
	for _, ref in ipairs(lines) do
		local name = normalize_branch_ref(ref)
		if name ~= "" and name ~= "HEAD" and not seen[name] then
			seen[name] = true
			branches[#branches + 1] = name
		end
	end
	table.sort(branches)
	return branches
end

local function create_branch(worktree, name)
	local branch = branch_name_from_prompt(name)
	if branch == "" then
		return "Git: empty branch name"
	end
	local err = vim.fn.system({ "git", "-C", worktree, "switch", "-c", branch })
	if vim.v.shell_error ~= 0 then
		return "Git: failed to create branch: " .. vim.trim(err)
	end
	vim.notify("Created and switched to: " .. branch, vim.log.levels.INFO)
	return nil
end

---Switch if local/remote exists; otherwise create and switch.
local function switch_or_create(worktree, name)
	local branch = branch_name_from_prompt(name)
	if branch == "" then
		return "Git: empty branch name"
	end
	if local_branch_exists(worktree, branch) or remote_branch_exists(worktree, branch) then
		return switch_to_branch(worktree, branch)
	end
	return create_branch(worktree, branch)
end

local function notify_git_err(err)
	if err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end

---Cmdline: :GitSwitch {name} — Tab complete; missing name creates branch.
function M.git_switch(name)
	local worktree = git_worktree()
	if not worktree then
		vim.notify("Git: not in a Git repository", vim.log.levels.WARN)
		return
	end
	notify_git_err(switch_or_create(worktree, name))
end

vim.api.nvim_create_user_command("GitSwitch", function(opts)
	M.git_switch(opts.args)
end, {
	nargs = 1,
	complete = function(arglead)
		local worktree = git_worktree()
		if not worktree then
			return {}
		end
		local branches = git_branch_names(worktree) or {}
		if arglead == "" then
			return branches
		end
		return vim.fn.matchfuzzy(branches, arglead)
	end,
})

-- ── Keymaps ─────────────────────────────────────────────────────────────────

vim.keymap.set("n", "<C-h>", M.marks, { silent = true, desc = "Marks picker" })
vim.keymap.set("n", "<C-j>", M.buffers, { silent = true, desc = "Buffers picker" })
vim.keymap.set("n", "<leader>b", M.buffers, { silent = true, desc = "Buffers picker" })
vim.keymap.set("n", "<leader>fs", M.document_symbols, { silent = true, desc = "LSP document symbols" })
vim.keymap.set("n", "<leader>gc", ":GitSwitch ", { silent = false, desc = "Git switch/create branch" })

return M
