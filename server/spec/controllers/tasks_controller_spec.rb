require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe TasksController do
  include ControllerSpecHelper

  before(:each) do
    init_controller TasksController
    @params = {
      GenericController::ParamOpts::CONTROL_TOKEN_KEY => Cfg.control_token
    }
    restore_logging
  end

  describe "tasks|reopen_logs" do
    before(:each) do
      @action = "tasks|reopen_logs"
    end

    it_should_behave_like "with param options",
      :needs_login => false, :needs_control_token => true

    it "should not fail" do
      invoke @action, @params
    end

    it "should call #reopen! on log writer" do
      Logging::Writer.instance.should_receive(:reopen!)
      invoke @action, @params
    end
  end

  describe "tasks|create_player" do
    let(:galaxy) { Factory.create(:galaxy) }
    let(:player) { Factory.create(:player) }

    before(:each) do
      @action = "tasks|create_player"
      @params.merge!(
        'galaxy_id' => galaxy.id,
        'web_user_id' => (Player.maximum(:web_user_id) || 0) + 1,
        'name' => "P#{Time.now.to_f}",
        'trial' => false
      )
      Galaxy.stub(:create_player).with(
        galaxy.id, @params['web_user_id'], @params['name'], @params['trial']
      ).and_return(player)
    end

    it_should_behave_like "with param options",
      :required => %w{galaxy_id web_user_id name},
      :needs_login => false, :needs_control_token => true

    shared_examples_for "calling create player" do
      it "should call Galaxy.create_player" do
        Galaxy.should_receive(:create_player).with(
          galaxy.id, @params['web_user_id'], @params['name'], @params['trial']
        ).and_return(player)
        invoke @action, @params
      end
    end

    shared_examples_for "returning player id" do
      it "should return player id" do
        invoke @action, @params
        Player.find(response[:player_id]).should == player
      end
    end

    describe "player does not exist" do
      it_should_behave_like "calling create player"
      it_should_behave_like "returning player id"
    end

    describe "player already exists" do
      let(:player) do
        Factory.create(:player,
          galaxy: galaxy, web_user_id: @params['web_user_id'],
          name: @params['name']
        )
      end

      before(:each) { player }

      it "should not call Galaxy.create_player" do
        Galaxy.should_not_receive(:create_player)
        invoke @action, @params
      end

      describe "player has a different name" do
        before(:each) do
          player.name += "a"
          player.save!
        end

        it_should_behave_like "calling create player"
      end

      describe "player has different web_user_id" do
        before(:each) do
          player.web_user_id += 1
          player.save!
        end

        it_should_behave_like "calling create player"
      end

      it_should_behave_like "returning player id"
    end
  end

  describe "tasks|destroy_player" do
    let(:player) { Factory.create(:player) }

    before(:each) do
      @action = "tasks|destroy_player"
      @params.merge!('player_id' => player.id)
    end

    it_should_behave_like "with param options",
      :required => %w{player_id},
      :needs_login => false, :needs_control_token => true

    it "should call destroy with Player#invoked_from_web set" do
      Player.should_receive(:find).with(player.id).and_return(player)
      player.should_receive(:destroy!).and_return do
        player.invoked_from_web.should be_true
        true
      end
      invoke @action, @params
    end

    it "should destroy user" do
      invoke @action, @params
      lambda do
        player.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should not fail if user is already destroyed" do
      player.destroy!
      invoke @action, @params
    end
  end

  describe "tasks|add_creds" do
    let(:player) { Factory.create(:player) }
    let(:creds) { 1500 }

    before(:each) do
      @action = "tasks|add_creds"
      @params.merge!('player_id' => player.id, 'creds' => creds)
    end

    it_should_behave_like "with param options",
      :required => %w{player_id creds},
      :needs_login => false, :needs_control_token => true

    it "should increase player pure creds" do
      lambda do
        invoke @action, @params
        player.reload
      end.should change(player, :pure_creds).by(creds)
    end

    it "should fail if player is not found" do
      player.destroy!
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "tasks|player_registered" do
    let(:player) { Factory.create(:player, :trial => true) }

    before(:each) do
      @action = "tasks|player_registered"
      @params.merge!('player_id' => player.id, 'name' => player.name + "FOO")
    end

    it_should_behave_like "with param options",
      :required => %w{player_id name},
      :needs_login => false, :needs_control_token => true

    it "should fail if player is not trial" do
      player.trial = false
      player.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should set Player#trial to false" do
      lambda do
        invoke @action, @params
        player.reload
      end.should change(player, :trial?).from(true).to(false)
    end

    it "should set Player#name" do
      lambda do
        invoke @action, @params
        player.reload
      end.should change(player, :name).from(player.name).to(@params['name'])
    end

    it "should fire Event::PlayerRename" do
      event = Event::PlayerRename.new(player.id, @params['name'])
      should_fire_event(event, EventBroker::CREATED) do
        invoke @action, @params
      end
    end
  end

  describe "tasks|is_player_connected" do
    before(:each) do
      @action = "tasks|is_player_connected"
      @params.merge!('player_id' => 50)
    end

    it_should_behave_like "with param options",
      :required => %w{player_id},
      :needs_login => false, :needs_control_token => true

    it "should return true if player is connected" do
      Celluloid::Actor[:dispatcher].should_receive(:player_connected?).
        with(@params['player_id']).and_return(true)
      invoke @action, @params
      response.should == {connected: true}
    end

    it "should return false if player is not connected" do
      invoke @action, @params
      response.should == {connected: false}
    end
  end

  describe "tasks|player_stats" do
    before(:each) do
      @action = "tasks|player_stats"
    end

    it_should_behave_like "with param options",
      :needs_login => false, :needs_control_token => true

    it "should work" do
      invoke @action, @params
    end
  end

  describe "tasks|pool_stats" do
    let(:galaxies) do
      [
        Factory.create(:galaxy, pool_free_zones: 20, pool_free_home_ss: 100),
        Factory.create(:galaxy, pool_free_zones: 10, pool_free_home_ss: 25),
        Factory.create(:galaxy, pool_free_zones: 10, pool_free_home_ss: 25),
      ]
    end
    let(:klass) { Class.new(Struct.new(:free_zones, :free_home_ss)) }

    before(:each) do
      @action = "tasks|pool_stats"
      galaxies
    end

    it_should_behave_like "with param options",
      :needs_login => false, :needs_control_token => true

    def data(free_zones, free_home_ss)
      klass.new(free_zones, free_home_ss)
    end

    it "should return stats" do
      SpaceMule.instance.should_receive(:pool_stats).
        with(an_instance_of(Fixnum)).exactly(3).times.and_return do |id|
          case id
          when galaxies[0].id then data(10, 20)
          when galaxies[1].id then data(10, 50)
          when galaxies[2].id then data(13, 25)
          else raise "Unknown galaxy id #{id.inspect} received!"
          end
        end

      invoke @action, @params

      response.should == {
        stats: {
          galaxies[0].id => {free_zones: 50.0, free_home_ss: 20.0},
          galaxies[1].id => {free_zones: 100.0, free_home_ss: 200.0},
          galaxies[2].id => {free_zones: 130.0, free_home_ss: 100.0},
        }
      }
    end

    it "should work" do
      invoke @action, @params
    end
  end

  describe "tasks|director_stats" do
    let(:stats) { {world: 3, chat: 5} }

    before(:each) do
      @action = "tasks|director_stats"
    end

    it_should_behave_like "with param options",
      :needs_login => false, :needs_control_token => true

    it "should return stats" do
      Celluloid::Actor[:dispatcher].should_receive(:director_stats).
        and_return(stats)

      invoke @action, @params
      response.should == {stats: stats}
    end

    it "should work" do
      invoke @action, @params
    end
  end
end