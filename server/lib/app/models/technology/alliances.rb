class Technology::Alliances < Technology
  def max_players; self.class.max_players(level); end

  # Maximum number of players allowed in this alliance.
  def self.max_players(level)
    evalproperty('max_players', nil, 'level' => level)
  end
end