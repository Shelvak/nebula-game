require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe DispatcherEventHandler::Handler do
  describe ".handle" do
    dispatcher = :dispatcher
    reason = :reason
    test_class1 = Class.new
    test_class2 = Class.new(test_class1)
    test_class3 = Class.new

    invokes = {}

    tester = lambda do |klass|
      lambda do |d, objects, r|
        [d, r].should == [dispatcher, reason]
        objects.each do |obj|
          obj.class.should == klass
          invokes[klass] ||= []
          invokes[klass] << obj
        end
      end
    end

    handler_methods = Module.new do
      define_method(:resolvers) do
        [
          [test_class2, tester[test_class2]],
          [test_class1, tester[test_class1]],
        ]
      end
      protected :resolvers
    end
    handler = Class.new(DispatcherEventHandler::Handler).extend(handler_methods)

    it "should invoke objects in specified order" do
      invokes.clear
      objects = [test_class1.new, test_class2.new, test_class1.new]

      handler.handle(dispatcher, objects, reason)

      invokes.should equal_to_hash(
        test_class1 => [objects[0], objects[2]],
        test_class2 => [objects[1]]
      )
    end

    it "should fail if handler does not know how to handle object" do
      lambda do
        handler.handle(dispatcher, [test_class3.new], reason)
      end.should raise_error(ArgumentError)
    end

    it "should not fail if given single object" do
      handler.handle(dispatcher, test_class1.new, reason)
    end
  end
end

