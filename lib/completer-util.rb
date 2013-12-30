# Util for completion in ruby scripts

module Completer

  class Completer
  
    def initialize &definitions
      return unless completion_phase?

      @completions = {}
      @aliases = {}
  
      instance_eval(&definitions)
  
      exit do_completion
    end

    def completion_phase?
      ARGV.find_index "--__complete"
    end
  
    def complete *values, &action
      raise ArgumentError.new "Invalid empty array of options" unless values && values.size > 0
  
      @completions[values.first] = action
      values.each { |option| @aliases[option] = values.first }
    end
  
    def do_completion
      parse_arguments
  
      # Get the appropriate action
      return 3 unless @completion_key
      completion_action = @completions[@completion_key]
       
      exit_code, *values = completion_action.call @stream
      puts values.join " "
  
      return exit_code
    end
  
    def parse_arguments 
      i = 0
      while i < ARGV.size
        arg = ARGV[i]
        case arg
        when /^--__complete$/
          context = uncased_context ARGV[i + 1]
          @completion_key = @aliases[context]
          i += 2
        when /^--__stream$/
          stream = ARGV[i + 1]
          @stream = File.new(stream, 'r') if File.exists? stream
          i += 2
        else
          i += 1
        end
      end
    end

    def uncased_context value
      uncased_value = value.dup
      2.times { |i| uncased_value[i] = '-' if value[i] == '@' }

      uncased_value
    end
  
  end

end
