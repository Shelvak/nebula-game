# Informs in what scope some work should be done.
class Dispatcher::Scope
  CHAT   = :chat
  GALAXY = :galaxy
  PLAYER = :player
  SERVER = :server

  attr_reader :ids

  def initialize(scope, ids)
    @scope = scope
    @ids = ids.freeze
  end

  def chat?; @scope == CHAT; end
  def galaxy?; @scope == GALAXY; end
  def player?; @scope == PLAYER; end
  def server?; @scope == SERVER; end

  def to_s
    "<#{self.class} scope=#{@scope} ids=#{@ids.inspect}>"
  end

  class << self
    # This work involves whole server.
    def server
      new(SERVER, [nil])
    end

    # This work only involves chat.
    def chat
      new(CHAT, [nil])
    end

    # This work involves whole galaxy, however its players should not be blocked.
    def galaxy(galaxy_ir_id)
      typesig binding, [Galaxy, Fixnum]
      new(GALAXY, [galaxy_ir_id.is_a?(Fixnum) ? galaxy_ir_id : galaxy_ir_id.id])
    end

    # This work involves several players.
    def player(player_or_id)
      typesig binding, [Player, Fixnum]
      players([player_or_id.is_a?(Fixnum) ? player_or_id : player_or_id.id])
    end

    # This work involves several players.
    def players(player_ids)
      typesig binding, Array

      new(PLAYER, player_ids)
    end

    # This work involves everyone who is friendly to player.
    def friendly_to_player(player)
      typesig binding, [NilClass, Player]

      player.nil? ? players([nil]) : players(player.friendly_ids)
    end

    # This work involves only planet owner.
    def planet_owner(planet_or_id)
      typesig binding, [Fixnum, SsObject::Planet]

      planet_id = planet_or_id.is_a?(Fixnum) ? planet_or_id : planet_or_id.id

      player_id = SsObject::Planet.select(:player_id).where(:id => planet_id).
        c_select_value
      raise Dispatcher::UnresolvableScope.new(
        "Cannot resolve scope for planet #{planet_id}: planet not found"
      ) if player_id.nil?

      player(player_id)
    end

    # This work involves planet, so it depends on every player that has units in
    # that planet + owner and his alliance.
    def planet(planet_or_id)
      typesig binding, [SsObject::Planet, Fixnum]

      planet = planet_or_id.is_a?(Fixnum) \
        ? SsObject::Planet.find(planet_id) : planet_or_id
      players(planet.observer_player_ids)
    rescue ActiveRecord::RecordNotFound => e
      raise Dispatcher::UnresolvableScope, e.message, e.backtrace
    end

    # This work involves NPC building, which can only be seen by planet owner.
    def npc_building(building_id)
      planet_id = Building.select(:planet_id).where(:id => building_id).
        c_select_value
      raise Dispatcher::UnresolvableScope.new(
        "Cannot resolve scope for NPC building #{building_id}: building not found"
      ) if planet_id.nil?

      planet_owner(planet_id)
    end

    # This work involves combat in location, everybody who has combat units
    # there should be touched.
    def combat(location_point)
      typesig binding, LocationPoint

      players(Location.combat_player_ids(location_point))
    end
  end
end