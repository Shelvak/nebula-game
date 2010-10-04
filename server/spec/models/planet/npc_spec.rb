require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Planet::Npc do
  it "should include Planet::Unlandable" do
    Planet::Npc.should include(Planet::Unlandable)
  end
end