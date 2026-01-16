-- ~/.config/nvim/lua/plugins/typescript-tools.lua
-- Plugin com ferramentas extras para TypeScript (melhor que ts_ls sozinho)

return {
	"pmizio/typescript-tools.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"neovim/nvim-lspconfig",
	},
	ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	config = function()
		require("typescript-tools").setup({
			-- ========== CONFIGURAÇÕES DO LSP ==========
			on_attach = function(client, bufnr)
				-- Desabilitar formatação (vamos usar Prettier)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				-- Keymaps específicos do TypeScript
				local opts = { noremap = true, silent = true, buffer = bufnr }

				vim.keymap.set("n", "<leader>to", ":TSToolsOrganizeImports<CR>", opts)
				vim.keymap.set("n", "<leader>ts", ":TSToolsSortImports<CR>", opts)
				vim.keymap.set("n", "<leader>tu", ":TSToolsRemoveUnused<CR>", opts)
				vim.keymap.set("n", "<leader>ti", ":TSToolsAddMissingImports<CR>", opts)
				vim.keymap.set("n", "<leader>tf", ":TSToolsFixAll<CR>", opts)
				vim.keymap.set("n", "<leader>tg", ":TSToolsGoToSourceDefinition<CR>", opts)
				vim.keymap.set("n", "<leader>tr", ":TSToolsRenameFile<CR>", opts)
				vim.keymap.set("n", "<leader>tF", ":TSToolsFileReferences<CR>", opts)
			end,

			-- ========== CONFIGURAÇÕES DO SERVIDOR ==========
			settings = {
				-- ========== ESPECÍFICO PARA CDK ==========
				separate_diagnostic_server = true,
				publish_diagnostic_on = "insert_leave",

				-- Completação de funções completas
				completions = {
					completeFunctionCalls = true,
				},

				-- Inlay hints (mostra tipos inline)
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = false,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},

				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = false,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
		})

		-- ========== COMANDOS CUSTOMIZADOS EM PORTUGUÊS ==========
		vim.api.nvim_create_user_command("TSOrganizar", "TSToolsOrganizeImports", {})
		vim.api.nvim_create_user_command("TSLimpar", "TSToolsRemoveUnused", {})
		vim.api.nvim_create_user_command("TSImportar", "TSToolsAddMissingImports", {})
		vim.api.nvim_create_user_command("TSCorrigir", "TSToolsFixAll", {})
	end,
}
