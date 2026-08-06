local M = {}

--- Shared exclude globs (from Telescope TELESCOPE_RG_EXCLUDE_GLOBS).
M.EXCLUDE_GLOBS = {
	"!.git",
	"!**/.git/**",
	"!**/node_modules/**",
	"!**/dist/**",
	"!**/build/**",
	"!**/.cache/**",
	"!**/bin/**",
	"!**/obj/**",
	"!**/*.min.*",
	"!**/*.d.ts",
	"!**/*.g.cs",
	"!**/wwwroot/lib/**",
	"!**/*syncfusion*",
	"!**/jquery*.js",
	"!**/jquery*.map",
	"!**/bootstrap/**",
	"!**/tests/mocks/**",
	"!**/Extrernal DLLs/**",
	"!**/*.map",
}

--- Lua patterns equivalent to EXCLUDE_GLOBS for path matching.
local IGNORE_PATTERNS = {
	"(^|/)%.git(/|$)",
	"(^|/)node_modules(/|$)",
	"(^|/)dist(/|$)",
	"(^|/)build(/|$)",
	"(^|/)%.cache(/|$)",
	"(^|/)bin(/|$)",
	"(^|/)obj(/|$)",
	"%.min%.[^/]+$",
	"%.d%.ts$",
	"%.g%.cs$",
	"(^|/)wwwroot/lib(/|$)",
	"syncfusion",
	"(^|/)jquery[^/]*%.js$",
	"(^|/)jquery[^/]*%.map$",
	"(^|/)bootstrap(/|$)",
	"(^|/)tests/mocks(/|$)",
	"(^|/)Extrernal DLLs(/|$)",
	"%.map$",
}

--- Flat list of `-g`, pattern pairs for the rg CLI.
function M.rg_glob_args()
	local args = {}
	for _, g in ipairs(M.EXCLUDE_GLOBS) do
		args[#args + 1] = "-g"
		args[#args + 1] = g
	end
	return args
end

--- Whether `path` matches a shared exclude (for findfunc fallback).
function M.should_ignore(path)
	if not path or path == "" then
		return false
	end
	path = path:gsub("\\", "/")
	for _, pat in ipairs(IGNORE_PATTERNS) do
		if path:match(pat) then
			return true
		end
	end
	return false
end

return M
