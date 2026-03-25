# Dotfiles Project - Context Document

## ⚠️ DIRECTRIZES IMPORTANTES

### Regra de Git

**NUNCA execute comandos git (commit, push, pull, rebase, etc.) sem minha ordem explícita!**

Sempre pergunte antes de executar qualquer comando git e espere minha confirmação.

---

## Visão Geral

Repositório de dotfiles pessoais focado em produtividade para desenvolvimento.
Configurações otimizadas para trabalho com múltiplas linguagens (Python, JavaScript,
Terraform) e integração com ferramentas de AI/ML.

### Propósito

- Ambiente de desenvolvimento reproduzível e versionado
- Workflow otimizado para coding com AI assistance (usando OpenCode)
- Configurações sincronizadas entre máquinas

---

## 🆕 **ATUALIZAÇÃO IMPORTANTE - MIGRAÇÃO PARA OPENCODE**

### Mudanças Realizadas (Fevereiro 2025)

#### ❌ **Removido: Avante.nvim**

- **Motivo**: Bugs com auto-suggestions, menos flexível para workflow terminal
- **Status**: Plugin desativado (movido para `disabled/`)
- **Arquivo**: `lua/saad/disabled/avante.lua`

#### ✅ **Adicionado: OpenCode.nvim**

- **Plugin**: `sudo-tee/opencode.nvim`
- **Integração**: Terminal-native, compatível com Tmux
- **Providers**: Suporta Claude (Anthropic), GPT (OpenAI), Gemini (Google)
- **Arquivo**: `lua/saad/plugins/opencode.lua`

#### 🔐 **Sistema de Segurança para API Keys**

**IMPORTANTE**: API keys NÃO devem estar no `.zshrc` ou em qualquer arquivo que vá para o Git!

**Estrutura de Secrets:**

```
~/.config/nvim/lua/
├── secrets.lua          # IGNORADO NO GIT - Suas chaves reais
└── secrets.lua.example  # COMMITADO - Template público
```

**Como usar:**

1. Copie `secrets.lua.example` para `secrets.lua`
2. Adicione suas chaves reais no `secrets.lua`
3. O `secrets.lua` está no `.gitignore` (NUNCA será commitado)
4. O plugin OpenCode carrega automaticamente do `secrets.lua`

**Arquivo secrets.lua:**

```lua
return {
    openai_api_key = "sk-proj-sua-chave-aqui",
    anthropic_api_key = "sk-ant-sua-chave-aqui",
}
```

---

## Project Structure

- **Root Directory**:
  - Contains configuration files for `tmux` and `zsh`.
  - Includes a `.gitignore` and `README.md`.

- **Neovim Configuration**:
  - Located in `nvim/.config/nvim`.
  - Key files include `init.lua` and various plugin configurations under `lua/saad/plugins`.

## Directory Structure

