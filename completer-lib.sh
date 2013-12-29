#!/usr/bin/env bash

readonly COMPLETION_FOLDER=$HOME/.completer
readonly PROGRAMS_FOLDER=$COMPLETION_FOLDER/programs

# create the appropriate env for the completion system
# $1 program name
install() {
  local program=$1

  mkdir -p $PROGRAMS_FOLDER/$program
  return 0
}

# $1 program name
createEnv() {
  local program=$1

  install $program
  return 0
}

# Gets the stream name where completion will be stored
# $1 program name
# $2 context
getStream() {
  echo "$PROGRAMS_FOLDER/$1/$2.cpl"
  return 0
}

# Records values for completion for a program in a specific context
# $1 program name
# $2 context
# $@ values
record() {
  local readonly program="$1"
  local readonly context="$2"
  shift 2

  createEnv $program
  local readonly stream="$(getStream $program $context)"

  # Clear stream from previous values
  > $stream

  for value in $@
  do
    echo $value >> $stream
  done
  return 0
}

# Checks if the recorded completion is up-to-date
# $1 program name
# $2 context
checkCompletion() {
  local readonly program="$1"
  local readonly context="$2"

  local readonly stream="$(getStream $program $context)"
  [ ! -e $stream ] && stream=''
  local readonly casedContext=${context//-/@}

  $program --__complete "$casedContext" --__stream "$stream"
  return $?
}

# Checks if the recorded completion is up-to-date
# $1 program name
# $2 context
getCompletion() {
  local readonly program="$1"
  local readonly context="$2"

  local readonly stream="$(getStream $program $context)"
  if [ -e $stream ] 
  then 
    cat $stream
    return 0
  else
    return 1
  fi
}

# Checks if the recorded completion is up-to-date
# $1 program name
# $2 context
doCompletion() {
  local readonly program="$1"
  local readonly context="$2"
  values=$(checkCompletion $program $context)
  exitCode=$?
  # it fails or there is no completion to expect
  [[ $exitCode > 2 ]] && exit $exitCode

  if [ $exitCode -eq 2 ]
  then
    echo $values
    return 0
  else
    if [ $exitCode -eq 1 ]
    then
      record $program $context $values
      echo $values
      return 0
    else
      getCompletion $program $context
      return $?
    fi
  fi
}

readonly REGISTRATION_FILE=$COMPLETION_FOLDER/__registered-programs
# Registers a program for completion
# $1 program
register() {
  local readonly program="$1"

  [ -e $REGISTRATION_FILE ] && presence=$(grep -cE "program:${program}$" $REGISTRATION_FILE) || presence=0

  # Add the program to the list
  [[ $presence = 0 ]] && echo "complete -F __completer $program # program:$program" >> $REGISTRATION_FILE

  return 0
}

# Registers a program for completion
# $1 program
unregister() {
  [ ! -e $REGISTRATION_FILE ] && return 0

  local readonly program="$1"

  local clearFile=0
  while read line
  do
    [[ $clearFile = 0 ]] && clearFile=1 && > $REGISTRATION_FILE
    echo $line >> $REGISTRATION_FILE
  done < <(grep -vE "^.*# program:${program}$" $REGISTRATION_FILE)
  
  return 0
}

# local variables
# mode: shell-script
