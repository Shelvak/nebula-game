require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::NpcInfantryFactory do
  before(:each) do
    @player = Factory.create(:player)
    @planet = Factory.create(:planet, :player => @player)
    @model = Factory.create(:b_npc_infantry_factory, :planet => @planet)
  end

  it_behaves_like "npc special factory"
end