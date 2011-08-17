require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Rewards do
  describe ".from_exploration" do
    [
      Rewards::METAL, Rewards::ENERGY, Rewards::ZETIUM
    ].each do |name|
      it "should parse #{name}" do
        Rewards.from_exploration(
        [
          {"kind" => name, "count" => 30},
          {"kind" => name, "count" => 15},
        ]
      ).should == Rewards.new(name => 45)
      end
    end

    [
      Rewards::XP, Rewards::POINTS
    ].each do |name|
      it "should parse #{name}" do
        Rewards.from_exploration(
        [
          {"kind" => name, "count" => 30},
          {"kind" => name, "count" => 15},
        ]
      ).should == Rewards.new(name => 45)
      end
    end

    it "should parse units" do
      Rewards.from_exploration(
        [
          {"kind" => Rewards::UNITS, "type" => "gnat", "count" => 3,
            "hp" => 80},
          {"kind" => Rewards::UNITS, "type" => "glancer", "count" => 1,
            "hp" => 60}
        ]
      ).should == Rewards.new(Rewards::UNITS => [
          {'type' => "Gnat", 'level' => 1, 'count' => 3, 'hp' => 80},
          {'type' => "Glancer", 'level' => 1, 'count' => 1, 'hp' => 60},
      ])
    end
  end

  describe "#claim!" do
    before(:each) do
      metal = 100
      energy = 110
      zetium = 120

      @planet = Factory.create(:planet_with_player)
      @planet.metal_storage += metal
      @planet.energy_storage += energy
      @planet.zetium_storage += zetium
      @player = @planet.player
      @fse = Factory.create(:fse_player,
        :solar_system_id => @planet.solar_system_id,
        :player => @player)
      
      @rewards = Rewards.new(
        Rewards::METAL => metal,
        Rewards::ENERGY => energy,
        Rewards::ZETIUM => zetium,
        Rewards::XP => 130,
        Rewards::POINTS => 140,
        Rewards::CREDS => 150,
        Rewards::SCIENTISTS => 150,
        Rewards::UNITS => [
          {'type' => "Trooper", 'level' => 1, 'count' => 2, 'hp' => 100},
          {'type' => "Shocker", 'level' => 2, 'count' => 1, 'hp' => 100},
          {'type' => "Seeker", 'level' => 1, 'count' => 1, 'hp' => 90},
        ]
      )
      @unit_defs = [
        [Unit::Trooper, 2, 1],
        [Unit::Shocker, 1, 2],
        [Unit::Seeker, 1, 1],
      ]
    end

    Rewards::REWARD_RESOURCES.each do |type, reward|
      it "should reward #{type}" do
        lambda do
          @rewards.claim!(@planet, @player)
          @planet.reload
        end.should change(@planet, type).by(@rewards[reward])
      end
    end

    it "should fire changed on Planet" do
      should_fire_event(@planet, EventBroker::CHANGED,
          EventBroker::REASON_OWNER_PROP_CHANGE) do
        @rewards.claim!(@planet, @player)
      end
    end

    Rewards::REWARD_PLAYER.each do |attributes, reward|
      [attributes].flatten.each do |attribute|
        it "should reward #{reward} (attr #{attribute})" do
          lambda do
            @rewards.claim!(@planet, @player)
            @player.reload
          end.should change(@player, attribute).by(@rewards[reward])
        end
      end
    end
    
    it "should reward units" do
      @rewards.claim!(@planet, @player)
      @unit_defs.each do |klass, count, level|
        klass.where(:level => level, :player_id => @player.id,
          :location => @planet.location).count.should == count
      end
    end

    describe "when population is exausted" do
      before(:each) do
        @player = Factory.create(:player, :population => 100, 
          :population_cap => 100)
        @planet = Factory.create(:planet, :player => @player)
      end
      
      it "should fail if rewarding units" do
        rewards = Rewards.new(Rewards::UNITS => [
          {'type' => "Seeker", 'level' => 1, 'count' => 1, 'hp' => 90},
        ])
        lambda do
          rewards.claim!(@planet, @player)
        end.should raise_error(GameLogicError)
      end
      
      it "should not fail not rewarding units" do
        rewards = Rewards.new(Rewards::METAL => 1000)
        lambda do
          rewards.claim!(@planet, @player)
        end.should_not raise_error(GameLogicError)
      end
      
      it "should not fail if rewarding units with overpopulation enabled" do
        rewards = Rewards.new(Rewards::UNITS => [
          {'type' => "Seeker", 'level' => 1, 'count' => 1, 'hp' => 90},
        ])
        lambda do
          rewards.claim!(@planet, @player, true)
        end.should_not raise_error(GameLogicError)
      end
    end

    it "should reward units honoring hp" do
      @rewards.claim!(@planet, @player)
      Unit::Seeker.where(:player_id => @player.id,
        :location => @planet.location).first.hp.should == \
        (Unit::Seeker.hit_points * 90 / 100)
    end

    it "should reward experienced units" do
      @rewards.claim!(@planet, @player)
      Unit::Shocker.find(:all, :conditions => {
          :level => 2, :player_id => @player.id,
            :location => @planet.location
      }).map(&:hp).uniq.should == [Unit::Shocker.hit_points]
    end
  end
end
