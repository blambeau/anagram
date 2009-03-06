module Anagram
  module Pack
    module Boolexpr
      module CommonTypes
        module Or; end
        module And; end
        module Proposition; end
        module Literal; end
        module Not; end
      end
      module SyntaxTree
        include CommonTypes
        module Parenthesized; end
        module Operator; end
      end
      module SemanticTree
        include CommonTypes
      end
    end
  end
end