```
/Users/marcelosaad/dotfiles
├── alacritty
│   └── .config
│       └── alacritty.toml
├── nvim
│   ├── .config
│   │   └── nvim
│   │       ├── init.lua
│   │       ├── lua
│   │       │   ├── config
│   │       │   │   └── avante.lua             # ⚠️ Config Avante (não usado)
│   │       │   ├── secrets.lua               # ⚠️  NUNCA COMMITAR!
│   │       │   ├── secrets.lua.example       # ✅ Template público
│   │       │   └── saad
│   │       │       ├── core
│   │       │       │   ├── api.lua
│   │       │       │   ├── init.lua
│   │       │       │   ├── keymaps.lua
│   │       │       │   └── options.lua
│   │       │       ├── disabled               # 🗂️ Plugins desabilitados
│   │       │       │   ├── avante.lua
│   │       │       │   ├── colorscheme.lua
│   │       │       │   ├── flutter.lua
│   │       │       │   ├── live-server.lua
│   │       │       │   ├── vim-terraform.lua
│   │       │       │   └── yazi.lua
│   │       │       ├── plugins
│   │       │       │   ├── alpha.lua
│   │       │       │   ├── auto-session.lua
│   │       │       │   ├── autopairs.lua
│   │       │       │   ├── bufferline.lua
│   │       │       │   ├── colorscheme.lua
│   │       │       │   ├── comment.lua
│   │       │       │   ├── diffview.lua
│   │       │       │   ├── dressing.lua
│   │       │       │   ├── formatting.lua
│   │       │       │   ├── git.lua
│   │       │       │   ├── gitsigns.lua
│   │       │       │   ├── indent-blankline.lua
│   │       │       │   ├── init.lua
│   │       │       │   ├── lazygit.lua
│   │       │       │   ├── linting.lua
│   │       │       │   ├── lsp                     # 🚀 Configurações LSP
│   │       │       │   │   ├── lspconfig.lua
│   │       │       │   │   └── mason.lua
│   │       │       │   ├── lualine.lua
│   │       │       │   ├── noice.lua
│   │       │       │   ├── nvim-cmp.lua
│   │       │       │   ├── nvim-tree.lua
│   │       │       │   ├── opencode.lua           # ✅ NOVO!
│   │       │       │   ├── rename.lua
│   │       │       │   ├── substitue.lua
│   │       │       │   ├── surround.lua
│   │       │       │   ├── telescope.lua
│   │       │       │   ├── todo-comments.lua
│   │       │       │   ├── treesitter.lua
│   │       │       │   ├── trouble.lua
│   │       │       │   ├── undotree.lua
│   │       │       │   ├── vim-maximazer.lua
│   │       │       │   └── which-key.lua
│   │       │       └── lazy.lua
├── tmux
│   ├── .tmux.conf
│   └── sessionx_fixed.sh          # Script corrigido para troca de sessões
└── zshrc
    └── .zshrc
```

---

## Tmux Configuration

### Plugins

- **tpm**: Gerenciador de plugins do tmux
- **tmux-sensible**: Configurações sensíveis defaults
- **tmux-yank**: Suporte a clipboard
- **tmux-resurrect**: Salvar/restaurar sessões
- **tmux-continuum**: Restauração automática de sessões
- **vim-tmux-navigator**: Navegação vim/tmux integrada
- **tmux-sessionx**: Troca de sessões com fzf
- **catppuccin**: Tema visual

### tmux-sessionx (Script Corrigido)

Este dotfiles inclui uma versão corrigida do plugin `tmux-sessionx` que corrige bugs com múltiplas sessões.

**Arquivo:** `tmux/sessionx_fixed.sh`

**Atalho:** `<prefix> + O`

**Funcionalidades:**
- Lista todas as sessões (incluindo a atual)
- Preview em tempo real do conteúdo da sessão
- Criação de novas sessões
- Troca rápida entre sessões

**Dependências:**
- `fzf` - fuzzy finder (obrigatório)
- Plugin `tmux-sessionx` (opcional - só precisa para o preview)

**Instalação do plugin para preview:**
```bash
git clone https://github.com/omerxx/tmux-sessionx.git ~/.tmux/plugins/tmux-sessionx
```

### Keybindings Tmux

| Atalho | Descrição |
|--------|-----------|
| `<prefix> + O` | Abrir seletor de sessões |
| `<prefix> + c` | Nova janela |
| `<prefix> + "` | Split vertical |
| `<prefix> + %` | Split horizontal |
| `<prefix> + h/j/k/l` | Navegar painéis (modo vim) |
| `<prefix> + a` | Sincronizar painéis |

---

## Neovim Configuration

### Filosofia de Configuração

#### Princípios

- **Minimalismo**: Apenas plugins essenciais, evitar bloat
- **Performance**: Lazy loading sempre que possível
- **Consistência**: Keybindings seguem padrão Vim/Tmux
- **Modularidade**: Um arquivo por plugin/funcionalidade
- **Segurança**: API keys em arquivos ignorados pelo Git

### `init.lua`

- Loads core configurations and lazy loading of plugins.
- Sets up notifications for macro recording events.

---

## 🤖 AI Integration (OpenCode)

### Configuração Atual

- **Provider Principal**: Anthropic (Claude)
- **Model Padrão**: claude-sonnet-4-20250514
- **Providers Disponíveis**:
  - Anthropic (Claude Sonnet 4, Opus 4, Haiku 4)
  - OpenAI (GPT-4o, GPT-4-turbo)
  - Google (Gemini 2.5 Pro)

