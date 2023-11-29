#!/bin/sh
set -x
DARWIN_REBUILD=`which darwin-rebuild`
NIXOS_REBUILD=`which nixos-rebuild`
if [ ! -z "${DARWIN_REBUILD}" ]; then
	echo "Found darwin-rebuild at ${DARWIN_REBUILD}"
	pushd ~/.dotfiles
	darwin-rebuild switch --flake .#
	popd
elif [ ! -z "${NIXOS_REBUILD}" ]; then
	echo "Found nixos-rebuild at ${NIXOS_REBUILD}"
	pushd ~/.dotfiles
	sudo nixos-rebuild switch --flake .#
	popd;
else
	echo "Could not find nixos-rebuild or darwin-rebuild ... Bailing out!"
	exit 1
fi
