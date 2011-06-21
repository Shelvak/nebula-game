require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe StatusChangeEvent::Nap do
  before(:each) do
    @object = StatusChangeEvent::Nap.new
  end
end