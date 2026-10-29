-- Unit tests for lazy.nvim plugin specs and the lockfile.
local function read(path)
	local f = assert(io.open(path, "r"))
	local s = f:read("*a")
	f:close()
	return s
end

local function list_lua(dir)
	local out = {}
	for _, p in ipairs(vim.fn.glob(dir .. "/*.lua", false, true)) do
		out[#out + 1] = p
	end
	table.sort(out)
	return out
end

local plugins_dir = NVIM_DIR .. "/lua/saad/plugins"
local files = list_lua(plugins_dir)
vim.list_extend(files, list_lua(plugins_dir .. "/lsp"))

-- Flatten a spec (string | table | list of specs) into a list of spec tables.
local function flatten(spec, acc)
	acc = acc or {}
	if type(spec) == "string" then
		acc[#acc + 1] = { spec }
	elseif type(spec) == "table" then
		if type(spec[1]) == "string" or spec.dir or spec.url or spec.import then
			acc[#acc + 1] = spec
			local deps = spec.dependencies or {}
			if type(deps) == "string" then
				deps = { deps }
			end
			for _, dep in ipairs(deps) do
				flatten(dep, acc)
			end
		else
			for _, s in ipairs(spec) do
				flatten(s, acc)
			end
		end
	end
	return acc
end

local function plugin_name(spec)
	if spec.name then
		return spec.name
	end
	local src = spec[1] or spec.url or spec.dir
	return (src:gsub("%.git$", ""):match("([^/]+)$"))
end

describe("plugin specs", function()
	it("finds plugin spec files", function()
		assert.is_true(#files > 10)
	end)

	for _, path in ipairs(files) do
		local rel = path:sub(#NVIM_DIR + 2)
		describe(rel, function()
			local ok, spec = pcall(dofile, path)

			it("loads without error", function()
				assert.is_true(ok, tostring(spec))
			end)

			it("returns a table", function()
				assert.are.equal("table", type(spec))
			end)

			it("has only well-formed specs", function()
				for _, s in ipairs(flatten(spec)) do
					local src = s[1] or s.url or s.dir or s.import
					assert.are.equal("string", type(src), "spec without source")
					if s[1] then
						assert.is_truthy(s[1]:match("^[%w%-%._]+/[%w%-%._]+$"), "bad plugin id: " .. s[1])
					end
					for _, key in ipairs({ "config", "init", "build" }) do
						if s[key] ~= nil then
							assert.is_true(vim.tbl_contains({ "function", "string", "boolean", "table" }, type(s[key])))
						end
					end
					if s.event ~= nil then
						assert.is_true(vim.tbl_contains({ "string", "table" }, type(s.event)))
					end
				end
			end)
		end)
	end

	it("does not declare the same plugin twice at top level with conflicting names", function()
		local seen = {}
		for _, path in ipairs(files) do
			local ok, spec = pcall(dofile, path)
			if ok then
				for _, s in ipairs(flatten(spec)) do
					if s[1] and s.priority then
						-- top-level specs only (priority is never set on dependencies here)
						seen[s[1]] = (seen[s[1]] or 0) + 1
					end
				end
			end
		end
		for id, n in pairs(seen) do
			assert.are.equal(1, n, id .. " declared " .. n .. " times with priority")
		end
	end)
end)

describe("lazy.lua", function()
	local src = read(NVIM_DIR .. "/lua/saad/lazy.lua")

	it("imports only saad.plugins and saad.plugins.lsp", function()
		local imports = {}
		for name in src:gmatch('import%s*=%s*"([^"]+)"') do
			imports[#imports + 1] = name
		end
		table.sort(imports)
		assert.are.same({ "saad.plugins", "saad.plugins.lsp" }, imports)
	end)

	it("never imports the disabled specs", function()
		assert.is_nil(src:find("disabled", 1, true))
	end)

	it("does not use deprecated vim.loop", function()
		assert.is_nil(src:find("vim.loop", 1, true))
	end)
end)

describe("lazy-lock.json", function()
	local lock = vim.json.decode(read(NVIM_DIR .. "/lazy-lock.json"))

	it("is valid JSON with branch+commit for every entry", function()
		for name, entry in pairs(lock) do
			assert.is_truthy(entry.commit and #entry.commit == 40, name .. ": bad commit")
			assert.is_truthy(entry.branch, name .. ": no branch")
		end
	end)

	it("locks every plugin declared in saad.plugins*", function()
		local missing = {}
		for _, path in ipairs(files) do
			local ok, spec = pcall(dofile, path)
			if ok then
				for _, s in ipairs(flatten(spec)) do
					if s[1] and not s.dir and not lock[plugin_name(s)] then
						missing[#missing + 1] = plugin_name(s)
					end
				end
			end
		end
		table.sort(missing)
		assert.are.same({}, missing)
	end)

	it("does not lock plugins that were replaced", function()
		assert.is_nil(lock["neodev.nvim"])
		assert.is_not_nil(lock["lazydev.nvim"])
	end)
end)

describe("disabled specs", function()
	it("are not valid-looking imports (kept out of the plugin tree)", function()
		for _, path in ipairs(list_lua(NVIM_DIR .. "/lua/saad/disabled")) do
			assert.is_nil(path:find("/plugins/", 1, true))
		end
	end)
end)

describe("mason.lua", function()
	local src = read(plugins_dir .. "/lsp/mason.lua")

	local function list_after(label)
		local block = src:match(label .. "%s*=%s*(%b{})")
		assert.is_truthy(block, label .. " block not found")
		local items = {}
		for name in block:gmatch('"([^"]+)"') do
			items[#items + 1] = name
		end
		return items
	end

	it("lists LSP servers without duplicates", function()
		local servers = list_after("ensure_installed")
		assert.is_true(#servers > 5)
		local seen = {}
		for _, s in ipairs(servers) do
			assert.is_nil(seen[s], "duplicate server " .. s)
			seen[s] = true
		end
	end)

	it("installs the language servers the config relies on", function()
		local servers = list_after("ensure_installed")
		for _, required in ipairs({ "lua_ls", "bashls", "yamlls", "terraformls", "ansiblels" }) do
			assert.is_true(vim.tbl_contains(servers, required), required .. " missing")
		end
	end)
end)

describe("lspconfig.lua", function()
	local src = read(plugins_dir .. "/lsp/lspconfig.lua")

	it("configures the custom servers with cmd and filetypes", function()
		local names = {}
		for name in src:gmatch("vim%.lsp%.config%.([%w_]+)%s*=") do
			names[#names + 1] = name
		end
		table.sort(names)
		assert.are.same({ "ansiblels", "jinja_lsp", "lua_ls", "terraformls", "yamlls" }, names)
		for _, name in ipairs(names) do
			local block = src:match("vim%.lsp%.config%." .. name .. "%s*=%s*(%b{})")
			assert.is_truthy(block:find("cmd%s*="), name .. ": no cmd")
			assert.is_truthy(block:find("filetypes%s*="), name .. ": no filetypes")
		end
	end)

	it("has no legacy lspconfig .setup() calls", function()
		assert.is_nil(src:find("lspconfig%.%w+%.setup"))
	end)

	it("uses lazydev instead of the archived neodev", function()
		assert.is_nil(src:find("neodev", 1, true))
		assert.is_truthy(src:find("lazydev.nvim", 1, true))
	end)
end)

describe("ftplugin", function()
	it("yaml.kubernetes.lua loads", function()
		local ok, err = pcall(dofile, NVIM_DIR .. "/ftplugin/yaml.kubernetes.lua")
		assert.is_true(ok, tostring(err))
	end)
end)
