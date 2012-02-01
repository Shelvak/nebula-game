class Dispatcher::Router
  ACTOR_CLASSES = {
    :chat_director => [Directors::Chat, 1],
    :galaxies_director => [Directors::Galaxy, 2],
    :players_director => [Directors::Player, 10]
  }

  def initialize
    @launched_actors = Set.new
  end

  def action(message)
    if message["action"].starts_with?("chat|")
      ensure_launched_actor!(:chat_director)
      Celluloid::Actor[:chat_director].work!([nil], message)
    else
      ensure_launched_actor!(:players_director)
      player_ids = [nil] # TODO: actually resolve player ids.
      Celluloid::Actor[:players_director].work!(player_ids, message)
    end
  end

  private
  def ensure_launched_actor!(name)
    unless @launched_actors.include?(name)
      klass, *args = ACTOR_CLASSES[name]
      klass.supervise_as(name, *args)
      @launched_actors.add(name)
    end
  end
end