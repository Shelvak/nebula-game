# Same as Objective::UpgradeTo but calculates already built objects.
#
# Actual calculation logic is in ObjectiveProgress.
class Objective::HaveUpgradedTo < Objective::UpgradeTo
  # Calculate how much of the objective is completed for the player.
  # Alliance objectives also count.
  def initial_completed(player_id)
    base = key.split("::")[0]
    finder = key.constantize.where(["`level` >= ?", level]).
      lock("LOCK IN SHARE MODE")
    player_ids = alliance? \
      ? Player.find(player_id).friendly_ids \
      : player_id

    case base
    when "Building"
      finder = finder.joins(:planet).where(
        "#{SsObject::Planet.table_name}.player_id" => player_ids
      )
    when "Unit", "Technology"
      finder = finder.where(:player_id => player_ids)
    else
      raise ArgumentError.new("Don't know how to handle #{key}!")
    end

    without_locking { finder.count }
  end
end
