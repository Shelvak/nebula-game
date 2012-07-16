class Galaxy < ActiveRecord::Base
  DScope = Dispatcher::Scope
  include Parts::WithLocking

  include ::Zone

  # FK :dependent => :delete_all
  has_many :fow_galaxy_entries
  # FK :dependent => :delete_all
  has_many :players
  # FK :dependent => :delete_all
  has_many :alliances
  # FK :dependent => :delete_all
  has_many :solar_systems
  # FK :dependent => :delete_all
  has_many :market_rates
  # FK :dependent => :delete_all
  has_many :market_offers

  # Is this is a development galaxy? Callbacks to web will not be ensued in
  # development galaxies.
  def dev?; Cfg.development_galaxy?(ruleset); end

  def to_s
    "<Galaxy(#{id}) ruleset:#{ruleset} pool(zones:#{pool_free_zones
      } home_ss:#{pool_free_home_ss}) callback:#{callback_url} created:#{
      created_at} apocalypse:#{apocalypse_start} dev:#{dev?}>"
  end

  # Returns number of wormholes in this galaxy.
  def wormhole_count
    without_locking do
      solar_systems.where(kind: SolarSystem::KIND_WORMHOLE).count
    end
  end

  # Returns ID of battleground solar system.
  def self.battleground_id(galaxy_id)
    without_locking do
      SolarSystem.select("id").
        where(
          galaxy_id: galaxy_id, x: nil, y: nil,
          kind: SolarSystem::KIND_BATTLEGROUND
        ).
        c_select_value
    end.to_i
  end

  # Returns ID of battleground solar system.
  def self.apocalypse_start(galaxy_id)
    without_locking do
      time = Galaxy.select("apocalypse_start").where(:id => galaxy_id).
        c_select_value
      time.is_a?(String) ? Time.parse(time) : time
    end
  end

  # Returns units visible for _player_ in +Galaxy+.
  def self.units(player, fow_entries=nil)
    fow_entries ||= FowGalaxyEntry.for(player)

    Unit.where(
      "(`player_id` IN (?) AND `location_galaxy_id`=?) OR (%s)" %
        FowGalaxyEntry.conditions(fow_entries),
      player.friendly_ids, player.galaxy_id
    ).all
  end

  # Returns closest wormhole which is near x, y point. Returns nil
  # if you do not see any wormholes.
  def self.closest_wormhole(galaxy_id, x, y)
    SolarSystem.where(
      :galaxy_id => galaxy_id, :kind => SolarSystem::KIND_WORMHOLE
    ).select(
      "*, SQRT(POW(x - #{x.to_i}, 2) + POW(y - #{y.to_i}, 2)) as distance"
    ).order("distance ASC").first
  end

  # Creates a new galaxy. This might take a lot of time depending on
  # _free_zones_ and _free_home_ss_ parameters.
  #
  # @param [String] ruleset Ruleset for this new galaxy.
  # @param [String] callback_url URL for events that should be posted back to
  # web.
  # @param [Fixnum] pool_free_zones Number of ensured free zones in the galaxy
  # when the pooler runs.
  # @param [Fixnum] pool_free_home_ss Number of ensured free home solar systems
  # when the pooler runs.
  # @return [Galaxy] Newly created galaxy.
  def self.create_galaxy(
    ruleset, callback_url, pool_free_zones, pool_free_home_ss=nil
  )
    typesig binding, String, String, Fixnum, [NilClass, Fixnum]

    CONFIG.with_set_scope(ruleset) do
      pool_free_home_ss ||= pool_free_zones * Cfg.galaxy_zone_max_player_count

      galaxy = new(
        ruleset: ruleset, callback_url: callback_url,
        pool_free_zones: pool_free_zones, pool_free_home_ss: pool_free_home_ss
      )
      galaxy.save!

      SpaceMule.instance.fill_galaxy(galaxy)

      spawn_callback(galaxy)
      create_metal_system_offer_callback(galaxy)
      create_energy_system_offer_callback(galaxy)
      create_zetium_system_offer_callback(galaxy)

      galaxy
    end
  end

  # Create player in galaxy _galaxy_id_ with Player#web_user_id, Player#name
  # and Player#trial.
  def self.create_player(galaxy_id, web_user_id, name, trial)
    ruleset = without_locking do
      Galaxy.select("ruleset").where(id: galaxy_id).c_select_value
    end

    raise ArgumentError, "Cannot find galaxy with ID #{galaxy_id}!" \
      if ruleset.nil?

    CONFIG.with_set_scope(ruleset) do
      player = Player.new(
        galaxy_id: galaxy_id, web_user_id: web_user_id, name: name, trial: trial,
        planets_count: 1, population_cap: Building::Mothership.population(1),
        creds: Cfg.player_starting_creds
      )
      player.save!

      Quest.start_player_quest_line(player.id)

      CallbackManager.register(
        player, CallbackManager::EVENT_CHECK_INACTIVE_PLAYER,
        Cfg.player_inactivity_time(player.points).from_now
      )

      connection.execute(%Q{
      UPDATE `#{SolarSystem.table_name}` SET
        kind=#{SolarSystem::KIND_NORMAL}, player_id=#{player.id}
      WHERE kind=#{SolarSystem::KIND_POOLED} LIMIT 1
      })

      home_ss = player.home_solar_system
      raise "We've ran out of pooled solar systems in galaxy #{galaxy_id}!" \
        if home_ss.nil?

      # Assign planet attributes so that metadata would be correct.
      now = Time.now
      scope = SsObject::Planet.where(solar_system_id: home_ss.id)
      scope.update_all(last_resources_update: now)
      scope.where("owner_changed IS NOT NULL").
        update_all(owner_changed: now, player_id: player.id)

      # Finally attach the zone.
      zone = Galaxy::Zone.for_enrollment(
        galaxy_id, Cfg.galaxy_zone_maturity_age
      )
      x, y = zone.free_spot_coords(galaxy_id)
      home_ss.attach!(x, y)

      player
    end
  end

  SPAWN_SCOPE = DScope.world
  def self.spawn_callback(galaxy)
    galaxy.spawn_convoy!
    CallbackManager.register(
      galaxy, CallbackManager::EVENT_SPAWN,
      Cfg.next_convoy_time(galaxy.wormhole_count)
    )
  end

  CREATE_METAL_SYSTEM_OFFER_SCOPE = DScope.world
  def self.create_metal_system_offer_callback(galaxy)
    MarketOffer.create_system_offer(galaxy.id, MarketOffer::KIND_METAL).save!
  end

  CREATE_ENERGY_SYSTEM_OFFER_SCOPE = DScope.world
  def self.create_energy_system_offer_callback(galaxy)
    MarketOffer.create_system_offer(galaxy.id, MarketOffer::KIND_ENERGY).save!
  end

  CREATE_ZETIUM_SYSTEM_OFFER_SCOPE = DScope.world
  def self.create_zetium_system_offer_callback(galaxy)
    MarketOffer.create_system_offer(galaxy.id, MarketOffer::KIND_ZETIUM).save!
  end

  # Saves statistical galaxy data for when somebody wins the galaxy.
  # @param galaxy_id [Fixnum]
  # @return [TrueClass]
  def self.save_finish_data(galaxy_id)
    ratings = Player.ratings(galaxy_id)
    alliance_ratings = Alliance.ratings(galaxy_id)

    data = JSON.generate({
      'date' => Time.now,
      'apocalypse' => false,
      'ratings' => ratings,
      'alliance_ratings' => alliance_ratings
    })
    MAILER.call("WIN", "").call("We have a winner!\n\n" + data) \
      if App.in_production?
    File.open(
      File.join(ROOT_DIR, "galaxy-#{galaxy_id}-finish-data.txt"),
      "w"
    ) { |f| f.write data } unless App.in_test?

    true
  end

  # Check if this galaxy should be finished. If so - finish it.
  # @param victory_points [Fixnum]
  def check_if_finished!(victory_points)
    finish! if ! dev? && ! finished? && victory_points >= Cfg.vps_for_winning
  end

  def finished?
    ! apocalypse_start.nil?
  end

  # End galaxy and start countdown of apocalypse.
  def finish!
    self.class.save_finish_data(id)

    self.apocalypse_start = Cfg.apocalypse_start_time

    save!
    convert_vps_to_creds!

    EventBroker.fire(
      Event::ApocalypseStart.new(id, apocalypse_start), EventBroker::CREATED
    )

    true
  end

  def apocalypse_started?
    finished? && apocalypse_start < Time.now
  end

  # Returns which apocalypse day it is on _date_. Uses +Time#now+ if _date_ is
  # nil.
  def apocalypse_day(date=nil)
    raise ArgumentError.new("Apocalypse hasn't started yet! Start on: #{
      apocalypse_start}") unless apocalypse_started?

    date ||= Time.now
    ((date - apocalypse_start) / 1.day).round + 1
  end

  # Saves statistical galaxy data for when somebody wins the galaxy.
  # @param galaxy_id [Fixnum]
  # @return [TrueClass]
  def self.save_apocalypse_finish_data(galaxy_id)
    galaxy = without_locking { Galaxy.find(galaxy_id) }
    ratings = Player.ratings(galaxy_id)

    data = JSON.generate({
      'date' => Time.now,
      'apocalypse_start' => galaxy.apocalypse_start,
      'apocalypse' => true,
      'ratings' => ratings
    })
    MAILER.call("WIN", "").call("We have an apocalypse winner!\n\n" + data) \
      if App.in_production?
    File.open(
      File.join(ROOT_DIR, "galaxy-#{galaxy_id}-apocalypse-finish-data.txt"),
      "w"
    ) { |f| f.write data } unless App.in_test?

    true
  end

  def check_if_apocalypse_finished!
    raise ArgumentError.new(
      "Cannot check if apocalypse finished if it hasn't started!"
    ) unless apocalypse_started?

    self.class.save_apocalypse_finish_data(id) \
      unless without_locking { players.where('planets_count > 0').exists? }
  end

  # Convert victory points to creds.
  #
  # If player is not in alliance:
  # - convert all victory points to creds.
  #
  # If player is in alliance:
  # - each player gets half alliance victory points + non-alliance vps.
  # - distribute half avps from each player evenly amongst alliance members.
  # - convert points to creds.
  #
  def convert_vps_to_creds!
    alliance_ids = without_locking do
      alliances.select("id").c_select_values.map(&:to_i)
    end

    alliance_ids.each do |alliance_id|
      alliance_players = players.where(:alliance_id => alliance_id).all

      total_alliance_vps = alliance_players.map do |player|
        player.alliance_vps / 2
      end.sum

      alliance_vps_per_player = total_alliance_vps / alliance_players.size
      alliance_players.each do |player|
        personal_creds = (player.victory_points - player.alliance_vps) +
          (player.alliance_vps / 2)
        added_creds = personal_creds + alliance_vps_per_player
        unless added_creds == 0
          player.creds += added_creds
          player.save!
          Notification.create_for_vps_to_creds_conversion(
            player.id, personal_creds, total_alliance_vps,
            alliance_vps_per_player
          )
        end
      end
    end

    players.where(:alliance_id => nil).find_each do |player|
      unless player.victory_points == 0
        player.creds += player.victory_points
        player.save!
        Notification.create_for_vps_to_creds_conversion(
          player.id, player.victory_points, nil, nil
        )
      end
    end
  end

  # Spawns moving convoy. If source or target are not given, picks random
  # wormholes in the galaxy.
  def spawn_convoy!(source=nil, target=nil)
    if source.nil? && target.nil?
      total = without_locking { solar_systems.wormhole.count }
      return if total < 2
    end

    CONFIG.with_set_scope(ruleset) do
      get_wormhole = lambda do
        row = without_locking do
          solar_systems.wormhole.select("x, y").limit("#{rand(total)}, 1").
            c_select_one
        end

        GalaxyPoint.new(id, row["x"], row["y"])
      end

      # Get two wormholes.
      while source == target
        source ||= get_wormhole.call
        target = get_wormhole.call
      end

      # Create units.
      days = ((Time.now - created_at) / 1.day).round
      units = UnitBuilder.from_random_ranges(
        Cfg.galaxy_convoy_units_definition, source, nil, days, 1
      )
      Unit.save_all_units(units, nil, EventBroker::CREATED)
      Cooldown.create_or_update!(source, Cfg.after_spawn_cooldown)

      unit_ids = units.map(&:id)
      LOGGER.debug "Launching convoy #{source} -> #{target} with unit ids #{
        unit_ids.inspect}"
      route = UnitMover.move(nil, unit_ids, source, target, false,
        Cfg.convoy_speed_modifier)

      units.each do |unit|
        CallbackManager.register(
          unit, CallbackManager::EVENT_DESTROY,
          # If we destroy units at same time as they arrive to their
          # destination then callback execution order is not determined and
          # units can be destroyed before they make their final hop. This
          # causes problems in the client, therefore we ensure that destroy
          # callbacks will be executed after last hop.
          route.arrives_at + 1
        )
      end

      route
    end
  end

  # Return solar system with coordinates x, y.
  def by_coords(x, y)
    solar_systems.find(:first, :conditions => {:x => x, :y => y})
  end

  # Which day is it? Rounded to integer.
  def current_day
    ((Time.now - created_at) / 1.day).round
  end

  def as_json(options=nil)
    attributes
  end

  private
end