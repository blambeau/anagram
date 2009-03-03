class Module
  
  # Creates a or matcher
  def |(mod)
    Anagram::Rewriting::OrMatcher.new(self,mod)
  end
  
  # Creates a and matcher
  def &(mod)
    Anagram::Rewriting::AndMatcher.new(self,mod)
  end
  
end