require 'test/unit'
require 'anagram/rewriting/rewriter'

class RewriterMethodsTest < Test::Unit::TestCase
  include Anagram::Rewriting::Rewriter::RewriterMethods
  
  module Common
    module Common1; end
    module Common2; end
  end
  module From
    include Common
    module From1; end
    module From2; end
  end
  module To
    include Common
    module To3; end
  end
  
  # Tests extraction of a module name
  def test_extract_module_name
    assert_equal(:RewriterMethods, extract_module_name(Anagram::Rewriting::Rewriter::RewriterMethods, true))
    assert_equal("RewriterMethods", extract_module_name(Anagram::Rewriting::Rewriter::RewriterMethods, false))
    assert_equal(:Rewriting, extract_module_name(Anagram::Rewriting, true))
    assert_equal("Rewriting", extract_module_name(Anagram::Rewriting, false))
    assert_equal(:Anagram, extract_module_name(Anagram, true))
    assert_equal("Anagram", extract_module_name(Anagram, false))
  end
  
  # Tests check of constant knowing
  def test_const_known_by
    assert_equal true,  const_known_by?(:Common1, Common)
    assert_equal false, const_known_by?(:From1, Common)
    assert_equal true,  const_known_by?(:Common1, From)
  end
  
  # Tests rewriting of a single type
  def test_rewrite_type
    rules = {From => To, From::From1 => To::To3}
    assert_equal(To, rewrite_type(From, rules))
    assert_equal(To::Common1, rewrite_type(From::Common1, rules))
    assert_equal(To::To3, rewrite_type(From::From1, rules))
    assert_equal(nil, rewrite_type(From::From2, rules))
  end
  
end