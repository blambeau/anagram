require 'rubygems'
require 'wlang'

module WLang
  class RuleSet
    module AnagramRuleSet
      U = WLang::RuleSet::Utils
      SU = Object.new; SU.extend(Anagram::Utils::StringUtils) 
  
      # Default mapping between tag symbols and methods
      DEFAULT_RULESET = {'=~' => :definition, '$' => :semantic_value, '+~' => :match_inclusion}
  
      # Rule implementation of <tt>=~{wlang/ruby}</tt>.
      def self.definition(parser, offset)
        expression, reached = parser.parse(offset, "wlang/ruby")
        value = parser.evaluate(expression)
        template, reached = parser.parse_block(reached, "wlang/dummy")
        template = template.strip_block(template)
        template = template.tabto(template, 0)
        template = template[0..-2]
        parser.evaluate("matching_rules") << [value, template]
        ["", reached]
      end
  
      # Rule implementation of <tt>${wlang/ruby}</tt>.
      def self.semantic_value(parser, offset)
        expression, reached = parser.parse(offset, "wlang/ruby")
        value = parser.evaluate(expression)
        value = value.semantic_value if value.respond_to?(:semantic_value)
        value = value.nil? ? "" : value.to_s
        [value, reached]
      end
      
      # Rule implementation of <tt>+~{wlang/ruby}</tt>.
      def self.match_inclusion(parser, offset)
        expression, reached = parser.parse(offset, "wlang/ruby")
        
        # decode expression
        decoded = U.expr(:expr, 
                         ["with",  :with, false]).decode(expression, parser)
        parser.syntax_error(offset) if decoded.nil?
        value, with = decoded[:expr], decoded[:with]

        rules = parser.evaluate("matching_rules")
        rules.each do |rule|
          next unless rule[0]===value
          template = rule[1]
          
          # build context
          context = U.context_from_using_and_with(decoded)
          context["n"] = value
          context["matching_rules"] = rules
    
          # instanciate
          instantiated = WLang::instantiate(template, context, "anagram")
          #indent = SU.column_of(parser.buffer.length-1, parser.buffer)
          #instantiated = SU.tabto(indent, instantiated).strip
          return [instantiated, reached]
        end
        
        ["", reached]
      end
      
    end
  end
end

WLang::dialect("anagram") do
  rules WLang::RuleSet::Basic
  rules WLang::RuleSet::Encoding
  rules WLang::RuleSet::Imperative
  rules WLang::RuleSet::Buffering
  rules WLang::RuleSet::Context
  rules WLang::RuleSet::AnagramRuleSet
end
