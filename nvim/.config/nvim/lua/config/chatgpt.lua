-- ~/.config/nvim/lua/config/chatgpt.lua
-- Configurações completas do ChatGPT.nvim

local status_ok, chatgpt = pcall(require, "chatgpt")
if not status_ok then
	vim.notify("ChatGPT.nvim não encontrado!", vim.log.levels.ERROR)
	return
end
local secrets = require("secrets")

chatgpt.setup({
	api_key_cmd = "echo " .. secrets.openai_api_key,
	-- ============================================
	-- CONFIGURAÇÃO DA API KEY
	-- ============================================
	-- Carrega a API key do arquivo secrets.lua

	yank_register = "+",

	-- ============================================
	-- MODELO E PARÂMETROS
	-- ============================================
	openai_params = {
		model = "gpt-4", -- ou "gpt-3.5-turbo"
		frequency_penalty = 0,
		presence_penalty = 0,
		max_tokens = 4096,
		temperature = 0.2,
		top_p = 1,
		n = 1,
	},

	openai_edit_params = {
		model = "gpt-4",
		frequency_penalty = 0,
		presence_penalty = 0,
		temperature = 0.2,
		top_p = 1,
		n = 1,
	},

	-- ============================================
	-- CONFIGURAÇÕES DE UI
	-- ============================================
	chat = {
		welcome_message = "🤖 Olá! Como posso ajudar com seu código hoje?",
		loading_text = "Carregando, aguarde...",
		question_sign = "👤",
		answer_sign = "🤖",
		border_left_sign = "│",
		border_right_sign = "│",
		max_line_length = 120,
		sessions_window = {
			active_sign = " 󰄲 ",
			inactive_sign = " 󰄱 ",
			current_line_sign = "",
			border = {
				style = "rounded",
				text = {
					top = " Sessões ",
				},
			},
			win_options = {
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
			},
		},
		keymaps = {
			close = "<C-c>",
			yank_last = "<C-y>",
			yank_last_code = "<C-k>",
			scroll_up = "<C-u>",
			scroll_down = "<C-d>",
			new_session = "<C-n>",
			cycle_windows = "<Tab>",
			cycle_modes = "<C-f>",
			next_message = "<C-j>",
			prev_message = "<C-k>",
			select_session = "<Space>",
			rename_session = "r",
			delete_session = "d",
			draft_message = "<C-r>",
			edit_message = "e",
			delete_message = "d",
			toggle_settings = "<C-o>",
			toggle_sessions = "<C-p>",
			toggle_help = "<C-h>",
			toggle_message_role = "<C-r>",
			toggle_system_role_open = "<C-s>",
			stop_generating = "<C-x>",
		},
	},

	popup_layout = {
		default = "center",
		center = {
			width = "80%",
			height = "80%",
		},
		right = {
			width = "30%",
			width_settings_open = "50%",
		},
	},

	popup_window = {
		border = {
			highlight = "FloatBorder",
			style = "rounded",
			text = {
				top = " ChatGPT ",
			},
		},
		win_options = {
			wrap = true,
			linebreak = true,
			foldcolumn = "1",
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
		buf_options = {
			filetype = "markdown",
		},
	},

	system_window = {
		border = {
			highlight = "FloatBorder",
			style = "rounded",
			text = {
				top = " SISTEMA ",
			},
		},
		win_options = {
			wrap = true,
			linebreak = true,
			foldcolumn = "2",
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
	},

	popup_input = {
		prompt = "  ",
		border = {
			highlight = "FloatBorder",
			style = "rounded",
			text = {
				top_align = "center",
				top = " Pergunta ",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
		submit = "<C-Enter>",
		submit_n = "<Enter>",
		max_visible_lines = 20,
	},

	settings_window = {
		setting_sign = "  ",
		border = {
			style = "rounded",
			text = {
				top = " Configurações ",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
	},

	help_window = {
		setting_sign = "  ",
		border = {
			style = "rounded",
			text = {
				top = " Ajuda ",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
	},

	-- ============================================
	-- AÇÕES PREDEFINIDAS EM PORTUGUÊS
	-- ============================================
	actions_paths = {},
	show_quickfixes_cmd = "Trouble quickfix",

	predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
})

-- ============================================
-- COMANDOS PERSONALIZADOS EM PORTUGUÊS
-- ============================================

-- Função helper para executar ações
local function chatgpt_action(prompt)
	return function()
		local mode = vim.fn.mode()
		local text = ""

		if mode == "v" or mode == "V" then
			-- Pega texto selecionado
			vim.cmd('normal! "xy')
			text = vim.fn.getreg("x")
		else
			-- Pega buffer inteiro
			text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
		end

		local filetype = vim.bo.filetype
		local final_prompt = string.format(prompt, filetype, text)

		-- Abre chat com o prompt
		vim.cmd("ChatGPT")
		vim.defer_fn(function()
			vim.api.nvim_feedkeys(final_prompt, "t", false)
		end, 500)
	end
end

-- Criar comandos
vim.api.nvim_create_user_command("GPTExplicar", function()
	chatgpt_action([[
Explique o seguinte código %s em português do Brasil de forma clara e didática, linha por linha se necessário:

```%s
%s
```
  ]])()
end, { range = true })

vim.api.nvim_create_user_command("GPTComentar", function()
	chatgpt_action([[
Adicione comentários detalhados em português ao seguinte código %s. Retorne APENAS o código comentado:

```%s
%s
```
  ]])()
end, { range = true })

vim.api.nvim_create_user_command("GPTOtimizar", function()
	chatgpt_action([[
Otimize o seguinte código %s mantendo a funcionalidade. Explique as otimizações em português:

```%s
%s
```
  ]])()
end, { range = true })

vim.api.nvim_create_user_command("GPTBugs", function()
	chatgpt_action([[
Analise o código abaixo e identifique possíveis bugs, erros ou problemas. Liste em português:

```%s
%s
```
  ]])()
end, { range = true })

vim.api.nvim_create_user_command("GPTTestes", function()
	chatgpt_action([[
Crie testes unitários completos para o código %s abaixo. Use as melhores práticas:

```%s
%s
```
  ]])()
end, { range = true })

vim.api.nvim_create_user_command("GPTRefatorar", function()
	chatgpt_action([[
Refatore o código %s abaixo seguindo as melhores práticas. Explique as mudanças em português:

```%s
%s
```
  ]])()
end, { range = true })

vim.api.nvim_create_user_command("GPTDocumentar", function()
	chatgpt_action([[
Crie documentação completa para o código %s abaixo. Inclua descrição, parâmetros, retorno e exemplos:

```%s
%s
```
  ]])()
end, { range = true })

vim.api.nvim_create_user_command("GPTSimplificar", function()
	chatgpt_action([[
Simplifique o código %s abaixo mantendo a funcionalidade. Torne-o mais legível:

```%s
%s
```
  ]])()
end, { range = true })

-- ============================================
-- KEYMAPS
-- ============================================
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Chat geral
keymap("n", "<leader>cg", "<cmd>ChatGPT<CR>", opts)
keymap("v", "<leader>cg", "<cmd>ChatGPT<CR>", opts)

-- Explicar código
keymap("n", "<leader>ce", "<cmd>GPTExplicar<CR>", opts)
keymap("v", "<leader>ce", "<cmd>GPTExplicar<CR>", opts)

-- Comentar código
keymap("n", "<leader>cm", "<cmd>GPTComentar<CR>", opts)
keymap("v", "<leader>cm", "<cmd>GPTComentar<CR>", opts)

-- Otimizar código
keymap("n", "<leader>co", "<cmd>GPTOtimizar<CR>", opts)
keymap("v", "<leader>co", "<cmd>GPTOtimizar<CR>", opts)

-- Buscar bugs
keymap("n", "<leader>cb", "<cmd>GPTBugs<CR>", opts)
keymap("v", "<leader>cb", "<cmd>GPTBugs<CR>", opts)

-- Criar testes
keymap("n", "<leader>ct", "<cmd>GPTTestes<CR>", opts)
keymap("v", "<leader>ct", "<cmd>GPTTestes<CR>", opts)

-- Refatorar
keymap("n", "<leader>cr", "<cmd>GPTRefatorar<CR>", opts)
keymap("v", "<leader>cr", "<cmd>GPTRefatorar<CR>", opts)

-- Documentar
keymap("n", "<leader>cd", "<cmd>GPTDocumentar<CR>", opts)
keymap("v", "<leader>cd", "<cmd>GPTDocumentar<CR>", opts)

-- Simplificar
keymap("n", "<leader>cs", "<cmd>GPTSimplificar<CR>", opts)
keymap("v", "<leader>cs", "<cmd>GPTSimplificar<CR>", opts)

-- Editar com instruções
keymap("n", "<leader>ci", "<cmd>ChatGPTEditWithInstruction<CR>", opts)
keymap("v", "<leader>ci", "<cmd>ChatGPTEditWithInstruction<CR>", opts)

-- Ações rápidas
keymap("v", "<leader>ca", "<cmd>ChatGPTRun<CR>", opts)

vim.notify("ChatGPT configurado com sucesso! 🚀", vim.log.levels.INFO)
