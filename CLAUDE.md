# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Development Commands

**Core Development:**

- `nix develop` - Enter development shell with all necessary tools
- `./bin/format` - Format all Nix code with alejandra
- `./bin/lint` - Run linters (deadnix, statix, shellcheck)

**System Configuration:**

- `./bin/apply-system $(hostname -s)` - Apply NixOS or nix-darwin configuration
- `./bin/apply-user` - Apply home-manager configuration
- `./bin/apply-remote-ssh user@host hostname` - Deploy to remote system

**Maintenance:**

- `./bin/update-nix` - Update flake inputs and commit lock file
- `./bin/clean-nix` - Garbage collection and store optimization
- `./bin/build-vm` - Build VM for testing configurations
- `./bin/store-repair` - Verify and repair Nix store

## Repository Architecture

This is a comprehensive Nix flake managing multiple systems through a
modular architecture:

### System Configurations

- **NixOS Systems**: xnix (AMD desktop), nixpad (ThinkPad),
  hetznix (ARM64 server), vm (ARM64 VM)
- **Darwin Systems**: fom-mbp (Apple Silicon MacBook Pro)
- Each system has dedicated configuration in
  `system/HOSTNAME/configuration.nix`

### Modular Structure

**System Modules** (`modules/system-*/`):

- `system-nixos/` - NixOS-specific modules using `custom.system-nixos.*` options
- `system-darwin/` - macOS-specific modules using `custom.system-darwin.*`
  options
- Organized by functionality: common, dev, hardware, networking, security,
  services

**User Modules** (`modules/user/`):

- Cross-platform user configurations using `custom.user.*` options
- Categories: ai, desktop, dev, editors, games, mail, shell
- Applied via home-manager in `system/HOSTNAME/users/USERNAME/home.nix`

### Module Convention Patterns

**System Modules:**

```nix
options.custom.system-nixos.CATEGORY.MODULE.enable =
  lib.mkEnableOption "...";
config = lib.mkIf (cfg.system-nixos.enable &&
  cfg.system-nixos.CATEGORY.MODULE.enable) { ... };
```

**User Modules:**

```nix
options.custom.user.MODULE_NAME.enable = lib.mkEnableOption "...";
config = lib.mkIf config.custom.user.MODULE_NAME.enable { ... };
```

## Key Dependencies

- **sops-nix**: Secret management across all systems
- **nixos-hardware**: Hardware-specific configurations for laptops/desktops
- **disko**: Declarative disk management for servers/VMs
- **home-manager**: User environment management
- **pre-commit-hooks**: Automated code quality checks

## Testing Requirements

After making changes, always run linting before applying configurations:

1. `./bin/format` - Format code
2. `./bin/lint` - Check for issues
3. Test system changes with `./bin/build-vm` when possible
4. Apply changes incrementally: system first, then user configurations
