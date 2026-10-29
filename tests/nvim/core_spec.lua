-- Unit tests for saad.core: options, keymaps and autocmds.
describe("saad.core", function()
	before_each(function()
		for name in pairs(package.loaded) do
			if name:match("^saad%.core") then
				package.loaded[name] = nil
			end
		end
		vim.g.mapleader = nil
		require("saad.core")
	end)

	describe("options", function()
		local expected = {
			relativenumber = true,
			number = true,
			tabstop = 2,
			shiftwidth = 2,
			expandtab = true,
			autoindent = true,
			wrap = false,
			ignorecase = true,
			smartcase = true,
			cursorline = true,
			termguicolors = true,
			background = "dark",
			signcolumn = "yes",
			splitright = true,
			splitbelow = true,
			swapfile = false,
		}
		for name, value in pairs(expected) do
			it(("sets %s = %s"):format(name, tostring(value)), function()
				assert.are.same(value, vim.o[name])
			end)
		end

		it("uses system clipboard (unnamedplus)", function()
			assert.is_truthy(vim.o.clipboard:find("unnamedplus", 1, true))
		end)

		it("allows backspace over indent, eol and start", function()
			assert.are.equal("indent,eol,start", vim.o.backspace)
		end)
	end)

	describe("keymaps", function()
		it("uses space as leader", function()
			assert.are.equal(" ", vim.g.mapleader)
		end)

		-- { mode, lhs (leader already expanded), expected rhs substring or nil, desc }
		local maps = {
			{ "i", "jk", "<Esc>", "Exit insert mode with jk" },
			{ "n", " nh", nil, "Clear search highlights" },
			{ "n", "<Esc>", nil, "Clear search highlights" },
			{ "n", "<C-D>", nil, "center the cursor" },
			{ "n", "<C-U>", nil, "center the cursor" },
			{ "n", "gd", nil, "go to definition" },
			{ "n", "K", nil, "Mostra documentação" },
			{ "n", " rn", nil, "Smart rename" },
			{ "n", " ca", nil, "Code Action" },
			{ "n", "[d", nil, "diagnostic prev " },
			{ "n", "]d", nil, "diagnostic next " },
			{ "n", " D", nil, "Open Float Diagnostic" },
			{ "n", " +", nil, "Increment number" },
			{ "n", " -", nil, "Decrement number" },
			{ "n", " sv", nil, "Split window vertically" },
			{ "n", " sh", nil, "Split window horizontally" },
			{ "n", " se", nil, "Make splits equal size" },
			{ "n", " sx", nil, "Close current split" },
			{ "n", " to", nil, "Open new tab" },
			{ "n", " tx", nil, "Close current tab" },
			{ "n", " tn", nil, "Go to next tab" },
			{ "n", " tp", nil, "Go to previous tab" },
			{ "n", " tf", nil, "Open current buffer in new tab" },
			{ "v", "<", "<gv", "Ident left" },
			{ "v", ">", ">gv", "Ident right" },
		}
		for _, m in ipairs(maps) do
			local mode, lhs, rhs, desc = m[1], m[2], m[3], m[4]
			it(("maps %s %q (%s)"):format(mode, lhs, desc), function()
				local map = vim.fn.maparg(lhs, mode, false, true)
				assert.is_truthy(map.lhs, "mapping missing")
				assert.are.equal(desc, map.desc)
				if rhs then
					assert.is_truthy(map.rhs and map.rhs:lower():find(rhs:lower(), 1, true))
				end
			end)
		end

		it("x deletes without touching registers", function()
			assert.are.equal('"_x', vim.fn.maparg("x", "n"))
		end)

		it("visual p keeps the last yank", function()
			assert.are.equal('"_dP', vim.fn.maparg("p", "v"))
		end)

		it("window/tab leader mappings use <cmd> or native window commands", function()
			assert.are.equal("<C-W>v", vim.fn.maparg(" sv", "n"))
			assert.is_truthy(vim.fn.maparg(" sx", "n"):find("close", 1, true))
			assert.is_truthy(vim.fn.maparg(" to", "n"):find("tabnew", 1, true))
		end)
	end)

	describe("autocmds", function()
		it("highlights on yank", function()
			local acs = vim.api.nvim_get_autocmds({ event = "TextYankPost", group = "kickstart-highlight-yank" })
			assert.is_true(#acs >= 1)
		end)

		it("is idempotent when reloaded (augroup cleared)", function()
			package.loaded["saad.core.api"] = nil
			require("saad.core.api")
			local acs = vim.api.nvim_get_autocmds({ event = "TextYankPost", group = "kickstart-highlight-yank" })
			assert.are.equal(1, #acs)
		end)
	end)
end)
