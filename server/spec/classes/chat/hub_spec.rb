require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Chat::Hub do
  before(:each) do
    @hub = Chat::Hub.new
  end

  describe "#join" do
    it "should create a channel if it does not exist" do
      chan = Chat::Channel.new("c")
      Chat::Channel.should_receive(:new).with("c").and_return(chan)
      @hub.join(1, "c")
    end

    it "should store key" do

    end
  end
end