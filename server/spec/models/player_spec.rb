require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe Player do
  describe ".ratings" do
    before(:all) do
      ally = Factory.create(:player_for_ratings)
      @alliance = Factory.create(:alliance, :owner => ally,
        :galaxy => ally.galaxy)
      ally.alliance = @alliance
      ally.save!

      no_ally = Factory.create(:player_for_ratings,
        :galaxy => ally.galaxy)

      @players = [ally, no_ally]
      @result = Player.ratings(@alliance.galaxy_id)
    end

    (%w{id name victory_points alliance_vps planets_count} +
        Player::POINT_ATTRIBUTES).each do |attr|
      it "should include #{attr}" do
        @result.each_with_index do |row, index|
          row[attr].should == @players[index].send(attr)
        end
      end
    end

    it "should include alliance if player is in alliance" do
      @result[0]["alliance"].should equal_to_hash(
        "id" => @alliance.id, "name" => @alliance.name
      )
    end

    it "should say alliance is nil if player is not in alliance" do
      @result[1]["alliance"].should be_nil
    end

    it "should include online field" do
      dispatcher = mock(Dispatcher)
      Dispatcher.stub!(:instance).and_return(dispatcher)
      dispatcher.stub!(:connected?).with(@players[0].id).and_return(true)
      dispatcher.stub!(:connected?).with(@players[1].id).and_return(false)
      result = Player.ratings(@alliance.galaxy_id)
      result.map { |row| row["online"] }.should == [true, false]
    end

    it "should use condition if supplied" do
      id = @players[0].id
      Player.ratings(@alliance.galaxy_id,
        Player.where(:id => id))[0]["id"].should == id
    end
  end
  
  describe "#victory_points" do
    it "should add to alliance victory points too" do
      alliance = Factory.create(:alliance)
      player = Factory.create(:player, :alliance => alliance)
      player.victory_points += 100
      lambda do
        player.save!
        alliance.reload
      end.should change(alliance, :victory_points).by(100)
    end

    it "should add to #alliance_vps too" do
      alliance = Factory.create(:alliance)
      player = Factory.create(:player, :alliance => alliance)
      player.victory_points += 100
      lambda do
        player.save!
      end.should change(player, :alliance_vps).by(100)
    end
  end
  
  describe "#daily_bonus_available?" do
    it "should return true if #daily_bonus_at is nil" do
      Factory.build(:player, :daily_bonus_at => nil).daily_bonus_available?.
        should be_true
    end
    
    it "should return true if #daily_bonus_at is in past" do
      Factory.build(:player, :daily_bonus_at => 10.seconds.ago).
        daily_bonus_available?.should be_true
    end
    
    it "should return false if it's players first time" do
      Factory.build(:player, :daily_bonus_at => nil, :first_time => true).
        daily_bonus_available?.should be_false
    end
    
    it "should return false if #daily_bonus_at is in future" do
      Factory.build(:player, :daily_bonus_at => 10.seconds.from_now).
        daily_bonus_available?.should be_false
    end
  end
  
  describe "#set_next_daily_bonus" do
    it "should set to now + cooldown if previous value was nil" do
      player = Factory.build(:player)
      player.set_next_daily_bonus
      player.daily_bonus_at.should be_within(SPEC_TIME_PRECISION).of(
        CONFIG['daily_bonus.cooldown'].from_now
      )
    end
    
    it "should set to closest future date otherwise" do
      next_bonus = 24.minutes.from_now
      player = Factory.build(:player, :daily_bonus_at => 
           next_bonus - 10 * CONFIG['daily_bonus.cooldown'])
      player.set_next_daily_bonus
      player.daily_bonus_at.should be_within(SPEC_TIME_PRECISION).of(
        next_bonus
      )
    end
  end
  
  describe "vip mode" do
    describe "#vip?" do
      it "should return false if level is 0" do
        Factory.build(:player, :vip_level => 0).should_not be_vip
      end

      it "should return true if level > 0" do
        Factory.build(:player, :vip_level => 1).should be_vip
      end
    end
    
    describe "#market_creds" do
      it "should return #pure_creds - #free_creds" do
        Factory.build(:player, :pure_creds => 1000, :free_creds => 800).
          market_creds.should == 200
      end
    end
    
    describe "#market_creds=" do
      it "should set #pure_creds to value + #free_creds" do
        player = Factory.build(:player, :pure_creds => 100, 
          :free_creds => 800)
        lambda do
          player.market_creds -= 50
        end.should change(player, :pure_creds).by(-50)
      end
      
      it "should not change #free_creds" do
        player = Factory.build(:player, :pure_creds => 100, 
          :free_creds => 800)
        lambda do
          player.market_creds -= 50
        end.should_not change(player, :free_creds)
      end
    end

    describe "#creds" do
      it "should add #pure_creds and #vip_creds" do
        Factory.build(:player, :vip_level => 1,
          :vip_creds => 1000, :pure_creds => 500).creds.should == 1500
      end
    end
    
    describe "#creds=" do
      before(:each) do
        @player = Factory.build(:player, :vip_level => 1,
          :vip_creds => 1000, :pure_creds => 1000)
      end
      
      describe "earning" do
        it "should add to pure_creds" do
          lambda do
            @player.creds += 500
          end.should change(@player, :pure_creds).by(500)
        end
        
        it "should not change vip creds" do
          lambda do
            @player.creds += 500
          end.should_not change(@player, :vip_creds)
        end
        
        it "should not change free creds" do
          lambda do
            @player.creds += 500
          end.should_not change(@player, :free_creds)
        end
      end

      describe "spending" do
        it "should subtract from vip creds" do
          lambda do
            @player.creds -= 500
          end.should change(@player, :vip_creds).by(-500)
        end
        
        describe "when spending more than vip_creds" do
          it "should subtract from pure creds" do
            lambda do
              @player.creds -= @player.vip_creds + 200
            end.should change(@player, :pure_creds).by(-200)
          end

          it "should not go below 0 for vip creds" do
            lambda do
              @player.creds = 0
            end.should change(@player, :vip_creds).to(0)
          end
        end
      
        describe "having free creds" do
          before(:each) do
            @player.vip_creds = 100
            @player.free_creds = 500
          end
          
          it "should first not consider vip_creds as free_creds" do
            lambda do
              @player.creds -= 300
            end.should change(@player, :free_creds).by(-200)
          end
          
          it "should not set free_creds below 0" do
            lambda do
              @player.creds = 0
            end.should change(@player, :free_creds).to(0)
          end
        end
      end
    end

    describe "#vip_start!" do
      before(:each) do
        @vip_level = 1
        @creds_needed, @per_day, @duration =
          CONFIG['creds.vip'][@vip_level - 1]

        @player = Factory.create(:player, :creds => 10000 + @creds_needed)
      end

      it "should fail if already a vip" do
        @player.stub!(:vip?).and_return(true)
        lambda do
          @player.vip_start!(@vip_level)
        end.should raise_error(GameLogicError)
      end

      it "should reduce current creds" do
        @player.vip_start!(@vip_level)
        @player.creds.should == 10000 + @per_day
      end
      
      describe "with free creds" do
        before(:each) do
          @player.free_creds = @creds_needed / 2 + 1
        end
        
        it "should flag #vip_free if vip was bought with >=50% of them" do
          @player.vip_start!(@vip_level)
          @player.vip_free?.should be_true
        end

        it "should reduce them" do
          lambda do
            @player.vip_start!(@vip_level)
          end.should change(@player, :free_creds).to(0)
        end
      end

      it "should fail if not enough creds" do
        @player.creds = @creds_needed - 1

        lambda do
          @player.vip_start!(@vip_level)
        end.should raise_error(GameLogicError)
      end

      it "should write vip_until" do
        @player.vip_start!(@vip_level)
        @player.vip_until.should be_within(SPEC_TIME_PRECISION).of(
          @duration.from_now)
      end

      it "should add stop callback" do
        @player.vip_start!(@vip_level)
        @player.should have_callback(
          CallbackManager::EVENT_VIP_STOP,
          @duration.from_now
        )
      end

      it "should call #vip_tick!" do
        @player.should_receive(:vip_tick!)
        @player.vip_start!(@vip_level)
      end

      it "should register with cred stats" do
        should_record_cred_stats(
          :vip, [@player, @vip_level, @creds_needed]
        ) { @player.vip_start!(@vip_level) }
      end

      it "should progress objective" do
        Objective::BecomeVip.should_receive(:progress).with(@player)
        @player.vip_start!(@vip_level)
      end
    end

    describe "#vip_tick!" do
      before(:each) do
        vip_level = 1
        @creds_needed, @per_day = CONFIG['creds.vip'][vip_level - 1]
        @vip_creds = 345

        @player = Factory.create(:player, :creds => 1200,
          :vip_level => vip_level, :vip_creds => @vip_creds)
      end

      it "should fail if not a vip" do
        @player.stub!(:vip?).and_return(false)
        lambda do
          @player.vip_tick!
        end.should raise_error(GameLogicError)
      end

      it "should set vip_creds" do
        @player.vip_tick!
        @player.vip_creds.should == @per_day
      end

      it "should write vip_creds_until" do
        @player.vip_tick!
        @player.vip_creds_until.should \
          be_within(SPEC_TIME_PRECISION).of(1.day.from_now)
      end

      it "should add tick callback" do
        @player.vip_tick!
        @player.should have_callback(
          CallbackManager::EVENT_VIP_TICK,
          CONFIG['creds.vip.tick.duration'].from_now)
      end

      it "should add new batch of creds" do
        lambda do
          @player.vip_tick!
        end.should change(@player, :creds).
          to(@player.creds - @vip_creds + @per_day)
      end

      it "should reset vip creds counter" do
        lambda do
          @player.vip_tick!
        end.should change(@player, :vip_creds).to(@per_day)
      end
    end

    describe "#vip_stop!" do
      before(:each) do
        @player = Factory.create(:player, :pure_creds => 7000,
          :vip_creds => 3000, :vip_level => 1, :vip_until => Time.now,
          :vip_creds_until => 10.minutes.from_now, :vip_free => true)
        CallbackManager.register(@player, CallbackManager::EVENT_VIP_TICK,
          @player.vip_creds_until)
        CallbackManager.register(@player, CallbackManager::EVENT_VIP_STOP,
          @player.vip_until)
        @player.vip_stop!
      end

      it "should fail if not a vip" do
        @player.stub!(:vip?).and_return(false)
        lambda do
          @player.vip_tick!
        end.should raise_error(GameLogicError)
      end

      it "should unregister tick" do
        @player.should_not have_callback(CallbackManager::EVENT_VIP_TICK)
      end

      it "should unregister stop" do
        @player.should_not have_callback(CallbackManager::EVENT_VIP_STOP)
      end

      it "should remove vip creds" do
        @player.vip_creds.should == 0
      end

      it "should not touch pure creds" do
        @player.pure_creds.should == 7000
      end

      it "should remove vip level" do
        @player.vip_level.should == 0
      end

      it "should remove vip_creds_until" do
        @player.vip_creds_until.should be_nil
      end

      it "should remove vip_until" do
        @player.vip_until.should be_nil
      end
      
      it "should set #vip_free to false" do
        @player.vip_free?.should be_false
      end
    end

    describe "#vip_conversion_rate" do
      it "should raise error if vip_level is 0" do
        lambda do
          Factory.build(:player).vip_conversion_rate
        end.should raise_error(GameLogicError)
      end

      it "should return deal value + 0.5" do
        with_config_values 'creds.vip' => [[1000, 100, 10.days]] do
          Factory.build(:player, :vip_level => 1).vip_conversion_rate.
            should == (100 * 10 / 1000).round + 0.5
        end
      end
    end

    describe "#vip_convert" do
      it "should fail if given negative amount" do
        lambda do
          Factory.build(:player, :vip_level => 1).vip_convert(-1)
        end.should raise_error(GameLogicError)
      end

      it "should fail if player does not have enough vip creds" do
        lambda do
          Factory.build(:player, :vip_level => 1, :vip_creds => 100).
            vip_convert(101)
        end.should raise_error(GameLogicError)
      end
      
      describe "increasments" do
        before(:each) do
          @creds = 100; rate = 1.3
          @player = Factory.build(:player, :vip_level => 1, 
            :vip_creds => @creds, :pure_creds => 10000)
          @player.stub!(:vip_conversion_rate).and_return(rate)
          @converted = (@creds / rate).floor
        end

        it "should increase pure creds" do
          lambda do
            @player.vip_convert(@creds)
          end.should change(@player, :pure_creds).by(@converted)
        end

        it "should increase #free_creds if #vip_free is set" do
          @player.vip_free = true
          lambda do
            @player.vip_convert(@creds)
          end.should change(@player, :free_creds).by(@converted)
        end
      end
      
      it "should not increase #free_creds otherwise" do
        player = Factory.build(:player, :vip_level => 1, :vip_creds => 100)
        lambda do
          player.vip_convert(10)
        end.should_not change(player, :free_creds)
      end

      it "should reduce amount from vip creds" do
        player = Factory.build(:player, :vip_level => 1, :vip_creds => 100)
        lambda do
          player.vip_convert(10)
        end.should change(player, :vip_creds).by(-10)
      end
    end
    
    describe ".on_callback" do
      before(:each) do
        @player = Factory.create(:player)
        Player.stub!(:find).with(@player.id).and_return(@player)
      end

      it "should invoke #vip_tick! upon tick" do
        @player.should_receive(:vip_tick!)
        Player.on_callback(@player.id, CallbackManager::EVENT_VIP_TICK)
      end

      it "should invoke #vip_stop! upon stop" do
        @player.should_receive(:vip_stop!)
        Player.on_callback(@player.id, CallbackManager::EVENT_VIP_STOP)
      end
    end
  end

  describe "updating" do
    before(:each) do
      @dispatcher = mock(Dispatcher)
      Dispatcher.stub!(:instance).and_return(@dispatcher)
      @dispatcher.stub!(:connected?).and_return(false)
      @player = Factory.create(:player)
    end

    it "should update dispatcher if player is connected" do
      @dispatcher.should_receive(:connected?).with(@player.id).
        and_return(true)
      @dispatcher.should_receive(:update_player).with(@player)
      @player.creds += 1
      @player.save!
    end

    it "should not update dispatcher if player is disconnected" do
      @dispatcher.should_receive(:connected?).with(@player.id).
        and_return(false)
      @dispatcher.should_not_receive(:update_player)
      @player.creds += 1
      @player.save!
    end

    describe "when alliance id changes" do
      it "should update chat hub" do
        player = Factory.create(:player,
          :alliance => Factory.create(:alliance))
        player.alliance = Factory.create(:alliance)
        Chat::Pool.instance.hub_for(player).should_receive(
          :on_alliance_change).with(player)
        player.save!
      end

      it "should not update chat hub if alliance id does not change" do
        player = Factory.create(:player,
          :alliance => Factory.create(:alliance))
        player.creds += 1
        Chat::Pool.instance.hub_for(player).should_not_receive(
          :on_alliance_change)
        player.save!
      end
    end

    describe "when language changes" do
      it "should update chat hub" do
        player = Factory.create(:player)
        Chat::Pool.instance.hub_for(player).
          should_receive(:on_language_change).with(player)
        player.language = 'lt'
        player.save!
      end

      it "should not update chat hub if language does not change" do
        player = Factory.create(:player)
        Chat::Pool.instance.hub_for(player).
          should_not_receive(:on_language_change)
        player.creds += 1
        player.save!
      end
    end
  end

  it "should not allow creating two players in same galaxy" do
    p1 = Factory.create(:player)
    p2 = Factory.build(:player, :galaxy_id => p1.galaxy_id,
      :web_user_id => p1.web_user_id)
    lambda do
      p2.save!
    end.should raise_error(ActiveRecord::RecordNotUnique)
  end

  describe "#as_json" do
    before(:all) do
      @model = Factory.create(:player)
    end

    fields = Player.columns.map(&:name)

    describe ":minimal mode" do
      before(:all) do
        @options = {:mode => :minimal}
      end

      @required_fields = %w{id name}
      @ommited_fields = fields - @required_fields
      it_behaves_like "to json"
    end

    describe "normal mode" do
      @required_fields = %w{id name scientists scientists_total xp
        first_time economy_points army_points science_points war_points
        victory_points creds population population_cap planets_count
        alliance_id alliance_cooldown_ends_at
        free_creds vip_level vip_creds vip_until vip_creds_until}
      @ommited_fields = fields - @required_fields
      it_behaves_like "to json"

      describe "if in alliance" do
        before(:each) do
          @alliance = Factory.create(:alliance, :owner => @model)
          @model.alliance = @alliance
          @model.save!
        end

        describe "owner" do
          it "should include if he's alliance owner" do
            @model.as_json['alliance_owner'].should be_true
          end

          it "should include number of players" do
            @model.as_json['alliance_player_count'].should == 1
          end
        end

        describe "not owner" do
          before(:each) do
            @alliance.owner = Factory.create(:player)
            @alliance.save!
          end

          it "should include if he's owner" do
            @model.as_json['alliance_owner'].should be_false
          end

          it "should not include number of players" do
            @model.as_json['alliance_player_count'].should be_nil
          end
        end
      end
    end
  end

  describe "#population_max" do
    it "should return #population_cap if cap is smaller" do
      pop = Cfg.player_max_population - 1
      Factory.build(:player, :population_cap => pop).population_max.
        should == pop
    end
    
    it "should return max config population if cap is greater" do
      pop = Cfg.player_max_population + 1
      Factory.build(:player, :population_cap => pop).population_max.
        should == Cfg.player_max_population
    end
  end
  
  describe "#overpopulation_mod" do
    describe "normally populated" do
      it "should return 1" do
        Factory.build(:player, :population => 10).overpopulation_mod.
          should == 1
      end
    end
    
    describe "overpopulated" do
      it "should return ratio" do
        Factory.build(:player, :population => 35, :population_cap => 10).
          overpopulation_mod.should == (10.0 / 35)
      end
    end
  end
  
  describe "points" do
    point_types = %w{war_points army_points science_points economy_points}

    point_types.each do |type|
      it "should progress have points objective if #{type} changed" do
        player = Factory.create(:player)
        Objective::HavePoints.should_receive(:progress).with(player)
        player.send("#{type}=", player.send(type) + 100)
        player.save!
      end

      it "should be summed into #points" do
        player = Factory.create(:player, :war_points => 0)
        player.send("#{type}=", 10)
        player.points.should == 10
      end

      it "should not allow setting it below 0" do
        player = Factory.build(:player)
        player.send("#{type}=", -10)
        player.save!
        player.send(type).should == 0
      end
    end

    it "should not progress have points objective if xp is changed" do
      player = Factory.create(:player)
      Objective::HavePoints.should_not_receive(:progress)
      player.xp += 100
      player.save!
    end
  end

  (Player::OBJECTIVE_ATTRIBUTES - ["points"]).each do |attr|
    it "should progress #{attr} when it is changed" do
      player = Factory.create(:player)
      klass = "Objective::Have#{attr.camelcase}".constantize
      klass.should_receive(:progress).with(player)
      player.send("#{attr}=", player.send(attr) + 100)
      player.save!
    end
  end

  describe ".minimal" do
    before(:all) do
      @player = Factory.create(:player)
    end

    it "should return id" do
      Player.minimal(@player.id)["id"].should == @player.id
    end

    it "should return name" do
      Player.minimal(@player.id)["name"].should == @player.name
    end

    it "should return nil if id is nil" do
      Player.minimal(nil).should be_nil
    end
  end

  describe "#change_scientist_count!" do
    before(:each) do
      @player = Factory.create(:player)
    end

    describe "positive count" do
      before(:each) do
        @scientists = 10
      end

      it "should add scientists to player" do
        lambda do
          @player.change_scientist_count!(@scientists)
        end.should change(@player, :scientists).by(@scientists)
      end

      it "should add scientists_total to player" do
        lambda do
          @player.change_scientist_count!(@scientists)
        end.should change(@player, :scientists_total).by(@scientists)
      end
    end

    describe "negative count" do
      before(:each) do
        @scientists = -10
      end

      it "should subtract scientists from player" do
        lambda do
          @player.change_scientist_count!(@scientists)
        end.should change(@player, :scientists).by(@scientists)
      end

      it "should subtract scientists_total from player" do
        lambda do
          @player.change_scientist_count!(@scientists)
        end.should change(@player, :scientists_total).by(@scientists)
      end

      it "should call player.ensure_free_scientists!" do
        @player.should_receive(:ensure_free_scientists!).with(- @scientists)
        @player.change_scientist_count!(@scientists)
      end
    end
  end

  describe "#friendly_ids" do
    before(:all) do
      @alliance = Factory.create :alliance
      @you = Factory.create :player, :alliance => @alliance
      @ally = Factory.create :player, :alliance => @alliance
      @enemy = Factory.create :player
    end

    it "should include your id even if you're not in alliance" do
      @enemy.friendly_ids.should == [@enemy.id]
    end

    it "should include your id" do
      @you.friendly_ids.should include(@you.id)
    end

    it "should include ally id" do
      @you.friendly_ids.should include(@ally.id)
    end

    it "should not include enemy id" do
      @you.friendly_ids.should_not include(@enemy.id)
    end
  end

  describe "#nap_ids" do
    before(:all) do
      @alliance = Factory.create :alliance
      @you = Factory.create :player, :alliance => @alliance
      @nap_alliance = Factory.create :alliance
      @nap = Factory.create(:nap, :initiator => @alliance,
        :acceptor => @nap_alliance)

      @nap_player = Factory.create :player, :alliance => @nap_alliance
      @enemy = Factory.create :player
    end

    it "should return [] if no naps" do
      @enemy.nap_ids.should == []
    end

    it "should include nap id" do
      @you.nap_ids.should include(@nap_player.id)
    end

    it "should not include enemy id" do
      @you.nap_ids.should_not include(@enemy.id)
    end

    it "should not include cancelled nap ids" do
      @nap.status = Nap::STATUS_CANCELED
      @nap.save!

      @you.nap_ids.should_not include(@nap_player.id)
    end
  end

  describe ".grouped_by_alliance" do
    it "should return hash of grouped players" do
      p1 = Factory.create :player
      p2 = Factory.create :player, :alliance => Factory.create(:alliance)
      p3 = Factory.create :player
      p4 = Factory.create :player, :alliance => p2.alliance
      p5 = Factory.create :player, :alliance => Factory.create(:alliance)

      Player.grouped_by_alliance(
        [p1.id, p2.id, p3.id, p4.id, p5.id]
      ).should == {
        p2.alliance_id => [p2, p4],
        p5.alliance_id => [p5],
        -1 => [p1],
        -2 => [p3]
      }
    end

    it "should support npc players" do
      p1 = Factory.create :player
      Player.grouped_by_alliance([p1.id, nil]).should == {
        -1 => [p1],
        -2 => [Combat::NPC]
      }
    end

    it "should support only npc player" do
      Player.grouped_by_alliance([nil]).should == {
        -1 => [Combat::NPC]
      }
    end
  end

  describe "destruction" do
    it "should set player_id to nil on planets" do
      player = Factory.create :player
      planet = Factory.create(:planet, :player => player)
      player.destroy
      planet.reload
      planet.player_id.should be_nil
    end

    it "should call control manager" do
      player = Factory.create :player
      ControlManager.instance.should_receive(:player_destroyed).with(player)
      player.destroy
    end

    it "should not call control manager if invoked from it" do
      player = Factory.create :player
      ControlManager.instance.should_not_receive(:player_destroyed)
      player.invoked_from_control_manager = true
      player.destroy
    end
    
    it "should disconnect player from dispatcher if he's connected" do
      player = Factory.create(:player)
      Dispatcher.instance.should_receive(:disconnect).
        with(player.id, Dispatcher::DISCONNECT_PLAYER_ERASED)
      player.destroy
    end

    describe "solar systems" do
      before(:each) do
        @player = Factory.create(:player)
        
        @shielded_ss = Factory.create(:solar_system, 
          opts_shielded(@player.id))
        Factory.create(:planet, :solar_system => @shielded_ss, 
          :player => @player)
        Factory.create(:planet, :solar_system => @shielded_ss, 
          :player => @player, :angle => 90)
        
        @unshielded_ss = Factory.create(:solar_system)
        
        Factory.create(:planet, :solar_system => @unshielded_ss, 
          :player => @player)
      end
      
      it "should turn shielded solar systems into dead stars" do
        lambda do
          @player.destroy
          @shielded_ss.reload
        end.should change(@shielded_ss, :kind).
          from(SolarSystem::KIND_NORMAL).to(SolarSystem::KIND_DEAD)
      end
      
      it "should not turn unshielded solar systems into dead stars" do
        lambda do
          @player.destroy
          @unshielded_ss.reload
        end.should_not change(@unshielded_ss, :kind)
      end
    end
  end

  describe "#ensure_free_scientists!" do
    describe "technologies" do
      before(:each) do
        @player = Factory.create :player, :scientists => 0
        # Scrambling and sorting to ensure that our code sorts things in a
        # right way
        @technologies = [
          Factory.create(:technology_upgrading_larger, :scientists => 1000,
            :player => @player),
          Factory.create(:technology_upgrading, :scientists => 60,
            :player => @player),
          Factory.create(:technology_upgrading_t2, :scientists => 20,
            :player => @player),
          Factory.create(:technology_upgrading_t3, :scientists => 40,
            :player => @player),
          Factory.create(:technology_upgrading_t4, :scientists => 80,
            :player => @player)
        ].sort_by { |technology| technology.scientists }
        @total_extras = @technologies.inject(0) do |sum, technology|
          sum + (technology.scientists - technology.scientists_min)
        end
      end

      describe "extras handling" do
        before(:each) do
          @extras = 10
        end

        it "should not change techs while there are with extras" do
          lambda do
            @player.ensure_free_scientists!(@extras)
            @technologies[0].reload
          end.should_not change(@technologies[0], :scientists)
        end

        it "should reduce extras in technologies" do
          lambda do
            @player.ensure_free_scientists!(@extras)
            @technologies[1].reload
          end.should change(@technologies[1], :scientists).by(-@extras)
        end

        it "should reduce to min scs if extras are not enough" do
          sc_min = @technologies[1].scientists_min
          extra_diff = @technologies[1].scientists - sc_min

          lambda do
            @player.ensure_free_scientists!(@extras + extra_diff)
            @technologies[1].reload
          end.should change(@technologies[1], :scientists).to(sc_min)
        end

        it "should reduce next technology if extras are not enough" do
          sc_min = @technologies[1].scientists_min
          extra_diff = @technologies[1].scientists - sc_min

          lambda do
            @player.ensure_free_scientists!(@extras + extra_diff)
            @technologies[2].reload
          end.should change(@technologies[2], :scientists).by(-@extras)
        end
      end

      describe "pausing" do
        it "should pause all technologies starting from the one with least" +
        " scientists" do
          @player.ensure_free_scientists!(@total_extras +
              @technologies[0].scientists_min)

          @technologies[0].reload
          @technologies[0].should be_paused
          @player.scientists.should == 340
        end

        it "should pause until required number of scientists are freed" do
          @player.ensure_free_scientists!(@total_extras +
              @technologies[0].scientists_min +
              @technologies[1].scientists_min)

          @player.scientists.should == 360
          @technologies[0].reload
          @technologies[0].should be_paused
          @technologies[1].reload
          @technologies[1].should be_paused
          @technologies[2].reload
          @technologies[2].should be_upgrading
        end
      end

      describe "unpausing" do
        it "should try to unpause technologies starting with the one with" +
        " most scientists" do
          @player.ensure_free_scientists!(@total_extras +
              @technologies[4].scientists_min)

          @player.scientists.should == 1120
          @technologies[0].reload
          @technologies[0].should be_upgrading
          @technologies[1].reload
          @technologies[1].should be_upgrading
          @technologies[2].reload
          @technologies[2].should be_upgrading
          @technologies[3].reload
          @technologies[3].should be_upgrading
          @technologies[4].reload
          @technologies[4].should be_paused
        end

        it "should leave unused scientists" do
          free_scientists = 5
          @player.ensure_free_scientists!(@total_extras +
              @technologies[0].scientists_min - free_scientists)

          @player.scientists.should == 340
          @technologies[0].reload
          @technologies[0].should be_paused
        end
      end

      it "should try to rewind extras state if possible" do
        @player.ensure_free_scientists! 560

        @player.scientists.should == 1000
        @technologies[0].reload
        @technologies[0].should be_upgrading
        @technologies[0].scientists.should == 20
        @technologies[1].reload
        @technologies[1].should be_upgrading
        @technologies[1].scientists.should == 40
        @technologies[2].reload
        @technologies[2].should be_upgrading
        @technologies[2].scientists.should == 60
        @technologies[3].reload
        @technologies[3].should be_upgrading
        @technologies[3].scientists.should == 80
        @technologies[4].reload
        @technologies[4].should be_paused
      end

      it "should dispatch changed technologies" do
        Reducer::ScientistsReducer.stub!(:reduce).and_return([
          [@technologies[0], Reducer::CHANGED, 20],
          [@technologies[3], Reducer::CHANGED, 30],
        ])
        should_fire_event([@technologies[0], @technologies[3]],
            EventBroker::CHANGED) do
          @player.ensure_free_scientists! 20
        end
      end

      it "should not crash if there are no changes" do
        Reducer::ScientistsReducer.stub!(:reduce).and_return([])
        EventBroker.should_not_receive(:fire)
        @player.ensure_free_scientists! 20
      end

      it "should not do anything is enough scientists are available" do
        player = Factory.create :player, :scientists => 100
        technology = Factory.create(:technology_upgrading_larger,
          :scientists => 1000,
          :player => player)

        player.ensure_free_scientists! 80
        player.scientists.should == 100

        technology.reload
        technology.scientists.should == 1000
      end
    end

    describe "exploration" do
      before(:each) do
        @player = Factory.create(:player, :scientists => 100,
          :scientists_total => 100)
        x = 10; y = 15
        @planet = Factory.create(:planet, :player => @player)
        Factory.create(:t_folliage_6x6, :planet => @planet, :x => x,
          :y => y)
        @planet.explore!(x, y)
      end

      it "should cancel explorations if there is not enough scientists" do
        @player.ensure_free_scientists! 100
        @planet.reload
        @planet.should_not be_exploring
      end

      it "should not cancel exploration if it's possible to not to" do
        planet = Factory.create(:planet, :player => @player)
        x = 5; y = 2
        Factory.create(:t_folliage_3x3, :planet => planet, :x => x, :y => y)
        planet.explore!(x, y)
        ensured = 100 - planet.exploration_scientists
        @player.ensure_free_scientists!(ensured)
        planet.reload
        planet.should be_exploring
      end

      it "should correctly free scientists" do
        @player.ensure_free_scientists! 100
        @player.scientists.should == 100
      end
    end
  end

  describe "notifier" do
    it_behaves_like "notifier",
                    :build => lambda { Factory.build(:player) },
                    :change => lambda { |player| player.scientists += 1 },
                    :notify_on_create => false, :notify_on_destroy => false
  end
end
