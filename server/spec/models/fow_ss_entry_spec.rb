require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

def count_for_alliance(alliance_id)
  solar_system_counters = {}
  FowSsEntry.find(:all,
    :conditions => {:alliance_id => alliance_id}
  ).each do |entry|
    solar_system_counters[entry.solar_system_id] = entry.counter
  end

  solar_system_counters
end

describe "fow ss entry recalculate", :shared => true do
  describe "if entry was changed" do
    before(:each) do
      FowSsEntry.stub!(:where).and_return([@fse])
      @fse.stub!(:changed?).and_return(true)
    end

    it "should return true" do
      FowSsEntry.recalculate(@fse.solar_system_id).should be_true
    end

    it "should dispatch event" do
      should_fire_event(
        an_instance_of(FowChangeEvent::Recalculate),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      ) do
        FowSsEntry.recalculate(@fse.solar_system_id)
      end
    end

    it "should not dispatch event if silenced" do
      should_not_fire_event(
        an_instance_of(FowChangeEvent::Recalculate),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      ) do
        FowSsEntry.recalculate(@fse.solar_system_id, false)
      end
    end
  end

  describe "if entry was not changed" do
    before(:each) do
      FowSsEntry.stub!(:where).and_return([@fse])
      @fse.stub!(:changed?).and_return(false)
    end

    it "should return false" do
      FowSsEntry.recalculate(@fse.solar_system_id).should be_false
    end

    it "should not dispatch event even if asked" do
      should_not_fire_event(
        an_instance_of(FowChangeEvent::Recalculate),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      ) do
        FowSsEntry.recalculate(@fse.solar_system_id, true)
      end
    end
  end
end

