class Building::ResearchCenter < Building
  def scientists(for_level=nil)
    evalproperty('scientists', nil, 'level' => for_level || level)
  end

  def on_activation
    super
    count = scientists
    player = planet.player
    player.scientists += count
    player.scientists_total += count
    player.save!
  end

  def on_deactivation
    super
    count = scientists
    player = planet.player
    player.ensure_free_scientists!(count)
    player.scientists -= count
    player.scientists_total -= count
    player.save!
  end
end