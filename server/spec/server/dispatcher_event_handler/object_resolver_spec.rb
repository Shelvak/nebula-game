require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe DispatcherEventHandler::ObjectResolver do
  include DispatcherEventHandlerObjectHelpers

  describe ".resolve" do
    let(:player_ids) { [1,2,3] }
    let(:friendly_ids) { [3,4,5] }
    let(:filter) { :filter }

    [:building, :tile].each do |kind|
      it "should resolve #{kind}" do
        obj = Factory.create(kind)
        planet = obj.planet
        DispatcherEventHandler::LocationResolver.should_receive(:resolve).
          with(planet.location_point).and_return([player_ids, filter])

        DispatcherEventHandler::ObjectResolver.resolve([obj], :reason).should ==
          dataset(player_ids, filter, [obj])
      end
    end

    [:unit, :wreckage, :cooldown].each do |kind|
      it "should resolve #{kind}" do
        obj = Factory.create(kind)
        DispatcherEventHandler::LocationResolver.should_receive(:resolve).
          with(obj.location).and_return([player_ids, filter])

        DispatcherEventHandler::ObjectResolver.resolve([obj], :reason).should ==
          dataset(player_ids, filter, [obj])
      end
    end

    it "should resolve Route (changed context)" do
      obj = Factory.create(:route)
      player = obj.player
      obj.stub!(:player).and_return(player.tap do |p|
        p.stub!(:friendly_ids).and_return(player_ids)
      end)

      DispatcherEventHandler::ObjectResolver.resolve(
        [obj], :reason, DispatcherEventHandler::ObjectResolver::CONTEXT_CHANGED
      ).should == dataset(player_ids, nil, [obj])
    end

    it "should not fail with NPC Route (changed context)" do
      obj = Factory.create(:route, :player => nil)
      DispatcherEventHandler::ObjectResolver.resolve(
        [obj], :reason, DispatcherEventHandler::ObjectResolver::CONTEXT_CHANGED
      ).should == []
    end

    it "should resolve Route (destroyed context for friendly ids)" do
      obj = Factory.create(:route)

      obj.stub_chain(:player, :friendly_ids).and_return(friendly_ids)

      DispatcherEventHandler::LocationResolver.should_receive(:resolve).
        with(obj.current).and_return([player_ids, filter])

      DispatcherEventHandler::ObjectResolver.resolve(
        [obj], :reason,
        DispatcherEventHandler::ObjectResolver::CONTEXT_DESTROYED
      ).should == dataset(player_ids | friendly_ids, nil, [obj])
    end

    it "should not fail with NPC Route (destroyed context)" do
      obj = Factory.create(:route, :player => nil)

      DispatcherEventHandler::ObjectResolver.resolve(
        [obj], :reason,
        DispatcherEventHandler::ObjectResolver::CONTEXT_DESTROYED
      ).should == []
    end

    it "should resolve Planet" do
      obj = Factory.create(:planet)
      SolarSystem.should_receive(:observer_player_ids).
        with(obj.solar_system_id).and_return(player_ids)

      DispatcherEventHandler::ObjectResolver.resolve([obj], :reason).should ==
        dataset(
          player_ids,
          Dispatcher::PushFilter.solar_system(obj.solar_system_id),
          [obj]
        )
    end

    [
      ["Notification", lambda { Factory.create(:notification) }],
      ["ClientQuest", lambda { ClientQuest.new(1, 2) }],
      ["QuestProgress", lambda { Factory.create(:quest_progress) }],
      ["ObjectiveProgress", lambda { Factory.create(:objective_progress) }],
    ].each do |kind, obj_creator|
      it "should resolve #{kind}" do
        obj = obj_creator.call
        DispatcherEventHandler::ObjectResolver.resolve([obj], :reason).should ==
          dataset([obj.player_id], nil, [obj])
      end
    end

    it "should resolve SolarSystem" do
      ss = Factory.create(:solar_system)

      DispatcherEventHandler::LocationResolver.should_receive(:resolve).
        with(ss.galaxy_point).and_return([player_ids, filter])

      DispatcherEventHandler::ObjectResolver.resolve([ss], :reason).should ==
        dataset(player_ids, filter, [ss])
    end

    it "should resolve SolarSystemMetadata" do
      ss = Factory.create(:solar_system)
      obj = SolarSystemMetadata.new(:id => ss.id)

      DispatcherEventHandler::LocationResolver.should_receive(:resolve).
        with(ss.galaxy_point).and_return([player_ids, filter])

      DispatcherEventHandler::ObjectResolver.resolve([obj], :reason).should ==
        dataset(player_ids, filter, [obj])
    end

    it "should resolve mixed objects" do
      player1 = Factory.create(:player)
      player2 = Factory.create(:player)

      notifications = [
        Factory.create(:notification, :player => player1),
        Factory.create(:notification, :player => player2),
        Factory.create(:notification, :player => player1),
      ]
      quest_progresses = [
        Factory.create(:quest_progress, :player => player2),
        Factory.create(:quest_progress, :player => player1),
      ]

      objects = notifications + quest_progresses

      DispatcherEventHandler::ObjectResolver.resolve(objects, :reason).should ==
        [
          data([player1.id], nil,
            [notifications[0], notifications[2], quest_progresses[1]]),
          data([player2.id], nil, [notifications[1], quest_progresses[0]])
        ]
    end
  end
end

