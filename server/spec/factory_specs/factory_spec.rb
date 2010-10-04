require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Factory" do
  it "should create building where resources entry is bound to same planet" do
    model = Factory.create :building
    model.planet.resources_entry.planet.should == model.planet
  end

  it "should create planet with player where galaxy == player.galaxy" do
    model = Factory.create :planet_with_player
    model.player.galaxy.should == model.galaxy
  end
end