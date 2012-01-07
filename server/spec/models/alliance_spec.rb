require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Alliance do
  describe "web integration" do
    describe "regular" do
      let(:alliance) { Factory.create(:alliance) }

      it "should integrate upon create" do
        alliance = Factory.build(:alliance)
        ControlManager.instance.should_receive(:alliance_created).
          with(alliance)
        alliance.save!
      end

      it "should integrate upon rename" do
        alliance.name = "WOO WOO WOO"
        ControlManager.instance.should_receive(:alliance_renamed).
          with(alliance)
        alliance.save!
      end

      it "should integrate upon destroy" do
        ControlManager.instance.should_receive(:alliance_destroyed).
          with(alliance)
        alliance.destroy
      end
    end

    describe "dev galaxy" do
      let(:galaxy) { Factory.create(:galaxy, :ruleset => 'dev') }
      let(:alliance) { Factory.create(:alliance, :galaxy => galaxy) }

      it "should integrate upon create" do
        alliance = Factory.build(:alliance, :galaxy => galaxy)
        ControlManager.instance.should_not_receive(:alliance_created)
        alliance.save!
      end

      it "should integrate upon rename" do
        alliance.name = "WOO WOO WOO"
        ControlManager.instance.should_not_receive(:alliance_renamed)
        alliance.save!
      end

      it "should integrate upon destroy" do
        ControlManager.instance.should_not_receive(:alliance_destroyed)
        alliance.destroy
      end
    end
  end

  describe "finishing galaxy" do
    let(:alliance) { Factory.create(:alliance) }

    it "should check it if vps were updated" do
      alliance.victory_points += 100
      alliance.galaxy.should_receive(:check_if_finished!).
        with(alliance.victory_points)
      alliance.save!
    end

    it "should not check it if vps were not updated" do
      alliance.name += "a"
      alliance.galaxy.should_not_receive(:check_if_finished!)
      alliance.save!
    end
  end

  describe "#as_json" do
    required_fields = %w{id name description victory_points owner_id}
    it_behaves_like "as json", Factory.create(:alliance), nil,
                    required_fields,
                    Alliance.columns.map(&:name) - required_fields
  end
  
  describe "#player_ratings" do
    it "should call Player.ratings" do
      alliance = Factory.create(:alliance)
      Player.should_receive(:ratings).with(alliance.galaxy_id,
        Player.where(:alliance_id => alliance.id)).and_return(:ratings)
      alliance.player_ratings.should == :ratings
    end
  end

  describe "#invitable_ratings" do
    it "should call Player.ratings" do
      alliance = Factory.create(:alliance)
      Alliance.should_receive(:visible_enemy_player_ids).with(alliance.id).
        and_return(:player_ids)
      Player.should_receive(:ratings).with(
        alliance.galaxy_id,
        Player.where(:id => :player_ids)
      ).and_return(:ratings)
      alliance.invitable_ratings.should == :ratings
    end
  end

  describe "#name" do
    before(:each) do
      @min = CONFIG['alliances.validation.name.length.min']
      @max = CONFIG['alliances.validation.name.length.max']
      @model = Factory.build(:alliance)
    end

    it_behaves_like "name validation"
  end

  describe "players relation" do
    describe "on destroy" do
      before(:each) do
        @alliance = Factory.create(:alliance)
        @player = Factory.create(:player, :alliance => @alliance)
      end

      it "should nullify Player#alliance_id" do
        @alliance.destroy
        @player.reload
        @player.alliance.should be_nil
      end

      it "should dispatch changed" do
        should_fire_event([@player], EventBroker::CHANGED) do
          @alliance.destroy
        end
      end
    end
  end

  describe ".ratings" do
    before(:all) do
      @g = (1..2).map { Factory.create(:galaxy) }

      @a = (1..2).map { Factory.create(:alliance, :galaxy => @g[0]) } +
        [Factory.create(:alliance, :galaxy => @g[1])]

      # Should not be included in stats.
      Factory.create(:player_for_ratings, :galaxy => @g[1],
        :alliance => @a[2])
      # No stats because no alliance.
      Factory.create(:player_for_ratings, :galaxy => @g[0])

      # Included players
      @a0_players = [
        Factory.create(:player_for_ratings, :galaxy => @g[0],
          :alliance => @a[0]),
        Factory.create(:player_for_ratings, :galaxy => @g[0],
          :alliance => @a[0]),
        Factory.create(:player_for_ratings, :galaxy => @g[0],
          :alliance => @a[0]),
      ]
      @a1_players = [
        Factory.create(:player_for_ratings, :galaxy => @g[0],
          :alliance => @a[1]),
        Factory.create(:player_for_ratings, :galaxy => @g[0],
          :alliance => @a[1])
      ]

      @ratings = Alliance.ratings(@g[0].id)
    end

    it "should not include alliances from other galaxy" do
      @ratings.find { |h| h['alliance_id'] == @a[2].id }.should be_nil
    end

    it "should not include not allied players" do
      @ratings.find { |h| h['alliance_id'].nil? }.should be_nil
    end

    (Player::POINT_ATTRIBUTES + %w{planets_count bg_planets_count}).each do
      |attr|

      it "should sum #{attr}" do
        @ratings.map_into_hash do |hash|
          [hash['alliance_id'], hash[attr.to_s]]
        end.should equal_to_hash(
          @a[0].id => @a0_players.map { |p| p.send(attr) }.sum,
          @a[1].id => @a1_players.map { |p| p.send(attr) }.sum
        )
      end

      it "should be Fixnums" do
        @ratings.each do |hash|
          hash[attr.to_s].should be_instance_of(Fixnum)
        end
      end
    end

    it "should include alliance name" do
      @ratings.map_into_hash do |hash|
        [hash['alliance_id'], hash['name']]
      end.should equal_to_hash(
        @a[0].id => @a[0].name,
        @a[1].id => @a[1].name
      )
    end

    it "should include alliance player count" do
      @ratings.map_into_hash do |hash|
        [hash['alliance_id'], hash['players_count']]
      end.should equal_to_hash(
        @a[0].id => @a0_players.size,
        @a[1].id => @a1_players.size
      )
    end

    it "should include alliance victory points" do
      @ratings.map_into_hash do |hash|
        [hash['alliance_id'], hash['victory_points']]
      end.should equal_to_hash(
        @a[0].id => @a[0].victory_points,
        @a[1].id => @a[1].victory_points
      )
    end
  end

  describe ".player_ids_for" do
    it "should return player ids" do
      alliance = Factory.create(:alliance)
      p1 = Factory.create :player, :alliance => alliance
      p2 = Factory.create :player, :alliance => alliance
      Factory.create :player
      p4 = Factory.create :player, :alliance => alliance

      Alliance.player_ids_for(alliance.id).sort.should == [
        p1.id, p2.id, p4.id
      ].sort
    end
  end

  describe ".names_for" do
    it "should return hash" do
      alliance = Factory.create(:alliance)
      Alliance.names_for([alliance.id]).should == {alliance.id => alliance.name}
    end
  end

  describe ".visible_enemy_player_ids" do
    it "should include enemy player ids where they have planets" do
      fse = Factory.create(:fse_alliance, :enemy_planets => true,
                           :enemy_ships => false)
      planet = Factory.create(:planet_with_player,
                              :solar_system => fse.solar_system)
      Alliance.visible_enemy_player_ids(fse.alliance_id).
        should include(planet.player_id)
    end

    it "should not include enemy player ids where they have units" do
      fse = Factory.create(:fse_alliance, :enemy_planets => false,
                           :enemy_ships => true)
      unit = Factory.create(:u_crow,
        :location => SolarSystemPoint.new(fse.solar_system_id, 0, 0)
      )
      Alliance.visible_enemy_player_ids(fse.alliance_id).
        should_not include(unit.player_id)
    end

    it "should not include allies even if they share same ss with enemy" do
      fse = Factory.create(:fse_alliance, :enemy_planets => true,
                           :enemy_ships => false)
      Factory.create(:planet_with_player, :solar_system => fse.solar_system)
      ally = Factory.create(:player, :alliance => fse.alliance)
      Factory.create(:planet, :player => ally,
                     :solar_system => fse.solar_system, :position => 1)
      Alliance.visible_enemy_player_ids(fse.alliance_id).
        should_not include(ally.id)
    end

    it "should return unique set" do
      fse = Factory.create(:fse_alliance, :enemy_planets => true,
                           :enemy_ships => false)
      player = Factory.create(:player)
      Factory.create(:planet, :player => player,
                     :solar_system => fse.solar_system)
      Factory.create(:planet, :player => player,
                     :solar_system => fse.solar_system, :position => 1)
      ids = Alliance.visible_enemy_player_ids(fse.alliance_id)
      ids.should == ids.uniq
    end
  end

  describe ".visible_enemy_alliance_ids" do
    let(:alliance_id) { 10 }

    it "should return unique set" do
      alliance1 = Factory.create(:alliance)
      alliance2 = Factory.create(:alliance)
      players = [
        Factory.create(:player, :alliance => alliance1),
        Factory.create(:player, :alliance => alliance2),
        Factory.create(:player, :alliance => alliance1)
      ]

      Alliance.should_receive(:visible_enemy_player_ids).with(alliance_id).
        and_return(players.map(&:id))
      Alliance.visible_enemy_alliance_ids(alliance_id).
        should == [alliance1.id, alliance2.id]
    end

    it "should not include nils" do
      players = [Factory.create(:player)]

      Alliance.should_receive(:visible_enemy_player_ids).with(alliance_id).
        and_return(players.map(&:id))
      Alliance.visible_enemy_alliance_ids(alliance_id).should == []
    end
  end

  describe "#naps" do
    before(:all) do
      @model = Factory.create :nap
    end

    it "should find by initiator_id" do
      @model.initiator.naps.should include(@model)
    end

    it "should find by acceptor_id" do
      @model.acceptor.naps.should include(@model)
    end
  end

  describe "#full?" do
    it "should return true if alliance have reached max players" do
      alliance = Factory.create(:alliance)
      (alliance.technology.max_players - alliance.players.size).times do
        Factory.create(:player, :alliance => alliance)
      end
      alliance.reload

      alliance.should be_full
    end

    it "should return false if alliance have reached max players" do
      alliance = Factory.create(:alliance)
      alliance.should_not be_full
    end
  end

  describe "#accept" do
    before(:each) do
      @alliance = Factory.create :alliance
      @player = Factory.create :player
    end

    it "should raise GameLogicError if already in alliance" do
      @player.alliance = Factory.create(:alliance)
      lambda do
        @alliance.accept(@player)
      end.should raise_error(GameLogicError)
    end

    it "should update player alliance" do
      lambda do
        @alliance.accept(@player)
        @player.reload
      end.should change(@player, :alliance).from(nil).to(@alliance)
    end

    it "should reset Player#alliance_vps to 0" do
      @player.alliance_vps = 1000
      lambda do
        @alliance.accept(@player)
        @player.reload
      end.should change(@player, :alliance_vps).to(0)
    end

    it "should assimilate player Galaxy cache" do
      FowGalaxyEntry.should_receive(:assimilate_player).with(
        @alliance, @player)
      @alliance.accept(@player)
    end

    it "should assimilate player SS cache" do
      FowSsEntry.should_receive(:assimilate_player).with(
        @alliance, @player)
      @alliance.accept(@player)
    end

    it "should integrate with web" do
      ControlManager.instance.should_receive(:player_joined_alliance).
        with(@player, @alliance)
      @alliance.accept(@player)
    end
    
    it "should not call control manager if we're accepting alliance owner" do
      ControlManager.instance.should_not_receive(:player_joined_alliance)
      @alliance.accept(@alliance.owner)
    end

    it "should not call control manager if we're in a dev galaxy" do
      @alliance.galaxy.ruleset = 'dev'
      @alliance.galaxy.save!
      ControlManager.instance.should_not_receive(:player_joined_alliance)
      @alliance.accept(@player)
    end

    it "should dispatch changed for alliance owner" do
      should_fire_event(@alliance.owner, EventBroker::CHANGED) do
        @alliance.accept(@player)
      end
    end
    
    it "should dispatch changed with Event::StatusChange" do
      should_fire_event(
        Event::StatusChange::Alliance.new(@alliance, @player,
          Event::StatusChange::Alliance::ACCEPT),
        EventBroker::CHANGED
      ) do
        @alliance.accept(@player)
      end
    end
  end

  describe "#throw_out" do
    before(:each) do
      @alliance = Factory.create :alliance
      @player = Factory.create :player, :alliance => @alliance
    end

    it "should raise GameLogicError if not in alliance" do
      @player.alliance = nil
      lambda do
        @alliance.throw_out(@player)
      end.should raise_error(GameLogicError)
    end

    it "should raise GameLogicError if in another alliance" do
      @player.alliance = Factory.create(:alliance)
      lambda do
        @alliance.throw_out(@player)
      end.should raise_error(GameLogicError)
    end

    it "should update player alliance" do
      lambda do
        @alliance.throw_out(@player)
        @player.reload
      end.should change(@player, :alliance).from(@alliance).to(nil)
    end

    it "should throw out player Galaxy cache" do
      FowGalaxyEntry.should_receive(:throw_out_player).with(
        @alliance, @player)
      @alliance.throw_out(@player)
    end

    it "should throw out player SS cache" do
      FowSsEntry.should_receive(:throw_out_player).with(
        @alliance, @player)
      @alliance.throw_out(@player)
    end

    it "should integrate with web" do
      ControlManager.instance.should_receive(:player_left_alliance).
        with(@player, @alliance)
      @alliance.throw_out(@player)
    end

    it "should not integrate with web if dev galaxy" do
      @alliance.galaxy.ruleset = 'dev'
      @alliance.galaxy.save!

      ControlManager.instance.should_not_receive(:player_left_alliance)
      @alliance.throw_out(@player)
    end

    it "should check player locations" do
      Combat::LocationChecker.should_receive(:check_player_locations).
        with(@player)
      @alliance.throw_out(@player)
    end

    it "should dispatch changed for alliance owner" do
      should_fire_event(@alliance.owner, EventBroker::CHANGED) do
        @alliance.throw_out(@player)
      end
    end
    
    it "should dispatch changed with Event::StatusChange" do
      should_fire_event(
        Event::StatusChange::Alliance.new(@alliance, @player,
          Event::StatusChange::Alliance::THROW_OUT),
        EventBroker::CHANGED
      ) do
        @alliance.throw_out(@player)
      end
    end
  end

  describe "#transfer_ownership!" do
    let(:alliance) do
      alliance = create_alliance
      (Technology::Alliances.max_players(2) - 1).times do
        Factory.create(:player, :alliance => alliance)
      end
      alliance
    end
    let(:player) { alliance.players.last }
    let(:technology) do
      Factory.create!(:t_alliances, :player => player, :level => 2)
    end

    before(:each) { technology() }

    it "should fail if trying to transfer to same player" do
      lambda do
        alliance.transfer_ownership!(alliance.owner)
      end.should raise_error(GameLogicError)
    end

    it "should fail if player is not from same alliance" do
      player.alliance = Factory.create(:alliance)
      lambda do
        alliance.transfer_ownership!(player)
      end.should raise_error(GameLogicError)
    end

    it "should fail if player does not have alliances technology" do
      technology.destroy
      lambda do
        alliance.transfer_ownership!(player)
      end.should raise_error(Alliance::TechnologyLevelTooLow)
    end

    it "should fail if player does not have sufficient technology level" do
      technology.level -= 1
      technology.save!
      lambda do
        alliance.transfer_ownership!(player)
      end.should raise_error(Alliance::TechnologyLevelTooLow)
    end

    it "should change alliance owner" do
      lambda do
        alliance.transfer_ownership!(player)
        alliance.reload
      end.should change(alliance, :owner).from(alliance.owner).to(player)
    end

    it "should create notifications for all alliance members" do
      as_json = alliance.as_json(:mode => :minimal)
      old_owner = alliance.owner.as_json(:mode => :minimal)
      new_owner = player.as_json(:mode => :minimal)
      alliance.member_ids.each do |member_id|
        Notification.should_receive(:create_for_alliance_owner_changed).with(
          member_id, as_json, old_owner, new_owner
        )
      end

      alliance.transfer_ownership!(player)
    end

    it "should notify web about changed owner"
  end

  describe "#take_over!" do
    let(:player) { Factory.build(:player) }
    let(:owner) do
      Factory.build(:player, :last_seen =>
        (Cfg.alliance_take_over_owner_inactivity_time + 1.minute).ago
      )
    end
    let(:alliance) { Factory.build(:alliance, :owner => owner) }

    it "should fail if owner is still considered active" do
      alliance.owner.last_seen =
        (Cfg.alliance_take_over_owner_inactivity_time - 1.minute).ago

      lambda do
        alliance.take_over!(player)
      end.should raise_error(GameLogicError)
    end

    it "should call #transfer_ownership!" do
      alliance.should_receive(:transfer_ownership!).with(player)
      alliance.take_over!(player)
    end
  end
end
