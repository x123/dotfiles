#!/bin/sh
set -xe

nixos-rebuild build-vm --flake .#xnix-vm

# without nixos-rebuild
#nix build .#nixosConfigurations.xnix-vm.config.system.build.vm

# old non flake way
#nix-build '<nixpkgs/nixos>' -A vm -I nixpkgs=channel:nixos-23.05 -I nixos-config=./system/xnixvm/configuration.nix
