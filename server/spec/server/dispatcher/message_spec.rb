require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Dispatcher::Message do
  let(:client) { ServerActor::Client.new("localhost", 12345) }

  def message(options={})
    options.reverse_merge!(
      :id => "123",
      :seq => nil,
      :action => "foo#{Dispatcher::Message::SPLITTER}bar",
      :params => {"lol" => "foo"},
      :client => client,
      :player => nil,
      :pushed => false
    )

    Dispatcher::Message.new(
      options[:id], options[:seq], options[:action], options[:params],
      options[:client], options[:player], options[:pushed]
    )
  end

  describe "#initialize" do
    it "should work" do
      message
    end

    it "should fail if action is nil" do
      lambda do
        message(:action => nil)
      end.should raise_error(Dispatcher::UnhandledMessage)
    end

    it "should fail if action does not have a splitter" do
      lambda do
        message(:action => "foo")
      end.should raise_error(Dispatcher::UnhandledMessage)
    end

    it "should return empty hash instead of params if they are not provided" do
      message(:params => nil).params.should == {}
    end

    it "should freeze params hash" do
      message.params.should be_frozen
    end
  end

  describe "#full_action" do
    it "should return passed action" do
      action = "some#{Dispatcher::Message::SPLITTER}task"
      message(:action => action).full_action.should == action
    end
  end
end

