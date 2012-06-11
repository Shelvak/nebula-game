class Objective::HealHp < Objective
  KEY = ""
  def self.resolve_key(klass); KEY; end

  def self.progress(player, hp_healed)
    super([player], {data: hp_healed})
  end

  def self.count_benefits(players, options)
    player = players[0]
    {player.id => options[:data]}
  end
end