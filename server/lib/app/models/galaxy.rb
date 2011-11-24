class Galaxy < ActiveRecord::Base
  include Zone

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

  # Is this is a development galaxy? Callbacks to web will not be ensued in
  # development galaxies.
  def dev?; Cfg.development_galaxy?(ruleset); end

  # Returns ID of battleground solar system.
  def self.battleground_id(galaxy_id)
    SolarSystem.select("id").
      where(:galaxy_id => galaxy_id, :x => nil, :y => nil).
      c_select_value.to_i
  end

  # Returns ID of battleground solar system.
  def self.apocalypse_start(galaxy_id)
    time = Galaxy.select("apocalypse_start").where(:id => galaxy_id).
      c_select_value
    time.is_a?(String) ? Time.parse(time) : time
  end

  # Returns units visible for _player_ in +Galaxy+.
  def self.units(player, fow_entries=nil)
    fow_entries ||= FowGalaxyEntry.for(player)

    conditions = "(%s) OR (%s)" % [
      sanitize_sql_for_conditions(
        {
          :player_id => player.friendly_ids,
          :location_type => Location::GALAXY,
          :location_id => player.galaxy_id
        },
        Unit.table_name
      ),
      FowGalaxyEntry.conditions(fow_entries)
    ]

    Unit.find_by_sql(
      "SELECT * FROM `#{Unit.table_name}` WHERE #{conditions}"
    )
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

  def self.create_galaxy(ruleset, callback_url)
    SpaceMule.instance.create_galaxy(ruleset, callback_url)
  end

  def self.create_player(galaxy_id, web_user_id, name)
    find(galaxy_id).create_player(web_user_id, name)
  end

  def self.on_callback(id, event)
    case event
    when CallbackManager::EVENT_SPAWN
      galaxy = find(id)
      galaxy.spawn_convoy!

      CallbackManager.register(galaxy, CallbackManager::EVENT_SPAWN,
        CONFIG.evalproperty('galaxy.convoy.time').from_now)
    when CallbackManager::EVENT_CREATE_METAL_SYSTEM_OFFER,
        CallbackManager::EVENT_CREATE_ENERGY_SYSTEM_OFFER,
        CallbackManager::EVENT_CREATE_ZETIUM_SYSTEM_OFFER
      MarketOffer.create_system_offer(
        id, MarketOffer::CALLBACK_MAPPINGS_FLIPPED[event]
      ).save!
    else
      raise ArgumentError.new("Don't know how to handle #{
        CallbackManager::STRING_NAMES[event]} (#{event})")
    end
  end

  # Saves statistical galaxy data for when somebody wins the galaxy.
  # @param galaxy_id [Fixnum]
  # @return [TrueClass]
  def self.save_galaxy_finish_data(galaxy_id)
    ratings = Player.ratings(galaxy_id)
    alliance_ratings = Alliance.ratings(galaxy_id)

    data = JSON.generate({
      'date' => Time.now,
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

  def apocalypse_started?
    finished? && apocalypse_start < Time.now
  end

  # End galaxy and start countdown of apocalypse.
  def finish!
    self.class.save_galaxy_finish_data(id)

    self.apocalypse_start = Cfg.apocalypse_start_time

    transaction do
      save!
      convert_vps_to_creds!
    end

    EventBroker.fire(
      Event::ApocalypseStart.new(id, apocalypse_start), EventBroker::CREATED
    )

    true
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
    alliance_ids = alliances.select("id").c_select_values.map(&:to_i)

    alliance_ids.each do |alliance_id|
      alliance_players = players.where(:alliance_id => alliance_id).all

      total_alliance_vps = alliance_players.map do |player|
        player.alliance_vps / 2
      end.sum

      alliance_vps_per_player = total_alliance_vps / alliance_players.size
      alliance_players.each do |player|
        personal_creds = (player.victory_points - player.alliance_vps) +
          (player.alliance_vps / 2)
        player.creds += personal_creds + alliance_vps_per_player
        player.save!
        Notification.create_for_vps_to_creds_conversion(
          player.id, personal_creds, total_alliance_vps, alliance_vps_per_player
        )
      end
    end
    
    players.where(:alliance_id => nil).find_each do |player|
      player.creds += player.victory_points
      player.save!
      Notification.create_for_vps_to_creds_conversion(
        player.id, player.victory_points, nil, nil
      )
    end
  end

  # Spawns convoy traveling from one random wormhole to other.
  def spawn_convoy!
    total = solar_systems.wormhole.count
    return if total < 2

    CONFIG.with_set_scope(ruleset) do
      source = target = nil
      while source == target
        coords = (0...2).map do
          row = solar_systems.wormhole.select("x, y").
            limit("#{rand(total)}, 1").c_select_one

          GalaxyPoint.new(id, row["x"], row["y"])
        end

        source, target = coords
      end

      # Create units.
      transaction do
        units = UnitBuilder.from_random_ranges(
          Cfg.galaxy_convoy_units_definition, id, source, nil
        )
        Unit.save_all_units(units, nil, EventBroker::CREATED)
        route = UnitMover.move(nil, units.map(&:id), source, target, false,
          CONFIG['galaxy.convoy.speed_modifier'])

        units.each do |unit|
          CallbackManager.register(unit, CallbackManager::EVENT_DESTROY,
            route.arrives_at)
        end

        route
      end
    end
  end

  def create_player(web_user_id, name)
    # To expand * speed things
    CONFIG.with_set_scope(ruleset) do
      SpaceMule.instance.create_players(id, ruleset, {web_user_id => name})
    end
  end

  # Return solar system with coordinates x, y.
  def by_coords(x, y)
    solar_systems.find(:first, :conditions => {:x => x, :y => y})
  end

  def as_json(options=nil)
    attributes
  end

  private
end