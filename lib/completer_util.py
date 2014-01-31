# Util for completion in ruby scripts

import sys
import os.path
# import traceback

def isNewer(stream):
  """ Decides if your script is more recent than the given stream
  Params: stream path to the file to compare
  """
  if not os.path.exists(stream):
    return False

  return os.path.getmtime(stream) > os.path.getmtime(__file__)

class Completer:

  def __init__(self):
    self._completions = {}
    self._aliases = {}

  @staticmethod
  def hasCompletionCall():
    return "--__complete" in sys.argv

  ACTIONS_KEY = "__actions"
  def completeActions(self, action):
    self._completions[self.ACTIONS_KEY] = action
    self._aliases[self.ACTIONS_KEY] = self.ACTIONS_KEY

    return self

  def completeOptions(self, options, action):
    if len(options) == 0:
      raise ValueError("Invalid empty array of options")

    self._completions[options[0]] = action
    for option in options:
      self._aliases[option] = options[0]

    return self

  VOID_OPTION = lambda(stream): 2
  def registerOptions(self, options):
    for option in options:
      self._aliases[option] = option
      self._completions[option] = self.VOID_OPTION

  OPTIONS_KEY = "__options"
  def collectOptions(self):
    self._aliases[self.OPTIONS_KEY] = self.OPTIONS_KEY
    self._completions[self.OPTIONS_KEY] = self.optionsCompletionMethod()

  def optionsCompletionMethod(self):
    def callback(stream):
      if isNewer(stream):
        return 0

      keys = self._aliases.keys()
      keys.remove(self.ACTIONS_KEY)
      keys.remove(self.OPTIONS_KEY)

      return 1, keys

    return callback

  def doCompletion(self):
    try:
      if not self.hasCompletionCall():
        # Do nothing for completion, let the program run
        return

      self.collectOptions()

      self.parseArguments()

      # Get the appropriate action
      if not self._completionKey or not self._completionKey in self._completions:
        exit(3)

      completionAction = self._completions[self._completionKey]

      completionResult = completionAction(self._stream)
      if type(completionResult) is tuple:
        exit_code, values = completionAction(self._stream)
        print " ".join(values)
      elif type(completionResult) is int:
        exit_code = completionResult
      else:
        exit_code = 4

      exit(exit_code)
    except Exception as e:
     # print e
     # traceback.print_exc()
     exit(4)

  def parseArguments(self):
    i = 0
    while i < len(sys.argv):
      arg = sys.argv[i]
      if "--__complete" == arg:
        context = self.uncasedContext(sys.argv[i + 1])
        self._completionKey = self._aliases[context] if context in self._aliases else None
        i += 2
      elif "--__stream" == arg:
        self._stream = sys.argv[i + 1]
        i += 2
      else:
        i += 1

  @staticmethod
  def uncasedContext(value):
    return value.replace('@', '-')

