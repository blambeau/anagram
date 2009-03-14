module Anagram
  
  #
  # Provides the matching framework used by Anagram to
  # match nodes in rewriting and selection tools.
  #
  module Matching
    
    # Factory methods to create matchers
    module Factory

      # Ensures that the given argument can be seen as a matcher
      def ensure_matcher(matcher)
        case matcher
          when Matcher
            matcher
          when Symbol
            HasKeyMatcher.new(matcher)
          when Module
            TypeMatcher.new(matcher)
          else
            raise ArgumentError, "Matcher expected, #{matcher} received." unless Matcher===matcher
        end
      end
      
      # Ensures that the given matchers (an array of) can all be seen as 
      # matcher instances.
      def ensure_matchers(matchers)
        raise ArgumentError unless Array===matchers
        matchers.collect {|m| ensure_matcher(m)}
      end
      
      # Factors a TypeMatcher instance
      def type_matcher(mod)
        TypeMatcher.new(mod)
      end
      alias :is_a :type_matcher
    
      # Factors a AndMatcher instance
      def and_matcher(*args)
        AndMatcher.new(args)
      end
      alias :and :and_matcher
    
      # Factors a OrMatcher instance
      def or_matcher(*args)
        OrMatcher.new(args)
      end
      alias :or :or_matcher
    
      # Factors a NotMatcher instance
      def not_matcher(matcher)
        NotMatcher.new(matcher)
      end
      alias :not :not_matcher
      
      # Factors a HasKeyMatcher instance
      def has_key_matcher(key)
        HasKeyMatcher.new(key)
      end
      alias :has_key :has_key_matcher
    
      # Factors a HasChildMatcher instance
      def has_child_matcher(matcher)
        HasChildMatcher.new(matcher)
      end
      alias :has_childw :has_child_matcher
    
    end # module Factory
    extend(Factory)
    
    # Ruby extensions hash used by the DSLHelper to make
    # its job
    RUBY_EXTENSIONS = {
      Module => [:not, :&, :|, :[]]
    }
    
    # The DSLHelper instance used to handle extensions
    DSL_HELPER = DSLHelper.new(RUBY_EXTENSIONS)
    
    # Installs the matching DSL. If a block is given yields it and uninstall
    # DSL after that. Otherwise, uninstall_dsl should be called later.
    def self.install_dsl
      DSL_HELPER.save
      load File.join(File.dirname(__FILE__), 'matching', 'ruby_extensions.rb')
      if block_given?
        yield
        DSL_HELPER.restore
      end
    end
    
    # Uninstalls the DSL. Calling this method means that a call to
    # install_dsl has been made before (without block).
    def self.uninstall_dsl
      DSL_HELPER.restore
    end
     
  end # module Matching

end

require 'anagram/matching/matcher'
require 'anagram/matching/type_matcher'
require 'anagram/matching/or_matcher'
require 'anagram/matching/and_matcher'
require 'anagram/matching/not_matcher'
require 'anagram/matching/has_key_matcher'
require 'anagram/matching/has_child_matcher'
