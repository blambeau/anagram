module Anagram
  module Ast
    
    #
    # Defines an Abstract Syntaxic/Semantic Tree Node.
    #
    # This class has two specializations: Branch and Leaf, with the obvious meaning 
    # with respect to a tree data-structure. Both use exactly the same API, but may 
    # differ in their behavior. See their respective API for details.
    #
    # See Ast for a description of this class usage.
    #
    class Node
      include Enumerable
      
      # Parent node, or nil if this one is the root.
      attr_reader :parent
      
      # Semantic key of this node in his parent.
      attr_reader :key_in_parent
      
      # Semantic modules that extend this node.
      attr_reader :semantic_types
      
      # SourceInterval instance when source tracking is used.
      attr_accessor :source_interval

      ### Construction API ####################################################

      # Creates a node instance and extend it with modules given by _types_
      # (expected to be an Array).
      def initialize(types)
        raise ArgumentError if types.any? {|type| type.nil?}
        @parent, @key_in_parent = nil, nil
        @semantic_types = types
        @source_interval = nil
        types.each do |type|
          self.extend(type) if Module===type
        end
      end
      
      # Extends with a semantic type
      def add_semantic_types(*mods)
        raise ArgumentError if mods.any? {|mod| mod.nil?}
        mods.each do |mod|
          self.extend(mod) if Module===mod
          @semantic_types << mod
        end
      end
      
      # Let the node know under which key it is installed in his parent.
      # This method is not expected to be used by users.
      def key_in_parent=(key)
        @key_in_parent = key
      end
      
      ### Write API ###########################################################
      protected
      
      # Provides the friendly syntax for selecting and creating children.
      def method_missing(name, *args)
        if (/=$/ =~ name.to_s and args.length==1)
          name = name.to_s[0..-2].to_sym
          self << [name, args[0]]
          self.select(name)
        elsif args.empty?
          self.select(name)
        else
          super(name, *args)
        end
      end
      
      # Callback when this node is attached in a parent. This method is not 
      # expected to be used by users.
      def attach(parent, key)
        raise ArgumentError, "Parent must be an Node, #{parent.inspect}" unless Node===parent
        raise ArgumentError, "Symbol expected as node key, #{key.inspect} received" unless key.nil? or Symbol===key
        detach unless @parent.nil?
        @parent, @key_in_parent = parent, key
      end
      
      # Forces the node to detach from its parent. This method is not 
      # expected to be used by users.
      def detach
        @parent, @key_in_parent = nil
      end
      
      ### Debug API ###########################################################
      public
      
      # Inspect this node
      def inspect
        self.debug("")
      end

      ### Source API ##########################################################
      
      # Returns start offset in source
      def start_index 
        @start_index ||= @source_interval.start_index
      end

      # Returns stop offset in source
      def stop_index 
        @stop_index ||= @source_interval.stop_index
      end

      # Returns the complete source text that led to this node creation.
      #
      # This method exists for backward compatibility with older versions of 
      # Treetop. Use source_interval.source instead.
      def input
        @source_interval.source
      end
      
      # Delegated to source_interval if any; returns "" otherwise. 
      #
      # This method exists for backward compatibility with older versions of 
      # Treetop. Use source_interval.source instead.
      def text_value
        @source_interval.nil? ? "" : @source_interval.text_value
      end
      
      ### Backward-compatibility API ##########################################
      
      # Delegated to source_interval if any; returns nil otherwise.
      #
      # This method exists for backward compatibility with older versions of 
      # Treetop. Use source_interval.source instead.
      def empty?
        @source_interval.nil? ? nil : @source_interval.empty?
      end
      
      # Alias for semantic_types. 
      #
      # This method exists for backward compatibility with older versions of 
      # Treetop. Use source_interval.source instead.
      def extension_modules
        semantic_types
      end
      
    end # class Node
        
  end
end