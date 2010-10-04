class Objective::AnnexPlanet < Objective
  # Only keep models which match the npc flag.
  def filter(models)
    super(models).reject do |model|
      old_player_id = model.player_id_change[0]
      npc? ? ! old_player_id.nil? : old_player_id.nil?
    end
  end

  def self.resolve_key(klass)
    super(klass).split("::")[0]
  end
end