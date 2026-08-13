local languages = {
	"bash",
	"c",
	"css",
	"dockerfile",
	"gitignore",
	"graphql",
	"hcl",
	"helm",
	"html",
	"javascript",
	"json",
	"lua",
	"prisma",
	"python",
	"query",
	"regex",
	"svelte",
	"terraform",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

local disabled_filetypes = {
	markdown = true,
	tmux = true,
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = function()
		require("nvim-treesitter").install(languages, { summary = true }):wait(300000)
	end,
	dependencies = {
		{
			"windwp/nvim-ts-autotag",
			opts = {
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = false,
				},
			},
		},
	},
	config = function()
		local group = vim.api.nvim_create_augroup("SaadTreesitter", { clear = true })

		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = "*",
			callback = function(args)
				local filetype = vim.bo[args.buf].filetype

				if vim.bo[args.buf].buftype ~= "" then
					return
				end

				if disabled_filetypes[filetype] then
					pcall(vim.treesitter.stop, args.buf)
					return
				end

				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}
