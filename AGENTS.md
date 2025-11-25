# Agent Guidelines for dotfiles Repository

This document outlines the conventions and commands for agentic coding agents
operating within this repository.

## Build/Lint/Test Commands

* **Lint**: `deadnix -l -L .`, `statix check .`, `shellcheck bin/*`
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
* **Markdown**: all markdown files *must* pass the markdownlint checks.

## Custom User Module Conventions

* **Module Structure**: All modules in `modules/user/` must
  follow the `custom.user.MODULE_NAME` pattern:
    * Define options under `options.custom.user.MODULE_NAME`
    * Include at minimum an `enable` option using `lib.mkEnableOption` or
      `lib.mkOption`
    * Use conditional configuration:
      `config = lib.mkIf config.custom.user.MODULE_NAME.enable { ... }`
    * Support hierarchical sub-options for granular control (e.g.,
      `custom.user.editors.neovim.enable`)

* **Usage Pattern**: These modules are consumed in
  `system/SYSTEMNAME/users/USERNAME/home.nix` files using the same
  `custom.user.MODULE_NAME` format for configuration.

* **Examples**:
    * `modules/user/ai/default.nix` defines `options.custom.user.ai.enable`
    * `modules/user/dev/default.nix` defines `options.custom.user.dev.enable`
    * `modules/user/editors/default.nix` defines
      `options.custom.user.editors.enable`
        * can granularly enable, for example,
          `custom.user.editors.neovim.enable = true` inside home.nix file
    * Used as: `custom.user.ai.enable = true;` in home.nix files
