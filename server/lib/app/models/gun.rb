# Class that represents a gun that unit or building has.
class Gun
  attr_reader :owner, :period, :damage, :reach, :index

  def initialize(owner, data, index)
    @owner = owner
    @index = index

    @cooldown = 0
    @type = data['type']
    @period = data['period'].to_i

    @dpt = GameConfig.safe_eval(data['dpt'], 'level' => owner.level).to_f
    @damage = data['damage'].to_sym
    @reach = data['reach'].to_sym
  end

  def to_s
    "<Gun:#{@type} dpt=#{@dpt} damage=#{@damage} reach=#{@reach
      } period=#{@period
      } cooldown=#{@cooldown}>"
  end

  def ground?; @reach == :ground; end
  def space?; @reach == :space; end
  def both?; @reach == :both; end

  # Returns _damage_ if unit has shot and false if it's on cooldown.
  #
  # Also decreases unit cooldown.
  #
  def shoot(participant)
    return false if cooling_down?

    @cooldown += period - 1
    damage = (
      (@dpt * CONFIG.damage(@damage, participant.armor)) *
      owner.stance_property('damage') *
      (2.0 - participant.stance_property('armor')) *
      (100.0 - participant.armor_mod) / 100
    ).round

    # Don't allow 0 damage, and more damage than HP.
    if damage > participant.hp
      damage = participant.hp
    elsif damage < 1
      damage = 1
    end
    participant.hp -= damage

    damage
  end
  
  def cool_down
    @cooldown -= 1
  end

  def cooling_down?
    @cooldown > 0
  end
end