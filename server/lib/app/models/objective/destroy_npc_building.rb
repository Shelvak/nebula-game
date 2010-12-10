class Objective::DestroyNpcBuilding < Objective
  # Override to store beneficiary which is later retrieved by
  # #count_benefits.
  def self.progress(npc_building, player)
    @beneficiary = player
    super([npc_building])
  end

  # Override to return stored beneficiary which was passed to #progress.
  def self.count_benefits(models)
    [[@beneficiary.id, 1]]
  end
end