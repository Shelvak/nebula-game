require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe SsObject do
  describe "#observer_player_ids" do
    Factory.create(:ss_object).observer_player_ids.should == []
  end

  describe "galaxy delegation" do
    it "should delegate galaxy" do
      model = Factory.create :planet
      model.galaxy.should == model.solar_system.galaxy
    end

    it "should delegate galaxy_id" do
      model = Factory.create :planet
      model.galaxy_id.should == model.solar_system.galaxy_id
    end
  end

  describe "#route_attrs" do
    it "should return Hash" do
      position = 2
      angle = 90
      planet = Factory.create(:planet, :position => position,
        :angle => angle)
      planet.route_attrs.should == {
        :id => planet.id,
        :type => Location::SS_OBJECT,
        :x => planet.position,
        :y => planet.angle
      }
    end
  end

  describe "#client_location" do
    it "should return ClientLocation" do
      position = 2
      angle = 90
      planet = Factory.create(:planet, :position => position,
        :angle => angle)
      planet.client_location.should == ClientLocation.new(planet.id,
        Location::SS_OBJECT, position, angle, planet.name, planet.terrain,
        planet.solar_system_id)
    end
  end

  describe ".find_for_player!" do
    it "should raise ActiveRecord::RecordNotFound if not found" do
      planet = Factory.create :planet
      lambda do
        SsObject.find_for_player!(planet.id, 0)
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should return Planet if found" do
      planet = Factory.create :planet
      SsObject.find_for_player!(planet.id, planet.player_id).should == planet
    end
  end

  describe "#as_json" do
    before(:all) do
      @model = Factory.create(:ss_object)
    end

    @required_fields = %w{id solar_system_id position angle type
      size}
    @ommited_fields = %w{width height metal metal_rate metal_storage
      energy energy_rate energy_storage
      zetium zetium_rate zetium_storage
      last_resources_update energy_diminish_registered}
    it_should_behave_like "to json"
  end

#  describe "resources entry" do
#    it "should create one for planet" do
#      Factory.create(:planet).resources_entry.should_not be_nil
#    end
#
#    it "should set `last_update` if assigned a player and last_update IS NULL" do
#      model = Factory.create(:planet)
#      re = model.resources_entry
#      re.last_update = nil
#      re.save!
#
#      model.player = Factory.create(:player)
#      model.save!
#      re.reload
#      re.last_update.drop_usec.should == Time.now.drop_usec
#    end
#  end

  it "should not allow creating two planets in same position in same SS" do
    planet = Factory.create :planet, :position => 3, :angle => 0
    lambda do
      Factory.create(:planet, :position => planet.position, :angle => 0,
        :solar_system => planet.solar_system)
    end.should raise_error(ActiveRecord::RecordNotUnique)
  end

  describe "#unassigned?" do
    it "should return true if player_id.nil?" do
      SsObject.new(:player_id => nil).unassigned?.should be_true
    end
    
    it "should return false if it has player_id" do
      SsObject.new(:player_id => 1).unassigned?.should be_false
    end
  end
end