require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "PluginClass" do

  it "adds and removes features from class" do
    class TestClass
      include PluginClass
    end
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
    class TestClass2
      include PluginClass
    end
    true.should_not be_instance_of(TestClass2)
    [].should_not be_instance_of(TestClass2)
    {}.should_not be_instance_of(TestClass2)

    TestClass2.new.should be_instance_of(TestClass2)
    PluginClass.extend_class "TestClass2" do
    end
    TestClass2.new.should be_instance_of(TestClass2)
    TestClass2.reset_class
    TestClass2.new.should be_instance_of(TestClass2)
  end

  it "supports is_a" do
    class TestClass3
      include PluginClass
    end
    true.should_not be_is_a(TestClass3)
    [].should_not be_is_a(TestClass3)
    {}.should_not be_is_a(TestClass3)

    TestClass3.new.should be_is_a(TestClass3)
    PluginClass.extend_class "TestClass3" do
    end
    TestClass3.new.should be_is_a(TestClass3)
    TestClass3.reset_class
    TestClass3.new.should be_is_a(TestClass3)
  end

  it "returns the root klasses name" do
    class TestClass4
      include PluginClass
    end
    TestClass4.new.class.name.should == "TestClass4"
    PluginClass.extend_class "PluginClass4" do
    end
    TestClass4.new.class.name.should == "TestClass4"
    TestClass4.reset_class
    TestClass4.new.class.name.should == "TestClass4"
  end

end