describe FowSsEntry do
  describe ".observer_player_ids" do
    before(:all) do
      @galaxy = Factory.create(:galaxy)
      @alliance = Factory.create :alliance
      @observer = Factory.create :player, :alliance => @alliance,
        :galaxy => @galaxy
      @observer_alliance = Factory.create :player, :alliance => @alliance
      @non_observer = Factory.create :player, :galaxy => @galaxy
      @fse_planets = Factory.create :fse_player, :player => @observer, 
        :player_planets => true
      @fse_alliance_planets = Factory.create :fse_alliance,
        :solar_system => @fse_planets.solar_system,
        :alliance => @alliance,
        :alliance_planet_player_ids => [@observer.id]
    end

    it "should return player id if he has visibility" do
      FowSsEntry.observer_player_ids(@fse_planets.solar_system_id).should \
        include(@observer.id)
    end

    it "should return player id if alliance has visibility" do
      FowSsEntry.observer_player_ids(@fse_planets.solar_system_id).should \
        include(@observer_alliance.id)
    end

    it "should not return player if if he doesn't have anything there" do
      FowSsEntry.observer_player_ids(
        @fse_planets.solar_system_id
      ).should_not include(@non_observer.id)
    end

    describe "battleground" do
      before(:all) do
        @battleground = Factory.create(:battleground, :galaxy => @galaxy)
        @wormhole = Factory.create(:wormhole, :galaxy => @galaxy)
        @fse_wormhole = Factory.create :fse_player, :player => @observer,
          :solar_system => @wormhole
      end

      it "should return player id if he sees some wormholes" do
        FowSsEntry.observer_player_ids(@battleground.id).should \
          include(@observer.id)
      end

      it "should not return player id if he sees no wormholes" do
        FowSsEntry.observer_player_ids(@battleground.id).should_not \
          include(@non_observer.id)
      end
    end
  end

  describe ".change_planet_owner" do
    describe "new player" do
      it "should do nothing when new player_id == nil" do
        planet = mock(SsObject)
        FowSsEntry.should_not_receive(:create)
        FowSsEntry.change_planet_owner(planet, nil, nil)
      end

      it "should create when new player_id == Fixnum" do
        player = Factory.create :player

        planet = mock(SsObject)
        planet.stub!(:solar_system_id).and_return(103)
        FowSsEntry.should_receive(:increase).with(planet.solar_system_id,
          player)
        FowSsEntry.change_planet_owner(planet, nil, player)
      end
    end

    describe "old player" do
      it "should do nothing when old player_id == nil" do
        planet = mock(SsObject)
        FowSsEntry.should_not_receive(:delete)
        FowSsEntry.change_planet_owner(planet, nil, nil)
      end

      it "should delete when old player_id == Fixnum" do
        player = Factory.create :player

        planet = mock(SsObject)
        planet.stub!(:solar_system_id).and_return(103)
        FowSsEntry.should_receive(:decrease).with(planet.solar_system_id,
          player)
        FowSsEntry.change_planet_owner(planet, player, nil)
      end
    end
  end

  describe "fow entry" do
    before(:each) do
      @short_factory_name = :fse
      @alliance = Factory.create(:alliance)
      @player = Factory.create(:player, :alliance => @alliance)
      @player_id = @player.id
      @solar_system_id = Factory.create(:solar_system).id

      @klass = FowSsEntry
      @first_arg = @solar_system_id
      @conditions = {:solar_system_id => @solar_system_id}
      @event_reason = EventBroker::REASON_SS_ENTRY
    end

    describe "fow entry" do
      before(:each) do
        FowSsEntry.stub!(:recalculate).and_return(false)
      end

      it_should_behave_like "fow entry"

      it "should dispatch destroyed for that solar system" do
        @klass.increase(@first_arg, @player, 2)
        should_fire_event(kind_of(FowChangeEvent::SsDestroyed),
          EventBroker::FOW_CHANGE,
          EventBroker::REASON_SS_ENTRY
        ) do
          @klass.decrease(@first_arg, @player, 2)
        end
      end
    end

    it "should recalculate for given ss" do
      @klass.should_receive(:recalculate).with(@solar_system_id, false)
      @klass.increase(@solar_system_id, @player)
    end

    describe "battleground" do
      before(:each) do
        @battleground = Factory.create(:battleground,
          :galaxy => @player.galaxy)
      end

      it "should return false" do
        @klass.increase(@battleground.id, @player).should be_false
      end

      it "should not dispatch event" do
        EventBroker.should_not_receive(:fire)
        @klass.increase(@battleground.id, @player)
      end

      it "should not create fow ss entry" do
        @klass.increase(@battleground.id, @player)
        FowSsEntry.where(:solar_system_id => @battleground.id).first.
          should be_nil
      end
    end

    it "should fire event if updated but recalculate returned true" do
      @klass.increase(@first_arg, @player)
      should_fire_event(
        FowChangeEvent::SolarSystem.new(@solar_system_id),
        EventBroker::FOW_CHANGE, @event_reason
      ) do
        @klass.stub!(:recalculate).and_return(true)
        @klass.increase(@first_arg, @player)
      end
    end

    it "should not fire event if created but asked not to do so" do
      should_not_fire_event(
        FowChangeEvent::SolarSystem.new(@solar_system_id),
        EventBroker::FOW_CHANGE, @event_reason) do
        @klass.increase(@solar_system_id, @player, 1, false)
      end
    end

    it "should not fire event if deleted but asked not to do so" do
      @klass.increase(@solar_system_id, @player)

      should_not_fire_event(
        FowChangeEvent::SolarSystem.new(@solar_system_id),
        EventBroker::FOW_CHANGE, @event_reason) do
        @klass.decrease(@solar_system_id, @player, 1, false)
      end
    end

    describe ".assimilate_player" do
      before(:each) do
        @ss1 = Factory.create(:solar_system)
        @ss2 = Factory.create(:solar_system)
        @ss3 = Factory.create(:solar_system)

        @player1 = @player
        @player2 = Factory.create(:player)

        # Alliance 1 SS
        FowSsEntry.increase(@ss1.id, @player1)
        FowSsEntry.increase(@ss2.id, @player1)

        # Player 2 SS
        FowSsEntry.increase(@ss2.id, @player2)
        FowSsEntry.increase(@ss3.id, @player2)
      end

      it "should add all player entries to alliance pool" do
        FowSsEntry.assimilate_player(@player1.alliance, @player2)

        count_for_alliance(@player1.alliance_id).should == {
          @ss1.id => 1,
          @ss2.id => 2,
          @ss3.id => 1
        }
      end

      it "should not dispatch event" do
        should_not_fire_event(anything,
            EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY) do
          FowSsEntry.assimilate_player(@alliance, @player2)
        end
      end
    end

    describe ".throw_out_player" do
      before(:each) do
        @ss1 = Factory.create(:solar_system)
        @ss2 = Factory.create(:solar_system)
        @ss3 = Factory.create(:solar_system)

        @player1 = @player
        @player2 = Factory.create(:player)

        # Alliance SS
        Factory.create(:fow_ss_entry, :solar_system => @ss1,
          :alliance => @player1.alliance, :counter => 1)
        Factory.create(:fow_ss_entry, :solar_system => @ss2,
          :alliance => @player1.alliance, :counter => 2)
        Factory.create(:fow_ss_entry, :solar_system => @ss3,
          :alliance => @player1.alliance, :counter => 1)

        # P2 SS
        Factory.create(:fow_ss_entry, :solar_system => @ss2,
          :player => @player2, :counter => 1)
        Factory.create(:fow_ss_entry, :solar_system => @ss3,
          :player => @player2, :counter => 1)
      end

      it "should remove all player entries from alliance pool" do
        FowSsEntry.throw_out_player(@player1.alliance, @player2)

        count_for_alliance(@player1.alliance_id).should == {
          @ss1.id => 1,
          @ss2.id => 1
        }
      end

      it "should not fire event" do
        should_not_fire_event(anything,
            EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY) do
          FowSsEntry.throw_out_player(@player1.alliance, @player2)
        end
      end
    end
  end

  describe "metadata" do
    describe ".recalculate" do
      asset_types = [
        ['planets', Proc.new do |solar_system, player|
          Factory.create :planet, :solar_system => solar_system,
            :player => player, :angle => 0,
            :position => (solar_system.ss_objects.maximum(:position) || -1) + 1
        end],
        ['ships', Proc.new do |solar_system, player|
          Factory.create :u_crow,
            :location => SolarSystemPoint.new(solar_system.id, 0, 0),
            :player => player
        end],
      ]

      describe "player entry" do
        before(:each) do
          # counter => 1 because we simulate other radar having this
          # SS under coverage
          @fse = Factory.create :fse_player, :counter => 1,
            :player_planets => false, :player_ships => false,
            :enemy_planets => false, :enemy_ships => false
        end

        it_should_behave_like "fow ss entry recalculate"

        asset_types.each do |type, create_asset|
          it "should set player_#{type}=true if player has #{type}" do
            lambda do
              create_asset.call(@fse.solar_system, @fse.player)
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(@fse, :"player_#{type}").from(false).to(true)
          end

          it "should set player_#{type}=false if player doesn't have #{
          type}" do
            @fse.send("player_#{type}=", true)
            @fse.save!

            lambda do
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(@fse, :"player_#{type}").from(true).to(false)
          end

          it "should set enemy_#{type}=true if enemy #{type} exist" do
            lambda do
              create_asset.call(@fse.solar_system, Factory.create(:player))
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(@fse, :"enemy_#{type}").from(false).to(true)
          end

          it "should set enemy_#{type}=false if there are NPC #{type}" do
            @fse.send("enemy_#{type}=", true)
            @fse.save!

            lambda do
              create_asset.call(@fse.solar_system, nil)
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(@fse, :"enemy_#{type}").to(false)
          end

          it "should set enemy_#{type}=false if enemy has no #{type}" do
            @fse.send("enemy_#{type}=", true)
            @fse.save!

            lambda do
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(@fse, :"enemy_#{type}").from(true).to(false)
          end

          it "should set nap_#{type}=nil" do
            @fse.send("nap_#{type}=", true)
            @fse.save!

            lambda do
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(
              @fse, :"nap_#{type}"
            ).from(true).to(nil)
          end

          it "should blank alliance_#{type.singularize}_player_ids" do
            @fse.send("alliance_#{type.singularize}_player_ids=", [1,2,3])
            @fse.save!

            lambda do
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(
              @fse, :"alliance_#{type.singularize}_player_ids"
            ).from([1,2,3]).to([])
          end
        end
      end

      describe "alliance entry" do
        before(:each) do
          # counter => 1 because we simulate other radar having this
          # SS under coverage
          @fse = Factory.create :fse_alliance, :counter => 1,
            :enemy_planets => false, :enemy_ships => false,
            :nap_planets => false, :nap_ships => false,
            :alliance_planet_player_ids => [],
            :alliance_ship_player_ids => []
          @alliance = @fse.alliance
          @nap_alliance = Factory.create :alliance
          @nap = Factory.create :nap, :initiator => @alliance,
            :acceptor => @nap_alliance, :status => Nap::STATUS_ESTABLISHED

          @player = Factory.create :player, :alliance => @alliance
          @ally = Factory.create :player, :alliance => @alliance
          @nap_player = Factory.create :player, :alliance => @nap_alliance
          @enemy = Factory.create :player
        end
        
        it_should_behave_like "fow ss entry recalculate"

        asset_types.each do |type, create_asset|
          alliance_accessor = "alliance_#{type.singularize}_player_ids"

          it "should set #{alliance_accessor} if " +
          "there are #{type} that belong to alliance" do
            create_asset.call(@fse.solar_system, @player)
            create_asset.call(@fse.solar_system, @ally)

            lambda do
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(@fse, alliance_accessor).from(false).to([
                @player.id, @ally.id
            ])
          end

          it "should set #{alliance_accessor} to " +
          "empty array if there are no #{type} that belong to alliance" do
            before = [1,2,3]
            @fse.send("#{alliance_accessor}=", before)
            @fse.save!

            lambda do
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(@fse, alliance_accessor).from(before).to([])
          end

          it "should set nap_#{type}=true if there are #{type} that" +
          "belong to nap" do
            create_asset.call(@fse.solar_system, @nap_player)

            lambda do
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(@fse, :"nap_#{type}").from(false).to(true)
          end

          it "should set nap_#{type}=false if there are no #{type} " +
          "that belong to nap" do
            @fse.send("nap_#{type}=", true)
            @fse.save!

            lambda do
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(@fse, :"nap_#{type}").from(true).to(false)
          end

          it "should set enemy_#{type}=true if there are #{type} that " +
          "belong to enemies" do
            create_asset.call(@fse.solar_system, @enemy)

            lambda do
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(@fse, :"enemy_#{type}").from(false).to(true)
          end

          it "should set enemy_#{type}=false if there are #{type} that" +
          "belong to npc" do
            @fse.send("enemy_#{type}=", true)
            @fse.save!

            lambda do
              create_asset.call(@fse.solar_system, nil)
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(@fse, :"enemy_#{type}").from(true).to(false)
          end

          it "should set enemy_#{type}=false if there are no #{type} that" +
          "belong to enemies" do
            @fse.send("enemy_#{type}=", true)
            @fse.save!

            lambda do
              FowSsEntry.recalculate(@fse.solar_system_id)
              @fse.reload
            end.should change(@fse, :"enemy_#{type}").from(true).to(false)
          end
        end
      end
    end

    describe ".merge_metadata" do
      before(:all) do
        @solar_system = Factory.create :solar_system
        @player = Factory.create :player,
          :alliance => Factory.create(:alliance)
        @fse_player = Factory.create :fse_player, :player => @player,
          :solar_system => @solar_system,
          :player_planets => true, :player_ships => true,
          :enemy_planets => true, :enemy_ships => true
        @fse_alliance = Factory.create :fse_alliance,
          :alliance => @player.alliance,
          :solar_system => @solar_system,
          :enemy_planets => false, :enemy_ships => false,
          :nap_planets => true, :nap_ships => true,
          :alliance_planet_player_ids => [@fse_player.player_id],
          :alliance_ship_player_ids => [@fse_player.player_id]
      end

      it "should include id if only player is present" do
        FowSsEntry.merge_metadata(@fse_player, nil)[:id].should ==
          @solar_system.id
      end

      it "should include id if only alliance is present" do
        FowSsEntry.merge_metadata(nil, @fse_alliance)[:id].should ==
          @solar_system.id
      end

      %w{planets ships}.each do |type|
        it "should take player_#{type} from player" do
          FowSsEntry.merge_metadata(@fse_player, @fse_alliance)[
            :"player_#{type}"
          ].should == @fse_player.send(:"player_#{type}")
        end

        it "should set player_#{type} to false if player is false" do
          FowSsEntry.merge_metadata(nil, @fse_alliance)[
            :"player_#{type}"
          ].should be_false
        end

        it "should take enemy_#{type} from alliance" do
          FowSsEntry.merge_metadata(@fse_player, @fse_alliance)[
            :"enemy_#{type}"
          ].should == @fse_alliance.send(:"enemy_#{type}")
        end

        it "should take enemy_#{type} from player if no alliance" do
          FowSsEntry.merge_metadata(@fse_player, nil)[
            :"enemy_#{type}"
          ].should == @fse_player.send(:"enemy_#{type}")
        end

        it "should take nap_#{type} from alliance" do
          FowSsEntry.merge_metadata(@fse_player, @fse_alliance)[
            :"nap_#{type}"
          ].should == @fse_alliance.send(:"nap_#{type}")
        end

        it "should set nap_#{type} to false if no alliance" do
          FowSsEntry.merge_metadata(@fse_player, nil)[
            :"nap_#{type}"
          ].should be_false
        end

        it "should set alliance_#{type} to false if we have no allies" do
          FowSsEntry.merge_metadata(@fse_player, @fse_alliance)[
            :"alliance_#{type}"
          ].should be_false
        end

        it "should set alliance_#{type} to true if we have allies" do
          @fse_alliance.send("alliance_#{type.singularize}_player_ids") <<
            @fse_player.player_id + 1

          FowSsEntry.merge_metadata(@fse_player, @fse_alliance)[
            :"alliance_#{type}"
          ].should be_true
        end

        it "should set alliance_#{type} to false if no alliance" do
          FowSsEntry.merge_metadata(@fse_player, nil)[
            :"alliance_#{type}"
          ].should be_false
        end
      end
    end
  end
end
