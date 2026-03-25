#!/usr/bin/env bash
# Setup automático do OpenCode com sistema de secrets seguro
# Compatível com macOS (Bash 3.x+, zsh) e Linux
# Uso: ./opencode.sh

set -e  # Parar em caso de erro

# ============================================
# DETECTAR SISTEMA OPERACIONAL
# ============================================
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    OS_DISPLAY="macOS"
    SED_INPLACE="sed -i ''"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    OS_DISPLAY="Linux"
    SED_INPLACE="sed -i"
else
    OS="unknown"
    OS_DISPLAY="Unknown"
    SED_INPLACE="sed -i"
fi

# ============================================
# CORES PARA OUTPUT
# ============================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================
# FUNÇÕES AUXILIARES
# ============================================
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

# ============================================
# BANNER
# ============================================
clear
echo ""
echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║   Setup OpenCode + Sistema de Secrets  ║${NC}"
echo -e "${MAGENTA}║          Dotfiles Configuration        ║${NC}"
echo -e "${MAGENTA}║                                        ║${NC}"
echo -e "${MAGENTA}║         Sistema: $OS_DISPLAY                ║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
echo ""

sleep 1

# ============================================
# 1. VERIFICAR PRÉ-REQUISITOS
# ============================================
print_step "1. Verificando pré-requisitos..."
echo ""

# Verificar Neovim
if ! command -v nvim &> /dev/null; then
    print_error "Neovim não encontrado!"
    if [[ "$OS" == "macos" ]]; then
        echo "  Instale com: ${CYAN}brew install neovim${NC}"
    else
        echo "  Instale com seu gerenciador de pacotes"
    fi
    exit 1
fi
NVIM_VERSION=$(nvim --version | head -n1 | cut -d' ' -f2)
print_success "Neovim encontrado: v$NVIM_VERSION"

# Verificar Node.js (para OpenCode)
if ! command -v node &> /dev/null; then
    print_warning "Node.js não encontrado. Necessário para OpenCode CLI."
    if [[ "$OS" == "macos" ]]; then
        print_info "Instale com: ${CYAN}brew install node${NC}"
    fi
    echo ""
    read -p "Continuar mesmo assim? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    NODE_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    print_success "Node.js encontrado: $NODE_VERSION"
    print_success "npm encontrado: v$NPM_VERSION"
fi

# Verificar Git
if ! command -v git &> /dev/null; then
    print_error "Git não encontrado!"
    exit 1
fi
GIT_VERSION=$(git --version | cut -d' ' -f3)
print_success "Git encontrado: v$GIT_VERSION"

# Verificar Tmux (opcional mas recomendado)
if command -v tmux &> /dev/null; then
    TMUX_VERSION=$(tmux -V | cut -d' ' -f2)
    print_success "Tmux encontrado: $TMUX_VERSION"
else
    print_warning "Tmux não encontrado (recomendado para workflow completo)"
    if [[ "$OS" == "macos" ]]; then
        print_info "Instale com: ${CYAN}brew install tmux${NC}"
    fi
fi

echo ""
sleep 1

# ============================================
# 2. VERIFICAR DIRETÓRIOS
# ============================================
print_step "2. Verificando estrutura de diretórios..."
echo ""

NVIM_CONFIG="$HOME/.config/nvim"
PLUGINS_DIR="$NVIM_CONFIG/lua/saad/plugins"
LUA_DIR="$NVIM_CONFIG/lua"

if [ ! -d "$NVIM_CONFIG" ]; then
    print_error "Configuração do Neovim não encontrada em $NVIM_CONFIG"
    print_info "Execute este script após configurar seu Neovim"
    exit 1
fi
print_success "Configuração Neovim: $NVIM_CONFIG"

if [ ! -d "$PLUGINS_DIR" ]; then
    print_warning "Diretório de plugins não encontrado. Criando..."
    mkdir -p "$PLUGINS_DIR"
    print_success "Criado: $PLUGINS_DIR"
else
    print_success "Diretório de plugins encontrado"
fi

echo ""
sleep 1

# ============================================
# 3. CRIAR SISTEMA DE SECRETS
# ============================================
print_step "3. Configurando sistema de secrets..."
echo ""

SECRETS_FILE="$LUA_DIR/secrets.lua"
SECRETS_EXAMPLE="$LUA_DIR/secrets.lua.example"

# Criar secrets.lua.example (template)
if [ ! -f "$SECRETS_EXAMPLE" ]; then
    cat > "$SECRETS_EXAMPLE" << 'EOF'
