# PRD — Personal Dev Environment (dotfiles)

> Documento de requisitos do projeto **já existente**. Descreve o que o projeto é, as regras que o governam, sua estrutura e como é validado.
> Fonte de verdade complementar: `context.md` (vocabulário), `docs/CODEBASE_MAP.md` (mapa gerado), `GIT_WARNING.md` (política git).

- **Dono:** Marcelo Saad
- **Status:** em uso diário
- **Plataformas alvo:** macOS (principal), Linux/Ubuntu (secundário)
- **Última revisão:** 2026-10-29

---

## 1. Visão geral

Ambiente de desenvolvimento pessoal **centrado no Neovim**, versionado e reproduzível em qualquer máquina com `stow`. Tmux, shell, terminais e integrações de IA existem para apoiar o fluxo no editor.

### 1.1 Problema

Reconfigurar editor, shell e terminal a cada máquina nova é lento e propenso a divergência. Configs com segredos misturados são arriscadas de versionar.

### 1.2 Objetivos

1. Reproduzir o ambiente completo com `git clone` + `stow <pacote>`.
2. Manter o Neovim modular: cada plugin em um arquivo, carregado sob demanda.
3. Nunca versionar segredos.
4. Detectar configuração quebrada automaticamente (testes + `:checkhealth`).
5. Suportar o trabalho diário do dono: Kubernetes, Terraform, Ansible, AWS, Python, JS/TS, Docker.

### 1.3 Não objetivos

- Não é um monorepo de infraestrutura nem de aplicação (arquivos `*.tf` são ignorados no `.gitignore`).
- Não há instalador automático; a instalação é documentada no `README.md`.
- Não mantém ferramentas raras ou nunca usadas (regra de escopo, seção 3.1).

---

## 2. Escopo e categorias

Um arquivo só pertence ao repo se for um **Daily Dev Workflow Asset**. Categorias canônicas (`context.md`):

| Categoria | O que contém | Exemplos |
|---|---|---|
| **Interactive Config** | Config das ferramentas usadas em sessões interativas | `nvim/`, `tmux/`, `zshrc/`, `alacritty/`, `kitty/`, `mise/` |
| **Developer Tooling** | Integrações locais que estendem o ambiente | `opencode/opencode.jsonc`, `.mcp.json`, `tests/` |
| **Documentation** | Material que explica o repo | `README.md`, `docs/`, `context.md`, `servidormcp.md` |

---

## 3. Regras do projeto

### 3.1 Escopo
- R1. Só entra no repo o que roda na máquina no fluxo diário de desenvolvimento.
- R2. O repo é Neovim-centric: tmux/shell/terminal priorizam o fluxo do editor (ex.: navegação `C-h/j/k/l` unificada entre tmux e Neovim).

### 3.2 Git (`GIT_WARNING.md`)
- R3. **Nenhum comando git** (`add`, `commit`, `push`, `pull`, …) sem autorização explícita do dono.
- R4. Proibido git automático após modificar arquivos, rodar Lazy/TPM ou qualquer operação automatizada.
- R5. Sempre pedir confirmação antes de usar git neste projeto.

### 3.3 Segredos
- R6. API keys vivem em `nvim/.config/nvim/lua/secrets.lua`, que é **git-ignorado**.
- R7. O template versionado é `secrets.lua.example` (apenas placeholders `YOUR_KEY_HERE`).
- R8. Nenhum arquivo versionado pode conter credenciais reais (padrões `sk-…`, `ghp_…`, `AKIA…`, `glpat-…`, `xox…`).
- R9. Arquivos `*.tf`, `*.tfstate`, `*.tfvars` e `.terraform/` são git-ignorados.

### 3.4 Layout GNU Stow
- R10. Cada diretório de topo é um **pacote stow** que espelha `$HOME`: `nvim/.config/nvim/…` → `~/.config/nvim`.
- R11. Pacotes: `nvim`, `alacritty`, `tmux`, `zshrc`, `kitty`, `mise`.
- R12. Configs ficam sob caminhos com ponto (`.config/…`, `.tmux.conf`, `.zshrc`).

