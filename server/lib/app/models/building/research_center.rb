class Building::ResearchCenter < Building
  def scientists(level=nil)
    self.class.scientists(level || self.level)
  end

  def self.scientists(level)
    evalproperty('scientists', nil, 'level' => level).round
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