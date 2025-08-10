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

## System Module Conventions

* **Module Structure**: System modules follow platform-specific namespace
  patterns:
    * **NixOS modules** in `modules/system-nixos/` use the
      `custom.system-nixos` pattern:
        * Organize into logical categories (common, dev, hardware,
          networking, security, services, wayland, x11)
        * Define options under `options.custom.system-nixos.CATEGORY.MODULE`
        * Use conditional configuration:
          `config = lib.mkIf (cfg.system-nixos.enable &&
          cfg.system-nixos.CATEGORY.MODULE.enable) { ... }`
    * **Darwin modules** in `modules/system-darwin/` use the
      `custom.system-darwin` pattern:
        * Define options under `options.custom.system-darwin.MODULE`
        * Use conditional configuration:
          `config = lib.mkIf (cfg.system-darwin.enable &&
          cfg.system-darwin.MODULE.enable) { ... }`

* **Usage Pattern**: These modules are consumed in
  `system/SYSTEMNAME/configuration.nix` files using the corresponding
  namespace format.

* **Examples**:
    * NixOS: `modules/system-nixos/hardware/nvidia.nix` defines
      `options.custom.system-nixos.hardware.nvidia.enable`
    * Darwin: `modules/system-darwin/fonts.nix` defines
      `options.custom.system-darwin.fonts.enable`
    * Used as: `custom.system-nixos.hardware.nvidia.enable = true;` in
      configuration.nix files

* **Platform Logic**: System modules often include platform-specific
  conditional logic and may have complex configuration options beyond
  simple enable flags (e.g., network ranges, hostnames, ports).

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
