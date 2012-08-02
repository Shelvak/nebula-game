require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe DispatcherEventHandler::Buffer do
  let(:dispatcher) { Celluloid::Actor[:dispatcher] }
  let(:handler) { DispatcherEventHandler::Buffer.instance }

  it "should proxy all calls to dispatcher" do
    dispatcher.should_receive(:foo).with(:bar, :baz)
    handler.foo(:bar, :baz)
  end

  it "should proxy #push_to_player calls to dispatcher if not wrapped" do
    dispatcher.should_receive(:push_to_player).with(:bar, :baz)
    handler.push_to_player(:bar, :baz)
  end

  it "should proxy #push_to_player! calls to dispatcher if not wrapped" do
    dispatcher.should_receive(:push_to_player!).with(:bar, :baz)
    handler.push_to_player!(:bar, :baz)
  end

  describe "#wrap" do
    it "should allow other methods to go through" do
      handler.wrap do
        dispatcher.should_receive(:foo).with(:bar, :baz)
        handler.foo(:bar, :baz)
      end
    end

    it "should buffer #push_to_player inside while wrapped" do
      mock_actor(:dispatcher, Dispatcher) do |dispatcher|
        counter = 0
        dispatcher.stub(:push_to_player!).and_return do |*args|
          counter += 1
        end
        handler.wrap do
          handler.push_to_player!(:foo)
          counter.should == 0
        end
      end
    end

    it "should call dispatcher with buffered items when all is ok" do
      mock_actor(:dispatcher, Dispatcher) do |dispatcher|
        counter = 0
        dispatcher.stub(:push_to_player!).and_return do |*args|
          counter += 1
        end
        handler.wrap do
          handler.push_to_player!(:foo)
          handler.push_to_player!(:bar)
        end
        counter.should == 2
      end
    end

    it "should discard items if we have some exception" do
      mock_actor(:dispatcher, Dispatcher) do |dispatcher|
        counter = 0
        dispatcher.stub(:push_to_player!).and_return do |*args|
          counter += 1
        end
        begin
          handler.wrap do
            handler.push_to_player!(:foo)
            handler.push_to_player!(:bar)
            raise "bad exception"
          end
        rescue; nil; end
        counter.should == 0
      end
    end

    it "should support nested wrapping" do
      mock_actor(:dispatcher, Dispatcher) do |dispatcher|
        counter = 0
        dispatcher.stub(:push_to_player!).and_return do |*args|
          counter += 1
        end
        handler.wrap do
          handler.push_to_player!(:foo)
          handler.wrap do
            handler.push_to_player!(:bar)
          end
          counter.should == 0
        end
        counter.should == 2
      end
    end
  end
end

