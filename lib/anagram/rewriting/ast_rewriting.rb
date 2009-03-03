module Anagram
  module Rewriting
    
    # 
    # Engine pluggin providing tools to rewrite ASTs.
    #
    module AstRewriting

      # Extensions to the engine DSL
      module DSLExtensions
        
        # Consider only types when applying type rewriting.
        def keep_types(*types)
          types = types[0] if (types.length==1 and Array===types)
          engine.add_instance_variable(:@kept_types, types)
        end
      
        # Uses the following type correspondance Hash when applying type rewriting.
        def type_rewrite(hash)
          engine.add_instance_variable(:@type_rewriting, hash)
        end
      
      end


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
              child, key = arg, arg.key_in_parent
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