require 'optparse'

module Anagram
  module Commands
    
    # Main class of the 'anagram' command line tool. 
    class AnagramCommand
      
      # Recognized commands
      COMMANDS = {"tt" => "TreetopCommand"}
      
      # Builds the anagram command options
      def options
        opts = OptionParser.new do |opt|
          opt.program_name = 'anagram'
          opt.version = Anagram::VERSION
          opt.release = nil
          opt.summary_indent = ' ' * 4
          banner = <<-EOF
            # usage: #{opt.program_name} command [options]
            
            # The most commonly used anagram commands are
            #   tt     Generates a treetop parser from a grammar
            
            # See 'anagram help COMMAND' for more information on a specfic command.
          EOF
          opt.banner = banner.gsub(/[ \t]+# /, "")
        end
      end
      
      # Builds a command instance
      def build_command(name)
        unless COMMANDS.has_key?(name)
          puts "Unknown command #{name}"
          show_usage(true)
        end
        require File.join(File.dirname(__FILE__), "#{name}_command.rb")
        clazz = COMMANDS[name]
        Kernel.eval %Q{#{clazz}.new}
      end
      
      # Shows usage and optionally exit
      def show_usage(exit=true)
        puts options
        Kernel.exit if exit
      end
      
      # Runs the command
      def run(argv)
        show_usage(true) if argv.empty?
        command = argv.shift
        case command
          when "--help", "-h"
            show_usage(true)
          when "--version"
            puts "anagram version " << Anagram::VERSION << " (c) University of Louvain, Bernard Lambeau"
            exit
          when 'help'
            show_usage(true) unless command=argv.shift
            cmd = build_command(command)
            cmd.run(["--help"])
          else
            cmd = build_command(command)
            cmd.run(argv)
        end
      end
      
    end # class AnagramCommand
    
  end
end
