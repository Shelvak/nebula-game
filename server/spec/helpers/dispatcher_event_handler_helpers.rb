class TestObject
  include Parts::Object
end

module DispatcherEventHandlerObjectHelpers
  def data(player_ids, filter, objects)
    data = DispatcherEventHandler::ObjectResolver::Data.new(player_ids, filter)
    objects.each { |obj| data << obj }
    data
  end

  def dataset(player_ids, filter, objects)
    [data(player_ids, filter, objects)]
  end

  def test_object_receive(kind, dispatcher, reason, objects=nil)
    if objects.nil?
      # Check dataset dispatching with multiple items
      objects = [TestObject.new, TestObject.new, TestObject.new]

      player_ids1 = [1, 2]
      player_ids2 = [2, 3]
      filter1 = :filter1
      filter2 = :filter2

      dataset = [
        data(player_ids1, filter1, [objects[0], objects[2]]),
        data(player_ids2, filter2, [objects[1]])
      ]
    else
      player_ids = [1, 2]
      filter = :filter

      dataset = dataset(player_ids, filter, objects)
    end

    context = case kind
      when :creation, :change
        DispatcherEventHandler::ObjectResolver::CONTEXT_CHANGED
      when :destruction
        DispatcherEventHandler::ObjectResolver::CONTEXT_DESTROYED
    end

    DispatcherEventHandler::ObjectResolver.should_receive(:resolve).
      with(objects, reason, context).and_return(dataset)

    dataset.each do |data|
      case kind
      when :creation
        action = ObjectsController::ACTION_CREATED
        params = {'objects' => data.objects}
      when :change
        action = ObjectsController::ACTION_UPDATED
        params = {'objects' => data.objects, 'reason' => reason}
      when :destruction
        action = ObjectsController::ACTION_DESTROYED
        params = {'objects' => data.objects, 'reason' => reason}
      end

      data.player_ids.each do |player_id|
        dispatcher.should_receive(:push_to_player).
          with(player_id, action, params, data.filter)
      end
    end

    objects
  end

  def test_object_creation(dispatcher, reason, objects=nil)
    test_object_receive(:creation, dispatcher, reason, objects)
  end

  def test_object_change(dispatcher, reason, objects=nil)
    test_object_receive(:change, dispatcher, reason, objects)
  end

  def test_object_destruction(dispatcher, reason, objects=nil)
    test_object_receive(:destruction, dispatcher, reason, objects)
  end
end