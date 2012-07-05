require 'irb'

def xxx
  Kernel.exit
end

module IRB # :nodoc:
  def self.start_session(binding)
    $IRB_RUNNING = true

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
      DispatcherEventHandler::Buffer.instance.wrap do
        ActiveRecord::Base.connection_pool.with_new_connection do
          irb.eval_input
        end
      end
    end
  ensure
    $IRB_RUNNING = false
    Celluloid::Actor[:callback_manager].resume!
    Celluloid::Actor[:pooler].resume!
  end
end

if App.in_development?
  # Console drop-out thread.
  Thread.new do
    java.lang.Thread.current_thread.name = "irb-session"

    loop do
      if $IRB_RUNNING
        sleep 1
      else
        input = gets.chomp
        case input
        when "cc"
          puts "\n\nDropping into IRB shell. Server operation suspended."
          puts "Press CTRL+C again to exit the server.\n\n"

          puts "Pausing callback manager..."
          Celluloid::Actor[:callback_manager].pause
          puts "Pausing pooler..."
          Celluloid::Actor[:pooler].pause
          puts "Starting IRB session..."
          IRB.start_session(ROOT_BINDING)
          puts "\nIRB done. Server operation resumed.\n\n"
        end
      end
    end
  end
end

# Various helpers for development cheating.
module Dev
  def self.add_creds(player, creds=200000)
    DispatcherEventHandler::Buffer.instance.wrap do
      player = Player.find(player) if player.is_a?(Fixnum)
      player.creds += creds
      player.save!

      player
    end
  end

  def self.max_resources(planet, rate=100000, storage=1000000)
    DispatcherEventHandler::Buffer.instance.wrap do
      planet = SsObject::Planet.find(planet) if planet.is_a?(Fixnum)
      planet = SsObject::Planet.where(:name => planet).first \
        if planet.is_a?(String)
      planet.metal_generation_rate = planet.energy_generation_rate =
        planet.zetium_generation_rate = rate
      planet.metal = planet.metal_storage = storage
      planet.energy = planet.energy_storage = storage
      planet.zetium = planet.zetium_storage = storage
      planet.save!
      EventBroker.fire(planet, EventBroker::CHANGED,
        EventBroker::REASON_OWNER_PROP_CHANGE)

      planet
    end
  end

  def self.start_child_quests(parent_quest_id, player_id=1)
    DispatcherEventHandler::Buffer.instance.wrap do
      Quest.start_child_quests(parent_quest_id, player_id)
      puts "Quests started!"
    end
  end

  def self.start_all_quests(player_id=1)
    DispatcherEventHandler::Buffer.instance.wrap do
      Quest.all.each do |quest|
        Quest.start_child_quests(quest.id, player_id)
      end
      puts "All quests started!"
    end
  end

  def self.seed(player_id=1, player_count=10)
    DispatcherEventHandler::Buffer.instance.wrap do
      current_pid = Player.maximum(:id) + 1
      current_web_user_id = Player.maximum(:web_user_id) + 1
      player = Player.find(player_id)

      # Ensure we have enough solar systems.
      galaxy = player.galaxy
      galaxy.pool_free_zones = (
        player_count.to_f / Cfg.galaxy_zone_max_player_count
      ).ceil
      galaxy.pool_free_home_ss = player_count
      SpaceMule.instance.ensure_pool(
        galaxy, galaxy.pool_free_zones, galaxy.pool_free_home_ss
      )

      player_count.times do |i|
        name = "p-#{current_pid + i}"
        web_user_id = current_web_user_id + i
        puts "Creating player #{i + 1}: #{name}"
        Galaxy.create_player(player.galaxy_id, web_user_id, name, false)
      end

      true
    end
  end

  def self.radar(player_id=1, x=0, y=0, strength=10)
    DispatcherEventHandler::Buffer.instance.wrap do
      Trait::Radar.increase_vision(
        [
          (x - strength)..(x + strength),
          (y - strength)..(y + strength)
        ], Player.find(player_id))
    end
  end

  def self.radar_off(player_id=1, x=0, y=0, strength=10)
    DispatcherEventHandler::Buffer.instance.wrap do
      Trait::Radar.decrease_vision(
        [
          (x - strength)..(x + strength),
          (y - strength)..(y + strength)
        ], Player.find(player_id))
    end
  end
  
  # Example:
  # 
  #   Dev.combat(10, "3xmule,2xzeus", "2xzeus")
  #
  def self.combat(planet_id, offenders, defenders="")
    DispatcherEventHandler::Buffer.instance.wrap do
      planet = SsObject::Planet.find(planet_id)

      parse = lambda do |str|
        str.split(",").map do |part|
          match = part.match(/(\d+)x(.+)/)
          count = match[1].to_i
          type = match[2]

          [type, count]
        end
      end

      unless defenders == ""
        owner = planet.player
        raise "No planet owner in #{planet}!" if owner.nil?

        Unit.give_units(parse.call(defenders), planet, owner)
      end

      attackers = []
      parse.call(offenders).each do |type, count|
        klass = "Unit::#{type.camelcase}".constantize
        count.times do
          unit = klass.new(
            :level => 1,
            :hp => klass.hit_points,
            :location => planet,
            :flank => 0
          )
          unit.skip_validate_technologies = true

          attackers.push unit
        end
      end
      Unit.save_all_units(attackers, nil, EventBroker::CREATED)
      Combat::LocationChecker.check_location(planet.location_point)
    end
  end
  
  def self.pimp(player_id_or_name, opts={})
    DispatcherEventHandler::Buffer.instance.wrap do
      player = player_id_or_name.is_a?(Fixnum) \
        ? Player.find(player_id_or_name) \
        : Player.where(:name => player_id_or_name).first

      opts.reverse_merge! :population => true, :scientists => true,
        :creds => true, :war_points => true

      if opts[:population]
        player.population_cap = 10_000
      end
      player.scientists = player.scientists_total = 10_000 if opts[:scientists]
      player.creds = 1_000_000 if opts[:creds]
      player.war_points = 1_000_000 if opts[:war_points]

      planet = player.planets.first
      max_resources(planet.id)

      player.save!
    end
  end
end