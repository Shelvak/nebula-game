require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

shared_examples_for "technology upgradable" do
  it "should return technology in upgrading state" do
    invoke @action, @params
    technology.reload.should be_upgrading
  end

  %w{scientists speed_up}.each do |arg|
    it "should pass #{arg}" do
      invoke @action, @params
      technology.reload.send(arg).should == @params[arg]
    end
  end
end

shared_examples_for "technology existing" do
  it "should not allow to change other player technology" do
    technology.player = Factory.create(:player)
    technology.save!
    lambda do
      invoke @action, @params
    end.should raise_error(ActiveRecord::RecordNotFound)
  end
end

describe TechnologiesController do
  include ControllerSpecHelper

  before(:each) do
    init_controller TechnologiesController, :login => true
  end

  describe "technologies|index" do
    before(:each) do
      @action = "technologies|index"
    end

    it_behaves_like "only push"

    it "should return list of player technologies" do
      should_respond_with :technologies => player.technologies
      push @action
    end
  end

  describe "technologies|new" do
    let(:technology) do
      Technology.new_by_type(
        @params['type'],
        :player => @player, :planet_id => @params['planet_id'], :level => 0,
        :scientists => @params['scientists'],
        :speed_up => @params['speed_up']
      )
    end

    before(:each) do
      @action = "technologies|new"
      @planet = Factory.create :planet_with_player, :player => player
      set_resources(@planet, 10000, 10000, 10000)
      @rc = Factory.create(:b_research_center, :planet => @planet)
      @params = {
        'type' => 'TestTechnology',
        'planet_id' => @planet.id,
        'scientists' => Technology::TestTechnology.scientists_min(1),
        'speed_up' => false
      }
      tech = technology
      Technology.stub(:new_by_type).and_return(tech)
    end

    it_behaves_like "with param options", %w{type planet_id scientists speed_up}

    it "should set technology as belonging to player" do
      invoke @action, @params
      technology.reload.player.should == player
    end

    it_behaves_like "technology upgradable"
  end

  describe "technologies|upgrade" do
    let(:technology) do
      Factory.create :technology, :level => 1, :player => player
    end

    before(:each) do
      @action = "technologies|upgrade"
      @planet = Factory.create :planet_with_player, :player => player
      set_resources(@planet, 10000, 10000, 10000)
      @rc = Factory.create(:b_research_center, :planet => @planet)
      @params = {'id' => technology.id, 'planet_id' => @planet.id,
        'scientists' => Technology::TestTechnology.scientists_min(2),
        'speed_up' => false
      }
    end

    it_behaves_like "with param options", %w{id planet_id scientists speed_up}

    it_behaves_like "technology upgradable"
    it_behaves_like "technology existing"
  end

  describe "technologies|update" do
    let(:technology) do
      Factory.create :technology_upgrading, :level => 1, :player => player
    end

    before(:each) do
      @action = "technologies|update"
      @params = {
        'id' => technology.id, 'scientists' => technology.scientists * 2
      }
    end

    it_behaves_like "with param options", %w{id}

    it_behaves_like "technology existing"

    it "should update scientist count" do
      invoke @action, @params
      technology.reload.scientists.should == @params['scientists']
    end
  end

  describe "technologies|pause" do
    let(:technology) do
      Factory.create :technology_upgrading, :level => 1, :player => player
    end

    before(:each) do
      @action = "technologies|pause"
      @params = {'id' => technology.id}
    end

    it_behaves_like "with param options", %w{id}

    it_behaves_like "technology existing"

    it "should pause technology" do
      invoke @action, @params
      technology.reload.should be_paused
    end
  end

  describe "technologies|resume" do
    let(:technology) do
      Factory.create :technology_paused, :level => 1, :player => player
    end

    before(:each) do
      @action = "technologies|resume"
      @params = {
        'id' => technology.id, 'scientists' => technology.scientists_min
      }
    end

    it_behaves_like "with param options", %w{id scientists}

    it_behaves_like "technology existing"

    it "should resume technology" do
      invoke @action, @params
      technology.reload.should be_upgrading
    end
  end

  describe "technologies|accelerate" do
    let(:technology) do
      Factory.create :technology_upgrading, :level => 1, :player => player
    end

    before(:each) do
      @action = "technologies|accelerate"
      player.creds = 1000000
      player.save!

      @params = {
        'id' => technology.id,
        'index' => CONFIG['creds.upgradable.speed_up'].size - 1
      }
    end

    it "should raise error when providing wrong index" do
      lambda do
        invoke @action, @params.merge('index' => @params['index'] + 1)
      end.should raise_error(GameLogicError)
    end

    it "should accelerate technology" do
      Creds.should_receive(:accelerate!).with(technology, @params['index'])
      invoke @action, @params
    end
  end

  describe "technologies|unlearn" do
    let(:technology) { Factory.create(:technology, :player => player) }

    before(:each) do
      @action = "technologies|unlearn"
      @params = {'id' => technology.id}
    end

    it "should fail if technology does not belong to player" do
      technology.player = Factory.create(:player)
      technology.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should call #unlearn! on technology" do
      player.stub_chain(:technologies, :find).with(technology.id).
        and_return(technology)
      technology.should_receive(:unlearn!)
      invoke @action, @params
    end
  end
end