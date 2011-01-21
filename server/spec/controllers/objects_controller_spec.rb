require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe ObjectsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller ObjectsController, :login => true
    @object = Factory.create :u_trooper
  end

  describe "objects|created" do
    before(:each) do
      @action = "objects|created"
      @params = {'objects' => [@object]}
    end

    @required_params = %w{objects}
    it_should_behave_like "with param options"
    it_should_behave_like "only push"

    it "should include object" do
      push @action, @params
      response_should_include(:objects => {
          @object.class.to_s => [@object.as_json(:perspective => player)]
      })
    end
  end

  describe "objects|updated" do
    before(:each) do
      @action = "objects|updated"
      @reason = :reason
      @params = {'objects' => [@object], 'reason' => @reason}
    end

    @required_params = %w{objects reason}
    it_should_behave_like "with param options"
    it_should_behave_like "only push"

    it "should cast planets to perspective" do
      planet = Factory.create(:planet, :player => player)
      push @action, @params.merge('objects' => [planet])
      response[:objects]["SsObject::Planet"].should include(
        planet.as_json(:resources => true, :perspective => player)
      )
    end

    it "should cast asteroids to perspective" do
      asteroid = Factory.create(:sso_asteroid)
      Factory.create(:fse_player, :player => player,
        :solar_system => asteroid.solar_system, :player_planets => true)
      push @action, @params.merge('objects' => [asteroid])
      response[:objects]["SsObject::Asteroid"].should include(
        asteroid.as_json(:resources => true))
    end

    it "should include object" do
      push @action, @params
      response_should_include(:objects => {
          @object.class.to_s => [@object.as_json(:perspective => player)]
      })
    end

    it "should include update reason" do
      push @action, @params
      response_should_include(:reason => @reason.to_s)
    end
  end

  describe "objects|destroyed" do
    before(:each) do
      @action = "objects|destroyed"
      @params = {'objects' => [@object], 'reason' => 'reason'}
    end

    @required_params = %w{objects reason}
    it_should_behave_like "with param options"
    it_should_behave_like "only push"

    it "should include objects id" do
      push @action, @params
      response_should_include(:object_ids => {
          "Unit::Trooper" => [@object.id]
      })
    end

    it "should include reason" do
      push @action, @params
      response_should_include(:reason => 'reason')
    end
  end
end