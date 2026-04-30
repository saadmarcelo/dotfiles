return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    local comment = require("Comment")

    local ok, ts_context_commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
    local pre_hook = nil
    if ok and ts_context_commentstring and ts_context_commentstring.create_pre_hook then
      pre_hook = ts_context_commentstring.create_pre_hook()
    end

    comment.setup({
      pre_hook = pre_hook,
    })
  end,
}
