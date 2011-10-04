class CombatDsl
  class BuildingsContainer
    attr_reader :buildings

    def initialize(planet, &block)
      @planet = planet
      @buildings = []
      instance_eval(&block)
    end

    def method_missing(name, *args)
      options = args.last || {}
      factory_options = options.except(:count, :level, :hp)
      (options[:count] || 1).times do
        building = Factory.build!(
          "b_#{name}", 
          {:planet => @planet, :level => (options[:level] || 1)}.
            merge(factory_options)
        )
        building.hp = (
          building.hit_points * ((options[:hp] || 100).to_f / 100)
        ).to_i
        building.save!

        @buildings.push building
      end
    end
  end

  class LocationContainer
    attr_reader :location, :galaxy_id

    def read_buildings; Set.new(@buildings); end

    def initialize(type, options, &block)
      @type = type
      @buildings = []
      case type
      when :planet
        @location = Factory.create(:planet, options)
        @galaxy_id = @location.solar_system.galaxy_id
      when :solar_system
        ss = Factory.create(:solar_system, options)
        @location = SolarSystemPoint.new(ss.id, 0, 0)
        @galaxy_id = @location.galaxy_id
      when :galaxy
        galaxy = Factory.create(:galaxy, options)
        @location = GalaxyPoint.new(galaxy.id, 0, 0)
        @galaxy_id = @location.id
      else
        raise ArgumentError.new("Don't know how to build location #{type}")
      end

      instance_eval(&block) unless block.nil?
    end

    def buildings(&block)
      raise ArgumentError.new("Cannot create buildings for type #{@type}") \
        unless @type == :planet

      @buildings = BuildingsContainer.new(@location, &block).buildings
    end
  end

  class UnitsContainer
    attr_reader :units

    def initialize(player, location, galaxy_id, &block)
      @player = player
      @location = location
      @galaxy_id = galaxy_id
      @units = []
      instance_eval(&block)
    end

    def method_missing(name, *args, &block)
      options = args.last || {}
      units = []
      (options[:count] || 1).times do
        unit = Factory.build!("u_#{name}", :location => @location,
          :galaxy_id => @galaxy_id,
          :level => (options[:level] || 1),
          :flank => (options[:level] || 0),
          :player => @player
        )
        unit.hp = (
          unit.hit_points * ((options[:hp] || 100).to_f / 100)
        ).to_i
        unit.save!

        # Add transported units
        if block
          transporter_container = self.class.new(@player, unit, @galaxy_id,
            &block)
          unit.stored = transporter_container.units.inject(0) do 
            |sum, transported_unit|
            sum + transported_unit.volume
          end

          # Update stored volume
          unit.save!
        end


        @units.push unit
        units.push unit
      end
      
      units.size == 1 ? units[0] : units
    end
  end

  class PlayerContainer
    attr_reader :player

    def read_units; @units; end

    def initialize(alliance, location_container, options, &block)
      options.reverse_merge! :alliance => alliance
      if options[:npc]
        @player = nil
      else
        @player = Factory.create(:player, options)
      end
      @location_container = location_container

      instance_eval(&block) if block
    end

    protected
    def units(&block)
      @units = UnitsContainer.new(@player, @location_container.location,
        @location_container.galaxy_id, &block)
    end
  end

  class AllianceContainer
    attr_reader :alliance, :players

    def initialize(dsl, options, &block)
      @dsl = dsl
      @players = []
      @alliance = Factory.create(:alliance, options)
      instance_eval(&block)
    end

    protected
    def player(options={}, &block)
      planet_owner = options.delete :planet_owner
      player = PlayerContainer.new(@alliance, @dsl.location_container,
        options, &block)
      @dsl.set_planet_owner(player) if planet_owner

      @players.push player
    end
  end

  def location_container; @location; end

  def initialize(&block)
    @alliances = []
    @players = []
    instance_eval(&block)
  end

  def run
    alliances = self.alliances
    nap_rules = Nap.get_rules(alliances.keys.reject { |id| id < 1 })
    Combat.run(
      location_container.location,
      players,
      nap_rules,
      units,
      location_container.read_buildings
    )
  end

  def set_planet_owner(player_container)
    location = @location.location
    location.player = player_container.player
    location.save!
  end

  def units
    units = []

    player_containers.each do |player_container|
      units_container = player_container.read_units
      units += units_container.units if units_container
    end

    Set.new(units)
  end

  def players
    location = @location.location
    players = Set.new(player_containers.accept do |player_container|
      # Only include player if he has any units or is a planet owner.
      has_units = (player_container.read_units.try(:units).try(:size) || 0) > 0
      if location.is_a?(SsObject::Planet)
        planet_owner = player_container.player == location.player
      else
        planet_owner = false
      end
      has_units || planet_owner
    end.map(&:player))
    players.add(nil) \
      if location.is_a?(SsObject::Planet) && location.player_id.nil?

    players
  end

  def alliances
    ids = players.map { |player| player.nil? ? nil : player.id }
    ::Player.grouped_by_alliance(ids)
  end

  protected
  def player_containers
    @alliances.map { |alliance| alliance.players }.flatten + @players
  end

  def location(type, options={}, &block)
    @location = LocationContainer.new(type, options, &block)
  end

  def alliance(options={}, &block)
    alliance = AllianceContainer.new(self, options, &block)
    @alliances.push alliance
    alliance
  end

  def player(options={}, &block)
    planet_owner = options.delete :planet_owner
    player = PlayerContainer.new(nil, @location, options, &block)
    set_planet_owner(player) if planet_owner

    @players.push player
    player
  end

  def nap(initiator, acceptor)
    Factory.create(:nap, :initiator => initiator.alliance,
      :acceptor => acceptor.alliance)
  end
end