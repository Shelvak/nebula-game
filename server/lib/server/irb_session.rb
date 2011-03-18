require 'irb'

module IRB # :nodoc:
  def self.start_session(binding)
    unless @__initialized
      args = ARGV.dup
      ARGV.replace([])
      IRB.setup(nil)
      ARGV.replace(args)
      @__initialized = true
    end

    workspace = WorkSpace.new(binding)

    irb = Irb.new(workspace)

    @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
    @CONF[:MAIN_CONTEXT] = irb.context

    catch(:IRB_EXIT) do
      irb.eval_input
    end
  end
end

# Various helpers for development cheating.
module Dev
  def self.add_creds(player, creds=200000)
    player = Player.find(player) if player.is_a?(Fixnum)
    player.creds += creds
    player.save!

    player
  end

  def self.max_resources(planet, rate=100000, storage=1000000)
    planet = SsObject::Planet.find(planet) if planet.is_a?(Fixnum)
    planet.metal_rate = planet.energy_rate = planet.zetium_rate = rate
    planet.metal = planet.metal_storage = storage
    planet.energy = planet.energy_storage = storage
    planet.zetium = planet.zetium_storage = storage
    planet.save!
    EventBroker.fire(planet, EventBroker::CHANGED,
      EventBroker::REASON_RESOURCES_CHANGED)

    planet
  end

  def self.seed(player_id=1, player_count=200)
    players = {}
    player_count.times { |i| players["player #{i}"] = "player #{i}" }

    player = Player.find(player_id)
    SpaceMule.instance.create_players(player.galaxy_id,
      player.galaxy.ruleset, players)
    radar(player_id)
  end

  def self.radar(player_id=1, x=0, y=0, strength=10)
    Trait::Radar.increase_vision(
      [
        (x - strength)..(x + strength),
        (y - strength)..(y + strength)
      ], Player.find(player_id))
  end
end