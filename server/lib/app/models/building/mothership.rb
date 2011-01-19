class Building::Mothership < Building
  include Trait::HasScientists

  def self_destruct!
    raise GameLogicError.new(
      "Cannot self-destruct the Mothership! Are you crazy?!"
    )
  end
end