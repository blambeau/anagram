module Anagram
  module Rewriting
    class Rewriter
      
      # Contributions to the engine
      module RewriterMethods
        
        ### To be moved in ModuleUtils ########################################
        
        # Extracts the short name of a module
        def extract_module_name(mod, assym=true)
          name = mod.name
          name = $1 if /.*::([a-zA-Z0-9_]+)$/ =~ name
          name = name.to_sym if assym
          name
        end
        
        # Checks if a constant is known by a module
        def const_known_by?(const, mod)
          return true if mod.const_defined?(const)
          true if mod.const_get(const)
        rescue
          false
        end
        
        ### To be moved in SelectionUtils #####################################
        
        # Recursively finds all descendant nodes matching the given matcher
        def descendant(matcher, stoponfound=true, node=context_node)          
          node.collect do |child|
            ds = []
            if matcher===child
              ds << child 
              ds << descendant(matcher, stoponfound, child) unless stoponfound
            else
              ds << descendant(matcher, stoponfound, child)
            end
            ds
          end.flatten
        end
      
        ### Type rewriting ####################################################
        
        # Rewrites a given node type giving rule
        def rewrite_type(type, rules)
          if rules.has_key?(type)
            rules[type]
          else
            rules.each_pair do |from, to|
              sym = extract_module_name(type, true)
              if const_known_by?(sym, from) and const_known_by?(sym, to)
                return to.const_get(sym)
              end
            end
            nil
          end
        end
        
        # Rewrites some node types using rewriting rewriting rules
        def rewrite_node_types(node=context_node)
          types = node.semantic_types
          rules = config[Rewriter].type_rewrite
          unless rules.nil?
            types = types.collect {|type| rewrite_type(type, rules)}.compact
          end
          types
        end
      
        ### Node copy #########################################################
        
        # Makes a light copy of a node (types, semantic value but not children)
        def light_copy(node=context_node)
          types = rewrite_node_types(node)
          copy = case node
            when Anagram::Ast::Branch
              Anagram::Ast::Branch.new(*types)
            when Anagram::Ast::Leaf
              Anagram::Ast::Leaf.new(node.semantic_value, *types)
            else
              raise "Unexpected node #{node.inspect}"
          end
          # TODO: remove this ugly hack
          key = node.key_in_parent
          copy.instance_eval %Q{self.key_in_parent = :'#{key}'} unless key.nil?
          copy
        end
      
        # Copies a node and recurse on all children.
        def copy_all(node=context_node)
          copy = light_copy(node)
          yield copy if block_given?
          node.children.each do |child|
            key, child_copy = child.key_in_parent, apply(child)
            unless child_copy.nil?
              copy << [key, child_copy]
            end
          end
          copy
        end
      
        # Copies the context_node, applying type rewriting. Recurse on
        # children denoted by _args_.
        def copy(*args)
          node = context_node
          copy = light_copy(node)
          yield copy if block_given?
          args.each do |arg|
            case arg
              when Integer
                child = node.select(arg)
                key = child.key_in_parent
                copy << [key, apply(child)]
              when Symbol
                child, key = node.select(arg), arg
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
      
      
        # Converts context_node to a leaf node (applying type rewriting)
        # with the given semantic value.
        def as_leaf(semvalue)
          types = rewrite_node_types(context_node)
          Anagram::Ast::Leaf.new(semvalue, *types)
        end
        
      end # module RewriterMethods
      
      # Allows creating a rewriter inline instead of subclassing
      def self.new(&block)
        c = Class.new(Rewriter)
        c.module_eval(&block) unless block.nil?
        c
      end
      
      # Installs an empty configuration on subclass
      def self.inherited(c)
        c.instance_eval do
          @config = Anagram::Rewriting::Engine::Configuration.new
        end
      end
      
      # Installs type rewriting rules
      def self.type_rewrite(hash)
        @config[Rewriter].type_rewrite = hash
        hash.each_key {|from| include(from)}
      end
      
      # Lauches a configuration
      def self.configuration(&block)
        dsl = Anagram::Rewriting::Engine::DSL.new(@config)
        dsl.execute_dsl(&block)
      end
      
      # Execution
      def self.<<(input)
        engine = Anagram::Rewriting::Engine.new(@config)
        engine.extend(Anagram::Rewriting::Syntax2Semantics)
        engine.extend(RewriterMethods)
        engine.execute(input)
      end
      
    end
  end
end