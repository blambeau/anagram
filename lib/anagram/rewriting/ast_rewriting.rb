module Anagram
  module Rewriting
    
    # 
    # Engine pluggin providing tools to rewrite ASTs.
    #
    module AstRewriting
      include Anagram::Ast::Helper

      ### Helpers for type rewriting ##########################################
      
      # Rewrites types inside _types_ array.
      def rewrite_types(types)
        unless @type_rewriting.nil?
          types = types.collect do |type|
            @type_rewriting[type] || type
          end
        end
        unless @kept_types.nil?
          types = types.select {|type| @kept_types.include?(type)}
        end
        types
      end
      
      # Recursively finds all descendant nodes matching the given matcher
      def find(matcher, node=context_node)
        node.collect do |child|
          if matcher===child
            child
          else
            find(matcher, child)
          end
        end.flatten
      end
      
      # Applies on all nodes returned by find(matcher)
      def find_and_apply(matcher)
        sel_apply(find(matcher))
      end
      
      def list(matcher)
        branch() << find_and_apply(matcher)
      end
      
      ### Helpers for  creation ############################################
      
      # Makes a light copy of the context_node (types, semantic value but not
      # children)
      def light_copy
        types = rewrite_types(context_node.semantic_types)
        copy = case context_node
          when Anagram::Ast::Branch
            Anagram::Ast::Branch.new(*types)
          when Anagram::Ast::Leaf
            Anagram::Ast::Leaf.new(context_node.semantic_value, *types)
          else
            raise "Unexpected context_node #{context_node.inspect}"
        end
        
        # TODO: remove this ugly hack
        key = context_node.key_in_parent
        copy.instance_eval %Q{self.key_in_parent = :'#{key}'} unless key.nil?
        
        copy
      end
      
      # Copies the context_node, applying type rewriting. Recurse on
      # children denoted by _args_.
      def copy(*args)
        copy = light_copy
        yield copy if block_given?
        args.each do |arg|
          case arg
            when Integer
              child = context_node.select(arg)
              key = child.key_in_parent
              copy << [key, apply(child)]
            when Symbol
              child, key = context_node.select(arg), arg
              copy << [key, apply(child)]
            when Node  
              child, key = arg, nil # arg.key_in_parent
              copy << [key, apply(child)]
            else
              copy << apply(arg)
          end
        end
        copy
      end
      
      # Copies the context_node and recurse on all children.
      def copy_all
        copy = light_copy
        context_node.children.each do |child|
          key, child_copy = child.key_in_parent, apply(child)
          unless child_copy.nil?
            copy << [key, child_copy]
          end
        end
        copy
      end
      
      # Converts context_node to a leaf node (keeping its original type)
      # with the given semantic value.
      def as_leaf(semvalue)
        types = rewrite_types(context_node.semantic_types)
        Anagram::Ast::Leaf.new(semvalue, *types)
      end
      
    end
  end
end