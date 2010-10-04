require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe QuestsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller QuestsController, :login => true
  end

  describe "quests|index" do
    before(:each) do
      @action = "quests|index"
      @params = {}
    end

    it_should_behave_like "only push"

    it "should return quests" do
      Quest.should_receive(:hash_all_for_player_id).with(player.id
        ).and_return(:quests)
      push @action, @params
      response_should_include(:quests => :quests)
    end
  end

  describe "quests|claim_reward" do
    before(:each) do
      @action = "quests|claim_reward"
      @params = {'id' => 10, 'planet_id' => 20}
    end

    @required_params = %w{id planet_id}
    it_should_behave_like "with param options"

    it "should claim rewards" do
      QuestProgress.should_receive(:claim_rewards!).with(
        player.id, @params['id'], @params['planet_id']
      )
      invoke @action, @params
    end
  end
end