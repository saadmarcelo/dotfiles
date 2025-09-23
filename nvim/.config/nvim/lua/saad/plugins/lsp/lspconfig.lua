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
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- Importações iniciais
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- Habilidades de autocompletar para todos os LSPs
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Função on_attach para configurar mapeamentos locais
		local on_attach = function(client, bufnr)
			local opts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "<leader>lwl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)
		end

		-- Configuração de diagnósticos
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
		})

		-- Adicionar suporte ao Terraform e Jinja2
		vim.filetype.add({
			extension = {
				tf = "terraform",
				j2 = "jinja2",
				jinja = "jinja2",
				jinja2 = "jinja2",
			},
			pattern = {
				[".*%.j2"] = "jinja2",
				[".*%.jinja"] = "jinja2",
				[".*%.jinja2"] = "jinja2",
			},
		})

		-- Aguardar a inicialização completa do Mason antes de configurar LSPs
		vim.schedule(function()
			-- Configurar LSPs usando lspconfig tradicional

			-- Ansible LSP
			lspconfig.ansiblels.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- Terraform LSP
			lspconfig.terraformls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- Jinja LSP (configuração corrigida)
			lspconfig.jinja_lsp.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "jinja2", "jinja" },
				root_dir = lspconfig.util.root_pattern(".git", "requirements.txt", "pyproject.toml", "setup.py"),
				settings = {
					templates = "./templates",
					backend = { "./src", "./app" },
					lang = "python",
				},
			})

			-- YAML LSP
			lspconfig.yamlls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					yaml = {
						-- Resolver problema de schemas múltiplos
						schemaStore = {
							enable = true,
							url = "https://www.schemastore.org/api/json/catalog.json",
						},
						schemas = {
							-- Usar apenas um schema por tipo de arquivo
							kubernetes = {
								"*.k8s.yaml",
								"k8s-*.yaml",
								"**/k8s/**/*.yaml",
								"**/kubernetes/**/*.yaml",
							},
							["http://json.schemastore.org/github-workflow"] = {
								".github/workflows/*.yml",
								".github/workflows/*.yaml",
							},
							["http://json.schemastore.org/github-action"] = {
								".github/action.yml",
								".github/action.yaml",
							},
							["http://json.schemastore.org/kustomization"] = {
								"kustomization.yml",
								"kustomization.yaml",
							},
							["http://json.schemastore.org/chart"] = {
								"Chart.yml",
								"Chart.yaml",
							},
						},
						validate = true,
						completion = true,
						hover = true,
						-- Reduzir validações conflitantes
						customTags = {
							"!reference sequence",
							"!secret scalar",
						},
					},
				},
			})

			-- Lua LSP
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						completion = {
							callSnippet = "Replace",
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			-- Dart LSP
			lspconfig.dartls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					dart = {
						completeFunctionCalls = true,
						showTodos = true,
					},
				},
			})
		end)
	end,
}
