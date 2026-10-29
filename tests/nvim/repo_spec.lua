-- Repo hygiene: secrets handling, opencode config shape, stow layout.
local function read(path)
	local f = assert(io.open(path, "r"))
	local s = f:read("*a")
	f:close()
	return s
end

local function git(args)
	local cmd = vim.list_extend({ "git", "-C", DOTFILES_ROOT }, args)
	local out = vim.fn.system(cmd)
	return vim.v.shell_error, out
end

describe("secrets", function()
	it("keeps a secrets.lua.example template with placeholders only", function()
		local src = read(NVIM_DIR .. "/lua/secrets.lua.example")
		assert.is_truthy(src:find("YOUR_KEY_HERE", 1, true))
		assert.is_nil(src:find("sk%-ant%-[%w_%-]+[a-z0-9]{30}"))
	end)

	it("git-ignores lua/secrets.lua", function()
		if vim.fn.executable("git") == 0 then
			return pending("git not available")
		end
		local code = git({ "check-ignore", "-q", "nvim/.config/nvim/lua/secrets.lua" })
		assert.are.equal(0, code)
	end)

	it("does not track lua/secrets.lua", function()
		if vim.fn.executable("git") == 0 then
			return pending("git not available")
		end
		local _, out = git({ "ls-files", "nvim/.config/nvim/lua/secrets.lua" })
		assert.are.equal("", vim.trim(out))
	end)

	it("has no obvious credentials in tracked files", function()
		if vim.fn.executable("git") == 0 then
			return pending("git not available")
		end
		local _, out = git({ "ls-files" })
		local patterns = {
			"sk%-ant%-api%d%d%-[%w_%-]+",
			"sk%-proj%-[%w_%-]+",
			"ghp_%w+",
			"github_pat_%w+",
			"glpat%-[%w_%-]+",
			"AKIA%u%d[%u%d]+",
			"xox[abp]%-[%w%-]+",
		}
		local hits = {}
		for file in out:gmatch("[^\n]+") do
			local skip = file:match("^tests/") or file:match("%.example$") or file:match("lazy%-lock%.json$")
			local abs = DOTFILES_ROOT .. "/" .. file
			if not skip and vim.fn.filereadable(abs) == 1 and vim.fn.getfsize(abs) < 1024 * 1024 then
				local content = read(abs)
				for _, pat in ipairs(patterns) do
					local m = content:match(pat)
					-- ignore obvious placeholders
					if m and not m:find("YOUR", 1, true) and #m > 20 then
						hits[#hits + 1] = file .. ": " .. m:sub(1, 8) .. "…"
					end
				end
			end
		end
		assert.are.same({}, hits)
	end)
end)

describe("opencode.jsonc", function()
	local raw = read(DOTFILES_ROOT .. "/opencode/opencode.jsonc")
	-- strip // line comments (not inside URLs: require start-of-line or whitespace before)
	local stripped = raw:gsub("\n%s*//[^\n]*", "\n"):gsub("%s//[^\n\"]*\n", "\n")
	local ok, cfg = pcall(vim.json.decode, stripped)

	it("parses as JSON once comments are removed", function()
		assert.is_true(ok, tostring(cfg))
	end)

	it("declares models", function()
		assert.are.equal("string", type(cfg.model))
		assert.are.equal("string", type(cfg.small_model))
	end)

	it("defines the expected MCP servers", function()
		for _, name in ipairs({ "aws", "kubernetes", "docker", "ansible", "github", "postgres", "context7" }) do
			assert.is_not_nil(cfg.mcp[name], name .. " missing from mcp")
		end
	end)

	it("gives every MCP server a valid type and launch target", function()
		for name, server in pairs(cfg.mcp) do
			assert.is_true(vim.tbl_contains({ "local", "remote" }, server.type), name .. ": bad type")
			if server.type == "local" then
				assert.is_true(type(server.command) == "table" and #server.command > 0, name .. ": no command")
			else
				assert.is_truthy(server.url and server.url:match("^https?://"), name .. ": no url")
			end
			if server.enabled ~= nil then
				assert.are.equal("boolean", type(server.enabled), name .. ": enabled must be boolean")
			end
		end
	end)
end)

describe("stow layout", function()
	-- Each stow package mirrors $HOME, so configs must live under dot-paths.
	local expected = {
		"nvim/.config/nvim/init.lua",
		"alacritty/.config/alacritty.toml",
		"kitty/.config/kitty/kitty.conf",
		"mise/.config/mise/config.toml",
		"tmux/.tmux.conf",
		"zshrc/.zshrc",
	}
	for _, rel in ipairs(expected) do
		it(rel .. " exists", function()
			assert.are.equal(1, vim.fn.filereadable(DOTFILES_ROOT .. "/" .. rel))
		end)
	end

	it("nvim init.lua loads core then lazy", function()
		local src = read(NVIM_DIR .. "/init.lua")
		local core = src:find('require("saad.core")', 1, true)
		local lazy = src:find('require("saad.lazy")', 1, true)
		assert.is_truthy(core and lazy and core < lazy)
	end)
end)

describe("GIT_WARNING policy", function()
	it("is present (no git operations without explicit user authorization)", function()
		assert.are.equal(1, vim.fn.filereadable(DOTFILES_ROOT .. "/GIT_WARNING.md"))
	end)
end)
