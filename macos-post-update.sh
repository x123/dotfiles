#!/bin/sh
set -x
DATESTAMP=`date -u "+%Y-%m-%d-%H%M%S%Z"`
sudo mv /etc/bashrc /etc/bashrc.orig.${DATESTAMP}
sudo mv /etc/zshrc /etc/zshrc.orig.${DATESTAMP}
sudo mv /etc/zprofile /etc/zprofile.orig.${DATESTAMP}
sudo mv /etc/shells /etc/shells.orig.${DATESTAMP}
sudo /nix/var/nix/profiles/system/activate.${DATESTAMP}
