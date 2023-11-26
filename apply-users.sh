#!/bin/sh
pushd ~/.dotfiles
home-manager switch -f ./users/x/home.nix
