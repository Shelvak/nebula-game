# Array with additional information obtained from +Combat+.
class CombatArray < Array
  # Hash of {unit/building => player_id} pairs.
  attr_reader :killed_by

  def initialize(source, killed_by)
    super(source)
    @killed_by = killed_by
  end

  def eql?(other)
    other.is_a?(self.class) && super.eql?(other) &&
      @killed_by == other.killed_by
  end

  def to_s
    "CombatArray(killed_by: #{@killed_by.try(:size) || "nil"}, size: #{size})"
  end

  def inspect
    "CombatArray(killed_by: #{@killed_by.inspect})#{super}"
  end
end