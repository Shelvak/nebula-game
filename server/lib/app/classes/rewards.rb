# For storing reward values.
class Rewards
  METAL = 'metal'
  ENERGY = 'energy'
  ZETIUM = 'zetium'
  XP = 'xp'
  POINTS = 'points'
  CREDS = 'creds'
  SCIENTISTS = 'scientists'
  UNITS = 'units'

  # Rewards assigned to +SsObject::Planet+
  REWARD_RESOURCES = [
    [:metal, METAL],
    [:energy, ENERGY],
    [:zetium, ZETIUM],
  ]
  # Known resource types
  KNOWN_RESOURCES = [METAL, ENERGY, ZETIUM]

  # Rewards assigned to +Player+
  REWARD_PLAYER = [
    [:xp, XP],
    [:economy_points, POINTS],
    [[:creds, :free_creds], CREDS],
    [[:scientists, :scientists_total], SCIENTISTS]
  ]

  def initialize(data={})
    @data = data
  end

  def self.from_json(json); new(JSON.parse(json)); end

  def as_json(options=nil); @data; end
  
  def eql?(other)
    other.is_a?(self.class) && other.as_json == as_json
  end

  def ==(other)
    other.is_a?(self.class) && as_json == other.as_json
  end

  # Creates +Rewards+ object from _exploration_config_ which is defines in
  # tiles exploration configuration.
  def self.from_exploration(exploration_config)
    rewards = new

    exploration_config.each do |item|
      case item['kind']
      when METAL, ENERGY, ZETIUM, POINTS, XP, CREDS
        rewards.send "add_#{item['kind']}", item['count']
      when UNITS
        klass = "Unit::#{item['type'].camelcase}".constantize
        options = item.except('type', 'kind').symbolize_keys
        rewards.add_unit(klass, options)
      else
        raise ArgumentError.new(
          "Unknown kind #{item['kind']} for #{item.inspect}!")
      end
    end

    rewards
  end

  def [](key); @data[key]; end

  [METAL, ENERGY, ZETIUM, XP, POINTS, SCIENTISTS, CREDS].each do |reward|
    define_method(reward) do |value|
      @data[reward]
    end
    define_method("#{reward}=") do |value|
      @data[reward] = value
    end
    define_method("add_#{reward}") do |value|
      @data[reward] ||= 0
      @data[reward] += value
    end
  end

  def units
    @data[UNITS]
  end

  # Define a unit for rewards.
  #
  # Usage: add_unit Unit::Trooper, :level => 3, :count => 2. :hp => 80
  #
  # :level and :count defaults to 1 and can be ommited.
  # :hp defaults to 100 and can be ommited.
  #
  def add_unit(klass, options)
    raise "#{klass} must be Unit!" unless klass.superclass == Unit
    options.assert_valid_keys(:level, :count, :hp)

    @data[UNITS] ||= []
    @data[UNITS].push(
      'type' => klass.to_s.demodulize,
      'level' => options[:level] || 1,
      'count' => options[:count] || 1,
      'hp' => options[:hp] || 100
    )
  end

  def claim!(planet, player, allow_overpopulation=false)
    if @data[UNITS] && @data[UNITS].size > 0
      raise GameLogicError.new(
        "Cannot give units if player is overpopulated!"
      ) if ! allow_overpopulation && player.overpopulated?
      
      units = []

      @data[UNITS].each do |specification|
        klass = "Unit::#{specification['type']}".constantize
        specification['count'].times do
          units << klass.new(
            :level => specification['level'],
            :hp_percentage => specification['hp'].to_f / 100,
            :player => player,
            :galaxy_id => player.galaxy_id
          )
        end
      end
      
      Unit.give_units_raw(units, planet, player)
    end
    
    increase_values(planet, REWARD_RESOURCES)
    increase_values(player, REWARD_PLAYER)
  end

  private
  # Increase values for different reward types on object.
  def increase_values(object, types)
    changed = false
    types.each do |attributes, reward|
      value = @data[reward]
      if value
        [attributes].flatten.each do |attribute|
          object.send("#{attribute}=", object.send(attribute) + value)
        end
        changed = true
      end
    end

    if changed
      object.save!
      # We need some special treatment for this baby
      EventBroker.fire(object, EventBroker::CHANGED,
        EventBroker::REASON_OWNER_PROP_CHANGE
      ) if object.is_a?(SsObject::Planet)
    end
  end
end
