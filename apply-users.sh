#!/bin/sh
set -x
USER=`whoami`
HOSTNAME=`hostname -s`
if [ -z "${USER}" ]
then
	echo "Not able to set USER with whoami ... Bailing out";
	exit 1;
fi
if [ -z "${HOSTNAME}" ]
then
	echo "Not able to get HOSTNAME with hostname -s ... Bailing out";
	exit 1;
fi

if [ "${USER}" = "root" ]
then
	echo "Current USER is ${USER}. This is meant to be run at a user-level (not root)."
	exit 1;
fi
echo "${USER}-${HOSTNAME}"
pushd ~/.dotfiles
nix build .#homeManagerConfigurations.${USER}-${HOSTNAME}.activationPackage
./result/activate
