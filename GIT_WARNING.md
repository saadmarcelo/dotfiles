# AVISO IMPORTANTE - Dotfiles NUNCA faz git commands

Este é o projeto de dotfiles. **NUNCA, EM HIPÓTESE ALGUMA**, execute comandos git (git add, git commit, git push, git pull, etc.) neste projeto sem autorização explícita do usuário.

## Razão

Dotfiles contém configurações pessoais e sensíveis (mesmo com secrets em arquivos ignorados). Commitar alterações automaticamente pode:
- Expor configurações que o usuário não quer versionar
- Quebrar o ambiente do usuário
- Submeter segredos acidentalmente

## Quando git É permitido

Apenas se o usuário solicitar explicitamente com palavras como:
- "Faça commit"
- "Commit isso"
- "Git commit"
- "Push para origin"

## Quando git NUNCA deve ser executado

- Após qualquer operação de modificação de arquivos
- Após install/sync de plugins (Lazy, Tmux, etc.)
- Após modificar configurações
- Em qualquer operação automática

## Regra

**SEMPRE peça confirmação antes de usar git neste projeto.**
