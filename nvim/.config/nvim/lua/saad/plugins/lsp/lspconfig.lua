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
				root_dir = lspconfig.util.root_pattern("roles", "playbooks"),
			},
			terraformls = {
				filetypes = { "terraform", "tf" },
			},
			yamlls = {
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

		-- Configuração padrão para todos os LSPs
		for server, config in pairs(servers) do
			lspconfig[server].setup(vim.tbl_extend("keep", {
				capabilities = capabilities,
				on_attach = on_attach,
			}, config))
		end
	end,
}
