# Guia de Configuração de Servidores MCP para Infra/DevOps

Este documento contém o guia completo de configuração dos servidores MCP (Model Context Protocol) para desenvolvimento de infraestrutura e DevOps.

---

## 📋 Visão Geral

### Servidores MCP Configurados

| # | Servidor | Status | Descrição |
|---|----------|--------|-----------|
| 1 | **AWS MCP** | ✅ Ativo | Gerencia recursos AWS (EC2, S3, Lambda, etc.) |
| 2 | **Kubernetes MCP** | ✅ Ativo | Gerencia clusters K8s |
| 3 | **Docker MCP** | ✅ Ativo | Via Docker Desktop MCP Toolkit |
| 4 | **Terraform Registry MCP** | ✅ Ativo | Consulta providers e módulos do Terraform |
| 5 | **AWS IaC MCP** | ❌ Precisa uvx | CDK e CloudFormation (requer instalação de uv) |

---

## 📁 Arquivo de Configuração

### Localização
```
~/.config/opencode/opencode.jsonc
```

### Conteúdo Atual
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
    }
  }
}
```

---

## 🔧 Configuração de Cada Servidor

### 1. AWS MCP Server

**Pacote:** `@imazhar101/mcp-aws-server`

**Recursos:**
- EC2: instâncias, security groups, key pairs
- S3: buckets, objetos, políticas
- Lambda: funções, camadas, versões
- IAM: usuários, roles, políticas
- ECS/EKR: clusters, serviços, tarefas

**Pré-requisitos:**
```bash
# Credenciais AWS configuradas
aws configure
# ou
export AWS_ACCESS_KEY_ID="AKIA..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_DEFAULT_REGION="us-east-1"
```

**Configuração no opencode.jsonc:**
```json
"aws": {
  "type": "local",
  "command": ["npx", "-y", "@imazhar101/mcp-aws-server"],
  "enabled": true
}
```

---

### 2. Kubernetes MCP Server

**Pacote:** `mcp-server-kubernetes`

**Recursos:**
-Pods: listar, criar, deletar, logs, exec
- Services: listar, descrever
- Deployments: listar, escalar, restart
- ConfigMaps e Secrets: listar, ver detalhes
- Helm: listar releases, install, uninstall

**Pré-requisitos:**
```bash
# kubectl configurado com contextos
kubectl config get-contexts

# Contextos disponíveis:
# - arn:aws:eks:sa-east-1:650167865564:cluster/provider-cloud-cluster
# - arn:aws:eks:us-east-1:650167865564:cluster/provider-staging-cloud  
# - kubernetes-admin@cluster.local
```

**Configuração no opencode.jsonc:**
```json
"kubernetes": {
  "type": "local",
  "command": ["npx", "-y", "mcp-server-kubernetes"],
  "enabled": true
}
```

**Para múltiplos contextos:**
O servidor automaticamente detecta todos os contextos do kubeconfig. Use `kubectl context` para trocar entre clusters.

---

### 3. Terraform Registry MCP Server

**Pacote:** `terraform-mcp-server`

**Recursos:**
- Listar providers do Terraform Registry
- Buscar módulos
- Ver versão de providers
- Documentação de recursos

**Configuração no opencode.jsonc:**
```json
"terraform-registry": {
  "type": "local",
  "command": ["npx", "-y", "terraform-mcp-server"],
  "enabled": true
}
```

**Variáveis de ambiente opcionais:**
```bash
export TERRAFORM_REGISTRY_URL="https://registry.terraform.io"
export TFC_TOKEN="seu-token-terraform-cloud"  # opcional
```

---

### 4. Docker MCP Server

**Status:** ✅ Ativo (via Docker Desktop MCP Toolkit)

**Pré-requisitos:**
1. Abrir Docker Desktop
2. Settings > Beta features > Enable Docker MCP Toolkit
3. Apply

**Configuração no opencode.jsonc:**
```json
"docker": {
  "type": "local",
  "command": ["docker", "mcp", "gateway", "run"],
  "enabled": true,
  "timeout": 60000
}
```

**Recursos disponíveis via Docker Desktop MCP Toolkit:**
- 200+ servidores MCP pré-configurados
- Isolados em containers
- Configuração de variáveis de ambiente e secrets
- Segurança com validação de inputs/outputs

---

### 5. AWS IaC MCP Server (CDK/CloudFormation)

**Pacote:** `awslabs.cdk-mcp-server`

**Status:** Precisa de instalação adicional (uvx)

**Instalação do uvx:**
```bash
# Instalar uv (universal Python package runner)
curl -LsSf https://astral.sh/uv/install.sh | sh

# ou via Homebrew
brew install uv
```

**Após instalar uv:**
```json
"aws-iac": {
  "type": "local",
  "command": ["uvx", "awslabs.cdk-mcp-server"],
  "enabled": true
}
```

**Recursos:**
- CDK best practices
- CDK Nag (segurança e compliance)
- AWS Solutions Constructs
- Geração de schemas para Bedrock Agent

---

## 🚀 Como Usar os Servidores MCP

### Verificar Status
```bash
opencode mcp list
```

### Habilitar/Desabilitar Servidor

Edite o arquivo `~/.config/opencode/opencode.jsonc` e altere `enabled` para `true` ou `false`.

### Autenticação
```bash
# Para servidores que requerem OAuth
opencode mcp auth <nome-servidor>
```

---

## 📝 Exemplos de Uso

### Com AWS
```
Liste todos os buckets S3 na minha conta AWS
```

### Com Kubernetes
```
Liste todos os pods no namespace default do cluster de staging
```

### Com Terraform
```
Quais são os providers disponíveis para AWS na versão 5.x?
```

---

## 🔄 Backup e Restauração

### Fazer Backup
```bash
# Copiar configuração atual
cp ~/.config/opencode/opencode.jsonc ~/dotfiles/opencode.jsonc.backup
```

### Restaurar Configuração
```bash
# Copiar backup de volta
cp ~/dotfiles/opencode.jsonc.backup ~/.config/opencode/opencode.jsonc

# Recarregar OpenCode
opencode mcp list
```

---

## ⚠️ Solução de Problemas

### Servidor não conecta
```bash
# Verificar logs
opencode mcp debug <nome-servidor>

# Verificar se o pacote está instalado
npx -y <pacote> --help
```

### Timeout no Docker
- O servidor Docker pode precisar de configuração adicional de socket
- Alternativa: usar Docker Desktop MCP Toolkit diretamente

### AWS credentials não funcionam
```bash
# Verificar credenciais
aws sts get-caller-identity

# Configurar novamente
aws configure
```

---

## 📦 Instalação de Dependências

### Node.js (para npx)
```bash
# Já deve estar instalado
node --version
npx --version
```

### uv (para AWS IaC MCP)
```bash
# macOS
brew install uv

# Linux
curl -LsSf https://astral.sh/uv/install.sh | sh
```

---

## 📅 Data de Criação
13 de Fevereiro de 2026

## 📅 Última Atualização
13 de Fevereiro de 2026
