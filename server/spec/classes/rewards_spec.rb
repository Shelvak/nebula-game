require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Rewards do
  describe ".from_exploration" do
    [
      ["metal", Rewards::METAL], 
      ["energy", Rewards::ENERGY], 
      ["zetium", Rewards::ZETIUM]
    ].each do |yml_name, const_name|
      it "should parse #{yml_name}" do
        Rewards.from_exploration(
        [
          {"kind" => "resource", "type" => yml_name, "count" => 30},
          {"kind" => "resource", "type" => yml_name, "count" => 15},
        ]
      ).should == Rewards.new(const_name => 45)
      end
    end

    [
      ["xp", Rewards::XP],
      ["points", Rewards::POINTS]
    ].each do |yml_name, const_name|
      it "should parse #{yml_name}" do
        Rewards.from_exploration(
        [
          {"kind" => yml_name, "count" => 30},
          {"kind" => yml_name, "count" => 15},
        ]
      ).should == Rewards.new(const_name => 45)
      end
    end

    it "should parse units" do
      Rewards.from_exploration(
        [
          {"kind" => "unit", "type" => "gnat", "count" => 3, "hp" => 80},
          {"kind" => "unit", "type" => "glancer", "count" => 1, "hp" => 60}
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
      
      @rewards = Rewards.new(
        Rewards::METAL => metal,
        Rewards::ENERGY => energy,
        Rewards::ZETIUM => zetium,
        Rewards::XP => 130,
        Rewards::POINTS => 140,
        Rewards::UNITS => [
          {'type' => "Trooper", 'level' => 1, 'count' => 2, 'hp' => 100},
          {'type' => "Shocker", 'level' => 2, 'count' => 1, 'hp' => 100},
          {'type' => "Seeker", 'level' => 1, 'count' => 1, 'hp' => 90},
        ]
      )
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
          EventBroker::REASON_RESOURCES_CHANGED) do
        @rewards.claim!(@planet, @player)
      end
    end

    Rewards::REWARD_PLAYER.each do |type, reward|
      it "should reward #{type}" do
        lambda do
          @rewards.claim!(@planet, @player)
          @player.reload
        end.should change(@player, type).by(@rewards[reward])
      end
    end

    it "should reward units" do
      @rewards.claim!(@planet, @player)
      Unit::Trooper.count(:all, :conditions => {
          :level => 1, :player_id => @player.id,
            :location => @planet.location
      }).should == 2
      Unit::Shocker.count(:all, :conditions => {
          :level => 2, :player_id => @player.id,
            :location => @planet.location
      }).should == 1
    end

    it "should reward units honoring hp" do
      @rewards.claim!(@planet, @player)
      Unit::Seeker.where(:player_id => @player.id,
        :location => @planet.location).first.hp.should == \
        (Unit::Seeker.hit_points(1) * 90 / 100)
    end

    it "should fire created with units" do
      should_fire_event(
        [an_instance_of(Unit::Trooper), an_instance_of(Unit::Trooper),
          an_instance_of(Unit::Shocker), an_instance_of(Unit::Seeker)],
        EventBroker::CREATED,
        EventBroker::REASON_REWARD_CLAIMED
      ) do
        @rewards.claim!(@planet, @player)
      end
    end

    it "should reward experienced units" do
      @rewards.claim!(@planet, @player)
      units = Unit::Shocker.find(:all, :conditions => {
          :level => 2, :player_id => @player.id,
            :location => @planet.location
      }).map(&:hp).uniq.should == [Unit::Shocker.hit_points(2)]
    end
  end
end