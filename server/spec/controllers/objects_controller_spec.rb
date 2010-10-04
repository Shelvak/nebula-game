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
      response_should_include(:objects => [@object])
    end

    it "should include object class" do
      push @action, @params
      response_should_include(:class_name => "Unit::Trooper")
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

    it "should include object" do
      push @action, @params
      response_should_include(:objects => [@object])
    end

    it "should include update reason" do
      push @action, @params
      response_should_include(:reason => @reason.to_s)
    end

    it "should include object class" do
      push @action, @params
      response_should_include(:class_name => "Unit::Trooper")
    end
  end

  describe "objects|destroyed" do
    before(:each) do
      @action = "objects|destroyed"
      @params = {'objects' => [@object]}
    end

    @required_params = %w{objects}
    it_should_behave_like "with param options"
    it_should_behave_like "only push"

    it "should include objects id" do
      push @action, @params
      response_should_include(:object_ids => [@object.id])
    end

    it "should include object class" do
      push @action, @params
      response_should_include(:class_name => "Unit::Trooper")
    end
  end
end