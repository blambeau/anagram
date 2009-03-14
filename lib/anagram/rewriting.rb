module Anagram
  
  #
  # Main module of Anagram's tools for your post-productions, semantic phases
  # and AST rewriting.
  #
  # == Example
  # 
  #   # (12+x)/(y*2) arithmetic expression (assuming typing modules exist)
  #   parser = ArithmeticParser.new
  #   ast = parser.parse("(15+x)/(y*2)")
  #
  #   # interpretation for x and y values
  #   interpretation = {"x" => 5, "y" => 2}
  #
  #   # we create an Engine instance for evaluating the expression
  #   engine = Anagram::Rewriting::Rewriter.new do
  #     template Times         do |r,node| r.apply(node.left) * r.apply(node.right)  end
  #     template Plus          do |r,node| r.apply(node.left) + r.apply(node.right)  end
  #     template Minus         do |r,node| r.apply(node.left) - r.apply(node.right)  end
  #     template Divide        do |r,node| r.apply(node.left) / r.apply(node.right)  end
  #     template Variable      do |r,node| interpretation[r.strip]                   end
  #     template Literal       do |r,node| r.integer                                 end
  #     template Parenthesized do |r,node| r.apply(0)                                end
  #   end
  #   engine.execute(ast)     # -> 5
  #
  # == Rewriting Engine
  #
  # All tools here are specializations or configurations of the Engine class.
  # This engine working is similar to XSLT processing of XML files, even if
  # important differences exist. The architecture of this class is generic 
  # and can be specialized for different tasks by including additional modules
  # (see use cases later). Its behavior can be described as follows:
  #
  # [Template] The engine is configured by installing templates on it. Templates
  #            can be seen as code blocks that are be executed when specific AST
  #            node are encountered (by pattern matching of their type). The engine
  #            is passed as first parameter and the matched node (aka context_node)
  #            as second argument.
  # [Apply] Maybe surprisingly, the engine does not hardcode the visit of AST nodes 
  #         (an infix or postfix tree visit for example). Instead, the templates
  #         decide which nodes have to be visited by invoking the engine <tt>apply</tt>
  #         method, passing nodes as arguments.
  # [Selection] In most cases (like the example above), selecting nodes can be made
  #             directly (like <tt>node.right</tt>). In more complex cases, one will
  #             typically use <tt>node.select(...)</tt> for making node selections on which 
  #             templates must be applied (see Anagram::Ast for details about selections).
  #             The apply method and all derived tools are friendly: you can directly
  #             express your selection, which will be made on the current context_node
  #             by the engine itself (it is the reason why r.apply(0) works for the 
  #             Parenthesized template in the example).
  # [DRY shortcuts] DRY shortcuts for common tasks exist in the Engine itself. For example,
  #                 <tt>r.apply_all</tt> is a shortcut for <tt>r.apply(node.children)</tt>.
  #                 Additional shortcuts can be installed by including pluggin modules.
  #                 In the example, <tt>r.strip</tt> and <tt>r.integer</tt> are shortcuts 
  #                 provided by the Anagram::Rewriting::Syntax2Semantics pluggin.
  # [Execution modes] Complex semantic phases sometimes require visiting same nodes multiple
  #                   times, making different things at different times. Engine modes are 
  #                   designed to handle such complex situations. Engine::DSL.mode allows 
  #                   creating templates in different modes while Engine.in_mode allows 
  #                   templates to switch the current mode before applying processing. 
  #                 
  # == Pointers
  #
  # [Engine::DSL] This module is the Domain Specific Language for creating engine 
  #               configurations. In addition to the <tt>template</tt> and the <tt>include</tt>
  #               keywords, you'll find useful other utils to configure your engine easily.
  # [Use cases] Below are descriptions of typical engine use cases.
  #
  # == AST rewriting
  # 
  # Assume that we would like to create a semantic tree from arithmetic expressions
  # by rewriting the parse tree returned by the generated Anagram parser. Below is an
  # example of engine configuration that creates a semantic tree, skipping all 
  # Parenthesized nodes, stripping spaces in variable names, converting literals as
  # integers embedded as semantic values of leaf nodes.
  #
  #   engine = Anagram::Rewriting::Rewriter.new do
  #     template Times|Plus|Divide|Minus  do |r,node| r.copy_and_apply(:left, :op, :right) end
  #     template Variable                 do |r,node| r.as_leaf(r.strip)                   end
  #     template Operator                 do |r,node| r.as_leaf(r.symbol)                  end
  #     template Literal                  do |r,node| r.as_leaf(r.integer)                 end
  #     template Parenthesized            do |r,node| r.apply(0)                           end
  #   end
  #
  # == Array AST production
  #
  # Simple semantic trees are sometimes easier to manipulate when represented by simple arrays.
  # For example, the arithmetic expression (12+x)/(y*2) can be represented as the following array:
  #
  #   [:/, [:+, 12, "x"], [:*, "y", 2]]
  #
  # From the semantic tree created previously, producing this array can be made using the following 
  # engine configuration:
  #
  #   engine = Anagram::Rewriting::Engine.new do
  #     template Times|Plus|Divide|Minus   do |r,node| r.apply(:left :op, :right)  end
  #     template Variable|Operator|Literal do |r,node| r.semantic_value            end
  #   end
  #
  module Rewriting
  end

end

require "anagram/rewriting/matchers"
require "anagram/rewriting/engine_methods"
require "anagram/rewriting/engine_state"
require "anagram/rewriting/engine_template"
require "anagram/rewriting/engine_dsl"
require "anagram/rewriting/engine_configuration"
require "anagram/rewriting/engine"
require "anagram/rewriting/syntax2semantics"
require "anagram/rewriting/rewriter"
require "anagram/rewriting/wlang/anagram_ruleset"
