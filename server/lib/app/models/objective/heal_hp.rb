class Objective::HealHp < Objective
  KEY = ""
  def self.resolve_key(klass); KEY; end

  def self.progress(player, hp_healed)
    @hp_healed = hp_healed
    super([player])
  end

  def self.count_benefits(players)
    player = players[0]
    {player.id => @hp_healed}
  end
end