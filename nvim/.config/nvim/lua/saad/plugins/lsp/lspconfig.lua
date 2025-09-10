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
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
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

		-- Configurações específicas para cada LSP
		local servers = {
			ansiblels = {
				filetypes = { "yaml.ansible" },
				root_dir = lspconfig.util.root_pattern("ansible.cfg", ".ansible-lint", "playbook.yml", "playbooks/"),
			},
			terraformls = {
				filetypes = { "terraform", "tf" },
				root_dir = lspconfig.util.root_pattern(".terraform", "*.tf"),
			},
			yamlls = {
				filetypes = { "yaml", "yaml.kubernetes" },
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
			},
			lua_ls = {
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
			},
			dartls = {
				cmd = { "dart", "language-server", "--protocol=lsp" },
				filetypes = { "dart" },
				root_dir = lspconfig.util.root_pattern("pubspec.yaml"),
				settings = {
					dart = {
						completeFunctionCalls = true,
						showTodos = true,
					},
				},
			},
		}

		-- Aguardar a inicialização completa do Mason antes de configurar LSPs
		vim.schedule(function()
			-- Configuração padrão para todos os LSPs
			for server, config in pairs(servers) do
				local final_config = vim.tbl_deep_extend("force", {
					capabilities = capabilities,
					on_attach = on_attach,
				}, config)

				lspconfig[server].setup(final_config)
			end
		end)
	end,
}
