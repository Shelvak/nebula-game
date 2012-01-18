class TestObject
  include Parts::Object
end

module DispatcherEventHandlerObjectHelpers
  def test_object_receive(kind, dispatcher, reason, objects=nil)
    objects ||= [TestObject.new]

    case kind
    when :creation
      action = ObjectsController::ACTION_CREATED
      context = DispatcherEventHandler::ObjectResolver::CONTEXT_CHANGED
      params = {'objects' => objects}
    when :change
      action = ObjectsController::ACTION_UPDATED
      context = DispatcherEventHandler::ObjectResolver::CONTEXT_CHANGED
      params = {'objects' => objects, 'reason' => reason}
    when :destruction
      action = ObjectsController::ACTION_DESTROYED
      context = DispatcherEventHandler::ObjectResolver::CONTEXT_DESTROYED
      params = {'objects' => objects, 'reason' => reason}
    end

    player_ids = [1, 2]
    filter = :filter

    data = DispatcherEventHandler::ObjectResolver::Data.new(player_ids, filter)
    objects.each { |obj| data << obj }
    dataset = [data]
    DispatcherEventHandler::ObjectResolver.should_receive(:resolve).
      with(objects, reason, context).and_return(dataset)

    player_ids.each do |player_id|
      dispatcher.should_receive(:push_to_player).
        with(player_id, action, params, filter)
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