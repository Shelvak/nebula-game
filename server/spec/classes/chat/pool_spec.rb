require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Chat::Pool do
  before(:each) do
    @object = Chat::Pool.new
  end
end