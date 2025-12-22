export PATH=$HOME/.local/bin:$PATH
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="fino"
plugins=(
	git
	# zsh-syntax-highlighting
  # zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Export nvim default editor 
export EDITOR=nvim

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/marcelosaad/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify


##### Alias
alias vim=nvim
alias v=vim 
alias vi=v
alias batcat=bat
alias k=kubectl

# History Search
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
# VI Mode
autoload edit-command-line && zle -N edit-command-line
bindkey "^v" edit-command-line
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history


# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ---- Eza (better ls) -----
alias ls="eza --icons=always"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
alias cd="z"

# ---- FZF -----

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# source <(kubectl completion zsh)
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Add kubectl completion 
source <(kubectl completion zsh)

# Ativar o kube-ps1
source ~/.kube-ps1/kube-ps1.sh
PROMPT='$(kube_ps1)'$PROMPT
KUBE_PS1_PREFIX="("            # Adiciona um prefixo antes do contexto
KUBE_PS1_SUFFIX=")"            # Adiciona um sufixo depois do contexto
KUBE_PS1_SYMBOL_USE_IMG=true   # Usa um ícone para o cluster

export PATH="$HOME/.cargo/bin:$PATH"

if [ "$TERM" = "xterm-kitty" ]; then
    alias ssh="kitty +kitten ssh"
fi
