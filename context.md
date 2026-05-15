# Personal Dev Environment

This repository defines a personal development environment centered on local workstation configuration, editor workflows, shell tooling, and AI-assisted developer tooling.

## Language

**Personal Dev Environment**:
The canonical scope of this repository: workstation config plus local developer tooling and bootstrap.
_Avoid_: Dotfiles puro, ops monorepo

**Dotfiles**:
The subset of this repository that configures interactive tools like Neovim, tmux, shell, and terminal emulators.
_Avoid_: Entire repository, infrastructure

**Bootstrap Tooling**:
Local setup and integration assets that install or wire developer tools into the environment.
_Avoid_: Runtime application code, infrastructure provisioning

**Daily Dev Workflow Asset**:
Anything that runs on this machine as part of the regular local development workflow.
_Avoid_: Rarely used personal artifacts, unrelated infrastructure automation

### Repository Categories

**Interactive Config**:
Configuration for the tools used directly during interactive development sessions.
_Avoid_: Tool integration metadata, generated analysis

**Developer Tooling**:
Local integrations that extend the development environment without being the primary interactive config themselves.
_Avoid_: Shell/editor config, generated docs

**Documentation**:
Human-written or generated material that explains, maps, or analyzes the repository.
_Avoid_: Executable config, runtime tooling

**Neovim-centric Environment**:
A development environment whose surrounding tools are primarily shaped to support the editor workflow.
_Avoid_: Terminal-centric environment, tool-agnostic setup

## Relationships

- The **Personal Dev Environment** includes the **Dotfiles**
- The **Personal Dev Environment** includes **Bootstrap Tooling**
- The **Dotfiles** are only one subset of the **Personal Dev Environment**
- A file belongs in this repository only if it is a **Daily Dev Workflow Asset**
- **Interactive Config**, **Developer Tooling**, and **Documentation** are the three canonical repository categories
- This repository is a **Neovim-centric Environment**
- In this repository, tmux, shell, terminal, and local tooling primarily support the Neovim workflow

## Example dialogue

> **Dev:** "Should `opencode/` live in this repo or somewhere else?"
> **Domain expert:** "Yes, if it supports the **Personal Dev Environment** locally; no, if it is generic infrastructure unrelated to the workstation setup."

## Flagged ambiguities

- "dotfiles" was being used to mean both the shell/editor configs and the entire repository; resolved: the repository is a **Personal Dev Environment**, and **Dotfiles** are one subset of it.
- `opencode.sh` and `main.yml` are currently present but do not fit the resolved repository boundary.
