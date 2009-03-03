module Anagram
  module Rewriting

    #
    # Provides a simple but powerful way to create non intrusive DSLs.
    #
    # Example:
    #
    #    # You have a given user block that uses your DSL. The later installs
    #    # potentially intrusive methods in some Ruby core classes.
    #    DSLHelper.new(String => [:upcase], Symbol => [:/, :&, :|]) do
    #      load 'mydsl.rb'          # install your DSL first 
    #      yield if block_given     # yield user block
    #    end
    #
    # After that DSLHelper block, all Ruby methods are correctly restored.
    # Block accepted by new is optional. Calling save and restore methods 
    # is the alternative. However, please note that their invocation MUST
    # respect (save restore)* otherwise a RuntimeError is raised.
    #
    class DSLHelper
      
      # Creates a DSLHelper instance. _hash_ must be a Hash instance
      # mapping modules to array of symbols. If a block is given, the
      # Ruby state is immediately saved, block is yield and state is
      # restored after that.
      def initialize(hash)
        @definition = hash
        @saved = nil
        if block_given?
          save
          yield
          restore
        end
      end

      # Saves all methods of the definition hash in an internal data
      # structure. This method raises an error is a save is already
      # pending.
      def save
        raise "save already pending" unless @saved.nil?
        @saved = {}
        @definition.each_pair do |mod, methods|
          @saved[mod] = methods.collect {|m| find_method(mod,m)}
        end
      end
      
      # Restores all methods previously saved. This method raises an
      # error if no save call has been made before.
      def restore
        raise "save has not been called previously." if @saved.nil?
        @definition.each_pair do |mod, methods|
          methods.zip(@saved[mod]).each do |name, saved|
            if saved.nil?
              mod.send(:remove_method, name) if mod.method_defined?(name)
            elsif
              mod.send(:define_method, name, saved)
            end
          end
        end
        @saved = nil
      end
      
      # Finds a method inside a Module, or returns nil.
      def find_method(mod, method)
        mod.instance_method(method)
      rescue
        nil
      end

      private :find_method  
    end

  end
end
