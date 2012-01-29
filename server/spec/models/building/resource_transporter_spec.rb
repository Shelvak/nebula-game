require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::ResourceTransporter do
  describe "#max_volume" do
    it "should use passed level if you have it" do
      level = 3; value = 10
      Building::ResourceTransporter.should_receive(:max_volume).with(level).
        and_return(value)
      Factory.build(:b_resource_transporter).max_volume(level).should == value
    end

    it "should use it's own level if not passed" do
      building = Factory.build(:b_resource_transporter, :level => 5)
      value = 10
      Building::ResourceTransporter.should_receive(:max_volume).
        with(building.level).and_return(value)
      building.max_volume.should == value
    end
  end

  describe ".max_volume" do
    it "should return rounded value" do
      with_config_values(
        'buildings.resource_transporter.max_volume' => "1.3 * level"
      ) { Building::ResourceTransporter.max_volume(2).should == 3 }
    end
  end

  describe "#transport!" do
    let(:player) { Factory.create(:player) }
    let(:source_planet) do
      planet = Factory.create(:planet, :player => player)
      set_resources(planet, 10000, 10000, 10000)
      planet
    end
    let(:target_planet) do
      planet = Factory.create(:planet, :player => player)
      set_resources(planet, 0, 0, 0, 10000, 10000, 10000)
      planet
    end
    let(:building) do
      Factory.create!(:b_resource_transporter,
        opts_active + {:level => 2, :planet => source_planet})
    end
    let(:target_transporter) do
      Factory.create!(:b_resource_transporter,
        opts_active + {:planet => target_planet})
    end

    before(:each) { target_transporter() }

    it "should fail if building is inactive" do
      opts_inactive.apply building
      lambda do
        building.transport!(target_planet, 10, 10, 10)
      end.should raise_error(GameLogicError)
    end

    it "should fail if cooldown hasn't expired yet" do
      building.cooldown_ends_at = 10.minutes.from_now
      lambda do
        building.transport!(target_planet, 10, 10, 10)
      end.should raise_error(GameLogicError)
    end

    it "should fail if trying to transport more resources than max_volume" do
      max_volume = building.max_volume
      Resources.should_receive(:total_volume).with(10, 20, 30).
        and_return(max_volume + 1)
      lambda do
        building.transport!(target_planet, 10, 20, 30)
      end.should raise_error(GameLogicError)
    end

    it "should fail if source planet does not have enough resources" do
      set_resources(source_planet, 9, 19, 29)
      lambda do
        building.transport!(target_planet, 10, 20, 30)
      end.should raise_error(GameLogicError)
    end

    it "should fail if target planet does not belong to same player" do
      target_planet.player = Factory.create(:player)
      target_planet.save!

      lambda do
        building.transport!(target_planet, 10, 20, 30)
      end.should raise_error(GameLogicError)
    end

    it "should fail if no transporter exists in target planet" do
      target_transporter.destroy!

      lambda do
        building.transport!(target_planet, 10, 20, 30)
      end.should raise_error(Building::ResourceTransporter::NoTransporterError)
    end

    it "should fail if inactive transporter exists in target planet" do
      opts_inactive.apply target_transporter
      target_transporter.save!

      lambda do
        building.transport!(target_planet, 10, 20, 30)
      end.should raise_error(Building::ResourceTransporter::NoTransporterError)
    end

    it "should set #cooldown_expires_at" do
      volume = Resources.total_volume(10, 20, 30)
      cooldown_time = building.cooldown_time(volume)
      building.transport!(target_planet, 10, 20, 30)
      building.reload.cooldown_ends_at.should be_within(SPEC_TIME_PRECISION).
        of(cooldown_time.from_now)
    end

    it "should dispatch changed for building" do
      should_fire_event(building, EventBroker::CHANGED) do
        building.transport!(target_planet, 10, 20, 30)
      end
    end

    it "should decrease source planet resources" do
      metal = source_planet.metal
      energy = source_planet.energy
      zetium = source_planet.zetium
      building.transport!(target_planet, 10, 20, 30)
      source_planet.reload
      [source_planet.metal, source_planet.energy, source_planet.zetium].
        should == [metal - 10, energy - 20, zetium - 30]
    end

    it "should dispatch changed for source planet" do
      should_fire_event(source_planet, EventBroker::CHANGED,
          EventBroker::REASON_OWNER_PROP_CHANGE) do
        building.transport!(target_planet, 10, 20, 30)
      end
    end

    it "should increase target planet resources (with fee subtracted)" do
      mult = 1.0 - building.fee
      building.transport!(target_planet, 10, 20, 30)
      target_planet.reload
      [target_planet.metal, target_planet.energy, target_planet.zetium].
        should == [10 * mult, 20 * mult, 30 * mult]
    end

    it "should dispatch changed for target planet" do
      should_fire_event(target_planet, EventBroker::CHANGED,
          EventBroker::REASON_OWNER_PROP_CHANGE) do
        building.transport!(target_planet, 10, 20, 30)
      end
    end
  end
end