### Keybindings Principais

#### Comandos Básicos

| Keybinding   | Modo   | Descrição             |
| ------------ | ------ | --------------------- |
| `<leader>oc` | Normal | Abrir/Fechar OpenCode |
| `<leader>oq` | Normal | Quick Chat            |
| `<leader>ob` | Normal | Enviar buffer atual   |
| `<leader>os` | Normal | Iniciar OpenCode      |
| `<leader>ov` | Visual | Enviar seleção        |

#### Comandos em Português (Visual Mode)

| Keybinding   | Descrição         |
| ------------ | ----------------- |
| `<leader>oe` | Explicar código   |
| `<leader>oo` | Otimizar código   |
| `<leader>of` | Refatorar código  |
| `<leader>ot` | Criar testes      |
| `<leader>od` | Documentar código |

#### Gerenciamento de Sessões

| Keybinding   | Modo   | Descrição      |
| ------------ | ------ | -------------- |
| `<leader>ol` | Normal | Listar sessões |
| `<leader>on` | Normal | Nova sessão    |

### Workflow com AI

#### 1. Workflow Integrado (Neovim + OpenCode Split)

```
1. Abrir Neovim normalmente
2. <leader>oc para abrir OpenCode no split
3. Selecionar código visualmente
4. <leader>oe para explicação
5. AI responde no split do OpenCode
```

#### 2. Workflow Terminal (Tmux + OpenCode + Neovim)

```
1. Tmux com 3 painéis:
   - Painel 1: Neovim (editor)
   - Painel 2: OpenCode CLI (chat com IA)
   - Painel 3: Terminal (testes/execução)

2. Selecionar código no Neovim
3. <leader>ov para enviar ao OpenCode
4. Conversar no terminal do OpenCode
5. OpenCode aplica mudanças automaticamente
6. Neovim recarrega arquivos automaticamente
```

### Comandos OpenCode CLI

No terminal do OpenCode:

- `/init` - Analisar projeto e criar contexto
- `/undo` ou `Ctrl+X, U` - Desfazer última mudança
- `/redo` ou `Ctrl+X, R` - Refazer mudança
- `/share` - Compartilhar conversa
- `/help` - Ajuda completa

---

## 🔧 MCP Servers (DevOps)

O OpenCode suporta MCP (Model Context Protocol) servers para integração com ferramentas DevOps. A configuração está em `~/.config/opencode/opencode.json`.

### MCPs Configurados

| MCP | Descrição | Comando | Status |
|-----|-----------|---------|--------|
| **AWS** | Gerencia recursos AWS (EC2, S3, Lambda, etc) | `npx -y @imazhar101/mcp-aws-server` | ✅ Ativo |
| **Kubernetes** | Gerencia clusters K8s (pods, services, deployments) | `npx -y mcp-server-kubernetes` | ✅ Ativo |
| **Docker** | Gerencia containers e imagens Docker | `docker mcp gateway run` | ✅ Ativo |
| **Terraform Registry** | Consulta providers e módulos do Terraform | `npx -y terraform-mcp-server` | ✅ Ativo |
| **AWS IaC** | CDK + CloudFormation (best practices, validação) | `uvx awslabs.cdk-mcp-server@latest` | ✅ Ativo |
| **Ansible** | Ansible (scaffolding, lint, execução de playbooks) | `uvx ansible-mcp-server` | ✅ Ativo |
| **GitHub** | Repositórios, PRs, issues | `npx -y @modelcontextprotocol/server-github` | ✅ Ativo |
| **PostgreSQL** | Query databases PostgreSQL | `npx -y @modelcontextprotocol/server-postgres` | ⚠️ Desabilitado (precisa DATABASE_URL) |
| **Context7** | Documentação atualizada de bibliotecas | `npx -y @upstash/context7-mcp` | ✅ Ativo |

