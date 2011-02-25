require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::NpcSpaceFactory do
  before(:each) do
    @player = Factory.create(:player)
    @planet = Factory.create(:planet, :player => @player)
    @model = Factory.create(:b_npc_space_factory, :planet => @planet)
  end

  it_should_behave_like "npc special factory"
end