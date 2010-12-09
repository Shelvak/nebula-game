# Class for DSL used in Quest#define.
class Quest::DSL
  attr_reader :parent, :help_url_id, :rewards

  def initialize(parent, help_url_id)
    @parent = parent
    @help_url_id = help_url_id
    @rewards = Rewards.new
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
  [Rewards::METAL, Rewards::ENERGY, Rewards::ZETIUM,
      Rewards::POINTS, Rewards::XP].each do |reward|
    define_method("reward_#{reward}") do |number|
      @rewards.send("add_#{reward}", number)
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

  PLANET_KEY ="SsObject::Planet"

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