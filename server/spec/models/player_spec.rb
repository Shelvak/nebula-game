require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe Player do
  describe ".ratings" do
    before(:all) do
      ally = Factory.create(:player_for_ratings, :last_seen => 10.minutes.ago)
      @alliance = Factory.create(:alliance, :owner => ally,
        :galaxy => ally.galaxy)
      ally.alliance = @alliance
      ally.save!

      no_ally = Factory.create(:player_for_ratings,
        :galaxy => ally.galaxy, :last_seen => 5.minutes.ago)
      not_logged_in = Factory.create(:player_for_ratings,
        :galaxy => ally.galaxy, :last_seen => nil)

      @players = [ally, no_ally, not_logged_in]
      @result = Player.ratings(@alliance.galaxy_id)
    end

    (
      %w{id name victory_points alliance_vps death_date last_seen} +
      Player::POINT_ATTRIBUTES
    ).each do |attr|
      it "should include #{attr}" do
        @result.each_with_index do |row, index|
          row[attr].should == @players[index].send(attr)
        end
      end
    end

    it "should set last_seen to true if currently online" do
      dispatcher = Celluloid::Actor[:dispatcher]
      dispatcher.stub!(:player_connected?).with(@players[0].id).
        and_return(true)
      dispatcher.stub!(:player_connected?).with(@players[1].id).
        and_return(false)
      dispatcher.stub!(:player_connected?).with(@players[2].id).
        and_return(false)
      result = Player.ratings(@alliance.galaxy_id)
      result.map { |row| row["last_seen"] }.
        should == [true, @players[1].last_seen, @players[2].last_seen]
    end

    it "should include alliance if player is in alliance" do
      @result[0]["alliance"].should equal_to_hash(
        "id" => @alliance.id, "name" => @alliance.name
      )
    end

    it "should say alliance is nil if player is not in alliance" do
      @result[1]["alliance"].should be_nil
    end

    it "should say vip=true if vip_level > 0" do
      player = @players[0]
      player.vip_level = 1; player.save!
      result = Player.ratings(@alliance.galaxy_id)
      result[0]['vip'].should be_true
    end

    it "should say vip=false if vip_level == 0" do
      player = @players[0]
      player.vip_level = 0; player.save!
      result = Player.ratings(@alliance.galaxy_id)
      result[0]['vip'].should be_false
    end

    it "should not include vip_level" do
      @result.any? { |r| r.has_key?('vip_level') }.should be_false
    end

    it "should use condition if supplied" do
      id = @players[0].id
      Player.ratings(@alliance.galaxy_id,
        Player.where(:id => id))[0]["id"].should == id
    end
  end

  describe ".names_for" do
    it "should return hash" do
      player = Factory.create(:player)
      Player.names_for([player.id]).should == {player.id => player.name}
    end
  end

  describe "#options" do
    let(:player) { Factory.create(:player) }

    it "should return PlayerOptions object" do
      PlayerOptions.should_receive(:find).with(player.id).and_return(:opts)
      player.options.should == :opts
    end

    it "should cache object between calls" do
      player.options
      PlayerOptions.should_not_receive(:find).with(player.id)
      player.options
    end

    it "should reload object if asked" do
      opts = player.options
      opts.data.chat_show_join_leave = ! opts.data.chat_show_join_leave?
      opts.save!

      player.options(true).should == opts
    end
  end

  describe "#victory_points" do
    let(:alliance) { Factory.create(:alliance) }
    let(:player) { Factory.create(:player, :alliance => alliance) }

    it "should add to alliance victory points too" do
      player.victory_points += 100
      lambda do
        player.save!
        alliance.reload
      end.should change(alliance, :victory_points).by(100)
    end

    it "should add to #alliance_vps too" do
      player.victory_points += 100
      lambda do
        player.save!
      end.should change(player, :alliance_vps).by(100)
    end

    describe "finished galaxy" do
      before(:each) do
        player.galaxy.apocalypse_start = 10.days.from_now
        player.galaxy.save!
      end

      it "should not increase #victory_points anymore" do
        lambda do
          player.victory_points += 100
          player.save!
          player.reload
        end.should_not change(player, :victory_points)
      end

      it "should not add to alliance victory points" do
        player.victory_points += 100
        lambda do
          player.save!
          alliance.reload
        end.should_not change(alliance, :victory_points)
      end

      it "should not add to #alliance_vps too" do
        player.victory_points += 100
        lambda do
          player.save!
          player.reload
        end.should_not change(player, :alliance_vps)
      end
    end
  end

  describe "on death" do
    let(:galaxy) { Factory.create(:galaxy, :apocalypse_start => 15.days.ago) }
    let(:player) do
      player = Factory.create(:player, :planets_count => 2, :pure_creds => 323,
        :bg_planets_count => 0, :galaxy => galaxy)
      player
    end

    describe "if #planets_count gets updated to 0" do
      before(:each) do
        player.planets_count = 0
      end

      it "should set #death_date" do
        player.save!
        player.reload
        player.death_date.should be_within(SPEC_TIME_PRECISION).of(Time.now)
      end

      it "should transfer player creds + apocalypse survival bonus to web" do
        ControlManager.instance.should_receive(:player_death).
          with(player, player.pure_creds +
                 Cfg.apocalypse_survival_bonus(player.galaxy.apocalypse_day))
        player.save!
      end

      it "should set #pure_creds to 0" do
        lambda do
          player.save!
        end.should change(player, :pure_creds).to(0)
      end

      it "should check if galaxy has ended" do
        player.galaxy.should_receive(:check_if_apocalypse_finished!)
        player.save!
      end
    end

    describe "if #planets_count does not get updated to 0" do
      before(:each) do
        player.planets_count = 1
      end

      it "should not set #death_date" do
        lambda do
          player.save!
          player.reload
        end.should_not change(player, :death_date)
      end

      it "should not change player creds" do
        lambda do
          player.save!
        end.should_not change(player, :creds)
      end

      it "should not transfer anything to web" do
        ControlManager.instance.should_not_receive(:player_death)
        player.save!
      end

      it "should not check if galaxy has ended" do
        player.galaxy.should_not_receive(:check_if_apocalypse_finished!)
        player.save!
      end
    end
  end

  describe "referral points" do
    let(:player) do
      Factory.create(
        :player, :war_points => Cfg.player_referral_points_needed - 1
      )
    end

    shared_examples_for "not invoking remote" do
      it "should not call ControlManager" do
        ControlManager.instance.
          should_not_receive(:player_referral_points_reached)
        player.save!
      end

      it "should not change #referral_submitted" do
        lambda do
          player.save!
        end.should_not change(player, :referral_submitted)
      end
    end

    describe "when enough points is collected" do
      before(:each) do
        player.economy_points += 1
      end

      it "should call ControlManager" do
        ControlManager.instance.
          should_receive(:player_referral_points_reached).with(player)
        player.save!
      end

      it "should set #referral_submitted" do
        lambda do
          player.save!
        end.should change(player, :referral_submitted).from(false).to(true)
      end

      describe "if dev galaxy" do
        before(:each) do
          player.galaxy.ruleset = 'dev'
          player.galaxy.save!
        end

        it "should not call ControlManager" do
          ControlManager.instance.
            should_not_receive(:player_referral_points_reached)
          player.save!
        end

        it "should change #referral_submitted" do
          lambda do
            player.save!
          end.should change(player, :referral_submitted).to(true)
        end
      end

      describe "if referral was already submitted" do
        before(:each) do
          player.referral_submitted = true
        end
        
        it_should_behave_like "not invoking remote"
      end

      describe "if ControlManager fails" do
        before(:each) do
          ControlManager.instance.stub(:player_referral_points_reached).
            and_raise(ControlManager::Error)
        end

        it "should not set #referral_submitted" do
          lambda do
            player.save!
          end.should_not change(player, :referral_submitted)
        end

        it "should log warning" do
          LOGGER.should_receive(:warn).with(an_instance_of(String))
          player.save!
        end
      end
    end

    describe "when not enough points is collected" do
      before(:each) do
        player.economy_points -= 1
      end

      it_should_behave_like "not invoking remote"
    end
  end

  describe "#inactivity_time" do
    it "should return 0 if player is connected" do
      player = Factory.create(:player)
      Celluloid::Actor[:dispatcher].should_receive(:player_connected?).
        with(player.id).and_return(true)
      player.inactivity_time.should == 0
    end

    it "should return time from created_at if player has never logged in" do
      player = Factory.
        build(:player, :last_seen => nil, :created_at => 30.minutes.ago)
      player.inactivity_time.should be_within(SPEC_TIME_PRECISION).
        of(30.minutes)
    end

    it "should return time from last login otherwise" do
      player = Factory.
        build(:player, :last_seen => 30.minutes.ago, :created_at => 15.days.ago)
      player.inactivity_time.should be_within(SPEC_TIME_PRECISION).
        of(30.minutes)
    end
  end
  
  describe "#daily_bonus_available?" do
    def player(bonus=nil, opts={})
      Factory.build(
        :player, {
          :daily_bonus_at => bonus,
          :economy_points => Cfg.daily_bonus_start_points,
          :science_points => 0,
          :army_points => 0,
          :war_points => 0
        }.merge(opts)
      )
    end

    it "should return true if #daily_bonus_at is nil" do
      player.daily_bonus_available?.should be_true
    end
    
    it "should return true if #daily_bonus_at is in past" do
      player(10.seconds.ago).daily_bonus_available?.should be_true
    end

    it "should return false if player does not have enough points" do
      player(nil, :economy_points => Cfg.daily_bonus_start_points - 1).
        daily_bonus_available?.should be_false
    end

    it "should return false if player does not have any planets" do
      # Player can have 0 planets only in apocalyptic galaxy.
      galaxy = Factory.create(:galaxy, :apocalypse_start => 5.minutes.ago)
      player = player(nil,
        :galaxy => galaxy, :planets_count => 0, :bg_planets_count => 0
      )
      player.daily_bonus_available?.should be_false
    end
    
    it "should return false if #daily_bonus_at is in future" do
      player(10.seconds.from_now).daily_bonus_available?.should be_false
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

  describe "#creds" do
    it "should add #pure_creds, #free_creds and #vip_creds" do
      Factory.build(:player, vip_level: 1, vip_creds: 1000,
        pure_creds: 500, free_creds: 300).creds.should == 1800
    end
  end

  describe "#creds=" do
    before(:each) do
      @player = Factory.build(:player, vip_level: 1,
        vip_creds: 1000, pure_creds: 1000, free_creds: 500)
    end

    describe "earning" do
      it "should raise error" do
        lambda do
          @player.creds += 500
        end.should raise_error(ArgumentError)
      end
    end

    describe "spending" do
      it "should subtract from vip creds" do
        lambda do
          @player.creds -= 500
        end.should change(@player, :vip_creds).by(-500)
      end

      it "should not subtract from free creds" do
        lambda do
          @player.creds -= 500
        end.should_not change(@player, :free_creds)
      end

      it "should not subtract from pure creds" do
        lambda do
          @player.creds -= 500
        end.should_not change(@player, :pure_creds)
      end

      describe "when spending more than vip_creds" do
        let(:creds) { @player.vip_creds + 200}

        it "should empty vip creds" do
          lambda do
            @player.creds -= creds
          end.should change(@player, :vip_creds).to(0)
        end

        it "should subtract from vip, then free creds" do
          lambda do
            @player.creds -= creds
          end.should change(@player, :free_creds).by(-200)
        end

        it "should not change pure_creds" do
          lambda do
            @player.creds -= creds
          end.should_not change(@player, :pure_creds)
        end
      end

      describe "when spending more than vip_creds+free_creds" do
        let(:creds) { @player.vip_creds + @player.free_creds + 200}

        it "should empty vip creds" do
          lambda do
            @player.creds -= creds
          end.should change(@player, :vip_creds).to(0)
        end

        it "should empty free_creds" do
          lambda do
            @player.creds -= creds
          end.should change(@player, :free_creds).to(0)
        end

        it "should change pure_creds" do
          lambda do
            @player.creds -= creds
          end.should change(@player, :pure_creds).by(-200)
        end
      end
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

    describe "#vip_start!" do
      before(:each) do
        @vip_level = 1
        @creds_needed, @per_day, @duration =
          CONFIG['creds.vip'][@vip_level - 1]

        @player = Factory.create(:player,
          pure_creds: 10000 + @creds_needed)
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
      let(:vip_level) { 1 }
      let(:creds_needed) { CONFIG['creds.vip'][vip_level - 1][0] }
      let(:per_day) { CONFIG['creds.vip'][vip_level - 1][1] }
      let(:vip_creds) { 345 }
      let(:player) do
        Factory.create(
          :player, pure_creds: 1200, vip_level: vip_level,
          vip_creds: vip_creds
        )
      end

      it "should fail if not a vip" do
        player.stub!(:vip?).and_return(false)
        lambda do
          player.vip_tick!
        end.should raise_error(GameLogicError)
      end

      shared_examples_for "vip tick" do
        it "should set vip_creds" do
          player.vip_tick!
          player.vip_creds.should == per_day
        end

        it "should add new batch of creds" do
          lambda do
            player.vip_tick!
          end.should change(player, :creds).
            to(player.creds - vip_creds + per_day)
        end

        it "should reset vip creds counter" do
          lambda do
            player.vip_tick!
          end.should change(player, :vip_creds).to(per_day)
        end
      end

      shared_examples_for "vip tick (except last day)" do
        it "should add tick callback" do
          player.vip_tick!
          player.should have_callback(
            CallbackManager::EVENT_VIP_TICK, player.vip_creds_until
          )
        end
      end

      describe "vip start" do
        before(:each) do
          player.vip_creds_until = nil
          player.vip_until = nil
        end

        it_should_behave_like "vip tick"
        it_should_behave_like "vip tick (except last day)"

        it "should write #vip_creds_until if #vip_creds_until is nil" do
          player.vip_tick!
          player.vip_creds_until.should be_within(SPEC_TIME_PRECISION).
            of(Cfg.player_vip_tick_duration.from_now)
        end
      end

      describe "ongoing vip" do
        let(:time) { 5.minutes.ago }
        before(:each) do
          player.vip_creds_until = time
          player.vip_until = 1.month.from_now
        end

        it_should_behave_like "vip tick"
        it_should_behave_like "vip tick (except last day)"

        it "should write #vip_creds_until based on previous #vip_creds_until" do
          player.vip_tick!
          player.vip_creds_until.should be_within(SPEC_TIME_PRECISION).
            of(time + Cfg.player_vip_tick_duration)
        end
      end

      describe "last vip day" do
        let(:time) { Time.now }
        before(:each) do
          player.vip_creds_until = time
          player.vip_until = time + Cfg.player_vip_tick_duration
        end

        it_should_behave_like "vip tick"

        it "should not update vip_creds_until" do
          lambda do
            player.vip_tick!
          end.should_not change(player, :vip_creds_until)
        end

        it "should not register vip tick callback" do
          player.vip_tick!
          player.should_not have_callback(CallbackManager::EVENT_VIP_TICK)
        end
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
      
      describe "increments" do
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

        it "should not increase free creds" do
          lambda do
            @player.vip_convert(@creds)
          end.should_not change(@player, :free_creds)
        end

        describe "if #vip_free is set" do
          before(:each) do
            @player.vip_free = true
          end

          it "should increase #free_creds" do
            lambda do
              @player.vip_convert(@creds)
            end.should change(@player, :free_creds).by(@converted)
          end

          it "should not increase #pure_creds" do
            lambda do
              @player.vip_convert(@creds)
            end.should_not change(@player, :pure_creds)
          end
        end
      end

      it "should reduce amount from vip creds" do
        player = Factory.build(:player, :vip_level => 1, :vip_creds => 100)
        lambda do
          player.vip_convert(10)
        end.should change(player, :vip_creds).by(-10)
      end
    end
    
    describe "callbacks" do
      let(:player) { Factory.create(:player) }

      describe ".vip_tick_callback" do
        it "should have scope" do
          Player::VIP_TICK_SCOPE
        end

        it "should invoke #vip_tick! upon tick" do
          player.should_receive(:vip_tick!)
          Player.vip_tick_callback(player)
        end
      end

      describe ".vip_stop_callback" do
        it "should have scope" do
          Player::VIP_STOP_SCOPE
        end

        it "should invoke #vip_stop! upon stop" do
          player.should_receive(:vip_stop!)
          Player.vip_stop_callback(player)
        end
      end

      describe ".check_inactive_player_callback" do
        it "should have scope" do
          Player::CHECK_INACTIVE_PLAYER_SCOPE
        end

        it "should find model and invoke #check_activity! on it" do
          player.should_receive(:check_activity!)
          Player.check_inactive_player_callback(player)
        end
      end
    end
  end

  describe "updating" do
    before(:each) do
      @dispatcher = Celluloid::Actor[:dispatcher]
      @dispatcher.stub!(:player_connected?).and_return(false)
      @player = Factory.create(:player)
    end

    it "should update dispatcher if player is connected" do
      @dispatcher.should_receive(:player_connected?).with(@player.id).
        and_return(true)
      @dispatcher.should_receive(:update_player!).with(@player)
      @player.pure_creds += 1
      @player.save!
    end

    it "should not update dispatcher if player is disconnected" do
      @dispatcher.should_receive(:player_connected?).with(@player.id).
        and_return(false)
      @dispatcher.should_not_receive(:update_player)
      @player.pure_creds += 1
      @player.save!
    end

    describe "when alliance id changes" do
      it "should update chat hub" do
        player = Factory.create(:player, :alliance => Factory.create(:alliance))
        player.alliance = Factory.create(:alliance)
        hub = Chat::Pool.instance.hub_for(player)
        hub.stub(:on_alliance_change)
        hub.should_receive(:on_alliance_change).with(player)
        player.save!
      end

      it "should progress BeInAlliance objective if it is not nil" do
        player = Factory.create(:player)
        Objective::BeInAlliance.stub(:progress)
        Objective::BeInAlliance.should_receive(:progress).with(player)

        player.alliance = Factory.create(:alliance)
        player.save!
      end

      it "should not progress BeInAlliance objective if it is nil" do
        player = Factory.create(:player, :alliance => Factory.create(:alliance))
        Objective::BeInAlliance.should_not_receive(:progress).with(player)

        player.alliance = nil
        player.save!
      end

      it "should not update chat hub if alliance id does not change" do
        player = Factory.create(:player,
          :alliance => Factory.create(:alliance))
        player.pure_creds += 1
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
        player.pure_creds += 1
        player.save!
      end
    end
  end

  it "should not allow creating two players in same galaxy" do
    p1 = Factory.create(:player)
    p2 = Factory.build(
      :player_no_home_ss, :galaxy_id => p1.galaxy_id,
      :web_user_id => p1.web_user_id
    )
    lambda do
      p2.save!
    end.should raise_error(ActiveRecord::RecordNotUnique)
  end

  describe "#as_json" do
    fields = Player.columns.map(&:name)

    describe ":minimal mode" do
      required_fields = %w{id name}
      ommited_fields = fields - required_fields
      it_behaves_like "as json", Factory.create(:player), {:mode => :minimal},
                      required_fields, ommited_fields
    end

    describe "normal mode" do
      required_fields = %w{id name scientists scientists_total xp
        economy_points army_points science_points war_points
        victory_points population population_cap
        alliance_id alliance_cooldown_ends_at alliance_cooldown_id
        free_creds pure_creds vip_level vip_creds vip_until
        vip_creds_until
        portal_without_allies trial
        planets_count bg_planets_count
        last_market_offer_cancel
      }
      ommited_fields = fields - required_fields
      it_behaves_like "as json", Factory.create(:player), nil,
                      required_fields, ommited_fields

      describe "if in alliance" do
        before(:each) do
          @alliance = Factory.create(:alliance)
          @model = @alliance.owner
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
        Factory.build(:player, population: 10, population_cap: 50).
          overpopulation_mod.should == 1
      end
    end

    describe "pop = max" do
      it "should return 1" do
        Factory.build(:player, population: 50, population_cap: 50).
          overpopulation_mod.should == 1
      end
    end

    describe "overpopulated" do
      it "should return ratio" do
        Factory.build(:player, population: 35, population_cap: 10).
          overpopulation_mod.should == (10.0 / 35)
      end

      it "should return Player::OVERPOPULATION_MOD_MIN if max is 0" do
        Factory.build(:player, population: 35, population_cap: 0).
          overpopulation_mod.should == Player::OVERPOPULATION_MOD_MIN
      end
    end
  end

  describe "#overpopulated?" do
    it "should return false if pop < cap" do
      Factory.build(:player, population: 5, population_cap: 10).
        should_not be_overpopulated
    end

    it "should return false if pop == cap" do
      Factory.build(:player, population: 10, population_cap: 10).
        should_not be_overpopulated
    end

    it "should return true if pop > cap" do
      Factory.build(:player, population: 15, population_cap: 10).
        should be_overpopulated
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

  describe ".minimal_from_ids" do
    it "should resolve from ids" do
      p1 = Factory.create(:player)
      p2 = Factory.create(:player)

      ids = [p1.id, nil, p2.id]
      Player.minimal_from_ids(ids).should equal_to_hash(
        p1.id => p1.as_json(:mode => :minimal),
        p2.id => p2.as_json(:mode => :minimal),
        nil => nil
      )
    end
  end

  describe "#recalculate_population" do
    let(:player) do
      Factory.create(:player, population: 1000, population_cap: 2500)
    end

    describe "#population" do
      let(:planet) { Factory.create(:planet, player: player) }
      let(:constructor) { Factory.create(:b_constructor_test, planet: planet) }
      let(:units) do
        # Random data that should not be taken into account
        Factory.create!(:u_cyrix)
        # Actual data
        [
          Factory.create!(:u_cyrix, player: player),
          Factory.create!(:u_cyrix, player: player),
          Factory.create!(:u_crow, player: player),
          Factory.create!(:u_mule, player: player),
          Factory.create!(:u_shocker, player: player),
          Factory.create!(:u_zeus, player: player)
        ]
      end
      let(:construction_queue_entries) do
        # Random data that should not be taken into account
        Factory.create(:construction_queue_entry,
          constructable_type: Unit::Zeus.to_s, prepaid: true)
        Factory.create(:construction_queue_entry,
          constructable_type: Unit::Zeus.to_s, prepaid: false)
        Factory.create(:construction_queue_entry,
          constructable_type: Building::Barracks.to_s, prepaid: false)
        Factory.create(:construction_queue_entry,
          constructable_type: Unit::Trooper.to_s, prepaid: false, constructor: constructor,
          count: 10)
        Factory.create(:construction_queue_entry,
          constructable_type: Unit::Trooper.to_s, prepaid: false, constructor: constructor,
          count: 10)
        Factory.create(:construction_queue_entry,
          constructable_type: Building::MetalStorage.to_s, prepaid: true,
          constructor: constructor, count: 10)
        # Actual data
        [
          Factory.create(:construction_queue_entry,
            constructable_type: Unit::Trooper.to_s,
            prepaid: true, constructor: constructor, count: 10),
          Factory.create(:construction_queue_entry,
            constructable_type: Unit::Rhyno.to_s,
            prepaid: true, constructor: constructor),
          Factory.create(:construction_queue_entry,
            constructable_type: Unit::Zeus.to_s,
            prepaid: true, constructor: constructor, count: 5),
        ]
      end

      let(:population) do
        (
          units.map(&:population) + construction_queue_entries.
            map { |cqe| cqe.constructable_class.population * cqe.count }
        ).sum
      end

      it "should recalculate #population to correct value" do
        lambda do
          player.recalculate_population
        end.should change(player, :population).to(population)
      end
    end

    describe "#population_cap" do
      let(:planet1) { Factory.create(:planet, player: player) }
      let(:planet2) { Factory.create(:planet, player: player) }
      let(:planet_other) { Factory.create(:planet_with_player) }
      let(:planet_npc) { Factory.create(:planet) }
      let(:buildings) do
        # Inactive building.
        Factory.create(:b_housing, opts_inactive + {planet: planet1, x: 30})
        # Building that doesn't give population.
        Factory.create(:b_barracks, opts_active + {planet: planet1, x: 40})
        # Building that is in other player planet.
        Factory.create(:b_housing, opts_active + {planet: planet_other})
        # Building that is in NPC planet.
        Factory.create(:b_housing, opts_active + {planet: planet_npc})
        [
          Factory.create(:b_headquarters, opts_working +
            {planet: planet1, x: 20}),
          Factory.create(:b_housing, opts_active +
            {planet: planet1, x: 0, level: 3}),
          # Grouping by type & level.
          Factory.create(:b_housing, opts_active +
            {planet: planet1, y: 10, level: 3}),
          Factory.create(:b_housing, opts_active +
            {planet: planet1, x: 10, level: 5}),
          Factory.create(:b_mothership, opts_active +
            {planet: planet2, x: 0, level: 1}),
          Factory.create(:b_housing, opts_active +
            {planet: planet2, x: 10, level: 2}),
        ]
      end
      let(:population_cap) do
        buildings.inject(0) do |sum, building|
          sum + building.population
        end
      end

      it "should recalculate #population_cap to correct value" do
        lambda do
          player.recalculate_population
        end.should change(player, :population_cap).to(population_cap)
      end
    end

    it "should not save record" do
      player.recalculate_population
      player.should_not be_saved
    end
  end

  describe "#recalculate_population!" do
    let(:player) { Factory.create(:player) }

    it "should call #recalculate_population" do
      player.should_receive(:recalculate_population)
      player.recalculate_population!
    end

    it "should save record" do
      player.recalculate_population!
      player.should be_saved
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

  describe "#alliance_ids" do
    let(:player) { Factory.build(:player) }

    it "should return #friendly_ids without you" do
      player.id = 2
      player.should_receive(:friendly_ids).and_return([1,2,3,4])
      player.alliance_ids.should == [1,3,4]
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

  describe "#leave_alliance!" do
    let(:alliance) { create_alliance }
    let(:player) { Factory.create(:player, :alliance => alliance) }

    it "should fail if you're not in the alliance" do
      player.alliance = nil

      lambda do
        player.leave_alliance!
      end.should raise_error(GameLogicError)
    end

    it "should set alliance cooldown" do
      player.leave_alliance!
      player.reload
      player.alliance_cooldown_ends_at.should be_within(SPEC_TIME_PRECISION).of(
        Cfg.alliance_leave_cooldown.from_now
      )
    end

    describe "if owner" do
      let(:player) { alliance.owner }

      before(:each) { player.alliance.stub!(:resign_ownership!) }

      it "should try to resign" do
        player.alliance.should_receive(:resign_ownership!)
        player.leave_alliance!
      end

      it "should destroy alliance if resigning failed" do
        player.alliance.stub(:resign_ownership!).
          and_raise(Alliance::NoSuccessorFound)
        player.leave_alliance!
        Alliance.exists?(@alliance).should be_false
      end
    end

    describe "if member" do
      it "should throw you out from alliance" do
        player.alliance.should_receive(:throw_out).with(player)
        player.leave_alliance!
      end

      it "should work properly" do
        player.leave_alliance!
      end
    end
  end

  describe "#alliance_cooldown_expired?" do
    let(:alliance) { create_alliance }

    describe "when alliance_cooldown_id is set" do
      def create_player(cooldown_ended)
        Factory.create(
          :player, :alliance_cooldown_id => alliance.id,
          :alliance_cooldown_ends_at => cooldown_ended \
            ? 10.minutes.ago : 10.minutes.from_now
        )
      end

      describe "cooldown has not ended" do
        let(:player) { create_player(false) }

        it "should return true if it is other alliance" do
          player.alliance_cooldown_expired?(alliance.id + 1).should be_true
        end

        it "should return true if alliance_id is not given" do
          player.alliance_cooldown_expired?(nil).should be_true
        end

        it "should return false if it is same alliance" do
          player.alliance_cooldown_expired?(alliance.id).should be_false
        end
      end

      describe "cooldown has ended" do
        let(:player) { create_player(true) }

        it "should return true if it is other alliance" do
          player.alliance_cooldown_expired?(alliance.id + 1).should be_true
        end

        it "should return true if alliance_id is not given" do
          player.alliance_cooldown_expired?(nil).should be_true
        end

        it "should return true if it is same alliance" do
          player.alliance_cooldown_expired?(alliance.id).should be_true
        end
      end
    end

    describe "when alliance_cooldown_id is nil" do
      def create_player(cooldown_ended)
        Factory.create(:player,
          :alliance_cooldown_ends_at => cooldown_ended \
            ? 10.minutes.ago : 10.minutes.from_now
        )
      end

      describe "cooldown has not ended" do
        let(:player) { create_player(false) }

        it "should return false if alliance id is given" do
          player.alliance_cooldown_expired?(10).should be_false
        end

        it "should return false if alliance_id is not given" do
          player.alliance_cooldown_expired?(nil).should be_false
        end
      end

      describe "cooldown has ended" do
        let(:player) { create_player(true) }

        it "should return true if alliance id is given" do
          player.alliance_cooldown_expired?(10).should be_true
        end

        it "should return true if alliance_id is not given" do
          player.alliance_cooldown_expired?(nil).should be_true
        end
      end
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

    describe "home solar system" do
      let(:player) { Factory.create(:player) }
      let(:home_ss) { player.home_solar_system }

      it "should destroy players home solar system" do
        home_ss_id = home_ss.id
        player.destroy!
        lambda do
          SolarSystem.find(home_ss_id)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should dispatch solar system destroyed if not detached" do
        should_fire_event(
          Event::FowChange::SsDestroyed.all_except(home_ss.id, player.id),
          EventBroker::FOW_CHANGE,
          EventBroker::REASON_SS_ENTRY
        ) do
          player.destroy!
        end
      end

      it "should not dispatch solar system destroyed if detached" do
        home_ss.detach!
        should_not_fire_event(
          Event::FowChange::SsDestroyed.all_except(home_ss.id, player.id),
          EventBroker::FOW_CHANGE,
          EventBroker::REASON_SS_ENTRY
        ) do
          player.destroy!
        end
      end
    end

    it "should call control manager" do
      player = Factory.create :player
      ControlManager.instance.should_receive(:player_destroyed).with(player)
      player.destroy
    end

    it "should not call control manager if invoked from it" do
      player = Factory.create :player
      ControlManager.instance.should_not_receive(:player_destroyed)
      player.invoked_from_web = true
      player.destroy
    end

    it "should not call control manager if dev galaxy" do
      player = Factory.create(:player,
        :galaxy => Factory.create(:galaxy, :ruleset => 'dev'))
      ControlManager.instance.should_not_receive(:player_destroyed)
      player.destroy
    end
    
    it "should disconnect player from dispatcher if he's connected" do
      player = Factory.create(:player)
      Celluloid::Actor[:dispatcher].should_receive(:disconnect!).
        with(player.id, Dispatcher::DISCONNECT_PLAYER_ERASED)
      player.destroy
    end

    it "should leave alliance if he is in one" do
      player = create_alliance.owner
      player.should_receive(:leave_alliance!)
      player.destroy!
    end

    it "should not leave alliance if he not in one" do
      player = Factory.create(:player)
      player.should_not_receive(:leave_alliance!)
      player.destroy!
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

      it "should create notification with changes" do
        changes = [
          [@technologies[0], Reducer::CHANGED, 20],
          [@technologies[3], Reducer::CHANGED, 30],
        ]
        Reducer::ScientistsReducer.stub!(:reduce).and_return(changes)
        Notification.should_receive(:create_for_technologies_changed).
          with(@player.id, changes)
        @player.ensure_free_scientists! 20
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

  describe "#relocatable?" do
    let(:galaxy) { Factory.create(:galaxy) }
    let(:player) { Factory.create(:player, :galaxy => galaxy) }
    let(:home_ss) { player.home_solar_system }
    let(:home_planet) do
      Factory.create(:planet, :player => player, :solar_system => home_ss)
    end
    let(:other_ss) do
      Factory.create(:solar_system, :galaxy => galaxy, :x => 1, :y => 0)
    end
    let(:other_planet) { Factory.create(:planet, :solar_system => other_ss) }
    let(:other_owned_planet) do
      Factory.create(:planet, :player => player, :solar_system => other_ss)
    end
    def unit_in(location)
      Factory.create(:u_crow, :player => player, :location => location)
    end

    before(:each) do
      home_planet()
    end

    it "should return false if player belongs to alliance" do
      player.alliance = Factory.create(:alliance)
      player.should_not be_relocatable
    end

    it "should return false if player has units in galaxy" do
      unit_in(GalaxyPoint.new(galaxy.id, 0, 0))
      player.should_not be_relocatable
    end

    it "should return false if player has units not in home ss" do
      unit_in(SolarSystemPoint.new(other_ss.id, 0, 0))
      player.should_not be_relocatable
    end

    it "should return false if player has units in planet not in home ss" do
      unit_in(other_planet)
      player.should_not be_relocatable
    end

    it "should return false if player has planets not in home ss" do
      other_owned_planet()
      player.should_not be_relocatable
    end

    it "should return false if player has any routes" do
      Factory.create(:route, :player => player)
      player.should_not be_relocatable
    end

    it "should return true if player only has planets in home ss" do
      player.should be_relocatable
    end

    it "should return true if player has units in home ss" do
      unit_in(SolarSystemPoint.new(home_ss.id, 0, 0))
      player.should be_relocatable
    end

    it "should return true if player has units in planet in home ss" do
      unit_in(home_planet)
      player.should be_relocatable
    end
  end

  describe "#active?" do
    let(:player) { Factory.create(:player) }

    it "should return false if he has never logged in" do
      player.last_seen = nil
      player.should_not be_active
    end

    it "should return false if he hasn't been active for required period" do
      period = 3.days
      Cfg.should_receive(:player_inactivity_time).with(player.points).
        and_return(period)
      player.last_seen = (period + 10.minutes).ago
      player.should_not be_active
    end

    it "should return true if he is currently connected" do
      Celluloid::Actor[:dispatcher].stub(:player_connected?).with(player.id).
        and_return(true)
      player.should be_active
    end

    it "should return true if he has been active for required period" do
      period = 3.days
      Cfg.should_receive(:player_inactivity_time).with(player.points).
        and_return(period)
      player.last_seen = (period - 10.minutes).ago
      player.should be_active
    end
  end

  describe "#check_activity!" do
    let(:player) do
      player = Factory.create(:player)
      player.stub!(:detached?).and_return(false)
      player.stub!(:detach!)
      player
    end

    shared_examples_for "not relocating" do
      it "should not hide player" do
        player.should_not_receive(:detach!)
        player.check_activity!
      end

      it "should register new callback" do
        player.should_receive(:register_check_activity!)
        player.check_activity!
      end
    end

    describe "player is inactive" do
      before(:each) do
        player.should_receive(:active?).and_return(false)
      end

      describe "relocatable" do
        before(:each) do
          player.should_receive(:relocatable?).and_return(true)
        end

        it "should detach player" do
          player.should_receive(:detach!)
          player.check_activity!
        end

        it "should not detach player if he is already detached" do
          player.stub!(:detached?).and_return(true)
          player.should_not_receive(:detach!)
          player.check_activity!
        end

        it "should not register new callback" do
          player.check_activity!
          player.should_not have_callback(
            CallbackManager::EVENT_CHECK_INACTIVE_PLAYER
          )
        end

        it "should unregister old callback if it exists" do
          CallbackManager.register_or_update(
            player, CallbackManager::EVENT_CHECK_INACTIVE_PLAYER,
            10.minutes.from_now
          )
          player.check_activity!
          player.should_not have_callback(
            CallbackManager::EVENT_CHECK_INACTIVE_PLAYER
          )
        end
      end

      describe "non relocatable" do
        before(:each) do
          player.should_receive(:relocatable?).and_return(false)
        end

        it_should_behave_like "not relocating"
      end
    end

    describe "player is active" do
      before(:each) do
        player.should_receive(:active?).and_return(true)
      end

      it_should_behave_like "not relocating"
    end
  end

  describe "#register_check_activity!" do
    let(:player) { Factory.create(:player) }

    it "should register a callback" do
      player.register_check_activity!
      player.should have_callback(
        CallbackManager::EVENT_CHECK_INACTIVE_PLAYER,
        Cfg.player_inactivity_time(player.points).from_now
      )
    end
  end

  describe "#attach!" do
    let(:player) { Factory.create(:player) }
    let(:home_solar_system) { player.home_solar_system }
    # Needed to have a suitable zone for reattachment.
    let(:normal_solar_system) do
      Factory.create(:solar_system, :galaxy => player.galaxy, :x => 10)
    end

    before(:each) { home_solar_system(); normal_solar_system() }

    it "should fail if player is already attached" do
      lambda do
        player.attach!
      end.should raise_error(ArgumentError)
    end

    describe "when detached" do
      before(:each) { player.detach! }

      it "should reattach home solar system to free zone" do
        zone = Galaxy::Zone.new(5, 1)
        Galaxy::Zone.should_receive(:for_reattachment).
          with(player.galaxy_id, player.points).and_return(zone)

        x, y = zone.absolute(4, 2)
        zone.should_receive(:free_spot_coords).with(player.galaxy_id).
          and_return([x, y])

        player.attach!
        home_solar_system.reload
        [home_solar_system.x, home_solar_system.y].should == [x, y]
      end

      it "should register player check activity" do
        player.should_receive(:register_check_activity!)
        player.attach!
      end

      it "should create notification" do
        Notification.should_receive(:create_for_player_attached).with(player.id)
        player.attach!
      end

      it "should work" do
        player.attach!
        player.should_not be_detached
      end
    end
  end

  describe ".battle_vps_multiplier" do
    def player(economy_points=10, science_points=15, army_points=20,
        war_points=25, victory_points=30)
      Factory.create(:player, :economy_points => economy_points,
        :science_points => science_points, :army_points => army_points,
        :war_points => war_points, :victory_points => victory_points)
    end
    
    def points(player)
      Cfg::Java.fairnessPoints(
        player.economy_points, player.science_points,
        player.army_points, player.war_points, player.victory_points
      ).to_f
    end

    def ratio(aggressor, defender)
      points(defender) / points(aggressor)
    end

    it "should fail if aggressor cannot be found" do
      lambda do
        Player.battle_vps_multiplier(0, player.id)
      end.should raise_error(GameLogicError)
    end

    it "should fail if defender cannot be found" do
      lambda do
        Player.battle_vps_multiplier(player.id, 0)
      end.should raise_error(GameLogicError)
    end

    it "should use Cfg::Java.fairnessPoints" do
      p1_args = [10, 20, 30, 40, 50]
      p2_args = p1_args.reverse

      Cfg::Java.should_receive(:fairnessPoints).with(*p1_args).and_return(10)
      Cfg::Java.should_receive(:fairnessPoints).with(*p2_args).and_return(20)
      player1 = player(*p1_args)
      player2 = player(*p2_args)
      Player.battle_vps_multiplier(player1.id, player2.id)
    end

    it "should return 1 if aggressor has no points" do
      Player.battle_vps_multiplier(
        player(0, 0, 0, 0, 0).id, player().id
      ).should == 1
    end

    describe "if aggressor is stronger than defender" do
      it "should use proportional linear formula" do
        aggressor = player(10, 10, 10, 10, 10)
        defender = player(9, 9, 9, 9, 9)

        formula = MathFormulas.line(Cfg::Java.battleVpsMaxWeakness, 0, 1, 1)
        expected = formula.call(ratio(aggressor, defender))
        Player.battle_vps_multiplier(aggressor.id, defender.id).should ==
          expected
      end

      it "should return 0 if aggressor is too strong" do
        aggressor = player(10, 10, 10, 10, 10)
        d_points = 10 * (Cfg::Java.battleVpsMaxWeakness - 0.1)
        defender = player(d_points, d_points, d_points, d_points, d_points)
        Player.battle_vps_multiplier(aggressor.id, defender.id).
          should == 0
      end
    end

    describe "if aggressor is weaker than defender" do
      it "should use linear formula" do
        aggressor = player(10, 10, 10, 10, 10)
        defender = player(30, 30, 30, 30, 30)
        Player.battle_vps_multiplier(aggressor.id, defender.id).should == 3
      end
    end
  end

  describe ".join_alliance_ids" do
    let(:alliance1) { create_alliance }
    let(:a1_p1) { alliance1.owner }
    let(:a1_p2) { Factory.create(:player, alliance: alliance1) }
    let(:a1_p3) { Factory.create(:player, alliance: alliance1) }
    let(:alliance2) { create_alliance }
    let(:a2_p1) { alliance2.owner }
    let(:a2_p2) { Factory.create(:player, alliance: alliance2) }
    let(:a2_p3) { Factory.create(:player, alliance: alliance2) }
    let(:player_ids) { [a1_p1.id, a2_p3.id] }
    let(:alliance_player_ids) {
      [a1_p1.id, a1_p2.id, a1_p3.id, a2_p1.id, a2_p2.id, a2_p3.id]
    }
    let(:non_ally) { Factory.create(:player) }

    def create_allies
      a1_p1; a1_p2; a1_p3; a2_p1; a2_p2; a2_p3
    end

    it "should join player allies" do
      create_allies
      Set.new(Player.join_alliance_ids(player_ids)).
        should == Set.new(alliance_player_ids)
    end

    it "should return distinct values" do
      ids = Player.join_alliance_ids(player_ids)
      ids.should == ids.uniq
    end

    it "should not include nils when joining players without alliance" do
      Player.join_alliance_ids(player_ids + [non_ally.id]).
        should_not include(nil)
    end
  end
end
