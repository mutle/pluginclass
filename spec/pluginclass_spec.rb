require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class TestClass
  extend PluginClass
end

describe "PluginClass" do

  it "adds and removes features from class" do
    TestClass.new.should_not respond_to(:foo)

    PluginClass.extend_class "TestClass" do
      def foo
        "foo"
      end
    end
    TestClass.new.should respond_to(:foo)

    TestClass.reset_class
    TestClass.new.should_not respond_to(:foo)
  end

  it "supports instance_of" do
    true.should_not be_instance_of(TestClass)
    [].should_not be_instance_of(TestClass)
    {}.should_not be_instance_of(TestClass)

    TestClass.new.should be_instance_of(TestClass)
    PluginClass.extend_class "TestClass" do
    end
    TestClass.new.should be_instance_of(TestClass)
    TestClass.reset_class
    TestClass.new.should be_instance_of(TestClass)
  end

  it "supports is_a" do
    true.should_not be_is_a(TestClass)
    [].should_not be_is_a(TestClass)
    {}.should_not be_is_a(TestClass)

    TestClass.new.should be_is_a(TestClass)
    PluginClass.extend_class "TestClass" do
    end
    TestClass.new.should be_is_a(TestClass)
    TestClass.reset_class
    TestClass.new.should be_is_a(TestClass)
  end

  it "returns the root klasses name" do
    TestClass.new.class.name.should == "TestClass"
    PluginClass.extend_class "TestClass" do
    end
    TestClass.new.class.name.should == "TestClass"
    TestClass.reset_class
    TestClass.new.class.name.should == "TestClass"
  end

end
