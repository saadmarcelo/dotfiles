return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
		"antosha417/nvim-lsp-file-operations",
		{ "folke/neodev.nvim", opts = {} },
		{
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
	},
	config = function()
		-- Importações iniciais
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- Habilidades de autocompletar para todos os LSPs
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Função on_attach para configurar mapeamentos locais
		local on_attach = function(client, bufnr)
			local opts = { noremap = true, silent = true, buffer = bufnr }

			-- Mapeamentos básicos de LSP
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float, opts)

			-- Adicionando seus keybinds personalizados
			vim.keymap.set("n", "<leader>ld", vim.lsp.buf.type_definition, opts)
			vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, opts)
			vim.keymap.set("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, opts)
			vim.keymap.set("n", "<leader>lwl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)
		end

		-- Diagnósticos personalizados
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			-- vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
		})
		-- Adicionar suporte ao Terraform
		vim.filetype.add({
			extension = {
				tf = "terraform",
			},
		})

		-- LSPs específicos
		lspconfig.ansiblels.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "yaml.ansible" },
			root_dir = lspconfig.util.root_pattern("roles", "playbooks"),
		})

		lspconfig.terraformls.setup({
			capabilities = capabilities,
			filetypes = { "terraform", "tf" },
			on_attach = on_attach,
		})

		lspconfig.yamlls.setup({
			capabilities = capabilities,
			filetypes = { "yaml", "yaml.kubernetes" },
			settings = {
				yaml = {
					schemas = {
						["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.31.1-standalone-strict/all.json"] = {
							"*.k8s.yaml",
							"k8s-*.yaml",
							"/*.yaml",
						},
						["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
						["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
						["http://json.schemastore.org/ansible-playbook"] = "playbooks/**/*.{yml,yaml}",
						["http://json.schemastore.org/ansible-stable-2.9"] = "roles/**/*.{yml,yaml}",
						["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
						["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
						["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
						["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
					},
					validate = true,
					completion = true,
				},
			},
		})

		-- Configurações para outros LSPs
		mason_lspconfig.setup_handlers({
			-- Configuração padrão para todos os LSPs
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end,
			-- Configuração para Svelte
			["svelte"] = function()
				lspconfig.svelte.setup({
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						on_attach(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePost", {
							pattern = { "*.js", "*.ts", "*.yaml", "*.yml" },
							callback = function(ctx)
								if client.supports_method("$/onDidChangeTsOrJsFile") then
									client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
								end
							end,
						})
					end,
				})
			end,
			-- Configuração para Lua
			["lua_ls"] = function()
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
		})
	end,
}
