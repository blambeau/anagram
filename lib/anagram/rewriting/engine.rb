module Anagram
  module Rewriting
    
    #
    # Provides a XSLT-inspired rewriter engine for Abstract Syntax Trees.
    # 
    # See Rewriting for detailed description of this class working. See also
    # Engine::DSL for explanation aboute engine configurations.
    #
    class Engine
      include Anagram::Ast::Helper
      include Anagram::Rewriting::Engine::Methods
      
      # Configuration
      attr_reader :configuration
      
      # Engine state
      attr_reader :state
      
      # Creates an empty rewriter.
      def initialize(configuration=nil, &block)
        configuration = Configuration.new unless configuration
        @configuration = configuration
        unless block.nil?
          @mode = :main
          extend(Engine::DSL)
          self.instance_eval &block
        end
        @state = nil
      end

      ### User-oriented API ###################################################
      
      # Launches the engine on a given _ast_ node. This node is considered as 
      # the first context_node to consider.
      def execute(ast, mode = :main)
        @state = State.new(nil)
        @state.mode = mode
        @state.context_node = ast
        collected = sel_apply([ast])
        @state = nil
        collected.nil? ? nil : collected[0]
      end

      ### Configuration & mode ################################################
      
      # Returns engine current execution mode
      def current_mode
        @state.mode
      end
      
      # Returns current InModeConfig
      def config
        @configuration.get_inmode_config(current_mode)
      end
      
      ### Template-oriented API ###############################################
      
      #
      # Applies templates on a selection in the current engine mode. Returns an
      # array containing all application results (template returned values), 
      # whitout nil.
      #
      # This method does not allow using selection shortcuts and expects a Selection 
      # or an Array of nodes. Please don't use it directly and call apply and its 
      # DRY shortcuts instead.
      #
      def sel_apply(selection)
        raise ArgumentError, "Selection or Array expected, #{selection.inspect} received"\
          unless Array===selection or Selection===selection
        mode = @state.mode
        @state = @state.push(mode)
          collected = selection.collect do |node|
            template = config.find_matching_template(node)
            unless template.nil?
              @state.context_node = node
              template.execute(self, node)
            end
          end.compact
        @state = @state.pop()
        collected
      end

      #
      # Converts apply arguments to a selection on the context_node.
      #
      # This method is provided to help pluggins implementing user-friendly DRY shortcuts
      # of the apply method. It takes varying arguments as input and returns an array
      # with two elements: the first one is the actual node selection, the second is a 
      # boolean indicating if the result must be an array or a single object. Typical
      # usage is the <tt>apply(...)</tt> implementation itself:
      #
      #   # Friendly apply method
      #   def apply(*args)
      #     selection, makeone = to_selection(*args)
      #     collected = sel_apply(selection)
      #     makeone ? (collected.empty? ? nil : collected[0]) : collected
      #   end
      #
      def to_selection(*args)
        if args.length==1
          case arg=args[0]
            when Symbol, Integer
              [[context_node.select(arg)], true]
            when Anagram::Ast::Node
              [[arg], true]
            when Array
              collected = arg.collect {|sub| to_selection(sub)[0]}
              collected = collected.flatten.compact.uniq
              [collected, false]
            when NilClass
              [[nil], true]
            else
              [context_node.select(arg), false]
          end
        else
          collected = args.collect {|arg| to_selection(arg)[0]}
          collected = collected.flatten.compact.uniq
          [collected, false]
        end
      end

      #
      # Friendly apply method. This method lauches templates executions on all
      # nodes denoted by _args_. These varying arguments may be node instances
      # as well as selection patterns (see Anagram::Ast about selection of AST
      # nodes)
      #
      def apply(*args)
        selection, makeone = to_selection(*args)
        collected = sel_apply(selection)
        makeone ? (collected.empty? ? nil : collected[0]) : collected
      end
      
      # Executes the given block in _mode_ instead of current one. The 
      # previous mode is restored after block execution.
      def in_mode(mode)
        @state = @state.push(mode)
          r = block_given? ? yield(self, context_node) : nil
        @state = @state.pop
        r
      end
      
      # Pushes some context objects and yields block
      def with(hash) 
        @state = @state.push(current_mode)
        hash.each_pair {|k,v| @state[k]=v}
        r = block_given? ? yield(self, context_node) : nil
        @state = @state.pop
        r
      end
      
      # Returns the current context node.
      def context_node
        @state.context_node
      end
      
    end # class Engine
  
  end
end