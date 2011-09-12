require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

shared_examples_for "checking ownership" do
  it "should not allow changing queues of constructor player doesn't own" do
    @planet.player = nil
    @planet.save!

    lambda do
      invoke @action, @params
    end.should raise_error(GameLogicError)
  end
end

describe ConstructionQueuesController do
  include ControllerSpecHelper

  before(:each) do
    init_controller ConstructionQueuesController, :login => true
    @planet = Factory.create :planet, :player => player
    @constructor = Factory.create :b_constructor_test, :planet => @planet
    @type = "Unit::TestUnit"
    @uq1 = ConstructionQueue.push(@constructor.id, @type + "1", 100)
    @uq2 = ConstructionQueue.push(@constructor.id, @type + "2", 100)
    @uq3 = ConstructionQueue.push(@constructor.id, @type + "3", 100)
    @uq4 = ConstructionQueue.push(@constructor.id, @type + "4", 100)
    @uq5 = ConstructionQueue.push(@constructor.id, @type + "5", 100)
  end

  describe "construction_queues|index" do
    before(:each) do
      @action = "construction_queues|index"
      @method = 'push'
      @params = {'constructor_id' => @constructor.id}
    end

    it_behaves_like "only push"

    @required_params = %w{constructor_id}
    it_behaves_like "with param options"

    it "should respond with constructor id" do
      should_respond_with \
        hash_including(
          :constructor_id => @constructor.id
        )
      push @action, @params
    end

    it "should respond with new queue" do
      should_respond_with \
        hash_including(
          :entries => @constructor.construction_queue_entries.map(&:as_json)
        )
      push @action, @params
    end
  end

  describe "construction_queues|move" do
    before(:each) do
      @action = "construction_queues|move"
      @params = {'id' => @uq2.id, 'position' => @uq4.position,
        'count' => 2}
    end

    @required_params = %w{id position}
    it_behaves_like "with param options"
    it_behaves_like "checking ownership"

    it "should move the entry" do
      ConstructionQueue.should_receive(:move).with(
        @uq2, @params['position'].to_i, @params['count']
      )
      invoke @action, @params
    end
  end

  describe "construction_queues|reduce" do
    before(:each) do
      @action = "construction_queues|reduce"
      @params = {'id' => @uq2.id, 'count' => @uq2.count / 4}
    end

    @required_params = %w{id count}
    it_behaves_like "with param options"
    it_behaves_like "checking ownership"

    it "should reduce the entry" do
      ConstructionQueue.should_receive(:reduce).with(
        @uq2, @params['count'].to_i
      )
      invoke @action, @params
    end
  end
end