require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe TasksController do
  include ControllerSpecHelper

  before(:each) do
    init_controller TasksController, :login => true
  end
end