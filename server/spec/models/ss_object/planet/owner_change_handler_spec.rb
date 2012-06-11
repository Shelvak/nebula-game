require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper.rb')
)

describe SsObject::Planet::OwnerChangeHandler do
  before(:each) do
    @old = Factory.create(:player, planets_count: 5, bg_planets_count: 8)
    @new = Factory.create(:player, planets_count: 10, bg_planets_count: 12)
    @planet = Factory.create :planet, :player => @old
    set_resources(@planet, 1_000_000, 1_000_000, 1_000_000)

    @handler = SsObject::Planet::OwnerChangeHandler.new(@planet, @old, @new)
  end

  describe "planets counter cache" do
    shared_examples_for "changing counter cache" do |attribute|
      it "should increase by 1 for new player" do
        lambda do
          @handler.handle!
          @new.reload
        end.should change(@new, attribute).by(1)
      end

      it "should decrease by 1 for old player" do
        lambda do
          @handler.handle!
          @old.reload
        end.should change(@old, attribute).by(-1)
      end
    end

    shared_examples_for "not changing counter cache" do |attribute|
      it "should not change for new player" do
        lambda do
          @handler.handle!
          @new.reload
        end.should_not change(@new, attribute)
      end

      it "should not change for old player" do
        lambda do
          @handler.handle!
          @old.reload
        end.should_not change(@old, attribute)
      end
    end

    shared_examples_for "pausing technologies" do |player_attr, tech_key|
      let(:technologies) do
        [
          Factory.create!(:technology_t2, opts_upgrading +
            {:player => @old, :level => 2}),
          Factory.create!(:technology_t3, opts_upgrading +
            {:player => @old, :level => 2}),
          Factory.create!(:technology_t4, opts_upgrading +
            {:player => @old, :level => 2}),
        ]
      end

      before(:each) { technologies() }

      describe "which do not meet #{tech_key} requirements anymore" do
        config_overrides = lambda do |player|
          req = player.send(player_attr).to_s
          {
            "technologies.test_t2.#{tech_key}.required" => req,
            "technologies.test_t3.#{tech_key}.required" => "0",
            "technologies.test_t4.#{tech_key}.required" => req
          }
        end

        it "should pause them" do
          with_config_values(config_overrides[@old]) do
            @handler.handle!
            technologies[0].reload.should be_paused
            technologies[1].reload.should_not be_paused
            technologies[2].reload.should be_paused
          end
        end

        it "should create notification with them" do
          with_config_values(config_overrides[@old]) do
            Notification.should_receive(:create_for_technologies_changed).with(
              @old.id, [
                [technologies[0], Reducer::RELEASED],
                [technologies[2], Reducer::RELEASED],
              ]
            )
            @handler.handle!
          end
        end
      end

      describe "when all techs meet their #{tech_key} requirements" do
        let(:config_overrides) do
          {
            "technologies.test_t2.#{tech_key}.required" => "0",
            "technologies.test_t3.#{tech_key}.required" => "0",
            "technologies.test_t4.#{tech_key}.required" => "0"
          }
        end

        it "should not pause any of the technologies" do
          with_config_values(config_overrides) do
            @handler.handle!
            technologies.each { |t| t.reload.should_not be_paused }
          end
        end

        it "should not create notification" do
          with_config_values(config_overrides) do
            Notification.should_not_receive(:create_for_technologies_changed)
            @handler.handle!
          end
        end
      end
    end

    it_should_behave_like "changing counter cache", :planets_count
    it_should_behave_like "not changing counter cache", :bg_planets_count
    it_should_behave_like "pausing technologies", :planets_count, :planets

    [:battleground, :mini_battleground].each do |type|
      describe "in #{type}" do
        before(:each) do
          @planet.solar_system = Factory.create(type)
          @planet.save!
        end

        it_should_behave_like "changing counter cache", :bg_planets_count
        it_should_behave_like "not changing counter cache", :planets_count
        it_should_behave_like "pausing technologies", :bg_planets_count,
                              :pulsars
      end
    end
  end

  describe "points" do
    [
      [:b_metal_storage, :economy_points],
      [:b_research_center, :science_points],
      [:b_barracks, :army_points]
    ].each do |factory, points_type|
      it "should remove #{points_type} from old player" do
        building = Factory.create!(factory, :level => 1,
          :planet => @planet)
        points = building.points_on_destroy
        @old.send("#{points_type}=", points)
        @old.save!
        @handler.handle!
        @old.reload
        @old.send(points_type).should == 0
      end

      it "should add #{points_type} to new player" do
        building = Factory.create!(factory, :level => 1,
          :planet => @planet)
        points = building.points_on_destroy
        @old.send("#{points_type}=", points)
        @old.save!
        @handler.handle!
        @new.reload
        @new.send(points_type).should == points
      end
    end
  end

  it "should call FowSsEntry.change_planet_owner after save" do
    FowSsEntry.should_receive(:change_planet_owner).with(
      @planet, @old, @new, 1
    ).and_return do |planet, old_player, new_player|
      planet.should be_saved
      true
    end
    @handler.handle!
  end

  it "should fire event" do
    should_fire_event(@planet, EventBroker::CHANGED,
    EventBroker::REASON_OWNER_CHANGED) do
      @handler.handle!
    end
  end

  it "should fire event after planet has been saved" do
    EventBroker.stub!(:fire).and_return(true)
    EventBroker.stub!(:fire).with(@planet, EventBroker::CHANGED,
    EventBroker::REASON_OWNER_CHANGED).and_return do
      |object, event_name, reason|
      object.should be_saved
    end
    @handler.handle!
  end

  it "should update Objective::AnnexPlanet" do
    Objective::AnnexPlanet.should_receive(:progress).with(@planet).
      and_return(true)
    @handler.handle!
  end

  it "should update Objective::HavePlanets" do
    Objective::HavePlanets.should_receive(:progress).with(@planet).
      and_return(true)
    @handler.handle!
  end

  describe "alive units" do
    before(:each) do
      @transporter = Factory.create(:u_mule, player: @old, location: @planet)
      @units = [
        @transporter,
        # Unit inside transporter.
        Factory.create(:unit, player: @old, location: @transporter)
      ]
    end

    it "should not change player if it didn't belong to old user" do
      @units.each do |unit|
        unit.player = Factory.create(:player)
        unit.save!
      end

      player = lambda do
        @units.map { |u| u.reload.player }
      end

      lambda do
        @handler.handle!
      end.should_not change(player, :call)
    end

    it "should change player id" do
      player = lambda do
        @units.map { |u| u.reload.player }.uniq
      end

      lambda do
        @handler.handle!
      end.should change(player, :call).from([@old]).to([@new])
    end

    it "should take population from old player" do
      @old.recalculate_population
      lambda do
        @handler.handle!
        @old.reload
      end.should change(@old, :population).by(- @units.map(&:population).sum)
    end

    it "should give population to new player" do
      @new.recalculate_population
      lambda do
        @handler.handle!
        @new.reload
      end.should change(@new, :population).by(@units.map(&:population).sum)
    end

    it "should call transfer fow ss entries for space units" do
      Factory.create!(:u_crow, :player => @old, :location => @planet)
      Factory.create!(:u_crow, :player => @old, :location => @planet)
      Factory.create!(:u_scorpion, :player => @old, :location => @planet)

      FowSsEntry.should_receive(:change_planet_owner).with(
        @planet, @old, @new, 4 # 1 mule + 2 crows + 1 for planet
      )
      @handler.handle!
    end

    it "should dispatch changed event" do
      # No changed for units inside transporter.
      should_fire_event([@transporter], EventBroker::CHANGED) do
        @handler.handle!
      end
    end
  end

  describe "objectives" do
    before(:each) do
      buildings = [Factory.create(:building, planet: @planet)]
      units = [Factory.create(:u_trooper, location: @planet, player: @old)]
      # Make our expectations work well, because units left in planet are
      # transferred to new players ownership.
      units.each { |u| u.player_id = @new.id }
      @objects = buildings + units
      # These should not be included.
      Factory.create(:u_trooper, location: @planet)
      Factory.create(:b_npc_solar_plant, planet: @planet, x: 10)
    end

    it "should regress Objective::HaveUpgradedTo for old player" do
      Objective::HaveUpgradedTo.should_receive(:regress).
        with(@objects, player_id: @old.id).and_return(true)
      @handler.handle!
    end

    it "should progress Objective::HaveUpgradedTo for new player" do
      # Because #regress uses #progress and #regress is called for old player
      # before #progress.
      Objective::HaveUpgradedTo.stub(:progress)
      Objective::HaveUpgradedTo.should_receive(:progress).
        with(@objects, player_id: @new.id).and_return(true)
      @handler.handle!
    end
  end

  describe "prepaid constructor queue entries" do
    let(:constructor) do
      Factory.create(:b_constructor_test, opts_working + {:planet => @planet})
    end
    let(:prepaid_entries) do
      [
        ConstructionQueue.push(constructor.id, Unit::Trooper.to_s, true, 5),
        ConstructionQueue.push(constructor.id, Unit::Azure.to_s, true, 5)
      ]
    end
    let(:population) do
      prepaid_entries.map { |e| e.constructable_class.population * e.count }.
        sum
    end

    before(:each) do
      ConstructionQueue.push(constructor.id, Unit::Azure.to_s, false, 5)
      self.prepaid_entries
      @old.recalculate_population
      @new.recalculate_population
      # We need to actually update planet player id, to transfer ownership of
      # CQEs.
      @planet.update_row! player_id: @new.id
    end

    it "should free population for old player" do
      lambda do
        @handler.handle!
        @old.reload
      end.should change(@old, :population).by(- population)
    end

    it "should take population for new player" do
      lambda do
        @handler.handle!
        @new.reload
      end.should change(@new, :population).by(population)
    end
  end

  describe "market offers where #from_kind is creds" do
    before(:each) do
      @offers = [
        Factory.create(:market_offer, :planet => @planet,
          :from_kind => MarketOffer::KIND_CREDS),
        Factory.create(:market_offer, :planet => @planet,
          :from_kind => MarketOffer::KIND_CREDS),
      ]
    end

    it "should add summed #from_amount to old player" do
      lambda do
        @handler.handle!
        @old.reload
      end.should change(@old, :creds).by(@offers.sum(&:from_amount))
    end

    it "should destroy those offers" do
      @handler.handle!
      @offers.each do |offer|
        lambda do
          offer.reload
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it "should not fail if planet does not have old player" do
      @planet.stub!(:player_change).and_return([nil, @new])
      lambda do
        @handler.handle!
      end.should_not raise_error
    end
  end

  describe "radar" do
    describe "when active" do
      before(:each) do
        @radar = Factory.create!(:b_radar,
                                 opts_active + {:planet => @planet})
      end

      it "should decrease vision for old player" do
        Trait::Radar.should_receive(:decrease_vision).with(
          @radar.radar_zone, @old)
        @handler.handle!
      end

      it "should increase vision for new player" do
        Trait::Radar.should_receive(:increase_vision).with(
          @radar.radar_zone, @new)
        @handler.handle!
      end
    end

    describe "when inactive" do
      before(:each) do
        @radar = Factory.create!(:b_radar,
                                 opts_inactive + {:planet => @planet})
      end

      it "should not decrease vision for old player" do
        Trait::Radar.should_not_receive(:decrease_vision)
        @handler.handle!
      end

      it "should not increase vision for new player" do
        Trait::Radar.should_not_receive(:increase_vision)
        @handler.handle!
      end
    end
  end

  shared_examples_for "transfering attribute" do
    it "should reduce attribute value from previous owner" do
      lambda do
        @handler.handle!
        @old.reload
      end.should change(@old, @attr).by(- @change)
    end

    it "should increase attribute value for new owner" do
      lambda do
        @handler.handle!
        @new.reload
      end.should change(@new, @attr).by(@change)
    end
  end

  shared_examples_for "not transfering attribute" do
    it "should reduce attribute value from previous owner" do
      lambda do
        @handler.handle!
        @old.reload
      end.should_not change(@old, @attr)
    end

    it "should increase attribute value for new owner" do
      lambda do
        @handler.handle!
        @new.reload
      end.should_not change(@new, @attr)
    end
  end

  describe "scientists" do
    before(:each) do
      @research_center = Factory.create(:b_research_center,
        opts_active + {:planet => @planet})
      @old.reload
    end

    %w{scientists scientists_total}.each do |attr|
      describe attr do
        before(:each) do
          @attr = attr
          @change = @research_center.scientists
        end

        describe "building active" do
          it_behaves_like "transfering attribute"
        end

        describe "inactinet ve building" do
          before(:each) do
            @research_center.deactivate!
          end

          it_behaves_like "not transfering attribute"
        end
      end
    end
  end

  describe "population_max" do
    before(:each) do
      @housing = Factory.create(:b_housing, opts_active + {planet: @planet})
      @old.reload
      @attr = :population_max
      @change = @housing.population
    end

    describe "building active" do
      it_behaves_like "transfering attribute"
    end

    describe "inactive building" do
      before(:each) do
        @housing.deactivate!
      end

      it_behaves_like "not transfering attribute"
    end

    describe "working building" do
      before(:each) do
        @housing.state = Building::STATE_WORKING
        @housing.save!
      end

      it_behaves_like "transfering attribute"
    end
  end

  describe "exploration" do
    it "should stop exploration if exploring" do
      @planet.stub!(:exploring?).and_return(true)
      @planet.should_receive(:stop_exploration!).with(@old)
      @handler.handle!
    end

    it "should not stop exploration if not exploring" do
      @planet.stub!(:exploring?).and_return(false)
      @planet.should_not_receive(:stop_exploration!)
      @handler.handle!
    end
  end

  describe "resetable cooldowns" do
    it "should reset cooldowns" do
      building = Factory.create(:b_npc_hall, :planet => @planet,
        :cooldown_ends_at => 10.minutes.from_now)
      lambda do
        @handler.handle!
        building.reload
      end.should change(building, :cooldown_ends_at)
    end
  end

  describe "battleground planets" do
    before(:each) do
      @planet.solar_system = Factory.create(:battleground)
      @handler.handle!
    end

    it "should give units in that planet" do
      Unit.should_receive(:give_units).with(
        CONFIG['battleground.planet.bonus'],
        @planet,
        @new
      )
      @handler.handle!
    end
  end
end