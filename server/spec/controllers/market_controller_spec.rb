require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe MarketController do
  include ControllerSpecHelper

  before(:each) do
    init_controller MarketController, :login => true
  end
end