-- Template de configuração de API keys
-- Copie para secrets.lua e adicione suas chaves reais
return {
    -- OpenAI API Key
    -- Obtenha em: https://platform.openai.com/api-keys
    openai_api_key = "sk-proj-YOUR_KEY_HERE",

    -- Anthropic API Key (Claude)
    -- Obtenha em: https://console.anthropic.com/settings/keys
    anthropic_api_key = "sk-ant-YOUR_KEY_HERE",

    -- GitHub Personal Access Token (opcional)
    -- github_token = "ghp_YOUR_TOKEN_HERE",

    -- GitLab Personal Access Token (opcional)
    -- gitlab_token = "glpat-YOUR_TOKEN_HERE",
}
EOF
    print_success "Criado: secrets.lua.example"
else
    print_success "secrets.lua.example já existe"
fi

# Verificar se secrets.lua existe
if [ -f "$SECRETS_FILE" ]; then
    print_success "secrets.lua já existe"
    echo ""
    read -p "Deseja visualizar (apenas primeiros 5 caracteres das chaves)? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        # Mostrar de forma segura (apenas início das chaves)
        if [[ "$OS" == "macos" ]]; then
            sed -E 's/(sk-[a-z]+-[A-Za-z0-9]{5})[A-Za-z0-9]+/\1***/g' "$SECRETS_FILE"
        else
            sed -r 's/(sk-[a-z]+-[A-Za-z0-9]{5})[A-Za-z0-9]+/\1***/g' "$SECRETS_FILE"
        fi
        echo ""
    fi
else
    print_warning "secrets.lua não encontrado."
    echo ""
    read -p "Criar agora com suas API keys? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        print_info "Cole suas API keys abaixo:"
        echo ""
        
        # OpenAI
        read -p "OpenAI API Key (sk-proj-...): " OPENAI_KEY
        if [ -z "$OPENAI_KEY" ]; then
            OPENAI_KEY="sk-proj-YOUR_KEY_HERE"
        fi
        
        # Anthropic
        read -p "Anthropic API Key (sk-ant-...): " ANTHROPIC_KEY
        if [ -z "$ANTHROPIC_KEY" ]; then
            ANTHROPIC_KEY="sk-ant-YOUR_KEY_HERE"
        fi
        
        echo ""
        
        cat > "$SECRETS_FILE" << EOF
-- Suas API keys (NUNCA commitar este arquivo!)
-- Gerado automaticamente em: $(date)
return {
    -- OpenAI API Key
    openai_api_key = "$OPENAI_KEY",

    -- Anthropic API Key (Claude)
    anthropic_api_key = "$ANTHROPIC_KEY",

    -- Adicione outras chaves conforme necessário
    -- github_token = "ghp_YOUR_TOKEN_HERE",
    -- gitlab_token = "glpat-YOUR_TOKEN_HERE",
}
EOF
        
        # Ajustar permissões (mais seguro)
        chmod 600 "$SECRETS_FILE"
        
        print_success "Criado: secrets.lua"
        print_success "Permissões ajustadas (600 - apenas você pode ler/escrever)"
    else
        print_warning "Você pode criar manualmente depois:"
        echo "  ${CYAN}cd $LUA_DIR${NC}"
        echo "  ${CYAN}cp secrets.lua.example secrets.lua${NC}"
        echo "  ${CYAN}# Editar e adicionar suas chaves${NC}"
    fi
fi

echo ""
sleep 1

# ============================================
# 4. ATUALIZAR .GITIGNORE
# ============================================
print_step "4. Configurando .gitignore..."
echo ""

GITIGNORE="$NVIM_CONFIG/.gitignore"

# Criar .gitignore se não existir
if [ ! -f "$GITIGNORE" ]; then
    touch "$GITIGNORE"
    print_info "Criado .gitignore vazio"
fi

# Adicionar regras de secrets se não existirem
if ! grep -q "secrets.lua" "$GITIGNORE" 2>/dev/null; then
    cat >> "$GITIGNORE" << 'EOF'

# ============================================
# SECRETS - NUNCA COMMITAR!
# ============================================
lua/secrets.lua
secrets.lua

# Mas manter o example
!secrets.lua.example
!lua/secrets.lua.example

# OpenCode sessions
.opencode/
**/opencode/sessions/

# Logs
*.log
logs/
EOF
    print_success "Adicionado secrets.lua ao .gitignore"
else
    print_success ".gitignore já protege secrets.lua"
fi

echo ""
sleep 1

# ============================================
# 5. INSTALAR OPENCODE CLI
# ============================================
print_step "5. Verificando OpenCode CLI..."
echo ""

if command -v opencode &> /dev/null; then
    OPENCODE_VERSION=$(opencode --version 2>&1 || echo "unknown")
    print_success "OpenCode CLI já instalado: $OPENCODE_VERSION"
