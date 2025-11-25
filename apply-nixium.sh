#!/bin/sh
set -x

DARWIN_REBUILD=`which darwin-rebuild`
NIXOS_REBUILD=`which nixos-rebuild`
if [ ! -z "${DARWIN_REBUILD}" ]; then
	echo "Found darwin-rebuild at ${DARWIN_REBUILD}"
	echo "darwin-rebuild doesn't support --target-host builds ... Bailing out!"
	exit 1
elif [ ! -z "${NIXOS_REBUILD}" ]; then
	echo "Found nixos-rebuild at ${NIXOS_REBUILD}"
	pushd ~/.dotfiles
    #nixos-rebuild -v build --flake .#nixium
    nixos-rebuild -v switch --target-host root@nixium.boxchop.city --flake .#nixium
	popd;
else
	echo "Could not find nixos-rebuild or darwin-rebuild ... Bailing out!"
	exit 1
fi
