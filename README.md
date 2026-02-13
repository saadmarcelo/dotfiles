# dotfiles

arquivos de config

instalar o app stow

## linux

`apt install stow`

## MacOS

`brew install stow`

`brew install kitty`

`brew install tmux`

Após clonar o repositorio entrar na pasta dotfiles

`stow nvim`

`stow lvim`

`stow alacritty`

`stow tmux`

`stow zshrc`

`stow kitty`

## Tmux

### Instalação

```bash
# 1. Instalar TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 2. Criar symlink para configuração
ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# 3. Instalar dependências
brew install fzf          # fuzzy finder (obrigatório para sessionx)
```

### Para instalar os plugins

Press prefix + I (capital i, as in Install) to fetch the plugin.

### tmux-sessionx (Plugin de Troca de Sessões)

Este dotfiles inclui uma versão corrigida do plugin `tmux-sessionx` que funciona corretamente com múltiplas sessões.

**Dependência obrigatória:**
- `fzf` - precisa estar instalado para o plugin funcionar

**Instalação do plugin (para ter o preview):**
```bash
git clone https://github.com/omerxx/tmux-sessionx.git ~/.tmux/plugins/tmux-sessionx
```

**Atalho:** `Ctrl+b O` - Abre seletor de sessões com preview

**Funcionalidades:**
- Lista todas as sessões (incluindo a atual)
- Preview em tempo real do conteúdo da sessão
- Criação de novas sessões
- Troca rápida entre sessões

## zshrc

`brew install fzf`

`brew install zsh-autosuggestions`

`brew install zsh-syntax-highlighting`

`brew install eza`

`brew install zoxide`

`brew install lazygit`

Git que indicar qual contexto esta executando kubernetes

`git clone https://github.com/jonmosco/kube-ps1.git ~/.kube-ps1`

# Ubuntu

## zshrc

`sudo apt install zsh -y`

`chsh -s $(which zsh)`

`zsh`

`source ~/.zshrc`

## Install oh my zsh

`sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"`

`git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions`

`git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting`

## Install zoxide

`sudo apt install zoxide`
