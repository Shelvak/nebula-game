# Class for DSL used in Quest#define.
class Quest::DSL
  attr_reader :parent, :help_url_id, :rewards

  def initialize(parent, help_url_id)
    @parent = parent
    @help_url_id = help_url_id
    @rewards = {}
    @objectives = []
  end

  # Saves quest with it's objectives and returns Quest.
  def save!
    quest = Quest.new(:parent => parent, :help_url_id => help_url_id,
      :rewards => rewards)
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
  [Quest::REWARD_METAL, Quest::REWARD_ENERGY, Quest::REWARD_ZETIUM,
      Quest::REWARD_POINTS, Quest::REWARD_XP].each do |reward|
    define_method("reward_#{reward}") do |number|
      @rewards[reward] ||= 0
      @rewards[reward] += number
    end
  end

  # Define a unit for rewards.
  #
  # Usage: reward_unit Unit::Trooper, :level => 3, :count => 2
  #
  # :level and :count defaults to 1 and can be ommited.
  #
  def reward_unit(klass, options={})
    raise "#{klass} must be Unit!" unless klass.superclass == Unit
    options.assert_valid_keys(:level, :count)

    @rewards[Quest::REWARD_UNITS] ||= []
    @rewards[Quest::REWARD_UNITS].push(
      'type' => klass.to_s.demodulize,
      'level' => options[:level] || 1,
      'count' => options[:count] || 1
    )
  end

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
      {:key => "Planet", :count => options[:count], :npc => options[:npc]}
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

  def upgrade_to(klass, options={})
    define_objective(Objective::UpgradeTo, klass, options)
  end

  def have_upgraded_to(klass, options={})
    define_objective(Objective::HaveUpgradedTo, klass, options)
  end

  def destroy(klass, options={})
    define_objective(Objective::Destroy, klass, options)
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