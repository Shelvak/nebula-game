class Technology::BuildingRepair < Technology
  include Parts::Healing

  # Get active building repair technology for player. Raise +GameLogicError+ if
  # no such technology can be found.
  def self.get!(player_id)
    typesig binding, Fixnum

    technology = where("level > 0 AND player_id=?", player_id).first

    raise GameLogicError.new(
      "Player #{player_id} does not have building repair technology!"
    ) if technology.nil?

    technology
  end
end