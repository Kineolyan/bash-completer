# Checks the dependencies
# Echoes the list of elements missing
checkDependencies() {
  if [ ! -d /etc/bash_completion.d ]
  then
    echo "bash-completion"
  fi

  type getopt &> /dev/null || echo "getopt"

  return 0
}

# Checks the optional packages and binaries that could be installed
# Echoes the list of elements missing
checkOptionals() {
  type ruby &> /dev/null || echo "ruby"

  return 0
}

# Echoes a list
# $1 pre-message
# $2 post-message
# $* package list
echoPackageList () {
  local preMessage="$1"
  local postMessage="$2"
  shift 2

  echo -en $preMessage
  for package in $*
  do
    echo "\n* $package"
  done
  echo -e "\n$postMessage"

  return 0
}

COMPLETION_SCRIPT=/etc/bash_completion.d/bash-completer
COMPLETION_BINARY=/usr/bin/bash-completer
install() {
  sudo ln -s $PWD/__completer $COMPLETION_SCRIPT
  sudo ln -s $PWD/bin/bash-completer $COMPLETION_BINARY

  # reload the completion file to reset the environment
  bashOptions=$-
  set +e
  source $COMPLETION_SCRIPT
  [[ "$bashOptions" == *e* ]] && set -e

  return 0
}

uninstall() {
  sudo rm -f $COMPLETION_SCRIPT $COMPLETION_BINARY

  return 0
}

usage() {
  cat <<USAGE
Usage: ./install.sh [options]
Options:
  -h --help     prints this message
  --notes       prints installation notes
USAGE
}

echoNotes() {
echo -ne "\e[34m"
cat <<NOTES
Bravo ! The installation is complete.
You can now start to register programs for completion.

The bash-completer has been installed in ~/.bash-completer. It's important that you do not move it to another location.
Otherwise, the program will stop to work.

To uninstall this, go to ~/.bash-completer and execute th uninstaller
cd ~/.bash-completer
./uninstall.sh

Up to now, there is no system to update automatically your version of bash-completer.
Just uninstall and reinstall everything if a newer version comes up.

One more note:
You can always review this message by executing ./install --notes

NOTES
echo -e "Bye ...\e[0m"
}
