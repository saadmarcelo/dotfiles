#!/usr/bin/env bash

# Script corrigido para sessionx - mostra TODAS as sessões com preview

CURRENT="$(tmux display-message -p '#S')"

# Obter TODAS as sessões (sem filtrar)
sessions=$(tmux list-sessions 2>/dev/null | sed -E 's/:.*$//')

# Se não houver sessões, usar a atual
if [[ -z "$sessions" ]]; then
    sessions="$CURRENT"
fi

# Script de preview
PREVIEW_SCRIPT="$HOME/.tmux/plugins/tmux-sessionx/scripts/preview.sh"

# Selecionar sessão com fzf + preview
selected=$(echo "$sessions" | fzf-tmux \
    -p 75%,85% \
    --prompt="Sessions: " \
    --preview-window=top,50% \
    --preview="$PREVIEW_SCRIPT {}")

# Se algo foi selecionado
if [[ -n "$selected" ]]; then
    # Se for a mesma sessão atual, não fazer nada
    if [[ "$selected" == "$CURRENT" ]]; then
        exit 0
    fi
    
    # Verificar se a sessão já existe
    if tmux has-session -t "$selected" 2>/dev/null; then
        tmux switch-client -t "$selected"
    else
        # Criar nova sessão se não existir
        tmux new-session -d -s "$selected"
        tmux switch-client -t "$selected"
    fi
fi
