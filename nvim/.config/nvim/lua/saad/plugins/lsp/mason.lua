return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")
		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Configurar mason-lspconfig ANTES do mason-tool-installer
		mason_lspconfig.setup({
			-- list of servers for mason to install
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
			},
			automatic_installation = true,
		})

		-- Aguardar um pouco antes de configurar o tool-installer
		vim.schedule(function()
			mason_tool_installer.setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"isort", -- python formatter
					"black", -- python formatter
					"pylint", -- python linter
					"eslint_d", -- js linter
					"docformatter",
				},
				auto_update = false, -- adicionar esta opção
				run_on_start = true,
			})
		end)
	end,
}
