#!/usr/bin/env bash
set -e

[ ! -e install-functions.sh ] && echo -e "\e[31mThe uninstaller must be started from bash-completer directory.\e[0m" && exit 1

source 'install-functions.sh'

cat <<MSG
You are about to uninstall bash-completer.
This operation will require root privileges, as for the installation.

MSG
while true
do
  echo -n "Continue the uninstallation [Y/n] "
  read continueUninstallation

  if [ "$continueUninstallation" == "n" ] || [ "$continueInstallation" == "N" ]
  then
    echo "Good. We though you did not like us."
    exit 0
  elif [ -z "$continueUninstallation" ] || [ "$continueUninstallation" == "y" ] || [ "$continueInstallation" == "Y" ]
  then
    break
  else
    echo -e "\e[31mInvalid choice\e[0m"
    ## loop again
  fi
done
echo ""

uninstall

echo -en "\e[34m"
cat <<NOTES
bash-completer in now uninstalled.
If you ever want to re-install it, you can always execute ./install.sh

You can now remove the folder ~/.bash-completer.

NOTES
echo -e "Adios ...\e[0m"

exit 0
