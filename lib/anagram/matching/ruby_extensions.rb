class Module
  
  # Factors a TypeMatcher instance and delegates
  def [](*args)
    Anagram::Matching::TypeMatcher.new(self)[*args]
  end
  
  # Factors a TypeMatcher instance and delegates
  def |(arg)
    Anagram::Matching::TypeMatcher.new(self)|arg
  end

  # Factors a TypeMatcher instance and delegates
  def &(arg)
    Anagram::Matching::TypeMatcher.new(self)&arg
  end

  # Factors a NotMatcher(TypeMatcher(self)) instance 
  def not
    Anagram::Matching::NotMatcher.new(self)
  end

end