### 3.5 Neovim
- R13. Carga em ordem fixa: `saad.core` (options → keymaps → api) e depois `saad.lazy`.
- R14. `<leader>` = espaço. Todo keymap tem `desc`.
- R15. Um plugin por arquivo em `lua/saad/plugins/`; servidores LSP em `lua/saad/plugins/lsp/`.
- R16. `lua/saad/disabled/` guarda specs desativados e **nunca** é importado pelo lazy.
- R17. Plugins carregam sob demanda (`event`, `keys`, `ft`, `cmd`) sempre que possível.
- R18. Todo plugin declarado precisa estar no `lazy-lock.json` (versões travadas e reproduzíveis).
- R19. Usar API nativa do Neovim ≥ 0.11 para LSP (`vim.lsp.config`); não usar `require("lspconfig").X.setup`.
- R20. Não usar APIs deprecated (`vim.loop` → `vim.uv`); `:checkhealth vim.deprecated` deve ficar limpo.
- R21. Código Lua formatado com `stylua` (indentação por tabs). Specs legados com 2 espaços são dívida conhecida.
- R22. Plugins arquivados/abandonados são substituídos (ex.: `neodev.nvim` → `lazydev.nvim`).

### 3.6 Tmux
- R23. `base-index 1`, `renumber-windows on`, `escape-time 0`, mouse ligado, barra no topo.
- R24. Novas janelas/splits herdam `pane_current_path`.
- R25. Plugins via TPM; `prefix + r` recarrega a config; `prefix + O` abre o seletor de sessões (sessionx, com versão corrigida em `sessionx_fixed.sh`).

### 3.7 Shell
- R26. `EDITOR=nvim`; `vim`, `v`, `vi` apontam para `nvim`.
- R27. Binários do Mason no `PATH` (`~/.local/share/nvim/mason/bin`).
- R28. `zoxide` (`cd` → `z`), `fzf`, `eza`, `kubectl` (`k`) e `kube-ps1` inicializados no `.zshrc`.
- R29. Nenhuma credencial hardcoded no `.zshrc`.

### 3.8 IA / MCP
- R30. Servidores MCP do OpenCode vivem em `opencode/opencode.jsonc`; todo servidor precisa de `type` (`local`/`remote`) e comando/URL válidos.
- R31. Servidores esperados: `aws`, `kubernetes`, `docker`, `terraform-registry`, `aws-iac`, `ansible`, `github`, `postgres`, `context7`.

---

## 4. Estrutura do repositório

```
dotfiles/
├── nvim/.config/nvim/            # pacote stow → ~/.config/nvim
│   ├── init.lua                  # entrada: core → lazy
│   ├── lazy-lock.json            # versões travadas
│   ├── ftplugin/                 # ex.: yaml.kubernetes.lua
│   └── lua/
│       ├── secrets.lua(.example) # segredos (ignorado) / template
│       └── saad/
│           ├── core/             # options, keymaps, api (autocmds)
│           ├── lazy.lua          # bootstrap do lazy.nvim
│           ├── plugins/          # 1 plugin por arquivo
│           │   └── lsp/          # lspconfig.lua, mason.lua
│           └── disabled/         # specs desativados (não importados)
├── tmux/                         # .tmux.conf, sessionx_fixed.sh
├── zshrc/.zshrc
├── alacritty/.config/alacritty.toml
├── kitty/.config/kitty/          # kitty.conf, current-theme.conf
├── mise/.config/mise/config.toml
├── opencode/opencode.jsonc       # MCP servers do OpenCode
├── tests/                        # suíte automática (seção 7)
├── docs/                         # PRD.md, CODEBASE_MAP.md
└── README.md, context.md, servidormcp.md, GIT_WARNING.md
```

---

## 5. Requisitos funcionais

### 5.1 Neovim

