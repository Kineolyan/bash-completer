#!/usr/bin/env bash
set -e

[ ! -e install-functions.sh ] && echo -e "\e[31mThe installer must be started from bash-completer directory.\e[0m" && exit 1

source 'install-functions.sh'

args=$(getopt -s bash -o 'h' -l 'help,notes' -- "$@")
if [ $? -ne 0 ]
then
  echo -e "\e[31mInvalid arguments\e[0m"
  usage
  exit 1
fi
eval set -- "$args"
while true
do
  option=$1
  shift 1

  case "$option" in
  -h|--help) usage ; exit 0 ;;
  --notes) echoNotes ; exit 0 ;;
  --) break ;;
  esac
done

## Installer for the bash-completer system.
cat <<MSG
Welcome in the installer of bash-completer.

There is few steps in this installer:
* checking of the dependencies
* configuration of the computer
* and it's done

So, let's go.
-------------
MSG

# Checking the dependencies
installationList=$(checkDependencies)

if [ -n "$installationList" ]
then
  echoPackageList "\e[33mbash-completer requires the following packages to work:" "\e[0m" $installationList
else
  echo -e "\e[32mAll dependencies are present\e[0m"
fi

## Checking for optionnal packages
optionalList=$(checkOptionals)

if [ -n "$optionalList" ]
then
  echoPackageList "The following packages and programs may be installed to take benefit of all features of bash-completer" "" $optionalList
fi

if [ -n "$installationList" ]
then
  cat <<MSG
This will exit to let you install the missing packages.
Restart the installer to resume where it left.
MSG
  exit 0
fi

cat <<MSG
------------------------------
Installation of bash-completer

> Installing the completion program
This step requires root privileges. It will
* install the completion commands in /etc/bash_completion.d
* install the completer binary in /usr/bin
MSG
while true
do
  echo -n "Continue the installation [Y/n] "
  read -n 1 continueInstallation
  echo ""

  if [ "$continueInstallation" == "n" ] || [ "$continueInstallation" == "N" ]
  then
    echo "Thanks for your participation. Retry when you want."
    exit 0
  elif [ "$continueInstallation" == "y" ] || [ "$continueInstallation" == "Y" ]
  then
    break
  else
    echo -e "\e[31mInvalid choice\e[0m"
    ## loop again
  fi
done

sudo ln -s $PWD/__completer /etc/bash_completion.d/bash-completer
sudo ln -s $PWD/bin/bash-completer /usr/bin/

# reload the completion file to reset the environment
source /etc/bash_completion.d/bash-completer

echo ""
echoNotes
