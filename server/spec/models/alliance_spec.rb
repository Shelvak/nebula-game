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
        should_fire_event(@alliance.players.all, EventBroker::CHANGED) do
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
        @a[0].owner,
        Factory.create(:player_for_ratings, :galaxy => @g[0],
          :alliance => @a[0]),
        Factory.create(:player_for_ratings, :galaxy => @g[0],
          :alliance => @a[0]),
        Factory.create(:player_for_ratings, :galaxy => @g[0],
          :alliance => @a[0]),
      ]
      @a1_players = [
        @a[1].owner,
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

  describe ".alliance_ids_for" do
    let(:ally1) { create_alliance.owner }
    let(:ally2) { create_alliance.owner }
    let(:non_ally1) { Factory.create(:player) }
    let(:non_ally2) { Factory.create(:player) }
    let(:player_ids) { [ally1.id, non_ally1.id, ally2.id, non_ally2.id] }
    let(:alliance_ids) { [ally1.alliance_id, ally2.alliance_id] }

    it "should return alliance ids for given players" do
      Alliance.alliance_ids_for(player_ids).should == alliance_ids
    end

    it "should not include nils" do
      Alliance.alliance_ids_for(player_ids).should_not include(nil)
    end

    it "should return empty array if all players are not in alliance" do
      Alliance.alliance_ids_for([non_ally1.id, non_ally2.id]).should == []
    end

    it "should return distinct values" do
      Alliance.alliance_ids_for([ally1.id, ally2.id, ally1.id]).
        should == alliance_ids
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
        alliance.owner.id, p1.id, p2.id, p4.id
      ].sort
    end

    it "should return empty array given empty player ids" do
      Alliance.player_ids_for([]).should == []
    end
  end

  describe ".names_for" do
    it "should return hash" do
      alliance = Factory.create(:alliance)
      Alliance.names_for([alliance.id]).should == {alliance.id => alliance.name}
    end

    it "should not mix up names if ids are not ordered" do
      alliances = [
        Factory.create(:alliance),
        Factory.create(:alliance)
      ]
      alliance_ids = alliances.map(&:id).reverse
      expected = alliances.each_with_object({}) do |alliance, hash|
        hash[alliance.id] = alliance.name
      end
      Alliance.names_for(alliance_ids).should equal_to_hash(expected)
    end
  end

  describe ".visible_enemy_player_ids" do
    let(:alliance) { create_alliance }
    let(:galaxy) { alliance.galaxy }
    let(:player) { alliance.owner }
    let(:ally) { Factory.create(:player, alliance: alliance, galaxy: galaxy) }
    let(:ss) { Factory.create(:solar_system, galaxy: galaxy) }
    let(:enemy) { Factory.create(:player, galaxy: galaxy) }

    it "should include enemy player ids where they have planets" do
      planet = Factory.create(:planet_with_player, solar_system: ss)
      Factory.create(:planet, solar_system: ss, player: player, angle: 90)
      Alliance.visible_enemy_player_ids(alliance.id).
        should include(planet.player_id)
    end

    it "should include enemy player ids in home ss" do
      home_ss = enemy.home_solar_system
      Factory.create(:fge, galaxy: galaxy, player: player, rectangle:
        Rectangle.new(home_ss.x, home_ss.y, home_ss.x + 1, home_ss.y + 1))
      Factory.create(:planet, player: enemy, solar_system: home_ss)
      Alliance.visible_enemy_player_ids(alliance.id).should include(enemy.id)
    end

    it "should not include enemy player ids where they have units" do
      location = SolarSystemPoint.new(ss.id, 0, 0)
      Factory.create(:planet, player: player, solar_system: ss)
      unit = Factory.create(:u_crow, location: location)
      Alliance.visible_enemy_player_ids(alliance.id).
        should_not include(unit.player_id)
    end

    it "should not include allies even if they share same ss with enemy" do
      Factory.create(:planet, player: enemy, solar_system: ss)
      Factory.create(:planet, player: ally, solar_system: ss, angle: 90)
      Alliance.visible_enemy_player_ids(alliance.id).should_not include(ally.id)
    end

    it "should return unique set" do
      Factory.create(:planet, player: enemy, solar_system: ss)
      Factory.create(:planet, player: enemy, solar_system: ss, angle: 90)
      Factory.create(:planet_with_player, solar_system: ss, angle: 180)
      Factory.create(:planet, player: player, solar_system: ss, angle: 270)
      ids = Alliance.visible_enemy_player_ids(alliance.id)
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

    it "should integrate with web" do
      ControlManager.instance.should_receive(:player_joined_alliance).
        with(@player, @alliance)
      @alliance.accept(@player)
    end
    
    it "should not call control manager if we're accepting alliance owner" do
      # Ensure player is not in alliance.
      player = @alliance.owner
      player.alliance = nil

      ControlManager.instance.should_not_receive(:player_joined_alliance)
      @alliance.accept(player)
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

  describe "#kick" do
    let(:alliance) { create_alliance }
    let(:player) { Factory.create(:player, :alliance => alliance) }

    it "should throw player out from alliance" do
      alliance.should_receive(:throw_out).with(player)
      alliance.kick(player)
    end

    it "should set alliance cooldown" do
      alliance.kick(player)
      player.reload.alliance_cooldown_ends_at.
        should be_within(SPEC_TIME_PRECISION).
                 of(Cfg.alliance_leave_cooldown.from_now)
    end

    it "should set alliance cooldown id" do
      alliance.kick(player)
      player.reload.alliance_cooldown_id.should == alliance.id
    end

    it "should create notification" do
      Notification.should_receive(:create_for_kicked_from_alliance).
        with(alliance, player)
      alliance.kick(player)
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

    it "should notify web about changed owner" do
      ControlManager.instance.should_receive(:alliance_owner_changed).
        with(alliance, player)
      alliance.transfer_ownership!(player)
    end
  end

  describe "#resign_ownership!" do
    let(:tech_level) { 2 }
    let(:alliance) do
      alliance = create_alliance
      (Technology::Alliances.max_players(tech_level)).times do
        Factory.create(:player, :alliance => alliance)
      end
      alliance
    end
    let(:new_owner) { alliance.players.last }
    let(:technology) do
      Factory.create!(:t_alliances, :player => new_owner, :level => tech_level)
    end

    before(:each) { technology() }

    it "should raise exception if no successor is found" do
      technology.destroy!
      lambda do
        alliance.resign_ownership!
      end.should raise_error(Alliance::NoSuccessorFound)
    end

    it "should transfer ownership" do
      lambda do
        alliance.resign_ownership!
        alliance.reload
      end.should change(alliance, :owner).from(alliance.owner).to(new_owner)
    end

    it "should transfer ownership to player who has most victory points" do
      new_owner.victory_points = 10000
      new_owner.save!

      player = alliance.players[-2]
      Factory.create!(:t_alliances, :player => player, :level => tech_level)
      player.victory_points = 5000
      player.save!

      lambda do
        alliance.resign_ownership!
        alliance.reload
      end.should change(alliance, :owner).from(alliance.owner).to(new_owner)
    end

    it "should throw old owner out" do
      old_owner_id = alliance.owner_id
      alliance.resign_ownership!
      alliance.member_ids.should_not include(old_owner_id)
    end
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
