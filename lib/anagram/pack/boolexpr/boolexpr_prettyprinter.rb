module Anagram
  module Pack
    module Boolexpr
  
      #
      # Pretty prints boolean expression from a semantic tree of the grammar.
      #
      class PrettyPrinter < Anagram::Rewriting::Rewriter
        include SemanticTree

        PRIORITIES = {Or => 1, And => 2, Not => 3, Proposition => 4, Literal => 5}
        Dyadic = Anagram::Matching::OrMatcher.new([Or, And])

        template Dyadic do |r,n| 
          left, op, right = r.apply(:left), r.apply(:op), r.apply(:right)
          right = "(#{right})" if PrettyPrinter.lower_priority?(n, n.right)
          "#{left} #{Or===n ? 'or' : 'and'} #{right}"
        end
        template Not         do |r,n| "not(#{r.apply(:right)})" end
        template Proposition do |r,n| r.semantic_value          end
        template Literal     do |r,n| r.semantic_value          end
    
        # Returns the priority of an Ast::Node
        def self.priority_of(who)
          p = PRIORITIES[who.semantic_types[0]]
          raise "Unexpected node #{who.inspect}" if p.nil?
          p
        end
  
        # Checks if a _what_ has lower priority than _who_ (both are expected
        # to be Ast::Nodes, not node kinds)
        def self.lower_priority?(who, what)
          raise ArgumentError if who.nil? or what.nil?
          priority_of(who) > priority_of(what)
        end

      end # class PrettyPrinter
      
    end
  end
end