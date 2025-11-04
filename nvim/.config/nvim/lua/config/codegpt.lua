local status_ok, codegpt = pcall(require, "codegpt")
if not status_ok then
	vim.notify("CodeGPT não encontrado!", vim.log.levels.ERROR)
	return
end

codegpt.setup({
	-- ============================================
	-- CONFIGURAÇÃO DA API KEY
	-- ============================================
	-- Opção 1: Variável de ambiente (recomendado)
	openai_api_key = require("secrets").openai_api_key,
	-- Opção 2: Hardcoded (NÃO RECOMENDADO - use apenas para testes)
	-- openai_api_key = "sk-proj-sua-key-aqui",

	-- ============================================
	-- MODELO GPT
	-- ============================================
	model = "gpt-4", -- ou "gpt-3.5-turbo" para economizar

	-- ============================================
	-- TEMPLATE DE CHAT
	-- ============================================
	chat_template = [[
    ### Instrução:
    {{instruction}}
    
    ### Entrada:
    {{input}}
    
    ### Contexto:
    {{context}}
    
    ### Resposta:
  ]],

	-- ============================================
	-- CONFIGURAÇÕES DE UI
	-- ============================================
	popup_window = {
		border = {
			highlight = "FloatBorder",
			style = "rounded",
			text = {
				top = " 🤖 CodeGPT ",
			},
		},
		win_options = {
			wrap = true,
			linebreak = true,
			foldcolumn = "1",
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
	},

	popup_input = {
		prompt = " 󰭻  ",
		border = {
			highlight = "FloatBorder",
			style = "rounded",
			text = {
				top_align = "center",
				top = " Prompt ",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
		submit = "<C-Enter>",
		submit_n = "<Enter>",
		max_tokens = 4096,
	},

	-- ============================================
	-- COMANDOS PERSONALIZADOS EM PORTUGUÊS
	-- ============================================
	hooks = {
		-- Explicar código selecionado
		Explicar = function(gpt, params)
			local template = [[
        Explique o seguinte código em português do Brasil de forma clara e didática:
        
        ```{{filetype}}
        {{text_selection}}
        ```
        
        Explique linha por linha se necessário.
      ]]
			local agent = gpt.get_chat_agent()
			gpt.exec_template_command(agent, template, params)
		end,

		-- Adicionar comentários ao código
		Comentar = function(gpt, params)
			local template = [[
        Adicione comentários detalhados em português ao seguinte código {{filetype}}:
        
        ```{{filetype}}
        {{text_selection}}
        ```
        
        Retorne APENAS o código com os comentários, sem explicações adicionais.
      ]]
			local agent = gpt.get_chat_agent()
			gpt.exec_template_command(agent, template, params)
		end,

		-- Otimizar código
		Otimizar = function(gpt, params)
			local template = [[
        Otimize o seguinte código {{filetype}} mantendo a funcionalidade:
        
        ```{{filetype}}
        {{text_selection}}
        ```
        
        Explique as otimizações feitas em português do Brasil.
      ]]
			local agent = gpt.get_chat_agent()
			gpt.exec_template_command(agent, template, params)
		end,

		-- Encontrar bugs
		BuscarBugs = function(gpt, params)
			local template = [[
        Analise o código abaixo e identifique possíveis bugs, erros ou problemas:
        
        ```{{filetype}}
        {{text_selection}}
        ```
        
        Liste os problemas encontrados e sugira correções em português.
      ]]
			local agent = gpt.get_chat_agent()
			gpt.exec_template_command(agent, template, params)
		end,

		-- Criar testes unitários
		CriarTestes = function(gpt, params)
			local template = [[
        Crie testes unitários completos para o seguinte código {{filetype}}:
        
        ```{{filetype}}
        {{text_selection}}
        ```
        
        Use as melhores práticas e frameworks adequados para {{filetype}}.
        Responda em português do Brasil.
      ]]
			local agent = gpt.get_chat_agent()
			gpt.exec_template_command(agent, template, params)
		end,

		-- Refatorar código
		Refatorar = function(gpt, params)
			local template = [[
        Refatore o seguinte código {{filetype}} seguindo as melhores práticas:
        
        ```{{filetype}}
        {{text_selection}}
        ```
        
        Mantenha a funcionalidade e explique as mudanças em português do Brasil.
      ]]
			local agent = gpt.get_chat_agent()
			gpt.exec_template_command(agent, template, params)
		end,

		-- Documentar função/classe
		Documentar = function(gpt, params)
			local template = [[
        Crie documentação completa para o seguinte código {{filetype}}:
        
        ```{{filetype}}
        {{text_selection}}
        ```
        
        Inclua:
        - Descrição do que faz
        - Parâmetros
        - Retorno
        - Exemplos de uso
        - Possíveis exceções
        
        Responda em português do Brasil.
      ]]
			local agent = gpt.get_chat_agent()
			gpt.exec_template_command(agent, template, params)
		end,

		-- Simplificar código
		Simplificar = function(gpt, params)
			local template = [[
        Simplifique o seguinte código {{filetype}} mantendo a funcionalidade:
        
        ```{{filetype}}
        {{text_selection}}
        ```
        
        Torne-o mais legível e fácil de entender.
        Explique as mudanças em português do Brasil.
      ]]
			local agent = gpt.get_chat_agent()
			gpt.exec_template_command(agent, template, params)
		end,
	},
})

-- ============================================
-- COMANDOS VIM PERSONALIZADOS
-- ============================================
vim.api.nvim_create_user_command("GPTExplicar", "Chat Explicar", {})
vim.api.nvim_create_user_command("GPTComentar", "Chat Comentar", {})
vim.api.nvim_create_user_command("GPTOtimizar", "Chat Otimizar", {})
vim.api.nvim_create_user_command("GPTBugs", "Chat BuscarBugs", {})
vim.api.nvim_create_user_command("GPTTestes", "Chat CriarTestes", {})
vim.api.nvim_create_user_command("GPTRefatorar", "Chat Refatorar", {})
vim.api.nvim_create_user_command("GPTDocumentar", "Chat Documentar", {})
vim.api.nvim_create_user_command("GPTSimplificar", "Chat Simplificar", {})

-- ============================================
-- KEYMAPS
-- ============================================
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Chat geral
keymap("n", "<leader>cg", ":ChatGPT<CR>", opts)
keymap("v", "<leader>cg", ":ChatGPT<CR>", opts)

-- Explicar código
keymap("v", "<leader>ce", ":GPTExplicar<CR>", opts)

-- Comentar código
keymap("v", "<leader>cm", ":GPTComentar<CR>", opts)

-- Otimizar código
keymap("v", "<leader>co", ":GPTOtimizar<CR>", opts)

-- Buscar bugs
keymap("v", "<leader>cb", ":GPTBugs<CR>", opts)

-- Criar testes
keymap("v", "<leader>ct", ":GPTTestes<CR>", opts)

-- Refatorar
keymap("v", "<leader>cr", ":GPTRefatorar<CR>", opts)

-- Documentar
keymap("v", "<leader>cd", ":GPTDocumentar<CR>", opts)

-- Simplificar
keymap("v", "<leader>cs", ":GPTSimplificar<CR>", opts)

vim.notify("CodeGPT configurado com sucesso! 🚀", vim.log.levels.INFO)
