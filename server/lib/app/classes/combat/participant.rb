# Various helpers for combat participants.
class Combat::Participant
  # Regular +Unit+ on the battlefield.
  KIND_UNIT = 0
  # +Building+ that has guns and should be in the battlefield.
  KIND_BUILDING_SHOOTING = 1
  # +Building+ that doesn't have any guns and should only be in the
  # background.
  KIND_BUILDING_PASSIVE = 2

  # Returns +Hash+: {:id => +Fixnum+, :player_id => +Fixnum+,
  # :type => +String+, :kind => #kind, :hp => +Fixnum+, :level => +Fixnum+,
  # :stance => +Fixnum+}.
  def self.as_json(unit)
    # TODO: look if all these properties are used.
    {
      :id => unit.id,
      :player_id => unit.player_id,
      :type => unit.type,
      :kind => kind(unit),
      :hp => unit.hp,
      :level => unit.level,
      :stance => unit.stance
    }
  end

  # Return [id, kind] pair for _unit_. _kind_ is resolved via #kind.
  def self.pair(unit)
    [unit.id, kind(unit)]
  end

  # Given _unit_ resolves it to client side kind.
  def self.kind(unit)
    case unit
    when ::Unit
      KIND_UNIT
    when Building
      if unit.guns.blank?
        KIND_BUILDING_PASSIVE
      else
        KIND_BUILDING_SHOOTING
      end
    end
  end
end
