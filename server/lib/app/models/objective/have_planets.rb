class Objective::HavePlanets < Objective
  # Calculate how much of the objective is completed for the player.
  # Alliance objectives also count.
  def initial_completed(player_id)
    player_ids = alliance? \
      ? Player.find(player_id).friendly_ids \
      : player_id

    Player.where(:id => player_ids).sum(:planets_count)
  end

  def filter(models)
    battleground_id = Galaxy.battleground_id(
      models[0].solar_system.galaxy_id)
    models.reject { |p| p.solar_system_id == battleground_id }
  end

  def self.count_benefits(models)
    benefits = {}

    models.each do |planet|
      old_id, new_id = planet.player_id_change
      benefits[old_id] = (benefits[old_id] || 0) - 1 unless old_id.nil?
      benefits[new_id] = (benefits[new_id] || 0) + 1 unless new_id.nil?
    end

    benefits
  end
end