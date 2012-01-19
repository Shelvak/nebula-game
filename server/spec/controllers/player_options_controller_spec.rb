require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe PlayerOptionsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller PlayerOptionsController, :login => true
  end

  describe "player_options|show" do
    before(:each) do
      @action = "player_options|show"
      @params = {}
      @method = :push
    end

    it_should_behave_like "only push"

    it "should respond with player options" do
      push @action, @params
      response_should_include(
        :options => player.options.data.as_json
      )
    end
  end

  describe "player_options|set" do
    before(:each) do
      @opts = player.options.data

      @action = "player_options|set"
      @params = PlayerOptions::Data.properties.each_with_object({}) do
        |property, params|

        params[property.to_s] = property.to_s
        @opts.stub!(:"#{property}=")
      end
    end

    it_should_behave_like "with param options", PlayerOptions::Data.properties

    it "should set options" do
      PlayerOptions::Data.properties.each do |property|
        @opts.should_receive(:"#{property}=").with(@params[property.to_s])
      end

      player.options.should_receive(:save!)
      invoke @action, @params
    end

    describe "when error occurs while setting properties" do
      it "should convert ArgumentError into GameLogicError" do
        property = PlayerOptions::Data.properties.first
        @opts.stub!(:"#{property}=").and_raise(ArgumentError)

        lambda do
          invoke @action, @params
        end.should raise_error(GameLogicError)
      end
    end
  end
end