require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module Lit; end
module Plus; end
module Times; end

class Module
  
  def instance_method_or_nil(meth)
    begin
      instance_method(meth)
    rescue
      nil
    end
  end
  
end

module EngineDSLSpec
  
  describe "The engine DSL" do
    include Anagram::Ast::Helper
    attr_reader :ast, :engine, :intrusion
    before do
      # expression is 12*(17+3)
      @ast = branch(Times) do |n|
        n.left = leaf(12, Lit)
        n.right = branch(Plus) do |n2|
          n2.left = leaf(17, Lit)
          n2.right = leaf(3, Lit)
        end
      end
      @engine = Anagram::Rewriting::Engine.new
      @intrusion = [Module.instance_method_or_nil(:|), Module.instance_method_or_nil(:&)]
    end
    
    it "is not ruby intrusive" do
      Anagram::Rewriting::Engine::DSL.new(engine) do
        template Lit|Plus do |r,n| "found"     end 
        template Lit&Plus do |r,n| "found"     end 
      end
      [Module.instance_method_or_nil(:|), Module.instance_method_or_nil(:&)].should == intrusion
    end
    
    it "accepts or matchers" do
      Anagram::Rewriting::Engine::DSL.new(engine) do
        template Times    do |r,n| r.apply_all end
        template Lit|Plus do |r,n| "found"     end 
      end
      engine.execute(ast).should == ["found", "found"]
    end
    
    it "accepts and matchers" do
      Anagram::Rewriting::Engine::DSL.new(engine) do
        template Times    do |r,n| r.apply_all end
        template Lit&Plus do |r,n| "found"     end 
      end
      engine.execute(ast).should be_nil
    end
    
  end
  
end