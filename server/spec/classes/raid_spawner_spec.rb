require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe RaidSpawner do
  methods = %w{register! key generate_arg units unit_counts}
  before(:all) { RaidSpawner.class_eval { public *methods } }
  after(:all) { RaidSpawner.class_eval { private *methods } }

  let(:battleground_planet) do
    ss = Factory.build(:battleground)
    Factory.build(:planet, :solar_system => ss,
      :player => Factory.create(:player, :bg_planets_count => 3))
  end

  let(:apocalyptic_planet) do
    galaxy = Factory.build(:galaxy, :apocalypse_start => 5.6.days.ago)
    ss = Factory.build(:solar_system, :galaxy => galaxy)
    Factory.build(:planet, :solar_system => ss,
      :next_raid_at => 5.days.from_now, :player => Factory.create(:player))
  end

  describe "#raid!" do
    let(:planet) { Factory.create(:planet, :next_raid_at => Time.now) }
    let(:spawner) { RaidSpawner.new(planet) }

    describe "when raiders exist" do
      let(:units) { [Factory.build(:unit_built)] }

      before(:each) do
        spawner.stub(:units).and_return(units)
      end

      it "should save raiders to database" do
        Unit.should_receive(:save_all_units).
          with(units, nil, EventBroker::CREATED)
        spawner.raid!
      end

      it "should check location for combat" do
        Combat::LocationChecker.should_receive(:check_location).
          with(planet.location_point)
        spawner.raid!
      end

      it "should reload planet after check" do
        invoked = false
        Combat::LocationChecker.should_receive(:check_location).and_return do
          invoked = true
        end
        planet.should_receive(:reload).and_return { invoked.should be_true }
        spawner.raid!
      end
    end

    describe "when raiders do not exist" do
      before(:each) do
        spawner.stub(:units).and_return([])
      end

      it "should not try to save raiders to database" do
        Unit.should_not_receive(:save_all_units)
        spawner.raid!
      end

      it "should not check location for combat" do
        Combat::LocationChecker.should_not_receive(:check_location)
        spawner.raid!
      end
    end

    it "should register new raid" do
      spawner.should_receive(:register!)
      spawner.raid!
    end
  end

  describe "#register!" do
    let(:planet) { Factory.create(:planet, :next_raid_at => 10.days.ago) }
    let(:spawner) { RaidSpawner.new(planet) }

    it "should shift #next_raid_at to the future" do
      next_raid_at = planet.next_raid_at
      spawner.register!
      planet.reload
      range = Cfg.raiding_delay_range
      range = (next_raid_at + range.first)..(next_raid_at + range.last)
      range.should cover(planet.next_raid_at)
    end

    it "should set #raid_arg" do
      spawner.stub!(:generate_arg).and_return(115)

      lambda do
        spawner.register!
        planet.reload
      end.should change(planet, :raid_arg).to(115)
    end

    it "should register a callback" do
      spawner.register!
      planet.should have_callback(CallbackManager::EVENT_RAID,
                                  planet.next_raid_at)
    end

    it "should dispatch a changed event" do
      should_fire_event(planet, EventBroker::CHANGED,
                        EventBroker::REASON_OWNER_PROP_CHANGE) do
        spawner.register!
      end
    end
  end

  describe "#key" do
    it "should return apocalypse key it it has started" do
      RaidSpawner.new(apocalyptic_planet).key.
        should == RaidSpawner::KEY_APOCALYPSE
    end

    it "should return battleground key if planet is in bg solar system" do
      RaidSpawner.new(battleground_planet).key.
        should == RaidSpawner::KEY_BATTLEGROUND
    end

    it "should return planet key if planet is in regular solar system" do
      RaidSpawner.new(Factory.build(:planet)).key.
        should == RaidSpawner::KEY_PLANET
    end
  end

  describe "#generate_arg" do
    it "should return 0 if planet is npc" do
      RaidSpawner.new(Factory.build(:planet)).generate_arg.should == 0
    end

    it "should return 0 if apocalypse has started" do
      RaidSpawner.new(apocalyptic_planet).generate_arg.should == 0
    end

    describe "if it's a battleground planet" do
      it "should return player bg planet count" do
        RaidSpawner.new(battleground_planet).generate_arg.
          should == battleground_planet.player.bg_planets_count
      end

      it "should return limit max arg" do
        max = Cfg.raiding_max_arg(RaidSpawner::KEY_BATTLEGROUND)
        battleground_planet.player.bg_planets_count = max + 1
        RaidSpawner.new(battleground_planet).generate_arg.
          should == max
      end
    end

    describe "if it's a regular planet" do
      let(:planet) do
        Factory.build(
          :planet, :player => Factory.create(:player, :planets_count => 5)
        )
      end

      it "should return player planet count " do
        RaidSpawner.new(planet).generate_arg.
          should == planet.player.planets_count
      end

      it "should return limit max arg" do
        max = Cfg.raiding_max_arg(RaidSpawner::KEY_PLANET)
        planet.player.planets_count = max + 1
        RaidSpawner.new(planet).generate_arg.should == max
      end
    end
  end

  describe "#units" do
    before(:all) do
      @planet = Factory.create(:planet)
      spawner = RaidSpawner.new(@planet)
      spawner.stubs(:unit_counts).returns([
        ["gnat", 2, 0],
        ["glancer", 1, 1],
      ])
      @units = spawner.units
    end

    it "should place units in planet" do
      @units.each { |unit| unit.location.should == @planet.location_point }
    end

    it "should set unit flanks" do
      @units.map(&:flank).should == [0, 0, 1]
    end

    it "should set unit levels" do
      @units.each { |unit| unit.level.should == 1 }
    end

    it "should set unit to full hp" do
      @units.each { |unit| unit.hp.should == unit.hit_points }
    end

    it "should not belong to any player" do
      @units.each { |unit| unit.player.should be_nil }
    end

    it "should be correct types" do
      @units.map { |u| u.class.to_s }.should == [
        "Unit::Gnat",
        "Unit::Gnat",
        "Unit::Glancer",
      ]
    end

    it "should not be saved" do
      @units.each { |unit| unit.id.should be_nil }
    end
  end

  describe "#unit_counts" do
    describe "in normal conditions" do
      it "should return data using SsObject#raid_arg" do
        with_config_values('raiding.raiders.planet' => {
          "gnat" => [
            "arg * 2", "arg * 4", "0.3 + (arg - 1) * 0.2"
          ]
        }) do
          spawner = RaidSpawner.new(Factory.build(:planet, :raid_arg => 2))
          counts = spawner.unit_counts.inject({}) do
            |hash, (type, count, flank)|
            hash[type] ||= 0
            hash[type] += count
            hash
          end
          (4..8).should cover(counts['gnat'])
        end
      end
    end

    describe "in apocalypse" do
      it "should return data using RaidSpawner#apocalypse_raid_arg" do
        with_config_values('raiding.raiders.apocalypse' => {
          "gnat" => [
            "arg", "arg", "0.3 + (arg - 1) * 0.2"
          ]
        }) do
          # Set to nonsense to check that we're not using it.
          apocalyptic_planet.raid_arg = 9999
          spawner = RaidSpawner.new(apocalyptic_planet)
          counts = spawner.unit_counts.inject({}) do
            |hash, (type, count, flank)|
            hash[type] ||= 0
            hash[type] += count
            hash
          end
          counts['gnat'].should == 7 + 5
        end
      end
    end
  end
end