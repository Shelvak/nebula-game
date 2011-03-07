require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe SolarSystem do
  describe "#as_json" do
    before(:all) do
      @model = Factory.create(:solar_system)
    end

    @required_fields = %w{id x y galaxy_id wormhole}
    @ommited_fields = %w{}
    it_should_behave_like "to json"
  end

  describe "#npc_unit_locations" do
    before(:all) do
      @ss = Factory.create(:solar_system)
      @npc1 = Factory.create(:u_dirac, :player => nil,
        :location => SolarSystemPoint.new(@ss.id, 0, 0))
      @npc2 = Factory.create(:u_crow, :player => nil,
        :location => SolarSystemPoint.new(@ss.id, 1, 0))
      @pc = Factory.create(:u_crow, :player => Factory.create(:player),
        :location => SolarSystemPoint.new(@ss.id, 2, 0))
      @results = @ss.npc_unit_locations
    end

    it "should include npc units" do
      @results.should include(@npc1.location)
    end

    it "should include abandoned units" do
      @results.should include(@npc2.location)
    end

    it "should not include controlled units" do
      @results.should_not include(@pc.location)
    end
  end

  describe "jumpgates" do    
    before(:all) do
      @ss = Factory.create(:solar_system)
      @gates = [
        Factory.create(:sso_jumpgate, :solar_system => @ss, :position => 7),
        Factory.create(:sso_jumpgate, :solar_system => @ss, :position => 1),
        Factory.create(:sso_jumpgate, :solar_system => @ss, :position => 4)
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
    model = Factory.create :solar_system
    Factory.build(:solar_system, :galaxy => model.galaxy, :x => model.x,
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
end