| ID | Requisito | Implementação |
|---|---|---|
| F1 | Opções base: números relativos, tabs de 2 espaços, sem wrap, busca smartcase, clipboard do sistema, sem swapfile, splits à direita/abaixo | `core/options.lua` |
| F2 | Keymaps de edição: `jk` sai do insert, `<Esc>` limpa highlight, `x` não copia, `C-d/C-u` centralizam, `<`/`>` mantêm seleção, `p` visual preserva yank | `core/keymaps.lua` |
| F3 | Gestão de janelas (`<leader>sv/sh/se/sx`) e abas (`<leader>to/tx/tn/tp/tf`) | `core/keymaps.lua` |
| F4 | Atalhos LSP: `gd`, `K`, `<leader>rn`, `<leader>ca`, `[d`/`]d`, `<leader>D`, `<leader>l{d,i,s,wa,wr,wl}` | `core/keymaps.lua`, `lsp/lspconfig.lua` |
| F5 | Destaque ao copiar (`TextYankPost`) | `core/api.lua` |
| F6 | LSP para Ansible, Terraform, Jinja2, YAML (schemas K8s/GitHub), Lua; demais servidores via Mason | `lsp/lspconfig.lua`, `lsp/mason.lua` |
| F7 | Instalação automática de servidores e ferramentas (Mason + tool-installer) | `lsp/mason.lua` |
| F8 | Formatação com `conform` (prettier, stylua, isort, black, djlint…), com format-on-save | `plugins/formatting.lua` |
| F9 | Lint com `nvim-lint` (eslint_d, pylint, tflint, djlint) | `plugins/linting.lua` |
| F10 | Autocomplete (nvim-cmp + LuaSnip + friendly-snippets + lspkind) | `plugins/nvim-cmp.lua` |
| F11 | Navegação: Telescope, nvim-tree, bufferline, lualine, alpha, which-key, trouble, todo-comments | `plugins/*.lua` |
| F12 | Git: gitsigns, lazygit, diffview, fugitive | `plugins/git.lua`, `gitsigns.lua`, `lazygit.lua`, `diffview.lua` |
| F13 | Edição: surround, comment, autopairs/autotag, substitute, inc-rename, undotree, maximizer | `plugins/*.lua` |
| F14 | Syntax: treesitter (bash, c, css, docker, graphql, hcl, helm, html, js/ts/tsx, json, lua, prisma, python, svelte, terraform, toml, yaml…) | `plugins/treesitter.lua` |
| F15 | Sessões automáticas (`auto-session`) e UI de mensagens (`noice`, `notify`, `dressing`) | `plugins/auto-session.lua`, `noice.lua`, `dressing.lua` |
| F16 | Tema Catppuccin | `plugins/colorscheme.lua` |
| F17 | Filetypes extras: `*.tf` → terraform; `*.j2`, `*.jinja`, `*.jinja2` → jinja2; ftplugin `yaml.kubernetes` | `lsp/lspconfig.lua`, `ftplugin/` |

### 5.2 Terminal, tmux e shell

| ID | Requisito |
|---|---|
| F18 | Alacritty e Kitty com fonte Nerd Font e tema consistente |
| F19 | Tmux: navegação transparente com Neovim, `synchronize-panes` em `prefix + a`, sessionx para troca de sessões, resurrect/continuum para persistência |
| F20 | Zsh: oh-my-zsh (`git`, `aws`), autosuggestions e syntax-highlighting, alias de produtividade, `awsp` (perfil AWS + checagem de sessão SSO), contexto K8s no prompt |

### 5.3 IA

| ID | Requisito |
|---|---|
| F21 | OpenCode configurado com modelo principal e `small_model` e servidores MCP (seção 3.8) |
| F22 | Alias `cc` para Claude Code; `cc-mini` para endpoint alternativo |

---

## 6. Requisitos não funcionais

| ID | Requisito | Verificação |
|---|---|---|
| N1 | Neovim sobe sem erros em ≥ 0.12 | `nvim --headless +qa` e testes |
| N2 | `:checkhealth` sem `ERROR` | healthcheck manual (seção 8) |
| N3 | Startup rápido via lazy-loading | R17 |
| N4 | Reprodutibilidade (lockfile) | R18 + teste do lockfile |
| N5 | Segurança de segredos | R6–R9 + testes de higiene |
| N6 | Portabilidade macOS/Linux | `README.md`, paths via `$HOME` |

