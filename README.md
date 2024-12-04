# dotfiles

arquivos de config

instalar o app stow

## linux

`apt install stow`

## MacOS

`brew install stow`

`brew install kitty`

Após clonar o repositorio entrar na pasta dotfiles

`stow nvim`

`stow lvim`

`stow alacritty`

`stow tmux`

`stow zshrc`

`stow kitty`

## Tmux

`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`

#type this in terminal if tmux is already running

`tmux source ~/.tmux.conf`

### Para instalar os plugin

Press prefix + I (capital i, as in Install) to fetch the plugin.

## zshrc

`brew install fzf`

`brew install zsh-autosuggestions`

`brew install zsh-syntax-highlighting`

`brew install eza`

`brew install zoxide`

`brew install lazygit`

Git que indicar qual contexto esta executando kubernete
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
