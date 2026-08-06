local ignores = require("ignores")

local has_rg = vim.fn.executable("rg") == 1
local cached_cwd ---@type string|nil
local cached_files ---@type string[]|nil

local function list_via_rg()
	local cmd = { "rg", "--files", "--hidden" }
	vim.list_extend(cmd, ignores.rg_glob_args())
	local files = vim.fn.systemlist(cmd)
	if vim.v.shell_error ~= 0 then
		return nil
	end
	return files
end

local function list_via_glob()
	local files = vim.fn.glob("**/*", true, true)
	local result = {}
	for _, f in ipairs(files) do
		if vim.fn.isdirectory(f) == 0 and not ignores.should_ignore(f) then
			result[#result + 1] = f
		end
	end
	return result
end

local function list_files()
	local cwd = vim.fn.getcwd()
	if cached_files and cached_cwd == cwd then
		return cached_files
	end

	local files
	if has_rg then
		files = list_via_rg()
	end
	if not files then
		files = list_via_glob()
	end

	cached_cwd = cwd
	cached_files = files
	return files
end

vim.api.nvim_create_autocmd("DirChanged", {
	group = vim.api.nvim_create_augroup("config-find-cache", { clear = true }),
	callback = function()
		cached_cwd = nil
		cached_files = nil
	end,
})

function _G.native_find(text, _)
	local files = list_files()
	if not text or text == "" then
		return files
	end
	return vim.fn.matchfuzzy(files, text)
end

vim.opt.findfunc = "v:lua.native_find"

vim.keymap.set("n", "<C-p>", ":find ", { silent = false, desc = "Find files" })
