module Anagram
  module Rewriting
    class Engine
      
      # Engine template.
      class Template
      
        # Mode in which this template executes
        attr_reader :mode
      
        # Matching priority of this template
        attr_reader :priority
      
        # Creates a template instance
        def initialize(matcher, mode = :main, priority = 1.0, &block)
          @matcher, @mode, @priority = matcher, mode, priority
          @block = block
        end
      
        # Node matching test
        def ===(node)
          @matcher===node
        end
      
        # Executes this template on a context node
        def execute(engine, node)
          return if @block.nil?
          @block.call(engine, node)
        end
      
        def inspect
          "Template[#{@matcher.inspect}, #{mode.inspect}, #{priority.inspect}]"
        end
      
      end # class Template
    end  
  end
end