require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

describe Anagram::Rewriting::DSLHelper do
  
  it "correctly handle non intrusive extensions" do
    # try it before
    lambda {"".say_hello_to_blambeau}.should raise_error(NoMethodError)
    
    # install DSL
    helper = Anagram::Rewriting::DSLHelper.new(String => [:say_hello_to_blambeau]) 
      helper.save
      load File.join(File.dirname(__FILE__), 'ruby_extensions1.rb')
      "".say_hello_to_blambeau.should == "hello blambeau"
    helper.restore
    
    # check after
    lambda {"".say_hello_to_blambeau}.should raise_error(NoMethodError)
  end
  
  it "correctly handle intrusive extensions" do
    # try it before
    "HELLO".downcase.should == "hello"
    "hello".upcase.should == "HELLO"
    
    # install DSL
    helper = Anagram::Rewriting::DSLHelper.new(String => [:upcase, :downcase])
      helper.save
      load File.join(File.dirname(__FILE__), 'ruby_extensions2.rb')
      
      "HELLO".downcase.should be_nil
      "hello".upcase.should be_nil
      
    helper.restore
  
    # check after
    "HELLO".downcase.should == "hello"
    "hello".upcase.should == "HELLO"
  end
  
  it "provides a correct block shortcut" do
    # try it before
    "HELLO".downcase.should == "hello"
    "hello".upcase.should == "HELLO"
    
    # install DSL
    helper = Anagram::Rewriting::DSLHelper.new(String => [:upcase, :downcase]) do
      load File.join(File.dirname(__FILE__), 'ruby_extensions2.rb')
      "HELLO".downcase.should be_nil
      "hello".upcase.should be_nil
    end
  
    # check after
    "HELLO".downcase.should == "hello"
    "hello".upcase.should == "HELLO"
  end
  
end
