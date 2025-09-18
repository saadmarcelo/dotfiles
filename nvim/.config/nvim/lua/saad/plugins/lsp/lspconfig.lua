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

		-- Configurações específicas para cada LSP usando vim.lsp.config
		local servers = {
			ansiblels = {
				name = "ansiblels",
				cmd = { "ansible-language-server", "--stdio" },
				filetypes = { "yaml.ansible" },
				root_markers = { "ansible.cfg", ".ansible-lint", "playbook.yml", "playbooks/" },
				capabilities = capabilities,
				on_attach = on_attach,
			},
			terraformls = {
				name = "terraformls",
				cmd = { "terraform-ls", "serve" },
				filetypes = { "terraform", "tf" },
				root_markers = { ".terraform", "*.tf" },
				capabilities = capabilities,
				on_attach = on_attach,
			},
			yamlls = {
				name = "yamlls",
				cmd = { "yaml-language-server", "--stdio" },
				filetypes = { "yaml", "yaml.kubernetes" },
				root_markers = { ".git" },
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
			},
			lua_ls = {
				name = "lua_ls",
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = {
					".luarc.json",
					".luarc.jsonc",
					".luacheckrc",
					".stylua.toml",
					"stylua.toml",
					"selene.toml",
					"selene.yml",
					".git",
				},
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
			},
			dartls = {
				name = "dartls",
				cmd = { "dart", "language-server", "--protocol=lsp" },
				filetypes = { "dart" },
				root_markers = { "pubspec.yaml" },
				capabilities = capabilities,
				on_attach = on_attach,
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
			-- Configurar usando vim.lsp.config (novo método)
			for server_name, config in pairs(servers) do
				vim.lsp.config[server_name] = config
			end
		end)
	end,
}
