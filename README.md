# Nix Configuration

A comprehensive Nix flake-based configuration for managing multiple systems,
including NixOS and macOS (via nix-darwin).

## Overview

This repository contains a centralized configuration for:

- NixOS systems (desktop, laptop, servers, VM)
- macOS systems (via nix-darwin)
- Home Manager configurations for all systems

## Systems

### NixOS Systems

- **xnix**: AMD desktop with NVIDIA GPU
- **nixpad**: Lenovo ThinkPad T480s
- **hetznix**: Hetzner cloud server (aarch64)
- **vm**: VM configuration (aarch64)

### Darwin (macOS) Systems

- **fom-mbp**: MacBook Pro (Apple Silicon)

### Home Manager Configurations

- User environments for all above systems

## Directory Structure

```text
.
├── bin/                # Helper scripts
├── modules/            # Shared configuration modules
│   ├── nix-settings/   # Common Nix settings
│   ├── system-darwin/  # macOS-specific modules
│   ├── system-nixos/   # NixOS-specific modules
│   └── user/           # User configurations
├── system/             # System-specific configurations
└── flake.nix          # Main entry point
```

## Usage

### Setup a New System

```bash
# Clone repository
git clone https://github.com/x123/dotfiles.git
cd dotfiles

# Apply system configuration (NixOS or Darwin)
./bin/apply-system $(hostname -s)

# Apply user configuration
./bin/apply-user
```

### Update System

```bash
# Update flake inputs
./bin/update-nix

# Apply changes
./bin/apply-system $(hostname -s)
./bin/apply-user
```

### Remote Deployment

```bash
# Deploy to a remote system
./bin/apply-remote-ssh user@host hostname
```

## Helper Scripts

| Script | Description |
|--------|-------------|
| `apply-system` | Apply NixOS or nix-darwin configuration |
| `apply-user` | Apply home-manager configuration |
| `apply-remote-ssh` | Deploy to remote system via SSH |
| `update-nix` | Update flake inputs |
| `clean-nix` | Garbage collection and store optimization |
| `format` | Format code with alejandra |
| `lint` | Run linters (deadnix, statix, shellcheck) |
| `build-vm` | Build VM for testing |
| `store-repair` | Verify and repair Nix store |
| `macos-post-update` | Post-update tasks for macOS |

## Features

- Multi-system management with Nix flakes
- Secret management with [sops-nix](https://github.com/Mic92/sops-nix)
- Development environments via `nix develop`
- Automated formatting and linting via pre-commit hooks
- Disk management with [disko](https://github.com/nix-community/disko)
- Hardware-specific configurations via [nixos-hardware](https://github.com/NixOS/nixos-hardware)

## Development

A development shell is provided with necessary tools:

```bash
nix develop
```

This gives you access to:

- alejandra (formatter)
- deadnix (detects unused variables)
- statix (linter)
- sops (secrets management)
- shellcheck (shell script linter)
- and more
