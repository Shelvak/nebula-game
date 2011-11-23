require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper.rb')
)

describe Event::FowChange::SsDestroyed do
  before(:each) do
    @object = Event::FowChange::SsDestroyed.new
  end
end