else
    print_warning "OpenCode CLI não encontrado."
    echo ""
    
    if [[ "$OS" == "macos" ]]; then
        echo "Opções de instalação:"
        echo "  1) ${CYAN}npm install -g @sst/opencode${NC} (recomendado)"
        echo "  2) ${CYAN}brew install opencode${NC}"
        echo ""
    fi
    
    read -p "Instalar via npm agora? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_step "Instalando OpenCode CLI via npm..."
        if npm install -g @sst/opencode; then
            print_success "OpenCode CLI instalado com sucesso!"
            OPENCODE_VERSION=$(opencode --version 2>&1 || echo "unknown")
            print_info "Versão: $OPENCODE_VERSION"
        else
            print_error "Falha ao instalar OpenCode CLI"
            print_warning "Tente manualmente: npm install -g @sst/opencode"
        fi
    else
        print_warning "Você pode instalar depois:"
        echo "  ${CYAN}npm install -g @sst/opencode${NC}"
        if [[ "$OS" == "macos" ]]; then
            echo "  ou"
            echo "  ${CYAN}brew install opencode${NC}"
        fi
    fi
fi

echo ""
sleep 1

# ============================================
# 6. CRIAR PLUGIN OPENCODE
# ============================================
print_step "6. Verificando plugin OpenCode..."
echo ""

OPENCODE_PLUGIN="$PLUGINS_DIR/opencode.lua"

if [ -f "$OPENCODE_PLUGIN" ]; then
    print_success "opencode.lua já existe"
    
    # Verificar se tem a configuração básica
    if grep -q "sudo-tee/opencode.nvim" "$OPENCODE_PLUGIN"; then
        print_success "Plugin parece estar configurado corretamente"
    else
        print_warning "Plugin existe mas pode estar desatualizado"
    fi
    
    echo ""
    read -p "Criar backup e sobrescrever com template? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Backup com timestamp
        BACKUP_FILE="$OPENCODE_PLUGIN.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$OPENCODE_PLUGIN" "$BACKUP_FILE"
        print_success "Backup criado: $(basename $BACKUP_FILE)"
        print_warning "⚠️  Você precisa copiar o conteúdo do artifact manualmente"
    fi
else
    print_warning "opencode.lua não existe"
    print_info "Crie o arquivo copiando o conteúdo do artifact:"
    echo "  ${CYAN}Artifact: 'opencode.lua - Plugin OpenCode'${NC}"
    echo "  ${CYAN}Destino: $OPENCODE_PLUGIN${NC}"
fi

echo ""
sleep 1

# ============================================
# 7. DESABILITAR AVANTE
# ============================================
print_step "7. Verificando Avante.nvim..."
echo ""

AVANTE_PLUGIN="$PLUGINS_DIR/avante.lua"

if [ -f "$AVANTE_PLUGIN" ]; then
    if grep -q "enabled = false" "$AVANTE_PLUGIN"; then
        print_success "Avante já está desabilitado"
    else
        print_warning "Avante ainda está ativo"
        echo ""
        read -p "Desabilitar agora? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Backup
            BACKUP_FILE="$AVANTE_PLUGIN.backup.$(date +%Y%m%d_%H%M%S)"
            cp "$AVANTE_PLUGIN" "$BACKUP_FILE"
            print_success "Backup criado: $(basename $BACKUP_FILE)"
            
            # Adicionar enabled = false (compatível com macOS)
            if [[ "$OS" == "macos" ]]; then
                sed -i '' 's/return {/return {\n\t-- DESABILITADO - Usando OpenCode agora\n\tenabled = false,/' "$AVANTE_PLUGIN"
            else
                sed -i 's/return {/return {\n\t-- DESABILITADO - Usando OpenCode agora\n\tenabled = false,/' "$AVANTE_PLUGIN"
            fi
            
            print_success "Avante desabilitado (enabled = false adicionado)"
        fi
    fi
else
    print_info "Avante não encontrado (não há problema)"
fi

echo ""
sleep 1

# ============================================
# 8. VERIFICAR GIT STATUS
# ============================================
print_step "8. Verificando status do Git..."
echo ""

cd "$NVIM_CONFIG"

if git rev-parse --is-inside-work-tree &> /dev/null; then
    # Verificar se secrets.lua está sendo rastreado
    if git ls-files --error-unmatch lua/secrets.lua 2>/dev/null; then
        print_error "⚠️  ALERTA: secrets.lua está sendo rastreado pelo Git!"
        echo ""
        print_warning "Isso é PERIGOSO! Suas chaves podem vazar."
        echo ""
        read -p "Remover do Git agora? (RECOMENDADO) (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git rm --cached lua/secrets.lua 2>/dev/null || true
            print_success "Removido do controle do Git"
            print_info "Não esqueça de commitar esta mudança!"
        fi
    else
        print_success "secrets.lua não está sendo rastreado ✓"
    fi
    
    # Mostrar status resumido
    echo ""
    print_info "Status atual do Git:"
    git status --short | head -n 10
    
else
    print_warning "Não é um repositório Git"
fi

echo ""
sleep 1

