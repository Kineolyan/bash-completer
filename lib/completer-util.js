// Util for completion in ruby scripts

exports.is_newer = function(stream) {
  try {
    // File.open($0) do |this_script|
    //   return this_script.mtime < file.mtime
    // end
  } catch (err) {
    return false;
  }
}

const ACTIONS_KEY = "__actions";
const VOID_OPTION = () => 3;
class Completer {

  constructor(definitions) {
    if (!this.isCompletionPhase()) {
      return;
    }

    this.completions = {}
    this.aliases = {}

    definitions(this);
    this.collectOptions();

    const code = this.doCompletion();
    process.exit(code);
  }

  isCompletionPhase() {
    return process.argv.includes('--__complete')
  }

  completeActions(...values, action) {
    this.completions[ACTIONS_KEY] = action;
    this.aliases[ACTIONS_KEY] = ACTIONS_KEY;
  }

  completeOptions(...values, action) {
    if (values === undefined || values.length === 0) {
      throw new Error('Invalid empty array of options');
    }

    this.completions[values[0]] = action;
    values.forEach(option => this.aliases[option] = values[0]);
  }

  OPTIONS_KEY = '__options'
  collectOptions() {
    this.aliases[OPTIONS_KEY] = OPTIONS_KEY
    this.completions[OPTIONS_KEY] = stream => {
      if (is_newer(stream)) {
        return 0;
      }

      options  = this.aliases.keys
      options.delete ACTIONS_KEY
      options.delete OPTIONS_KEY

      return 1, *options
    }
    }
  }

  registerOptions(...options) {
    this.completeOptions(...options, VOID_OPTION);
  }

  doCompletion() {
    parse_arguments

    # Get the appropriate action
    return 3 unless this.completion_key
    completion_action = this.completions[this.completion_key]

    exit_code, *values = completion_action.call this.stream
    puts values.join " "

    return exit_code
  }

  parse_arguments() {
    i = 0
    while i < ARGV.size
      arg = ARGV[i]
      case arg
      when /^--__complete$/
        context = uncased_context ARGV[i + 1]
        this.completion_key = this.aliases[context]
        i += 2
      when /^--__stream$/
        stream = ARGV[i + 1]
        this.stream = File.new(stream, 'r') if File.exists? stream
        i += 2
      else
        i += 1
      }
    }
  }

  uncased_context(value) {
    value.dup.gsub /@/, '-'
  }
}

module.exports = Completer;
