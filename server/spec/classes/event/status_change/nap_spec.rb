require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper.rb')
)

describe Event::StatusChange::Nap do
  before(:each) do
    @object = Event::StatusChange::Nap.new
  end
end