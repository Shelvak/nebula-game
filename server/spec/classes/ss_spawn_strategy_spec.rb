require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe SsSpawnStrategy do
  let(:solar_system) { Factory.create(:solar_system) }
  let(:strategy) { SsSpawnStrategy.new(solar_system) }

  shared_examples_for "picking position in solar system" do
    it "should return position in solar system" do
      strategy.pick.id.should == solar_system.id
    end
  end

  describe "strategies" do
    describe "outer circle" do
      before(:each) do
        Cfg.stub!(:solar_system_spawn_strategy).with(solar_system).
          and_return(SsSpawnStrategy::STRATEGY_OUTER_CIRCLE)
      end

      it_should_behave_like "picking position in solar system"

      it "should return position in last circle" do
        strategy.pick.position.should == Cfg.solar_system_orbit_count
      end

      it "should not position items on excluded points" do
        all_points = SolarSystemPoint.orbit_points(
          solar_system.id, Cfg.solar_system_orbit_count
        ).to_a

        point = all_points[-1]
        excluded = Set.new(all_points[0..-2])

        strategy = SsSpawnStrategy.new(solar_system, excluded)
        strategy.pick.should == point
      end

      it "should not position items on jumpgates" do
        jumpgate = Factory.create(:sso_jumpgate, :angle => 0,
                                  :position => Cfg.solar_system_orbit_count,
                                  :solar_system => solar_system)
        excluded = (
          SolarSystemPoint.orbit_points(solar_system.id, jumpgate.position) -
            Set.new([jumpgate.solar_system_point])
        ).to_a

        point = excluded[-1]
        excluded = Set.new(excluded[0..-2])

        strategy = SsSpawnStrategy.new(solar_system, excluded)
        strategy.pick.should == point
      end
    end

    describe "random" do
      before(:each) do
        Cfg.stub!(:solar_system_spawn_strategy).with(solar_system).
          and_return(SsSpawnStrategy::STRATEGY_RANDOM)
      end
      
      it_should_behave_like "picking position in solar system"

      it "should not position items on excluded points" do
        all_points = SolarSystemPoint.all_orbit_points(solar_system.id).to_a

        point = all_points[-1]
        excluded = Set.new(all_points[0..-2])

        strategy = SsSpawnStrategy.new(solar_system, excluded)
        strategy.pick.should == point
      end
    end
  end
end