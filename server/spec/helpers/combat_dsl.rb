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
      (options[:count] || 1).times do
        building = Factory.build!("b_#{name}", :planet => @planet,
          :level => (options[:level] || 1))
        building.hp = (
          building.hit_points * ((options[:hp] || 100).to_f / 100)
        ).to_i
        building.save!

        @buildings.push building
      end
    end
  end

  class LocationContainer
    attr_reader :location

    def read_buildings; @buildings; end

    def initialize(type, &block)
      @type = type
      case type
      when :planet
        @buildings = []
        @location = Factory.create(:planet)
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

    def initialize(player, location, &block)
      @player = player
      @location = location
      @units = []
      instance_eval(&block)
    end

    def method_missing(name, *args, &block)
      options = args.last || {}
      (options[:count] || 1).times do
        unit = Factory.build!("u_#{name}", :location => @location,
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
          transporter_container = self.class.new(@player, unit, &block)
          unit.stored = transporter_container.units.inject(0) do 
            |sum, transported_unit|
            sum + transported_unit.volume
          end

          # Update stored volume
          unit.save!
        end


        @units.push unit
      end
    end
  end

  class PlayerContainer
    attr_reader :player

    def read_units; @units; end

    def initialize(alliance, location, &block)
      @player = Factory.create(:player, :alliance => alliance)
      @location = location

      instance_eval(&block) if block
    end

    protected
    def units(&block)
      @units = UnitsContainer.new(@player, @location, &block)
    end
  end

  class AllianceContainer
    attr_reader :alliance, :players

    def initialize(dsl, &block)
      @dsl = dsl
      @players = []
      @alliance = Factory.create(:alliance)
      instance_eval(&block)
    end

    protected
    def player(options={}, &block)
      location = @dsl.location_container.location
      player = PlayerContainer.new(@alliance, location, &block)
      @dsl.set_planet_owner(player) if options[:planet_owner]

      @players.push player
    end
  end

  def location_container; @location; end

  def initialize(&block)
    @alliances = []
    @players = []
    instance_eval(&block)
  end

  def create
    alliances = self.alliances
    nap_rules = Nap.get_rules(alliances.keys.reject { |id| id < 1 })
    Combat.new(
      location_container.location,
      alliances,
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

    units
  end

  def players
    player_containers.map(&:player)
  end

  def alliances
    ids = players.map(&:id)
    ::Player.grouped_by_alliance(ids)
  end

  protected
  def player_containers
    @alliances.map { |alliance| alliance.players }.flatten + @players
  end

  def location(type, &block)
    @location = LocationContainer.new(type, &block)
  end

  def alliance(&block)
    alliance = AllianceContainer.new(self, &block)
    @alliances.push alliance
    alliance
  end

  def player(options={}, &block)
    player = PlayerContainer.new(nil, @location.location, &block)
    set_planet_owner(player) if options[:planet_owner]

    @players.push player
    player
  end

  def nap(initiator, acceptor)
    Factory.create(:nap, :initiator => initiator.alliance,
      :acceptor => acceptor.alliance)
  end
end

def new_combat(&block); CombatDsl.new(&block).create; end