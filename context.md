## Visão Geral

Repositório de dotfiles pessoais focado em produtividade para desenvolvimento.
Configurações otimizadas para trabalho com múltiplas linguagens (Python, JavaScript,
Terraform) e integração com ferramentas de AI/ML.

### Propósito

- Ambiente de desenvolvimento reproduzível e versionado
- Workflow otimizado para coding com AI assistance
- Configurações sincronizadas entre máquinas

# Dotfiles Project Overview

This document provides a comprehensive overview of the dotfiles project, focusing on its structure and configurations related to AI tools, particularly Neovim and any AI integrations.

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
│   │       │   └── saad
│   │       │       ├── plugins
│   │       │       │   ├── alpha.lua
│   │       │       │   ├── auto-session.lua
│   │       │       │   ├── autopairs.lua
│   │       │       │   ├── avante.lua
│   │       │       │   ├── bufferline.lua
│   │       │       │   ├── colorscheme.lua
│   │       │       │   ├── comment.lua
│   │       │       │   ├── diffview.lua
│   │       │       │   ├── dressing.lua
│   │       │       │   ├── formatting.lua
│   │       │       │   ├── git.lua
│   │       │       │   ├── gitsigns.lua
│   │       │       │   ├── indent-blankline.lua
│   │       │       │   ├── lazygit.lua
│   │       │       │   ├── linting.lua
│   │       │       │   ├── lualine.lua
│   │       │       │   ├── noice.lua
│   │       │       │   ├── nvim-cmp.lua
│   │       │       │   ├── nvim-tree.lua
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
├── tmux
│   └── .tmux.conf
└── zshrc
    └── .zshrc
```

## Neovim Configuration

## Filosofia de Configuração

### Princípios

- **Minimalismo**: Apenas plugins essenciais, evitar bloat
- **Performance**: Lazy loading sempre que possível
- **Consistência**: Keybindings seguem padrão Vim/Tmux
- **Modularidade**: Um arquivo por plugin/funcionalidade
- **`init.lua`**:
  - Loads core configurations and lazy loading of plugins.
  - Sets up notifications for macro recording events.

## AI Integration (Avante.nvim)

### Configuração Atual

- **Provider**: [Claude/OpenAI/outro - especificar]
- **Model**: [claude-sonnet-4-5/gpt-4/outro]
- **Keybindings principais**:
  - `<leader>aa` - Abrir Avante chat
  - `<leader>ae` - Explain selected code
  - `<leader>ar` - Refactor suggestion

### Workflow com AI

1. Selecionar código visualmente
2. `<leader>ae` para explicação contextual
3. AI considera:
   - Linguagem e contexto do arquivo
   - Convenções deste dotfile
   - Plugins instalados (LSP, formatters, linters disponíveis)

### Prompt Context para AI

Quando sugerir configurações Neovim:

- Usar Lua moderno (não VimScript)
- Seguir estrutura modular em `lua/saad/plugins/`
- Garantir compatibilidade com lazy.nvim
- Considerar plugins já instalados (ver lista abaixo)

- **Plugins**:
  - **`alpha.lua`**: Configures the startup screen for Neovim.
  - **`auto-session.lua`**: Manages session persistence.
  - **`autopairs.lua`**: Automatically inserts matching pairs of characters.
  - **`avante.lua`**: Integrates AI functionalities using Avante.nvim.
  - **`bufferline.lua`**: Enhances the buffer line with additional features.
  - **`colorscheme.lua`**: Manages color schemes.
  - **`comment.lua`**: Facilitates easy commenting of code.
  - **`diffview.lua`**: Provides a Git diff view.
  - **`dressing.lua`**: Improves UI components.
  - **`formatting.lua`**: Uses `conform.nvim` for formatting files with tools like Prettier and Black.
  - **`git.lua`**: Integrates Git functionalities.
  - **`gitsigns.lua`**: Shows Git changes in the sign column.
  - **`indent-blankline.lua`**: Displays indentation guides.
  - **`lazygit.lua`**: Integrates LazyGit for Git operations.
  - **`linting.lua`**: Configures `nvim-lint` for linting support across multiple languages.
  - **`lualine.lua`**: Configures the status line.
  - **`noice.lua`**: Enhances the command line UI.
  - **`nvim-cmp.lua`**: Configures the `nvim-cmp` plugin for autocompletion.
  - **`nvim-tree.lua`**: Provides a file explorer.
  - **`rename.lua`**: Facilitates renaming of symbols.
  - **`substitue.lua`**: Enhances substitution capabilities.
  - **`surround.lua`**: Provides surround text manipulation.
  - **`telescope.lua`**: Adds fuzzy finding capabilities.
  - **`todo-comments.lua`**: Highlights and manages TODO comments.
  - **`treesitter.lua`**: Provides advanced syntax highlighting and code manipulation.
  - **`trouble.lua`**: Displays diagnostics and issues.
  - **`undotree.lua`**: Visualizes the undo history.
  - **`vim-maximazer.lua`**: Maximizes and restores windows.
  - **`which-key.lua`**: Integrates `which-key.nvim` for displaying available keybindings.

## Stack Tecnológica

### Core

- **Editor**: Neovim 0.11+ (especificar versão mínima)
- **Plugin Manager**: lazy.nvim
- **Terminal**: kitty
- **Shell**: Zsh + [oh-my-zsh/outro]
- **Multiplexer**: Tmux 3.x

### Linguagens Suportadas

- **JavaScript/TypeScript**: LSP (tsserver), Formatter (prettier), Linter (eslint)
- **Python**: LSP (pyright), Formatter (black), Linter (ruff)
- **Lua**: LSP (lua_ls), Formatter (stylua)
- **Terraform**: LSP (terraform-ls), Formatter (terraform fmt)
- **YAML/JSON**: LSP (yamlls, jsonls)
- **Jinja2**: Syntax support via Treesitter

## AI and Language Support

- **AI Tools**:
  - While there are no explicit AI tools mentioned, the setup includes advanced autocompletion and LSP configurations that enhance coding efficiency and could be leveraged for AI development.

- **Language Support**:
  - Extensive support for languages like JavaScript, Python, Terraform, Jinja2, YAML, and Lua, making it suitable for a wide range of development tasks.

## Enhancements for AI Tool Utilization

- The current setup provides a robust environment for development with features like autocompletion, linting, and formatting, which are crucial for AI and machine learning projects.
- To further enhance AI tool utilization, consider integrating specific AI plugins or tools that provide features like code intelligence or model training assistance.

This overview provides a comprehensive understanding of the dotfiles project setup, particularly focusing on Neovim configurations and their potential for enhancing AI tool utilization.

## Regras para AI Assistants

### Ao Sugerir Configurações Neovim

✅ **FAZER**:

- Usar sintaxe Lua moderna (não VimScript legacy)
- Criar novo arquivo em `lua/saad/plugins/` se for plugin novo
- Usar lazy loading quando apropriado (`event`, `cmd`, `ft`)
- Incluir keybindings com `which-key` description
- Comentar código complexo em português
- Considerar plugins existentes antes de sugerir novos

❌ **NÃO FAZER**:

- Não sugerir plugins duplicados (ex: não adicionar outro file explorer se nvim-tree existe)
- Não usar `vim.cmd()` para configurações que podem ser Lua pura
- Não criar keybindings que conflitem com os existentes
- Não assumir que Packer ou Vim-plug estão instalados (usar lazy.nvim)

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
      "mp",
      "MarkdownPreviewToggle",
      desc = "Markdown Preview",
    },
  },
}
```

Então adicionar em `init.lua` ou no lazy setup.
