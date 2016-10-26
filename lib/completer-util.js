// Util for completion in ruby scripts
const fs = require('fs');

function getStats(path) {
  try {
    return fs.statSync(path);
  } catch (err) {
    return undefined;
  }
}

function isNewer(stream) {
  if (stream !== undefined) {
    try {
      const currentStats = getStats(process.argv[1]);
      return currentStats === undefined || currentStats.mtime.getTime() < stream.mtime.getTime();
    } catch (err) {}
  }

  return false;
}

const ACTIONS_KEY = "__actions";
const OPTIONS_KEY = '__options';
const VOID_ACTION = () => [3];

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

  completeActions(action, ...values) {
    this.completions[ACTIONS_KEY] = action;
    this.aliases[ACTIONS_KEY] = ACTIONS_KEY;
  }

  completeOptions(action, ...values) {
    if (values === undefined || values.length === 0) {
      throw new Error('Invalid empty array of options');
    }

    this.completions[values[0]] = action;
    values.forEach(option => this.aliases[option] = values[0]);
  }

  collectOptions() {
    this.aliases[OPTIONS_KEY] = OPTIONS_KEY;
    this.completions[OPTIONS_KEY] = stream => {
      if (isNewer(stream)) {
        return [0];
      }

      const options = Object.keys(this.aliases)
        .filter(option => option !== ACTIONS_KEY && option !== OPTIONS_KEY);

      return [1, ...options];
    }
  }

  registerOptions(...options) {
    this.completeOptions(VOID_ACTION, ...options);
  }

  doCompletion() {
    this.parseArguments();

    if (!this.completionKey) {
      return 3;
    }

    const completionAction = this.completions[this.completionKey];
    const [exitCode, ...values] = completionAction(this.stream, this.previousArgs);
    // Output values for bash-completion
    process.stdout.write(`${values.join(' ')}\n`);

    return exitCode;
  }

  parseArguments() {
    let i = 0
    const args = process.argv.slice(2);
    while (i < args.length) {
      const arg = args[i]
      if (/^--__complete$/.test(arg)) {
        let context = this.uncasedContext(args[i + 1]);
        this.completionKey = this.aliases[context];
        i += 2;
      } else if (/^--__stream$/.test(arg)) {
        let stream = args[i + 1]
        this.stream = getStats(stream);
        i += 2;
      } else {
        i += 1;
      }
    }

    const argEndIdx = args.indexOf('--');
    this.previousArgs = argEndIdx >= 0 ? args.slice(argEndIdx + 1) : [];
  }

  uncasedContext(value) {
    return value.replace(/@/g, '-');
  }
}

exports.Completer = Completer;
exports.isNewer = isNewer;
