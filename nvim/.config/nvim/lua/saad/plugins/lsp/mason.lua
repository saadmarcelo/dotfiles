return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				"jqls",
				"html",
				"ansiblels",
				"bashls",
				"dockerls",
				"lua_ls",
				"graphql",
				"docker_compose_language_service",
				"helm_ls",
				"tflint",
				"jsonls",
				"sqlls",
				"ruff",
				"terraformls",
				"eslint",
				"taplo",
				"yamlls",
				-- ========== TYPESCRIPT/CDK ==========
				"ts_ls", -- TypeScript Language Server (novo nome do tsserver)
			},
			automatic_installation = true,
		})

		vim.schedule(function()
			mason_tool_installer.setup({
				ensure_installed = {
					"prettier", -- formatter
					"stylua", -- lua formatter
					"isort", -- python formatter
					"black", -- python formatter
					"pylint", -- python linter
					"eslint_d", -- js/ts linter
					"docformatter",
					"djlint", -- Jinja2 linter e formatter
					-- ========== TYPESCRIPT/CDK ==========
					"prettierd", -- Formatter rápido para TS/JS
					"biome", -- Linter/Formatter alternativo super rápido
				},
				auto_update = false,
				run_on_start = true,
			})
		end)
	end,
}