### Dependências externas

`stow`, `neovim ≥ 0.11`, `git`, `ripgrep`, `fd`, `node`/`npm`, `python3`, `cargo`, `luarocks`, `tree-sitter-cli`, `tmux`, `fzf`, `zoxide`, `eza`, `lazygit`, `kitty`/`alacritty`, Nerd Font (SauceCodePro).

Opcionais (geram apenas WARNING no checkhealth): providers perl/ruby/python/node do Neovim, `php`, `composer`, `java`, `julia`, `hg`.

---

## 7. Estratégia de testes

Suíte em `tests/`, executada por `tests/run.sh [all|nvim|shell]`. **Não** exige rede nem carregar plugins: usa `tests/minimal_init.lua`, que injeta só a config do repo e o `plenary.nvim`.

| Arquivo | Cobre |
|---|---|
| `tests/nvim/core_spec.lua` | Opções, leader, ~30 keymaps (`desc`/`rhs`), autocmds e idempotência do augroup |
| `tests/nvim/plugins_spec.lua` | Cada spec carrega e é bem formado; sem duplicatas; todo plugin no `lazy-lock.json`; `lazy.lua` importa só `plugins` e `plugins.lsp`; `mason.lua` sem duplicatas e com servidores obrigatórios; `lspconfig.lua` sem API legada; ftplugin carrega |
| `tests/nvim/syntax_spec.lua` | Todo `.lua` compila; verificação informativa de `stylua` |
| `tests/nvim/repo_spec.lua` | `secrets.lua` ignorado e não rastreado; template só com placeholders; varredura de credenciais; `opencode.jsonc` válido com MCPs esperados; layout stow; `GIT_WARNING.md` presente |
| `tests/shell/config_test.sh` | `zsh -n`; regras do `.zshrc`; `tmux.conf` carrega num servidor isolado; `sessionx_fixed.sh` válido; TOML e JSON válidos |

Ferramentas ausentes geram **skip**, não falha.

### Critérios de aceitação
- `tests/run.sh` retorna 0.
- Toda regra R-verificável (seção 3) tem teste correspondente ou está listada como dívida.
- Mudança em keymap/option exige atualizar o teste correspondente.

---

## 8. Healthcheck manual

```bash
nvim --headless "+checkhealth" "+w! /tmp/health.txt" "+qa!"   # procurar ERROR/WARNING
nvim --headless "+Lazy! check" +qa
tests/run.sh
```

Falsos positivos conhecidos: avisos `vim.lsp: 'X' config not found` no checkhealth headless (o `lspconfig` carrega em `BufReadPre`).

---

## 9. Dívidas técnicas e riscos

| # | Item | Impacto |
|---|---|---|
| D1 | 13 specs Lua fora do padrão `stylua` (2 espaços) | baixo; rodar `stylua nvim/.config/nvim` |
| D2 | `if use_new_api` redundante em `lsp/lspconfig.lua` (Neovim 0.12 sempre verdadeiro) | baixo |
| D3 | `sqls` não instalado embora `sqlls` esteja no Mason | médio — LSP de SQL inativo |
| D4 | Arquivo `substitue.lua` e `vim-maximazer.lua` com typo no nome | baixo (cosmético) |
| D5 | `README.md` cita `stow lvim`, pacote que não existe | baixo |
| D6 | `docs/CODEBASE_MAP.md` gerado em 2026-03-04, pode estar defasado | baixo |
| D7 | `alacritty`/`kitty`/`zshrc` têm cobertura de teste só estática | baixo |

---

## 10. Fluxo de mudança

1. Editar o arquivo no pacote correspondente (nunca em `~`; é symlink via stow).
2. `tests/run.sh`.
3. Abrir o Neovim e `:checkhealth` se a mudança tocar plugins/LSP.
4. Pedir autorização ao dono antes de qualquer comando git (R3–R5).
