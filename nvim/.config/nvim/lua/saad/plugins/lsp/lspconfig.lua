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
		-- Verificar se a nova API está disponível
		local use_new_api = vim.fn.has("nvim-0.11") == 1

		if use_new_api then
			-- Nova configuração para Neovim 0.11+
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
				-- Usando a nova API vim.lsp.config

				-- Ansible LSP
				vim.lsp.config.ansiblels = {
					cmd = { "ansible-language-server", "--stdio" },
					filetypes = { "yaml.ansible" },
					root_markers = { ".ansible-lint", "ansible.cfg", ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
				}

				-- Terraform LSP
				vim.lsp.config.terraformls = {
					cmd = { "terraform-ls", "serve" },
					filetypes = { "terraform", "terraform-vars" },
					root_markers = { ".terraform", "*.tf", ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
				}

				-- Jinja LSP
				vim.lsp.config.jinja_lsp = {
					cmd = { "jinja-lsp" },
					filetypes = { "jinja2", "jinja" },
					root_markers = { ".git", "requirements.txt", "pyproject.toml", "setup.py" },
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						templates = "./templates",
						backend = { "./src", "./app" },
						lang = "python",
					},
				}

				-- YAML LSP
				vim.lsp.config.yamlls = {
					cmd = { "yaml-language-server", "--stdio" },
					filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
					root_markers = { ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						yaml = {
							schemaStore = {
								enable = true,
								url = "https://www.schemastore.org/api/json/catalog.json",
							},
							schemas = {
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
							customTags = {
								"!reference sequence",
								"!secret scalar",
							},
						},
					},
				}

				-- Lua LSP
				vim.lsp.config.lua_ls = {
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
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = {
								enable = false,
							},
						},
					},
				}

				-- Dart LSP
				vim.lsp.config.dartls = {
					cmd = { "dart", "language-server", "--protocol=lsp" },
					filetypes = { "dart" },
					root_markers = { "pubspec.yaml", ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						dart = {
							completeFunctionCalls = true,
							showTodos = true,
						},
					},
				}
			end)
		else
			-- Configuração antiga para versões anteriores ao Neovim 0.11
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
				-- Configurar LSPs usando lspconfig tradicional (versão antiga)

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

				-- Jinja LSP
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
							schemaStore = {
								enable = true,
								url = "https://www.schemastore.org/api/json/catalog.json",
							},
							schemas = {
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
		end
	end,
}
