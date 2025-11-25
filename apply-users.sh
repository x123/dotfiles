#!/bin/sh
set -x
USER=`whoami`
if [ -z "${USER}" ]
then
	echo "Not able to set USER with whoami. Bailing";
	exit 1;
fi

if [ "${USER}" = "root" ]
then
	echo "Current USER is ${USER}. This is meant to be run at a user-level (not root)."
	exit 1;
fi
echo $USER
pushd ~/.dotfiles
nix build .#homeManagerConfigurations.${USER}.activationPackage
./result/activate
