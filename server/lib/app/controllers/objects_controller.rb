# Controller that is responsible for pushing object updates to client.
class ObjectsController < GenericController
  # Pushes information about newly created objects to client.
  #
  # Invocation: by server
  #
  # Params:
  # - objects (Object[]): objects that were created
  #
  # Response:
  # - objects (Hash): objects that were created:
  #   {
  #     "Unit::Trooper" => [Unit#as_json, ...],
  #     "class_name" => [object, ...]
  #   }
  #
  ACTION_CREATED = 'objects|created'

  CREATED_OPTIONS = logged_in + only_push + required(:objects => Array)
  def self.created_scope(m); objects_scope(m); end
  def self.created_action(m)
    respond m, :objects => prepare(m.player, m.params['objects'])
  end

  # Pushes information about updated objects to client.
  #
  # Invocation: by server
  #
  # Params:
  # - objects (Object[]): objects that are being updated
  # - reason (Symbol): reason why this object was updated
  #
  # Response:
  # - objects (Object[]): objects that are being updated
  #   {
  #     "Unit::Trooper" => [Unit#as_json, ...],
  #     "class_name" => [object, ...]
  #   }
  # - reason (String): reason why this object was updated
  #
  ACTION_UPDATED = 'objects|updated'

  UPDATED_OPTIONS = logged_in + only_push +
    required(:objects => Array, :reason => [Symbol, String])
  def self.updated_scope(m); objects_scope(m); end
  def self.updated_action(m)
    respond m,
      :objects => prepare(m.player, m.params['objects']),
      :reason => m.params['reason'].to_s
  end

  # Pushes information about destroyed objects to client.
  #
  # Invocation: by server
  #
  # Parameters:
  # - objects (Object[]): objects that are being destroyed
  # - reason (String): why they were destroyed
  #
  # Response:
  # - object_ids (Fixnum[]): object ids that are being destroyed
  #   {
  #     "Unit::Trooper" => [1, ...],
  #     "class_name" => [id, ...]
  #   }
  # - reason (String): reason why this object were destroyed
  #
  ACTION_DESTROYED = 'objects|destroyed'

  DESTROYED_OPTIONS = logged_in + only_push +
    required(:objects => Array, :reason => [Symbol, String])
  def self.destroyed_scope(m); objects_scope(m); end
  def self.destroyed_action(m)
    respond m,
      :object_ids => prepare_destroyed(m.params['objects']),
      :reason => m.params['reason'].to_s
  end

  protected
  class << self
    private
    def objects_scope(m); scope.player(m.player); end

    def prepare(player, objects)
      resolver = StatusResolver.new(player)

      group_by_class(objects).inject({}) do |hash, (class_name, class_objects)|
        hash[class_name] = cast_perspective(player, class_objects, resolver)
        hash
      end
    end

    def prepare_destroyed(objects)
      group_by_class(objects).inject({}) do |hash, (class_name, class_objects)|
        hash[class_name] = class_objects.map(&:id)
        hash
      end
    end

    def group_by_class(objects)
      objects.group_to_hash { |object| object.class.to_s }
    end

    # Cast given objects to players perspective. E.g. If object is a planet
    # and that player owns it, it should get more data than the one that does
    # not own it.
    def cast_perspective(player, objects, resolver)
      objects.map do |object|
        case object
        when Unit
          object.as_json(:perspective => resolver)
        when SsObject::Planet
          object.as_json(
            :owner => object.player_id == player.id,
            :view => object.observer_player_ids.include?(player.id),
            :perspective => resolver
          )
        else
          object.as_json
        end
      end
    end
  end
end