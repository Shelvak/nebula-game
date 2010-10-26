require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe SolarSystem do
  describe "#to_json" do
    before(:all) do
      @model = Factory.create(:ss_homeworld)
    end

    @ommited_fields = %w{type}
    it_should_behave_like "to json"
  end

  describe "jumpgates" do    
    before(:all) do
      @ss = Factory.create(:solar_system)
      @gates = [
        Factory.create(:p_jumpgate, :solar_system => @ss, :position => 7),
        Factory.create(:p_jumpgate, :solar_system => @ss, :position => 1),
        Factory.create(:p_jumpgate, :solar_system => @ss, :position => 4)
      ]
      Factory.create(:planet, :solar_system => @ss, :position => 5)
      Factory.create(:planet, :solar_system => @ss, :position => 2)
    end
    
    describe ".rand_jumpgate" do
      it "should return Planet::Jumpgate" do
        SolarSystem.rand_jumpgate(@ss.id).should be_instance_of(
          SsObject::Jumpgate)
      end

      it "should select one of the existing jumpgates" do
        @gates.should include(SolarSystem.rand_jumpgate(@ss.id))
      end
    end

    describe ".closest_jumpgate" do
      [
        [3, 0, 2],
        [10, 0, 0],
        [10, 180, 1]
      ].each do |position, angle, gate_index|
        it "should return closest jumpgate (#{position}, #{angle})" do
          SolarSystem.closest_jumpgate(
            @ss.id, position, angle
          ).should == @gates[gate_index]
        end
      end
    end
  end

  describe "#orbit_count" do
    it "should return max planet position + 1" do
      @ss = Factory.create(:solar_system)
      Factory.create(:planet, :solar_system => @ss, :position => 7)
      @ss.orbit_count.should == 8
    end
  end

  it "should not allow two systems in same place" do
    model = Factory.create :ss_homeworld
    Factory.build(:ss_homeworld, :galaxy => model.galaxy, :x => model.x,
      :y => model.y).should_not be_valid
  end

  describe "visibility methods" do
    describe ".single_visible_for" do
      before(:all) do
        @alliance = Factory.create :alliance
        @player = Factory.create :player, :alliance => @alliance
      end

      it "should return SolarSystem if it's visible (player)" do
        ss = Factory.create :solar_system, :galaxy => @player.galaxy
        Factory.create :fse_player, :player => @player, :solar_system => ss
        SolarSystem.single_visible_for(ss.id, @player)[0].should == ss
      end

      it "should return SolarSystem if it's visible (alliance)" do
        ss = Factory.create :solar_system, :galaxy => @player.galaxy
        Factory.create :fse_alliance, :alliance => @alliance,
          :solar_system => ss
        SolarSystem.single_visible_for(ss.id, @player)[0].should == ss
      end

      it "should return metadata along with it" do
        ss = Factory.create :solar_system, :galaxy => @player.galaxy
        fse = Factory.create :fse_player, :player => @player,
          :solar_system => ss

        SolarSystem.single_visible_for(
          ss.id, @player
        )[1].should == FowSsEntry.merge_metadata(fse, nil)
      end

      it "should raise ActiveRecord::RecordNotFound if SolarSystem " +
      "exists but is not visible" do
        ss = Factory.create :solar_system, :galaxy => @player.galaxy
        lambda do
          SolarSystem.single_visible_for(ss.id, @player)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe ".visible_for" do
      before(:each) do
        @player = Factory.create :player
      end

      it "should return solar systems visible for player in galaxy" do
        fse1 = Factory.create :fse_player, :player => @player
        fse2 = Factory.create :fse_player, :player => @player
        # Invisible SS
        Factory.create :solar_system

        SolarSystem.visible_for(@player).map do |e|
          e[:solar_system].id
        end.sort.should == [fse1.solar_system_id, fse2.solar_system_id].sort
      end

      it "should return metadata for ss'es visible for player in galaxy" do
        @player.alliance = Factory.create :alliance
        @player.save!

        fse1_p = Factory.create :fse_player, :player => @player
        fse2_p = Factory.create :fse_player, :player => @player
        fse2_a = Factory.create :fse_alliance, 
          :alliance => @player.alliance,
          :solar_system => fse2_p.solar_system
        fse3_a = Factory.create :fse_alliance, :alliance => @player.alliance
        # Invisible SS
        Factory.create :solar_system

        SolarSystem.visible_for(@player).map do |e|
          e[:metadata]
        end.should == [
          FowSsEntry.merge_metadata(fse1_p, nil),
          FowSsEntry.merge_metadata(fse2_p, fse2_a),
          FowSsEntry.merge_metadata(nil, fse3_a)
        ]
      end
    end
  end

  describe "not empty" do
    before(:all) do
      @model = Factory.create :ss_expansion, :create_empty => false
    end

    [:regular, :resource, :npc, :mining].each do |attr|
      it "should have #{attr} in it" do
        @model.planets.count(
          :conditions => {:type => attr.to_s.camelcase}
        ).should be_in_config_range(
          "solar_system.expansion.#{attr}_planets"
        )
      end
    end

    it "should have some gaps between planets" do
      planets = []
      @model.planets.map { |planet| planets[planet.position] = planet.type }

      planets.should have_gaps('solar_system.expansion.gaps')
    end

    it "should create resources_entry for each planet" do
      @model.planets.map(&:resources_entry).compact.size.should == @model.planets.size
    end
  end
end