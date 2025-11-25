#!/bin/sh
set -x
USER=`whoami`
SCUTIL=`which scutil`

if [ ! -z "${SCUTIL}" ]
then
	HOSTNAME=`scutil --get LocalHostName`
else
	HOSTNAME=`hostname -s`
fi

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

echo "${USER}-${HOSTNAME}"
pushd ~/.dotfiles
nix build -v .#homeManagerConfigurations.${USER}-${HOSTNAME}.activationPackage
if [ $? -eq 0 ]
then
    ./result/activate;
else
    echo "Build above failed, not running ./result/activate";
    exit 1;
fi
