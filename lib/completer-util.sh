# This util will handle the completion for the communication
# between completer and the script on the values used for
# completion.
#
# This must be included after the definition of the completion
# functions.
#
# Completion functions are named:
# * complete__actions for the function defining the actions of the
#    script
# * complete__options for the function defining all possible
#    options of the script
# * complete@<x> for completion of the short option -<x>
# * complete@@<xyz> for completion of the long option --<xyz>
#
# It expects functions fullfilling the following contract:
# it returns:
#  0 if the values are up-to-date
#  1 if new values are set, these values are echoed
#  2 if there is no need to store the values, these values are echoed
#  3 if there is no completion

# Check if this is a call for complete by checking the presence
# of the option --__complete among the args.
if [[ "$@" == *--__complete* ]]
then
  readonly __completer_longOpts="__complete:,__stream:"
  __completer_args=$(getopt -qs bash -o '' -l "$__completer_longOpts" -- "$@")

  if [ $? -eq 0 ]
  then
    eval set -- "$__completer_args"
    while true
    do
      case $1 in
      --__complete) readonly __context="$2" ;;
      --__stream) readonly __stream="$2" ;;
      --) break ;;
      esac
      shift 2
    done
    
    complete$__context $__stream 2> /dev/null
    exit $?
  fi
fi
