# Agent Guidelines for dotfiles Repository

This document outlines the conventions and commands for agentic coding agents
operating within this repository.

## Build/Lint/Test Commands

* **Lint**: `deadnix -l -L .`, `statix check .`, `shellcheck bin/*`
* **Pre-commit checks**: `nix flake check` (runs alejandra, deadnix,
  markdownlint, shellcheck)
* **Testing**: Tests must be completed by the user, please ask them to test
  the changes and report back.

## Code Style Guidelines

* **Formatting**: Enforced by `alejandra`. Code should be formatted
  automatically.
* **Imports**: No specific guidelines beyond what `deadnix` enforces (i.e., no
  unused imports).
* **Naming Conventions**: Adhere to existing Nix conventions.
* **Error Handling**: No explicit guidelines found; follow existing patterns.
* **Shell Scripts**: Linted with `shellcheck`. Follow POSIX shell best
  practices.
