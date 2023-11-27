#!/bin/sh
pushd ~/.dotfiles
nix build .#homeManagerConfigurations.x.activationPackage
./result/activate
