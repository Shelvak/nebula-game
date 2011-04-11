require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe AlliancesController do
  include ControllerSpecHelper

  before(:each) do
    init_controller AlliancesController, :login => true
  end
end