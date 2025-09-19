-- Arquivo: ~/.config/nvim/after/ftplugin/jinja2.lua
-- Configurações específicas para arquivos Jinja2

local opt_local = vim.opt_local

-- Configurações básicas do buffer
opt_local.tabstop = 2
opt_local.shiftwidth = 2
opt_local.softtabstop = 2
opt_local.expandtab = true
opt_local.autoindent = true
opt_local.smartindent = true

-- Configurações de comentários para Jinja2
opt_local.commentstring = "{# %s #}"

-- Configurações de folding
opt_local.foldmethod = "indent"
opt_local.foldlevel = 99

-- Configurar syntax highlighting específico para Jinja2
vim.cmd([[
  " Definir regiões de syntax para Jinja2
  syntax region jinjaVariable start=+{{+ end=+}}+
  syntax region jinjaTag start=+{%+ end=+%}+
  syntax region jinjaComment start=+{#+ end=+#}+
  
  " Highlight groups para Jinja2
  highlight default link jinjaVariable Identifier
  highlight default link jinjaTag Statement
  highlight default link jinjaComment Comment
  
  " Definir palavras-chave do Jinja2
  syntax keyword jinjaKeyword if else elif endif for endfor while endwhile
  syntax keyword jinjaKeyword macro endmacro call endcall filter endfilter
  syntax keyword jinjaKeyword set endset block endblock extends include
  syntax keyword jinjaKeyword import from as with endwith raw endraw
  syntax keyword jinjaKeyword autoescape endautoescape trans endtrans
  
  highlight default link jinjaKeyword Keyword
  
  " Operators e funções Jinja2
  syntax keyword jinjaFunction range loop caller varargs kwargs
  syntax keyword jinjaFunction lipsum dict cycler joiner
  
  highlight default link jinjaFunction Function
  
  " Filtros comuns do Jinja2
  syntax keyword jinjaFilter abs attr batch capitalize center default
  syntax keyword jinjaFilter dictsort escape filesizeformat first float
  syntax keyword jinjaFilter forceescape format groupby indent int join
  syntax keyword jinjaFilter last length list lower map max min pprint
  syntax keyword jinjaFilter random reject rejectattr replace reverse
  syntax keyword jinjaFilter round safe select selectattr slice sort
  syntax keyword jinjaFilter string striptags sum title trim truncate
  syntax keyword jinjaFilter unique upper urlencode urlize wordcount
  syntax keyword jinjaFilter xmlattr tojson
  
  highlight default link jinjaFilter Type
]])

-- Keymaps específicos para Jinja2
local keymap = vim.keymap

-- Atalhos para inserir tags Jinja2
keymap.set("i", "<C-j>v", "{{ }}<Left><Left>", { buffer = true, desc = "Insert Jinja2 variable" })
keymap.set("i", "<C-j>t", "{% %}<Left><Left>", { buffer = true, desc = "Insert Jinja2 tag" })
keymap.set("i", "<C-j>c", "{# #}<Left><Left>", { buffer = true, desc = "Insert Jinja2 comment" })

-- Navegação entre blocos Jinja2
keymap.set("n", "]]", function()
	vim.fn.search("{{\\|{%\\|{#", "W")
end, { buffer = true, desc = "Next Jinja2 block" })

keymap.set("n", "[[", function()
	vim.fn.search("{{\\|{%\\|{#", "bW")
end, { buffer = true, desc = "Previous Jinja2 block" })

-- Autocommands específicos para Jinja2
local augroup = vim.api.nvim_create_augroup("Jinja2", { clear = true })

-- Detectar e configurar filetype para arquivos .j2
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.j2", "*.jinja", "*.jinja2" },
	group = augroup,
	callback = function()
		vim.bo.filetype = "jinja2"
		-- Definir o tipo de arquivo base baseado na extensão
		local filename = vim.fn.expand("%:t")
		if filename:match("%.html%.j2$") then
			vim.bo.syntax = "htmljinja"
		elseif filename:match("%.xml%.j2$") then
			vim.bo.syntax = "xml"
		elseif filename:match("%.yml%.j2$") or filename:match("%.yaml%.j2$") then
			vim.bo.syntax = "yaml"
		elseif filename:match("%.json%.j2$") then
			vim.bo.syntax = "json"
		elseif filename:match("%.sh%.j2$") then
			vim.bo.syntax = "sh"
		else
			vim.bo.syntax = "jinja2"
		end
	end,
})

-- Configurar indentação automática para blocos Jinja2
vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*.j2,*.jinja,*.jinja2",
	group = augroup,
	callback = function()
		vim.bo.indentexpr = "GetJinja2Indent()"
	end,
})

-- Função personalizada de indentação para Jinja2
vim.cmd([[
function! GetJinja2Indent()
  let line = getline(v:lnum)
  let prevline = getline(v:lnum - 1)
  let indent = indent(v:lnum - 1)
  
  " Aumentar indentação após tags de abertura
  if prevline =~ '{%\s*\(if\|for\|while\|with\|block\|macro\|filter\|call\|trans\|autoescape\)\>'
    return indent + &shiftwidth
  endif
  
  " Diminuir indentação para tags de fechamento
  if line =~ '{%\s*\(endif\|endfor\|endwhile\|endwith\|endblock\|endmacro\|endfilter\|endcall\|endtrans\|endautoescape\)\>'
    return indent - &shiftwidth
  endif
  
  " Diminuir indentação para else/elif
  if line =~ '{%\s*\(else\|elif\)\>'
    return indent - &shiftwidth
  endif
  
  return indent
endfunction
]])
