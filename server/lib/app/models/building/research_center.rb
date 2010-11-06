class Building::ResearchCenter < Building
  def scientists(for_level=nil)
    evalproperty('scientists', nil, 'level' => for_level || level)
  end

  def on_activation
    super
    planet.player.change_scientist_count!(scientists)
  end

  def on_deactivation
    super
    planet.player.change_scientist_count!(- scientists)
  end
end