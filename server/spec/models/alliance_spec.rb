require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Alliance do
  describe "web integration" do
    it "should integrate upon create" do
      alliance = Factory.build(:alliance)
      ControlManager.instance.should_receive(:alliance_created).
        with(alliance)
      alliance.save!
    end

    it "should integrate upon rename" do
      alliance = Factory.create(:alliance)
      alliance.name = "WOO WOO WOO"
      ControlManager.instance.should_receive(:alliance_renamed).
        with(alliance)
      alliance.save!
    end

    it "should integrate upon destroy" do
      alliance = Factory.create(:alliance)
      ControlManager.instance.should_receive(:alliance_destroyed).
        with(alliance)
      alliance.destroy
    end
  end

  describe "#as_json" do
    before(:all) do
      @model = Factory.create(:alliance)
    end
    
    @required_fields = %w{id name description victory_points owner_id}
    @ommited_fields = Alliance.columns.map(&:name) - @required_fields
    
    it_should_behave_like "to json"
  end
  
  describe "#player_ratings" do
    it "should call Player.ratings" do
      alliance = Factory.create(:alliance)
      Player.should_receive(:ratings).with(alliance.galaxy_id,
        Player.where(:alliance_id => alliance.id)).and_return(:ratings)
      alliance.player_ratings.should == :ratings
    end
  end

  describe "#name" do
    before(:each) do
      @min = CONFIG['alliances.validation.name.length.min']
      @max = CONFIG['alliances.validation.name.length.max']
      @model = Factory.build(:alliance)
    end

    it_should_behave_like "name validation"
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

    (Player::POINT_ATTRIBUTES + %w{victory_points planets_count}).each do
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
      Alliance.names_for([alliance.id]).should == {
        alliance.id => alliance.name
      }
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

    it "should dispatch changed for alliance owner" do
      should_fire_event(@alliance.owner, EventBroker::CHANGED) do
        @alliance.accept(@player)
      end
    end
    
    it "should dispatch changed with StatusChangeEvent" do
      should_fire_event(
        StatusChangeEvent::Alliance.new(@alliance, @player, 
          StatusChangeEvent::Alliance::ACCEPT), 
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
    
    it "should dispatch changed with StatusChangeEvent" do
      should_fire_event(
        StatusChangeEvent::Alliance.new(@alliance, @player,
          StatusChangeEvent::Alliance::THROW_OUT), 
        EventBroker::CHANGED
      ) do
        @alliance.throw_out(@player)
      end
    end
  end
end
