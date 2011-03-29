require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe ChatController do
  include ControllerSpecHelper

  before(:each) do
    init_controller ChatController, :login => true
  end
end