# ============================================
# 9. CRIAR ARQUIVO DE CONFIGURAÇÃO OPENCODE
# ============================================
print_step "9. Verificando configuração do OpenCode..."
echo ""

OPENCODE_CONFIG="$HOME/.opencode/config.yml"

if [ -f "$OPENCODE_CONFIG" ]; then
    print_success "Configuração OpenCode já existe: $OPENCODE_CONFIG"
else
    print_info "Configuração OpenCode não encontrada"
    read -p "Criar configuração básica? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p "$HOME/.opencode"
        
        cat > "$OPENCODE_CONFIG" << 'EOF'
# Configuração básica do OpenCode
provider: anthropic

anthropic:
  model: claude-sonnet-4-20250514
  api_key: ${ANTHROPIC_API_KEY}

# O OpenCode vai usar as chaves do secrets.lua via Neovim
# Para uso standalone no terminal, configure:
# export ANTHROPIC_API_KEY="sua-chave"
EOF
        print_success "Criada configuração básica"
    fi
fi

echo ""
sleep 1

# ============================================
# 10. RESUMO E PRÓXIMOS PASSOS
# ============================================
print_step "10. Resumo da instalação"
echo ""

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          ✅ SETUP COMPLETO!            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}Arquivos criados/modificados:${NC}"
echo "  ✓ $SECRETS_EXAMPLE (template)"
if [ -f "$SECRETS_FILE" ]; then
    echo "  ✓ $SECRETS_FILE (suas chaves - protegido)"
fi
echo "  ✓ $GITIGNORE (atualizado)"
if [ -f "$OPENCODE_CONFIG" ]; then
    echo "  ✓ $OPENCODE_CONFIG (config OpenCode)"
fi
echo ""

echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo -e "${YELLOW}        PRÓXIMOS PASSOS MANUAIS         ${NC}"
echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo ""

echo -e "${BLUE}1.${NC} Copiar plugin OpenCode:"
echo "   ${CYAN}# Copie o conteúdo do artifact 'opencode.lua'${NC}"
echo "   ${CYAN}# Destino: $OPENCODE_PLUGIN${NC}"
echo ""

echo -e "${BLUE}2.${NC} Verificar secrets.lua:"
echo "   ${CYAN}cat $SECRETS_FILE${NC}"
echo ""

echo -e "${BLUE}3.${NC} Sincronizar plugins no Neovim:"
echo "   ${CYAN}nvim${NC}"
echo "   ${CYAN}:Lazy sync${NC}"
echo "   ${CYAN}:qa${NC}"
echo ""

echo -e "${BLUE}4.${NC} Testar OpenCode no Neovim:"
echo "   ${CYAN}nvim${NC}"
echo "   ${CYAN}<leader>oc${NC} ${NC}# Toggle OpenCode"
echo "   ${CYAN}<leader>oq${NC} ${NC}# Quick chat"
echo ""

echo -e "${BLUE}5.${NC} Verificar e commitar mudanças:"
echo "   ${CYAN}cd $NVIM_CONFIG${NC}"
echo "   ${CYAN}git status${NC} ${YELLOW}# Verificar que secrets.lua NÃO aparece!${NC}"
echo "   ${CYAN}git add lua/secrets.lua.example .gitignore${NC}"
echo "   ${CYAN}git commit -m 'feat: adicionar OpenCode com sistema de secrets'${NC}"
echo ""

echo -e "${RED}═══════════════════════════════════════${NC}"
echo -e "${RED}        ⚠️  AVISOS DE SEGURANÇA         ${NC}"
echo -e "${RED}═══════════════════════════════════════${NC}"
echo ""
echo "  • NUNCA commite secrets.lua"
echo "  • Sempre execute 'git status' antes de commit"
echo "  • Se secrets.lua aparecer no git status, execute:"
echo "    ${CYAN}git rm --cached lua/secrets.lua${NC}"
echo "  • Rotacione suas API keys periodicamente"
echo ""

# ============================================
# 11. OPÇÃO DE ABRIR NEOVIM
# ============================================
echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo ""
read -p "Abrir Neovim agora para verificar? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    print_step "Abrindo Neovim..."
    print_info "Dentro do Neovim, execute:"
    echo "  ${CYAN}:Lazy sync${NC}    # Sincronizar plugins"
    echo "  ${CYAN}:messages${NC}     # Ver mensagens"
    echo "  ${CYAN}:checkhealth${NC}  # Verificar saúde"
    echo "  ${CYAN}:qa${NC}           # Sair"
    echo ""
    sleep 3
    nvim
fi

echo ""
print_success "Setup concluído! 🎉"
echo ""

if [[ "$OS" == "macos" ]]; then
    print_info "Sistema $OS_DISPLAY detectado - script otimizado para sua plataforma!"
fi

print_info "Documentação completa em: context.md"
echo ""
