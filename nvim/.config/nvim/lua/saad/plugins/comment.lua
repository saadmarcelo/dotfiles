return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		local comment = require("Comment")

		comment.setup({
			pre_hook = function(ctx)
				local ok, ts = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
				if ok and ts and ts.create_pre_hook then
					local hook = ts.create_pre_hook()
					if hook then
						local result = hook(ctx)
						if result then
							return result
						end
					end
				end
				local ft = vim.bo.filetype
				if ft == "ansible" or ft == "yaml" then
					return "# %s"
				end
			end,
		})
	end,
}