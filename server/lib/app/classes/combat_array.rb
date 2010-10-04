# Array with additional information obtained from +Combat+.
class CombatArray < Array
  # Hash of {unit/building => player_id} pairs.
  attr_reader :killed_by

  def initialize(source, killed_by)
    super(source)
    @killed_by = killed_by
  end
end