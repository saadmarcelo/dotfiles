require("saad.core")
require("saad.lazy")

-- Exibir notificações quando a gravação de macro começar e terminar, com o nome do registrador
vim.api.nvim_create_autocmd("RecordingEnter", {
	callback = function()
		local register = vim.fn.reg_recording() -- Obter o registrador onde a macro está sendo gravada
		vim.notify("Iniciando gravação de macro no registrador: " .. register, vim.log.levels.INFO)
	end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
	callback = function()
		local register = vim.fn.reg_recording() -- Obter o registrador onde a macro foi gravada
		vim.notify("Gravação de macro no registrador " .. register .. " concluída", vim.log.levels.INFO)
	end,
})

-- Configuração simplificada de filetype para Jinja2
vim.filetype.add({
	extension = {
		j2 = "jinja2",
		jinja = "jinja2",
		jinja2 = "jinja2",
	},
	pattern = {
		[".*%.j2$"] = "jinja2",
		[".*%.jinja$"] = "jinja2",
		[".*%.jinja2$"] = "jinja2",
	},
})
