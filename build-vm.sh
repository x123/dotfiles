#!/bin/sh
set -xe
nix-build '<nixpkgs/nixos>' -A vm -I nixpkgs=channel:nixos-23.05 -I nixos-config=./system/xnixvm/configuration.nix
