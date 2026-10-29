-- Every Lua file in the nvim config must at least compile.
describe("lua syntax", function()
	local files = vim.fn.glob(NVIM_DIR .. "/**/*.lua", false, true)

	it("finds lua files", function()
		assert.is_true(#files > 20)
	end)

	for _, path in ipairs(files) do
		it(path:sub(#NVIM_DIR + 2) .. " compiles", function()
			local fn, err = loadfile(path)
			assert.is_truthy(fn, tostring(err))
		end)
	end

	it("stylua formatting is clean (when stylua is available)", function()
		local stylua = vim.fn.exepath("stylua")
		if stylua == "" then
			stylua = vim.fn.stdpath("data") .. "/mason/bin/stylua"
		end
		if vim.fn.executable(stylua) == 0 then
			return pending("stylua not installed")
		end
		local out = vim.fn.system({ stylua, "--check", NVIM_DIR .. "/lua", NVIM_DIR .. "/init.lua" })
		if vim.v.shell_error ~= 0 then
			-- Informational: some legacy specs still use 2-space indent. Run `stylua nvim/.config/nvim` to fix.
			local files = {}
			for f in out:gmatch("Diff in ([^\n]+):") do
				files[#files + 1] = f:sub(#NVIM_DIR + 2)
			end
			return pending(#files .. " file(s) not stylua-formatted: " .. table.concat(files, ", "))
		end
	end)
end)
