class Technology::Alliances < Technology
  def max_players; self.class.max_players(level); end

  # Maximum number of players allowed in this alliance.
  def self.max_players(level)
    evalproperty('max_players', nil, 'level' => level).to_i
  end

  # Returns which technology level you need to be able to have _count_ players
  # in your alliance.
  def self.required_level_for_player_count(count)
    1.upto(max_level) do |level|
      return level if max_players(level) >= count
    end
  end
end