### Arquivo de Configuração

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "aws": {
      "type": "local",
      "command": ["npx", "-y", "@imazhar101/mcp-aws-server"],
      "enabled": true,
      "environment": {}
    },
    "kubernetes": {
      "type": "local",
      "command": ["npx", "-y", "mcp-server-kubernetes"],
      "enabled": true,
      "environment": {}
    },
    "docker": {
      "type": "local",
      "command": ["docker", "mcp", "gateway", "run"],
      "enabled": true,
      "timeout": 60000,
      "environment": {}
    },
    "terraform-registry": {
      "type": "local",
      "command": ["npx", "-y", "terraform-mcp-server"],
      "enabled": true,
      "environment": {}
    },
    "aws-iac": {
      "type": "local",
      "command": ["uvx", "awslabs.cdk-mcp-server@latest"],
      "enabled": true,
      "timeout": 120000,
      "environment": {}
    },
    "ansible": {
      "type": "local",
      "command": ["uvx", "ansible-mcp-server"],
      "enabled": true,
      "timeout": 120000,
      "environment": {}
    },
    "github": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-github"],
      "enabled": true,
      "environment": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "postgres": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-postgres"],
      "enabled": false,
      "environment": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "context7": {
      "type": "local",
      "command": ["npx", "-y", "@upstash/context7-mcp"],
      "enabled": true,
      "environment": {
        "CONTEXT7_API_KEY": "SUA_CHAVE_API"
      }
    }
  }
}
```

### Pré-requisitos

- **AWS MCP**: AWS CLI configurado (`aws configure`)
- **Kubernetes MCP**: `kubectl` configurado e acesso ao cluster
- **Docker MCP**: Docker Desktop com MCP Toolkit habilitado (Settings > Beta > Enable Docker MCP Toolkit)
- **Terraform**: Node.js instalado (para npx)
- **AWS IaC MCP**: `uv` instalado (`brew install uv`) - ✅ Instalado
- **Ansible MCP**: ⚠️ Em desenvolvimento - sem pacote disponível
- **GitHub MCP**: Já configurado e funcionando
- **PostgreSQL MCP**: Variável de ambiente `DATABASE_URL` necessária (desabilitado temporariamente)
- **Context7 MCP**: API key configurada

### Configurar Variáveis de Ambiente

Adicione no `secrets.lua` ou exporte manualmente:

```lua
-- No secrets.lua
github_token = "ghp_seu_token_aqui",
-- DATABASE_URL deve ser passado diretamente no ambiente
```

### Verificar MCPs Ativos

```bash
opencode mcp list
```

### Contexto para AI

Quando sugerir configurações Neovim:

- Usar Lua moderno (não VimScript)
- Seguir estrutura modular em `lua/saad/plugins/`
- Garantir compatibilidade com lazy.nvim
- Considerar plugins já instalados (ver lista abaixo)
- **NUNCA** sugerir commitar `secrets.lua`
- Sempre usar `secrets.lua` para API keys

---

## Plugins Instalados

### AI Tools

- **`opencode.lua`**: ✅ Ativo - Integração com OpenCode AI
- **`avante.lua`**: ❌ Desativado - Movido para pasta `disabled/`

### Disabled Plugins

- **`avante.lua`**: Plugin AI substituído pelo OpenCode
- **`colorscheme.lua`**: Tema desativado (usando catppuccin)
- **`flutter.lua`**: Suporte Flutter não necessário atualmente
- **`live-server.lua`**: Servidor live para web development
- **`vim-terraform.lua`**: Suporte Terraform via Vim (usando LSP)
- **`yazi.lua`**: File explorer alternativo (usando nvim-tree)

### Core Plugins

- **`alpha.lua`**: Configures the startup screen for Neovim.
- **`auto-session.lua`**: Manages session persistence.
- **`autopairs.lua`**: Automatically inserts matching pairs of characters.
- **`bufferline.lua`**: Enhances the buffer line with additional features.
- **`colorscheme.lua`**: Manages color schemes.
- **`comment.lua`**: Facilitates easy commenting of code.
- **`diffview.lua`**: Provides a Git diff view.
- **`dressing.lua`**: Improves UI components.

### Development Tools

- **`formatting.lua`**: Uses `conform.nvim` for formatting files with tools like Prettier and Black.
- **`git.lua`**: Integrates Git functionalities.
- **`gitsigns.lua`**: Shows Git changes in the sign column.
- **`lazygit.lua`**: Integrates LazyGit for Git operations.
- **`linting.lua`**: Configures `nvim-lint` for linting support across multiple languages.

### LSP Configuration

- **`lsp/mason.lua`**: Gerenciador automático de LSPs, formatters e linters
- **`lsp/lspconfig.lua`**: Configuração dos servidores LSP para múltiplas linguagens

### Navigation & UI

- **`nvim-tree.lua`**: Provides a file explorer.
- **`telescope.lua`**: Adds fuzzy finding capabilities.
- **`which-key.lua`**: Integrates `which-key.nvim` for displaying available keybindings.
- **`lualine.lua`**: Configures the status line.
- **`noice.lua`**: Enhances the command line UI.
- **`indent-blankline.lua`**: Displays indentation guides.

### Coding Assistance

- **`nvim-cmp.lua`**: Configures the `nvim-cmp` plugin for autocompletion.
- **`treesitter.lua`**: Provides advanced syntax highlighting and code manipulation.
- **`trouble.lua`**: Displays diagnostics and issues.
- **`todo-comments.lua`**: Highlights and manages TODO comments.

### Utilities

- **`undotree.lua`**: Visualizes the undo history.
- **`vim-maximazer.lua`**: Maximizes and restores windows.
- **`rename.lua`**: Facilitates renaming of symbols.
- **`substitue.lua`**: Enhances substitution capabilities.
- **`surround.lua`**: Provides surround text manipulation.

---

## Stack Tecnológica

### Core

- **Editor**: Neovim 0.11+
- **Plugin Manager**: lazy.nvim
- **Terminal**: Alacritty
- **Shell**: Zsh
- **Multiplexer**: Tmux 3.x
- **AI Agent**: OpenCode CLI

### Linguagens Suportadas

- **JavaScript/TypeScript**: LSP (tsserver), Formatter (prettier), Linter (eslint)
- **Python**: LSP (pyright), Formatter (black), Linter (ruff)
- **Lua**: LSP (lua_ls), Formatter (stylua)
- **Terraform**: LSP (terraform-ls), Formatter (terraform fmt)
- **YAML/JSON**: LSP (yamlls, jsonls)
- **Jinja2**: Syntax support via Treesitter

---

## 🔐 Segurança e Secrets Management

### Sistema de Secrets

#### Estrutura de Arquivos

```
~/.config/nvim/lua/
├── secrets.lua          # Suas chaves reais (NUNCA commitar!)
└── secrets.lua.example  # Template para o Git
```

#### Como Configurar

1. **Primeiro uso (novo desenvolvedor):**

   ```bash
   cd ~/.config/nvim/lua
   cp secrets.lua.example secrets.lua
   # Editar secrets.lua com suas chaves reais
   ```

2. **Adicionar secrets.lua ao .gitignore:**

   ```bash
   # Já está configurado no .gitignore:
   lua/secrets.lua
   secrets.lua
   ```

3. **Formato do secrets.lua:**
   ```lua
   return {
       openai_api_key = "sk-proj-sua-chave-real",
       anthropic_api_key = "sk-ant-sua-chave-real",
       -- Outras chaves conforme necessário
   }
   ```

#### Como Plugins Usam Secrets

O OpenCode carrega automaticamente:

```lua
local secrets = require("secrets")
vim.env.OPENAI_API_KEY = secrets.openai_api_key
vim.env.ANTHROPIC_API_KEY = secrets.anthropic_api_key
```

#### ⚠️ Regras de Segurança

✅ **FAZER:**

- Manter `secrets.lua` no `.gitignore`
- Commitar apenas `secrets.lua.example`
- Rotacionar chaves periodicamente
- Usar chaves diferentes por máquina se possível

❌ **NÃO FAZER:**

- NUNCA commitar `secrets.lua`
- Não colocar chaves no `.zshrc` (vai para o Git!)
- Não usar `export` em arquivos versionados
- Não compartilhar chaves em chats/issues

---

## Regras para AI Assistants

### Ao Sugerir Configurações Neovim

✅ **FAZER**:

- Usar sintaxe Lua moderna (não VimScript legacy)
- Criar novo arquivo em `lua/saad/plugins/` se for plugin novo
- Usar lazy loading quando apropriado (`event`, `cmd`, `ft`)
- Incluir keybindings com `which-key` description
- Comentar código complexo em português
- Considerar plugins existentes antes de sugerir novos
- **Sempre** usar `secrets.lua` para API keys
- Mencionar adicionar novos secrets ao `.gitignore`

❌ **NÃO FAZER**:

- Não sugerir plugins duplicados (ex: outro file explorer se nvim-tree existe)
- Não usar `vim.cmd()` para configurações que podem ser Lua pura
- Não criar keybindings que conflitem com os existentes
- Não assumir que Packer ou Vim-plug estão instalados (usar lazy.nvim)
- **NUNCA** sugerir colocar API keys no `.zshrc` ou arquivos versionados
- Não recomendar `export` de secrets em arquivos de configuração

### Exemplo de Resposta Esperada

Quando eu perguntar "como adicionar suporte para Markdown":

```lua
-- lua/saad/plugins/markdown.lua
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    {
      "<leader>mp",
      "<cmd>MarkdownPreviewToggle<CR>",
      desc = "Markdown Preview",
    },
  },
}
```

Então adicionar em `init.lua` ou no lazy setup.

---

## Instalação e Setup

### Pré-requisitos

1. Neovim 0.11+
2. Node.js (para OpenCode CLI)
3. Git
4. Tmux
5. Zsh

### Instalação do OpenCode CLI

```bash
# Via NPM
npm install -g @sst/opencode

