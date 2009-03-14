module Anagram
  
  #
  # Provides the matching framework used by Anagram to
  # match nodes in rewriting and selection tools.
  #
  module Matching
    
    # Factory methods to create matchers
    module Factory

      # Factors a TypeMatcher instance
      def type_matcher(mod)
        TypeMatcher.new(mod)
      end
    
      # Factors a AndMatcher instance
      def and_matcher(*args)
        AndMatcher.new(args)
      end
    
      # Factors a OrMatcher instance
      def or_matcher(*args)
        OrMatcher.new(args)
      end
    
      # Factors a NotMatcher instance
      def not_matcher(matcher)
        NotMatcher.new(matcher)
      end
      
      # Factors a HasKeyMatcher instance
      def has_key_matcher(key)
        HasKeyMatcher.new(key)
      end
    
      # Factors a HasChildMatcher instance
      def has_child_matcher(matcher)
        HasChildMatcher.new(matcher)
      end
    
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
