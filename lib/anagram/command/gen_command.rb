require 'optparse'
require 'anagram/pack/anagrammar/anagrammar'

module Anagram
  module Commands
    
    # Implementation of 'gen' anagram's subcommand 
    class ParserGenCommand
      
      # Grammar file taken as input
      attr_reader :grammar_file
      
      # Output file of the generated parser
      attr_reader :output_file
      
      # Builds the 'anagram tt' command options
      def options
        opts = OptionParser.new do |opt|
          opt.program_name = 'anagram'
          opt.version = Anagram::VERSION
          opt.release = nil
          opt.summary_indent = ' ' * 4
          banner = <<-EOF
            # usage: #{opt.program_name} gen [options] GRAMMAR
          EOF
          opt.banner = banner.gsub(/[ \t]+# /, "")
          opt.on("-o", "--output=OUTPUT",
                 "Flush parser generation in output file") do |value|
            @output_file = value         
          end
          opt.on("--stdout",
                 "Flush parser generation on output console") do |value|
            @output_file = STDOUT      
          end
          opt.on_tail("-h", "--help", "Show this message") do
            puts opts
            exit
          end
        end
      end
      
      # Shows usage and exit
      def show_usage(exit=true)
        puts options
        Kernel.exit if exit
      end
      
      # Puts an error message and exit
      def error(msg)
        puts msg
        Kernel.exit
      end
      
      # Runs the command
      def run(argv)
        opts = options
        
        # handle arguments    
        rest = opts.parse!(argv)
        show_usage(true) if rest.length != 1
        @grammar_file = rest[0]
        @output_file = "#{@grammar_file[0...-File.extname(@grammar_file).length]}_parser.rb" unless @output_file
     
        # check files
        error("No such grammar file #{@grammar_file}") \
          unless File.exists?(@grammar_file) and File.file?(@grammar_file) and
                 File.readable?(@grammar_file) 
        error("Unable to write #{@output_file}") \
          unless STDOUT==@output_file or not(File.exists?(@output_file)) or File.writable?(@output_file)
        
        grammar = File.read(@grammar_file)
        if STDOUT==@output_file
          STDOUT << Anagram::Pack::Anagrammar.to_ruby_code(grammar)
        else
          File.open(@output_file, 'w') do |f|
            f << Anagram::Pack::Anagrammar.to_ruby_code(grammar)
          end
        end
      end
      
    end # class TreetopCommand
    
  end 
end