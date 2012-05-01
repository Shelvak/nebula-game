class Objective::DestroyNpcBuilding < Objective
  # Override to store beneficiary which is later retrieved by
  # #count_benefits.
  def self.progress(npc_building, player)
    super([npc_building], {player_id: player.id})
  end

  # Override to return stored beneficiary which was passed to #progress.
  def self.count_benefits(models, options)
    [[options[:player_id], 1]]
  end
end