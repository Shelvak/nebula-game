require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

shared_examples_for "technology upgradable" do
  it "should return technology in upgrading state" do
    invoke @action, @params
    Technology.find(
      @controller.response_params[:technology]['id']
    ).should be_upgrading
  end

  %w{scientists speed_up}.each do |arg|
    it "should pass #{arg}" do
      invoke @action, @params
      @controller.response_params[:technology][arg].should == @params[arg]
    end
  end
end

shared_examples_for "technology existing" do
  it "should not allow to change other player technology" do
    @technology.player = Factory.create(:player)
    @technology.save!
    lambda do
      invoke @action, @params
    end.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should return technology" do
    invoke @action, @params
    @technology.reload
    @controller.response_params[:technology].should == @technology.as_json
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
    before(:each) do
      @action = "technologies|new"
      @planet = Factory.create :planet_with_player, :player => player
      set_resources(@planet, 10000, 10000, 10000)
      @rc = Factory.create(:b_research_center, :planet => @planet)
      @params = {'type' => 'TestTechnology', 'planet_id' => @planet.id,
        'scientists' => Technology::TestTechnology.scientists_min(1),
        'speed_up' => false
      }
    end

    @required_params = %w{type planet_id scientists speed_up}
    it_behaves_like "with param options"

    it "should return new technology" do
      invoke @action, @params
      @controller.response_params[:technology].should == Technology.find(
        @controller.response_params[:technology]['id']
      ).as_json
    end

    it "should set technology as belonging to player" do
      invoke @action, @params
      Technology.find(
        @controller.response_params[:technology]['id']
      ).player.should == player
    end

    it_behaves_like "technology upgradable"
  end

  describe "technologies|upgrade" do
    before(:each) do
      @action = "technologies|upgrade"
      @technology = Factory.create :technology, :level => 1,
        :player => player
      @planet = Factory.create :planet_with_player, :player => player
      set_resources(@planet, 10000, 10000, 10000)
      @rc = Factory.create(:b_research_center, :planet => @planet)
      @params = {'id' => @technology.id, 'planet_id' => @planet.id,
        'scientists' => Technology::TestTechnology.scientists_min(2),
        'speed_up' => false
      }
    end

    @required_params = %w{id planet_id scientists speed_up}
    it_behaves_like "with param options"

    it_behaves_like "technology upgradable"
    it_behaves_like "technology existing"
  end

  describe "tehcnologies|update" do
    before(:each) do
      @action = "technologies|update"
      @technology = Factory.create :technology_upgrading, :level => 1,
        :player => player
      @params = {'id' => @technology.id,
        'scientists' => @technology.scientists * 2}
    end

    @required_params = %w{id}
    it_behaves_like "with param options"

    it_behaves_like "technology existing"

    it "should update scientist count" do
      invoke @action, @params
      @controller.response_params[:technology]['scientists'].should == \
        @params['scientists']
    end
  end

  describe "technologies|pause" do
    before(:each) do
      @action = "technologies|pause"
      @technology = Factory.create :technology_upgrading, :level => 1,
        :player => player
      @params = {'id' => @technology.id}
    end

    @required_params = %w{id}
    it_behaves_like "with param options"

    it_behaves_like "technology existing"

    it "should return paused technology" do
      invoke @action, @params
      Technology.find(
        @controller.response_params[:technology]['id']
      ).should be_paused
    end
  end

  describe "technologies|resume" do
    before(:each) do
      @action = "technologies|resume"
      @technology = Factory.create :technology_paused, :level => 1,
        :player => player
      @params = {'id' => @technology.id, 
        'scientists' => @technology.scientists_min}
    end

    @required_params = %w{id scientists}
    it_behaves_like "with param options"

    it_behaves_like "technology existing"

    it "should return resumed technology" do
      invoke @action, @params
      Technology.find(
        @controller.response_params[:technology]['id']
      ).should be_upgrading
    end
  end

  describe "technologies|accelerate" do
    before(:each) do
      @action = "technologies|accelerate"
      player.creds = 1000000
      player.save!

      @technology = Factory.create :technology_upgrading, :level => 1,
        :player => player
      @params = {'id' => @technology.id,
        'index' => CONFIG['creds.upgradable.speed_up'].size - 1}
    end

    it "should raise error when providing wrong index" do
      lambda do
        invoke @action, @params.merge('index' => @params['index'] + 1)
      end.should raise_error(GameLogicError)
    end

    it "should accelerate technology" do
      player.stub_chain(:technologies, :find).with(@technology.id).
        and_return(@technology)
      Creds.should_receive(:accelerate!).with(@technology, @params['index'])
      invoke @action, @params
    end

    it "should respond with technology" do
      invoke @action, @params
      @technology.reload
      response_should_include(:technology => @technology.as_json)
    end
  end

  describe "technologies|unlearn" do
    before(:each) do
      @technology = Factory.create(:technology, :player => player)

      @action = "technologies|unlearn"
      @params = {'id' => @technology.id}
    end

    it "should fail if technology does not belong to player" do
      technology = Factory.create(:technology)
      lambda do
        invoke @action, @params.merge('id' => technology.id)
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should call #unlearn! on technology" do
      player.stub_chain(:technologies, :find).with(@technology.id).
        and_return(@technology)
      @technology.should_receive(:unlearn!)
      invoke @action, @params
    end
  end
end