# Various helpers for randomness.
module Random
  # Return boolean value based on integer _chance_.
  def self.chance(chance)
    rand(100) + 1 <= chance
  end
end
