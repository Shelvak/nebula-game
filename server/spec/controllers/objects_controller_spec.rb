require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

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

    it_behaves_like "with param options", %w{objects}
    it_behaves_like "only push"

    it "should include prepared objects" do
      prepared = :prepared
      @controller.should_receive(:prepare).with(@params['objects']).
        and_return(prepared)

      push @action, @params
      response_should_include(:objects => prepared)
    end
  end

  describe "objects|updated" do
    before(:each) do
      @action = "objects|updated"
      @reason = :reason
      @params = {'objects' => [@object], 'reason' => @reason}
    end

    it_behaves_like "with param options", %w{objects reason}
    it_behaves_like "only push"

    it "should include prepared objects" do
      prepared = :prepared
      @controller.should_receive(:prepare).with(@params['objects']).
        and_return(prepared)

      push @action, @params
      response_should_include(:objects => prepared)
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

    it_behaves_like "with param options", %w{objects reason}
    it_behaves_like "only push"

    it "should include prepared object ids" do
      prepared = :prepared
      @controller.should_receive(:prepare_destroyed).with(@params['objects']).
        and_return(prepared)

      push @action, @params
      response_should_include(:object_ids => prepared)
    end

    it "should include reason" do
      push @action, @params
      response_should_include(:reason => 'reason')
    end
  end

  describe "#prepare" do
    before(:each) do
      @objects = [
        Factory.create(:unit, :player => player),
        Factory.create(:unit),
        Factory.create(:building)
      ]
      @grouped_objects = @objects.group_to_hash { |object| object.class.to_s }
      @result = @controller.send(:prepare, @objects)
    end

    it "should group objects by class" do
      @grouped_objects.each do |class_name, objs|
        @result[class_name].size.should == objs.size
      end
    end

    it "should cast them to perspective" do
      resolver = StatusResolver.new(player)
      @grouped_objects.each do |class_name, objs|
        @result[class_name].should == @controller.
          send(:cast_perspective, objs, resolver)
      end
    end
  end

  describe "#prepare_destroyed" do
    before(:each) do
      @objects = [
        Factory.create(:unit),
        Factory.create(:unit),
        Factory.create(:building)
      ]
      @grouped_objects = @objects.group_to_hash { |object| object.class.to_s }
      @result = @controller.send(:prepare_destroyed, @objects)
    end

    it "should group objects by class" do
      @grouped_objects.each do |class_name, objs|
        @result[class_name].size.should == objs.size
      end
    end

    it "should map them to ids" do
      @grouped_objects.each do |class_name, objs|
        @result[class_name].should == objs.map(&:id)
      end
    end
  end

  describe "#cast_perspective" do
    before(:each) do
      @resolver = StatusResolver.new(player)
    end

    describe Unit do
      it "should call #as_json with perspective" do
        unit = Factory.create(:unit)
        @controller.send(:cast_perspective, [unit], @resolver).should ==
          [unit.as_json(:perspective => @resolver)]
      end
    end

    describe SsObject::Planet do
      before(:each) do
        @planet = Factory.create(:planet)
        @return_value = :json
      end

      it "should call #as_json with perspective" do
        @planet.should_receive(:as_json).and_return do |options|
          options[:perspective].should == @resolver
          @return_value
        end
        @controller.send(:cast_perspective, [@planet], @resolver).should ==
          [@return_value]
      end

      it "should call #as_json with :owner => false if player is not owner" do
        @planet.should_receive(:as_json).and_return do |options|
          options[:owner].should be_false
          @return_value
        end
        @controller.send(:cast_perspective, [@planet], @resolver).should ==
          [@return_value]
      end

      it "should call #as_json with :owner => true if player is owner" do
        @planet.player = player
        @planet.should_receive(:as_json).and_return do |options|
          options[:owner].should be_true
          @return_value
        end
        @controller.send(:cast_perspective, [@planet], @resolver).should ==
          [@return_value]
      end

      it "should call #as_json with :view => true if player can't view it" do
        @planet.should_receive(:as_json).and_return do |options|
          options[:view].should be_false
          @return_value
        end
        @controller.send(:cast_perspective, [@planet], @resolver).should ==
          [@return_value]
      end

      it "should call #as_json with :view => true if player can view it" do
        @planet.stub!(:observer_player_ids).and_return([player.id])
        @planet.should_receive(:as_json).and_return do |options|
          options[:view].should be_true
          @return_value
        end
        @controller.send(:cast_perspective, [@planet], @resolver).should ==
          [@return_value]
      end
    end

    describe "anything else" do
      it "should call #as_json" do
        obj = Object.new
        def obj.as_json; :json; end
        @controller.send(:cast_perspective, [obj], @resolver).should ==
          [obj.as_json]
      end
    end
  end
end