# Class for DSL used in Quest#define.
class Quest::DSL
  def id; @quest_id; end

  def initialize(parent_id, quest_id, main_quest_slides, achievement)
    @quest_id = quest_id
    @parent_id = parent_id
    @main_quest_slides = main_quest_slides
    @achievement = achievement
    @rewards = Rewards.new
    @objectives = []
  end

  def to_s
    "<Quest::DSL id=#{@quest_id} parent=#{@parent_id} main_quest_slides=#{
      @main_quest_slides.inspect} achievement=#{@achievement}>"
  end

  # Saves quest with it's objectives and returns Quest.
  def save!
    quest = Quest.new(
      :parent_id => @parent_id,
      :main_quest_slides => @main_quest_slides.nil? \
        ? nil : @main_quest_slides.join(","),
      :rewards => @achievement ? nil : @rewards,
      :achievement => @achievement
    )
    quest.id = @quest_id
    quest.save!

    @objectives.each do |klass, options|
      objective = klass.new(options)
      objective.quest = quest
      objective.save!
    end

    quest
  end
  
  def check
    errors = []
    
    quest = Quest.where(:id => @quest_id).first
    if quest.nil?
      errors.push "Not found!"
      return errors
    end
    
    errors.push "Parent id should have been #{@parent_id} but was #{
      quest.parent_id}" unless @parent_id == quest.parent_id
    rewards = @rewards.blank? ? nil : @rewards
    errors.push "Expected rewards:\n#{@rewards
      }\n\nActual rewards:\n#{quest.rewards}" \
      unless rewards == quest.rewards
    errors.push "Expected achievement to be #{@achievement}, but it was #{
      quest.achievement}" unless @achievement == quest.achievement
    expected = @main_quest_slides.nil? \
      ? nil \
      : @main_quest_slides.join(",")
    errors.push "Expected main_quest_slides to be #{expected}, but it was #{
      quest.main_quest_slides}" unless expected == quest.main_quest_slides
    
    defined_objectives = @objectives.dup
    quest.objectives.all.reject do |objective|
      index = defined_objectives.index do |klass, options|
        objective.is_a?(klass) && options.map do |key, value|
          objective.send(key) == value
        end.uniq == [true]
      end
      
      if index
        defined_objectives.delete_at(index)
      else
        errors.push "Objective #{objective
          } was not defined but found in DB!"
      end
    end
    
    unless defined_objectives.blank?
      defined_objectives.each do |klass, options|
        errors.push "Objective #{klass.to_s.demodulize} with options " +
          (options.map { |k, v| "#{k}: #{v.inspect}"}.join(", ")) +
          " was defined, but not found in DB!"
      end
    end
    
    errors
  end

  # Reward numeric property.
  #
  # Usage: reward_metal(100)
  #
  [
    Rewards::METAL, Rewards::ENERGY, Rewards::ZETIUM,
    Rewards::POINTS, Rewards::XP, Rewards::SCIENTISTS, Rewards::CREDS
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
  def reward_cost(klass, options={})
    options.reverse_merge!(:count => 1, :level => 1)

    metal_cost = klass.metal_cost(options[:level])
    energy_cost = klass.energy_cost(options[:level])
    zetium_cost = klass.zetium_cost(options[:level])

    reward_metal metal_cost * options[:count] if metal_cost > 0
    reward_energy energy_cost * options[:count] if energy_cost > 0
    reward_zetium zetium_cost * options[:count] if zetium_cost > 0
  end

  # Rewards resources for given amount of points.
  def reward_resources_for_points(points, multiplier=nil)
    multiplier ||= 0.03

    reward = (points * multiplier).ceil
    metal = (Resources.volume_to_metal(reward) * 2).round
    energy = (Resources.volume_to_energy(reward) * 2).round
    zetium = (Resources.volume_to_zetium(reward) * 0.7).round
    #puts "#{points} -> #{metal} m, #{energy} e, #{zetium} z"
    
    reward_metal metal
    reward_energy energy
    reward_zetium zetium
  end

  # Rewards creds for given amount of points.
  def reward_creds_for_points(points, multiplier=nil)
    multiplier ||= 0.5
    creds = (Math.log10(points) ** 5 * multiplier).round
    #puts "#{points} -> #{creds} creds"

    reward_creds creds
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

  # Explore any tile object without area limit.
  #
  # Usage: explore_any_object :count => 10
  #
  # :count defaults to 1
  def explore_any_object(options={})
    options.reverse_merge!(:count => 1)

    @objectives.push([
      Objective::ExploreBlock,
      {:key => Objective::ExploreBlock::KEY, :count => options[:count]}
    ])
  end

  # Become a VIP player a number of times.
  #
  # Usage: become_vip :count => 10, :level => 1
  #
  # :count and :level defaults to 1
  #
  # :level specifies level AT LEAST needed to qualify for this objective.
  #
  def become_vip(options={})
    options.reverse_merge!(:count => 1, :level => 1)

    @objectives.push([
      Objective::BecomeVip,
      {:key => Objective::BecomeVip::KEY, :count => options[:count],
        :level => options[:level]
      }
    ])
  end

  # Accelerate something with credits.
  #
  # Usage: accelerate Building, :count => 10
  #
  # :count defaults to 1
  def accelerate(klass, options={})
    options.reverse_merge!(:count => 1)

    @objectives.push([
      Objective::Accelerate,
      {:key => klass.to_s, :count => options[:count]}
    ])
  end

  def be_in_alliance
    @objectives.push([
      Objective::BeInAlliance,
      {:key => Objective::BeInAlliance::KEY}
    ])
  end

  # Complete a number of quests.
  #
  # Usage: complete_quests :count => 10
  #
  # :count defaults to 1
  def complete_quests(options={})
    options.reverse_merge!(:count => 1)

    @objectives.push([
      Objective::CompleteQuests,
      {:key => Objective::CompleteQuests::KEY, :count => options[:count]}
    ])
  end

  # Complete a number of achievements.
  #
  # Usage: complete_achievements :count => 10
  #
  # :count defaults to 1
  def complete_achievements(options={})
    options.reverse_merge!(:count => 1)

    @objectives.push([
      Objective::CompleteAchievements,
      {:key => Objective::CompleteAchievements::KEY,
        :count => options[:count]}
    ])
  end

  # Battle an enemy with _outcome_.
  #
  # Usage: battle Combat::OUTCOME_WIN, :count => 10
  #
  # :count defaults to 1
  #
  def battle(outcome, options)
    options.reverse_merge!(:count => 1)

    @objectives.push([
      Objective::Battle,
      {:key => Objective::Battle::KEY, :count => options[:count],
        :outcome => outcome}
    ])
  end

  # Move building.
  #
  # Usage: move_building :count => 10, :key => "Building::Barracks"
  #
  # :count defaults to 1
  # :key defaults to "Building"
  #
  def move_building(options)
    options.reverse_merge!(:count => 1, :key => Building.to_s)

    @objectives.push([
      Objective::MoveBuilding,
      {:key => options[:key], :count => options[:count]}
    ])
  end

  # Self destruct a building.
  #
  # Usage: self_destruct :count => 10, :key => "Building::Barracks"
  #
  # :count defaults to 1
  # :key defaults to "Building"
  #
  def self_destruct(options)
    options.reverse_merge!(:count => 1, :key => Building.to_s)

    @objectives.push([
      Objective::SelfDestruct,
      {:key => options[:key], :count => options[:count]}
    ])
  end

  # Accelerate flight.
  #
  # Usage: accelerate_flight :count => 10
  #
  # :count defaults to 1
  #
  def accelerate_flight(options)
    options.reverse_merge!(:count => 1)

    @objectives.push([
      Objective::AccelerateFlight,
      {:key => Objective::AccelerateFlight::KEY, :count => options[:count]}
    ])
  end

  # Heal N HP of units.
  #
  # Usage: heal_hp 10
  #
  def heal_hp(count)
    @objectives.push([
      Objective::HealHp,
      {:key => Objective::HealHp::KEY, :count => count}
    ])
  end

  # Repair N HP of buildings.
  #
  # Usage: repair_hp 10
  #
  def repair_hp(count)
    @objectives.push([
      Objective::RepairHp,
      {:key => Objective::RepairHp::KEY, :count => count}
    ])
  end

  PLANET_KEY = SsObject::Planet.to_s

  # Annex a planet.
  #
  # Options:
  # - :count => Fixnum - number of planets required.
  #
  def annex_planet(options={})
    options.assert_valid_keys(:count)

    options.reverse_merge! :count => 1
    @objectives.push([
      Objective::AnnexPlanet,
      {:key => PLANET_KEY, :count => options[:count], :npc => true}
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
      {:key => PLANET_KEY, :count => options[:count]}
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