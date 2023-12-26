#!/bin/sh
set -x

pushd ~/.dotfiles
nix build -v .#nixosConfigurations.nixium.config.system.build.googleComputeImage
popd;
