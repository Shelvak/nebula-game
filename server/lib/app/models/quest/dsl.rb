# Class for DSL used in Quest#define.
class Quest::DSL
  def id; @quest_id; end

  def initialize(parent_id, quest_id, help_url_id)
    @quest_id = quest_id
    @parent_id = parent_id
    @help_url_id = help_url_id
    @rewards = Rewards.new
    @objectives = []
  end

  def to_s
    "<Quest::DSL id=#{@quest_id} parent=#{@parent_id} help_url=#{
      @help_url_id}>"
  end

  # Saves quest with it's objectives and returns Quest.
  def save!
    quest = Quest.new(:parent_id => @parent_id,
      :help_url_id => @help_url_id, :rewards => @rewards)
    quest.id = @quest_id
    quest.save!

    @objectives.each do |klass, options|
      objective = klass.new(options)
      objective.quest = quest
      objective.save!
    end

    quest
  end

  # Reward numeric property.
  #
  # Usage: reward_metal(100)
  #
  [
    Rewards::METAL, Rewards::ENERGY, Rewards::ZETIUM,
    Rewards::POINTS, Rewards::XP, Rewards::SCIENTISTS
  ].each do |reward|
    define_method("reward_#{reward}") do |number|
      @rewards.send("add_#{reward}", number)
    end
  end

  # Reward cost to build _klass.
  #
  # Usage: reward_cost(Building::CollectorT1, :count => 1.2)
  #
  # Default options:
  # * :count - 1
  # * :level - 1
  #
  def reward_cost(klass, options)
    options.reverse_merge!(:count => 1, :level => 1)

    metal_cost = klass.metal_cost(options[:level])
    energy_cost = klass.energy_cost(options[:level])
    zetium_cost = klass.zetium_cost(options[:level])

    reward_metal metal_cost * options[:count] if metal_cost > 0
    reward_energy energy_cost * options[:count] if energy_cost > 0
    reward_zetium zetium_cost * options[:count] if zetium_cost > 0
  end

  # Rewards resources for given amount of points.
  def reward_resources_for_points(points)
    reward = (points / 3 * 0.03).ceil
    metal = (Resources.volume_to_metal(reward) * 2).round
    energy = (Resources.volume_to_energy(reward) * 2).round
    zetium = (Resources.volume_to_zetium(reward) * 0.7).round
#    puts "#{points} -> #{metal}, #{energy}, #{zetium}"
    
    reward_metal metal
    reward_energy energy
    reward_zetium zetium
  end

  # Rewards units for points
  def reward_units_for_points(points, unit_list)
    points_left = (points * 0.07).round
    units = {}
    can_exit = false
    until can_exit
      reduced = false
      unit_list.each do |klass, count, level|
        level ||= 1
        count.times do
          key = [klass, level]

          points_required = Resources.total_volume(
            klass.metal_cost(level),
            klass.energy_cost(level),
            klass.zetium_cost(level)
          )

          if points_left >= points_required
            units[key] ||= 0
            units[key] += 1
            points_left -= points_required
            reduced = true
          end
        end
      end

      can_exit = true unless reduced
    end

#    puts "units for points #{points}"
    units.each do |key, count|
      klass, level = key
#      puts "#{klass.to_s} (#{level}) * #{count}"
      reward_unit klass, :count => count, :level => level
    end
  end

  # Define a unit for rewards.
  #
  # Usage: reward_unit Unit::Trooper, :level => 3, :count => 2. :hp => 80
  #
  # :level and :count defaults to 1 and can be ommited.
  # :hp defaults to 100 and can be ommited.
  #
  def reward_unit(klass, options={})
    @rewards.add_unit(klass, options)
  end

  # Explore tile object.
  #
  # Usage: explore_object Tile::FOLLIAGE_3X3, :count => 10
  #
  # :count defaults to 1
  def explore_object(tile_kind, options={})
    width, height = Tile::BLOCK_SIZES[tile_kind]
    min_area = width * height

    options.reverse_merge!(:count => 1)

    @objectives.push([
      Objective::ExploreBlock,
      {:key => Objective::ExploreBlock::KEY, :count => options[:count],
        :limit => min_area}
    ])
  end

  PLANET_KEY = SsObject::Planet.to_s

  # Annex a planet.
  #
  # Options:
  # - :npc => true or false - should that planet be owned by NPC?
  # - :count => Fixnum - number of planets required.
  #
  def annex_planet(options={})
    options.assert_valid_keys(:npc, :count)

    options.reverse_merge! :npc => true, :count => 1
    @objectives.push([
      Objective::AnnexPlanet,
      {:key => PLANET_KEY, :count => options[:count],
        :npc => options[:npc]}
    ])
  end

  # Have a number of planets.
  #
  # Options:
  # - :count => Fixnum, default 1.
  def have_planets(options={})
    options.assert_valid_keys(:count)

    options.reverse_merge! :count => 1
    @objectives.push([
      Objective::HavePlanets,
      {:key => "Planet", :count => options[:count]}
    ])
  end

  PLAYER_KEY = Player.to_s

  # Player should have some _number_ of points.
  Player::OBJECTIVE_ATTRIBUTES.each do |attr|
    klass = "Objective::Have#{attr.camelcase}".constantize

    define_method("have_#{attr}") do |number|
      @objectives.push([
        klass,
        {:key => PLAYER_KEY, :count => 1, :limit => number}
      ])
    end
  end

  def upgrade_to(klass, options={})
    define_objective(Objective::UpgradeTo, klass, options)
  end

  def have_upgraded_to(klass, options={})
    define_objective(Objective::HaveUpgradedTo, klass, options)
  end

  def destroy(klass, options={})
    define_objective(Objective::Destroy, klass, options)
  end

  def destroy_npc_building(klass, options={})
    define_objective(Objective::DestroyNpcBuilding, klass, options)
  end

  def define_objective(objective_klass, klass, options)
    options.assert_valid_keys(:level, :count)

    options.reverse_merge! :level => 1, :count => 1
    @objectives.push([
      objective_klass,
      {:key => klass.to_s, :level => options[:level],
        :count => options[:count]}
    ])
  end
end