# Via Homebrew
brew install opencode

# Verificar instalação
opencode --version
```

### Setup do Neovim

```bash
# 1. Clonar dotfiles
git clone https://github.com/seu-usuario/dotfiles.git ~/dotfiles

# 2. Criar symlinks
ln -s ~/dotfiles/nvim/.config/nvim ~/.config/nvim

# 3. Configurar secrets
cd ~/.config/nvim/lua
cp secrets.lua.example secrets.lua
# Editar secrets.lua com suas API keys

# 4. Instalar plugins
nvim
:Lazy sync
```

### Verificação

```bash
# No Neovim
:checkhealth opencode
:checkhealth lazy

# No terminal
which opencode  # Deve mostrar o caminho do binário
```

---

## Troubleshooting

### Plugin OpenCode não carrega

```bash
# Verificar se secrets.lua existe
ls ~/.config/nvim/lua/secrets.lua

# Verificar logs no Neovim
:messages

# Recarregar configuração
:source ~/.config/nvim/init.lua
```

### API Key não funciona

```lua
-- No Neovim, verificar se secrets foi carregado:
:lua print(vim.inspect(require("secrets")))

-- Deve mostrar suas chaves (mascaradas)
```

### OpenCode CLI não encontrado

```bash
# Verificar PATH
which opencode

# Se não encontrado, adicionar ao PATH no ~/.zshrc:
export PATH="$PATH:/caminho/para/opencode"
```

---

## Changelog

### 2025-02-12 - Migração para OpenCode

- ❌ Desativado Avante.nvim (bugs com auto-suggestions)
- ✅ Adicionado OpenCode.nvim
- ✅ Implementado sistema de secrets.lua
- ✅ Atualizado .gitignore para segurança
- ✅ Criado keybindings em português para OpenCode
- ✅ Configurado workflow com Tmux
- ✅ Adicionada estrutura LSP completa
- ✅ Organizada pasta disabled/ para plugins inativos
- 📝 Atualizado documentação completa

---

## Recursos Adicionais

- **OpenCode Docs**: [opencode.ai/docs](https://opencode.ai/docs)
- **Plugin GitHub**: [sudo-tee/opencode.nvim](https://github.com/sudo-tee/opencode.nvim)
- **Lazy.nvim**: [github.com/folke/lazy.nvim](https://github.com/folke/lazy.nvim)
- **Neovim**: [neovim.io](https://neovim.io)

---

**Última atualização**: 12 de Fevereiro de 2025
