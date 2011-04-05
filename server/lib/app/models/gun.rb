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

  def ground?; @reach == :ground || @reach == :both; end
  def space?; @reach == :space || @reach == :both; end

  # Returns _damage_ if unit has shot and false if it's on cooldown.
  #
  # Also decreases unit cooldown.
  #
  def shoot(participant, technologies_damage_mod, technologies_armor_mod)
    return false if cooling_down?

    @cooldown += period - 1
    dmg_percent = CONFIG.damage(@damage, participant.armor) * (
      1 + technologies_damage_mod.to_f / 100
    ) * owner.stance_property('damage')
    armor_percent = (1 + technologies_armor_mod.to_f / 100) *
      (1 + participant.armor_mod.to_f / 100) *
      participant.stance_property('armor')

    damage = (@dpt.to_f * dmg_percent / armor_percent).round

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