module Anagram
  module Ast
    
    # Defines an internal node inside an AST. See Anagram::Ast for a detailed 
    # description.
    class Branch < Node
      
      ### Construction API ####################################################
      
      # Creates an empty Branch node and extend it with the given types.
      def initialize(*types)
        super(types)
        @children = []
        @child_keys = {}
      end
      

      ### Query API ###########################################################
      
      # Returns false
      def leaf?() false; end

      # Returns true
      def branch?() true; end
      
      # Returns self
      def semantic_value
        self
      end
      
      # Recursively collects semantic values of descendant leaf nodes.
      def semantic_values
        self.collect {|child| child.semantic_values}.flatten
      end
      
      # Checks if a given child exists under _key_
      def has_child?(key)
        @child_keys.has_key?(key)
      end
      
      # Yields block on each child of this node
      def each
        return nil unless block_given?
        @children.each {|child| yield child}
      end
      
      # Returns an array with child keys, without nil but in order of 
      # appearance in children collection.
      def child_keys
        @children.collect {|child| child.key_in_parent}.compact
      end
      
      # Returns the children array. The real children data-structure is returned
      # without being duplicated but is not intended to be modified.
      def children
        @children
      end
      
      # Executes a selection query. See the 'Selecting AST nodes' section in 
      # Anagram::Ast
      def select(*args)
        if args.length==1
          collected = case arg=args[0]
            when NilClass
              nil
            when Integer
              return @children[arg]
            when Symbol
              return has_child?(arg) ? @children[@child_keys[arg]] : nil
            when Range
              return [@children[arg]].flatten.compact
            when Module
              return @children.select {|child| arg===child}
          end
        end
        Selection[self].select(*args).to_a
      end
           
      ### Write API ###########################################################
         
      # Bulk set children   
      def children=(children)
        @children, @child_keys = children, {}
        @children.each_with_index do |child,i|
          key = child.key_in_parent
          child.attach(self, key)
          @child_keys[key] = i unless key.nil?
        end
      end
            
      #
      # Pushes _child_ as last element in the children array. Associates it with 
      # _key_ in the Hash-like structure. Returns self. 
      #
      # This method expects _key_ to be a Symbol (or nil) and _child_ to be an 
      # Node (branch or leaf) and checks its arguments.
      #
      def add_child(key, child)
        raise ArgumentError, "Symbol expected for key, #{key.inspect} received." unless key.nil? or Symbol===key 
        raise ArgumentError, "Node expected for child, #{child.inspect} received." unless Node===child
        unless key.nil?
          # add or replace a named child
          if @child_keys.has_key?(key)
            index = @child_keys[key]
            @children[index].detach
            @children[index] = child
          else
            @child_keys[key] = @children.length
            @children << child
          end
        else
          # add an unnamed child
          @children << child
        end
        child.attach(self, key)
        self
      end
      
      #
      # Pushes children in this node and returns self. This method is an helper to produce 
      # AST easily, but comes with some complexity with respect to its  arguments.
      #
      # The following _arg_ 'matching' are performed, in this order (the first one wins):
      #   [Symbol, Node]     -> add_child(arg[0], arg[1])
      #   [Symbol, Object]   -> add_child(arg[0], Leaf.new(arg[1]))
      #   Node               -> add_child(arg.key_in_parent, arg)
      #   Array              -> recurse on each element
      #   Object             -> add_child(nil, Leaf.new(arg))
      #
      # See also Anagram::Ast::Helper for user-friendly ways of creating ASTs.
      #
      def <<(arg)
        if seems_key_node?(arg)
          key, child = arg
          child = Leaf.new(child) unless Node===child
        elsif Node===arg
          key, child = nil, arg #arg.key_in_parent, arg
        elsif Array===arg
          arg.each {|elm| self.<<(elm)}
          return self
        else
          key, child = :unnamed, arg
        end
        add_child(key, child)
      end
      
      protected
      # Checks if some argument look like a (key, node) pair that can be 
      # transformed to a child node (leaf or branch according to node type).
      def seems_key_node?(arg)
        Array===arg and arg.length==2 and (Symbol===arg[0] or arg[0].nil?)
      end
      
      ### Debug API ###########################################################
      public
      
      # Debugs this node on an output buffer
      def debug(buffer="", show_source=false, indent=0)
        if key_in_parent.nil?
          buffer << "  "*indent << "Branch("
        else
          buffer << "  "*indent << ":#{key_in_parent} => Branch("
        end
        buffer << (show_source ? source_interval.to_s : semantic_types.join(', '))
        buffer << ")"
        unless self.children.empty?
          buffer << "[\n"
          self.each do |child|
            child.debug(buffer, show_source, indent+1)
          end
          buffer << "  "*indent << "]\n"
        else
          buffer << "[]\n"
        end
        buffer
      end
      
    end # class Branch
    
  end
end