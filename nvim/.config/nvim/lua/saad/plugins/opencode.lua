-- ~/.config/nvim/lua/saad/plugins/opencode.lua
-- Plugin OpenCode.nvim - IA integrada ao Neovim via terminal
return {
	"sudo-tee/opencode.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		-- ============================================
		-- CARREGAR API KEYS DO ARQUIVO SECRETS
		-- ============================================
		local secrets_ok, secrets = pcall(require, "secrets")
		if not secrets_ok then
			vim.notify(
				"⚠️  Arquivo secrets.lua não encontrado!\n"
					.. "Copie secrets.lua.example para secrets.lua e configure suas API keys.",
				vim.log.levels.WARN
			)
			-- Continua mesmo sem secrets para testes
		else
			-- Configurar variáveis de ambiente
			if secrets.openai_api_key then
				vim.env.OPENAI_API_KEY = secrets.openai_api_key
			end
			if secrets.anthropic_api_key then
				vim.env.ANTHROPIC_API_KEY = secrets.anthropic_api_key
			end
		end

		-- ============================================
		-- VERIFICAR SE OPENCODE CLI ESTÁ INSTALADO
		-- ============================================
		if vim.fn.executable("opencode") == 0 then
			vim.notify(
				"⚠️  OpenCode CLI não encontrado no PATH!\n" .. "Instale com: npm install -g @sst/opencode",
				vim.log.levels.WARN
			)
			return
		end

		-- ============================================
		-- SETUP DO OPENCODE
		-- ============================================
		local ok, opencode = pcall(require, "opencode")
		if not ok then
			vim.notify("❌ Erro ao carregar opencode.nvim", vim.log.levels.ERROR)
			return
		end

		opencode.setup({
			-- Configurações básicas
			opencode_path = vim.fn.exepath("opencode"),

			-- Auto-start
			auto_start = false, -- Não iniciar automaticamente

			-- Window config
			window = {
				split_ratio = 0.3,
				position = "right", -- "right", "left", "top", "bottom", "float"
			},

			-- Context que será enviado
			context = {
				files = true,
				selection = true,
				diagnostics = false,
			},
		})

		-- ============================================
		-- CRIAR COMANDOS CUSTOMIZADOS
		-- ============================================

		-- Comando para abrir/fechar OpenCode
		vim.api.nvim_create_user_command("OpencodeToggle", function()
			require("opencode").toggle()
		end, {})

		-- Comando para iniciar OpenCode
		vim.api.nvim_create_user_command("OpencodeStart", function()
			require("opencode").start()
		end, {})

		-- Comando para parar OpenCode
		vim.api.nvim_create_user_command("OpencodeStop", function()
			require("opencode").stop()
		end, {})

		-- Comando para enviar seleção
		vim.api.nvim_create_user_command("OpencodeSend", function()
			require("opencode").send_selection()
		end, { range = true })

		-- ============================================
		-- KEYMAPS
		-- ============================================
		local keymap = vim.keymap.set
		local opts = { noremap = true, silent = true }

		-- Abrir/Fechar OpenCode
		keymap("n", "<leader>oc", function()
			require("opencode").toggle()
		end, vim.tbl_extend("force", opts, { desc = "Toggle OpenCode" }))

		-- Iniciar OpenCode
		keymap("n", "<leader>os", function()
			require("opencode").start()
		end, vim.tbl_extend("force", opts, { desc = "Start OpenCode" }))

		-- Enviar buffer atual
		keymap("n", "<leader>ob", function()
			require("opencode").send_buffer()
		end, vim.tbl_extend("force", opts, { desc = "Enviar Buffer" }))

		-- Enviar seleção (Visual Mode)
		keymap("v", "<leader>ov", function()
			require("opencode").send_selection()
		end, vim.tbl_extend("force", opts, { desc = "Enviar Seleção" }))

		-- Prompts customizados em português (Visual Mode)
		keymap("v", "<leader>oe", function()
			local selection = require("opencode").get_selection()
			require("opencode").send_with_prompt(
				"Explique este código em português do Brasil de forma clara e didática:\n\n" .. selection
			)
		end, vim.tbl_extend("force", opts, { desc = "Explicar código" }))

		keymap("v", "<leader>oo", function()
			local selection = require("opencode").get_selection()
			require("opencode").send_with_prompt(
				"Otimize este código mantendo a funcionalidade. Explique as mudanças em português:\n\n" .. selection
			)
		end, vim.tbl_extend("force", opts, { desc = "Otimizar código" }))

		keymap("v", "<leader>of", function()
			local selection = require("opencode").get_selection()
			require("opencode").send_with_prompt(
				"Refatore este código seguindo as melhores práticas. Explique em português:\n\n" .. selection
			)
		end, vim.tbl_extend("force", opts, { desc = "Refatorar código" }))

		vim.notify("✅ OpenCode.nvim configurado com sucesso!", vim.log.levels.INFO)
	end,
}
